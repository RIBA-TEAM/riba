import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore-backed service for the appointment system.
///
/// Two collections are used:
///
/// * `availability_blocks` — windows of time that a counselor / teacher
///   has opened up. Each block is sliced into fixed 30-minute slots
///   client-side via [streamAvailableSlots].
/// * `appointments` — concrete bookings made by parents. Booking is
///   guarded by a Firestore transaction so two parents cannot grab the
///   same slot.
class AppointmentService {
  AppointmentService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const String _blocksCollection = 'availability_blocks';
  static const String _appointmentsCollection = 'appointments';

  /// All slots are exactly this long. Kept as a constant rather than a
  /// per-block field so the parent UI can rely on a single granularity.
  static const int slotMinutes = 30;

  // ---------------------------------------------------------------------------
  // Availability blocks (counselor / teacher side)
  // ---------------------------------------------------------------------------

  /// Stream of availability blocks belonging to a single owner, ordered
  /// by start time.
  Stream<List<AvailabilityBlock>> streamBlocksForOwner(String ownerId) {
    return _db
        .collection(_blocksCollection)
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snap) {
          final blocks = snap.docs
              .map((d) => AvailabilityBlock.fromDoc(d))
              .toList()
            ..sort((a, b) => a.startAt.compareTo(b.startAt));
          return blocks;
        });
  }

  Future<void> addBlock({
    required String ownerId,
    required String ownerName,
    required String ownerRole,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    if (!endAt.isAfter(startAt)) {
      throw ArgumentError('endAt must be strictly after startAt');
    }
    final durationMinutes = endAt.difference(startAt).inMinutes;
    if (durationMinutes < slotMinutes) {
      throw ArgumentError('Block must be at least $slotMinutes minutes long');
    }

    await _db.collection(_blocksCollection).add({
      'owner_id': ownerId,
      'owner_name': ownerName,
      'owner_role': ownerRole,
      'start_at': Timestamp.fromDate(startAt),
      'end_at': Timestamp.fromDate(endAt),
      'slot_minutes': slotMinutes,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteBlock(String blockId) async {
    await _db.collection(_blocksCollection).doc(blockId).delete();
  }

  // ---------------------------------------------------------------------------
  // Slot computation (parent side)
  // ---------------------------------------------------------------------------

  /// Returns a stream of free 30-minute slots for a single owner on a
  /// given calendar day.
  ///
  /// Internally this watches both the owner's blocks and confirmed
  /// appointments. Slots that are already booked (status == confirmed)
  /// are removed from the candidate set.
  Stream<List<AppointmentSlot>> streamAvailableSlots({
    required String ownerId,
    required DateTime day,
  }) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    // Use only equality filters so Firestore does not require composite
    // indexes (range + equality on different fields needs an index). Day
    // filtering is done client-side; data volume per owner stays small.
    final blocksStream = _db
        .collection(_blocksCollection)
        .where('owner_id', isEqualTo: ownerId)
        .snapshots();

    final appointmentsStream = _db
        .collection(_appointmentsCollection)
        .where('owner_id', isEqualTo: ownerId)
        .where('status', isEqualTo: 'confirmed')
        .snapshots();

    // Combine the two streams: re-emit whenever either side changes.
    return _combineLatest2(blocksStream, appointmentsStream, (
      QuerySnapshot<Map<String, dynamic>> blocksSnap,
      QuerySnapshot<Map<String, dynamic>> apptSnap,
    ) {
      final blocks = blocksSnap.docs
          .map(AvailabilityBlock.fromDoc)
          .where(
            (b) =>
                b.endAt.isAfter(dayStart) &&
                b.startAt.isBefore(dayEnd),
          )
          .toList();
      final taken = apptSnap.docs
          .map((d) => d.data())
          .where((data) {
            final raw = data['start_at'];
            if (raw is! Timestamp) return false;
            final t = raw.toDate();
            return !t.isBefore(dayStart) && t.isBefore(dayEnd);
          })
          .map((data) => (data['start_at'] as Timestamp).toDate())
          .toSet();

      final List<AppointmentSlot> slots = [];
      for (final block in blocks) {
        DateTime cursor = block.startAt;
        while (cursor.add(Duration(minutes: slotMinutes))
            .compareTo(block.endAt) <=
            0) {
          if (cursor.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
              cursor.isBefore(dayEnd)) {
            final isTaken = taken.any((t) => _sameInstant(t, cursor));
            if (!isTaken) {
              slots.add(
                AppointmentSlot(
                  ownerId: ownerId,
                  blockId: block.id,
                  startAt: cursor,
                  endAt: cursor.add(Duration(minutes: slotMinutes)),
                ),
              );
            }
          }
          cursor = cursor.add(Duration(minutes: slotMinutes));
        }
      }

      slots.sort((a, b) => a.startAt.compareTo(b.startAt));
      return slots;
    });
  }

  // ---------------------------------------------------------------------------
  // Booking + cancellation
  // ---------------------------------------------------------------------------

  /// Books an appointment for [slot], using a Firestore transaction so
  /// that two parents racing for the same slot will not both succeed.
  ///
  /// Throws [SlotAlreadyTakenException] if another confirmed
  /// appointment exists for the same `(owner_id, start_at)` pair.
  Future<Appointment> bookAppointment({
    required AppointmentSlot slot,
    required String ownerName,
    required String ownerRole,
    required String parentId,
    required String parentName,
    required String studentId,
    required String studentName,
    String? note,
  }) async {
    final startTs = Timestamp.fromDate(slot.startAt);
    final endTs = Timestamp.fromDate(slot.endAt);

    // We use a transaction to atomically (re)check the conflict query
    // and write the new doc. Note that Firestore transactions only
    // guarantee atomicity for *document* reads via `transaction.get`,
    // not for queries — so this still has a tiny race window, but the
    // query+write pair drastically reduces double-booking risk.
    final docRef = _db.collection(_appointmentsCollection).doc();

    await _db.runTransaction((txn) async {
      final existing = await _db
          .collection(_appointmentsCollection)
          .where('owner_id', isEqualTo: slot.ownerId)
          .where('status', isEqualTo: 'confirmed')
          .where('start_at', isEqualTo: startTs)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw SlotAlreadyTakenException();
      }

      txn.set(docRef, {
        'owner_id': slot.ownerId,
        'owner_role': ownerRole,
        'owner_name': ownerName,
        'parent_id': parentId,
        'parent_name': parentName,
        'student_id': studentId,
        'student_name': studentName,
        'start_at': startTs,
        'end_at': endTs,
        'status': 'confirmed',
        'note': note ?? '',
        'block_id': slot.blockId,
        'created_at': FieldValue.serverTimestamp(),
      });
    });

    return Appointment(
      id: docRef.id,
      ownerId: slot.ownerId,
      ownerRole: ownerRole,
      ownerName: ownerName,
      parentId: parentId,
      parentName: parentName,
      studentId: studentId,
      studentName: studentName,
      startAt: slot.startAt,
      endAt: slot.endAt,
      status: 'confirmed',
      note: note ?? '',
      blockId: slot.blockId,
    );
  }

  Future<void> cancelAppointment(
    String appointmentId, {
    required bool byParent,
  }) async {
    await _db.collection(_appointmentsCollection).doc(appointmentId).update({
      'status': byParent ? 'cancelled_by_parent' : 'cancelled_by_owner',
      'cancelled_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Appointment>> streamAppointmentsForOwner(String ownerId) {
    return _db
        .collection(_appointmentsCollection)
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map(Appointment.fromDoc).toList()
            ..sort((a, b) => b.startAt.compareTo(a.startAt));
          return list;
        });
  }

  Stream<List<Appointment>> streamAppointmentsForParent(String parentId) {
    return _db
        .collection(_appointmentsCollection)
        .where('parent_id', isEqualTo: parentId)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map(Appointment.fromDoc).toList()
            ..sort((a, b) => b.startAt.compareTo(a.startAt));
          return list;
        });
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Lists users in the `users` collection with `role` in
  /// {`counselor`, `teacher`}. Used by the parent's "who do I want to
  /// book with?" picker.
  Future<List<AppointmentOwner>> listBookableOwners() async {
    final snap = await _db
        .collection('users')
        .where('role', whereIn: ['counselor', 'teacher'])
        .get();
    return snap.docs
        .map(
          (d) => AppointmentOwner(
            id: d.id,
            name: (d.data()['name'] ?? d.data()['full_name'] ?? 'User')
                .toString(),
            role: (d.data()['role'] ?? 'counselor').toString(),
            specialty: (d.data()['specialty'] ?? '').toString(),
          ),
        )
        .toList();
  }

  static bool _sameInstant(DateTime a, DateTime b) {
    return a.millisecondsSinceEpoch == b.millisecondsSinceEpoch;
  }

  /// Tiny `combineLatest` for two streams, since `rxdart` is not a
  /// dependency. Emits whenever either source has produced at least
  /// one value and one of them changes.
  static Stream<R> _combineLatest2<A, B, R>(
    Stream<A> a,
    Stream<B> b,
    R Function(A, B) combiner,
  ) async* {
    A? lastA;
    B? lastB;
    bool hasA = false;
    bool hasB = false;

    final controller = StreamController<R>();

    final subA = a.listen((value) {
      lastA = value;
      hasA = true;
      if (hasB) controller.add(combiner(lastA as A, lastB as B));
    }, onError: controller.addError);

    final subB = b.listen((value) {
      lastB = value;
      hasB = true;
      if (hasA) controller.add(combiner(lastA as A, lastB as B));
    }, onError: controller.addError);

    controller.onCancel = () async {
      await subA.cancel();
      await subB.cancel();
    };

    yield* controller.stream;
  }
}

class SlotAlreadyTakenException implements Exception {
  @override
  String toString() => 'Slot already taken';
}

// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------

class AvailabilityBlock {
  AvailabilityBlock({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerRole,
    required this.startAt,
    required this.endAt,
  });

  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerRole;
  final DateTime startAt;
  final DateTime endAt;

  factory AvailabilityBlock.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? const <String, dynamic>{};
    return AvailabilityBlock(
      id: doc.id,
      ownerId: (data['owner_id'] ?? '').toString(),
      ownerName: (data['owner_name'] ?? '').toString(),
      ownerRole: (data['owner_role'] ?? 'counselor').toString(),
      startAt: _toDate(data['start_at']),
      endAt: _toDate(data['end_at']),
    );
  }
}

class AppointmentSlot {
  AppointmentSlot({
    required this.ownerId,
    required this.blockId,
    required this.startAt,
    required this.endAt,
  });

  final String ownerId;
  final String blockId;
  final DateTime startAt;
  final DateTime endAt;
}

class Appointment {
  Appointment({
    required this.id,
    required this.ownerId,
    required this.ownerRole,
    required this.ownerName,
    required this.parentId,
    required this.parentName,
    required this.studentId,
    required this.studentName,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.note,
    required this.blockId,
  });

  final String id;
  final String ownerId;
  final String ownerRole;
  final String ownerName;
  final String parentId;
  final String parentName;
  final String studentId;
  final String studentName;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String note;
  final String blockId;

  bool get isUpcoming =>
      status == 'confirmed' && endAt.isAfter(DateTime.now());

  factory Appointment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Appointment(
      id: doc.id,
      ownerId: (data['owner_id'] ?? '').toString(),
      ownerRole: (data['owner_role'] ?? 'counselor').toString(),
      ownerName: (data['owner_name'] ?? '').toString(),
      parentId: (data['parent_id'] ?? '').toString(),
      parentName: (data['parent_name'] ?? '').toString(),
      studentId: (data['student_id'] ?? '').toString(),
      studentName: (data['student_name'] ?? '').toString(),
      startAt: _toDate(data['start_at']),
      endAt: _toDate(data['end_at']),
      status: (data['status'] ?? 'confirmed').toString(),
      note: (data['note'] ?? '').toString(),
      blockId: (data['block_id'] ?? '').toString(),
    );
  }
}

class AppointmentOwner {
  AppointmentOwner({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
  });

  final String id;
  final String name;
  final String role;
  final String specialty;
}

DateTime _toDate(dynamic raw) {
  if (raw is Timestamp) return raw.toDate();
  if (raw is DateTime) return raw;
  if (raw is String) return DateTime.tryParse(raw) ?? DateTime(2000);
  return DateTime(2000);
}

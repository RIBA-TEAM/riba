import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addObservation({
    required String studentId,
    required String teacherId,
    required String behavior,
    required String note,
    required int riskLevel,
  }) async {
    await _db.collection("observations").add({
      "student_id": studentId,
      "teacher_id": teacherId,
      "behavior": behavior,
      "note": note,
      "risk_level": riskLevel,
      "created_at": Timestamp.now(),
    });
  }
}

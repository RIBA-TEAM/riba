import 'package:flutter/material.dart';

import '../../../core/services/appointment_service.dart';

/// Lists every appointment booked against this counselor / teacher.
/// Splits the list into "Yaklaşan" and "Geçmiş" sections, and lets the
/// owner cancel an upcoming one.
class OwnerAppointmentsScreen extends StatelessWidget {
  OwnerAppointmentsScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
  });

  final String ownerId;
  final String ownerName;

  final AppointmentService _service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF101922);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        title: const Text(
          'Randevularım',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ownerId.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Kullanıcı kimliği bulunamadı.\nLütfen tekrar giriş yapın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          : StreamBuilder<List<Appointment>>(
              stream: _service.streamAppointmentsForOwner(ownerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Hata: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }

                final all = snapshot.data ?? const <Appointment>[];
                final upcoming =
                    all.where((a) => a.isUpcoming).toList()
                      ..sort((a, b) => a.startAt.compareTo(b.startAt));
                final past = all
                    .where((a) => !a.isUpcoming)
                    .toList(); // already sorted desc

                if (all.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Henüz randevu yok.',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const _SectionHeader('Yaklaşan'),
                      const SizedBox(height: 8),
                      ...upcoming.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AppointmentCard(
                            appointment: a,
                            cancelable: true,
                            onCancel: () => _confirmCancel(context, a),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (past.isNotEmpty) ...[
                      const _SectionHeader('Geçmiş / İptal'),
                      const SizedBox(height: 8),
                      ...past.map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AppointmentCard(
                            appointment: a,
                            cancelable: false,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, Appointment a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Randevuyu iptal et?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '${a.parentName} (${a.studentName}) ile '
          '${_formatDateTime(a.startAt)} tarihindeki randevu iptal edilecek.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Vazgeç',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.cancelAppointment(a.id, byParent: false);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Randevu iptal edildi.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İptal edilemedi: $e')),
      );
    }
  }

  static String _formatDateTime(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final hour = d.hour.toString().padLeft(2, '0');
    final minute = d.minute.toString().padLeft(2, '0');
    return '$day.$month.${d.year} $hour:$minute';
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.white60,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.cancelable,
    this.onCancel,
  });

  final Appointment appointment;
  final bool cancelable;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    final isCancelled = a.status.startsWith('cancelled');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2127),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  a.parentName.isEmpty ? 'Veli' : a.parentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              _StatusChip(status: a.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Öğrenci: ${a.studentName.isEmpty ? '-' : a.studentName}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Color(0xFF137FEC),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                _formatRange(a.startAt, a.endAt),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          if (a.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Not: ${a.note}',
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
          if (cancelable && !isCancelled) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                label: const Text(
                  'Randevuyu iptal et',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatRange(DateTime start, DateTime end) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(start.day)}.${two(start.month)}.${start.year} '
        '${two(start.hour)}:${two(start.minute)}–'
        '${two(end.hour)}:${two(end.minute)}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;
    switch (status) {
      case 'confirmed':
        color = const Color(0xFF22C55E);
        label = 'Onaylı';
        break;
      case 'cancelled_by_parent':
        color = Colors.orange;
        label = 'Veli iptal';
        break;
      case 'cancelled_by_owner':
        color = Colors.redAccent;
        label = 'İptal';
        break;
      case 'completed':
        color = Colors.blueGrey;
        label = 'Tamamlandı';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

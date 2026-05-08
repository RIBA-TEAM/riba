import 'package:flutter/material.dart';

import '../../../core/services/appointment_service.dart';
import '../parent_routes.dart';
import '../widgets/parent_bottom_nav.dart';

/// Lists all appointments belonging to the logged-in parent.
/// Shows two sections: upcoming (cancelable) and past / cancelled.
class ParentAppointmentsScreen extends StatelessWidget {
  ParentAppointmentsScreen({super.key});

  final AppointmentService _service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);
    const bgDark = Color(0xFF101C22);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String parentId = args?['parentId'] ?? '';
    final String parentName = args?['parentName'] ?? 'Parent';
    final String studentId = args?['studentId'] ?? '';
    final String studentName = args?['studentName'] ?? 'Student';
    final String studentClass = args?['studentClass'] ?? '-';
    final String schoolNo = args?['schoolNo'] ?? '-';

    final navArgs = {
      'parentId': parentId,
      'parentName': parentName,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'schoolNo': schoolNo,
    };

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tealDeep, primary],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(context, navArgs),
                Expanded(
                  child: parentId.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Veli kimliği bulunamadı.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        )
                      : StreamBuilder<List<Appointment>>(
                          stream: _service.streamAppointmentsForParent(
                            parentId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Hata: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final all =
                                snapshot.data ?? const <Appointment>[];
                            final upcoming = all
                                .where((a) => a.isUpcoming)
                                .toList()
                              ..sort(
                                (a, b) => a.startAt.compareTo(b.startAt),
                              );
                            final past =
                                all.where((a) => !a.isUpcoming).toList();

                            if (all.isEmpty) {
                              return _emptyState(context, navArgs);
                            }

                            return ListView(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                8,
                                16,
                                96,
                              ),
                              children: [
                                if (upcoming.isNotEmpty) ...[
                                  const _SectionHeader('Yaklaşan'),
                                  const SizedBox(height: 8),
                                  ...upcoming.map(
                                    (a) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: _AppointmentCard(
                                        appointment: a,
                                        cancelable: true,
                                        onCancel: () => _confirmCancel(
                                          context,
                                          a,
                                        ),
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
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
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
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ParentBottomNav(selectedIndex: 2, args: navArgs),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> navArgs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Randevularım',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              ParentRoutes.bookAppointment,
              arguments: navArgs,
            ),
            icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
            tooltip: 'Yeni randevu',
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, Map<String, dynamic> navArgs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_available_outlined,
              color: Colors.white60,
              size: 56,
            ),
            const SizedBox(height: 12),
            const Text(
              'Henüz bir randevunuz yok.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                ParentRoutes.bookAppointment,
                arguments: navArgs,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Yeni randevu al'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF137FEC),
              ),
            ),
          ],
        ),
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
          '${a.ownerName} ile ${_formatDateTime(a.startAt)} '
          'tarihindeki randevu iptal edilecek.',
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
      await _service.cancelAppointment(a.id, byParent: true);
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
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} '
        '${two(d.hour)}:${two(d.minute)}';
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
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w800,
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
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  a.ownerName.isEmpty ? 'Görevli' : a.ownerName,
                  style: const TextStyle(
                    color: Color(0xFF111618),
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
            _roleLabel(a.ownerRole),
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
          const SizedBox(height: 8),
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
                style: const TextStyle(
                  color: Color(0xFF111618),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          if (a.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Not: ${a.note}',
              style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13),
            ),
          ],
          if (cancelable && !isCancelled) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.redAccent,
                ),
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

  static String _roleLabel(String role) {
    switch (role) {
      case 'teacher':
        return 'Öğretmen';
      case 'counselor':
        return 'Rehber';
      default:
        return role;
    }
  }

  static String _formatRange(DateTime start, DateTime end) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(start.day)}.${two(start.month)}.${start.year}  '
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
        label = 'İptal ettiniz';
        break;
      case 'cancelled_by_owner':
        color = Colors.redAccent;
        label = 'İptal edildi';
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

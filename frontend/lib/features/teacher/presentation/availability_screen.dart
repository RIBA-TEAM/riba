import 'package:flutter/material.dart';

import '../../../core/services/appointment_service.dart';

/// Lets a counselor / teacher publish 30-minute appointment windows.
///
/// A "block" is a contiguous range (e.g. 14:00-16:00). The
/// [AppointmentService] slices it into 30-minute slots when the
/// parent UI asks for availability.
class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
    required this.ownerRole,
  });

  final String ownerId;
  final String ownerName;
  final String ownerRole;

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  final AppointmentService _service = AppointmentService();

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF101922);
    const primary = Color(0xFF137FEC);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        title: const Text(
          'Müsait Saatler',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Aralık Ekle'),
      ),
      body: widget.ownerId.isEmpty
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
          : StreamBuilder<List<AvailabilityBlock>>(
              stream: _service.streamBlocksForOwner(widget.ownerId),
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

                final blocks = snapshot.data ?? const [];
                if (blocks.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Henüz müsait aralık eklemediniz.\n'
                        'Sağ alttaki "Aralık Ekle" düğmesine basın.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, height: 1.4),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: blocks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _BlockCard(
                    block: blocks[i],
                    onDelete: () => _confirmDelete(blocks[i]),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showAddDialog() async {
    final now = DateTime.now();
    DateTime selectedDate = DateTime(now.year, now.month, now.day);
    TimeOfDay startTime = const TimeOfDay(hour: 14, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 16, minute: 0);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text(
                'Yeni Aralık',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DialogTile(
                      icon: Icons.event_outlined,
                      label: 'Tarih',
                      value: _formatDate(selectedDate),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          initialDate: selectedDate,
                        );
                        if (picked != null) {
                          setLocalState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _DialogTile(
                      icon: Icons.schedule_outlined,
                      label: 'Başlangıç',
                      value: _formatTime(startTime),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: startTime,
                        );
                        if (picked != null) {
                          setLocalState(() => startTime = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _DialogTile(
                      icon: Icons.schedule,
                      label: 'Bitiş',
                      value: _formatTime(endTime),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: ctx,
                          initialTime: endTime,
                        );
                        if (picked != null) {
                          setLocalState(() => endTime = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Bu aralık 30 dakikalık slotlara bölünür.',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text(
                    'İptal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF137FEC),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Ekle'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true || !mounted) return;

    final start = _combine(selectedDate, startTime);
    final end = _combine(selectedDate, endTime);

    if (!end.isAfter(start)) {
      _showSnack('Bitiş saati başlangıçtan sonra olmalı.');
      return;
    }
    if (end.difference(start).inMinutes < AppointmentService.slotMinutes) {
      _showSnack(
        'Aralık en az ${AppointmentService.slotMinutes} dakika olmalı.',
      );
      return;
    }

    try {
      await _service.addBlock(
        ownerId: widget.ownerId,
        ownerName: widget.ownerName,
        ownerRole: widget.ownerRole,
        startAt: start,
        endAt: end,
      );
      if (!mounted) return;
      _showSnack('Aralık eklendi.');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Hata: $e');
    }
  }

  Future<void> _confirmDelete(AvailabilityBlock block) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Aralığı sil?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '${_formatDate(block.startAt)}  '
          '${_formatTime(TimeOfDay.fromDateTime(block.startAt))} – '
          '${_formatTime(TimeOfDay.fromDateTime(block.endAt))}\n\n'
          'Bu aralıktaki kullanılmamış slotlar kaldırılır.',
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteBlock(block.id);
      if (!mounted) return;
      _showSnack('Aralık silindi.');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Silinemedi: $e');
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  static String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _BlockCard extends StatelessWidget {
  const _BlockCard({required this.block, required this.onDelete});

  final AvailabilityBlock block;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final start = block.startAt;
    final end = block.endAt;
    final slotCount =
        end.difference(start).inMinutes ~/ AppointmentService.slotMinutes;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2127),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF137FEC).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event, color: Color(0xFF137FEC)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${start.day.toString().padLeft(2, '0')}.'
                  '${start.month.toString().padLeft(2, '0')}.${start.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} '
                  '– ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')} '
                  '($slotCount slot)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _DialogTile extends StatelessWidget {
  const _DialogTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF101922),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF137FEC), size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

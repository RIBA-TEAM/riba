import 'package:flutter/material.dart';

import '../../../core/services/appointment_service.dart';
import '../widgets/parent_bottom_nav.dart';

/// Three-step booking flow:
///   1. pick a counselor / teacher
///   2. pick a day
///   3. pick a free 30-min slot, optionally add a note, confirm
class ParentBookAppointmentScreen extends StatefulWidget {
  const ParentBookAppointmentScreen({super.key});

  @override
  State<ParentBookAppointmentScreen> createState() =>
      _ParentBookAppointmentScreenState();
}

class _ParentBookAppointmentScreenState
    extends State<ParentBookAppointmentScreen> {
  final AppointmentService _service = AppointmentService();

  Future<List<AppointmentOwner>>? _ownersFuture;

  AppointmentOwner? _selectedOwner;
  DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String _filter = 'all'; // all | counselor | teacher

  bool _booking = false;

  @override
  void initState() {
    super.initState();
    _ownersFuture = _service.listBookableOwners();
  }

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
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOwnerStep(),
                        const SizedBox(height: 16),
                        if (_selectedOwner != null) _buildDateStep(),
                        const SizedBox(height: 16),
                        if (_selectedOwner != null)
                          _buildSlotsStep(
                            parentId: parentId,
                            parentName: parentName,
                            studentId: studentId,
                            studentName: studentName,
                          ),
                      ],
                    ),
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

  Widget _buildHeader(BuildContext context) {
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
          const Text(
            'Randevu Al',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerStep() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepLabel('1. Kim ile?'),
          const SizedBox(height: 8),
          Row(
            children: [
              _FilterPill(
                label: 'Hepsi',
                selected: _filter == 'all',
                onTap: () => setState(() => _filter = 'all'),
              ),
              const SizedBox(width: 8),
              _FilterPill(
                label: 'Rehber',
                selected: _filter == 'counselor',
                onTap: () => setState(() => _filter = 'counselor'),
              ),
              const SizedBox(width: 8),
              _FilterPill(
                label: 'Öğretmen',
                selected: _filter == 'teacher',
                onTap: () => setState(() => _filter = 'teacher'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<AppointmentOwner>>(
            future: _ownersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Hata: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                );
              }
              final all = snapshot.data ?? const <AppointmentOwner>[];
              final filtered = _filter == 'all'
                  ? all
                  : all.where((o) => o.role == _filter).toList();

              if (filtered.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Bu kategoride listelenecek kişi yok.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return Column(
                children: filtered.map((o) {
                  final selected = _selectedOwner?.id == o.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _OwnerTile(
                      owner: o,
                      selected: selected,
                      onTap: () {
                        setState(() => _selectedOwner = o);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateStep() {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepLabel('2. Hangi gün?'),
          const SizedBox(height: 8),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final day = today.add(Duration(days: i));
                final selected = _isSameDay(day, _selectedDay);
                return _DayPill(
                  day: day,
                  selected: selected,
                  onTap: () => setState(() => _selectedDay = day),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotsStep({
    required String parentId,
    required String parentName,
    required String studentId,
    required String studentName,
  }) {
    final owner = _selectedOwner!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepLabel('3. Hangi saat?'),
          const SizedBox(height: 8),
          StreamBuilder<List<AppointmentSlot>>(
            stream: _service.streamAvailableSlots(
              ownerId: owner.id,
              day: _selectedDay,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Hata: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white70),
                );
              }

              final slots = snapshot.data ?? const <AppointmentSlot>[];
              if (slots.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Bu gün için müsait slot yok.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: slots.map((s) {
                  return _SlotChip(
                    slot: s,
                    onTap: _booking
                        ? null
                        : () => _confirmBooking(
                              slot: s,
                              parentId: parentId,
                              parentName: parentName,
                              studentId: studentId,
                              studentName: studentName,
                            ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking({
    required AppointmentSlot slot,
    required String parentId,
    required String parentName,
    required String studentId,
    required String studentName,
  }) async {
    if (parentId.isEmpty || studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veli veya öğrenci kimliği eksik. Lütfen yeniden giriş yapın.'),
        ),
      );
      return;
    }

    final noteController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Randevuyu onayla',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_selectedOwner!.name}\n'
                '${_formatDate(slot.startAt)}  '
                '${_formatTime(slot.startAt)}–${_formatTime(slot.endAt)}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Not (opsiyonel)',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF137FEC),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );

    if (result != true || !mounted) return;

    setState(() => _booking = true);
    try {
      await _service.bookAppointment(
        slot: slot,
        ownerName: _selectedOwner!.name,
        ownerRole: _selectedOwner!.role,
        parentId: parentId,
        parentName: parentName,
        studentId: studentId,
        studentName: studentName,
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Randevu başarıyla oluşturuldu.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // back to dashboard
    } on SlotAlreadyTakenException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu slot az önce alındı, başka bir saat seçin.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _formatDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }

  static String _formatTime(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.hour)}:${two(d.minute)}';
  }
}

class _StepLabel extends StatelessWidget {
  const _StepLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF1193D4) : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _OwnerTile extends StatelessWidget {
  const _OwnerTile({
    required this.owner,
    required this.selected,
    required this.onTap,
  });

  final AppointmentOwner owner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withOpacity(0.10),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF1193D4),
              child: Text(
                owner.name.isEmpty ? '?' : owner.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner.name,
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _roleLabel(owner.role) +
                        (owner.specialty.isEmpty
                            ? ''
                            : ' • ${owner.specialty}'),
                    style: TextStyle(
                      color: selected ? Colors.black54 : Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: Color(0xFF137FEC)),
          ],
        ),
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
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const weekdayShort = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final wd = weekdayShort[day.weekday - 1];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              wd,
              style: TextStyle(
                color: selected ? const Color(0xFF1193D4) : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day.day.toString(),
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.slot, required this.onTap});

  final AppointmentSlot slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String two(int v) => v.toString().padLeft(2, '0');
    final label = '${two(slot.startAt.hour)}:${two(slot.startAt.minute)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF137FEC),
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

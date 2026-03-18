import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ObservationScreen extends StatefulWidget {
  const ObservationScreen({super.key});

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  String? student;
  String? behavior;
  String? academic;

  final notesController = TextEditingController();

  bool _isSaving = false;

  final Map<String, String> _behaviorLabels = {
    'mood': 'Ruh hali değişimi',
    'withdrawal': 'İçe kapanma',
    'aggression': 'Agresif davranış',
    'anxiety': 'Kaygı belirtileri',
  };

  final Map<String, String> _academicLabels = {
    'declining': 'Notlarda düşüş',
    'missing': 'Eksik ödevler',
    'attendance': 'Devamsızlık',
    'improvement': 'Gelişim',
  };

  String _buildTitle() {
    if (behavior != null && _behaviorLabels.containsKey(behavior)) {
      return _behaviorLabels[behavior]!;
    }
    if (academic != null && _academicLabels.containsKey(academic)) {
      return _academicLabels[academic]!;
    }
    return 'Yeni Gözlem';
  }

  String _buildMessage() {
    final parts = <String>[];

    if (behavior != null && _behaviorLabels.containsKey(behavior)) {
      parts.add('Davranış: ${_behaviorLabels[behavior]}');
    }

    if (academic != null && _academicLabels.containsKey(academic)) {
      parts.add('Akademik durum: ${_academicLabels[academic]}');
    }

    if (notesController.text.trim().isNotEmpty) {
      parts.add('Not: ${notesController.text.trim()}');
    }

    return parts.join(' • ');
  }

  String _buildRiskLevel() {
    switch (behavior) {
      case 'aggression':
      case 'anxiety':
        return 'high';
      case 'withdrawal':
      case 'mood':
        return 'medium';
      default:
        return 'low';
    }
  }

  Future<void> _saveObservation() async {
    if (student == null || behavior == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen öğrenci ve davranış seçin')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      final studentDoc = await firestore
          .collection('students')
          .doc(student)
          .get();

      if (!studentDoc.exists) {
        throw Exception('Öğrenci bulunamadı');
      }

      final studentData = studentDoc.data()!;
      final parentId = studentData['parent_id'] ?? '';

      await firestore.collection('observations').add({
        'student_id': student,
        'parent_id': parentId,
        'teacher_id': 'teacher1',
        'title': _buildTitle(),
        'message': _buildMessage(),
        'note': notesController.text.trim(),
        'behavior': behavior,
        'academic': academic,
        'risk_level': _buildRiskLevel(),
        'source': 'guidance',
        'created_at': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Observation saved')));

      setState(() {
        student = null;
        behavior = null;
        academic = null;
      });
      notesController.clear();

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt sırasında hata oluştu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF101922);
    const primary = Color(0xFF137FEC);
    const success = Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            colors: [Color(0xFF1A2A3A), Color(0xFF101922)],
            center: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Yeni Gözlem',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white70),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(Icons.person_search, 'Öğrenci Seçimi'),
                      const SizedBox(height: 8),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('students')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return _dropdown(
                              value: student,
                              hint: 'Öğrenci bulunamadı',
                              items: const [],
                              onChanged: (_) {},
                            );
                          }

                          final studentDocs = snapshot.data!.docs;

                          return DropdownButtonFormField<String>(
                            value: student,
                            dropdownColor: const Color(0xFF1C2127),
                            icon: const Icon(
                              Icons.expand_more,
                              color: Colors.white54,
                            ),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Öğrenci Seçiniz',
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: const Color(0xFF101922),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.white10,
                                ),
                              ),
                            ),
                            items: studentDocs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final name = data['name'] ?? '';
                              final schoolNo = data['school_no'] ?? '';

                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text('$name ($schoolNo)'),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => student = v),
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      if (student != null)
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('students')
                              .doc(student)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const SizedBox.shrink();
                            }

                            final data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final name = data['name'] ?? '';
                            final studentClass = data['class'] ?? '-';
                            final schoolNo = data['school_no'] ?? '-';

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(28, 33, 39, 0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: primary.withOpacity(0.18),
                                    child: Text(
                                      name.isNotEmpty
                                          ? name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$studentClass Sınıfı • No: $schoolNo',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: primary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 24),

                      _sectionTitle(Icons.psychology, 'Davranış Göstergeleri'),
                      const SizedBox(height: 8),

                      _dropdown(
                        value: behavior,
                        hint: 'Gözlem seçiniz...',
                        items: const [
                          DropdownMenuItem(
                            value: 'mood',
                            child: Text('Ruh hali değişimi'),
                          ),
                          DropdownMenuItem(
                            value: 'withdrawal',
                            child: Text('İçe kapanma'),
                          ),
                          DropdownMenuItem(
                            value: 'aggression',
                            child: Text('Agresif davranış'),
                          ),
                          DropdownMenuItem(
                            value: 'anxiety',
                            child: Text('Kaygı belirtileri'),
                          ),
                        ],
                        onChanged: (v) => setState(() => behavior = v),
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle(Icons.school, 'Akademik Göstergeler'),
                      const SizedBox(height: 8),

                      _dropdown(
                        value: academic,
                        hint: 'Durum seçiniz...',
                        items: const [
                          DropdownMenuItem(
                            value: 'declining',
                            child: Text('Notlarda düşüş'),
                          ),
                          DropdownMenuItem(
                            value: 'missing',
                            child: Text('Eksik ödevler'),
                          ),
                          DropdownMenuItem(
                            value: 'attendance',
                            child: Text('Devamsızlık'),
                          ),
                          DropdownMenuItem(
                            value: 'improvement',
                            child: Text('Gelişim'),
                          ),
                        ],
                        onChanged: (v) => setState(() => academic = v),
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle(Icons.description, 'Ek Rehberlik Notları'),
                      const SizedBox(height: 8),

                      TextField(
                        controller: notesController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:
                              'Gözlemlenen olay veya detayları yazınız...',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF101922),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: success,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isSaving ? null : _saveObservation,
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Text('Save Observation'),
                      ),

                      const SizedBox(height: 10),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text('İptal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF137FEC)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1C2127),
      icon: const Icon(Icons.expand_more, color: Colors.white54),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF101922),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

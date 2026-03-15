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
              /// HEADER
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
                          "Yeni Gözlem",
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

              /// BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ÖĞRENCİ SEÇİMİ
                      _sectionTitle(Icons.person_search, "Öğrenci Seçimi"),

                      const SizedBox(height: 8),

                      _dropdown(
                        value: student,
                        hint: "Öğrenci Seçiniz",
                        items: const [
                          DropdownMenuItem(
                            value: "sarah",
                            child: Text("Sarah Jenkins"),
                          ),
                          DropdownMenuItem(
                            value: "john",
                            child: Text("John Doe"),
                          ),
                        ],
                        onChanged: (v) => setState(() => student = v),
                      ),

                      const SizedBox(height: 14),

                      /// ÖĞRENCİ KARTI
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(28, 33, 39, 0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),

                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuAfD2MXwwckz_dC5nCAOFL1yO_sUMmWLJ9NZlfkG0xNMSJjv71x_xTR_aguvSyY5nPJBF5V6XFQnrypl3UJGucabyonrqmfQgeB511V-dITjQIqUIjt7ob_Q3s6s0zAk40mWjYYXxvyd7KSgpu1DszdBLp5qVl4wqlC-2JHkUzzaaTt2R4bbDo3VMEgoHKCtWyMiYZ8CXd-9Olw_Axzy1oEMuir-K_l0U7Gt8IYUaSIAncM_H-tmWedIgic9iU-Ow3IqWFtnV9wLKPf",
                              ),
                            ),

                            const SizedBox(width: 14),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sarah Jenkins",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "10-B Sınıfı • ID: #ST-2041",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(Icons.check_circle, color: primary),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// DAVRANIŞ
                      _sectionTitle(Icons.psychology, "Davranış Göstergeleri"),

                      const SizedBox(height: 8),

                      _dropdown(
                        value: behavior,
                        hint: "Gözlem seçiniz...",
                        items: const [
                          DropdownMenuItem(
                            value: "mood",
                            child: Text("Ruh hali değişimi"),
                          ),
                          DropdownMenuItem(
                            value: "withdrawal",
                            child: Text("İçe kapanma"),
                          ),
                          DropdownMenuItem(
                            value: "aggression",
                            child: Text("Agresif davranış"),
                          ),
                          DropdownMenuItem(
                            value: "anxiety",
                            child: Text("Kaygı belirtileri"),
                          ),
                        ],
                        onChanged: (v) => setState(() => behavior = v),
                      ),

                      const SizedBox(height: 24),

                      /// AKADEMİK
                      _sectionTitle(Icons.school, "Akademik Göstergeler"),

                      const SizedBox(height: 8),

                      _dropdown(
                        value: academic,
                        hint: "Durum seçiniz...",
                        items: const [
                          DropdownMenuItem(
                            value: "declining",
                            child: Text("Notlarda düşüş"),
                          ),
                          DropdownMenuItem(
                            value: "missing",
                            child: Text("Eksik ödevler"),
                          ),
                          DropdownMenuItem(
                            value: "attendance",
                            child: Text("Devamsızlık"),
                          ),
                          DropdownMenuItem(
                            value: "improvement",
                            child: Text("Gelişim"),
                          ),
                        ],
                        onChanged: (v) => setState(() => academic = v),
                      ),

                      const SizedBox(height: 24),

                      /// NOTLAR
                      _sectionTitle(Icons.description, "Ek Rehberlik Notları"),

                      const SizedBox(height: 8),

                      TextField(
                        controller: notesController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:
                              "Gözlemlenen olay veya detayları yazınız...",
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

                      /// BUTONLAR
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: success,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (student == null || behavior == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Lütfen öğrenci ve davranış seçin",
                                ),
                              ),
                            );
                            return;
                          }

                          await FirebaseFirestore.instance
                              .collection('OBSERVATIONS')
                              .add({
                                'studentId': student,
                                'teacherId': 'teacher_test',
                                'behavior': behavior,
                                'academic': academic,
                                'note': notesController.text,
                                'createdAt': Timestamp.now(),
                              });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Observation saved")),
                          );

                          Navigator.pop(context);
                        },
                        child: const Text("Save Observation"),
                      ),

                      const SizedBox(height: 10),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text("İptal"),
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

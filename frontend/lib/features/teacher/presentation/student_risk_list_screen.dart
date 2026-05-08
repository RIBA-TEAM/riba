import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_detail_screen.dart';

class StudentRiskListScreen extends StatefulWidget {
  const StudentRiskListScreen({super.key});

  @override
  State<StudentRiskListScreen> createState() =>
      _StudentRiskListScreenState();
}

class _StudentRiskListScreenState
    extends State<StudentRiskListScreen> {

  // ✅ MOCK DATA
  List<Student> students = [
    Student(id: "ST-1024", riskLevel: "Yüksek", category: "Akademik"),
    Student(id: "ST-8821", riskLevel: "Orta", category: "Sosyal"),
    Student(id: "ST-4092", riskLevel: "Düşük", category: "Akademik"),
    Student(id: "ST-5555", riskLevel: "Yüksek", category: "Davranışsal"),
  ];

  // ✅ SEÇİLİ FİLTRE
  String selectedFilter = "Tüm Vakalar";

  // ✅ FİLTRELENMİŞ LİSTE
  List<Student> get filteredStudents {
    if (selectedFilter == "Tüm Vakalar") return students;

    return students.where((student) {
      return student.riskLevel == selectedFilter ||
          student.category == selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      body: Column(
        children: [

          /// 🔵 HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D2A4A),
                  Color(0xFF101922),
                  Color(0xFF0A1F33),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [

                /// ÜST BAŞLIK
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: const [
                        Text("RIBA",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Öğrenci Risk Listesi",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.notifications,
                            color: Colors.white),
                        SizedBox(width: 12),
                        Icon(Icons.account_circle,
                            color: Colors.white),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                /// ARAMA
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF283039),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search,
                          color: Colors.grey),
                      hintText: "Öğrenci ID Ara...",
                      hintStyle:
                          TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔵 FİLTRELER
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              children: [
                buildFilterChip("Tüm Vakalar"),
                buildFilterChip("Yüksek"),
                buildFilterChip("Orta"),
                buildFilterChip("Düşük"),
                buildFilterChip("Akademik"),
                buildFilterChip("Davranışsal"),
                buildFilterChip("Sosyal"),
              ],
            ),
          ),

          const SizedBox(height: 10),

         /// 🔵 RİSK LİSTESİ
Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: filteredStudents.length,
    itemBuilder: (context, index) {
      final student = filteredStudents[index];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  StudentDetailScreen(student: student),
            ),
          );
        },
        child: RiskItem(
          id: student.id,
          risk: "${student.riskLevel} Risk",
          color: getRiskColor(student.riskLevel),
          tags: [student.category],
          time: "Yeni",
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }

  /// 🔵 FİLTRE CHIP
  Widget buildFilterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF137FEC)
              : const Color(0xFF283039),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 🔵 RİSK RENGİ
  Color getRiskColor(String risk) {
    switch (risk) {
      case "Yüksek":
        return Colors.red;
      case "Orta":
        return Colors.orange;
      case "Düşük":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class RiskItem extends StatelessWidget {
  final String id;
  final String risk;
  final Color color;
  final List<String> tags;
  final String time;

  const RiskItem({
    super.key,
    required this.id,
    required this.risk,
    required this.color,
    required this.tags,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(16),
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding:
                const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.05),
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white
                      .withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(id,
                        style:
                            const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold)),
                    Text(time,
                        style:
                            const TextStyle(
                                color:
                                    Colors.grey,
                                fontSize:
                                    11)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(risk,
                    style: TextStyle(
                        color: color,
                        fontSize: 12)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: tags
                      .map((tag) =>
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4),
                            decoration:
                                BoxDecoration(
                              color: color
                                  .withOpacity(
                                      0.1),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),
                            ),
                            child: Text(tag,
                                style: TextStyle(
                                    color: color,
                                    fontSize:
                                        10)),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
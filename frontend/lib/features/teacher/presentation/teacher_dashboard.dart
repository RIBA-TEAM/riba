import 'package:flutter/material.dart';
import 'package:frontend/features/teacher/presentation/student_risk_list_screen.dart';
import 'package:frontend/features/teacher/presentation/reports.dart';
import 'package:frontend/features/teacher/presentation/observation_entry_screen.dart';
import 'settings.dart';
import 'package:frontend/features/teacher/presentation/notifications_page.dart';


class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      buildDashboardContent(),
      const StudentRiskListScreen(),
      const ReportsPage(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),

      body: pages[selectedIndex],

      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF137FEC),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ObservationScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: const Color(0xFF101922),
        selectedItemColor: const Color(0xFF137FEC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late),
            label: "Öğrenciler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Raporlar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
        ],
      ),
    );
  }

  /// 🔹 Dashboard İçeriği Ayrı Fonksiyona Alındı
  Widget buildDashboardContent() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.2,
              colors: [Color(0xFF1E3A8A), Color(0xFF101922)],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF137FEC),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Günaydın",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "Şevval Eser",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Öğrenci Önceliklendirme",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Expanded(
                          child: RiskCard(
                            title: "Yüksek Risk",
                            count: "12",
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RiskCard(
                            title: "Orta Risk",
                            count: "24",
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RiskCard(
                            title: "Düşük Risk",
                            count: "56",
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    AlertTile(
                      initials: "JD",
                      title: "Belirgin ruh hali değişimi",
                      subtitle: "Yüksek stres göstergeleri tespit edildi",
                      color: Colors.orange,
                    ),
                    AlertTile(
                      initials: "AL",
                      title: "Yoklama eksik",
                      subtitle: "3 ardışık kontrol atlandı",
                      color: Colors.teal,
                    ),
                    AlertTile(
                      initials: "RB",
                      title: "Olumlu gelişme",
                      subtitle: "Duygusal istikrar artışı gözlemlendi",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RiskCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const RiskCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  final String initials;
  final String title;
  final String subtitle;
  final Color color;

  const AlertTile({
    super.key,
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Text(
                initials,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import '../student_routes.dart';

/// AMAÇ: Öğrencinin duygu ve risk geçmişini görüntülemesi
/// Bu ekran, zaman içinde duygusal değişimleri ve risk trendlerini analiz etmesini sağlar
class StudentHistoryScreen extends StatelessWidget {
  const StudentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// HEADER
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  StudentRoutes.dashboard,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "Geçmiş",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Duygu ve risk geçmişin",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Son aktivitelerini buradan takip edebilirsin.",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),

                  /// RISK CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Haftalık Risk Değişimi",
                            style: TextStyle(color: Colors.white54),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "28%",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3994EF),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(
                                Icons.trending_down,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "-5% geçen haftaya göre",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          /// Fake chart placeholder
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.indigo],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// FILTER BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _filterButton("Tümü", true),
                      const SizedBox(width: 10),
                      _filterButton("Bu Hafta", false),
                      const SizedBox(width: 10),
                      _filterButton("Bu Ay", false),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// LIST
                  _historyItem("😊", "Mutlu", "Dün, 14:20"),
                  _historyItem("🧘", "Sakin", "Cumartesi, 11:45"),
                  _historyItem("😰", "Kaygılı", "Cuma, 18:30"),
                  _historyItem("🤔", "Düşünceli", "Perşembe, 09:15"),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _bottomNav(context),
          ),
        ],
      ),
    );
  }

  static Widget _filterButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF3994EF)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget _historyItem(String emoji, String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(date, style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home, 0, context),
              _navIcon(Icons.chat_bubble, 1, context),
              _navIcon(Icons.history, 2, context, selected: true),
              _navIcon(Icons.settings, 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(
    IconData icon,
    int index,
    BuildContext context, {
    bool selected = false,
  }) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, StudentRoutes.dashboard);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, StudentRoutes.chat);
            break;
          case 2:
            break;
          case 3:
            Navigator.pushReplacementNamed(context, StudentRoutes.settings);
            break;
        }
      },
      child: Icon(
        icon,
        color: selected ? const Color(0xFF3994EF) : Colors.grey,
      ),
    );
  }
}

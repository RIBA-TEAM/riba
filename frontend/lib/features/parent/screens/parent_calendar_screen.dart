import 'package:flutter/material.dart';

class ParentCalendarScreen extends StatelessWidget {
  const ParentCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1220),

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Etkinlik ve Duygu Takvimi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFF3C83F6),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF0A1220), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _takvimAlani(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                "GÜNLÜK ÖZETLER",
                style: TextStyle(
                  color: Colors.white38,
                  letterSpacing: 1.5,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _duyguKart(),
            _toplantiKart(),
            _etkinlikKart(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// TAKVİM
  Widget _takvimAlani() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_left, color: Colors.white38),
              Text(
                "Ekim 2023",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ["PT", "SA", "ÇA", "PE", "CU", "CT", "PZ"]
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [2, 3, 4, 5, 6, 7, 8].map((d) {
              final isToday = d == 5;

              return Container(
                width: 42,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF3C83F6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: const Color(0xFF3C83F6).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isToday)
                      Text(
                        "BUGÜN",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Text(
                      d.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// DUYGU KARTI
  Widget _duyguKart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.sentiment_very_satisfied,
            color: Color(0xFF3C83F6),
            size: 30,
          ),
          const SizedBox(width: 20),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DUYGU: MUTLU",
                  style: TextStyle(color: Color(0xFF3C83F6)),
                ),
                SizedBox(height: 6),
                Text(
                  "Bugün",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Rehberlik görüşmesi yapıldı. Olumlu bir gün geçti.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// TOPLANTI KARTI
  Widget _toplantiKart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Text(
        "Yarın 14:30 - Rehber Öğretmen ile görüşme",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// ETKİNLİK
  Widget _etkinlikKart() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.blueGrey,
      ),
      child: const Center(
        child: Text(
          "Robotik Kodlama Atölyesi",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

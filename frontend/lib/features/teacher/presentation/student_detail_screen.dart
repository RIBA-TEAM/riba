import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  final List<int> monthlyRisk = [40, 35, 50, 70, 90, 100];

   StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      body: Stack(
        children: [

          /// ANA İÇERİK
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.id,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${student.riskLevel} Risk • ${student.category}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _riskColor(student.riskLevel)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Takip Gerekli",
                        style: TextStyle(
                            color: _riskColor(student.riskLevel),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// RİSK SKOR KARTI
                glassCard(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            width: 180,
                            child: CircularProgressIndicator(
                              value: _riskToValue(student.riskLevel),
                              strokeWidth: 12,
                              backgroundColor:
                                  Colors.white.withOpacity(0.05),
                              valueColor: AlwaysStoppedAnimation(
                                  _riskColor(student.riskLevel)),
                            ),
                          ),
                          Text(
                            "${(_riskToValue(student.riskLevel) * 100).toInt()}%",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${student.riskLevel} Öncelik",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _riskColor(student.riskLevel)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

glassCard(
  child: Column(
    children: [

      /// BAR GRAFİK
      SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            monthlyRisk.length,
            (index) {
              final value = monthlyRisk[index];
              final isActive = index >= monthlyRisk.length - 2;

              return Container(
                width: 20,
                height: value.toDouble(),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.blue
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(height: 12),

      /// AYLAR (DİNAMİK)
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: getLast6Months()
            .map(
              (month) => Text(
                month,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            )
            .toList(),
      ),
    ],
  ),
),

                const SizedBox(height: 30),

                /// TESPİT EDİLEN FAKTÖRLER
                sectionTitle("Tespit Edilen Faktörler"),
                const SizedBox(height: 10),

                factorCard(
                  Icons.school,
                  "Akademik Performans",
                  "Not ortalamasında düşüş tespit edildi.",
                  Colors.blue,
                  "ACİL",
                ),

                factorCard(
                  Icons.groups,
                  "Sosyal İzolasyon",
                  "Kulüp katılımında azalma gözlemlendi.",
                  Colors.teal,
                  "ORTA",
                ),

                factorCard(
                  Icons.health_and_safety,
                  "Devamsızlık",
                  "Geç kalma oranında artış mevcut.",
                  Colors.amber,
                  "DÜŞÜK",
                ),

                const SizedBox(height: 30),

                /// DANIŞMAN NOTLARI
                sectionTitle("Danışman Notları"),
                const SizedBox(height: 10),

                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Şevval Eser • Kıdemli Danışman",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Güncelleme: 12 Haziran 2024",
                        style:
                            TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "“Öğrenci sınav dönemi nedeniyle stresli olduğunu ifade etti. Önümüzdeki hafta veli görüşmesi planlandı.”",
                        style:
                            TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          /// ALT SABİT BUTONLAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF101922)
                    .withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                      color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.event, size: 18),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Randevu Planla"),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.check_circle, size: 18),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Durumu Güncelle"),
            ),
          ),
        ),
                ],
                
              ),
            ),
          )
        ],
      ),
    );
  }
  List<String> getLast6Months() {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final date = DateTime(now.year, now.month - (5 - index));
      return _monthShort(date.month);
    });
  }

  String _monthShort(int month) {
    const months = [
      "Oca", "Şub", "Mar", "Nis",
      "May", "Haz", "Tem", "Ağu",
      "Eyl", "Eki", "Kas", "Ara"
    ];
    return months[month - 1];
  }


  double _riskToValue(String risk) {
    switch (risk) {
      case "Yüksek":
        return 0.78;
      case "Orta":
        return 0.55;
      case "Düşük":
        return 0.30;
      default:
        return 0.0;
    }
  }

  Color _riskColor(String risk) {
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

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withOpacity(0.05)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
  }

  Widget factorCard(
      IconData icon, String title, String desc, Color color, String level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: glassCard(
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(desc,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12)),
                ],
              ),
            ),
            Text(level,
                style: TextStyle(
                    color: color,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 11))
          ],
        ),
      ),
    );
  }
}

class RiskBar extends StatelessWidget {
  final double height;
  final bool active;

  const RiskBar({
    super.key,
    required this.height,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: active
            ? Colors.blue
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
import 'package:flutter/material.dart';


class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Color(0xFF137fec)),
            SizedBox(width: 8),
            Text("Raporlar ve Analitik"),
          ],
        ),

      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// KPI KARTLARI
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: "Toplam Öğrenci",
                    value: "1248",
                    sub: "+2%",
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: "Aktif Vakalar",
                    value: "42",
                    sub: "Stabil",
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// DESTEK ORANI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardStyle(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Destek Katılımı",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("84%",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.84,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF137fec),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// RİSK DAĞILIMI
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Risk Dağılımı",
                  style: TextStyle(color: Colors.white70)),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardStyle(),
              child: Column(
                children: [

                  /// RİSK BAR
                  Row(
                    children: [
                      Expanded(
                        flex: 65,
                        child: Container(height: 12, color: Colors.blue),
                      ),
                      Expanded(
                        flex: 25,
                        child: Container(height: 12, color: Colors.orange),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(height: 12, color: Colors.red),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// LEGEND
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Düşük (812)",
                          style: TextStyle(color: Colors.grey)),
                      Text("Orta (312)",
                          style: TextStyle(color: Colors.grey)),
                      Text("Yüksek (124)",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// KATEGORİLER
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("En Yaygın Sorun Kategorileri",
                  style: TextStyle(color: Colors.white70)),
            ),

            const SizedBox(height: 10),

            _categoryTile(
              icon: Icons.school,
              title: "Akademik Performans",
              subtitle: "24 öğrenci işaretlendi",
            ),

            _categoryTile(
              icon: Icons.psychology,
              title: "Duygusal İyi Oluş",
              subtitle: "18 öğrenci işaretlendi",
            ),

            _categoryTile(
              icon: Icons.groups,
              title: "Sosyal Uyum",
              subtitle: "12 öğrenci işaretlendi",
            ),

            const SizedBox(height: 20),

            /// HAFTALIK TREND
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Haftalık Uyarı Trendi",
                  style: TextStyle(color: Colors.white70)),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardStyle(),
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  _bar(40),
                  _bar(60),
                  _bar(55),
                  _bar(80),
                  _bar(45),
                  _bar(30),
                  _bar(50),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// EXPORT
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text("Detaylı CSV Raporu İndir"),
            )
          ],
        ),
      ),
    );
  }

  /// STAT KARTI
  Widget _statCard(
      {required String title,
      required String value,
      required String sub,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  /// CATEGORY TILE
  Widget _categoryTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12))
                ]),
          ),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  /// BAR
  static Widget _bar(double height) {
    return Container(
      width: 14,
      height: height,
      color: Colors.blue,
    );
  }

  /// CARD STYLE
  static BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(14),
    );
  }
}
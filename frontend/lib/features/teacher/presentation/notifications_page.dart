import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF137FEC);
    const backgroundDark = Color(0xFF101922);

    return Scaffold(
      backgroundColor: backgroundDark,

      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Bildirimler"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Tümünü okundu yap",
              style: TextStyle(color: primary),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            /// FİLTRELER
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: _filterButton("Tümü", true)),

                  Expanded(child: _filterButton("Okunmamış", false)),

                  Expanded(child: _filterButton("Arşiv", false)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// BİLDİRİM 1
            _notificationCard(
              icon: Icons.trending_up,
              color: Colors.orange,
              title: "Risk Seviyesi Değişti",
              text:
                  "Öğrenci #4421 (Jordan M.) devamsızlık nedeniyle düşük riskten orta riske yükseltildi.",
              time: "10 dakika önce",
              unread: true,
            ),

            _notificationCard(
              icon: Icons.psychology,
              color: primary,
              title: "Yeni Sistem Uyarısı",
              text:
                  "Yapay zeka, 11. sınıf öğrencilerinde yeni davranış göstergeleri tespit etti.",
              time: "2 saat önce",
              unread: true,
            ),

            _notificationCard(
              icon: Icons.event_repeat,
              color: Colors.green,
              title: "Gözlem Hatırlatması",
              text:
                  "Sarah Jenkins için akran arabuluculuğu sonrası takip gözlemi yapılması gerekiyor.",
              time: "Dün",
              unread: false,
            ),

            _notificationCard(
              icon: Icons.trending_down,
              color: Colors.grey,
              title: "Risk Seviyesi Azaldı",
              text:
                  "Marcus L. öğrencisinin risk seviyesi düşük seviyeye düşürüldü.",
              time: "2 gün önce",
              unread: false,
            ),

            _notificationCard(
              icon: Icons.assignment_turned_in,
              color: Colors.grey,
              title: "Rapor Tamamlandı",
              text: "Özel eğitim departmanı için haftalık rapor oluşturuldu.",
              time: "3 gün önce",
              unread: false,
            ),

            const SizedBox(height: 20),

            const Text(
              "Son 30 günün bildirimleri gösteriliyor",
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// FİLTRE BUTONU
  static Widget _filterButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF137FEC) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// BİLDİRİM KARTI
  static Widget _notificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String text,
    required String time,
    required bool unread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          /// ICON
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  text,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          /// OKUNMAMIŞ NOKTA
          if (unread)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF137FEC),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import '../student_routes.dart';

/// AMAÇ: Öğrencinin sohbet geçmişini görüntülemesi ve yeni sohbet başlatması
/// Bu ekran, geçmiş sohbetleri listelemekte ve hızlıca yeni sohbet oluşturmaya izin vermektedir
class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// === Arka plan rengi - koyu mavi tema ===
      backgroundColor: const Color(0xFF0F172A),

      /// === BAŞLIK ÇUBUĞU (APP BAR) ===
      /// Sayfa başlığı ve geri dönüş düğmesi içerir
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, StudentRoutes.dashboard);
          },
        ),
        title: const Text(
          "Sohbetler",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          /// === ARKA PLAN PARILTISI ===
          /// Dekoratif mavi daire - tasarım vurgusu
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFF3994EF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// === BAŞLIK BÖLÜMÜ ===
                /// \"Sohbetler\" başlığı ve arama butonu
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        /// Arama simgesi
                        children: [_circleButton(Icons.search, () {})],
                      ),

                      const SizedBox(height: 20),

                      /// Sayfa başlığı
                      const Text(
                        "Sohbetler",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Alt başlık - açıklaması
                      const Text(
                        "RIBA ile geçmiş konuşmaların",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// === SOHBET LİSTESİ ===
                /// Geçmiş sohbetleri gösterir
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      /// Sohbet 1: Kaygı üzerine
                      ChatItem(
                        title: "Kaygı hakkında sohbet",
                        subtitle:
                            "Rahatlamana yardımcı olacak bazı teknikler...",
                        time: "14:20",
                        statusColor: Colors.green,
                      ),

                      /// Sohbet 2: Sınav stresi
                      ChatItem(
                        title: "Sınav stresi üzerine",
                        subtitle: "Nefes egzersizlerini denedin mi?",
                        time: "Dün",
                        statusColor: Colors.orange,
                      ),

                      /// Sohbet 3: Uyku düzeni
                      ChatItem(
                        title: "Uyku düzeni tavsiyeleri",
                        subtitle: "Akşam saatlerinde mavi ışık kullanımı...",
                        time: "Salı",
                        statusColor: Colors.green,
                      ),

                      /// Sohbet 4: Ağır stres
                      ChatItem(
                        title: "Yoğun stres yönetimi",
                        subtitle: "Bu konuda uzman desteği almanı öneririm.",
                        time: "12 Haz",
                        statusColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// === YENİ SOHBET BUTONU (FAB) ===
          /// Sağ altta yeni sohbet oluşturma düğmesi
          Positioned(
            bottom: 110,
            right: 20,
            child: GestureDetector(
              onTap: () {
                /// Sohbet detay sayfasına yönlendir
                Navigator.pushNamed(context, StudentRoutes.chatDetail);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3994EF),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3994EF).withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Yeni Sohbet",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// === ALT NAVİGASYON ===
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomNav(context)),
        ],
      ),
    );
  }

  /// === DAİRESEL BUTON OLUŞTURUR ===
  /// İkon ve tıklanma işlevselliği içeren
  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,

        /// Buton tasarımı - koyu arka plan
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  /// === ALT NAVİGASYON ÇUBUĞU OLUŞTURUR ===
  /// Dört ana sayfa arasında gezinti sağlar
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
              _navIcon(Icons.home, false, () {
                Navigator.pushReplacementNamed(
                  context,
                  StudentRoutes.dashboard,
                );
              }),
              _navIcon(Icons.chat_bubble, true, () {}),
              _navIcon(Icons.history, false, () {
                Navigator.pushReplacementNamed(context, StudentRoutes.history);
              }),
              _navIcon(Icons.settings, false, () {
                Navigator.pushReplacementNamed(context, StudentRoutes.settings);
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// === NAVİGASYON İKONU OLUŞTURUR ===
  /// Seçili duruma göre rengini değiştirir
  /// Parametreler: icon = simge türü, selected = seçili mi, onTap = tıklanma işlemi
  Widget _navIcon(IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,

        /// Mavi = seçili, Gri = seçilmemiş
        color: selected ? const Color(0xFF3994EF) : Colors.grey,
      ),
    );
  }
}

/// === SOHBET ÖĞESİ WİDGETİ ===
/// Listedeki her sohbeti temsil eder
/// Avatar, başlık, alt başlık, saat ve durum göstergesi içerir
class ChatItem extends StatelessWidget {
  /// Sohbetin başlığı
  final String title;

  /// Sohbetin son mesajı
  final String subtitle;

  /// Sohbetin saati
  final String time;

  /// Asistanın durumu (çevrimiçi/çevrimdışı) - renk kodları
  final Color statusColor;

  const ChatItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Sohbete tıklandığında detay sayfasını aç
        Navigator.pushNamed(context, StudentRoutes.chatDetail);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        /// Kart tasarımı - hafif saydam arka plan
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            /// === AVATAR + DURUM GÖSTERGESİ ===
            Stack(
              children: [
                /// Asistan avatarı
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF3994EF).withOpacity(0.2),

                  /// Robot simgesi
                  child: const Icon(Icons.smart_toy, color: Color(0xFF3994EF)),
                ),

                /// Durum göstergesi (yeşil/turuncu/kırmızı nokta)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            /// === SOHBET BİLGİLERİ ===
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Sohbet başlığı
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// Sohbet saati
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// Son mesaj (alt başlık)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// İleri ok simgesi
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

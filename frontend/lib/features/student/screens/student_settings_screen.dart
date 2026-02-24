/// AMAÇ: Öğrenci ayarlar ekranı
/// Profil, dil, bildirimler ve diğer tercihleri yönetme

import 'dart:ui';
import 'package:flutter/material.dart';
import '../student_routes.dart';

/// Ayarlar ekranı (Stateful Widget)
/// Kullanıcı tercihleri güncelledikçe durumu güncellemek için Stateful kullanıldı
class StudentSettingsScreen extends StatefulWidget {
  const StudentSettingsScreen({super.key});

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  /// Dil tercihi - false = Türkçe, true = İngilizce
  bool isEnglish = false;

  /// Bildirim durumu - true = açık, false = kapalı
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      body: Stack(
        children: [
          /// === Arka plan Gradyant ===
          /// Tasarım vurgusu için radyal gradyan
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.2,
                colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            StudentRoutes.dashboard,
                          );
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Ayarlar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        /// PROFILE
                        const SizedBox(height: 10),
                        _profileSection(),

                        const SizedBox(height: 30),

                        /// TERCIHLER VE AYARLAR BÖLÜMÜ
                        /// Dil seçimi ve bildirim ayarları
                        _sectionTitle("TERCİHLER"),
                        const SizedBox(height: 10),

                        /// Dil seçim toggle'ı - Türkçe/İngilizce
                        _toggleTile(
                          icon: Icons.language,
                          title: "Dil Seçimi",
                          subtitle: "Türkçe / English",
                          value: isEnglish,
                          onChanged: (val) {
                            setState(() {
                              isEnglish = val;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        /// Bildirim toggle'ı - bildirimleri aç/kapat
                        _toggleTile(
                          icon: Icons.notifications,
                          title: "Bildirimler",
                          value: notificationsEnabled,
                          onChanged: (val) {
                            setState(() {
                              notificationsEnabled = val;
                            });
                          },
                        ),

                        const SizedBox(height: 30),

                        /// YASAL VE POLİTİKA BÖLÜMÜ
                        /// Gizlilik politikası ve KVKK bilgileri
                        _sectionTitle("YASAL"),
                        const SizedBox(height: 10),

                        /// Gizlilik politikası link'i
                        _navigationTile(
                          icon: Icons.shield_outlined,
                          title: "Gizlilik Politikası",
                          onTap: () {
                            // Navigator.push...
                          },
                        ),

                        const SizedBox(height: 12),

                        /// KVKK Aydınlatma Metni link'i
                        _navigationTile(
                          icon: Icons.description_outlined,
                          title: "KVKK Aydınlatma Metni",
                          onTap: () {
                            // Navigator.push...
                          },
                        ),

                        const SizedBox(height: 30),

                        /// ÇIKIŞ BÖLÜMÜ
                        /// Hesaptan çıkış yap
                        _logoutTile(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM NAV
          Positioned(bottom: 20, left: 20, right: 20, child: _bottomNav()),
        ],
      ),
    );
  }

  // ================= PROFİL BÖLÜMÜ =================
  /// Kullanıcı profilini göstermek için widgetı
  /// Avatar, kiİD ve düzen düğmesi içerir
  Widget _profileSection() {
    return Column(
      children: [
        /// Profil resmini göstermek için Stack
        /// Resmin sağ altı köşesine doğrulandı simgesi eklenmiştir
        Stack(
          children: [
            /// Profil resmi - internet kaynağından yüklen
            const CircleAvatar(
              radius: 65, // Avatar boyutu
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),

            /// Doğrulandı simgesi (sağ alt çeigen)
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Öğrenci ID'si
        const Text(
          "S-2041",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        /// Öğrenci kimliği etiketi
        const Text("RIBA Student ID", style: TextStyle(color: Colors.blue)),
        const SizedBox(height: 20),

        /// Profil düzenle butonu
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text("Profil Düzenle"),
        ),
      ],
    );
  }

  // ================= TERCIH PLOTALARI (SEÇİM KUTULARI) =================
  /// Toggle (AÇ/KAPA) seçeneği - dil, bildirimler vb. için
  /// Icon, başlık, alt başlık ve toggle düğmesi içerir
  Widget _toggleTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return _glassContainer(
      child: Row(
        children: [
          /// Sol tarafta icon daire
          _iconCircle(icon),
          const SizedBox(width: 16),

          /// Orta kısımda başlık ve alt başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),

          /// Sağ tarafta toggle şıkı
          Switch(value: value, activeColor: Colors.blue, onChanged: onChanged),
        ],
      ),
    );
  }

  /// Navigasyon plotağı - tıklanabilir çeşitli sayfay yönlendiren sıra
  /// Icon, başlık ve sağ ileri ok simgesi içerir
  Widget _navigationTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _glassContainer(
        child: Row(
          children: [
            /// Sol tarafta icon daire
            _iconCircle(icon),
            const SizedBox(width: 16),

            /// Orta kısımda başlık
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            /// Sağ tarafta ileriye gitmek için ok
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Çıkış (logout) plotağı - kırmızı stillendirilmiş
  /// Kullanıcını login ekranına geri göndürür
  Widget _logoutTile() {
    return GestureDetector(
      onTap: () {
        // Çıkış yap - login ekranına dön
        Navigator.pushReplacementNamed(context, "/");
      },
      child: _glassContainer(
        borderColor: Colors.red.withOpacity(0.3), // Kırmızı sınır
        child: Row(
          children: [
            /// Sol tarafta kırmızı icon daire
            _iconCircle(
              Icons.logout,
              bgColor: Colors.red.withOpacity(0.2),
              iconColor: Colors.red,
            ),
            const SizedBox(width: 16),

            /// Orta kısımda kırmızı "Çıkış Yap" metni
            const Expanded(
              child: Text(
                "Çıkış Yap",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= KÖŞELLEŞTİRİLMİŞ UI YARDIMÇI FONKSİYONLARI =================

  /// İcon dairesi - yan tarafta ufak renkli daire içinde ikon gösterir
  /// Kullanıcı arabirimi için görsel tutarlılık sağlar
  Widget _iconCircle(
    IconData icon, {
    Color bgColor = const Color(0xFF1E293B),
    Color iconColor = Colors.blue,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor, // Daire arka planı
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor), // Ikon
    );
  }

  /// Buzlu cam efekti ile kapsayıcı - "frosted glass" stili
  /// Arka planın hafifçe görülmesini sağlar
  Widget _glassContainer({
    required Widget child,
    Color borderColor = const Color(0x33FFFFFF),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        /// Bulanık filtre - arka planı donuk yapıyor
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Saydam beyaz arka plan
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            // Saydam beyaz sınır
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Bölüm başlığı - "Genel Ayarlar" gibi başlıklar için
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Dairesel buton - geri dönüş düğmesi gibi
  /// Hover etkilerine hazır ve tıklanabilir
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // Saydam beyaz
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  /// Alt gezinti çubuğu - frosted glass stil
  /// Fuzzy glass efekti ile saydam arka plan gösterir
  Widget _bottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        /// Bulanık filtre - arka planı donuk yapıyor
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            // Saydam beyaz arka plan
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(40),
          ),

          /// Dört navigasyon simgesi
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home, 0), // Anasayfa
              _navIcon(Icons.chat_bubble, 1), // Sohbet
              _navIcon(Icons.history, 2), // Geçmiş
              _navIcon(Icons.settings, 3, selected: true), // Ayarlar (şu anki)
            ],
          ),
        ),
      ),
    );
  }

  /// Navigasyon simgesi - tıklanabilir icon
  /// Tıklanınca ilgili sayfaya yönlendir
  Widget _navIcon(IconData icon, int index, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        // İndekse göre yönlendir
        switch (index) {
          case 0: // Anasayfa
            Navigator.pushReplacementNamed(context, StudentRoutes.dashboard);
            break;
          case 1: // Sohbet
            Navigator.pushReplacementNamed(context, StudentRoutes.chat);
            break;
          case 2: // Geçmiş
            Navigator.pushReplacementNamed(context, StudentRoutes.history);
            break;
          case 3: // Ayarlar (zaten buradayız)
            break;
        }
      },
      child: Icon(
        icon,
        color: selected ? Colors.blue : Colors.grey,
      ), // Seçili = mavi
    );
  }
}

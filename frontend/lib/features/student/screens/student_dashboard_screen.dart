import 'package:flutter/material.dart';
import 'dart:ui';
import '../student_routes.dart';

/// Öğrenci ana kontrol paneli ekranı
/// Bu ekran, öğrencinin duygusal durumunu takip etmek ve RIBA asistanına erişmek için arayüz sağlar
class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  /// Seçilen alt navigasyon öğesinin indeksi
  int _selectedIndex = 0;

  /// Alt navigasyonda bir öğe dokunulduğunda çalışır
  /// Seçilen öğeyi işaretler ve ilgili sayfaya yönlendirir
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, StudentRoutes.dashboard);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, StudentRoutes.chat);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, StudentRoutes.history);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, StudentRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0F172A,
      ), // ===== Koyu mavi arka plan rengi =====
      // ---------- ÜST BAŞLIK ÇUBUĞU (APP BAR) ----------
      // /// Kullanıcı ID'si, selamlaşma mesajı ve bildirim simgesini gösterir
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF0F172A,
        ), // AppBar arka planı - uyumlu koyu mavi renk
        elevation: 0, // Gölge efekti kapalı
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Öğrenci ID etiketi - mavi renk ile vurgulanmış
            Text(
              "Öğrenci ID: S-2041",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),

            /// Selamlaşma mesajı - ana başlık
            Text(
              "Selam! Bugün kendini nasıl hissediyorsun?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          /// Bildirim simgesi - sağ üst köşede
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications),
          ),
        ],
      ),

      // ---------- ANA SAYFA İÇERİĞİ ----------
      // Kaydırılabilir görünüm: Duygu kartı, risk durumu, yapay zeka desteği, son duygular
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DUYGU HALINE İLİŞKİN KART - Öğrencinin mevcut duygusunu seçmesini ve metin girmesini sağlar
            _buildMoodCard(),

            const SizedBox(height: 20),

            /// SAĞLIK DURUMU KARTI - Öğrencinin duygusal risk seviyesini gösterir
            _buildRiskCard(),

            const SizedBox(height: 20),

            /// RIBA YAPAY ZEKA ASISTANI KARTI - Sohbet özelliğine hızlı erişim sağlar
            _buildAISupportCard(),

            const SizedBox(height: 20),

            /// SON KAYIT EDILEN DUYGULAR - Geçmiş duygu kayıtlarını görüntüler
            _buildRecentMoods(),
          ],
        ),
      ),

      // ---------- KAYAN AKSIYON DÜĞMESI ----------
      // Sohbet ekranına hızlı giriş sağlar
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushNamed(context, StudentRoutes.chat);
        },
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ---------- ALT GEZINTI ÇUBUĞU ----------
      // Dört ana sayfa arasında gezinti sağlar: Anasayfa, Sohbet, Geçmiş, Ayarlar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ================= İNŞA EDİCİ FONKSİYONLAR (WIDGET BİLEŞENLERİ) =================

  /// Alt navigasyon öğesi (simge + etiket)
  /// Seçili duruma göre rengi değişir (mavi/gri)
  Widget _navItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// /// DUYGU HAL İNE İLİŞKİN KART OLUŞTURUR
  /// Dordü duygu seçim düğmesini (😊 😐 😔 😰) ve metin giriş alanını içerir
  /// Kullanıcı duygusal durumunu seçer ve açıklama yazabilir
  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Kart başlığı
          const Text(
            "Kendini nasıl hissediyorsun?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Duygu seçim düğmeleri - 4 farklı duygu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _moodButton("😊", "Mutlu"),
              _moodButton("😐", "Nötr"),
              _moodButton("😔", "Üzgün"),
              _moodButton("😰", "Kaygılı"),
            ],
          ),
          const SizedBox(height: 16),

          /// Açıklama metin alanı - isteğe bağlı
          TextField(
            decoration: InputDecoration(
              hintText: "Bir şey paylaşmak ister misin?",
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// /// DUYGU SEÇİM DÜĞMESI OLUŞTURUR
  /// Emoji ve duygu adını içeren dairesel buton
  /// Parametreler: emoji = duygusal simge, label = duygu adı (Türkçe)
  Widget _moodButton(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        /// Tıklanınca günlük duygu kontrol ekranını aç
        Navigator.pushNamed(context, StudentRoutes.moodCheckIn);
      },
      child: Column(
        children: [
          /// Dairesel buton - emoji içerir
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),

          /// Duygu adı metni
          Text(label),
        ],
      ),
    );
  }

  /// /// SAĞLIK VE RİSK DURUMU KARTI OLUŞTURUR
  /// Öğrencinin duygusal risk seviyesini gösterir
  /// Risk durumunu basit bir mesajla sunar
  Widget _buildRiskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Kart başlığı
          Text(
            "Ruh Sağlığı Durumu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          /// Risk analiz sonucu - olumlu mesaj
          Text("Düşük duygusal risk tespit edildi. Harika gidiyorsun!"),
        ],
      ),
    );
  }

  /// /// RIBA YAPAY ZEKA ASISTANI KARTI OLUŞTURUR
  /// Mavi gradyan arka planı ile tasarlanmış, sohbet özelliğine hızlı erişim sağlar
  /// Gizli ve güvenli sohbet hakkında bilgi verir
  Widget _buildAISupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        /// Mavi-indigo gradyan - dikkat çekici tasarım
        gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Kart başlığı
          const Text(
            "RIBA Asistanıyla Konuş",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// Açıklayıcı metin - gizlilik bilgisi
          const Text("Her zaman ihtiyacın olduğunda güvenli ve gizli sohbet."),
          const SizedBox(height: 20),

          /// Sohbete başlatma düğmesi
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              /// Sohbet ekranına yönlendir
              Navigator.pushNamed(context, StudentRoutes.chat);
            },
            child: const Text("Sohbete Başla"),
          ),
        ],
      ),
    );
  }

  /// /// SON KAYIT EDILEN DUYGULAR BÖLÜMÜ OLUŞTURUR
  /// Geçmiş duygu kayıtlarını küçük liste halinde gösterir
  /// "Tümünü Gör" butonu ile tüm geçmiş kaydına erişim sağlar
  Widget _buildRecentMoods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Başlık ve "Tümünü Gör" seçeneği içeren üst kısım
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Bölüm başlığı
            const Text(
              "Son Duygular",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            /// Geçmiş sayfasına yönlendiren buton
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, StudentRoutes.history);
              },
              child: const Text("Tümünü Gör"),
            ),
          ],
        ),
        const SizedBox(height: 10),

        /// Son üç duygu kaydı
        _recentItem("Sakin"),
        _recentItem("Mutlu"),
        _recentItem("Düşünceli"),
      ],
    );
  }

  /// /// GEÇMIŞ DUYGU ÖĞESİ OLUŞTURUR
  /// Tek bir duygu kaydını listeye ekleme tarzında gösterir
  /// Parametreler: title = duygu adı (Türkçe)
  Widget _recentItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        /// Duygu adı ve ileri simgesi
        children: [Text(title), const Icon(Icons.arrow_forward_ios, size: 16)],
      ),
    );
  }

  /// /// KART DEKORASYONUNU OLUŞTURUR
  /// Tüm kartlar için standart stil tanımı
  /// Koyu arka plan rengi (Color(0xFF1E293B)) ve yuvarlatılmış köşeler içerir
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      /// Kart arka planı - uyumlu koyu ton
      color: const Color(0xFF1E293B),

      /// Köşeleri yuvarlatma
      borderRadius: BorderRadius.circular(20),
    );
  }

  /// Alt gezinti çubuğu - frosted glass stil
  /// Fuzzy glass efekti ile saydam arka plan gösterir
  Widget _buildBottomNav() {
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
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(Icons.home, 0), // Anasayfa
                _buildNavIcon(Icons.chat_bubble, 1), // Sohbet
                _buildNavIcon(Icons.history, 2), // Geçmiş
                _buildNavIcon(Icons.settings, 3), // Ayarlar
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigasyon simgesi - tıklanabilir icon
  /// Tıklanınca ilgili sayfaya yönlendir
  Widget _buildNavIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Icon(
        icon,
        color: _selectedIndex == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}

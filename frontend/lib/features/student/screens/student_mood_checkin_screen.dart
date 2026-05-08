/// AMAÇ: Öğrencinin günlük duygu durumunu kontrol etmesi için kullanıcı arayüzü
/// Bu ekran, duygu seçimi, yoğunluk seviyesi, nedenleri ve açıklamaları kaydeder

import 'package:flutter/material.dart';
import 'dart:ui';
import '../student_routes.dart';

/// Duygu kontrol ekranı (Stateful Widget)
/// Kullanıcı etkileşimlerine göre durumu dinamik olarak güncellemek için Stateful kullanıldı
class StudentMoodCheckInScreen extends StatefulWidget {
  const StudentMoodCheckInScreen({super.key});

  @override
  State<StudentMoodCheckInScreen> createState() =>
      _StudentMoodCheckInScreenState();
}

class _StudentMoodCheckInScreenState extends State<StudentMoodCheckInScreen> {
  /// Seçilen duygu indeksi (0-4 arası)
  int selectedMood = 0;

  /// Duygu yoğunluğu seviyesi (1-10 arası slider değeri)
  double intensity = 4;

  /// Duyguları temsil eden emoji listesi
  final List<String> moods = ["😊", "😐", "😔", "😟", "😌"];

  /// Her duygumun Türkçe açıklaması
  final List<String> moodLabels = [
    "Mutlu",
    "Nötr",
    "Üzgün",
    "Kaygılı",
    "Sakin",
  ];

  /// Duyguların olası nedenleri (çoklu seçim için)
  final List<String> reasons = [
    "Okul",
    "Aile",
    "Arkadaşlar",
    "Sınav",
    "Sosyal Medya",
    "Genel",
  ];

  /// Kullanıcı tarafından seçilen nedenlerin listesi
  List<String> selectedReasons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// === Arka plan rengi - koyu mavi tema ===
      backgroundColor: const Color(0xFF0F172A),

      /// === BAŞLIK ÇUBUĞU (APP BAR) ===
      /// Sayfa başlığı ve geri dönüş düğmesi içerir
      appBar: AppBar(
        backgroundColor: const Color(
          0xFF0F172A,
        ), // AppBar arka planı - uyumlu renk
        elevation: 0, // Gölge efekti kapalı
        /// Geri dönüş düğmesi - önceki sayfaya geri götürür
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Günlük Duygu Kontrolü",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 2),
            Text(
              "Bugünkü ruh halini paylaş",
              style: TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- DUYGU SEÇİM BÖLÜMÜ ----------
                /// Kullanıcı beş duygulardan birini seçebilir (emoji + etiket)
                /// Animasyon yapılarak seçilme durumu gösterilir
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      // Mevcut öğenin seçilip seçilmediğini kontrol et
                      bool isSelected = selectedMood == index;

                      return GestureDetector(
                        onTap: () {
                          // Dokunulduğunda bu duyguyu seçili yap
                          setState(() {
                            selectedMood = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [
                              /// Animasyonlu kapsayıcı - seçilme durumunu gösterir
                              AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 200,
                                ), // 200ms animasyon süresi
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  // Seçiliyse mavi transparan, değilse gri
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors
                                              .blue // Seçili - mavi sınır
                                        : Colors
                                              .grey
                                              .shade800, // Seçilmemiş - gri sınır
                                    width: isSelected
                                        ? 2
                                        : 1, // Seçiliyse kalın sınır
                                  ),
                                ),
                                // Emoji gösterimi
                                child: Text(
                                  moods[index],
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Duygu etiketi (Türkçe adı)
                              Text(
                                moodLabels[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors
                                            .blue // Seçili - mavi metin
                                      : Colors.grey, // Seçilmemiş - gri metin
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                /// ---------- YOĞUNLUK SEVİYESİ BÖLÜMÜ ----------
                /// 1-10 arasında slider ile duygusal yoğunluğu seçer
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık - ne sorulduğunu açıklar
                      const Text(
                        "Bugün kendini ne kadar yoğun hissediyorsun?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      /// Slider kontrol - 1 ile 10 arasında değer seçebilir
                      Slider(
                        value: intensity,
                        min: 1, // Minimum 1
                        max: 10, // Maksimum 10
                        divisions: 9, // 9 adım (10 değer)
                        activeColor: Colors.blue,
                        onChanged: (val) {
                          // Slider hareket ettikçe değeri güncelle
                          setState(() {
                            intensity = val;
                          });
                        },
                      ),

                      /// Slider etiketleri - minimum ve maksimum değerler
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "1 - Çok Az",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "10 - Aşırı",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// ---------- DUYGU NEDENİ BÖLÜMÜ ----------
                /// Çoklu seçim - kullanıcı birden fazla neden seçebilir
                const Text(
                  "Buna ne sebep oluyor?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// Çoklu seçim butonları - kullanıcı birden fazla neden seçebilir
                Wrap(
                  spacing: 10, // Düğmeler arası yatay boşluk
                  runSpacing: 10, // Satırlar arası dikey boşluk
                  children: reasons.map((reason) {
                    // Mevcut nedenin seçilip seçilmediğini kontrol et
                    bool isSelected = selectedReasons.contains(reason);

                    return GestureDetector(
                      onTap: () {
                        // Dokunulduğunda seçim durumunu aç/kapat
                        setState(() {
                          if (isSelected) {
                            selectedReasons.remove(reason); // Listeden kaldır
                          } else {
                            selectedReasons.add(reason); // Listeye ekle
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // Seçiliyse mavi transparan, değilse gri
                          color: isSelected
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.grey[900],
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Köşeli düğme
                          border: Border.all(
                            color: isSelected
                                ? Colors
                                      .blue // Seçili - mavi sınır
                                : Colors
                                      .grey
                                      .shade800, // Seçilmemiş - gri sınır
                          ),
                        ),
                        // Neden metni
                        child: Text(
                          reason,
                          style: TextStyle(
                            color: isSelected
                                ? Colors
                                      .blue // Seçili - mavi metin
                                : Colors.grey, // Seçilmemiş - gri metin
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                /// ---------- AÇIKLAMA NOTU BÖLÜMÜ ----------
                /// Öğrenci opsiyonel olarak ayrıntılı açıklama yazabilir
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    maxLines: 5, // Maksimum 5 satır
                    maxLength: 200, // Maksimum 200 karakter
                    decoration: InputDecoration(
                      hintText: "İstersen biraz daha detay paylaşabilirsin...",
                      border: InputBorder.none, // Sınır yok
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------- KAYDET DÜĞMESI ----------
                /// Tüm bilgileri kaydedip önceki ekrana döner
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        StudentRoutes.chatDetail,
                        arguments: {
                          "mood": moodLabels[selectedMood],
                          "intensity": intensity,
                        },
                      );
                    },
                    child: const Text(
                      "Kaydet ve Devam Et",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
              _navIcon(Icons.history, 2, context),
              _navIcon(Icons.settings, 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, BuildContext context) {
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
            Navigator.pushReplacementNamed(context, StudentRoutes.history);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, StudentRoutes.settings);
            break;
        }
      },
      child: Icon(icon, color: Colors.grey),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';

/// AMAÇ: RIBA ile birebir sohbet detay ekranı
/// Bu ekran, belirli bir sohbete girildiğinde mesaj akışını, hızlı duygu seçim çiplerini
/// ve mesaj giriş alanını gösterir. Tasarım koyu temaya uygun şekilde stilize edilmiştir.
class StudentChatDetailScreen extends StatefulWidget {
  const StudentChatDetailScreen({super.key});

  @override
  State<StudentChatDetailScreen> createState() =>
      _StudentChatDetailScreenState();
}

class _StudentChatDetailScreenState extends State<StudentChatDetailScreen> {
  /// Metin alanı kontrolcüsü - gönderilecek mesajı tutmak için
  final TextEditingController controller = TextEditingController();

  /// Mesaj listesini tutar. Her öğe bir harita: {"sender": "user"|"bot", "text": "..."}
  final List<Map<String, String>> _messages = [
    {
      "sender": "bot",
      "text":
          "Merhaba! Bugün kendini nasıl hissediyorsun? Seninle konuşmak için buradayım 💙",
    },
  ];

  /// Scroll controller: yeni mesaj gönderildiğinde listeyi sona kaydırmak için
  final ScrollController _listController = ScrollController();

  /// Chat ID
  final String _chatId = 'default-chat-001';

  /// Loading state
  bool _isLoading = false;

  /// Seçili duygu durumu (mood). Backend prompt'una eklenir.
  String? _selectedMood;

  /// Mood chip listesi: (etiket -> backend'e gidecek metin)
  static const List<Map<String, String>> _moodOptions = [
    {'emoji': '🙂', 'label': 'İyiyim', 'value': 'iyi'},
    {'emoji': '😟', 'label': 'Kaygılıyım', 'value': 'kaygılı'},
    {'emoji': '😢', 'label': 'Üzgünüm', 'value': 'üzgün'},
    {'emoji': '😡', 'label': 'Kızgınım', 'value': 'kızgın'},
    {'emoji': '😶', 'label': 'Yalnızım', 'value': 'yalnız'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      // ---------- APP BAR ----------
      // Başlıkta asistan adı, çevrimiçi gösterge ve bilgi butonu bulunur
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Önceki ekrana dön
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Text(
                  "RIBA Asistan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 6),
                // Küçük yeşil nokta: asistanın çevrimiçi/aktif olduğunu gösterir
                CircleAvatar(radius: 4, backgroundColor: Colors.green),
              ],
            ),
            SizedBox(height: 2),
            Text(
              "Gizli ve güvenli sohbet",
              style: TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.info_outline), // Bilgi butonu (detaylar)
          ),
        ],
      ),

      // ---------- BODY ----------
      body: Column(
        children: [
          /// CHAT AREA: Mesaj listesini içerir
          /// Koyu tonlarda gradyan arka plan ve mesaj baloncukları
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                controller: _listController,
                itemCount: _messages.length + 1, // +1 for the date chip at top
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Tarih etiketi
                    return Column(
                      children: [
                        const SizedBox(height: 4),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "BUGÜN",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white54,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }

                  final msg = _messages[index - 1];
                  final sender = msg['sender'] ?? 'bot';
                  final text = msg['text'] ?? '';

                  // Bot mesajı (solda ikon ile)
                  if (sender == 'bot') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3994EF).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              color: Color(0xFF3994EF),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                text,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Kullanıcı mesajı (sağa hizalı)
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3994EF), Colors.blue],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          text,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// MOOD SEÇİCİ: yatay kaydırılabilir duygu çipi listesi
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _moodOptions.length,
              itemBuilder: (context, index) {
                final m = _moodOptions[index];
                final value = m['value']!;
                final isSelected = _selectedMood == value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = isSelected ? null : value;
                    });
                  },
                  child: _chip(m['emoji']!, m['label']!, selected: isSelected),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          /// MESAJ GİRİŞ ALANI
          /// TextField ve Gönder butonu içerir
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Row(
              children: [
                /// Metin giriş alanı - yuvarlatılmış kapsayıcı içinde
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Bir şey paylaşmak ister misin?",
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// Gönder düğmesi - dairesel mavi buton
                GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3994EF),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  /// Mesaj gönderme: kullanıcının yazdığı metni `_messages`'e ekler,
  /// backend'e gönderir, bot cevabı alır ve listeyi sona kaydırır.
  void _handleSend() async {
    final text = controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _isLoading = true;
    });

    controller.clear();

    try {
      debugPrint(
        'Sending chat (base: ${ApiConfig.apiBaseUrlV1}, mood: $_selectedMood)',
      );

      // Önceki konuşma turlarını backend'e prompt context'i olarak yolla.
      // Son eklenen kullanıcı mesajını history'ye dahil etme (zaten 'text' alanı olarak gidiyor).
      final history = _messages
          .take(_messages.length - 1)
          .map(
            (m) => {
              'role': (m['sender'] ?? 'bot') == 'user' ? 'user' : 'bot',
              'text': m['text'] ?? '',
            },
          )
          .toList();

      final responseData = await ApiService().sendChatMessage(
        _chatId,
        text,
        mood: _selectedMood,
        history: history,
      );

      if (responseData['success'] == false) {
        final err = responseData['error']?.toString() ?? 'Sunucu hatası';
        _showErrorSnackBar(err);
        setState(() {
          _isLoading = false;
        });
      } else {
        // Backend yeni 'reply', eski yapı 'bot_response' döndürüyor.
        final dynamic replyValue =
            responseData['reply'] ?? responseData['bot_response'];
        final botResponse = replyValue?.toString().trim() ?? '';

        if (botResponse.isEmpty) {
          _showErrorSnackBar('Bot yanıtı alınamadı');
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _messages.add({'sender': 'bot', 'text': botResponse});
            _isLoading = false;
          });
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_listController.hasClients) {
          _listController.animateTo(
            _listController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
      _showErrorSnackBar(ApiConfig.userMessageForError(e));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Tek bir duygu çipi oluşturur
  /// `selected` true ise farklı renk/stil uygulanır
  Widget _chip(String emoji, String text, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF3994EF).withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: selected ? const Color(0xFF3994EF) : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _listController.dispose();
    super.dispose();
  }

  Widget _bottomNav() {
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
              _navIcon(Icons.home, 0),
              _navIcon(Icons.chat_bubble, 1, selected: true),
              _navIcon(Icons.history, 2),
              _navIcon(Icons.settings, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        // Navigasyon işlemleri
      },
      child: Icon(
        icon,
        color: selected ? const Color(0xFF3994EF) : Colors.grey,
      ),
    );
  }
}

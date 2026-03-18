import 'package:flutter/material.dart';

class ParentChatScreen extends StatelessWidget {
  const ParentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1220),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ayşe Yılmaz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Rehber Öğretmen',
              style: TextStyle(color: Colors.blueAccent, fontSize: 12),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      /// BODY
      body: SafeArea(
        child: Column(
          children: [
            /// ÜST KARTLAR
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.sentiment_very_satisfied,
                      title: "Çocuğun Durumu",
                      subtitle: "Bugün her şey yolunda görünüyor",
                      iconColor: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.notifications,
                      title: "Öğretmen Bildirimi",
                      subtitle: "1 yeni geri bildirim var",
                      iconColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),

            const Text(
              "BUGÜN",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),

            /// MESAJ LİSTESİ
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: const [
                  _ChatBubble(
                    message:
                        "Selamlar, bugün öğrencimizle bir görüşme yaptık. Durumu gayet iyi görünüyor.",
                    time: "14:20",
                    isMe: false,
                  ),
                  _ChatBubble(
                    message:
                        "Merhabalar hocam, çok sevindim. Detayları akşam konuşalım.",
                    time: "14:25",
                    isMe: true,
                  ),
                ],
              ),
            ),

            /// INPUT
            _MessageInput(),
          ],
        ),
      ),
    );
  }

  /// ÜST KART
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// MESAJ BALONU (ayrı widget → temiz yapı)
class _ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const _ChatBubble({
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : const Color(0xFF1A2235),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// INPUT ALANI (ayrı widget → temiz yapı)
class _MessageInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        children: [
          _circleButton(Icons.add),
          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2235),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Mesajınızı yazın...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),
          _circleButton(Icons.send, color: Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF1A2235),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

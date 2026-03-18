import 'package:flutter/material.dart';

class ParentNotificationsScreen extends StatelessWidget {
  const ParentNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF101C22);

    return Scaffold(
      backgroundColor: bgDark,

      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        title: const Text("Bildirimler"),
      ),

      body: const Center(
        child: Text(
          "Henüz bildirim yok",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}

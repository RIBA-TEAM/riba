/// AMAÇ: RIBA uygulamasının ana giriş noktası
/// Uygulama temasını, yapısını ve ilk ekranı tanımlar

import 'package:flutter/material.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/student/student_routes.dart';
import 'features/parent/parent_routes.dart'; // ✅ EKLENDİ

/// Uygulamanın başlangıç noktası
void main() {
  runApp(const MyApp());
}

/// Ana uygulama widgeti
/// Material Design teması ve yönlendirmeyi yapılandırır
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug banner gizle
      title: 'RIBA',

      /// Uygulama teması - koyu tema (dark mode)
      theme: ThemeData(
        brightness: Brightness.dark, // Koyu mod
        primarySwatch: Colors.blue, // Ana renk - mavi
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Koyu mavi arka plan
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B), // AppBar arka planı
        ),
      ),

      /// Uygulamanın giriş sayfası
      home: const LoginScreen(),

      /// Tüm sayfalar için yönlendirme yapılandırması
      routes: {
        ...StudentRoutes.routes, // Öğrenci modülü rotaları
        ...ParentRoutes.routes, // ✅ Parent modülü rotaları eklendi
      },
    );
  }
}

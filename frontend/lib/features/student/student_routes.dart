/// AMAÇ: Öğrenci özelliği içindeki tüm sayfaların yönlendirme tanımı
/// Route koşulları ve sayfa bileşenleri bu dosyada merkezi olarak yönetilir

import 'package:flutter/material.dart';
import 'package:frontend/features/student/screens/student_chat_detail_screen.dart';
import 'screens/student_dashboard_screen.dart';
import 'screens/student_chat_screen.dart';
import 'screens/student_history_screen.dart';
import 'screens/student_settings_screen.dart';
import 'screens/student_mood_checkin_screen.dart';

/// Öğrenci modülü yönlendirme sınıfı
/// Sayfalar arası gezinti için route tanımlarını içerir
class StudentRoutes {
  /// Ana kontrol paneli sayfası
  static const dashboard = "/studentDashboard";

  /// Sohbet ekranı - RIBA asistanıyla konuşma
  static const chat = "/studentChat";

  /// Geçmiş duygu kayıtları
  static const history = "/studentHistory";

  /// Ayarlar ekranı
  static const settings = "/studentSettings";

  /// Günlük duygu kontrolü ekranı
  static const moodCheckIn = "/studentMoodCheckIn";

  static const chatDetail = "/studentChatDetail";
  /// Tüm sayfaların route haritası
  /// Bu harita uygulamada kullanılan tüm navigation yollarını içerir
  static Map<String, WidgetBuilder> routes = {
    dashboard: (context) => const StudentDashboardScreen(),
    chat: (context) => const StudentChatScreen(),
    history: (context) => const StudentHistoryScreen(),
    settings: (context) => const StudentSettingsScreen(),
    moodCheckIn: (context) => const StudentMoodCheckInScreen(),
    chatDetail: (context) => const StudentChatDetailScreen(),
  };
}

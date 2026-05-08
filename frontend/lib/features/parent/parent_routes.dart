import 'package:flutter/material.dart';
import 'screens/parent_appointments_screen.dart';
import 'screens/parent_book_appointment_screen.dart';
import 'screens/parent_calendar_screen.dart';
import 'screens/parent_chat_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/parent_messages_screen.dart';
import 'screens/parent_notifications_screen.dart';
import 'screens/parent_system_info_screen.dart';
import 'screens/parent_profile_settings_screen.dart';

class ParentRoutes {
  // Route names
  static const String calendar = '/parent/calendar';
  static const String chat = '/parent/chat';
  static const String dashboard = '/parent/dashboard';
  static const String messages = '/parent/messages';
  static const String notifications = '/parent/notifications';
  static const String system = '/parent/system';
  static const String profile = '/parent/profile';
  static const String bookAppointment = '/parent/book-appointment';
  static const String myAppointments = '/parent/appointments';

  /// Register this in MaterialApp(routes: ParentRoutes.routes, ...)
  static Map<String, WidgetBuilder> get routes => {
    chat: (_) => const ParentChatScreen(),
    dashboard: (_) => const ParentDashboardScreen(),
    messages: (_) => const ParentMessagesScreen(),
    notifications: (_) => const ParentNotificationsScreen(),
    system: (_) => const ParentSystemInfoScreen(),
    profile: (_) => const ParentProfileSettingsScreen(),
    calendar: (_) => const ParentCalendarScreen(),
    bookAppointment: (_) => const ParentBookAppointmentScreen(),
    myAppointments: (_) => ParentAppointmentsScreen(),
  };

  /// Optional helper for safer navigation.
  ///
  /// IMPORTANT: We pass `settings: settings` so that arguments provided
  /// via `Navigator.pushNamed(context, route, arguments: ...)` are
  /// forwarded to the target screen via `ModalRoute.of(context)?.settings`.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chat:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentChatScreen(),
        );
      case dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentDashboardScreen(),
        );
      case messages:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentMessagesScreen(),
        );
      case notifications:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentNotificationsScreen(),
        );
      case system:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentSystemInfoScreen(),
        );
      case profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentProfileSettingsScreen(),
        );
      case calendar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentCalendarScreen(),
        );
      case bookAppointment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ParentBookAppointmentScreen(),
        );
      case myAppointments:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ParentAppointmentsScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const _ParentUnknownRouteScreen(),
        );
    }
  }
}

class _ParentUnknownRouteScreen extends StatelessWidget {
  const _ParentUnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Unknown Parent Route', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

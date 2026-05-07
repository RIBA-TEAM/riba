import 'package:flutter/material.dart';
<<<<<<< arzu

import 'screens/parent_chat_screen.dart';
=======
import 'screens/parent_calendar_screen.dart';
>>>>>>> develop
import 'screens/parent_dashboard_screen.dart';
import 'screens/parent_messages_screen.dart';
import 'screens/parent_system_info_screen.dart';
import 'screens/parent_profile_settings_screen.dart';
import 'screens/parent_notifications_screen.dart';

class ParentRoutes {
  // Route names
  static const String calendar = '/parent/calendar';
  static const String dashboard = '/parent/dashboard';
  static const String messages = '/parent/messages';
  static const String system = '/parent/system';
  static const String profile = '/parent/profile';
  static const String notifications = '/parent/notifications';
  static const String chat = '/parent/chat';

  /// ROUTES MAP
  static Map<String, WidgetBuilder> get routes => {
    dashboard: (_) => const ParentDashboardScreen(),
    messages: (_) => const ParentMessagesScreen(),
    system: (_) => const ParentSystemInfoScreen(),
    profile: (_) => const ParentProfileSettingsScreen(),
    notifications: (_) => const ParentNotificationsScreen(),
    chat: (_) => const ParentChatScreen(),
  };

  /// SAFER NAVIGATION (optional ama profesyonel)
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const ParentDashboardScreen());

      case messages:
        return MaterialPageRoute(builder: (_) => const ParentMessagesScreen());

      case system:
        return MaterialPageRoute(
          builder: (_) => const ParentSystemInfoScreen(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ParentProfileSettingsScreen(),
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const ParentNotificationsScreen(),
        );

      case chat:
        return MaterialPageRoute(builder: (_) => const ParentChatScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const _ParentUnknownRouteScreen(),
        );
    }
  }
}

/// UNKNOWN ROUTE SCREEN
class _ParentUnknownRouteScreen extends StatelessWidget {
  const _ParentUnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sayfa bulunamadı', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

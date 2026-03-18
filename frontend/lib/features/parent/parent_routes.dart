import 'package:flutter/material.dart';
import 'screens/parent_calendar_screen.dart';
import 'screens/parent_dashboard_screen.dart';
import 'screens/parent_messages_screen.dart';
import 'screens/parent_system_info_screen.dart';
import 'screens/parent_profile_settings_screen.dart';

class ParentRoutes {
  // Route names
  static const String calendar = '/parent/calendar';
  static const String dashboard = '/parent/dashboard';
  static const String messages = '/parent/messages';
  static const String system = '/parent/system';
  static const String profile = '/parent/profile';

  /// Register this in MaterialApp(routes: ParentRoutes.routes, ...)
  static Map<String, WidgetBuilder> get routes => {
    dashboard: (_) => const ParentDashboardScreen(),
    messages: (_) => const ParentMessagesScreen(),
    system: (_) => const ParentSystemInfoScreen(),
    profile: (_) => const ParentProfileSettingsScreen(),
    calendar: (_) => const ParentCalendarScreen(),
  };

  /// Optional helper for safer navigation
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
         case calendar:
      return MaterialPageRoute(
        builder: (_) => const ParentCalendarScreen(),
      );
      default:
        return MaterialPageRoute(
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

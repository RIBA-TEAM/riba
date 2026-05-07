import 'dart:ui';
import 'package:flutter/material.dart';

class ParentDrawer extends StatelessWidget {
  const ParentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: const Color(0xFF101C22).withOpacity(0.95),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  /// HEADER
                  Column(
                    children: const [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Parent Panel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// MENU ITEMS
                  _drawerItem(
                    context,
                    icon: Icons.dashboard,
                    title: "Dashboard",
                    route: '/parent/dashboard',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.mail_outline,
                    title: "Messages",
                    route: '/parent/messages',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    route: '/parent/notifications',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: "System Information",
                    route: '/parent/system',
                  ),

                  _drawerItem(
                    context,
                    icon: Icons.settings,
                    title: "Profile Settings",
                    route: '/parent/profile',
                  ),

                  const Spacer(),

                  /// LOGOUT
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}

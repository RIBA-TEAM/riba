import 'dart:ui';
import 'package:flutter/material.dart';

class ParentBottomNav extends StatelessWidget {
  const ParentBottomNav({super.key, required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    Widget item({
      required int index,
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      final bool active = index == selectedIndex;
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: active
                      ? primary
                      : (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? primary
                        : (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF101C22).withOpacity(0.60)
                : Colors.white.withOpacity(0.70)),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.10 : 0.25,
                ),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              item(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () {
                  // zaten home
                },
              ),
              item(
                index: 1,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                onTap: () {
                  // TODO: /parent/chat (ileride)
                },
              ),
              item(
                index: 2,
                icon: Icons.calendar_today_outlined,
                label: 'Calendar',
                onTap: () {
                  // TODO: /parent/calendar (ileride)
                },
              ),
              item(
                index: 3,
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.pushNamed(context, '/parent/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

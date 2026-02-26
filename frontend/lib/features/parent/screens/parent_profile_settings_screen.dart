import 'dart:ui';
import 'package:flutter/material.dart';

class ParentProfileSettingsScreen extends StatefulWidget {
  const ParentProfileSettingsScreen({super.key});

  @override
  State<ParentProfileSettingsScreen> createState() =>
      _ParentProfileSettingsScreenState();
}

class _ParentProfileSettingsScreenState
    extends State<ParentProfileSettingsScreen> {
  bool pushNotifications = true;
  bool emailAlerts = false;
  bool faceId = true;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const bgDark = Color(0xFF101C22);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Page background (dark)
          Container(color: bgDark),

          // Gradient header area
          Container(
            height: 340,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A2E38), primary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(0, 10),
                  color: Color(0x55000000),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Scroll content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header row (back - title - edit)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _CircleGlassIconButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () => Navigator.pop(context),
                              ),
                              const Text(
                                'Profile & Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              _CircleGlassIconButton(
                                icon: Icons.edit,
                                onTap: () {
                                  // TODO: edit profile
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Profile card (overlapping the header)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Transform.translate(
                            offset: const Offset(0, 56),
                            child: _GlassCard(
                              borderRadius: 20,
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                children: [
                                  // avatar with verified
                                  Stack(
                                    children: [
                                      Container(
                                        width: 96,
                                        height: 96,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.20,
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                          image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCahyULXpKdOdtYgxSz5GfbuvBl_--r9qi15yW3ywfsfhV6arC8MaZIJ39_9Xd3t62LJgqhRMWcdt6pWIfV7V8-1yHxapzXE2Hg2BLUtIXgBchrG_DPJA37fmrp4LCcPp9GT1NKgpa2c_BvdBPhm5H36vw_KfT9Ouj_pOFkvel0XV2v8pbKpdqKgBgPNaSzQQdMAttuBkS_e6YaJ2W09eSp-SMy8fZm8Y5cF5D0UQnt5y-k_SNCFp-MxmA57Vx54dED0swqgweN0tvj',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.verified,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Sarah Jenkins',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : const Color(0xFF111618),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'sarah.j@email.com',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFF6B7280),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.school,
                                          color: primary,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'LINKED STUDENT: ST-1024',
                                          style: TextStyle(
                                            color: primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 96),

                        // Settings sections
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SectionTitle('Preferences'),
                              _GlassGroup(
                                children: [
                                  _NavRow(
                                    iconBg: const Color(
                                      0xFF3B82F6,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFF3B82F6),
                                    icon: Icons.language,
                                    title: 'Language',
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'English (US)',
                                          style: TextStyle(
                                            color: Color(0xFF9CA3AF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // TODO: language picker
                                    },
                                  ),
                                  _SwitchRow(
                                    iconBg: const Color(
                                      0xFFF97316,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFFF97316),
                                    icon: Icons.notifications_active,
                                    title: 'Push Notifications',
                                    value: pushNotifications,
                                    onChanged: (v) =>
                                        setState(() => pushNotifications = v),
                                  ),
                                  _SwitchRow(
                                    iconBg: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFF10B981),
                                    icon: Icons.alternate_email,
                                    title: 'Email Alerts',
                                    value: emailAlerts,
                                    onChanged: (v) =>
                                        setState(() => emailAlerts = v),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              _SectionTitle('Security'),
                              _GlassGroup(
                                children: [
                                  _NavRow(
                                    iconBg: const Color(
                                      0xFFA855F7,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFFA855F7),
                                    icon: Icons.lock_reset,
                                    title: 'Change Password',
                                    trailing: const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                    onTap: () {
                                      // TODO: change password screen
                                    },
                                  ),
                                  _SwitchRow(
                                    iconBg: const Color(
                                      0xFF6366F1,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFF6366F1),
                                    icon: Icons.fingerprint,
                                    title: 'Face ID / Biometrics',
                                    value: faceId,
                                    onChanged: (v) =>
                                        setState(() => faceId = v),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              _SectionTitle('Account'),
                              _GlassGroup(
                                children: [
                                  _NavRow(
                                    iconBg: const Color(
                                      0xFF6B7280,
                                    ).withOpacity(0.10),
                                    iconColor: const Color(0xFF6B7280),
                                    icon: Icons.description,
                                    title: 'Privacy Policy',
                                    trailing: const Icon(
                                      Icons.open_in_new_rounded,
                                      color: Color(0xFF9CA3AF),
                                      size: 20,
                                    ),
                                    onTap: () {
                                      // TODO: open privacy policy
                                    },
                                  ),
                                  _LogoutRow(
                                    onTap: () {
                                      // TODO: logout -> back to Login
                                      // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              const Center(
                                child: Text(
                                  'RIBA v2.4.0 (Build 2024.102)',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom navigation (HTML’deki 5 ikonlu)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ProfileBottomNav(selectedIndex: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- COMPONENTS ----------------------------- */

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.borderRadius = 16, this.padding});

  final Widget child;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (isDark
                ? const Color(0xFF101C22).withOpacity(0.60)
                : Colors.white.withOpacity(0.70)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: (isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.30)),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CircleGlassIconButton extends StatelessWidget {
  const _CircleGlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: _GlassCard(
        borderRadius: 999,
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF6B7280),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _GlassGroup extends StatelessWidget {
  const _GlassGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 16,
      child: Column(children: _withDividers(children)),
    );
  }

  List<Widget> _withDividers(List<Widget> list) {
    final out = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      out.add(list[i]);
      if (i != list.length - 1) {
        out.add(_Divider());
      }
    }
    return out;
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      color: isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE5E7EB),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF111618),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF111618),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: primary),
        ],
      ),
    );
  }
}

class _LogoutRow extends StatelessWidget {
  const _LogoutRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBottomNav extends StatelessWidget {
  const _ProfileBottomNav({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    Widget item({
      required int index,
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool showDot = false,
      bool activeBold = false,
    }) {
      final active = index == selectedIndex;
      final color = active ? primary : const Color(0xFF9CA3AF);

      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, color: color, size: 28),
                    if (showDot)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: active ? primary : primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: active
                        ? (activeBold ? FontWeight.w900 : FontWeight.w800)
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.70),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.20), width: 1),
            ),
          ),
          child: Row(
            children: [
              item(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () => Navigator.pushNamed(context, '/parent/dashboard'),
              ),
              item(
                index: 1,
                icon: Icons.analytics,
                label: 'Reports',
                onTap: () {
                  // TODO: /parent/reports
                },
              ),
              item(
                index: 2,
                icon: Icons.person,
                label: 'Profile',
                showDot: true,
                activeBold: true,
                onTap: () {}, // zaten burası
              ),
              item(
                index: 3,
                icon: Icons.calendar_today,
                label: 'Events',
                onTap: () {
                  // TODO: /parent/events
                },
              ),
              item(
                index: 4,
                icon: Icons.contact_support,
                label: 'Support',
                onTap: () {
                  // TODO: /parent/support
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/parent_bottom_nav.dart';
import '../widgets/parent_dashboard_card.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const bgDark = Color(0xFF101C22);
    const tealDeep = Color(0xFF0D4D5E);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tealDeep, primary],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 96), // bottom nav boşluğu
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top App Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ParentGlassButton(
                            onTap: () {
                              // TODO: drawer / menu
                            },
                            icon: Icons.menu,
                          ),
                          const Text(
                            'RIBA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          ParentGlassButton(
                            onTap: () {
                              // TODO: notifications
                            },
                            icon: Icons.notifications_none_rounded,
                          ),
                        ],
                      ),
                    ),

                    // Welcome
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to the RIBA\nSupport Portal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your central hub for school support updates.',
                            style: TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Primary Status Card
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ParentPrimaryStatusCard(
                        imageAsset: 'assets/images/dashboard.jpg',
                        statusPillText: 'CURRENT STATUS',
                        title: 'Support process active',
                        subtitle: 'Guidance follow-up ongoing',
                        buttonText: 'View Full Details',
                        showGreenDot: true,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Navigation Section Title
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 10),
                      child: Text(
                        'DASHBOARD NAVIGATION',
                        style: TextStyle(
                          color: Color(0xE6FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    // Navigation Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ParentNavTile(
                            icon: Icons.mail_outline_rounded,
                            title: 'Messages from School',
                            subtitle: 'Check recent updates from counselors.',
                            onTap: () {
                              Navigator.pushNamed(context, '/parent/messages');
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.info_outline_rounded,
                            title: 'System Information',
                            subtitle: 'Learn more about the RIBA framework.',
                            onTap: () {
                              Navigator.pushNamed(context, '/parent/system');
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.person_outline_rounded,
                            title: 'Profile & Settings',
                            subtitle: 'Manage your notification preferences.',
                            onTap: () {
                              Navigator.pushNamed(context, '/parent/profile');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ParentBottomNav(selectedIndex: 0),
          ),

          // iOS Home indicator
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 64,
            bottom: 6,
            child: Container(
              width: 128,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.30),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

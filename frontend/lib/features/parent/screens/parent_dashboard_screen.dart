import 'package:flutter/material.dart';

import '../parent_routes.dart';
import '../widgets/parent_bottom_nav.dart';
import '../widgets/parent_dashboard_card.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const bgDark = Color(0xFF101C22);
    const tealDeep = Color(0xFF0D4D5E);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String parentId = args?['parentId'] ?? '';
    final String parentName = args?['parentName'] ?? 'Parent';
    final String studentId = args?['studentId'] ?? '';
    final String studentName = args?['studentName'] ?? 'Student';
    final String studentClass = args?['studentClass'] ?? '-';
    final String schoolNo = args?['schoolNo'] ?? '-';

    final Map<String, dynamic> parentArgs = {
      'parentId': parentId,
      'parentName': parentName,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'schoolNo': schoolNo,
    };

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
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
             
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48),
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
                              Navigator.pushNamed(
                                context,
                                ParentRoutes.notifications,
                                arguments: parentArgs,
                              );
                            },
                            icon: Icons.notifications_none_rounded,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $parentName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'You can view the latest updates and support information for $studentName.',
                            style: const TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.school_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        studentName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Class: $studentClass   •   School No: $schoolNo',
                                        style: const TextStyle(
                                          color: Color(0xCCFFFFFF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ParentPrimaryStatusCard(
                        imageAsset: 'assets/images/dashboard.jpg',
                        statusPillText: 'CURRENT STATUS',
                        title: '$studentName is currently being supported',
                        subtitle: 'Guidance follow-up is ongoing',
                        buttonText: 'View Details',
                        showGreenDot: true,
                      ),
                    ),

                    const SizedBox(height: 18),

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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ParentNavTile(
                            icon: Icons.mail_outline_rounded,
                            title: 'Messages from School',
                            subtitle: 'Check recent updates and observations.',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/parent/messages',
                                arguments: parentArgs,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.calendar_month_outlined,
                            title: 'Calendar',
                            subtitle:
                                'View meetings, activities, and upcoming dates.',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/parent/calendar',
                                arguments: parentArgs,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.event_available_outlined,
                            title: 'Book Appointment',
                            subtitle:
                                'Schedule a meeting with a counselor or teacher.',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ParentRoutes.bookAppointment,
                                arguments: parentArgs,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.list_alt_rounded,
                            title: 'My Appointments',
                            subtitle:
                                'View, manage, or cancel your upcoming meetings.',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ParentRoutes.myAppointments,
                                arguments: parentArgs,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          ParentNavTile(
                            icon: Icons.person_outline_rounded,
                            title: 'Profile',
                            subtitle:
                                'Manage your account and notification settings.',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/parent/profile',
                                arguments: parentArgs,
                              );
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

          Positioned(
  left: 0,
  right: 0,
  bottom: 0,
  child: ParentBottomNav(selectedIndex: 0, args: parentArgs),
),
        ],
      ),
    );
  }
}

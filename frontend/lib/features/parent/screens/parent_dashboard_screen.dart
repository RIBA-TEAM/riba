import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/parent_bottom_nav.dart';
import '../widgets/parent_dashboard_card.dart';
import '../widgets/parent_drawer.dart';
import '../../../core/providers/notification_provider.dart';

import 'parent_chat_screen.dart';
import 'parent_profile_settings_screen.dart';
import 'parent_calendar_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    /// SAYFALAR (TAB SİSTEMİ)
    final List<Widget> pages = [
      _buildHome(context), // 0 → HOME
      const ParentChatScreen(), // 1 → CHAT
      const ParentCalendarScreen(),
      const ParentProfileSettingsScreen(), // 3 → SETTINGS
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF101C22),
      drawer: const ParentDrawer(),

      body: pages[_selectedIndex],

      /// BOTTOM NAV
      bottomNavigationBar: ParentBottomNav(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  /// HOME (ESKİ DASHBOARD AYNEN KORUNDU)
  Widget _buildHome(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);

    return Stack(
      children: [
        /// BACKGROUND
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
            padding: const EdgeInsets.only(bottom: 96),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// TOP BAR
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// MENU
                        Builder(
                          builder: (context) => ParentGlassButton(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icons.menu,
                          ),
                        ),

                        const Text(
                          'RIBA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        /// NOTIFICATION
                        Consumer<NotificationProvider>(
                          builder: (context, notifier, child) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ParentGlassButton(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/parent/notifications',
                                    );
                                  },
                                  icon: Icons.notifications_none_rounded,
                                ),

                                if (notifier.unreadCount > 0)
                                  Positioned(
                                    right: -6,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        notifier.unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  /// HOŞ GELDİNİZ
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RIBA Destek Portalına\nHoş Geldiniz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Okul destek sürecine dair güncellemeleri buradan takip edebilirsiniz.',
                          style: TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// DURUM KARTI
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ParentPrimaryStatusCard(
                      imageAsset: 'assets/images/dashboard.jpg',
                      statusPillText: 'GÜNCEL DURUM',
                      title: 'Destek süreci aktif',
                      subtitle: 'Rehberlik takibi devam ediyor',
                      buttonText: 'Detayları Gör',
                      showGreenDot: true,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// PANEL MENÜ
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: Text(
                      'PANEL MENÜSÜ',
                      style: TextStyle(
                        color: Color(0xE6FFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  /// NAVIGATION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ParentNavTile(
                          icon: Icons.mail_outline_rounded,
                          title: 'Okuldan Mesajlar',
                          subtitle:
                              'Rehberlik biriminden gelen güncellemeleri görüntüleyin.',
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1; // 🔥 CHAT
                            });
                          },
                        ),

<<<<<<< arzu
                        const SizedBox(height: 12),

                        ParentNavTile(
                          icon: Icons.info_outline_rounded,
                          title: 'Sistem Bilgisi',
                          subtitle:
                              'RIBA sistemi hakkında daha fazla bilgi alın.',
                          onTap: () {
                            Navigator.pushNamed(context, '/parent/system');
                          },
                        ),

                        const SizedBox(height: 12),

                        ParentNavTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Profil ve Ayarlar',
                          subtitle: 'Bildirim tercihlerinizi buradan yönetin.',
                          onTap: () {
                            setState(() {
                              _selectedIndex = 3;
                            });
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
      ],
    );
  }

  /// PLACEHOLDER (şimdilik)
  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        '$title sayfası yakında',
        style: const TextStyle(color: Colors.white),
=======
          Positioned(
  left: 0,
  right: 0,
  bottom: 0,
  child: ParentBottomNav(selectedIndex: 0, args: parentArgs),
),
        ],
>>>>>>> develop
      ),
    );
  }
}

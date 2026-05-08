import 'dart:ui';

import 'package:flutter/material.dart';

import '../parent_routes.dart';
import '../widgets/parent_bottom_nav.dart';

class ParentChatScreen extends StatefulWidget {
  const ParentChatScreen({super.key});

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);
    const bgDark = Color(0xFF101C22);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String parentName = args?['parentName'] ?? 'Parent';
    final String studentName = args?['studentName'] ?? 'Student';

    final List<_ChatThread> allThreads = [
      const _ChatThread(
        title: 'Guidance Office',
        subtitle: 'Weekly follow-up and student wellbeing updates.',
        icon: Icons.psychology_alt_outlined,
        unreadCount: 2,
      ),
      const _ChatThread(
        title: 'Class Teacher',
        subtitle: 'Attendance and class participation notes.',
        icon: Icons.school_outlined,
        unreadCount: 1,
      ),
      const _ChatThread(
        title: 'Administration',
        subtitle: 'Announcements and school policy notices.',
        icon: Icons.apartment_outlined,
        unreadCount: 0,
      ),
    ];

    final List<_ChatThread> filteredThreads = allThreads
        .where((t) =>
            t.title.toLowerCase().contains(_query.toLowerCase()) ||
            t.subtitle.toLowerCase().contains(_query.toLowerCase()))
        .toList();

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
            bottom: false,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _RoundGlassIconButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Chat Hub',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _RoundGlassIconButton(
                              icon: Icons.notifications_none_rounded,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ParentRoutes.notifications,
                                  arguments: args,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _GlassInfoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $parentName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Choose a channel to continue messages about $studentName.',
                                style: const TextStyle(
                                  color: Color(0xD9FFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _GlassInfoCard(
                          child: TextField(
                            onChanged: (value) => setState(() => _query = value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search chat channels...',
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.70),
                              ),
                              icon: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...filteredThreads.map(
                          (thread) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ChatTile(
                              thread: thread,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ParentRoutes.messages,
                                  arguments: args,
                                );
                              },
                            ),
                          ),
                        ),
                        if (filteredThreads.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 22),
                            child: Center(
                              child: Text(
                                'No channels found.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ParentBottomNav(selectedIndex: 1, args: args),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.thread, required this.onTap});

  final _ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.12),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(thread.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          thread.subtitle,
                          style: const TextStyle(
                            color: Color(0xD9FFFFFF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (thread.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${thread.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  const _GlassInfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RoundGlassIconButton extends StatelessWidget {
  const _RoundGlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.white.withValues(alpha: 0.12),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatThread {
  const _ChatThread({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.unreadCount,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int unreadCount;
}

import 'dart:ui';

import 'package:flutter/material.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() =>
      _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  bool _showUnreadOnly = false;

  late final List<_NotificationItem> _items = [
    _NotificationItem(
      title: 'Guidance Meeting Reminder',
      body: 'Meeting scheduled for tomorrow at 10:30 with counselor.',
      icon: Icons.event_note_rounded,
      dateText: '2h ago',
      isUnread: true,
    ),
    _NotificationItem(
      title: 'New Observation Added',
      body: 'Class teacher shared an update about participation this week.',
      icon: Icons.feed_outlined,
      dateText: 'Yesterday',
      isUnread: true,
    ),
    _NotificationItem(
      title: 'School Announcement',
      body: 'Friday schedule updated for all classes.',
      icon: Icons.campaign_outlined,
      dateText: '3d ago',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);
    const bgDark = Color(0xFF101C22);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String parentName = args?['parentName'] ?? 'Parent';

    final List<_NotificationItem> visibleItems = _showUnreadOnly
        ? _items.where((i) => i.isUnread).toList()
        : _items;

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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
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
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            for (final item in _items) {
                              item.isUnread = false;
                            }
                          });
                        },
                        child: const Text(
                          'Mark all read',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _GlassCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Hello, $parentName. Keep track of your latest updates here.',
                            style: const TextStyle(
                              color: Color(0xE6FFFFFF),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        selected: !_showUnreadOnly,
                        onSelected: (_) => setState(() => _showUnreadOnly = false),
                        selectedColor: Colors.white.withValues(alpha: 0.24),
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        label: const Text(
                          'All',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      FilterChip(
                        selected: _showUnreadOnly,
                        onSelected: (_) => setState(() => _showUnreadOnly = true),
                        selectedColor: Colors.white.withValues(alpha: 0.24),
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        label: const Text(
                          'Unread',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: visibleItems.isEmpty
                        ? const Center(
                            child: Text(
                              'No notifications to display.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: visibleItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = visibleItems[index];
                              return _NotificationTile(
                                item: item,
                                onTap: () {
                                  setState(() => item.isUnread = false);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final _NotificationItem item;
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              item.dateText,
                              style: const TextStyle(
                                color: Color(0xCCFFFFFF),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.body,
                          style: const TextStyle(
                            color: Color(0xE6FFFFFF),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.isUnread)
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22D3EE),
                        shape: BoxShape.circle,
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

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

class _NotificationItem {
  _NotificationItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.dateText,
    required this.isUnread,
  });

  final String title;
  final String body;
  final IconData icon;
  final String dateText;
  bool isUnread;
}

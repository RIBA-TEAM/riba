import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'new_parent_message_screen.dart';
import '../widgets/parent_bottom_nav.dart';

class ParentMessagesScreen extends StatefulWidget {
  const ParentMessagesScreen({super.key});

  @override
  State<ParentMessagesScreen> createState() => _ParentMessagesScreenState();
}

class _ParentMessagesScreenState extends State<ParentMessagesScreen> {
  int _selectedTab = 0; // 0: Guidance Office, 1: Teachers, 2: General

  Stream<List<_MessageItem>> _getMessages({
    required String studentId,
    required String parentId,
  }) {
    return FirebaseFirestore.instance
        .collection('observations')
        .where('student_id', isEqualTo: studentId)
        .where('parent_id', isEqualTo: parentId)
        .snapshots()
        .asyncMap((snapshot) async {
          final items = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final teacherId = (data['teacher_id'] ?? '').toString();

              String senderName = _parseSender(data);

              if (teacherId.isNotEmpty) {
                try {
                  final teacherDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(teacherId)
                      .get();

                  if (teacherDoc.exists) {
                    final teacherData = teacherDoc.data()!;
                    senderName = (teacherData['name'] ?? senderName).toString();
                  }
                } catch (_) {}
              }

              final DateTime createdAt = _parseDate(
                data['created_at'] ??
                    data['createdAt'] ??
                    data['timestamp'] ??
                    data['date'],
              );

              return _MessageItem(
                id: doc.id,
                category: _parseCategory(data),
                sender: senderName,
                timeText: _formatTime(createdAt),
                title: _parseTitle(data),
                preview: _parsePreview(data),
                avatar: _parseAvatar(data),
                isUnread: _parseUnread(data),
                createdAt: createdAt,
              );
            }).toList(),
          );

          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return items;
        });
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime(2000);
    return DateTime(2000);
  }

  static MessageCategory _parseCategory(Map<String, dynamic> data) {
    final source =
        (data['source'] ??
                data['sender_role'] ??
                data['senderRole'] ??
                data['type'] ??
                data['category'] ??
                '')
            .toString()
            .toLowerCase();

    if (source.contains('guidance') ||
        source.contains('counselor') ||
        source.contains('rehber')) {
      return MessageCategory.guidance;
    }

    if (source.contains('teacher') || source.contains('ogretmen')) {
      return MessageCategory.teacher;
    }

    return MessageCategory.general;
  }

  static String _parseSender(Map<String, dynamic> data) {
    return (data['sender_name'] ??
            data['senderName'] ??
            data['teacher_name'] ??
            data['author'] ??
            data['source'] ??
            'School')
        .toString();
  }

  static String _parseTitle(Map<String, dynamic> data) {
    return (data['title'] ??
            data['subject'] ??
            data['headline'] ??
            'New Message')
        .toString();
  }

  static String _parsePreview(Map<String, dynamic> data) {
    return (data['message'] ??
            data['content'] ??
            data['text'] ??
            data['observation'] ??
            data['note'] ??
            'No message content.')
        .toString();
  }

  static String _parseAvatar(Map<String, dynamic> data) {
    final source =
        (data['source'] ??
                data['sender_role'] ??
                data['senderRole'] ??
                data['type'] ??
                data['category'] ??
                '')
            .toString()
            .toLowerCase();

    if (source.contains('guidance') ||
        source.contains('counselor') ||
        source.contains('rehber')) {
      return "🧑‍🏫";
    }

    if (source.contains('teacher') || source.contains('ogretmen')) {
      return "👩";
    }

    return "🏛️";
  }

  static bool _parseUnread(Map<String, dynamic> data) {
    if (data['is_read'] == false) return true;
    if (data['isUnread'] == true) return true;
    return false;
  }

  static String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  List<_MessageItem> _filterMessages(List<_MessageItem> messages) {
    switch (_selectedTab) {
      case 0:
        return messages
            .where((m) => m.category == MessageCategory.guidance)
            .toList();
      case 1:
        return messages
            .where((m) => m.category == MessageCategory.teacher)
            .toList();
      case 2:
        return messages
            .where((m) => m.category == MessageCategory.general)
            .toList();
      default:
        return messages;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);
    const bgDark = Color(0xFF101C22);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String parentId = args?['parentId'] ?? '';
    final String parentName = args?['parentName'] ?? 'Parent';
    final String studentId = args?['studentId'] ?? '';
    final String studentName = args?['studentName'] ?? 'Student';
    final String studentClass = args?['studentClass'] ?? '-';
    final String schoolNo = args?['schoolNo'] ?? '-';

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
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _RoundGlassIconButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () => Navigator.pop(context),
                              ),
                              const Text(
                                "Messages",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Messages for $studentName",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Parent: $parentName",
                                style: const TextStyle(
                                  color: Color(0xCCFFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Class: $studentClass   •   School No: $schoolNo",
                                style: const TextStyle(
                                  color: Color(0xB3FFFFFF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: _TabBarGlass(
                            selectedIndex: _selectedTab,
                            onChanged: (i) => setState(() => _selectedTab = i),
                            labels: const [
                              "Guidance\nOffice",
                              "Teachers",
                              "General",
                            ],
                          ),
                        ),
                        if (studentId.isEmpty || parentId.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                "Parent ID or Student ID not found.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          StreamBuilder<List<_MessageItem>>(
                            stream: _getMessages(
                              studentId: studentId,
                              parentId: parentId,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      "An error occurred: ${snapshot.error}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final allMessages = snapshot.data ?? [];
                              final filteredMessages = _filterMessages(
                                allMessages,
                              );

                              if (allMessages.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Text(
                                      "There are no messages for this student yet.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (filteredMessages.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Text(
                                      "There are no messages in this category yet.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: filteredMessages
                                      .map(
                                        (m) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _MessageCard(
                                            item: m,
                                            onTap: () {},
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 100,
                  child: GestureDetector(
                    onTap: () {
                      if (parentId.isEmpty || studentId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Parent ID or Student ID is missing.',
                            ),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewParentMessageScreen(
                            parentId: parentId,
                            parentName: parentName,
                            studentId: studentId,
                            studentName: studentName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_square,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ParentBottomNav(
                    selectedIndex: 1,
                    args: {
                      'parentId': parentId,
                      'parentName': parentName,
                      'studentId': studentId,
                      'studentName': studentName,
                      'studentClass': studentClass,
                      'schoolNo': schoolNo,
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageCategory { guidance, teacher, general }

class _RoundGlassIconButton extends StatelessWidget {
  const _RoundGlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _TabBarGlass extends StatelessWidget {
  const _TabBarGlass({
    required this.selectedIndex,
    required this.onChanged,
    required this.labels,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(labels.length, (i) {
              final selected = i == selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? primary
                            : Colors.white.withOpacity(0.80),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.item, required this.onTap});

  final _MessageItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    final isUnread = item.isUnread;

    if (isUnread) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.90),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    left: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(width: 4, color: primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Avatar(emoji: item.avatar),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MessageTexts(
                            sender: item.sender,
                            timeText: item.timeText,
                            title: item.title,
                            preview: item.preview,
                            strong: true,
                            timeColor: primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.60),
                                blurRadius: 8,
                                spreadRadius: 1,
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
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.70),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Avatar(emoji: item.avatar, faded: true),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MessageTexts(
                      sender: item.sender,
                      timeText: item.timeText,
                      title: item.title,
                      preview: item.preview,
                      strong: false,
                      timeColor: const Color(0xFF6B7280),
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.emoji, this.faded = false});

  final String emoji;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: faded ? 0.75 : 1,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFE5E7EB),
          border: Border.all(color: Colors.white, width: 1.2),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}

class _MessageTexts extends StatelessWidget {
  const _MessageTexts({
    required this.sender,
    required this.timeText,
    required this.title,
    required this.preview,
    required this.strong,
    required this.timeColor,
  });

  final String sender;
  final String timeText;
  final String title;
  final String preview;
  final bool strong;
  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                sender,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: strong
                      ? const Color(0xFF111618)
                      : const Color(0xFF1F2937),
                  fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              timeText,
              style: TextStyle(
                color: timeColor,
                fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: strong ? const Color(0xFF111618) : const Color(0xFF374151),
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          preview,
          maxLines: strong ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: strong ? const Color(0xFF4B5563) : const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
            fontSize: 13,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

class _MessageItem {
  final String id;
  final MessageCategory category;
  final String sender;
  final String timeText;
  final String title;
  final String preview;
  final String avatar;
  final bool isUnread;
  final DateTime createdAt;

  const _MessageItem({
    required this.id,
    required this.category,
    required this.sender,
    required this.timeText,
    required this.title,
    required this.preview,
    required this.avatar,
    required this.isUnread,
    required this.createdAt,
  });
}

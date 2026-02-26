import 'dart:ui';
import 'package:flutter/material.dart';

class ParentMessagesScreen extends StatefulWidget {
  const ParentMessagesScreen({super.key});

  @override
  State<ParentMessagesScreen> createState() => _ParentMessagesScreenState();
}

class _ParentMessagesScreenState extends State<ParentMessagesScreen> {
  int _selectedTab = 0; // 0: Guidance Office, 1: Teachers, 2: General

  // Demo data (şimdilik statik) — sonra API bağlarız
  final List<_MessageItem> _messages = const [
    _MessageItem(
      sender: "School Guidance Office",
      timeText: "10:45 AM",
      title: "New update on your child's progress",
      preview:
          "An update regarding our recent meeting. We've seen positive engagement in the last sessions...",
      avatarUrl:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuC724g62cwG4-C6SG-az9yJwsKGDRhXL09geuqsS8gIk_eRll5GAmo6RgHnH97zhJcj202G1D8_C5-iAFqNZ7s9eQduBDtrfiEy9ZgZpnjl6PnCmjvrr33fyzNAv_S2UU5aRrJ1Zl7Fkhk5EJFFrIidh19IksA9tOuQ83Ymwn73MZQunBqzAtoqq4mXeuprRvIb08UKa2OeIJUgJ06ypp0rP0qOFTVvG6iJNnz1O0ClCcYcmc-ECNG0SX7xCMp8jrK0Mw6TIy5gt8tW",
      isUnread: true,
    ),
    _MessageItem(
      sender: "Dr. Sarah Miller",
      timeText: "9:15 AM",
      title: "Follow-up regarding today's session",
      preview:
          "I wanted to share some resources we discussed this morning for home practice...",
      avatarUrl:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAErlA2HrgqVb9B6ojSeDpsI3WJYgRjei3MnkfCl3Kzk_FWYmaq7zi5H7TjEb12-aMR4Ho-i2bWD1NABWJNXMuzpwFqeK5jssFCejvJilxdnXVk6w-s5NvdP3Lfws66tcVpFsuieVYu7jkL4nPNr9t-KaAiLVp_K-qygPCgh-zQ-FAP5YEm0p9N0GdDYS9YiYGNsnkK0XR8v5uBpv_hJyfyBkny_1kObWfoCd3uDlRo7p_JS2zHNd4fJnwCR8JW85bAgrQvim_MRFyI",
      isUnread: true,
    ),
    _MessageItem(
      sender: "School Guidance Office",
      timeText: "Yesterday",
      title: "Semester Progress Report",
      preview: "We've updated the progress report for the current semester...",
      avatarUrl:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuC4FGCloykuxpXXF_1Ou0IYH0glORqmkOAMKi5tKPGcp-ZLUIN3WEBPFl7DUDnJiBhXVxSh0fyG26agc4LrFqaEFqjjiNH2CUhdfnp4ahY0_dmUXCMjhVYpYorqIdxi26MzIqUXam3iUmUCo0Cv3KQ0L_UD0Lu1GOKy4FDaZnjfg0qh6erxYY2ESQ5lNVb46xKqLcNguLxaZcMZ-u0juFn5gTuDkP7li_3K_kQghOL3G0y7fOPqr2hQJOTfLxcTwSqc_RdAEiNIzJYd",
      isUnread: false,
    ),
    _MessageItem(
      sender: "Counseling Department",
      timeText: "Oct 24",
      title: "Upcoming Parents' Workshop",
      preview:
          "Invitation to the upcoming digital wellbeing workshop for parents...",
      avatarUrl:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCt-CPcuMppROS2vyrX8ylWdMYx6SvvaqC5gtuSzBtKuTYK4Pz5wAoqA6kiv7A-fkFkaZTdzhBVmLqubJTH8ODjnEJyEjnATl_TtjdSA66gjaPi-NTB0D1wB1Y_YVmBJYuBmUSkDcyxeYZrI21mE8187AnT8e8A4RfpZyc5-JZj7BvckVoRGi2xDXwEB6Ao3sqnDs7oRGsORSUCm2V4pSGBAiOjhgNAReAKxQ3ZlXNlETS6l2rL0dOHa86q8wsgXBkLFb0K8MGtYat1",
      isUnread: false,
    ),
    _MessageItem(
      sender: "Dr. Sarah Miller",
      timeText: "Oct 22",
      title: "Initial Consultation Meeting",
      preview:
          "Thank you for taking the time to meet with us yesterday. Here are the notes...",
      avatarUrl:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDoEXE5GXXOvZeKbXOZvsGAME-BcnFG_Qbhj3WGinztg1fLL1QoGWZ0u4sDjfB1bYAobclHLAHe7D_yXDmybfSJlpTh-ehAekFuVJSpOehqKdfen2fwuD0c0i0bVkKUf4CVReVWzbKLL51aGu69C-BNh99mxAspr4SGc3V89rJA-xHeBHD_srve_fQ688jDuRkx_-YcIsgmhR9ju1sHzfVWuFmxhlx8LKKE-GeSZRPyJ5rq4RZBnyDVe_jVk2b9kbQlmkpGOuBXF69A",
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);

    return Scaffold(
      backgroundColor: const Color(0xFF101C22),
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

          // Content
          SafeArea(
            child: Stack(
              children: [
                // Scrollable area
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sticky-like header area (we keep it visually same)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              _ProfileAvatar(
                                imageUrl:
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCTl9I7tnuczE87gTmz9R47ogfTj60Xs5wkBmzgTJz4X0vAY51uj78W9rG54AjRnLRzJQIU6eT-Sd-TRerT2ROlfB5WO7JGmA41nooEZTQ4AcRHufbLngbvKf0vgdoMSFAyvRFkODCoK4hP_MX_4fbuZD1APQi7ZC0fRNt45v7jPHZ3DNtG8DovGF8hDB6B9oUateKoWqkjhI0A-tuEAEXMEFysVGRqkZlO3wLBsUWgsgjmtLMF14sGLNRovIS2863glIQ3xK8dElUw",
                              ),
                            ],
                          ),
                        ),

                        // Tabs
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

                        // Message list
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: _messages
                                .map(
                                  (m) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _MessageCard(
                                      item: m,
                                      onTap: () {
                                        // TODO: message detail screen
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Action Button (edit_square)
                Positioned(
                  right: 18,
                  bottom: 110,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: compose new message / note
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

                // Bottom Navigation Bar (glass)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _BottomNavGlass(selectedIndex: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- UI WIDGETS ----------------------------- */

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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.30), width: 2),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
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
      // Unread glass-card with left primary bar + dot
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
                        _Avatar(url: item.avatarUrl),
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

    // Read card (white/70 blur, slightly faded)
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
                  _Avatar(url: item.avatarUrl, grayscale: true),
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
  const _Avatar({required this.url, this.grayscale = false});
  final String url;
  final bool grayscale;

  @override
  Widget build(BuildContext context) {
    final img = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );

    if (!grayscale) return img;

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.7,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.7,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.7,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ]),
      child: img,
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

class _BottomNavGlass extends StatelessWidget {
  const _BottomNavGlass({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    Widget item({
      required int index,
      required IconData icon,
      required String label,
      bool showBadge = false,
      required VoidCallback onTap,
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
                    if (showBadge)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 1.0,
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
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.20), width: 1),
            ),
          ),
          child: Row(
            children: [
              item(
                index: 0,
                icon: Icons.home_rounded,
                label: "Home",
                onTap: () => Navigator.pushNamed(context, '/parent/dashboard'),
              ),
              item(
                index: 1,
                icon: Icons.chat_bubble_rounded,
                label: "Messages",
                showBadge: true,
                onTap: () {}, // zaten buradasın
              ),
              item(
                index: 2,
                icon: Icons.event,
                label: "Calendar",
                onTap: () {
                  // TODO: /parent/calendar
                },
              ),
              item(
                index: 3,
                icon: Icons.person,
                label: "Profile",
                onTap: () => Navigator.pushNamed(context, '/parent/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ----------------------------- DATA MODEL ----------------------------- */

class _MessageItem {
  final String sender;
  final String timeText;
  final String title;
  final String preview;
  final String avatarUrl;
  final bool isUnread;

  const _MessageItem({
    required this.sender,
    required this.timeText,
    required this.title,
    required this.preview,
    required this.avatarUrl,
    required this.isUnread,
  });
}

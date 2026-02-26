import 'dart:ui';
import 'package:flutter/material.dart';

class ParentSystemInfoScreen extends StatelessWidget {
  const ParentSystemInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);

    return Scaffold(
      backgroundColor: const Color(0xFF101C22),
      body: Stack(
        children: [
          // iOS-style vertical gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [tealDeep, primary],
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Scroll content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header / Top Bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                          child: Row(
                            children: [
                              _CircleGlassIconButton(
                                icon: Icons.arrow_back_ios_new_rounded,
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Parent Information',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 52,
                              ), // sağ boşluk (HTML'deki pr-10)
                            ],
                          ),
                        ),

                        // Hero Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                          child: Column(
                            children: const [
                              SizedBox(height: 8),
                              _HeroIcon(),
                              SizedBox(height: 12),
                              Text(
                                "Built on Trust & Safety",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Our commitment to providing a safe, ethical, and supportive environment for your child.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xCCFFFFFF),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Information Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: const [
                              _InfoCard(
                                icon: Icons.handshake_rounded,
                                title: "Purpose of RIBA",
                                body:
                                    "RIBA is a supportive companion tool designed to enhance human interaction. It helps identify needs early so we can provide better care for your child.",
                              ),
                              SizedBox(height: 14),
                              _InfoCard(
                                icon: Icons.note_alt_rounded,
                                title: "Professional Oversight",
                                body:
                                    "Evaluations are always conducted by licensed human counselors. RIBA assists with data, but experts make the final decisions.",
                              ),
                              SizedBox(height: 14),
                              _InfoCard(
                                icon: Icons.lock_rounded,
                                title: "Your Privacy",
                                body:
                                    "Your data is locked and private. We use industry-leading encryption to ensure that student information is never sold or misused.",
                              ),
                              SizedBox(height: 14),
                              _InfoCard(
                                icon: Icons.gavel_rounded,
                                title: "Ethical Boundaries",
                                body:
                                    "We operate under strict ethical guidelines. RIBA does not replace parenting or professional therapy; it supports it.",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Visual image section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                          child: _ImageBanner(
                            imageUrl:
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuATN7P-JyZMTD5faiFjfW-g2rLpWxxCTC0-Ny8ogddcvM5tFYQtEhln36vU0vkqFhNgwHa0AwPH5fN-xfn1ArjTNu9HAOgNNx_zAZ1DoehheY-hRUVIXGeEiQGxz5o3KnugRr0rXqsvTXvOQXvkq01zA5QoV-IKO3VEC1cpDeEOb0F-h7q0SkXvaKSt3288p8LT6OQfv1bqFYj8oCKgdjogXTBRSoahfYxE5BK0lNjxKf7SyBFgyaokE_9ulIllkikDlGgxWTbQYGrs",
                            tagText: "SAFE & SOUND",
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Footer / Contact Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // HTML: Got it, Thank you
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                  ),
                                  child: const Text(
                                    "Got it, Thank you",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Have more questions? Contact our school counselor or visit our Privacy Policy.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.60),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation Bar (4 icons like HTML)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _InfoBottomNav(selectedIndex: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- UI PIECES ----------------------------- */

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
                ? const Color(0xFF101C22).withOpacity(0.75)
                : Colors.white.withOpacity(0.85)),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.white.withOpacity(0.30),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.shield_outlined, color: Colors.white, size: 44),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    return _GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF111618),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF4B5563),
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
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

class _ImageBanner extends StatelessWidget {
  const _ImageBanner({required this.imageUrl, required this.tagText});
  final String imageUrl;
  final String tagText;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1193D4);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.20)),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tagText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBottomNav extends StatelessWidget {
  const _InfoBottomNav({required this.selectedIndex});
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
      final active = index == selectedIndex;
      final color = active ? primary : const Color(0xFF9CA3AF);

      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _GlassCard(
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: SizedBox(
        height: 70,
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
              icon: Icons.description,
              label: 'Reports',
              onTap: () {
                // TODO: reports
              },
            ),
            item(
              index: 2,
              icon: Icons.chat_bubble,
              label: 'Chat',
              onTap: () => Navigator.pushNamed(context, '/parent/messages'),
            ),
            item(
              index: 3,
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => Navigator.pushNamed(context, '/parent/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

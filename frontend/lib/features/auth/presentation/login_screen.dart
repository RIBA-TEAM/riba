import 'dart:ui';
import 'package:flutter/material.dart';
import '../../teacher/presentation/teacher_dashboard.dart';
import '../../student/student_routes.dart';

enum UserRole { student, parent, counselor }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole selectedRole = UserRole.student;

  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  String getIdentifierHint() {
    switch (selectedRole) {
      case UserRole.student:
        return "Öğrenci Numarası";
      case UserRole.parent:
        return "Email or Ebeveyn No";
      case UserRole.counselor:
        return "Okul Emaili";
    }
  }

  IconData getIdentifierIcon() {
    switch (selectedRole) {
      case UserRole.student:
        return Icons.badge_outlined;
      case UserRole.parent:
        return Icons.alternate_email;
      case UserRole.counselor:
        return Icons.mail_outline;
    }
  }

  String getTitle() {
    switch (selectedRole) {
      case UserRole.student:
        return "Öğrenci Girişi";
      case UserRole.parent:
        return "Ebeveyn Girişi";
      case UserRole.counselor:
        return "Rehber Girişi";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF042F2E), Color(0xFF064E3B), Color(0xFF1E40AF)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🔵 LOGO + TITLE (YUKARIDA)
                Column(
                  children: const [
                    Icon(
                      Icons.health_and_safety,
                      size: 52,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "RIBA",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🔵 BLUR LOGIN CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: 420,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            getTitle(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// ROLE SELECTOR
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: UserRole.values.map((role) {
                                final isSelected = role == selectedRole;

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRole = role;
                                        identifierController.clear();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF196EE6)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        role.name.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// IDENTIFIER FIELD
                          TextField(
                            controller: identifierController,
                            keyboardType: selectedRole == UserRole.student
                                ? TextInputType.number
                                : TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(getIdentifierIcon()),
                              hintText: getIdentifierHint(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// PASSWORD FIELD
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF196EE6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                if (selectedRole == UserRole.counselor) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TeacherDashboard(),
                                    ),
                                  );
                                } else if (selectedRole == UserRole.student) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    StudentRoutes.dashboard,
                                  );
                                }
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../teacher/presentation/teacher_dashboard.dart';
import '../../student/student_routes.dart';
import '../../parent/parent_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  bool _obscurePassword = true;

  Future<void> signIn(String userId, String password, String role) async {
    final firestore = FirebaseFirestore.instance;

    try {
      if (role == "student") {
        final result = await firestore
            .collection('students')
            .where('school_no', isEqualTo: userId.trim())
            .where('password', isEqualTo: password.trim())
            .get();

        if (result.docs.isEmpty) {
          print("Student not found or wrong password");
          return;
        }

        Navigator.pushReplacementNamed(context, StudentRoutes.dashboard);
        return;
      }

      final result = await firestore
          .collection('users')
          .where('email', isEqualTo: userId.trim())
          .get();

      if (result.docs.isEmpty) {
        print("User not found");
        return;
      }

      final userDoc = result.docs.first;
      final userData = userDoc.data();

      if (userData['password'].toString().trim() != password.trim()) {
        print("Wrong password");
        return;
      }

      if (userData['role'].toString().toLowerCase().trim() !=
          role.toLowerCase().trim()) {
        print("Wrong role");
        return;
      }

      if (role == 'parent') {
        final studentId = userData['student_id'];

        final studentDoc = await firestore
            .collection('students')
            .doc(studentId)
            .get();

        if (!studentDoc.exists) {
          print("Student not found for this parent");
          return;
        }

        final studentData = studentDoc.data()!;

        Navigator.pushReplacementNamed(
          context,
          ParentRoutes.dashboard,
          arguments: {
            'parentId': userDoc.id,
            'parentName': userData['name'] ?? '',
            'parentEmail': userData['email'] ?? '',
            'studentId': studentId,
            'studentName': studentData['name'] ?? '',
            'studentClass': studentData['class'] ?? '',
            'schoolNo': studentData['school_no'] ?? '',
          },
        );
        return;
      }

      if (role == 'counselor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TeacherDashboard()),
        );
        return;
      }
    } catch (e) {
      print("Login error: $e");
    }
  }

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
    const inputTextColor = Colors.black;
    const hintColor = Colors.black54;
    const iconColor = Colors.black87;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),

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

                          TextField(
                            controller: identifierController,
                            keyboardType: selectedRole == UserRole.student
                                ? TextInputType.number
                                : TextInputType.emailAddress,
                            style: const TextStyle(
                              color: inputTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                getIdentifierIcon(),
                                color: iconColor,
                              ),
                              hintText: getIdentifierHint(),
                              hintStyle: const TextStyle(color: hintColor),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF196EE6),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: inputTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: iconColor,
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(color: hintColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: iconColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF196EE6),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

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
                              onPressed: () async {
                                await signIn(
                                  identifierController.text,
                                  passwordController.text,
                                  selectedRole.name,
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/api_config.dart';

class AuthService extends ChangeNotifier {

  String? _userId;
  String? _role;
  String? _fullName;
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get userId => _userId;
  String? get role => _role;
  String? get fullName => _fullName;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _userId != null;

  /// Backend'ye giriş yap
  Future<bool> login(String email, String password, String role) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final uri = Uri.parse('${ApiConfig.apiBaseUrlV1}/auth/login');

      debugPrint('Login attempt: $email ($role)');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response('timeout', 408),
          );

      debugPrint('Login response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          _userId = responseData['user_id'];
          _role = responseData['role'];
          _fullName = responseData['full_name'];

          _isLoading = false;
          notifyListeners();

          debugPrint('Login successful: $_userId');
          return true;
        } else {
          _error = responseData['message'] ?? 'Login failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Login error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      _error = ApiConfig.userMessageForError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Kayıt ol
  Future<bool> register(
    String email,
    String password,
    String fullName,
    String role,
  ) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final uri = Uri.parse('${ApiConfig.apiBaseUrlV1}/auth/register');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'full_name': fullName,
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = responseData['message'] ?? 'Registration failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Registration error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Registration exception: $e');
      _error = ApiConfig.userMessageForError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Çıkış yap
  Future<void> logout() async {
    try {
      _userId = null;
      _role = null;
      _fullName = null;
      _error = null;
      notifyListeners();
      debugPrint('Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Hata mesajını temizle
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

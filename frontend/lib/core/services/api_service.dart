import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.apiBaseUrlV1;

  static final ApiService _instance = ApiService._internal();

  ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  // Chat API Methods
  Future<Map<String, dynamic>> sendChatMessage(
    String chatId,
    String message, {
    String? mood,
    List<Map<String, String>>? history,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/$chatId/message');

      final body = <String, dynamic>{'text': message};
      if (mood != null && mood.isNotEmpty) {
        body['mood'] = mood;
      }
      if (history != null && history.isNotEmpty) {
        body['history'] = history;
      }

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response('timeout', 408),
          );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        debugPrint('Chat API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Chat API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Chat API Exception: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getChats() async {
    try {
      final uri = Uri.parse('$baseUrl/chat/');

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Get chats error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get chats exception: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createChat(String message) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Create chat error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Create chat exception: $e');
      rethrow;
    }
  }

  // Risk Assessment API Methods
  Future<Map<String, dynamic>> getRiskAssessment(String studentId) async {
    try {
      final uri = Uri.parse('$baseUrl/risk/?student_id=$studentId');

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Risk assessment error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Risk assessment exception: $e');
      rethrow;
    }
  }

  // Auth API Methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Login error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      rethrow;
    }
  }

  // Health check
  Future<bool> healthCheck() async {
    try {
      final uri = Uri.parse('${ApiConfig.rootBaseUrl}/health');

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }
}

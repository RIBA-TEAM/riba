import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import 'api_service.dart';

class ChatService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _currentChatId;
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  String? get currentChatId => _currentChatId;
  List<Map<String, String>> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Chat oluştur
  Future<bool> createChat() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _apiService.createChat('Yeni sohbet');

      if (result.containsKey('chat_id')) {
        _currentChatId = result['chat_id'] as String;
        _messages.clear();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = 'Chat oluşturulamadı';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Create chat error: $e');
      _error = ApiConfig.userMessageForError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mesaj gönder ve bot cevabı al
  Future<bool> sendMessage(String message) async {
    if (_currentChatId == null) {
      _error = 'Chat ID bulunamadı';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = null;

      // Kullanıcı mesajını ekle
      _messages.add({'sender': 'user', 'text': message});
      notifyListeners();

      // Backend'e gönder
      final result = await _apiService.sendChatMessage(
        _currentChatId!,
        message,
      );

      if (result.containsKey('bot_response')) {
        // Bot cevabını ekle
        _messages.add({
          'sender': 'bot',
          'text': result['bot_response'] as String,
        });
      } else {
        _error = 'Bot yanıtı alınamadı';
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Send message error: $e');
      _error = ApiConfig.userMessageForError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sohbetleri yükle
  Future<bool> loadChats() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _apiService.getChats();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Load chats error: $e');
      _error = ApiConfig.userMessageForError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mesaj geçmişini temizle
  void clearMessages() {
    _messages.clear();
    _currentChatId = null;
    _error = null;
    notifyListeners();
  }

  /// Mesaj ekle (sadece UI için)
  void addMessageLocally(String sender, String text) {
    _messages.add({'sender': sender, 'text': text});
    notifyListeners();
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}

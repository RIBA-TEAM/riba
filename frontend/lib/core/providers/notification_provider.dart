import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _unreadCount = 3; // backend gelince API'den alınacak

  int get unreadCount => _unreadCount;

  void setUnread(int value) {
    _unreadCount = value;
    notifyListeners();
  }

  void decrease() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  void clear() {
    _unreadCount = 0;
    notifyListeners();
  }
}

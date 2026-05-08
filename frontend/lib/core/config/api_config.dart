import 'package:flutter/foundation.dart';

import 'resolve_api_host.dart';

/// Uygulama genelinde RIBA backend adresi.
///
/// Özel adres için:
/// `flutter run --dart-define=RIBA_API_BASE_URL=http://192.168.1.10:8000/api/v1`
class ApiConfig {
  ApiConfig._();

  static const String _envBase = String.fromEnvironment(
    'RIBA_API_BASE_URL',
    defaultValue: '',
  );

  /// Örnek: `http://10.0.2.2:8000/api/v1`
  static String get apiBaseUrlV1 {
    final trimmed = _envBase.trim();
    if (trimmed.isNotEmpty) {
      return trimmed.replaceAll(RegExp(r'/+$'), '');
    }
    final host = kIsWeb ? 'localhost' : resolveDefaultApiHost();
    return 'http://$host:8000/api/v1';
  }

  /// `/api/v1` olmadan kök (örn. health için).
  static String get rootBaseUrl {
    const suffix = '/api/v1';
    final v1 = apiBaseUrlV1;
    if (v1.endsWith(suffix)) {
      return v1.substring(0, v1.length - suffix.length);
    }
    return v1.replaceAll(RegExp(r'/api/v1/?$'), '');
  }

  static String userMessageForError(Object error) {
    final text = error.toString();
    if (text.contains('Connection refused') ||
        text.contains('Failed host lookup') ||
        text.contains('Network is unreachable')) {
      return 'Sunucuya bağlanılamıyor. Backend\'i başlatın (port 8000). '
          'Gerçek cihazda: flutter run '
          '--dart-define=RIBA_API_BASE_URL=http://BILGISAYAR_IP:8000/api/v1';
    }
    if (text.contains('timeout') ||
        text.contains('TimeoutException') ||
        text.contains('408')) {
      return 'Bağlantı zaman aşımına uğradı. Ağı veya sunucuyu kontrol edin.';
    }
    return 'Bir hata oluştu. Ayrıntı konsolda.';
  }
}

import 'dart:io' show Platform;

String resolveDefaultApiHostImpl() {
  if (Platform.isAndroid) {
    // Emülatörde bilgisayardaki localhost için; gerçek cihazda --dart-define kullanın.
    return '10.0.2.2';
  }
  return '127.0.0.1';
}

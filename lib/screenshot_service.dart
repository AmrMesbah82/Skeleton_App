import 'package:flutter/services.dart';

class ScreenshotService {
  static const MethodChannel _channel =
      MethodChannel('com.example.screenshot/screenshot');

  static Future<void> preventScreenshot() async {
    try {
      await _channel.invokeMethod('preventScreenshot');
    } on PlatformException catch (e) {
      print("Failed to prevent screenshot: '${e.message}'.");
    }
  }
}

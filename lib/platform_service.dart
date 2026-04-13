import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel(
    'com.example.flutter_application_1/call',
  );

  static Future<String?> makeCall(String phoneNumber) async {
    try {
      final result = await platform.invokeMethod<Object?>('makeCall', {
        'phoneNumber': phoneNumber,
      });
      return result?.toString();
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}

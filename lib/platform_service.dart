import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel(
    'com.example.flutter_application_1/call',
  );

  static Future<dynamic> makeCall(String phoneNumber) async {
    final result = await platform.invokeMethod('makeCall', {
      'phoneNumber': phoneNumber,
    });

    return result;
  }
}

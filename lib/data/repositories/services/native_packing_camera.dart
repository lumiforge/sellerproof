import 'package:flutter/services.dart';

class NativePackingCamera {
  static const MethodChannel _channel = MethodChannel('packing_camera_channel');

  static Future<String?> startPackingCamera() async {
    final String? path = await _channel.invokeMethod<String>(
      'startPackingCamera',
    );
    return path;
  }
}

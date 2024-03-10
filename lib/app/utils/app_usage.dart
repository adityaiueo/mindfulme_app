import 'package:flutter/services.dart';
import 'dart:async';

class AppUsage {
  static const MethodChannel _channel = MethodChannel('app_usage');

  static Future<String> getForegroundApp() async {
    final String foregroundApp =
        await _channel.invokeMethod('printForegroundApp');
    return foregroundApp;
  }

  static Future<bool> get needPermissionForBlocking async {
    final bool needPermission =
        await _channel.invokeMethod('needPermissionForBlocking');
    return needPermission;
  }

  static void openUsageAccessSettings() {
    _channel.invokeMethod('openUsageAccessSettings');
  }
}

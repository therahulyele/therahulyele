import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static const MethodChannel _channel = MethodChannel('permission_channel');

  /// Check if Usage Access permission is granted
  /// This is a more reliable way to check Usage Access permission
  static Future<bool> hasUsageAccessPermission() async {
    try {
      // Try to check through platform channel
      final bool hasPermission = await _channel.invokeMethod(
        'hasUsageAccessPermission',
      );
      return hasPermission;
    } catch (e) {
      // Fallback: check basic permissions
      final phoneStatus = await Permission.phone.status;
      final notificationStatus = await Permission.notification.status;

      // If both permissions are granted, assume usage access might be available
      return phoneStatus.isGranted && notificationStatus.isGranted;
    }
  }

  /// Request Usage Access permission
  static Future<bool> requestUsageAccessPermission() async {
    try {
      // First request basic permissions
      await Permission.phone.request();
      await Permission.notification.request();

      // Then try to open Usage Access settings
      return await openUsageAccessSettings();
    } catch (e) {
      return false;
    }
  }

  /// Open Android Usage Access settings
  static Future<bool> openUsageAccessSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
      return true;
    } catch (e) {
      return false;
    }
  }
}

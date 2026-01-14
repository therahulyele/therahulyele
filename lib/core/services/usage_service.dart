import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/app_usage.dart';
import '../platform/platform_helper.dart';
import '../../features/usage/mock/mock_usage_data.dart';

class UsageService {
  static const _channel = MethodChannel('com.example.usage');

  /// Get usage statistics from platform-specific APIs
  static Future<List<AppUsage>> getUsageStats() async {
    if (PlatformHelper.isIOS) {
      // Temporary mock until Screen Time entitlement available
      return MockUsageData.today;
    }

    try {
      print('UsageService: Attempting to get usage stats...');
      final result = await _channel.invokeMethod('getUsageStats');
      print('UsageService: Received result: $result');
      final List list = List<Map<dynamic, dynamic>>.from(result);
      final apps = list.map((e) => AppUsage.fromMap(e)).toList();
      print('UsageService: Parsed ${apps.length} apps');
      return apps;
    } on PlatformException catch (e) {
      print('UsageService: Error getting usage stats: ${e.message}');
      return [
        AppUsage(
          packageName: 'error',
          appName: 'Error',
          totalTimeForeground: 0,
          lastTimeUsed: 0,
          firstTimeStamp: 0,
          lastTimeStamp: 0,
          iconBase64: '',
          error: 'Failed to get usage stats: ${e.message}',
        ),
      ];
    } catch (e) {
      print('UsageService: Unexpected error: $e');
      return [
        AppUsage(
          packageName: 'error',
          appName: 'Error',
          totalTimeForeground: 0,
          lastTimeUsed: 0,
          firstTimeStamp: 0,
          lastTimeStamp: 0,
          iconBase64: '',
          error: 'Unexpected error: $e',
        ),
      ];
    }
  }

  /// Check if the app has usage stats permission
  static Future<bool> hasPermission() async {
    if (PlatformHelper.isIOS) {
      // iOS permission check would go here when Screen Time is implemented
      return true; // Mock for now
    }

    try {
      print('UsageService: Checking permission...');
      final result = await _channel.invokeMethod('hasPermission');
      print('UsageService: Permission result: $result');
      return result as bool;
    } on PlatformException catch (e) {
      print('UsageService: Error checking permission: ${e.message}');
      return false;
    } catch (e) {
      print('UsageService: Unexpected error checking permission: $e');
      return false;
    }
  }

  /// Request usage stats permission
  static Future<bool> requestPermission() async {
    if (PlatformHelper.isIOS) {
      // iOS permission request would go here when Screen Time is implemented
      return true; // Mock for now
    }

    try {
      print('UsageService: Requesting permission...');
      final result = await _channel.invokeMethod('requestUsagePermission');
      print('UsageService: Permission request result: $result');
      return result as bool;
    } on PlatformException catch (e) {
      print('UsageService: Error requesting permission: ${e.message}');
      return false;
    } catch (e) {
      print('UsageService: Unexpected error requesting permission: $e');
      return false;
    }
  }

  /// Check Screen Time usage permission (iOS 15+)
  static Future<bool> checkUsagePermission() async {
    if (PlatformHelper.isIOS) {
      // iOS Screen Time permission check would go here
      return true; // Mock for now
    }

    try {
      print('UsageService: Checking usage permission...');
      final result = await _channel.invokeMethod('checkUsagePermission');
      print('UsageService: Usage permission result: $result');
      return result as bool;
    } on PlatformException catch (e) {
      print('UsageService: Error checking usage permission: ${e.message}');
      return false;
    } catch (e) {
      print('UsageService: Unexpected error checking usage permission: $e');
      return false;
    }
  }

  /// Request Screen Time usage permission (iOS 15+)
  static Future<bool> requestUsagePermission() async {
    if (PlatformHelper.isIOS) {
      // iOS Screen Time permission request would go here
      return true; // Mock for now
    }

    try {
      print('UsageService: Requesting usage permission...');
      final result = await _channel.invokeMethod('requestUsagePermission');
      print('UsageService: Usage permission request result: $result');
      return result as bool;
    } on PlatformException catch (e) {
      print('UsageService: Error requesting usage permission: ${e.message}');
      return false;
    } catch (e) {
      print('UsageService: Unexpected error requesting usage permission: $e');
      return false;
    }
  }

  /// Get usage stats with error handling
  static Future<UsageStatsResult> getUsageStatsWithErrorHandling() async {
    try {
      // Check permission first
      final permissionGranted = await hasPermission();
      if (!permissionGranted) {
        return UsageStatsResult.error(
          'Usage access permission not granted. Please enable it in Settings.',
        );
      }

      final stats = await getUsageStats();
      if (stats.isNotEmpty && stats.first.error != null) {
        return UsageStatsResult.error(stats.first.error!);
      }

      return UsageStatsResult.success(stats);
    } catch (e) {
      return UsageStatsResult.error('Unexpected error: $e');
    }
  }

  /// Open usage settings using native method channel
  static Future<bool> openUsageSettings() async {
    try {
      print(
        'UsageService: Opening usage settings via native method channel...',
      );
      final result = await _channel.invokeMethod('openUsageSettings');
      print('UsageService: Native settings opening result: $result');
      return result as bool;
    } on PlatformException catch (e) {
      print('UsageService: Error opening usage settings: ${e.message}');
      // Fallback to permission_handler
      return await _openAppSettingsFallback();
    } catch (e) {
      print('UsageService: Unexpected error opening settings: $e');
      // Fallback to permission_handler
      return await _openAppSettingsFallback();
    }
  }

  /// Debug method to check all permission states
  static Future<Map<String, dynamic>> debugPermissions() async {
    try {
      final hasPermissionResult = await hasPermission();
      final checkUsagePermissionResult = await checkUsagePermission();
      final requestUsagePermissionResult = await requestUsagePermission();

      return {
        'hasPermission': hasPermissionResult,
        'checkUsagePermission': checkUsagePermissionResult,
        'requestUsagePermission': requestUsagePermissionResult,
        'platform': PlatformHelper.isAndroid ? 'Android' : 'iOS',
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'platform': PlatformHelper.isAndroid ? 'Android' : 'iOS',
      };
    }
  }

  /// Fallback method using permission_handler
  static Future<bool> _openAppSettingsFallback() async {
    try {
      print('UsageService: Using permission_handler fallback...');
      await openAppSettings();
      return true;
    } catch (e) {
      print('UsageService: Permission handler fallback failed: $e');
      return false;
    }
  }
}

class UsageStatsResult {
  final bool isSuccess;
  final List<AppUsage>? data;
  final String? error;

  UsageStatsResult.success(this.data) : isSuccess = true, error = null;
  UsageStatsResult.error(this.error) : isSuccess = false, data = null;
}

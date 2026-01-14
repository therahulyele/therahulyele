import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../platform/platform_helper.dart';

class SettingsOpener {
  /// Open device settings for usage access permissions
  static Future<bool> openUsageSettings() async {
    try {
      if (PlatformHelper.isAndroid) {
        return await _openAndroidUsageSettings();
      } else if (PlatformHelper.isIOS) {
        return await _openIOSScreenTimeSettings();
      }
      return false;
    } catch (e) {
      print('SettingsOpener: Error opening settings: $e');
      return false;
    }
  }

  /// Open Android usage access settings
  static Future<bool> _openAndroidUsageSettings() async {
    try {
      // First try using Android Intent (more reliable)
      try {
        final intent = AndroidIntent(
          action: 'android.settings.USAGE_ACCESS_SETTINGS',
        );
        await intent.launch();
        return true;
      } catch (e) {
        print('SettingsOpener: Android Intent failed: $e');
      }

      // Fallback to URL launcher with different formats
      final List<String> usageUrls = [
        'android-app://android.settings.USAGE_ACCESS_SETTINGS',
        'android-app://com.android.settings/.Settings\$UsageAccessSettingsActivity',
        'android-app://com.android.settings/.Settings\$AppUsageAccessSettingsActivity',
        'android-app://com.android.settings/.Settings\$ManageApplicationsActivity',
      ];

      for (final url in usageUrls) {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            return await launchUrl(Uri.parse(url));
          }
        } catch (e) {
          print('SettingsOpener: Failed to open $url: $e');
          continue;
        }
      }

      // Fallback to general app settings
      return await _openAndroidAppSettings();
    } catch (e) {
      print('SettingsOpener: Error opening Android usage settings: $e');
      return await _openAndroidAppSettings();
    }
  }

  /// Open Android app settings as fallback
  static Future<bool> _openAndroidAppSettings() async {
    try {
      // First try using Android Intent (more reliable)
      try {
        final intent = AndroidIntent(
          action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        );
        await intent.launch();
        return true;
      } catch (e) {
        print('SettingsOpener: Android Intent for app settings failed: $e');
      }

      // Fallback to URL launcher with different formats
      final List<String> appUrls = [
        'android-app://android.settings.APPLICATION_DETAILS_SETTINGS',
        'android-app://com.android.settings/.Settings\$ApplicationSettingsActivity',
        'android-app://com.android.settings/.Settings\$ManageApplicationsActivity',
        'android-app://com.android.settings/.Settings\$InstalledAppDetailsActivity',
      ];

      for (final url in appUrls) {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            return await launchUrl(Uri.parse(url));
          }
        } catch (e) {
          print('SettingsOpener: Failed to open $url: $e');
          continue;
        }
      }

      // Final fallback to general settings
      return await _openAndroidGeneralSettings();
    } catch (e) {
      print('SettingsOpener: Error opening Android app settings: $e');
      return await _openAndroidGeneralSettings();
    }
  }

  /// Open Android general settings as final fallback
  static Future<bool> _openAndroidGeneralSettings() async {
    try {
      // First try using Android Intent (more reliable)
      try {
        final intent = AndroidIntent(action: 'android.settings.SETTINGS');
        await intent.launch();
        return true;
      } catch (e) {
        print('SettingsOpener: Android Intent for general settings failed: $e');
      }

      // Fallback to URL launcher with different formats
      final List<String> generalUrls = [
        'android-app://android.settings.SETTINGS',
        'android-app://com.android.settings/.Settings',
        'android-app://com.android.settings/.Settings\$MainSettingsActivity',
      ];

      for (final url in generalUrls) {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            return await launchUrl(Uri.parse(url));
          }
        } catch (e) {
          print('SettingsOpener: Failed to open $url: $e');
          continue;
        }
      }

      return false;
    } catch (e) {
      print('SettingsOpener: Error opening Android general settings: $e');
      return false;
    }
  }

  /// Open iOS Screen Time settings
  static Future<bool> _openIOSScreenTimeSettings() async {
    try {
      // iOS Screen Time settings URL
      const String screenTimeUrl = 'App-prefs:SCREEN_TIME';

      if (await canLaunchUrl(Uri.parse(screenTimeUrl))) {
        return await launchUrl(Uri.parse(screenTimeUrl));
      }

      // Fallback to general iOS settings
      return await launchUrl(Uri.parse('App-prefs:'));
    } catch (e) {
      print('SettingsOpener: Error opening iOS Screen Time settings: $e');
      return false;
    }
  }

  /// Open general device settings
  static Future<bool> openGeneralSettings() async {
    try {
      if (PlatformHelper.isAndroid) {
        return await _openAndroidGeneralSettings();
      } else if (PlatformHelper.isIOS) {
        return await launchUrl(Uri.parse('App-prefs:'));
      }
      return false;
    } catch (e) {
      print('SettingsOpener: Error opening general settings: $e');
      return false;
    }
  }

  /// Show platform-specific instructions for enabling permissions
  static String getPermissionInstructions() {
    if (PlatformHelper.isAndroid) {
      return '''To enable usage access:

1. Go to Settings > Apps & notifications
2. Tap "Special app access"
3. Tap "Usage access"
4. Find "The Lost Years" and enable it
5. Return to this app and refresh''';
    } else if (PlatformHelper.isIOS) {
      return '''To enable Screen Time access:

1. Go to Settings > Screen Time
2. Tap "App Limits"
3. Enable Screen Time permissions
4. Return to this app and refresh

Note: Screen Time API access requires additional setup.''';
    }
    return 'Please check your device settings for usage access permissions.';
  }
}

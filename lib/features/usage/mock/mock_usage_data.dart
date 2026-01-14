import '../../../core/models/app_usage.dart';

class MockUsageData {
  static List<AppUsage> get today => [
    AppUsage(
      packageName: 'com.apple.Safari',
      appName: 'Safari',
      totalTimeForeground: 480000,
      lastTimeUsed: DateTime.now().millisecondsSinceEpoch - 300000,
      firstTimeStamp: DateTime.now().millisecondsSinceEpoch - 480000,
      lastTimeStamp: DateTime.now().millisecondsSinceEpoch - 300000,
      iconBase64: '',
    ),
    AppUsage(
      packageName: 'com.apple.Music',
      appName: 'Music',
      totalTimeForeground: 180000,
      lastTimeUsed: DateTime.now().millisecondsSinceEpoch - 600000,
      firstTimeStamp: DateTime.now().millisecondsSinceEpoch - 180000,
      lastTimeStamp: DateTime.now().millisecondsSinceEpoch - 600000,
      iconBase64: '',
    ),
    AppUsage(
      packageName: 'com.apple.Photos',
      appName: 'Photos',
      totalTimeForeground: 60000,
      lastTimeUsed: DateTime.now().millisecondsSinceEpoch - 1200000,
      firstTimeStamp: DateTime.now().millisecondsSinceEpoch - 60000,
      lastTimeStamp: DateTime.now().millisecondsSinceEpoch - 1200000,
      iconBase64: '',
    ),
    AppUsage(
      packageName: 'com.apple.Messages',
      appName: 'Messages',
      totalTimeForeground: 240000,
      lastTimeUsed: DateTime.now().millisecondsSinceEpoch - 180000,
      firstTimeStamp: DateTime.now().millisecondsSinceEpoch - 240000,
      lastTimeStamp: DateTime.now().millisecondsSinceEpoch - 180000,
      iconBase64: '',
    ),
    AppUsage(
      packageName: 'com.apple.Maps',
      appName: 'Maps',
      totalTimeForeground: 120000,
      lastTimeUsed: DateTime.now().millisecondsSinceEpoch - 900000,
      firstTimeStamp: DateTime.now().millisecondsSinceEpoch - 120000,
      lastTimeStamp: DateTime.now().millisecondsSinceEpoch - 900000,
      iconBase64: '',
    ),
  ];

  static List<AppUsage> get empty => [];
}

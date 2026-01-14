class AppUsage {
  final String packageName;
  final String appName;
  final int totalTimeForeground;
  final int lastTimeUsed;
  final int firstTimeStamp;
  final int lastTimeStamp;
  final String iconBase64;
  final String? error;

  AppUsage({
    required this.packageName,
    required this.appName,
    required this.totalTimeForeground,
    required this.lastTimeUsed,
    required this.firstTimeStamp,
    required this.lastTimeStamp,
    required this.iconBase64,
    this.error,
  });

  factory AppUsage.fromMap(Map<dynamic, dynamic> map) {
    return AppUsage(
      packageName: map['packageName'] ?? '',
      appName: map['appName'] ?? map['packageName'] ?? 'Unknown App',
      totalTimeForeground: map['totalTimeForeground'] ?? 0,
      lastTimeUsed: map['lastTimeUsed'] ?? 0,
      firstTimeStamp: map['firstTimeStamp'] ?? 0,
      lastTimeStamp: map['lastTimeStamp'] ?? 0,
      iconBase64: map['iconBase64'] ?? '',
      error: map['error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'totalTimeForeground': totalTimeForeground,
      'lastTimeUsed': lastTimeUsed,
      'firstTimeStamp': firstTimeStamp,
      'lastTimeStamp': lastTimeStamp,
      'iconBase64': iconBase64,
      'error': error,
    };
  }

  @override
  String toString() {
    return 'AppUsage(packageName: $packageName, appName: $appName, totalTimeForeground: $totalTimeForeground)';
  }
}

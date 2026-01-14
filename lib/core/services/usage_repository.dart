import '../models/app_usage.dart';
import 'usage_service.dart';

class UsageRepository {
  static final UsageRepository _instance = UsageRepository._internal();
  factory UsageRepository() => _instance;
  UsageRepository._internal();

  List<AppUsage> _cachedUsage = [];
  DateTime? _lastFetch;

  /// Get usage statistics with caching and sorting
  Future<List<AppUsage>> getUsageStats({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _cachedUsage.isNotEmpty && _lastFetch != null) {
      final now = DateTime.now();
      final cacheAge = now.difference(_lastFetch!);
      if (cacheAge.inMinutes < 5) {
        // Cache for 5 minutes
        return _cachedUsage;
      }
    }

    final result = await UsageService.getUsageStatsWithErrorHandling();

    if (result.isSuccess && result.data != null) {
      _cachedUsage = _sortUsageByTime(result.data!);
      _lastFetch = DateTime.now();
      return _cachedUsage;
    } else {
      throw Exception(result.error ?? 'Failed to fetch usage stats');
    }
  }

  /// Sort usage data by total time (descending)
  List<AppUsage> _sortUsageByTime(List<AppUsage> usage) {
    final sorted = List<AppUsage>.from(usage);
    sorted.sort(
      (a, b) => b.totalTimeForeground.compareTo(a.totalTimeForeground),
    );
    return sorted;
  }

  /// Get top N apps by usage time
  List<AppUsage> getTopApps(List<AppUsage> usage, {int limit = 10}) {
    return usage.take(limit).toList();
  }

  /// Get total usage time across all apps
  int getTotalUsageTime(List<AppUsage> usage) {
    return usage.fold(0, (sum, app) => sum + app.totalTimeForeground);
  }

  /// Get usage statistics summary
  UsageSummary getUsageSummary(List<AppUsage> usage) {
    final totalTime = getTotalUsageTime(usage);
    final topApps = getTopApps(usage, limit: 5);

    return UsageSummary(
      totalApps: usage.length,
      totalUsageTime: totalTime,
      topApps: topApps,
      averageUsagePerApp: usage.isNotEmpty ? totalTime ~/ usage.length : 0,
    );
  }

  /// Clear cache
  void clearCache() {
    _cachedUsage.clear();
    _lastFetch = null;
  }
}

class UsageSummary {
  final int totalApps;
  final int totalUsageTime;
  final List<AppUsage> topApps;
  final int averageUsagePerApp;

  UsageSummary({
    required this.totalApps,
    required this.totalUsageTime,
    required this.topApps,
    required this.averageUsagePerApp,
  });
}

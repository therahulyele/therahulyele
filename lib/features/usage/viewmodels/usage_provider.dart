import 'package:flutter/material.dart';
import '../../../core/models/app_usage.dart';
import '../../../core/services/usage_repository.dart';

class UsageProvider extends ChangeNotifier {
  final UsageRepository _repository = UsageRepository();

  List<AppUsage> _usage = [];
  bool _loading = false;
  String? _error;
  bool _hasPermission = false;

  List<AppUsage> get usage => _usage;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasPermission => _hasPermission;

  UsageSummary? get summary {
    if (_usage.isEmpty) return null;
    return _repository.getUsageSummary(_usage);
  }

  Future<void> loadUsage({bool forceRefresh = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _usage = await _repository.getUsageStats(forceRefresh: forceRefresh);
      _hasPermission = true;
    } catch (e) {
      _error = e.toString();
      _hasPermission = false;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refreshUsage() async {
    await loadUsage(forceRefresh: true);
  }

  Future<bool> checkPermission() async {
    try {
      // This would check actual permissions
      _hasPermission = true;
      notifyListeners();
      return true;
    } catch (e) {
      _hasPermission = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      // This would request actual permissions
      _hasPermission = true;
      notifyListeners();
      return true;
    } catch (e) {
      _hasPermission = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

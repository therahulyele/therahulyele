import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeData get currentTheme =>
      _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    if (_isDark != isDark) {
      _isDark = isDark;
      notifyListeners();
    }
  }

  void setLightTheme() {
    if (_isDark) {
      _isDark = false;
      notifyListeners();
    }
  }

  void setDarkTheme() {
    if (!_isDark) {
      _isDark = true;
      notifyListeners();
    }
  }
}

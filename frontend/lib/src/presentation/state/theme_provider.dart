import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../utils/logger.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  ThemeData _themeData = AppTheme.lightTheme;
  AppThemeMode _themeMode = AppThemeMode.light;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  AppThemeMode get themeMode => _themeMode;
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    // Default to system to avoid white flash on startup.
    WidgetsBinding.instance.addObserver(this);
    _applyTheme(AppThemeMode.system);
    _loadThemePreference();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == AppThemeMode.system) {
      _applyTheme(AppThemeMode.system);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex =
          prefs.getInt('theme_mode') ?? AppThemeMode.system.index;
      _themeMode = AppThemeMode.values[themeModeIndex];
      _applyTheme(_themeMode);
    } catch (e) {
      Logger.warning('Error loading theme preference: $e');
      _applyTheme(AppThemeMode.light);
    }
  }

  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', _themeMode.index);
    } catch (e) {
      Logger.warning('Error saving theme preference: $e');
    }
  }

  void _applyTheme(AppThemeMode mode) {
    _themeMode = mode;
    
    if (mode == AppThemeMode.system) {
      // Use system brightness
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    } else {
      _isDarkMode = mode == AppThemeMode.dark;
    }

    _themeData = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
    _saveThemePreference();
  }

  void setThemeMode(AppThemeMode mode) {
    _applyTheme(mode);
    Logger.info('Theme changed to: ${mode.name}');
  }

  void toggleTheme() {
    final newMode = _isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    setThemeMode(newMode);
  }
}

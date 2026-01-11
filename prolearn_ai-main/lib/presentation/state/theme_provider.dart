import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppTheme.lightTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData == AppTheme.lightTheme ? ThemeData.dark() : AppTheme.lightTheme;
    notifyListeners();
  }
}

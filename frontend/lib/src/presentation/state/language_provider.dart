import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, filipino, bisaya }

class LanguageProvider with ChangeNotifier {
  static const _storageKey = 'app_language';

  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final index = prefs.getInt(_storageKey);
      if (index != null && index >= 0 && index < AppLanguage.values.length) {
        _language = AppLanguage.values[index];
        notifyListeners();
      }
    } catch (_) {
      // Keep default English if preference fails to load.
    }
  }

  Future<void> _saveLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_storageKey, _language.index);
    } catch (_) {
      // Ignore save errors.
    }
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
    _saveLanguagePreference();
  }

  String labelFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.filipino:
        return 'Filipino';
      case AppLanguage.bisaya:
        return 'Bisaya';
    }
  }
}

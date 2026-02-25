import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class AppStateManager {
  // We'll manage the entire CupertinoThemeData instance here
  final darkModeNotifier =
      ValueNotifier<CupertinoThemeData>(AppTheme.darkTheme);

  // Getter for the current theme data
  CupertinoThemeData get theme => darkModeNotifier.value;

  void init() {
    final isDarkMode = getIt<UserSettings>().getDarkMode();
    _setTheme(isDarkMode);
  }

  void setDarkMode(bool isDarkMode) {
    _setTheme(isDarkMode);
    getIt<UserSettings>().setDarkMode(isDarkMode);
  }

  // Private helper to set the theme based on dark mode status
  void _setTheme(bool isDarkMode) {
    darkModeNotifier.value =
        isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  void setFontSize(double value) {
    // If you want to change font size dynamically across the app,
    // you'll need to create new ThemeData instances with updated font sizes
    // and notify listeners. This will be a more complex change.
    // For now, let's keep it as a placeholder or remove if not actively used to update theme.
    getIt<UserSettings>().setFontSize(value);
  }
}

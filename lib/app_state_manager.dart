import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class AppStateManager {
  final darkModeNotifier =
      ValueNotifier<CupertinoThemeData>(AppTheme.darkTheme);
  CupertinoThemeData get theme => darkModeNotifier.value;

  void init() {
    final isDarkMode = getIt<UserSettings>().getDarkMode();
    isDarkMode
        ? darkModeNotifier.value = AppTheme.darkTheme
        : darkModeNotifier.value = AppTheme.lightTheme;
  }

  void toggleDarkMode() {
    final isDarkMode = !getIt<UserSettings>().getDarkMode();
    isDarkMode
        ? darkModeNotifier.value = AppTheme.darkTheme
        : darkModeNotifier.value = AppTheme.lightTheme;

    getIt<UserSettings>().setDarkMode(isDarkMode);
  }

  void setFontSize(double value) {
    getIt<UserSettings>().setFontSize(value);
  }
}

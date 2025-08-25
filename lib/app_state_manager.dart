import 'package:flutter/foundation.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class AppStateManager {
  final darkModeNotifier = ValueNotifier<bool>(false);
  void init() {
    darkModeNotifier.value = getIt<UserSettings>().getDarkMode();
  }

  void toggleDarkMode() {
    darkModeNotifier.value = !darkModeNotifier.value;
    getIt<UserSettings>().setDarkMode(darkModeNotifier.value);
  }

  void setFontSize(double value) {
    getIt<UserSettings>().setFontSize(value);
  }
}

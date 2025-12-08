import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

class SettingsManager {
  final appstatemanager = getIt<AppStateManager>();
  void toggleDarkMode() {
    final isDarkMode = !getIt<UserSettings>().getDarkMode();
    appstatemanager.setDarkMode(isDarkMode);
  }

  void dragFontSize(double value) {
    appstatemanager.setFontSize(value);
  }
}

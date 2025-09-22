import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';

class SettingsManager {
  final appstatemanager = getIt<AppStateManager>();
  void toggleDarkMode() {
    appstatemanager.toggleDarkMode();
  }
}

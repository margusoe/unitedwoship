import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart'; // Add this
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

  // --- UPDATED METHOD ---
  Future<void> setUserName(String name) async {
    final pb = getIt<PocketBaseService>().pb;
    final userId = pb.authStore.record?.id;

    if (userId != null && userId.isNotEmpty) {
      try {
        // 1. Update PocketBase server
        await pb.collection('users').update(userId, body: {
          'name': name,
        });

        // 2. Update local UI state
        getIt<UserSettings>().setUserName(name);
      } catch (e) {
        debugPrint("Failed to update name on server: $e");
        // You could show an error dialog here if needed
      }
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart'; // Add this import
import 'package:pocketbase/pocketbase.dart';

class AuthManager {
  final PocketBaseService _pbService = getIt<PocketBaseService>();

  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> init() async {
    isAuthenticated.value = _pbService.pb.authStore.isValid;
    if (isAuthenticated.value) {
      _syncNameFromAuthStore(); // Grab name if already logged in
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _pbService.pb.collection('users').authWithPassword(email, password);
      _syncNameFromAuthStore(); // Grab name on new login
      isAuthenticated.value = true;
    } on ClientException catch (e) {
      debugPrint('Login Error: ${e.response}');
      throw Exception('Invalid email or password.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      await _pbService.pb.collection('users').create(body: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'emailVisibility': false,
        'verified': false,
      });
      await login(email, password);
    } on ClientException catch (e) {
      debugPrint('Registration Error: ${e.response}');
      throw Exception('Failed to create account.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    _pbService.pb.authStore.clear();
    await getIt<SongDatabase>().clearAll();
    isAuthenticated.value = false;
  }

  // --- NEW HELPER METHOD ---
  void _syncNameFromAuthStore() {
    final model = _pbService.pb.authStore.model as RecordModel?;
    if (model != null) {
      final pbName = model.getStringValue('name');
      if (pbName.isNotEmpty) {
        getIt<UserSettings>().setUserName(pbName);
      }
    }
  }
}

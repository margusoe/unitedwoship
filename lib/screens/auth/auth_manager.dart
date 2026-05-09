// lib/screens/auth/auth_manager.dart
import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';

class AuthManager {
  final PocketBaseService _pbService = getIt<PocketBaseService>();

  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> init() async {
    // Check if the user already has a valid session token saved locally
    isAuthenticated.value = _pbService.pb.authStore.isValid;
  }

  /// Logs in an existing user
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      await _pbService.pb.collection('users').authWithPassword(email, password);

      isAuthenticated.value = true;
    } on ClientException catch (e) {
      debugPrint('Login Error: ${e.response}');
      throw Exception('Invalid email or password.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Registers a new user and automatically logs them in
  /// Registers a new user and automatically logs them in
  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;

      // 1. Create the user in PocketBase
      await _pbService.pb.collection('users').create(body: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': password,
        // Add these two fields to satisfy PocketBase requirements:
        'emailVisibility': false,
        'verified': false,
      });

      // 2. Automatically log them in after successful registration
      await login(email, password);
    } on ClientException catch (e) {
      debugPrint('Registration Error: ${e.response}');
      throw Exception(
          'Failed to create account. Email might already be in use or password is too short (min 8 chars).');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logs the user out
  Future<void> signOut() async {
    _pbService.pb.authStore.clear();

    // Clear local data so the next user has a fresh slate
    await getIt<SongDatabase>().clearAll();

    isAuthenticated.value = false;
  }
}

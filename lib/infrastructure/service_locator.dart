// lib/infrastructure/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/live_mode_manager.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart';
import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/auth/auth_manager.dart'; // Added

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Initialize PocketBase Service first (sync wait)
  final pbService = PocketBaseService();
  await pbService.init();
  getIt.registerSingleton<PocketBaseService>(pbService);

  // 2. Register other services
  getIt.registerLazySingleton<AppStateManager>(() => AppStateManager());
  getIt.registerLazySingleton<SongDatabase>(() => SongDatabase());
  getIt.registerLazySingleton<HomeManager>(() => HomeManager());
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());

  // 3. Register AuthManager
  getIt.registerLazySingleton<AuthManager>(() => AuthManager());
  // lib/infrastructure/service_locator.dart
  getIt.registerLazySingleton<SyncManager>(() => SyncManager());
  getIt.registerLazySingleton<LiveModeManager>(() => LiveModeManager());
}

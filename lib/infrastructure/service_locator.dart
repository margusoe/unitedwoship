// lib/infrastructure/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/song_database.dart';
import 'package:unitedwoship/infrastructure/pocketbase_service.dart';
import 'package:unitedwoship/infrastructure/sync_manager.dart';
import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/auth/auth_manager.dart';
import 'package:unitedwoship/screens/set/setlist_manager.dart'; // Added

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final pbService = PocketBaseService();
  await pbService.init();
  getIt.registerSingleton<PocketBaseService>(pbService);
  getIt.registerLazySingleton<AppStateManager>(() => AppStateManager());
  getIt.registerLazySingleton<SongDatabase>(() => SongDatabase());
  getIt.registerLazySingleton<HomeManager>(() => HomeManager());
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
  getIt.registerLazySingleton<AuthManager>(() => AuthManager());
  getIt.registerLazySingleton<SyncManager>(() => SyncManager());
  getIt.registerLazySingleton<SetlistManager>(() => SetlistManager());
}

import 'package:get_it/get_it.dart';
import 'package:magtaalhundetgel/app_state_manager.dart';
import 'package:magtaalhundetgel/screens/home/home_manager.dart';
import 'package:magtaalhundetgel/infrastructure/in_app_storage.dart';
import 'package:magtaalhundetgel/infrastructure/user_settings.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AppStateManager>(() => AppStateManager());
  getIt.registerLazySingleton<SongDatabase>(() => SongDatabase());
  getIt.registerLazySingleton<HomeManager>(() => HomeManager());
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
}

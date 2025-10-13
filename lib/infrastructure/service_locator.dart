import 'package:get_it/get_it.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/web_api.dart';
import 'package:unitedwoship/screens/home/home_manager.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AppStateManager>(() => AppStateManager());
  getIt.registerLazySingleton<SongDatabase>(() => SongDatabase());
  getIt.registerLazySingleton<HomeManager>(() => HomeManager());
  getIt.registerLazySingleton<UserSettings>(() => UserSettings());
  getIt.registerLazySingleton<WebApi>(() => WebApi());
}

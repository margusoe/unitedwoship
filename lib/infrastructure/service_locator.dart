import 'package:get_it/get_it.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SongDatabase>(() => SongDatabase());
}

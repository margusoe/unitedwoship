import 'package:flutter/material.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/home/home_screen.dart';
import 'package:unitedwoship/infrastructure/in_app_storage.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<SongDatabase>().init();
  await getIt<UserSettings>().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final manager = getIt<AppStateManager>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: manager.darkModeNotifier,
        builder: (context, isDarkMode, child) {
          print(isDarkMode);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: HomeScreen(),
          );
        });
  }
}

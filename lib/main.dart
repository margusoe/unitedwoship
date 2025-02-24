import 'package:flutter/material.dart';
import 'package:magtaalhundetgel/app_state_manager.dart';
import 'package:magtaalhundetgel/screens/home/home_screen.dart';
import 'package:magtaalhundetgel/infrastructure/in_app_storage.dart';
import 'package:magtaalhundetgel/infrastructure/service_locator.dart';
import 'package:magtaalhundetgel/infrastructure/user_settings.dart';

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode
                // ? ThemeData(colorScheme: MaterialTheme.darkScheme())
                // : ThemeData(colorScheme: MaterialTheme.lightScheme()),
                ? ThemeData(
                    colorSchemeSeed: Colors.blue, brightness: Brightness.dark)
                : ThemeData(
                    colorSchemeSeed: Colors.grey[800],
                    brightness: Brightness.light),
            home: HomeScreen(),
          );
        });
  }
}

// lib/main.dart
import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/auth/auth_manager.dart'; // Added
import 'package:unitedwoship/screens/auth/auth_screen.dart'; // Added
import 'package:unitedwoship/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: setupServiceLocator is now async
  await setupServiceLocator();

  await getIt<UserSettings>().init();
  getIt<AppStateManager>().init();

  // Initialize Auth Manager
  await getIt<AuthManager>().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appstatemanager = getIt<AppStateManager>();
  final authManager = getIt<AuthManager>(); // Grab AuthManager

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CupertinoThemeData>(
        valueListenable: appstatemanager.darkModeNotifier,
        builder: (context, theme, child) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'United Worship',
            // Listen to Auth State to determine which screen to show
            home: ValueListenableBuilder<bool>(
              valueListenable: authManager.isAuthenticated,
              builder: (context, isAuthenticated, child) {
                if (isAuthenticated) {
                  return const HomeScreen();
                } else {
                  return const AuthScreen();
                }
              },
            ),
          );
        });
  }
}

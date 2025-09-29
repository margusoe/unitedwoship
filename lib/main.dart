import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_state_manager.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<UserSettings>().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appstatemanager = getIt<AppStateManager>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CupertinoThemeData>(
        valueListenable: appstatemanager.darkModeNotifier,
        builder: (context, theme, child) {
          return CupertinoApp(
            theme: theme, // This is where the theme is applied
            title: 'United Worship',
            home: const HomeScreen(),
          );
        });
  }
}

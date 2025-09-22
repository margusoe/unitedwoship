import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/infrastructure/service_locator.dart';
import 'package:unitedwoship/infrastructure/user_settings.dart';
import 'package:unitedwoship/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<UserSettings>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettings = getIt<UserSettings>();
    return ValueListenableBuilder<bool>(
      valueListenable: userSettings.isDarkMode,
      builder: (context, isDarkMode, child) {
        return CupertinoApp(
          theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          title: 'United Worship',
          home: const HomeScreen(),
        );
      },
    );
  }
}

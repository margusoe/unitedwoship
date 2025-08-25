import 'package:flutter/cupertino.dart';
import 'package:unitedwoship/app_theme.dart';
import 'package:unitedwoship/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: AppTheme.cupertinoTheme,
      title: 'United Worship',
      home: const HomeScreen(),
    );
  }
}

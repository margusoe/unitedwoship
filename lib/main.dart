import 'package:flutter/material.dart';
import 'package:unitedwoship/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade700),
        drawerTheme: DrawerThemeData(),
      ),
      home: HomeScreen(),
    );
  }
}

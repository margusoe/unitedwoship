import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  late final SharedPreferences prefs;

  final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isDarkMode.value = getDarkMode();
  }

  static const _isDarkModeKey = "isDarkMode";

  Future<void> setDarkMode(bool isDarkMode) async {
    await prefs.setBool(_isDarkModeKey, isDarkMode);
    this.isDarkMode.value = isDarkMode;
  }

  bool getDarkMode() {
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  static const _fontSizeKey = "fontSize";

  Future<void> setFontSize(double fontSize) async {
    await prefs.setDouble(_fontSizeKey, fontSize);
  }

  double getFontSize() {
    return prefs.getDouble(_fontSizeKey) ?? 17.0;
  }
}
import 'package:flutter/cupertino.dart';

class AppTheme {
  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF101823);
  static const Color darkSurfaceColor = Color(0xFF1B2531);
  static const Color darkPrimaryColor = Color(0xFF7EB6FD);
  static const Color darkOnPrimaryColor = Color(0xFF162432);
  static const Color darkTextColor = Color(0xFFECECED);
  static const Color darkSecondaryTextColor = Color(0xFF87A2C6);

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightSurfaceColor = Color(0xFFE8EDF2);
  static const Color lightPrimaryColor = Color(0xFF8AB4F8);
  static const Color lightOnPrimaryColor = Color(0xFF202124);
  static const Color lightTextColor = Color(0xFF202124);
  static const Color lightSecondaryTextColor = Color(0xFF5F6368);

  // Dark Text Styles
  static const TextStyle darkTitleStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: darkTextColor,
  );
  static const TextStyle darkBodyStyle = TextStyle(color: darkTextColor, fontSize: 12);
  static const TextStyle darkHintStyle = TextStyle(color: darkSecondaryTextColor);

  // Light Text Styles
  static const TextStyle lightTitleStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: lightTextColor,
  );
  static const TextStyle lightBodyStyle = TextStyle(color: lightTextColor, fontSize: 12);
  static const TextStyle lightHintStyle = TextStyle(color: lightSecondaryTextColor);

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    barBackgroundColor: darkBackgroundColor,
    textTheme: CupertinoTextThemeData(
      textStyle: darkBodyStyle,
      primaryColor: darkPrimaryColor,
      navTitleTextStyle: darkTitleStyle.copyWith(fontSize: 17, color: darkTextColor),
      navLargeTitleTextStyle:
          darkTitleStyle.copyWith(fontSize: 34, color: darkTextColor),
      navActionTextStyle: TextStyle(color: darkPrimaryColor),
      pickerTextStyle: darkBodyStyle,
      dateTimePickerTextStyle: darkBodyStyle,
    ),
  );

  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    barBackgroundColor: lightBackgroundColor,
    textTheme: CupertinoTextThemeData(
      textStyle: lightBodyStyle,
      primaryColor: lightPrimaryColor,
      navTitleTextStyle: lightTitleStyle.copyWith(fontSize: 17, color: lightTextColor),
      navLargeTitleTextStyle:
          lightTitleStyle.copyWith(fontSize: 34, color: lightTextColor),
      navActionTextStyle: TextStyle(color: lightPrimaryColor),
      pickerTextStyle: lightBodyStyle,
      dateTimePickerTextStyle: lightBodyStyle,
    ),
  );

  static final BoxDecoration darkTextFieldDecoration = BoxDecoration(
    color: darkSurfaceColor,
    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  );

  static final BoxDecoration lightTextFieldDecoration = BoxDecoration(
    color: lightSurfaceColor,
    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  );
}
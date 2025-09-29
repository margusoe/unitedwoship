import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color darkBackgroundColor = Color(0xFF101823);
  static const Color darkSurfaceColor = Color(0xFF1B2531);
  static const Color darkPrimaryColor = Color(0xFF7EB6FD);
  static const Color darkOnPrimaryColor = Color(0xFF162432);
  static const Color darkTextColor = Color(0xFFECECED);
  static const Color darkSecondaryTextColor = Color(0xFF87A2C6);

  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightSurfaceColor = Color(0xFFE8EDF2);
  static const Color lightPrimaryColor = Color(0xFF8AB4F8);
  static const Color lightOnPrimaryColor = Color(0xFF202124);
  static const Color lightTextColor = Color(0xFF202124);
  static const Color lightSecondaryTextColor = Color(0xFF5F6368);

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    barBackgroundColor: darkBackgroundColor,
    textTheme: CupertinoTextThemeData(
      textStyle: _getBaseTextStyle(Brightness.dark),
      primaryColor: darkPrimaryColor,
      navTitleTextStyle: _getNavTitleTextStyle(Brightness.dark),
      navLargeTitleTextStyle: _getNavLargeTitleTextStyle(Brightness.dark),
      navActionTextStyle: _getNavActionTextStyle(Brightness.dark),
      pickerTextStyle: _getBaseTextStyle(Brightness.dark),
      dateTimePickerTextStyle: _getBaseTextStyle(Brightness.dark),
    ),
  );

  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    barBackgroundColor: lightBackgroundColor,
    textTheme: CupertinoTextThemeData(
      // Define base text style for the theme
      textStyle: _getBaseTextStyle(Brightness.light),
      primaryColor: lightPrimaryColor,
      navTitleTextStyle: _getNavTitleTextStyle(Brightness.light),
      navLargeTitleTextStyle: _getNavLargeTitleTextStyle(Brightness.light),
      navActionTextStyle: _getNavActionTextStyle(Brightness.light),
      pickerTextStyle: _getBaseTextStyle(Brightness.light),
      dateTimePickerTextStyle: _getBaseTextStyle(Brightness.light),
    ),
  );

  static Color _getTextColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextColor : lightTextColor;

  static Color _getSecondaryTextColor(Brightness brightness) =>
      brightness == Brightness.dark
          ? darkSecondaryTextColor
          : lightSecondaryTextColor;

  static Color _getSurfaceColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurfaceColor : lightSurfaceColor;

  static Color _getPrimaryColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkPrimaryColor : lightPrimaryColor;

  static Color _getSecondaryColor(Brightness brightness) =>
      brightness == Brightness.dark
          ? darkSecondaryTextColor
          : lightSecondaryTextColor;

  static Color _getOnPrimaryColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkOnPrimaryColor : lightOnPrimaryColor;

  // Generic Text Styles that derive from the theme's brightness
  static TextStyle _getBaseTextStyle(Brightness brightness) => TextStyle(
        color: _getTextColor(brightness),
        fontSize: 12,
      );

  static TextStyle _getTitleStyle(Brightness brightness) => TextStyle(
        fontWeight: FontWeight.w400,
        color: _getTextColor(brightness),
      );

  static TextStyle _getHintStyle(Brightness brightness) => TextStyle(
        color: _getSecondaryTextColor(brightness),
      );

  static TextStyle _getNavTitleTextStyle(Brightness brightness) =>
      _getTitleStyle(brightness)
          .copyWith(fontSize: 17, color: _getTextColor(brightness));

  static TextStyle _getNavLargeTitleTextStyle(Brightness brightness) =>
      _getTitleStyle(brightness)
          .copyWith(fontSize: 34, color: _getTextColor(brightness));

  static TextStyle _getNavActionTextStyle(Brightness brightness) =>
      TextStyle(color: _getPrimaryColor(brightness));

  static TextStyle titleStyle(BuildContext context) =>
      _getTitleStyle(CupertinoTheme.of(context).brightness ?? Brightness.light);

  static TextStyle bodyStyle(BuildContext context) => _getBaseTextStyle(
      CupertinoTheme.of(context).brightness ?? Brightness.light);

  static TextStyle hintStyle(BuildContext context) =>
      _getHintStyle(CupertinoTheme.of(context).brightness ?? Brightness.light);

  static Color surfaceColor(BuildContext context) => _getSurfaceColor(
      CupertinoTheme.of(context).brightness ?? Brightness.light);

  static Color primaryColor(BuildContext context) => _getPrimaryColor(
      CupertinoTheme.of(context).brightness ?? Brightness.light);

  static Color secondaryColor(BuildContext context) => _getSecondaryColor(
      CupertinoTheme.of(context).brightness ?? Brightness.light);

  static Color onPrimaryColor(BuildContext context) => _getOnPrimaryColor(
      CupertinoTheme.of(context).brightness ?? Brightness.light);

  static BoxDecoration textFieldDecoration(BuildContext context) {
    final brightness =
        CupertinoTheme.of(context).brightness ?? Brightness.light;
    return BoxDecoration(
      color: _getSurfaceColor(brightness),
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
    );
  }
}

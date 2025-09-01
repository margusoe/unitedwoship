import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF101823);
  static const Color surfaceColor =
      Color(0xFF1B2531); // for text fields, cards, etc.
  static const Color primaryColor = Color(0xFF7EB6FD); // button color
  static const Color onPrimaryColor = Color(0xFF162432); // button text color

  static const Color textColor = Color(0xFFECECED);
  static const Color secondaryTextColor = Color(0xFF87A2C6); // hint text

  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(color: textColor, fontSize: 12);
  static const TextStyle hintStyle = TextStyle(color: secondaryTextColor);

  static final CupertinoThemeData cupertinoTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    barBackgroundColor: backgroundColor,
    textTheme: CupertinoTextThemeData(
      textStyle: bodyStyle,
      primaryColor: primaryColor,
      navTitleTextStyle: titleStyle.copyWith(fontSize: 17, color: textColor),
      navLargeTitleTextStyle:
          titleStyle.copyWith(fontSize: 34, color: textColor),
      navActionTextStyle: TextStyle(color: primaryColor),
      pickerTextStyle: bodyStyle,
      dateTimePickerTextStyle: bodyStyle,
    ),
  );

  static final BoxDecoration textFieldDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  );
}

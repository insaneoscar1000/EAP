import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xff0F6358),
    splashColor: Color(0xffE3BD36),
    indicatorColor: Color(0xff0F6358),
    secondaryHeaderColor: Color(0xFFE8ECF4),
    primaryColorDark: Color(0xff000000),
    primaryColorLight: Color(0xffF4F4F4),
    fontFamily: 'Urbanist',
  );
}

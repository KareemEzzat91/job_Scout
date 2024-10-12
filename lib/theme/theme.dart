import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.lightPrimary,
  hintColor: AppColors.lightSecondary,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  primaryColor: AppColors.darkPrimary,
  hintColor: AppColors.darkSecondary,
  brightness: Brightness.dark,
);

class AppColors {
  static const Color lightPrimary = Colors.white;
  static const Color lightSecondary = Colors.black;

  static const Color darkPrimary = Colors.black;
  static const Color darkSecondary = Colors.white;
}

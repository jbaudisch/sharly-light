import 'package:flutter/material.dart';

/// Abstract class containing the apps theme-data
abstract class SharlyTheme {
  static const sharlyCardTheme = CardTheme(
    elevation: 0,
    margin: EdgeInsets.all(2),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );

  static const dropDownTheme = DropdownMenuThemeData(
      inputDecorationTheme:
          InputDecorationTheme(focusColor: Colors.transparent));

  static final commonTheme = ThemeData(
    focusColor: Colors.transparent,
    useMaterial3: true,
    dropdownMenuTheme: dropDownTheme,
  );

  static final lightTheme = ThemeData(
    focusColor: Colors.transparent,
    dropdownMenuTheme: dropDownTheme,
    useMaterial3: true,
    brightness: Brightness.light,
    cardTheme: sharlyCardTheme.copyWith(color: lightColorScheme.surfaceVariant),
    colorScheme: lightColorScheme,
    appBarTheme: const AppBarTheme(
        color: Color(0xfff5f5f5), surfaceTintColor: Colors.grey),
    scaffoldBackgroundColor: const Color(0xfffffdfc),
  );

  static final darkTheme = ThemeData(
      focusColor: Colors.transparent,
      dropdownMenuTheme: dropDownTheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xff1f1f1f),
      brightness: Brightness.dark,
      shadowColor: Colors.transparent,
      cardTheme:
          sharlyCardTheme.copyWith(color: darkColorScheme.surfaceVariant),
      applyElevationOverlayColor: true,
      appBarTheme: const AppBarTheme(
          color: Color(0xff1f1f1f), surfaceTintColor: Colors.grey),
      colorScheme: darkColorScheme);

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    brightness: Brightness.dark,
  );

  static final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent, brightness: Brightness.light);
}

import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final primaryColor = const Color(0xFF1A2185);
  static final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
  );

  static ThemeData getTheme() => ThemeData(
    colorScheme: colorScheme,
    fontFamily: 'Archivo',
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: colorScheme.error),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: colorScheme.primary,
      ),
    ),
    useMaterial3: true,
  );
}

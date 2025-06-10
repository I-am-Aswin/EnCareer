import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Colors.blue),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.blueAccent, brightness: Brightness.light),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(color: Colors.indigo[900]),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
        .copyWith(secondary: Colors.indigoAccent, brightness: Brightness.dark),
  );
}
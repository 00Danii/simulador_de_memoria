import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Colors.white,
    secondary: Color(0xFF5B7D61),
    onSecondary: Colors.white,
    error: Color.fromARGB(255, 252, 11, 103),
    onError: Colors.white,
    background: Color(0xFFE2E2E2),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);

var darkTheme = ThemeData(
    // brightness: Brightness.dark,
    colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 144, 244, 148),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color(0xffba92b8),
    onSecondary: Colors.white,
    error: Color(0xfff974a6),
    onError: Colors.white,
    background: Color.fromARGB(255, 0, 0, 0),
    onBackground: Colors.white,
    surface: Color.fromARGB(255, 0, 0, 0),
    onSurface: Colors.white,
  ),
);

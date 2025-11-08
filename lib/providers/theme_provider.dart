import 'package:flutter/material.dart';

// Dark theme only - light mode removed
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.transparent, // REQUIRED for glass effect
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF3B82F6),
    surface: Color(0xFF1C1C1E),
  ),
  // Custom fonts applied throughout
  textTheme: const TextTheme(
    // Display styles - BebasNeue for headers
    displayLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 57,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 45,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ),
    // Headline styles - BebasNeue for titles
    headlineLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    // Title styles - use BebasNeue for headings (requested font)
    titleLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    // Body styles - Lato for content
    bodyLarge: TextStyle(fontFamily: 'Lato', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Lato', fontSize: 14),
    bodySmall: TextStyle(fontFamily: 'Lato', fontSize: 12),
    // Label styles - Lato for labels
    labelLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  ),
  // Apply custom fonts to buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white70,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
        fontSize: 14,
      ),
    ),
  ),
  // Apply custom fonts to input fields
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Lato'),
    hintStyle: TextStyle(fontFamily: 'Lato'),
    helperStyle: TextStyle(fontFamily: 'Lato'),
    errorStyle: TextStyle(fontFamily: 'Lato'),
  ),
  // Apply custom fonts to app bar
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
);

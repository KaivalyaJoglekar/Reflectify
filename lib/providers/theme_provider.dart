import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// Light theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF3B82F6),
    surface: Color(0xFFF5F5F5),
  ),
  // Custom fonts applied throughout
  textTheme: const TextTheme(
    // Display styles - BebasNeue for headers
    displayLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    displayMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    displaySmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    // Headline styles - BebasNeue for titles
    headlineLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    // Title styles - use BebasNeue for headings (requested font)
    titleLarge: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleSmall: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    // Body styles - Lato for content
    bodyLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      color: Colors.black54,
    ),
    // Label styles - Lato for labels
    labelLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
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
      foregroundColor: Colors.white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black54,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
        fontSize: 14,
      ),
    ),
  ),
  // Apply custom fonts to input fields
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Lato', color: Colors.black54),
    hintStyle: TextStyle(fontFamily: 'Lato', color: Colors.black38),
    helperStyle: TextStyle(fontFamily: 'Lato', color: Colors.black54),
    errorStyle: TextStyle(fontFamily: 'Lato', color: Colors.red),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black26),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF3B82F6)),
    ),
  ),
  // Apply custom fonts to app bar
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
);

// Dark theme (existing theme)
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

Future<void> loadThemeMode(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? true;
  ref.read(themeModeProvider.notifier).state = isDarkMode
      ? ThemeMode.dark
      : ThemeMode.light;
}

Future<void> toggleTheme(WidgetRef ref) async {
  final currentTheme = ref.read(themeModeProvider);
  final newTheme = currentTheme == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
  ref.read(themeModeProvider.notifier).state = newTheme;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', newTheme == ThemeMode.dark);
}

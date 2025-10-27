import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// --- PROVIDER SETUP ---
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// --- STATE NOTIFIER ---
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  /// Load saved theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? true;
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Toggle theme mode and persist the new setting
  Future<void> toggleTheme() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state == ThemeMode.dark);
  }
}

/// --- LIGHT THEME ---
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF3B82F6),
    surface: Color(0xFFF5F5F5),
  ),

  /// Text Theme — BebasNeue for titles, Lato for body
  textTheme: const TextTheme(
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
    titleLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
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

  /// Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3B82F6),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black87,
      textStyle: const TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  ),

  /// Input Fields
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

  /// AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
);

/// --- DARK THEME ---
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3B82F6),
  scaffoldBackgroundColor: Colors.black, // AMOLED optimized background
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF3B82F6),
    surface: Color(0xFF1C1C1E),
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 36, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'BebasNeue', fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontFamily: 'BebasNeue', fontSize: 24, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontFamily: 'Lato', fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: 'Lato', fontSize: 16),
    bodyMedium: TextStyle(fontFamily: 'Lato', fontSize: 14),
    bodySmall: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Colors.white70),
    labelLarge: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w600),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3B82F6),
      foregroundColor: Colors.white,
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
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Lato', color: Colors.white70),
    hintStyle: TextStyle(fontFamily: 'Lato', color: Colors.white54),
    helperStyle: TextStyle(fontFamily: 'Lato', color: Colors.white60),
    errorStyle: TextStyle(fontFamily: 'Lato', color: Colors.redAccent),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF3B82F6)),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontFamily: 'BebasNeue',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
);

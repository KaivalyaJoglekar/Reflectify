import 'package:flutter/material.dart';
import 'package:reflectify/screens/splash_screen.dart';

void main() {
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF3B82F6);

    return MaterialApp(
      title: 'Reflectify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: accentColor,
        scaffoldBackgroundColor: Colors.transparent, // REQUIRED for glass effect
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          surface: Color(0xFF1C1C1E), 
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Lato'),
          bodyMedium: TextStyle(fontFamily: 'Lato'),
          titleLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 32),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
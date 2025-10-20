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
        scaffoldBackgroundColor: const Color(0xFF0F101C),
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          surface: Color(0xFF1E1E1E),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Lato'),
          bodyMedium: TextStyle(fontFamily: 'Lato'),
          titleLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 28),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accentColor,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white54),
          floatingLabelStyle: const TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          prefixIconColor: Colors.grey[500],
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:reflectify/screens/splash_screen.dart';

void main() {
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF3B82F6); // A nice blue color

    return MaterialApp(
      title: 'Reflectify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.light(
          primary: accentColor,
          secondary: accentColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accentColor, // Use accent for text buttons
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // UPDATED: Centralized style for all text form fields
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.black54),
          floatingLabelStyle: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          prefixIconColor: Colors.grey[500],
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reflectify/screens/splash_screen.dart'; // This will now be our Welcome Screen

void main() {
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF04E99); // A vibrant pink accent color

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
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            prefixIconColor: Colors.grey[500],
         ),
      ),
      home: const SplashScreen(), // Starts with the new Welcome Screen
    );
  }
}
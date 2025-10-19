import 'package:flutter/material.dart';
import 'package:reflectify/screens/splash_screen.dart';

void main() {
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryAccent = Color(0xFF8A5DF4); // Vivid Purple
    const primaryRed = Color(0xFFF92A2A); // Red highlight

    return MaterialApp(
      title: 'Reflectify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: primaryAccent,

        // --- SET THE DEFAULT FONT FAMILY ---
        fontFamily: 'Lato', // Lato is now the default for all text

        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryAccent, width: 2),
          ),
          labelStyle: const TextStyle(
            color: Colors.white54,
            fontFamily: 'Lato',
          ),
          floatingLabelStyle: const TextStyle(color: primaryAccent),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'BebasNeue', // Use BebasNeue for buttons
              letterSpacing: 1.2,
            ),
          ),
        ),

        // --- DEFINE THE CUSTOM TEXT THEME WITH NEW FONTS ---
        textTheme: const TextTheme(
          // For body text, UI elements, etc.
          bodyMedium: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontFamily: 'Lato',
          ),

          // For major headings like "Welcome Back"
          headlineSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 48,
            fontFamily: 'BebasNeue', // Use BebasNeue for headings
            letterSpacing: 1.5,
          ),

          // For section titles like "Recent Entries"
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.2,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

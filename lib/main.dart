import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:reflectify/screens/splash_screen.dart';
import 'package:reflectify/providers/theme_provider.dart';

void main() {
  // Wrap the app in a ProviderScope
  runApp(const ProviderScope(child: JournalApp()));
}

class JournalApp extends ConsumerWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    const accentColor = Color(0xFF3B82F6);

    return MaterialApp(
      title: 'Reflectify',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const SplashScreen(),
    );
  }
}

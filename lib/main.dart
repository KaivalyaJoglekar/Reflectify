import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:reflectify/screens/splash_screen.dart';
import 'package:reflectify/providers/theme_provider.dart';

// Import Firebase Core and options
import 'package:firebase_core/firebase_core.dart';
import 'package:reflectify/firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wrap the app in a ProviderScope
  runApp(const ProviderScope(child: JournalApp()));
}

class JournalApp extends ConsumerWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

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
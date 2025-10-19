import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after a delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          // Use the grainy background pattern
          image: DecorationImage(
            image: const AssetImage('assets/grain.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  blurRadius: 50.0,
                  spreadRadius: 10.0,
                ),
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 60.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            // Your App Logo
            child: const Icon(
              Icons.auto_stories,
              color: Colors.white,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }
}

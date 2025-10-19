import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);

    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // The background is now pure black, with no texture.
        color: Colors.black,
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFE83D67,
                        ).withOpacity(0.5), // Magenta
                        blurRadius: 70.0,
                        spreadRadius: 15.0,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFF9B59B6,
                        ).withOpacity(0.4), // Vivid Purple
                        blurRadius: 80.0,
                        spreadRadius: 10.0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_stories,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

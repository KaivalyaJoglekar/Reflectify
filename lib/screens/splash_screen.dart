import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _aurora1X;
  late Animation<double> _aurora1Y;
  late Animation<double> _aurora2X;
  late Animation<double> _aurora2Y;
  late Animation<double> _auroraOpacity;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();

    // Aurora 1: left-to-right subtle motion
    _aurora1X = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -60.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 20.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _aurora1Y = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -5.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Aurora 2: right-to-left subtle motion (opposite phase)
    _aurora2X = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 60.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -20.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _aurora2Y = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 15.0, end: -5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 20.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Global opacity ramp for entrance
    _auroraOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Fast text reveal animation - quicker and snappier
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          fb_auth.User? firebaseUser =
              fb_auth.FirebaseAuth.instance.currentUser;

          if (firebaseUser == null) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          } else {
            final appUser = User(
              name: firebaseUser.displayName ?? 'Reflectify User',
              username: firebaseUser.email?.split('@').first ?? 'user',
              email: firebaseUser.email ?? 'no-email',
            );

            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    MainNavigationScreen(user: appUser),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _auroraBlob({required Color color, required double diameter}) {
    return Container(
      width: diameter,
      height: diameter / 1.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(diameter / 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.95),
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Grid background (only on splash)
          Positioned.fill(
            child: Image.asset('assets/grid.jpg', fit: BoxFit.cover),
          ),

          // Dark overlay to make auroras visible
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.7)),
          ),

          // Animated auroras in center mixing together
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SizedBox(
                  width: 320,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Aurora 1 (purple/pink)
                      Opacity(
                        opacity: _auroraOpacity.value * 0.95,
                        child: Transform.translate(
                          offset: Offset(_aurora1X.value, _aurora1Y.value),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 28,
                              sigmaY: 28,
                            ),
                            child: _auroraBlob(
                              color: const Color(0xFF6C5CE7), // purple
                              diameter: 160,
                            ),
                          ),
                        ),
                      ),

                      // Aurora 2 (teal/green) overlapping and mixing
                      Opacity(
                        opacity: _auroraOpacity.value * 0.9,
                        child: Transform.translate(
                          offset: Offset(_aurora2X.value, _aurora2Y.value),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 34,
                              sigmaY: 34,
                            ),
                            child: _auroraBlob(
                              color: const Color(0xFF4D7BFF), // blue
                              diameter: 160,
                            ),
                          ),
                        ),
                      ),

                      // Momento Logo in center (visible over aurora) - Circular
                      Opacity(
                        opacity: _auroraOpacity.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/momento_logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Gradient "MOMENTO" text with fast fade and scale effect
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _textRevealAnimation.value,
                    child: Opacity(
                      opacity: _textRevealAnimation.value,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF6C5CE7), // purple
                            Color(0xFF4D7BFF), // blue
                            Color(0xFF00D9FF), // cyan
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'MOMENTO',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Color(0xFF6C5CE7), blurRadius: 20),
                              Shadow(color: Color(0xFF00D9FF), blurRadius: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Loading indicator at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

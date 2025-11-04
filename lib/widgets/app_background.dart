import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatefulWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _aurora1X;
  late Animation<double> _aurora1Y;
  late Animation<double> _aurora2X;
  late Animation<double> _aurora2Y;
  late Animation<double> _aurora3X;
  late Animation<double> _aurora3Y;
  late Animation<double> _aurora4X;
  late Animation<double> _aurora4Y;

  // Removed the duplicate declarations for aurora 3 and 4

  @override
  void initState() {
    super.initState();

    // Set up a long, slow, repeating animation
    _controller = AnimationController(
      duration: const Duration(seconds: 25), // Slower animation
      vsync: this,
    )..repeat(reverse: true); // Loop back and forth

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

    // --- FIX ---
    // Removed the first, overwritten definitions for Aurora 3 and 4.
    // Kept the second set as the intended animations.

    // Aurora 3: subtle top-right movement
    _aurora3X = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 20.0, end: 60.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 60.0, end: 10.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _aurora3Y = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -40.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: -30.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Aurora 4: subtle bottom-left movement
    _aurora4X = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -20.0, end: -60.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -60.0, end: -10.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _aurora4Y = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 40.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 30.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Solid black base
          Positioned.fill(child: Container(color: Colors.black)),

          // Subtle radial overlays to create mesh/aurora feel
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Top-left purple aurora
                    Positioned(
                      left: -80 + _aurora1X.value,
                      top: -60 + _aurora1Y.value,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
                        child: Container(
                          width: 420,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.5, -0.5),
                              colors: [
                                const Color(0xFF6C5CE7).withOpacity(0.85),
                                const Color(0xFF6C5CE7).withOpacity(0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom-right blue aurora
                    Positioned(
                      right: -80 + _aurora2X.value,
                      bottom: -60 + _aurora2Y.value,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 56, sigmaY: 56),
                        child: Container(
                          width: 460,
                          height: 340,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.6, 0.6),
                              colors: [
                                const Color(0xFF4D7BFF).withOpacity(0.8),
                                const Color(0xFF4D7BFF).withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- NEW WIDGET ---
                    // Added Aurora 3 (Top-right)
                    Positioned(
                      right: -100 + _aurora3X.value,
                      top: -80 + _aurora3Y.value,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 52, sigmaY: 52),
                        child: Container(
                          width: 400,
                          height: 300,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.7, -0.7),
                              colors: [
                                const Color(
                                  0xFFE040FB,
                                ).withOpacity(0.75), // Pink/Magenta
                                const Color(0xFFE040FB).withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- NEW WIDGET ---
                    // Added Aurora 4 (Bottom-left)
                    Positioned(
                      left: -120 + _aurora4X.value,
                      bottom: -100 + _aurora4Y.value,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                        child: Container(
                          width: 440,
                          height: 320,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(-0.6, 0.6),
                              colors: [
                                const Color(
                                  0xFF00BFA5,
                                ).withOpacity(0.8), // Teal
                                const Color(0xFF00BFA5).withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Center subtle overlay to mesh colors
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.06,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: SweepGradient(
                                colors: [
                                  Color(0xFF051025),
                                  Color(0xFF0B0630),
                                  Color(0xFF051025),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // The actual screen content goes on top
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}

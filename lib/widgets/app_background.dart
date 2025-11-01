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
            color.withOpacity(0.95),
            color.withOpacity(0.55),
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
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
      backgroundColor: Colors.black, // Base color
      body: Stack(
        children: [
          // Animated auroras
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
                        opacity: 0.95, // Constant opacity
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
                      // Aurora 2 (blue)
                      Opacity(
                        opacity: 0.9, // Constant opacity
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
                    ],
                  ),
                );
              },
            ),
          ),
          // The actual screen content
          widget.child,
        ],
      ),
    );
  }
}
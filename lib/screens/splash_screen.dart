import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeInController;
  late Animation<double> _orb1MoveX, _orb1MoveY;
  late Animation<double> _orb2MoveX, _orb2MoveY;
  late Animation<double> _orb3MoveX, _orb3MoveY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _fadeInController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // Enhanced blob animations for smooth merging effect
    _orb1MoveX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -60, end: 30), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 30, end: -60), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb1MoveY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -40, end: 30), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 30, end: -40), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb2MoveX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 60, end: -30), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -30, end: 60), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb2MoveY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 40, end: -30), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -30, end: 40), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Third blob for enhanced merging effect
    _orb3MoveX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 40), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 40, end: -40), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -40, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb3MoveY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -50, end: 0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0, end: 50), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 50, end: -50), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // bg_mad.jpg background image - full screen
          Positioned.fill(
            child: Image.asset(
              'assets/bg_mad.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to gradient if image fails to load
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1a1a2e),
                        Color(0xFF16213e),
                        Color(0xFF0f3460),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Dark overlay for better blob visibility
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // Animated merging blobs with enhanced blur
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_controller, _fadeInController]),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blob 1 (Reddish-Pink) - Larger
                    Transform.translate(
                      offset: Offset(_orb1MoveX.value, _orb1MoveY.value),
                      child: const MergingBlob(
                        color: Color(0xFFD62F6D),
                        diameter: 200,
                      ),
                    ),
                    // Blob 2 (Purple) - Medium
                    Transform.translate(
                      offset: Offset(_orb2MoveX.value, _orb2MoveY.value),
                      child: const MergingBlob(
                        color: Color(0xFF8A5DF4),
                        diameter: 180,
                      ),
                    ),
                    // Blob 3 (Blue-Purple) - Smaller
                    Transform.translate(
                      offset: Offset(_orb3MoveX.value, _orb3MoveY.value),
                      child: const MergingBlob(
                        color: Color(0xFF4ECDC4),
                        diameter: 160,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MergingBlob extends StatelessWidget {
  final Color color;
  final double diameter;

  const MergingBlob({super.key, required this.color, required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
            color.withOpacity(0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class DottedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    const double spacing = 30.0;
    const double radius = 2.5;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeInController;
  late Animation<double> _orb1MoveX, _orb1MoveY;
  late Animation<double> _orb2MoveX, _orb2MoveY;
  late Animation<double> _iconFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _fadeInController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    // Further reduced animation tweens for a very tight, centered movement
    _orb1MoveX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -40, end: 20), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 20, end: -40), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb1MoveY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -30, end: 20), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 20, end: -30), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb2MoveX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 40, end: -20), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -20, end: 40), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orb2MoveY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 30, end: -20), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -20, end: 30), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _iconFade =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeInController);

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
      body: CustomPaint(
        // The painter is on the root widget, ensuring it covers the whole screen.
        size: MediaQuery.of(context).size,
        painter: DottedGridPainter(),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller, _fadeInController]),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Orb 1 (Reddish-Pink) - Diameter greatly reduced
                  Transform.translate(
                    offset: Offset(_orb1MoveX.value, _orb1MoveY.value),
                    child: const Orb(
                      color: Color(0xFFD62F6D),
                      diameter: 150, // MODIFIED
                    ),
                  ),
                  // Orb 2 (Purple) - Diameter greatly reduced
                  Transform.translate(
                    offset: Offset(_orb2MoveX.value, _orb2MoveY.value),
                    child: const Orb(
                      color: Color(0xFF8A5DF4),
                      diameter: 130, // MODIFIED
                    ),
                  ),
                  FadeTransition(
                    opacity: _iconFade,
                    child: Image.network(
                      'https://i.imgur.com/b2bX3AD.png',
                      width: 70,
                      height: 70,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Orb extends StatelessWidget {
  final Color color;
  final double diameter;

  const Orb({Key? key, required this.color, required this.diameter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.7),
      ),
      child: BackdropFilter(
        // Reduced blur to match smaller size
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
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
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const double spacing = 15.0;
    const double radius = 0.7;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
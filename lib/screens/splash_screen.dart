import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/grainy_background.dart';

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

    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeInController);

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
          // Grid background image
          Positioned.fill(
            child: Image.asset(
              'assets/grid.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.7),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Dotted grid overlay
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: DottedGridPainter(),
          ),
          // Animated orbs
          GrainyBackground(
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_controller, _fadeInController]),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Orb 1 (Reddish-Pink)
                      Transform.translate(
                        offset: Offset(_orb1MoveX.value, _orb1MoveY.value),
                        child: const Orb(
                          color: Color(0xFFD62F6D),
                          diameter: 150,
                        ),
                      ),
                      // Orb 2 (Purple)
                      Transform.translate(
                        offset: Offset(_orb2MoveX.value, _orb2MoveY.value),
                        child: const Orb(
                          color: Color(0xFF8A5DF4),
                          diameter: 130,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
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
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    const double spacing = 25.0;
    const double radius = 2.0;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

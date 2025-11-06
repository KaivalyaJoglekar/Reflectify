import 'dart:math';
import 'package:flutter/material.dart';

class GrainyBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const GrainyBackground({
    super.key,
    required this.child,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: backgroundColor),
        CustomPaint(painter: GrainPainter(), child: Container()),
        child,
      ],
    );
  }
}

class GrainPainter extends CustomPainter {
  static final List<_GrainDot> _grainDots = [];

  GrainPainter() {
    // Generate grain pattern once and reuse
    if (_grainDots.isEmpty) {
      final random = Random(42);
      for (int i = 0; i < 2500; i++) {
        _grainDots.add(
          _GrainDot(
            x: random.nextDouble(),
            y: random.nextDouble(),
            opacity: random.nextDouble() * 0.025, // Much more subtle
          ),
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw static grain pattern
    for (final dot in _grainDots) {
      paint.color = Colors.white.withValues(alpha: dot.opacity);
      canvas.drawCircle(
        Offset(dot.x * size.width, dot.y * size.height),
        0.3, // Smaller dots
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GrainDot {
  final double x;
  final double y;
  final double opacity;

  _GrainDot({required this.x, required this.y, required this.opacity});
}

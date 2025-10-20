import 'dart:math';
import 'package:flutter/material.dart';

class TopographicBackground extends StatelessWidget {
  final Widget child;
  const TopographicBackground({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // The base color is now white
      color: Colors.white,
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: AbstractPainter(), // Use the new abstract painter
          ),
          child,
        ],
      ),
    );
  }
}

// NEW: This painter creates a random, abstract scribble pattern
class AbstractPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // Lines are a very subtle black to not be distracting
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final random = Random();

    // Draw 40 short, random curves to create an abstract texture
    for (int i = 0; i < 40; i++) {
      var path = Path();
      var startPoint = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      path.moveTo(startPoint.dx, startPoint.dy);

      var controlPoint = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      var endPoint = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

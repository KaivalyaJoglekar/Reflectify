import 'dart:math';
import 'package:flutter/material.dart';

class TopographicBackground extends StatelessWidget {
  final Widget child;

  const TopographicBackground({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // The base color of the screen is black
      child: Stack(
        children: [
          // This CustomPaint widget draws the lines in the background
          CustomPaint(size: Size.infinite, painter: BackgroundPainter()),
          // Your screen's content (the child widget) goes on top of the background
          child,
        ],
      ),
    );
  }
}

// This class handles the actual drawing of the wavy lines
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
          .withOpacity(0.1) // Lines are semi-transparent white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Using a seed for Random ensures the pattern is the same every time
    final random = Random(123);

    // Draw 15 complex, wavy lines across the screen
    for (int i = 0; i < 15; i++) {
      final path = Path();

      // Start the line at a random point
      final startPoint = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      path.moveTo(startPoint.dx, startPoint.dy);

      // Add a few curved segments to make the line wavy and organic
      for (int j = 0; j < 5; j++) {
        final controlPoint1 = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        final controlPoint2 = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        final endPoint = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          endPoint.dx,
          endPoint.dy,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // The background doesn't need to change, so this is false
    return false;
  }
}

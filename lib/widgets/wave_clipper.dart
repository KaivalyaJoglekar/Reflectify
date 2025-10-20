import 'package:flutter/material.dart';

// This class creates the beautiful wave shape for our container.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // A Path is a collection of lines and curves that describe a shape.
    var path = Path();

    // 1. Start drawing from the top-left corner. This is the starting point.
    path.moveTo(0, size.height * 0.4);

    // 2. Create the first bezier curve for the main wave.
    // This curve gives the shape its primary organic, flowing look.
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.3);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // 3. Create the second bezier curve for the rest of the wave.
    // This creates a more complex and interesting shape that flows to the edge.
    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.5);
    var secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // 4. Draw straight lines to the bottom corners to fill the rest of the area.
    path.lineTo(size.width, size.height); // Line to the bottom-right corner
    path.lineTo(0, size.height); // Line to the bottom-left corner

    // 5. Close the path to form a complete, enclosed shape.
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // The shape is static, so it doesn't need to be redrawn.
    return false;
  }
}

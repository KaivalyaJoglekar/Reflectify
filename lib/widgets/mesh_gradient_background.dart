import 'package:flutter/material.dart';

class MeshGradientBackground extends StatelessWidget {
  const MeshGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left aurora glow
        Positioned(
          top: -200,
          left: -200,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom-right aurora glow
        Positioned(
          bottom: -250,
          right: -250,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8A5DF4).withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
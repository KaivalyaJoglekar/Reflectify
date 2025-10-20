import 'package:flutter/material.dart';

class MeshGradientBackground extends StatefulWidget {
  final Widget? child;
  const MeshGradientBackground({super.key, this.child});

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Defined Colors to mimic the dark blue/purple mesh from the image
    const Color darkBlue = Color(0xFF0A0A1F);
    const Color midPurple = Color(0xFF1E0D40);
    const Color neonBlue = Color(0xFF5A8DFF);
    const Color neonPurple = Color(0xFF8A5DF4);

    return Container(
      color: darkBlue,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated Background Circles to mimic the mesh gradient glow
              Positioned(
                top: -100 + 50 * _controller.value,
                left: -150 + 50 * _controller.value,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: neonBlue.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonBlue.withOpacity(0.5),
                        blurRadius: 150,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -100 - 50 * _controller.value,
                right: -150 - 50 * _controller.value,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: neonPurple.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonPurple.withOpacity(0.5),
                        blurRadius: 200,
                      ),
                    ],
                  ),
                ),
              ),
              // Main content goes here
              widget.child ?? const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
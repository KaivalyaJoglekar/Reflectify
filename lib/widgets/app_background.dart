import 'package:flutter/material.dart';
import 'package:reflectify/widgets/mesh_gradient_background.dart';
import 'package:reflectify/widgets/grainy_background.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GrainyBackground(
      child: Stack(children: [const MeshGradientBackground(), child]),
    );
  }
}

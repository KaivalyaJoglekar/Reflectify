import 'package:flutter/material.dart';
import 'package:reflectify/widgets/mesh_gradient_background.dart'; // ADDED

class AppBackground extends StatelessWidget {
  final Widget? child;
  const AppBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    // MODIFIED: Use the animated gradient background
    return MeshGradientBackground(child: child);
  }
}

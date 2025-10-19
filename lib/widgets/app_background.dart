import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget? child;
  const AppBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    // A simple, pure black container that fills the entire screen.
    return Container(color: Colors.black, child: child);
  }
}

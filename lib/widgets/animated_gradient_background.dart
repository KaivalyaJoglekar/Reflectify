import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  // Using direct hex values to avoid deprecated 'withOpacity'
  final List<Color> colors = [
    const Color(0x998A5DF4), // 0.6 opacity
    const Color(0x66E91E63), // 0.4 opacity for Colors.pink
    const Color(0x662196F3), // 0.4 opacity for Colors.blue
  ];

  List<Alignment> alignments = [
    const Alignment(-1.5, -1.2),
    const Alignment(1.5, 1.2),
    const Alignment(0.0, 0.5),
    const Alignment(1.0, -0.5),
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // A timer periodically changes the alignment of the blobs, creating a smooth animation
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() => currentIndex = (currentIndex + 1) % alignments.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This Stack places the animated blobs in the background
    // and the screen's content (the child) on top.
    return Stack(
      children: [
        AnimatedAlign(
          duration: const Duration(seconds: 4),
          alignment: alignments[currentIndex],
          curve: Curves.easeInOut,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors[0]),
          ),
        ),
        AnimatedAlign(
          duration: const Duration(seconds: 4),
          alignment: alignments[(currentIndex + 1) % alignments.length],
          curve: Curves.easeInOut,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors[1]),
          ),
        ),
        AnimatedAlign(
          duration: const Duration(seconds: 4),
          alignment: alignments[(currentIndex + 2) % alignments.length],
          curve: Curves.easeInOut,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors[2]),
          ),
        ),
        // This is where the actual screen content (like the login form) is displayed
        widget.child,
      ],
    );
  }
}

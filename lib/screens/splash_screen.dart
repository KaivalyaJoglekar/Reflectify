import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/topographic_background.dart';
import 'package:reflectify/widgets/bottom_wave_clipper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The main background is now black
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // TOP PART: The white header with the new abstract pattern
          ClipPath(
            clipper: BottomWaveClipper(),
            child: SizedBox(
              // UPDATED: Height is reduced to 45% to push the wave higher
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              child: const TopographicBackground(child: SizedBox.shrink()),
            ),
          ),

          // BOTTOM PART: The black area with white text
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Reflectify',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your daily journal guide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.white70),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Continue', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            // The arrow icon will now be blue
                            Icon(
                              Icons.arrow_forward,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
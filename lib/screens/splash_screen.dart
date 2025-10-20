import 'package:flutter/material.dart';
import 'package:reflectify/screens/login_screen.dart';
import 'package:reflectify/widgets/topographic_background.dart';
import 'package:reflectify/widgets/wave_clipper.dart'; // Import the new wave clipper

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopographicBackground(
        child: Column(
          children: [
            const Spacer(flex: 3), // Keeps the majority of the screen dark
            Expanded(
              flex: 2,
              // NEW: We wrap the container with ClipPath to apply our custom shape.
              child: ClipPath(
                clipper: WaveClipper(), // This is our custom wave shape!
                child: Container(
                  width: double.infinity,
                  color: Colors.white, // The container itself is now just a colored box
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 60.0, 32.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to Reflectify', // UPDATED TEXT
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your daily journal guide', // UPDATED TEXT
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
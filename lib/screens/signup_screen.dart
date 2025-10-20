import 'package:flutter/material.dart';
import 'package:reflectify/widgets/topographic_background.dart';
import 'package:reflectify/screens/navigation_screen.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/widgets/wave_clipper.dart'; // Import the wave clipper

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sampleUser = User(
      name: 'New User',
      username: 'newuser',
      email: 'user@example.com',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: TopographicBackground(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 3,
              // NEW: Wrap the Container with ClipPath to apply the wave shape
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  // Adjusted padding to give space below the wave's curve
                  padding: const EdgeInsets.fromLTRB(32.0, 80.0, 32.0, 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text('Full Name', style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(height: 8),
                        const TextField(
                          decoration: InputDecoration(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 24),
                        const Text('Email', style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(height: 8),
                        const TextField(
                          decoration: InputDecoration(),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        const Text('Password', style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(height: 8),
                        const TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.visibility_off_outlined),
                          ),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => NavigationScreen(user: sampleUser),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Sign up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an Account? ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Sign in'),
                            ),
                          ],
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
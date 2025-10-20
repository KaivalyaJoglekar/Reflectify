import 'package:flutter/material.dart';
import 'package:reflectify/widgets/topographic_background.dart';
import 'package:reflectify/screens/navigation_screen.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/signup_screen.dart';
import 'package:reflectify/widgets/wave_clipper.dart'; // Import the wave clipper

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final sampleUser = User(
      name: 'Kaivalya Joglekar',
      username: 'kaivalyajoglekar',
      email: 'kaivalya.j@example.com',
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
                          'Sign in',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text('Email', style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: 'demo@email.com',
                          decoration: const InputDecoration(),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        const Text('Password', style: TextStyle(color: Colors.black54, fontSize: 16)),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: 'enter your password',
                          obscureText: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.visibility_off_outlined),
                          ),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24.0,
                                  width: 24.0,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    side: BorderSide(color: Colors.grey[400]!),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Remember Me', style: TextStyle(color: Colors.black54)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => NavigationScreen(user: sampleUser),
                                ),
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
                            child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an Account? ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
                              },
                              child: const Text('Sign up'),
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
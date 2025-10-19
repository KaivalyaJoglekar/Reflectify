import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/navigation_screen.dart';
import 'package:reflectify/widgets/app_background.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is a sample user for navigation.
    final sampleUser = User(
      name: 'Kaivalya Joglekar',
      username: 'kaivalyajoglekar',
      email: 'kaivalya.j@example.com',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_alt_1,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start your journaling journey.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          label: 'Full Name',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Password',
                          icon: Icons.lock_outline_rounded,
                          isObscure: true,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NavigationScreen(user: sampleUser),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isObscure = false,
  }) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Icon(icon),
        ),
      ),
    );
  }
}

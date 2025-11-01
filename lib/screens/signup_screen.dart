import 'package:flutter/material.dart';
import 'package:reflectify/widgets/topographic_background.dart';
// Use MainNavigationScreen for consistency
import 'package:reflectify/screens/main_navigation_screen.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/widgets/bottom_wave_clipper.dart';
import 'package:reflectify/widgets/grainy_background.dart';

// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

// Convert to StatefulWidget
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Add text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Signup function
  Future<void> _signup() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Create user with Firebase
      final credential =
          await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final fb_auth.User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        // Update the user's display name
        await firebaseUser.updateDisplayName(_nameController.text.trim());
        // Reload user to get the updated info
        await firebaseUser.reload();
        
        // Get the reloaded user
        final updatedUser = fb_auth.FirebaseAuth.instance.currentUser;

        // Create app User model
        final appUser = User(
          name: updatedUser?.displayName ?? 'New User',
          username: updatedUser?.email?.split('@').first ?? 'user',
          email: updatedUser?.email ?? 'no-email',
        );

        // Navigate to main app
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => MainNavigationScreen(user: appUser),
            ),
            (route) => false,
          );
        }
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Signup failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Form area is black
      body: GrainyBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TOP PART: White header with abstract pattern
              ClipPath(
                clipper: BottomWaveClipper(),
                child: SizedBox(
                  // UPDATED: Height reduced to 35% to push the wave higher
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: TopographicBackground(
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 40.0),
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // BOTTOM PART: Black form area
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController, // Assign controller
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController, // Assign controller
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController, // Assign controller
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.white54,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signup, // Call _signup
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary, // Blue button
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an Account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
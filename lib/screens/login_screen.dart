import 'package:flutter/material.dart';
import 'package:reflectify/widgets/topographic_background.dart';
import 'package:reflectify/screens/main_navigation_screen.dart';
import 'package:reflectify/models/user_model.dart';
import 'package:reflectify/screens/signup_screen.dart';
import 'package:reflectify/widgets/bottom_wave_clipper.dart';
import 'package:reflectify/widgets/app_background.dart';
import 'package:reflectify/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  // Add text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add loading state
  bool _isLoading = false;
  // Password visibility
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _login() async {
    // Validate inputs
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check if email is empty
    if (email.isEmpty) {
      CustomToast.show(
        context,
        message: 'Please enter your email address',
        icon: Icons.email_outlined,
        iconColor: Colors.orange,
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      CustomToast.show(
        context,
        message: 'Please enter a valid email address',
        icon: Icons.error_outline,
        iconColor: Colors.orange,
      );
      return;
    }

    // Check if password is empty
    if (password.isEmpty) {
      CustomToast.show(
        context,
        message: 'Please enter your password',
        icon: Icons.lock_outline,
        iconColor: Colors.orange,
      );
      return;
    }

    // Check password length
    if (password.length < 6) {
      CustomToast.show(
        context,
        message: 'Password must be at least 6 characters',
        icon: Icons.error_outline,
        iconColor: Colors.orange,
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Sign in with Firebase
      final credential = await fb_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final fb_auth.User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        // Create app User model from Firebase User
        final appUser = User(
          name: firebaseUser.displayName ?? 'Reflectify User',
          username: firebaseUser.email?.split('@').first ?? 'user',
          email: firebaseUser.email!,
        );

        // Show success toast
        if (mounted) {
          CustomToast.show(
            context,
            message: 'Welcome back, ${appUser.name}!',
            icon: Icons.check_circle,
            iconColor: Colors.green,
          );
        }

        // Navigate to main app
        await Future.delayed(const Duration(milliseconds: 500));
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
      // Show specific error messages
      String errorMessage;
      IconData errorIcon = Icons.error_outline;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          errorIcon = Icons.person_off_outlined;
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again';
          errorIcon = Icons.lock_outline;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          errorIcon = Icons.email_outlined;
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          errorIcon = Icons.block;
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later';
          errorIcon = Icons.timer_outlined;
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection';
          errorIcon = Icons.wifi_off;
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password';
          errorIcon = Icons.error_outline;
          break;
        default:
          errorMessage = e.message ?? 'Login failed. Please try again';
      }

      if (mounted) {
        CustomToast.show(
          context,
          message: errorMessage,
          icon: errorIcon,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      // Handle any other errors
      if (mounted) {
        CustomToast.show(
          context,
          message: 'An unexpected error occurred',
          icon: Icons.error_outline,
          iconColor: Colors.red,
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
      backgroundColor: Colors.black, // Form area is now black
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TOP PART: The white header with the abstract pattern
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
                                'Sign in',
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

              // BOTTOM PART: The black form area
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0),
                child: Column(
                  children: [
                    TextFormField(
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
                    TextFormField(
                      controller: _passwordController, // Assign controller
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '••••••••••',
                        hintStyle: const TextStyle(color: Colors.white24),
                        labelStyle: const TextStyle(color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) =>
                                  setState(() => _rememberMe = value ?? false),
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              checkColor: Colors.black,
                              side: const BorderSide(color: Colors.white54),
                            ),
                            const Text(
                              'Remember Me',
                              style: TextStyle(color: Colors.white70),
                            ),
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
                        onPressed: _isLoading ? null : _login, // Call _login
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
                                'Login',
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
                          "Don't have an Account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text('Sign up'),
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

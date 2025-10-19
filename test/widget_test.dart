// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectify/main.dart';
import 'package:reflectify/screens/login_screen.dart';

void main() {
  testWidgets('Splash screen transitions to Login screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JournalApp());

    // Verify that the SplashScreen is shown.
    expect(find.byIcon(Icons.auto_stories), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    // Wait for the timer to finish.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that the LoginScreen is now shown.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}

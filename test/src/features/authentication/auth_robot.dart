import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_auth_flutter_riverpod/src/app.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpMyApp({
    FakeAuthRepository? authRepository,
    bool settle = true,
  }) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        if (authRepository != null)
          authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: const MyApp(),
    ));
    if (settle) {
      await tester.pumpAndSettle();
    }
  }

  Future<void> signInAnonymously() async {
    final finder = find.text('Sign in anonymously');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // Logout
  Future<void> signOut() async {
    final finder = find.text('Logout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  void expectAccountScreen() {
    final finder = find.text('Account');
    expect(finder, findsOneWidget);
  }

  void expectSignInScreen() {
    final finder = find.text('Sign In');
    expect(finder, findsOneWidget);
  }

  // Alerts
  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}

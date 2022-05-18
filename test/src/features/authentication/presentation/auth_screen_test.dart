import 'package:flutter_test/flutter_test.dart';

import '../auth_robot.dart';

void main() {
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpMyApp();
    await r.signInAnonymously();
    r.expectAccountScreen();
    await r.signOut();
    r.expectSignInScreen();
  });
}

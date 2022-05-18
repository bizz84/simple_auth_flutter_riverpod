import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_screen_controller.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        // setup
        when(authRepository.signOut).thenAnswer(
          (_) => Future.value(),
        );
        // run
        expectLater(
          controller.stream,
          emitsInOrder(const [
            AsyncLoading<void>(),
            AsyncData<void>(null),
          ]),
        );
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );

    test(
      'signOut failure',
      () async {
        // setup
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);
        // run
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]),
        );
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}

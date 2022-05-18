import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/sign_in_controller.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late SignInScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = SignInScreenController(authRepository: authRepository);
  });
  group('SignInScreenController', () {
    test('initial state is AsyncData', () {
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('signInAnonymously success', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(authRepository.signInAnonymously).thenAnswer(
        (_) => Future.value(),
      );
      final controller = SignInScreenController(authRepository: authRepository);
      // run
      await controller.signInAnonymously();
      // verify
      verify(authRepository.signInAnonymously).called(1);
      expect(controller.debugState, const AsyncData<void>(null));
    });
    test(
      'signInAnonymously success',
      () async {
        // setup
        when(authRepository.signInAnonymously).thenAnswer(
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
        await controller.signInAnonymously();
        // verify
        verify(authRepository.signInAnonymously).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );

    test(
      'signInAnonymously failure',
      () async {
        // setup
        final exception = Exception('Connection failed');
        when(authRepository.signInAnonymously).thenThrow(exception);
        // run
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              expect(value, isA<AsyncError<void>>());
              return true;
            }),
          ]),
        );
        await controller.signInAnonymously();
        // verify
        verify(authRepository.signInAnonymously).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}

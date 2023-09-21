import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_screen_controller.dart';

import '../../../mocks.dart';

void main() {
  // a helper method to create a ProviderContainer that overrides the authRepositoryProvider
  ProviderContainer makeProviderContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<int>());
  });
  group('AccountScreenController', () {
    test('initial state is AsyncData', () {
      // setup
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      // verify
      verifyNever(authRepository.signOut);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('signOut success', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(authRepository.signInAnonymously).thenAnswer(
        (_) => Future.value(),
      );
      final container = makeProviderContainer(authRepository);
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      // run
      await controller.signOut();
      // verify
      verify(authRepository.signInAnonymously).called(1);
      expect(controller.state, const AsyncData<void>(null));
    });
    test(
      'signOut success',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        when(authRepository.signInAnonymously).thenAnswer(
          (_) => Future.value(),
        );
        final container = makeProviderContainer(authRepository);
        final controller =
            container.read(accountScreenControllerProvider.notifier);
        final listener = Listener<AsyncValue<void>>();
        // listen to the provider and call [listener] whenever its value changes
        container.listen(
          accountScreenControllerProvider,
          listener,
          fireImmediately: true,
        );

        // run
        await controller.signOut();

        // verify
        verifyInOrder([
          // initial state
          () => listener(null, const AsyncData<void>(null)),
          // mutation
          // * use a matcher since AsyncLoading != AsyncLoading with data
          // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
          () => listener(
              const AsyncData<void>(null), any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), const AsyncData<void>(null)),
        ]);
        // verify that the listener is no longer called
        verifyNoMoreInteractions(listener);
        // verify
        verify(authRepository.signInAnonymously).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );

    test(
      'signOut failure',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        final exception = Exception('Connection failed');
        when(authRepository.signInAnonymously).thenThrow(exception);
        final container = makeProviderContainer(authRepository);
        final controller =
            container.read(accountScreenControllerProvider.notifier);
        final listener = Listener<AsyncValue<void>>();
        // listen to the provider and call [listener] whenever its value changes
        container.listen(
          accountScreenControllerProvider,
          listener,
          fireImmediately: true,
        );

        // run
        await controller.signOut();

        // verify
        verifyInOrder([
          // initial state
          () => listener(null, const AsyncData<void>(null)),
          // mutation
          // * use a matcher since AsyncLoading != AsyncLoading with data
          // * https://codewithandrea.com/articles/unit-test-async-notifier-riverpod/
          () => listener(
              const AsyncData<void>(null), any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verify(authRepository.signInAnonymously).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}

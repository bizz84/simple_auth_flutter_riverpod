import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.authRepository})
      : super(const AsyncData<void>(null));
  final FakeAuthRepository authRepository;

  Future<void> signInAnonymously() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(authRepository.signInAnonymously);
  }
}

final signInScreenControllerProvider =
    StateNotifierProvider.autoDispose<SignInScreenController, AsyncValue<void>>(
        (ref) {
  return SignInScreenController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

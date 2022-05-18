import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

class SignInScreenController extends StateNotifier<AsyncValue<void>> {
  SignInScreenController({required this.authRepository})
      : super(const AsyncData(null));
  final FakeAuthRepository authRepository;

  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }
}

final signInScreenControllerProvider =
    StateNotifierProvider.autoDispose<SignInScreenController, AsyncValue<void>>(
        (ref) {
  return SignInScreenController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

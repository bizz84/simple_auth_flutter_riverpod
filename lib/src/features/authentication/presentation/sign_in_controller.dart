import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInScreenController extends _$SignInScreenController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> signInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }
}

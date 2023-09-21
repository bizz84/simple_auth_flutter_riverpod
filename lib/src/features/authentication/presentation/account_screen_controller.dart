import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

part 'account_screen_controller.g.dart';

@riverpod
class AccountScreenController extends _$AccountScreenController {
  @override
  FutureOr<void> build() {
    // no-op
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(authRepository.signOut);
  }
}

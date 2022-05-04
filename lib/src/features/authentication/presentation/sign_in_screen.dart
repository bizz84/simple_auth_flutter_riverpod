import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/sign_in_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/async_value_ui.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      signInScreenControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    final state = ref.watch(signInScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: state.isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign in anonymously'),
            onPressed: state.isLoading
                ? null
                : () => ref
                    .read(signInScreenControllerProvider.notifier)
                    .signInAnonymously(),
          ),
        ),
      ),
    );
  }
}

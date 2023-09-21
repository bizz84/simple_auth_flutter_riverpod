import 'package:mocktail/mocktail.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/fake_auth_repository.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

// a generic Listener class, used to keep track of when a provider notifies its listeners
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

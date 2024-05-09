import 'package:mockito/mockito.dart';

extension FutureWhenExtensions<T> on PostExpectation<Future<T>> {
  void thenResolve(T value) =>
      thenAnswer((realInvocation) => Future.value(value));
}

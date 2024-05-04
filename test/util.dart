import 'package:mockito/mockito.dart';

extension WhenExtensions<T> on PostExpectation<Future<T>> {
  void thenResolve(T value) =>
      thenAnswer((realInvocation) => Future.value(value));
}

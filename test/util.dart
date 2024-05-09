import 'package:mockito/mockito.dart';

extension FutureWhenExtensions<T> on PostExpectation<Future<T>> {
  void thenResolve(T value) =>
      thenAnswer((realInvocation) => Future.value(value));

  PostExpectation<Future<T>> c_thenResolve(T value) {
    thenResolve(value);
    return this;
  }
}

extension WhenExtension<T> on PostExpectation<T> {
  PostExpectation<T> c_thenReturn(T value) {
    thenReturn(value);
    return this;
  }
}

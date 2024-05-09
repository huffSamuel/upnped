// Mocks generated by Mockito 5.4.4 from annotations
// in upnped/test/ssdp/ssdp_server_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i3;
import 'dart:typed_data' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:upnped/src/shared/shared.dart' as _i5;
import 'package:upnped/src/ssdp/ssdp.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSocketFactory_0 extends _i1.SmartFake implements _i2.SocketFactory {
  _FakeSocketFactory_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSocketProxy_1 extends _i1.SmartFake implements _i2.SocketProxy {
  _FakeSocketProxy_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRawDatagramSocket_2 extends _i1.SmartFake
    implements _i3.RawDatagramSocket {
  _FakeRawDatagramSocket_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeInternetAddress_3 extends _i1.SmartFake
    implements _i3.InternetAddress {
  _FakeInternetAddress_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRawSocketEvent_4 extends _i1.SmartFake
    implements _i3.RawSocketEvent {
  _FakeRawSocketEvent_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamSubscription_5<T> extends _i1.SmartFake
    implements _i4.StreamSubscription<T> {
  _FakeStreamSubscription_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_6<T> extends _i1.SmartFake implements _i4.Future<T> {
  _FakeFuture_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SocketBuilder].
///
/// See the documentation for Mockito's code generation for more information.
class MockSocketBuilder extends _i1.Mock implements _i2.SocketBuilder {
  @override
  _i2.SocketFactory get socketFactory => (super.noSuchMethod(
        Invocation.getter(#socketFactory),
        returnValue: _FakeSocketFactory_0(
          this,
          Invocation.getter(#socketFactory),
        ),
        returnValueForMissingStub: _FakeSocketFactory_0(
          this,
          Invocation.getter(#socketFactory),
        ),
      ) as _i2.SocketFactory);

  @override
  _i4.Future<_i2.SocketProxy> build(
    _i3.InternetAddress? address,
    List<_i3.NetworkInterface>? interfaces,
    int? port,
    _i2.SocketCallback? fn, {
    int? multicastHops = 1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #build,
          [
            address,
            interfaces,
            port,
            fn,
          ],
          {#multicastHops: multicastHops},
        ),
        returnValue: _i4.Future<_i2.SocketProxy>.value(_FakeSocketProxy_1(
          this,
          Invocation.method(
            #build,
            [
              address,
              interfaces,
              port,
              fn,
            ],
            {#multicastHops: multicastHops},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.SocketProxy>.value(_FakeSocketProxy_1(
          this,
          Invocation.method(
            #build,
            [
              address,
              interfaces,
              port,
              fn,
            ],
            {#multicastHops: multicastHops},
          ),
        )),
      ) as _i4.Future<_i2.SocketProxy>);
}

/// A class which mocks [UserAgentFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserAgentFactory extends _i1.Mock implements _i5.UserAgentFactory {
  @override
  _i4.Future<String> create() => (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
        ),
        returnValue: _i4.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #create,
            [],
          ),
        )),
      ) as _i4.Future<String>);
}

/// A class which mocks [NativeNetworkInterfaceLister].
///
/// See the documentation for Mockito's code generation for more information.
class MockNativeNetworkInterfaceLister extends _i1.Mock
    implements _i2.NativeNetworkInterfaceLister {
  @override
  _i4.Future<List<_i3.NetworkInterface>> list() => (super.noSuchMethod(
        Invocation.method(
          #list,
          [],
        ),
        returnValue: _i4.Future<List<_i3.NetworkInterface>>.value(
            <_i3.NetworkInterface>[]),
        returnValueForMissingStub: _i4.Future<List<_i3.NetworkInterface>>.value(
            <_i3.NetworkInterface>[]),
      ) as _i4.Future<List<_i3.NetworkInterface>>);
}

/// A class which mocks [SocketProxy].
///
/// See the documentation for Mockito's code generation for more information.
class MockSocketProxy extends _i1.Mock implements _i2.SocketProxy {
  @override
  _i3.RawDatagramSocket get socket => (super.noSuchMethod(
        Invocation.getter(#socket),
        returnValue: _FakeRawDatagramSocket_2(
          this,
          Invocation.getter(#socket),
        ),
        returnValueForMissingStub: _FakeRawDatagramSocket_2(
          this,
          Invocation.getter(#socket),
        ),
      ) as _i3.RawDatagramSocket);

  @override
  List<_i3.NetworkInterface> get networkInterfaces => (super.noSuchMethod(
        Invocation.getter(#networkInterfaces),
        returnValue: <_i3.NetworkInterface>[],
        returnValueForMissingStub: <_i3.NetworkInterface>[],
      ) as List<_i3.NetworkInterface>);

  @override
  _i3.InternetAddress get address => (super.noSuchMethod(
        Invocation.getter(#address),
        returnValue: _FakeInternetAddress_3(
          this,
          Invocation.getter(#address),
        ),
        returnValueForMissingStub: _FakeInternetAddress_3(
          this,
          Invocation.getter(#address),
        ),
      ) as _i3.InternetAddress);

  @override
  void send(
    List<int>? buffer,
    _i3.InternetAddress? address,
    int? port,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #send,
          [
            buffer,
            address,
            port,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void listen(_i2.SocketCallback? fn) => super.noSuchMethod(
        Invocation.method(
          #listen,
          [fn],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> destroy() => (super.noSuchMethod(
        Invocation.method(
          #destroy,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [RawDatagramSocket].
///
/// See the documentation for Mockito's code generation for more information.
class MockRawDatagramSocket extends _i1.Mock implements _i3.RawDatagramSocket {
  @override
  bool get readEventsEnabled => (super.noSuchMethod(
        Invocation.getter(#readEventsEnabled),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set readEventsEnabled(bool? _readEventsEnabled) => super.noSuchMethod(
        Invocation.setter(
          #readEventsEnabled,
          _readEventsEnabled,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get writeEventsEnabled => (super.noSuchMethod(
        Invocation.getter(#writeEventsEnabled),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set writeEventsEnabled(bool? _writeEventsEnabled) => super.noSuchMethod(
        Invocation.setter(
          #writeEventsEnabled,
          _writeEventsEnabled,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get multicastLoopback => (super.noSuchMethod(
        Invocation.getter(#multicastLoopback),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set multicastLoopback(bool? _multicastLoopback) => super.noSuchMethod(
        Invocation.setter(
          #multicastLoopback,
          _multicastLoopback,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get multicastHops => (super.noSuchMethod(
        Invocation.getter(#multicastHops),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  set multicastHops(int? _multicastHops) => super.noSuchMethod(
        Invocation.setter(
          #multicastHops,
          _multicastHops,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set multicastInterface(_i3.NetworkInterface? _multicastInterface) =>
      super.noSuchMethod(
        Invocation.setter(
          #multicastInterface,
          _multicastInterface,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get broadcastEnabled => (super.noSuchMethod(
        Invocation.getter(#broadcastEnabled),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set broadcastEnabled(bool? _broadcastEnabled) => super.noSuchMethod(
        Invocation.setter(
          #broadcastEnabled,
          _broadcastEnabled,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  _i3.InternetAddress get address => (super.noSuchMethod(
        Invocation.getter(#address),
        returnValue: _FakeInternetAddress_3(
          this,
          Invocation.getter(#address),
        ),
        returnValueForMissingStub: _FakeInternetAddress_3(
          this,
          Invocation.getter(#address),
        ),
      ) as _i3.InternetAddress);

  @override
  bool get isBroadcast => (super.noSuchMethod(
        Invocation.getter(#isBroadcast),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i4.Future<int> get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<bool> get isEmpty => (super.noSuchMethod(
        Invocation.getter(#isEmpty),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<_i3.RawSocketEvent> get first => (super.noSuchMethod(
        Invocation.getter(#first),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#first),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#first),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> get last => (super.noSuchMethod(
        Invocation.getter(#last),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#last),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#last),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> get single => (super.noSuchMethod(
        Invocation.getter(#single),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#single),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.getter(#single),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  int send(
    List<int>? buffer,
    _i3.InternetAddress? address,
    int? port,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [
            buffer,
            address,
            port,
          ],
        ),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  void joinMulticast(
    _i3.InternetAddress? group, [
    _i3.NetworkInterface? interface,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #joinMulticast,
          [
            group,
            interface,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void leaveMulticast(
    _i3.InternetAddress? group, [
    _i3.NetworkInterface? interface,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #leaveMulticast,
          [
            group,
            interface,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i7.Uint8List getRawOption(_i3.RawSocketOption? option) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRawOption,
          [option],
        ),
        returnValue: _i7.Uint8List(0),
        returnValueForMissingStub: _i7.Uint8List(0),
      ) as _i7.Uint8List);

  @override
  void setRawOption(_i3.RawSocketOption? option) => super.noSuchMethod(
        Invocation.method(
          #setRawOption,
          [option],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Stream<_i3.RawSocketEvent> asBroadcastStream({
    void Function(_i4.StreamSubscription<_i3.RawSocketEvent>)? onListen,
    void Function(_i4.StreamSubscription<_i3.RawSocketEvent>)? onCancel,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #asBroadcastStream,
          [],
          {
            #onListen: onListen,
            #onCancel: onCancel,
          },
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.StreamSubscription<_i3.RawSocketEvent> listen(
    void Function(_i3.RawSocketEvent)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #listen,
          [onData],
          {
            #onError: onError,
            #onDone: onDone,
            #cancelOnError: cancelOnError,
          },
        ),
        returnValue: _FakeStreamSubscription_5<_i3.RawSocketEvent>(
          this,
          Invocation.method(
            #listen,
            [onData],
            {
              #onError: onError,
              #onDone: onDone,
              #cancelOnError: cancelOnError,
            },
          ),
        ),
        returnValueForMissingStub:
            _FakeStreamSubscription_5<_i3.RawSocketEvent>(
          this,
          Invocation.method(
            #listen,
            [onData],
            {
              #onError: onError,
              #onDone: onDone,
              #cancelOnError: cancelOnError,
            },
          ),
        ),
      ) as _i4.StreamSubscription<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> where(
          bool Function(_i3.RawSocketEvent)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #where,
          [test],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<S> map<S>(S Function(_i3.RawSocketEvent)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #map,
          [convert],
        ),
        returnValue: _i4.Stream<S>.empty(),
        returnValueForMissingStub: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);

  @override
  _i4.Stream<E> asyncMap<E>(
          _i4.FutureOr<E> Function(_i3.RawSocketEvent)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #asyncMap,
          [convert],
        ),
        returnValue: _i4.Stream<E>.empty(),
        returnValueForMissingStub: _i4.Stream<E>.empty(),
      ) as _i4.Stream<E>);

  @override
  _i4.Stream<E> asyncExpand<E>(
          _i4.Stream<E>? Function(_i3.RawSocketEvent)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #asyncExpand,
          [convert],
        ),
        returnValue: _i4.Stream<E>.empty(),
        returnValueForMissingStub: _i4.Stream<E>.empty(),
      ) as _i4.Stream<E>);

  @override
  _i4.Stream<_i3.RawSocketEvent> handleError(
    Function? onError, {
    bool Function(dynamic)? test,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #handleError,
          [onError],
          {#test: test},
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<S> expand<S>(Iterable<S> Function(_i3.RawSocketEvent)? convert) =>
      (super.noSuchMethod(
        Invocation.method(
          #expand,
          [convert],
        ),
        returnValue: _i4.Stream<S>.empty(),
        returnValueForMissingStub: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);

  @override
  _i4.Future<dynamic> pipe(
          _i4.StreamConsumer<_i3.RawSocketEvent>? streamConsumer) =>
      (super.noSuchMethod(
        Invocation.method(
          #pipe,
          [streamConsumer],
        ),
        returnValue: _i4.Future<dynamic>.value(),
        returnValueForMissingStub: _i4.Future<dynamic>.value(),
      ) as _i4.Future<dynamic>);

  @override
  _i4.Stream<S> transform<S>(
          _i4.StreamTransformer<_i3.RawSocketEvent, S>? streamTransformer) =>
      (super.noSuchMethod(
        Invocation.method(
          #transform,
          [streamTransformer],
        ),
        returnValue: _i4.Stream<S>.empty(),
        returnValueForMissingStub: _i4.Stream<S>.empty(),
      ) as _i4.Stream<S>);

  @override
  _i4.Future<_i3.RawSocketEvent> reduce(
          _i3.RawSocketEvent Function(
            _i3.RawSocketEvent,
            _i3.RawSocketEvent,
          )? combine) =>
      (super.noSuchMethod(
        Invocation.method(
          #reduce,
          [combine],
        ),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #reduce,
            [combine],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #reduce,
            [combine],
          ),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<S> fold<S>(
    S? initialValue,
    S Function(
      S,
      _i3.RawSocketEvent,
    )? combine,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fold,
          [
            initialValue,
            combine,
          ],
        ),
        returnValue: _i6.ifNotNull(
              _i6.dummyValueOrNull<S>(
                this,
                Invocation.method(
                  #fold,
                  [
                    initialValue,
                    combine,
                  ],
                ),
              ),
              (S v) => _i4.Future<S>.value(v),
            ) ??
            _FakeFuture_6<S>(
              this,
              Invocation.method(
                #fold,
                [
                  initialValue,
                  combine,
                ],
              ),
            ),
        returnValueForMissingStub: _i6.ifNotNull(
              _i6.dummyValueOrNull<S>(
                this,
                Invocation.method(
                  #fold,
                  [
                    initialValue,
                    combine,
                  ],
                ),
              ),
              (S v) => _i4.Future<S>.value(v),
            ) ??
            _FakeFuture_6<S>(
              this,
              Invocation.method(
                #fold,
                [
                  initialValue,
                  combine,
                ],
              ),
            ),
      ) as _i4.Future<S>);

  @override
  _i4.Future<String> join([String? separator = r'']) => (super.noSuchMethod(
        Invocation.method(
          #join,
          [separator],
        ),
        returnValue: _i4.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #join,
            [separator],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #join,
            [separator],
          ),
        )),
      ) as _i4.Future<String>);

  @override
  _i4.Future<bool> contains(Object? needle) => (super.noSuchMethod(
        Invocation.method(
          #contains,
          [needle],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<void> forEach(void Function(_i3.RawSocketEvent)? action) =>
      (super.noSuchMethod(
        Invocation.method(
          #forEach,
          [action],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<bool> every(bool Function(_i3.RawSocketEvent)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #every,
          [test],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> any(bool Function(_i3.RawSocketEvent)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #any,
          [test],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Stream<R> cast<R>() => (super.noSuchMethod(
        Invocation.method(
          #cast,
          [],
        ),
        returnValue: _i4.Stream<R>.empty(),
        returnValueForMissingStub: _i4.Stream<R>.empty(),
      ) as _i4.Stream<R>);

  @override
  _i4.Future<List<_i3.RawSocketEvent>> toList() => (super.noSuchMethod(
        Invocation.method(
          #toList,
          [],
        ),
        returnValue:
            _i4.Future<List<_i3.RawSocketEvent>>.value(<_i3.RawSocketEvent>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i3.RawSocketEvent>>.value(<_i3.RawSocketEvent>[]),
      ) as _i4.Future<List<_i3.RawSocketEvent>>);

  @override
  _i4.Future<Set<_i3.RawSocketEvent>> toSet() => (super.noSuchMethod(
        Invocation.method(
          #toSet,
          [],
        ),
        returnValue:
            _i4.Future<Set<_i3.RawSocketEvent>>.value(<_i3.RawSocketEvent>{}),
        returnValueForMissingStub:
            _i4.Future<Set<_i3.RawSocketEvent>>.value(<_i3.RawSocketEvent>{}),
      ) as _i4.Future<Set<_i3.RawSocketEvent>>);

  @override
  _i4.Future<E> drain<E>([E? futureValue]) => (super.noSuchMethod(
        Invocation.method(
          #drain,
          [futureValue],
        ),
        returnValue: _i6.ifNotNull(
              _i6.dummyValueOrNull<E>(
                this,
                Invocation.method(
                  #drain,
                  [futureValue],
                ),
              ),
              (E v) => _i4.Future<E>.value(v),
            ) ??
            _FakeFuture_6<E>(
              this,
              Invocation.method(
                #drain,
                [futureValue],
              ),
            ),
        returnValueForMissingStub: _i6.ifNotNull(
              _i6.dummyValueOrNull<E>(
                this,
                Invocation.method(
                  #drain,
                  [futureValue],
                ),
              ),
              (E v) => _i4.Future<E>.value(v),
            ) ??
            _FakeFuture_6<E>(
              this,
              Invocation.method(
                #drain,
                [futureValue],
              ),
            ),
      ) as _i4.Future<E>);

  @override
  _i4.Stream<_i3.RawSocketEvent> take(int? count) => (super.noSuchMethod(
        Invocation.method(
          #take,
          [count],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> takeWhile(
          bool Function(_i3.RawSocketEvent)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #takeWhile,
          [test],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> skip(int? count) => (super.noSuchMethod(
        Invocation.method(
          #skip,
          [count],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> skipWhile(
          bool Function(_i3.RawSocketEvent)? test) =>
      (super.noSuchMethod(
        Invocation.method(
          #skipWhile,
          [test],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> distinct(
          [bool Function(
            _i3.RawSocketEvent,
            _i3.RawSocketEvent,
          )? equals]) =>
      (super.noSuchMethod(
        Invocation.method(
          #distinct,
          [equals],
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> firstWhere(
    bool Function(_i3.RawSocketEvent)? test, {
    _i3.RawSocketEvent Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #firstWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #firstWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #firstWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> lastWhere(
    bool Function(_i3.RawSocketEvent)? test, {
    _i3.RawSocketEvent Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #lastWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #lastWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #lastWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> singleWhere(
    bool Function(_i3.RawSocketEvent)? test, {
    _i3.RawSocketEvent Function()? orElse,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #singleWhere,
          [test],
          {#orElse: orElse},
        ),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #singleWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #singleWhere,
            [test],
            {#orElse: orElse},
          ),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Future<_i3.RawSocketEvent> elementAt(int? index) => (super.noSuchMethod(
        Invocation.method(
          #elementAt,
          [index],
        ),
        returnValue: _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #elementAt,
            [index],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.RawSocketEvent>.value(_FakeRawSocketEvent_4(
          this,
          Invocation.method(
            #elementAt,
            [index],
          ),
        )),
      ) as _i4.Future<_i3.RawSocketEvent>);

  @override
  _i4.Stream<_i3.RawSocketEvent> timeout(
    Duration? timeLimit, {
    void Function(_i4.EventSink<_i3.RawSocketEvent>)? onTimeout,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #timeout,
          [timeLimit],
          {#onTimeout: onTimeout},
        ),
        returnValue: _i4.Stream<_i3.RawSocketEvent>.empty(),
        returnValueForMissingStub: _i4.Stream<_i3.RawSocketEvent>.empty(),
      ) as _i4.Stream<_i3.RawSocketEvent>);
}

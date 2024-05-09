import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:upnped/src/shared/shared.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

import '../util.dart';
@GenerateNiceMocks([
  MockSpec<SocketBuilder>(),
  MockSpec<UserAgentFactory>(),
  MockSpec<NativeNetworkInterfaceLister>(),
  MockSpec<SocketProxy>(),
  MockSpec<RawDatagramSocket>(),
])
import 'ssdp_server_test.mocks.dart';

void main() {
  group('Server', () {
    late MockSocketBuilder mockSocketBuilder;
    late MockUserAgentFactory mockUserAgentFactory;
    late MockNativeNetworkInterfaceLister mockNetworkInterfaceLister;

    late Server server;

    setUp(() {
      mockSocketBuilder = MockSocketBuilder();
      mockUserAgentFactory = MockUserAgentFactory();
      mockNetworkInterfaceLister = MockNativeNetworkInterfaceLister();

      server = Server.forTest(
        userAgentFactory: mockUserAgentFactory,
        socketBuilder: mockSocketBuilder,
        networkLister: mockNetworkInterfaceLister,
      );
    });

    Future<List<MockSocketProxy>> start() async {
      var mockSockets = <MockSocketProxy>[];
      when(mockNetworkInterfaceLister.list()).thenResolve([]);
      when(mockSocketBuilder.build(any, any, any, any)).thenAnswer((i) {
        final socket = MockSocketProxy();

        if (mockSockets.length % 2 == 0) {
          when(socket.address).thenReturn(InternetAddress.anyIPv4);
        } else {
          when(socket.address).thenReturn(InternetAddress.anyIPv4);
        }

        mockSockets.add(socket);
        return Future.value(socket);
      });
      await server.start();

      return mockSockets;
    }

    group('start', () {
      test('should get network interfaces', () async {
        try {
          await server.start();
        } catch (_) {}

        verify(mockNetworkInterfaceLister.list());
      });

      test('should build sockets', () async {
        final networkInterfaces = <NetworkInterface>[];
        when(mockNetworkInterfaceLister.list()).thenResolve(networkInterfaces);
        when(mockSocketBuilder.build(any, any, any, any))
            .thenResolve(MockSocketProxy());

        try {
          await server.start();
        } catch (_) {}

        verify(mockSocketBuilder.build(
          InternetAddress.anyIPv4,
          networkInterfaces,
          1900,
          any,
          multicastHops: 1,
        ));
        verify(mockSocketBuilder.build(
          InternetAddress.anyIPv4,
          networkInterfaces,
          0,
          any,
          multicastHops: 1,
        ));
        verify(mockSocketBuilder.build(
          InternetAddress.anyIPv6,
          networkInterfaces,
          1900,
          any,
          multicastHops: 1,
        ));
        verify(mockSocketBuilder.build(
          InternetAddress.anyIPv6,
          networkInterfaces,
          0,
          any,
          multicastHops: 1,
        ));
      });

      group('when called twice sequentially', () {
        test('should throw StateError', () async {
          when(mockNetworkInterfaceLister.list()).thenResolve([]);
          when(mockSocketBuilder.build(any, any, any, any))
              .thenResolve(MockSocketProxy());

          await server.start();

          final invoke = server.start();

          expectLater(invoke, throwsA(isA<StateError>()));
        });
      });
    });
    group('stop', () {
      test('should destroy all sockets', () async {
        final mockSockets = await start();

        await server.stop();

        for (final socket in mockSockets) {
          verify(socket.destroy());
        }
      });
    });

    group('search', () {
      group('before starting', () {
        test('should throw a StateError', () {
          expectLater(() => server.search(), throwsA(isA<StateError>()));
        });
      });

      test('should send an M-SEARCH on each socket', () async {
        when(mockUserAgentFactory.create()).thenResolve('useragent');
        final mockSockets = await start();

        await server.search();

        for (final socket in mockSockets) {
          verify(socket.send(
            argThat(isA<List<int>>()),
            argThat(isA<InternetAddress>()),
            1900,
          ));
        }
      });
    });
  });
}

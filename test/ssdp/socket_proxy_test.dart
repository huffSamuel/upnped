import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

@GenerateNiceMocks([
  MockSpec<RawDatagramSocket>(),
  MockSpec<NetworkInterface>(),
])
import 'socket_proxy_test.mocks.dart';

void main() {
  group('SocketProxy', () {
    late MockRawDatagramSocket mockSocket;
    late MockNetworkInterface mockNetworkInterface;
    late SocketProxy proxy;

    setUp(() {
      mockSocket = MockRawDatagramSocket();
      mockNetworkInterface = MockNetworkInterface();
      proxy = SocketProxy(mockSocket, [mockNetworkInterface]);
    });

    group('address', () {
      test('should return underlying socket address', () {
        final expected = InternetAddress.anyIPv4;

        when(mockSocket.address).thenReturn(expected);

        final actual = proxy.address;

        expect(actual, equals(expected));
      });
    });

    group('send', () {
      test('should call send on the socket', () {
        proxy.send([0], InternetAddress.anyIPv4, 2000);

        verify(mockSocket.send([0], InternetAddress.anyIPv4, 2000)).called(1);
      });
    });

    group('destroy', () {
      setUp(() {
        when(mockSocket.address).thenReturn(InternetAddress.anyIPv4);
      });

      test('should leave the multicast group', () async {
        await proxy.destroy();

        verify(mockSocket.leaveMulticast(any));
      });

      group('when leaving multicast throws an OSError', () {
        test('destroy should not fail', () {
          when(mockSocket.leaveMulticast(any)).thenThrow(const OSError());

          expectLater(() => proxy.destroy(), returnsNormally);
        });
      });

      test('should leave the interface multicast groups', () async {
        await proxy.destroy();

        verify(mockSocket.leaveMulticast(any, mockNetworkInterface));
      });

      group('when leaving interface multicast groups throws an OSError', () {
        test('destroy should not fail', () {
          when(mockSocket.leaveMulticast(any, any)).thenThrow(const OSError());

          expectLater(() => proxy.destroy(), returnsNormally);
        });
      });

      test('should close the socket', () async {
        await proxy.destroy();

        verify(mockSocket.close());
      });

      group('when socket close fails', () {
        test('destroy should not fail', () {
          when(mockSocket.close()).thenThrow('');

          expectLater(() => proxy.destroy(), returnsNormally);
        });
      });
    });

    group('listen', () {
      test('should listen to the socket', () {
        proxy.listen((socket, event) {});

        verify(mockSocket.listen(any)).called(1);
      });
    });
  });
}

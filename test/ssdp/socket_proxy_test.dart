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

      test('should leave the interface multicast groups', () async {
        await proxy.destroy();

        verify(mockSocket.leaveMulticast(any, mockNetworkInterface));
      });

      test('should close the socket', () async {
        await proxy.destroy();

        verify(mockSocket.close());
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

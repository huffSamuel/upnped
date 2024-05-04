import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

@GenerateNiceMocks([
  MockSpec<SocketFactory>(),
  MockSpec<RawDatagramSocket>(),
  MockSpec<NetworkInterface>(),
])
import 'socket_builder_test.mocks.dart';

void main() {
  group('SocketFactory', () {
    late MockNetworkInterface mockNetworkInterface;
    late MockSocketFactory mockFactory;
    late MockRawDatagramSocket mockSocket;
    late SocketBuilder builder;

    setUp(() {
      mockNetworkInterface = MockNetworkInterface();
      mockFactory = MockSocketFactory();
      mockSocket = MockRawDatagramSocket();
      when(mockFactory.create(any, any)).thenAnswer(
        (realInvocation) => Future.value(mockSocket),
      );

      builder = SocketBuilder(socketFactory: mockFactory);
    });

    group('build', () {
      test('should call builder.create()', () async {
        try {
          await builder.build(
            InternetAddress.anyIPv4,
            [],
            2000,
            (socket, event) {},
          );
        } catch (err) {
          //
        }

        verify(mockFactory.create(any, any));
      });

      test('should enable broadcast events', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.broadcastEnabled = true).called(1);
      });

      test('should enable read events', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.readEventsEnabled = true).called(1);
      });

      test('should disable write events', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.writeEventsEnabled = false).called(1);
      });

      test('should enable multicastLoopback', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.multicastLoopback = false).called(1);
      });

      test('should set multicast hops', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.multicastHops = 1).called(1);
      });

      for (var testCase in [
        (
          socketAddress: InternetAddress.anyIPv4,
          expected: InternetAddress('239.255.255.250')
        ),
        (
          socketAddress: InternetAddress.anyIPv6,
          expected: InternetAddress('FF05::C')
        )
      ]) {
        test('should join expected multicast group', () async {
          when(mockSocket.address).thenReturn(testCase.socketAddress);

          await builder.build(
            testCase.socketAddress,
            [],
            2000,
            (socket, event) {},
          );

          verify(mockSocket.joinMulticast(argThat(equals(testCase.expected))))
              .called(1);
        });
      }

      group('when fails to join multicast group', () {
        setUp(() {
          when(mockSocket.joinMulticast(any)).thenThrow(const OSError('error'));
        });

        test('should complete', () async {
          expect(
            builder.build(
              InternetAddress.anyIPv4,
              [],
              2000,
              (s, e) {},
            ),
            completes,
          );
        });
      });

      test('should join multicast group for each interface', () async {
        await builder.build(
          InternetAddress.anyIPv4,
          [mockNetworkInterface],
          2000,
          (socket, event) {},
        );

        verify(mockSocket.joinMulticast(
                any, argThat(equals(mockNetworkInterface))))
            .called(1);
      });

      group('when joining interface group fails', () {
        setUp(() {
          when(mockSocket.joinMulticast(any, any))
              .thenThrow(const OSError('error'));
        });

        test('should complete', () async {
          expect(
            builder.build(
              InternetAddress.anyIPv4,
              [mockNetworkInterface],
              2000,
              (s, e) {},
            ),
            completes,
          );
        });
      });
    });
  });
}

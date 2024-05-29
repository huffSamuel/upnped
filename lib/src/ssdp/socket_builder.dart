part of 'ssdp.dart';

typedef SocketCallback = void Function(
  RawDatagramSocket socket,
  RawSocketEvent event,
);

abstract class SocketFactory {
  Future<RawDatagramSocket> create(InternetAddress address, int port);
}

class RawDatagramSocketFactory implements SocketFactory {
  const RawDatagramSocketFactory();

  // coverage:ignore-start
  // Ignoring since we can't mock out the framework's static bind method.
  @override
  Future<RawDatagramSocket> create(
    InternetAddress address,
    int port,
  ) async {
    return await RawDatagramSocket.bind(
      address,
      port,
      reuseAddress: true,
      reusePort: !(Platform.isAndroid || Platform.isWindows),
    );
  }
  // coverage:ignore-end
}

class SocketBuilder {
  final SocketFactory socketFactory;

  const SocketBuilder({this.socketFactory = const RawDatagramSocketFactory()});

  Future<SocketProxy> build(
    InternetAddress address,
    List<NetworkInterface> interfaces,
    int port,
    SocketCallback fn, {
    int multicastHops = 1,
  }) async {
    final socket = await socketFactory.create(address, port)
      ..broadcastEnabled = true
      ..readEventsEnabled = true
      ..writeEventsEnabled = false
      ..multicastLoopback = false
      ..multicastHops = multicastHops;

    final proxy = SocketProxy(
      socket,
      interfaces,
    )..listen(fn);

    final group = _multicastAddress(address.type);

    try {
      socket.joinMulticast(group);
    } on OSError {
      Log.warn(
          'Socket failed to join multicast group. So long as a single socket joins, this is not a critical error.');
    }

    for (var interface in interfaces) {
      try {
        socket.joinMulticast(group, interface);
      } on OSError {
        Log.warn(
          'Socket failed to join multicast group. So long as a single socket joins, this is not a critical error.',
        );
      }
    }

    return proxy;
  }
}

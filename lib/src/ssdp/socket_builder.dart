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

    final group = _group(address.type);

    try {
      socket.joinMulticast(group);
    } on OSError {
      // TODO: Verbose log error
    }

    for (var interface in interfaces) {
      try {
        socket.joinMulticast(group, interface);
      } on OSError {
        // TODO: Verbose log error
      }
    }

    return proxy;
  }
}

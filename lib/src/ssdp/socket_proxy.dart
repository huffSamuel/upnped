part of 'ssdp.dart';

class SocketProxy {
  final RawDatagramSocket socket;
  final List<NetworkInterface> networkInterfaces;

  StreamSubscription? _sub;

  SocketProxy(this.socket, this.networkInterfaces);

  InternetAddress get address => socket.address;

  void send(
    List<int> buffer,
    InternetAddress address,
    int port,
  ) =>
      socket.send(
        buffer,
        address,
        port,
      );

  void listen(SocketCallback fn) {
    _sub = socket.listen((event) => fn(socket, event));
  }

  Future<void> destroy() async {
    final group = _multicastAddress(socket.address.type);

    await _sub?.cancel();

    try {
      socket.leaveMulticast(group);
    } on OSError {
      Log.warn('Failed to leave multicast group');
    }

    for (final interface in networkInterfaces) {
      try {
        socket.leaveMulticast(group, interface);
      } on OSError {
        Log.warn('Failed to leave interface multicast group');
      }
    }

    try {
      socket.close();
    } catch (err) {
      Log.error('Failed to close socket');
    }
  }
}

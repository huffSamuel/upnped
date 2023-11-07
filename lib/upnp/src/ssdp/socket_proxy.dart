part of ssdp;

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
    final group = _group(socket.address.type);

    await _sub?.cancel();
  

    try {
      socket.leaveMulticast(group);
    } on OSError {
      // TODO: verbose log
    }

    for (final interface in networkInterfaces) {
      try {
        socket.leaveMulticast(group, interface);
      } on OSError {
        // TODO: Verbose log
      }
    }

    socket.close();
  }
}

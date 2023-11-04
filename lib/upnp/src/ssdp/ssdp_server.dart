part of ssdp;

final InternetAddress _v4Multicast = InternetAddress('239.255.255.250');
final InternetAddress _v6Multicast = InternetAddress('FF05::C');
const _ssdpPort = 1900;
const _anyPort = 0;

InternetAddress _group(InternetAddressType addressType) {
  return addressType == InternetAddress.anyIPv4.type
      ? _v4Multicast
      : _v6Multicast;
}

class Server {
  final _clients = StreamController<Device>();

  final List<RawDatagramSocket> _sockets = [];
  final List<StreamSubscription> _subscriptions = [];

  late String _userAgent;
  late List<NetworkInterface> _interfaces;

  bool _running = false;

  /// A stream that emits whenever a new device is discovered.
  Stream<Device> get clients => _clients.stream;

  /// Indicates if the server is running.
  bool get started => _running;

  /// Stop listening for device discovery notifications.
  Future<void> stop() async {
    if (!_running) {
      return;
    }

    await Future.wait(_subscriptions.map((e) => e.cancel()));

    for (final socket in _sockets) {
      _destroySocket(socket);
    }

    _running = false;
  }

  /// Start listening for device discovery notifications.
  Future<void> start({
    int multicastHops = defaultMulticastHops,
  }) async {
    if (_sockets.isNotEmpty) {
      throw StateError('cannot start while running');
    }

    final [ua, interfaces] = await Future.wait([
      userAgent(),
      NetworkInterface.list(),
    ]);

    _userAgent = ua as String;
    _interfaces = interfaces as List<NetworkInterface>;

    await Future.wait([
      _createSocket(InternetAddress.anyIPv4, _interfaces, _ssdpPort),
      _createSocket(InternetAddress.anyIPv4, _interfaces, _anyPort),
      _createSocket(InternetAddress.anyIPv6, _interfaces, _ssdpPort),
      _createSocket(InternetAddress.anyIPv6, _interfaces, _anyPort),
    ]);

    _running = true;
  }

  /// Search for devices.
  ///
  /// Returns a `Future` that resolves when {maxResponseTime} has elapsed.
  ///
  /// Throws a `StateError` if the server has not been started yet.
  Future<void> search({
    Duration maxResponseTime = const Duration(seconds: defaultResponseSeconds),
    String? searchTarget,
  }) async {
    assert(
      maxResponseTime.inSeconds > 1,
      'maxResponseTime must be greater than or equal to 1',
    );

    if (!_running) {
      throw StateError('cannot search before server has been started');
    }
    searchTarget = searchTarget ?? defaultSearchTarget;

    final completer = Completer<void>();
    final request = MSearchRequest.multicast(
      _userAgent,
      mx: maxResponseTime.inSeconds,
      st: searchTarget,
    );
    final data = request.encode();

    for (final socket in _sockets) {
      final target = socket.address.type == _v4Multicast.type
          ? _v4Multicast
          : _v6Multicast;

      try {
        socket.send(data, target, _ssdpPort);
      } on SocketException {
        // TODO: verbose log error
      }
    }

    Future.delayed(
      maxResponseTime,
    ).then((_) => completer.complete());

    return completer.future;
  }

  void _destroySocket(RawDatagramSocket socket) {
    final group = _group(socket.address.type);

    try {
      socket.leaveMulticast(group);
    } on OSError {
      // TODO: verbose log
    }

    for (final interface in _interfaces) {
      try {
        socket.leaveMulticast(group, interface);
      } on OSError {
        // TODO: Verbose log
      }
    }

    socket.close();
  }

  Future<void> _createSocket(
    InternetAddress address,
    List<NetworkInterface> interfaces,
    int port,
  ) async {
    final socket = await RawDatagramSocket.bind(
      address,
      port,
      reuseAddress: true,
      reusePort: !Platform.isAndroid,
    )
      ..broadcastEnabled = true
      ..readEventsEnabled = true
      ..writeEventsEnabled = false
      ..multicastLoopback = false
      ..multicastHops = 1; // TODO: from options

    _subscriptions.add(socket.listen((event) => _onSocketEvent(socket, event)));

    final multicast = _group(address.type);

    try {
      socket.joinMulticast(multicast);
    } on OSError {
      // TODO: Verbose log error
    }

    for (var interface in interfaces) {
      try {
        socket.joinMulticast(multicast, interface);
      } on OSError {
        // TODO: Verbose log error
      }
    }

    _sockets.add(socket);
  }

  void _onSocketEvent(RawDatagramSocket socket, RawSocketEvent event) {
    final packet = socket.receive();

    if (packet == null) {
      return;
    }

    try {
      _clients.add(Device.fromPacket(packet));
    } catch (err) {
      // TODO: If logging enabled print the log
    }
  }
}

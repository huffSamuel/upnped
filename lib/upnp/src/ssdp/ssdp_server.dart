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

class Server with EnsureUserAgentMixin {
  final _discoveredController = StreamController<Device>.broadcast();
  final List<SocketProxy> _sockets = [];
  final SocketBuilder _socketBuilder;

  late List<NetworkInterface> _interfaces;

  bool _running = false;

  Server._({
    UserAgentFactory userAgentFactory = const PlatformUserAgentFactory(),
    SocketBuilder socketBuilder = const SocketBuilder(),
  }) : _socketBuilder = socketBuilder {
    super.userAgentFactory = userAgentFactory;
  }

  factory Server() => Server._();

  @visibleForTesting
  factory Server.forTest({
    required UserAgentFactory userAgentFactory,
    required SocketBuilder socketBuilder,
  }) =>
      Server._(
        userAgentFactory: userAgentFactory,
        socketBuilder: socketBuilder,
      );

  /// A stream that emits whenever a new device is discovered.
  Stream<Device> get discovered => _discoveredController.stream;

  /// Indicates if the server is running.
  bool get started => _running;

  /// Stop listening for device discovery notifications.
  Future<void> stop() async {
    if (!_running) {
      return;
    }

    await Future.wait(_sockets.map((e) => e.destroy()));

    _running = false;
  }

  /// Start listening for device discovery notifications.
  Future<void> start({
    int multicastHops = defaultMulticastHops,
  }) async {
    if (_sockets.isNotEmpty) {
      throw StateError('cannot start while running');
    }

    await ensureUserAgent();
    _interfaces = await NetworkInterface.list();

    await Future.wait([
      _socketBuilder.build(
        InternetAddress.anyIPv4,
        _interfaces,
        _ssdpPort,
        _onSocketEvent,
        multicastHops: multicastHops,
      ),
      _socketBuilder.build(
        InternetAddress.anyIPv4,
        _interfaces,
        _anyPort,
        _onSocketEvent,
        multicastHops: multicastHops,
      ),
      _socketBuilder.build(
        InternetAddress.anyIPv6,
        _interfaces,
        _ssdpPort,
        _onSocketEvent,
        multicastHops: multicastHops,
      ),
      _socketBuilder.build(
        InternetAddress.anyIPv6,
        _interfaces,
        _anyPort,
        _onSocketEvent,
        multicastHops: multicastHops,
      ),
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
      currentUserAgent!,
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

        networkController.add(MSearchEvent(request.toString()));
        // TODO: Add message sent event
      } on SocketException {
        // TODO: verbose log error
      }
    }

    Future.delayed(
      maxResponseTime,
    ).then((_) => completer.complete());

    return completer.future;
  }

  void _onSocketEvent(RawDatagramSocket socket, RawSocketEvent event) {
    final packet = socket.receive();

    if (packet == null) {
      return;
    }

    final device = Device.parse(packet.data);
    networkController.add(NotifyEvent(device.location!, device.toString()));

    try {
      _discoveredController.add(device);
    } catch (err) {
      // TODO: If logging enabled print the log
    }
  }
}

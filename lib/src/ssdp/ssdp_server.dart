part of 'ssdp.dart';

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
  final _discoveredController = StreamController<Device>.broadcast();
  final List<SocketProxy> _sockets = [];
  final SocketBuilder _socketBuilder;
  final UserAgentFactory _userAgentFactory;

  late List<NetworkInterface> _interfaces;

  /// A stream that emits whenever a new device is discovered.
  Stream<Device> get discovered => _discoveredController.stream;

  Server({
    required SocketBuilder socketBuilder,
    required UserAgentFactory userAgentFactory,
  })  : _socketBuilder = socketBuilder,
        _userAgentFactory = userAgentFactory;

  /// Stop listening for device discovery notifications.
  Future<void> stop() async {
    await Future.wait(_sockets.map((e) => e.destroy()));
    _sockets.clear();
  }

  /// Start listening for device discovery notifications.
  Future<void> start({
    int multicastHops = defaultMulticastHops,
    bool ipv4 = true,
    bool ipv6 = true,
  }) async {
    if (_sockets.isNotEmpty) {
      throw StateError('cannot start while running');
    }

    _interfaces = await NetworkInterface.list();

    _sockets.addAll(await Future.wait([
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
    ]));
  }

  /// Search for devices.
  void search({
    Duration maxResponseTime = const Duration(seconds: defaultResponseSeconds),
    String searchTarget = defaultSearchTarget,
  }) async {
    final userAgent = await _userAgentFactory.create();

    final request = MSearchRequest.multicast(
      userAgent,
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
      } on SocketException catch (e) {
        log('error', 'Unable to send MSEARCH packet', {"exception": e});
      }
    }
  }

  void _onSocketEvent(RawDatagramSocket socket, RawSocketEvent event) {
    final packet = socket.receive();

    if (packet == null) {
      return;
    }

    try {
      final device = Device.parse(packet.data);
      networkController.add(NotifyEvent(device.location!, device.toString()));
      _discoveredController.add(device);
    } catch (err) {
      log('error', 'Unable to parse packet as NOTIFY', {
        'packet': utf8.decode(packet.data),
        'port': packet.port,
        'address': packet.address
      });
    }
  }
}

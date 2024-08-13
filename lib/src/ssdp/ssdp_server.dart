part of 'ssdp.dart';

final InternetAddress _v4Multicast = InternetAddress('239.255.255.250');
final InternetAddress _v6Multicast = InternetAddress('FF05::C');
const _ssdpPort = 1900;
const _anyPort = 0;

InternetAddress _multicastAddress(InternetAddressType addressType) {
  return addressType == InternetAddress.anyIPv4.type
      ? _v4Multicast
      : _v6Multicast;
}

typedef ListNetworkFn = Future<List<NetworkInterface>> Function();

sealed class NetworkInterfaceLister {
  Future<List<NetworkInterface>> list();
}

// coverage:ignore-start
class NativeNetworkInterfaceLister implements NetworkInterfaceLister {
  @override
  Future<List<NetworkInterface>> list() => NetworkInterface.list();
}
// coverage:ignore-end

class Server {
  final _discoveredController = StreamController<Notify>();
  final List<SocketProxy> _sockets = [];
  final SocketBuilder _socketBuilder;
  final UserAgentFactory _userAgentFactory;
  final NetworkInterfaceLister _networkLister;

  late List<NetworkInterface> _interfaces;

  /// A stream that emits whenever a new device is discovered.
  Stream<Notify> get discovered => _discoveredController.stream;

  Server()
      : _socketBuilder = const SocketBuilder(),
        _userAgentFactory = PlatformUserAgentFactory(),
        _networkLister = NativeNetworkInterfaceLister();

  @visibleForTesting
  Server.forTest({
    required SocketBuilder socketBuilder,
    required UserAgentFactory userAgentFactory,
    required NetworkInterfaceLister networkLister,
  })  : _userAgentFactory = userAgentFactory,
        _socketBuilder = socketBuilder,
        _networkLister = networkLister;

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

    _interfaces = await _networkLister.list();

    _sockets.addAll(
      await Future.wait(
        [
          (InternetAddress.anyIPv4, _ssdpPort),
          (InternetAddress.anyIPv4, _anyPort),
          (InternetAddress.anyIPv6, _ssdpPort),
          (InternetAddress.anyIPv6, _anyPort),
        ].map(
          (x) => _socketBuilder.build(
            x.$1,
            _interfaces,
            x.$2,
            _onSocketEvent,
            multicastHops: multicastHops,
          ),
        ),
      ),
    );
  }

  /// Search for devices.
  Future<void> search({
    Duration maxResponseTime = const Duration(seconds: defaultResponseSeconds),
    String searchTarget = defaultSearchTarget,
  }) async {
    if (_sockets.isEmpty) {
      throw StateError('Cannot search without starting');
    }

    final userAgent = await _userAgentFactory.create();

    final request = MSearch.multicast(
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

        final event = MSearchEvent(content: request.toString());
        networkController.add(event);
      } on SocketException catch (e) {
        Log.error('Unable to send MSEARCH packet', {"exception": e});
      }
    }
  }

  void _onSocketEvent(RawDatagramSocket socket, RawSocketEvent event) {
    final packet = socket.receive();

    if (packet == null) {
      return;
    }

    final data = utf8.decode(packet.data);
    final lines = data.split('\r\n');

    try {
      if (lines[0].contains(MSearch.method)) {
        // TODO: Emit an MSEARCH network event
        Log.info('M-SEARCH request heard', {
          'data': lines,
        });
        return;
      }

      final notify = Notify.parse(data);

      final device = NotifyDiscovered(notify);
      final event = NotifyEvent(
        device.location!,
        content: notify.toString(),
      );
      networkController.add(event);
      _discoveredController.add(notify);
    } catch (err) {
      Log.error('Unable to parse packet as NOTIFY', {
        'packet': utf8.decode(packet.data),
        'port': packet.port,
        'address': packet.address
      });
    }
  }
}

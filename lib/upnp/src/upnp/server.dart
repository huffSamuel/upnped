part of upnp;

/// A UPnP Server.
class Server {
  StreamSubscription? _clientSub;
  late ssdp.Server _ssdp;

  final _devices = StreamController<UPnPDevice>.broadcast();
  final DeviceBuilder _deviceBuilder;

  /// A broadcast stream of UPnP devices discovered.
  Stream<UPnPDevice> get devices => _devices.stream;

  /// Create a new server.
  ///
  /// {ssdpServer} is intended for testing.
  Server._({
    ssdp.Server? ssdpServer,
    DeviceBuilder deviceBuilder = const DeviceBuilder(),
  }) : _deviceBuilder = deviceBuilder {
    _ssdp = ssdpServer ??= ssdp.Server();
  }

  factory Server() => Server._();

  @visibleForTesting
  factory Server.forTest({
    required ssdp.Server ssdpServer,
  }) =>
      Server._(
        ssdpServer: ssdpServer,
      );

  /// Stop listening for UPnP devices on the network.
  Future<void> stop() {
    _clientSub?.cancel();
    _clientSub = null;

    return _ssdp.stop();
  }

  /// Start the server and begin listening for devices.
  ///
  /// Devices that emit regular NOTIFY messages may be found before calling the
  /// `search` method.
  ///
  /// Setting {locale} *may* cause devices to respond in that locale. Devices are not required
  /// to comply with local preferences.
  Future<void> start({
    String? locale,
    int multicastHops = defaultMulticastHops,
  }) async {
    final effectiveLocale = locale ?? defaultLocale;

    _clientSub?.cancel();

    _clientSub = _ssdp.discovered.listen((event) {
      _deviceBuilder.build(event, effectiveLocale).then(_devices.add);
    });

    await _ssdp.start(
      multicastHops: multicastHops,
    );
  }

  /// Search for UPnP devices on the network.
  Future<void> search({
    Duration maxResponseTime = const Duration(seconds: defaultResponseSeconds),
    String? searchTarget,
  }) =>
      _ssdp.search(
        maxResponseTime: maxResponseTime,
        searchTarget: searchTarget,
      );
}

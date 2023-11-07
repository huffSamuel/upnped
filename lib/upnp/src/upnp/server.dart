part of upnp;

/// A UPnP Server.
class Server {
  StreamSubscription? _clientSub;
  late ssdp.Server _ssdp;

  final _devices = StreamController<UPnPDevice>.broadcast();

  /// A broadcast stream of UPnP devices discovered.
  Stream<UPnPDevice> get devices => _devices.stream;

  /// Create a new server.
  ///
  /// {ssdpServer} is intended for testing.
  Server._({
    ssdp.Server? ssdpServer,
  }) {
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
      _getRootDevice(event, effectiveLocale);
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

  Future<ServiceAggregate> _getService(
    ssdp.Device client,
    Map<String, String> headers,
    ServiceDocument document,
  ) async {
    final uri = Uri(
      scheme: client.location!.scheme,
      host: client.location!.host,
      port: client.location!.port,
      pathSegments: document.scpdurl.pathSegments,
    );

    Service? service;

    try {
      final response = await http.get(uri, headers: headers);
      service = Service.fromXml(
        XmlDocument.parse(
          response.body,
        ),
      );
    } catch (err) {
      service = null;
    }

    return ServiceAggregate(
      document,
      service,
      uri,
    );
  }

  Future<DeviceAggregate> _getDevice(
    ssdp.Device client,
    DeviceDocument device,
    Map<String, String> headers,
  ) async {
    final services = await Future.wait(
      device.services.map(
        (service) => _getService(
          client,
          headers,
          service,
        ),
      ),
    );

    final devices = await Future.wait(
      device.devices.map(
        (device) => _getDevice(
          client,
          device,
          headers,
        ),
      ),
    );

    return DeviceAggregate(
      device,
      services,
      devices,
    );
  }

  Future<UPnPDevice> _getRootDevice(
    ssdp.Device client,
    String locale,
  ) async {
    final headers = {HttpHeaders.acceptLanguageHeader: locale};

    final response = await http.get(
      client.location!,
      headers: headers,
    );

    final deviceDocument =
        XmlDocument.parse(response.body).rootElement.getElement('device');
    final device = DeviceDocument.fromXml(deviceDocument!);

    final aggregate = await _getDevice(
      client,
      device,
      headers,
    );

    return UPnPDevice(
      client,
      device,
      aggregate.services,
      aggregate.devices,
    );
  }
}

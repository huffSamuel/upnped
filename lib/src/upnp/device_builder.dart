part of 'upnp.dart';

class DeviceManager {
  final Map<String, _DeviceImpl> _devices = {};

  final http.Client _client;

  DeviceManager() : _client = http.Client();

  @visibleForTesting
  DeviceManager.forTest({
    required http.Client client,
  }) : _client = client;

  Future<http.Response> _get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers);
    networkController.add(HttpEvent(response));
    return response;
  }

  void activateDevice(NotifyAlive notify) {
    _devices[notify.usn]?.alive(notify);
  }

  void deactivateDevice(NotifyByeBye notify) {
    _devices[notify.usn]?.byebye();
  }

  /// Build a UPnPDevice from [notify].
  ///
  /// This method retrieves all device and service documents for the given client and constructs
  /// an aggregate device from the retrieved information.
  Future<Device> build(
    NotifyDiscovered notify,
    String locale,
  ) async {
    final headers = {HttpHeaders.acceptLanguageHeader: locale};

    final response = await _get(
      notify.location!,
      headers: headers,
    );

    final deviceDocument =
        XmlDocument.parse(response.body).rootElement.getElement('device');
    final device = DeviceDocument.fromXml(deviceDocument!);

    final aggregate = await _getDevice(
      notify,
      device,
      headers,
    );

    final rootDevice = _DeviceImpl(
      device,
      aggregate.services,
      aggregate.devices,
      notify: notify,
    );

    _devices[rootDevice.description.udn] = rootDevice;

    return rootDevice;
  }

  Future<ServiceAggregate> _getService(
    NotifyDiscovered client,
    Map<String, String> headers,
    ServiceDescription document,
  ) async {
    final uri = Uri(
      scheme: client.location!.scheme,
      host: client.location!.host,
      port: client.location!.port,
      pathSegments: document.scpdurl.pathSegments,
    );

    Service? service;

    try {
      final response = await _get(uri, headers: headers);

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

  Future<_DeviceImpl> _getDevice(
    NotifyDiscovered client,
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

    return _DeviceImpl(
      device,
      services,
      devices,
    );
  }
}

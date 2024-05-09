part of 'upnp.dart';

class DeviceBuilder {
  final http.Client _client;

  DeviceBuilder() : _client = http.Client();

  @visibleForTesting
  DeviceBuilder.forTest({
    required http.Client client,
  }) : _client = client;

  Future<http.Response> _get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers);
    networkController.add(HttpEvent(response));
    return response;
  }

  /// Build a UPnPDevice from [client].
  ///
  /// This method retrieves all device and service documents for the given client and constructs
  /// an aggregate device from the retrieved information.
  Future<UPnPDevice> build(
    ssdp.Device client,
    String locale,
  ) async {
    final headers = {HttpHeaders.acceptLanguageHeader: locale};

    final response = await _get(
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
}

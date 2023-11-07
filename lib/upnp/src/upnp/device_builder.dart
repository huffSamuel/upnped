part of upnp;

class DeviceBuilder {
  const DeviceBuilder();

  Future<UPnPDevice> build(
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
}

part of '../upnp.dart';

// TODO: Support extension nodes

/// A collection of vendor-specific information, definitions of all embedded
/// devices, URL for presentation of the device, and listings for all services,
/// including URLs for control and eventing
class DeviceDescription {
  /// UPnP device type.
  final DeviceType deviceType;

  final String friendlyName;

  /// Manufacturer's name.
  final String manufacturer;

  /// Web site for [manufacturer].
  final Uri? manufacturerUrl;

  /// Long description for end user.
  final String? modelDescription;

  /// Model name.
  final String modelName;

  /// Model number.
  final String? modelNumber;

  /// Web site for model.
  final Uri? modelUrl;

  /// Serial number.
  final String? serialNumber;

  /// Unique device name.
  ///
  /// A universally-unique identifier for the device, whether root or embedded.
  final String udn;

  /// Universal product code.
  ///
  /// A 12-digit, all numeric code that identifies the consumer packages.
  final String? upc;

  /// List of icons that visually represent this device.
  final List<DeviceIcon> iconList;

  /// List of services available on this device.
  final List<ServiceData> services;

  /// List of child devices on this device.
  final List<DeviceDescription> devices;

  /// URL to presentation for this device.
  final Uri? presentationUrl;

  /// Extension properties.
  /// 
  /// These provide manufacturer-specific information for non-UPnP spec behaviors.
  final UnmodifiableListView<XmlElement> extensions;

  DeviceDescription._({
    required this.deviceType,
    required this.friendlyName,
    required this.manufacturer,
    this.manufacturerUrl,
    this.modelDescription,
    required this.modelName,
    this.modelNumber,
    this.modelUrl,
    this.serialNumber,
    required this.udn,
    this.upc,
    required this.iconList,
    required this.services,
    required this.devices,
    this.presentationUrl,
    required this.extensions,
  });

  factory DeviceDescription.fromXml(XmlNode xml) {
    final presentationUrl = xml.getElement('presentationURL');

    final modelUrl = xml.getElement('modelURL');
    final manufacturerUrl = xml.getElement('manufacturerURL');

    final extensions = xml.nodes.whereType<XmlElement>().where((x) => x.namespacePrefix != null).toList();

    return DeviceDescription._(
      deviceType: DeviceType(uri: xml.getElement('deviceType')!.innerText),
      friendlyName: xml.getElement('friendlyName')!.innerText,
      manufacturer: xml.getElement('manufacturer')!.innerText,
      manufacturerUrl:
          manufacturerUrl != null ? Uri.parse(manufacturerUrl.innerText) : null,
      modelDescription: xml.getElement('modelDescription')?.innerText,
      modelName: xml.getElement('modelName')!.innerText,
      modelNumber: xml.getElement('modelNumber')?.innerText,
      modelUrl: modelUrl != null ? Uri.parse(modelUrl.innerText) : null,
      serialNumber: xml.getElement('serialNumber')?.innerText,
      udn: xml.getElement('UDN')!.innerText,
      upc: xml.getElement('UPC')?.innerText,
      iconList: _elementMapper(
        xml.getElement('iconList'),
        'icon',
        DeviceIcon.fromXml,
      ),
      services: _nodeMapper(
        xml.getElement('serviceList'),
        'service',
        ServiceData.fromXml,
      ),
      devices: _nodeMapper(
        xml.getElement('deviceList'),
        'device',
        DeviceDescription.fromXml,
      ),
      presentationUrl:
          presentationUrl != null ? Uri.parse(presentationUrl.innerText) : null,
      extensions: UnmodifiableListView(extensions),
    );
  }
}

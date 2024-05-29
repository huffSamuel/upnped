part of '../upnp.dart';

/// A service as defined in a [DeviceDescription].
class ServiceData {
  /// UPnP service type.
  final String serviceType;

  final String serviceVersion;

  /// Service identifier.
  final ServiceId serviceId;

  /// URL for service description.
  final Uri scpdurl;

  /// URL for control.
  final Uri controlUrl;

  /// URL for eventing.
  final Uri eventSubUrl;

  ServiceData({
    required this.serviceType,
    required this.serviceVersion,
    required this.serviceId,
    required this.scpdurl,
    required this.controlUrl,
    required this.eventSubUrl,
  });

  factory ServiceData.fromXml(XmlNode xml) {
    final scpdurl = xml.getElement('SCPDURL')?.innerText;
    final controlUrl = xml.getElement('controlURL')?.innerText;
    final eventSubUrl = xml.getElement('eventSubURL')?.innerText;
    final serviceType = xml.getElement('serviceType')!.innerText;

    final serviceTypeFields = serviceType.split(':');

    return ServiceData(
      serviceType: serviceTypeFields[serviceTypeFields.length - 2],
      serviceVersion: serviceTypeFields[serviceTypeFields.length - 1],
      serviceId: ServiceId.parse(xml.getElement('serviceId')!.innerText),
      scpdurl: Uri.parse(scpdurl!),
      controlUrl: Uri.parse(controlUrl!),
      eventSubUrl: Uri.parse(eventSubUrl!),
    );
  }
}

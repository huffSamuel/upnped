part of 'ssdp.dart';

/// A string that determines which UPnP devices reply to search requests.
class SearchTarget {
  /// Search for all devices and services.
  static const String all = 'ssdp:all';

  /// Search for root devices only.
  static const String rootDevice = 'upnp:rootdevice';

  /// Search for a particular device.
  static String device(String uuid) => 'uuid:$uuid';

  /// Search for any device of this type.
  static String deviceType(String deviceType, String ver) =>
      ('urn:schemas-upnp-org:device:$deviceType:$ver');

  /// Search for any service of this type.
  static String serviceType(String serviceType, String ver) =>
      ('urn:schemas-upnp-org:service:$serviceType:$ver');

  /// Search for any device of this type.
  /// 
  /// {domain}, {deviceType}, and {ver} are defined by the UPnP vendor.
  static String vendorDomain(String domain, String deviceType, String ver) =>
      ('urn:${_sanitize(domain)}:device:$deviceType:$ver');

  /// Search for any service of this type.
  /// 
  /// {domain}, {serviceType}, and {ver} are defined by the UPnP vendor.
  static String vendorService(String domain, String serviceType, String ver) =>
      ('urn:${_sanitize(domain)}:service:$serviceType:$ver');

  static String _sanitize(String domain) => domain.replaceAll('.', '-');
}

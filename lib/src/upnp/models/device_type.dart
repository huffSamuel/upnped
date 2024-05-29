part of '../upnp.dart';

/// Utility class that separates a UPnP device type string into its component parts.
class DeviceType {
  /// The full UPnP device type.
  final String uri;

  List<String> get _fields => uri.split(':');

  /// Domain name of this device.
  String get domainName => _fields[1];

  /// Type of this device.
  String get deviceType => _fields[3];

  /// Version of this device.
  int get version => int.parse(_fields[4]);

  DeviceType({
    required this.uri,
  });
}

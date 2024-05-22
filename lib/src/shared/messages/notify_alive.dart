part of '../messages.dart';

class NotifyAlive extends NotifyDecorator {
  static final List<String> _knownKeys = [
    NotifyKey.host,
    NotifyKey.cacheControl,
    NotifyKey.location,
    NotifyKey.nt,
    NotifyKey.nts,
    NotifyKey.server,
    NotifyKey.sp,
    NotifyKey.sl,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => parseHost(headers[NotifyKey.host]!);

  /// Max duration, in seconds, after which control points should assume this device
  /// is no longer available.
  String get cacheControl => headers[NotifyKey.cacheControl]!;

  /// URL to the UPnP description of the root device.
  Uri get location => Uri.parse(headers[NotifyKey.location]!);

  /// Notification type.
  String get nt => headers[NotifyKey.nt]!;

  /// Server name specified by the UPnP vendor.
  ///
  /// Takes the form {OS name}/{OS version} UPnP/2.0 {product name}/{product version}
  String get server => headers[NotifyKey.server]!;

  /// If port 1900 is unavailable, this device is allowed to respond to unicast M-SEARCH
  /// messages on this port.
  int? get searchPort => allowed(NotifyKey.sp, int.parse);

  /// The base URL for a TLS connection.
  String? get secureLocation => wrapped.headers[NotifyKey.sl];

  NotifyAlive(
    Notify data,
  ) : super(data, NotifyAlive._knownKeys);
}

part of '../messages.dart';

class NotifyUpdate extends NotifyDecorator {
  static final List<String> _knownKeys = [
    NotifyKey.host,
    NotifyKey.location,
    NotifyKey.nt,
    NotifyKey.nts,
    NotifyKey.nbid,
    NotifyKey.sp,
    NotifyKey.sl,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => parseHost(headers[NotifyKey.host]!);

  /// URL to the UPnP description of the root device.
  Uri get location => Uri.parse(headers[NotifyKey.location]!);

  /// Notification type.
  String get nt => headers[NotifyKey.nt]!;

  /// The new bootId that the device intends to use in subsequent announcement
  /// messages.
  int get nextBootId => int.parse(headers[NotifyKey.nbid]!);

  /// If port 1900 is unavailable, this device is allowed to respond to unicast M-SEARCH
  /// messages on this port.
  int? get searchPort => allowed(NotifyKey.sp, int.parse);

  /// The base URL for a TLS connection.
  String? get secureLocation => headers[NotifyKey.sl];

  NotifyUpdate(Notify data) : super(data, NotifyUpdate._knownKeys);
}

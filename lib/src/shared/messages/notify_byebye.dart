part of '../messages.dart';

class NotifyByeBye extends NotifyDecorator {
  static final List<String> _knownKeys = [
    NotifyKey.host,
    NotifyKey.nt,
    NotifyKey.nts,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => parseHost(headers[NotifyKey.host]!);

  /// Notification type.
  String get nt => headers[NotifyKey.nt]!;

  NotifyByeBye(Notify data) : super(data, NotifyByeBye._knownKeys);
}

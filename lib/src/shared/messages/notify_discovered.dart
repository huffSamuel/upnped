part of '../messages.dart';

/// A NOTIFY response from a device to a M-SEARCH request.
class NotifyDiscovered extends NotifyDecorator {
  static final _knownKeys = [
    NotifyKey.cacheControl,
    NotifyKey.date,
    NotifyKey.ext,
    NotifyKey.location,
    NotifyKey.server,
    NotifyKey.st,
    NotifyKey.sp,
    NotifyKey.sl
  ];

  /// After this duration, control points should assume the device is no longer available.
  String? get cacheControl => wrapped.headers[NotifyKey.cacheControl];

  /// The RFC1123-date when this response was generated.
  DateTime? get date => allowed(NotifyKey.date, HttpDate.parse);

  /// Required for backwards compatibility with UPnP 1.0.
  String? get ext => wrapped.headers[NotifyKey.ext];

  /// The URL to the UPnP description of the root device.
  Uri? get location => allowed(NotifyKey.location, Uri.parse);

  /// Specified by the UPnP vendor, this specifies product tokens for the device.
  String? get server => wrapped.headers[NotifyKey.server];

  /// The search target. This field changes depending on the search request.
  String get st => wrapped.headers[NotifyKey.st]!;

  /// Device will respond to M-SEARCH messages sent to this port only if port 1900 is unavailable.
  int? get searchPort => allowed(NotifyKey.sp, int.parse);

  /// Base URL for the scheme component and correct port for a TLS connection.
  String? get secureLocation => wrapped.headers[NotifyKey.sl];

  /// Get a single extension value for the device.
  ///
  /// Returns `null` if the extension is not defined for this device.
  String? extension(String key) => extensions[key.toLowerCase()];

  NotifyDiscovered(Notify notify) : super(notify, _knownKeys);
}

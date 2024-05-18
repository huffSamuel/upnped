part of '../ssdp.dart';

const _cacheControl = 'cache-control';
const _date = 'date';
const _ext = 'ext';
const _location = 'location';
const _opt = 'opt';
const _server = 'server';
const _st = 'st';
const _usn = 'usn';
const _nt = 'nt';
const _nts = 'nts';
const _bid = 'bootid.upnp.org';
const _nbid = 'nextbootid.upnp.org';
const _cid = 'configid.upnp.org';
const _sp = 'searchport.upnp.org';
const _sl = 'securelocation.upnp.org';
const _host = 'host';

const _commonKnown = [
  _bid,
  _cid,
  _usn,
];

UnmodifiableMapView<String, String> _createHeaderMap(
  UnmodifiableMapView<String, String> all,
  bool Function(MapEntry e) include,
) =>
    UnmodifiableMapView(Map.fromEntries(all.entries.where(include)));

enum NotificationSubtype {
  none(null),
  alive('ssdp:alive'),
  byebye('ssdp:byebye');

  const NotificationSubtype(this.value);

  factory NotificationSubtype.from(String? value) {
    for (final n in NotificationSubtype.values) {
      if (value == n.value) {
        return n;
      }
    }

    throw 'Unknown value $value';
  }

  final String? value;
}

class NotifyMessage with EquatableMixin {
  final String _raw;
  final UnmodifiableMapView<String, String> headers;

  NotifyMessage(this._raw, this.headers);

  factory NotifyMessage.parse(
    Uint8List data,
  ) {
    final raw = utf8.decode(data);
    final headers = <String, String>{};
    for (var segment in raw.split('\r\n')) {
      final colon = segment.indexOf(':');

      if (colon != -1) {
        final key = segment.substring(0, colon).trim().toLowerCase();
        final value = segment.substring(colon + 1).trim();

        headers[key] = value;
      }
    }

    return NotifyMessage(
      raw,
      UnmodifiableMapView(headers),
    );
  }

  @override
  List<Object?> get props => [_raw];
}

abstract class _Notify with EquatableMixin {
  final NotifyMessage _data;

  /// Unique service name of a device or service.
  String get usn => _data.headers[_usn]!;

  /// The boot instance of the device specified by a monotonically increasing value.
  int get bootId => int.parse(_data.headers[_bid]!);

  /// The configuration number of the root device.
  int get configId => int.parse(_data.headers[_cid]!);

  /// Extension headers in this notification.
  UnmodifiableMapView<String, String> extensions;

  /// Known headers in this notification.
  UnmodifiableMapView<String, String> known;

  /// All headers in this notification.
  UnmodifiableMapView<String, String> get headers => _data.headers;

  _Notify(this._data, List<String> known)
      : extensions =
            _createHeaderMap(_data.headers, (e) => !known.contains(e.key)),
        known = _createHeaderMap(_data.headers, (e) => known.contains(e.key));

  @override
  List<Object?> get props => [_data];
}

class Notify extends _Notify {
  static final _knownKeys = [
    _cacheControl,
    _date,
    _ext,
    _location,
    _server,
    _st,
    _sp,
    _sl
  ];

  /// After this duration, control points should assume the device is no longer available.
  String? get cacheControl => _data.headers[_cacheControl];

  /// The RFC1123-date when this response was generated.
  DateTime? get date => _data.headers['date'] == null
      ? null
      : HttpDate.parse(_data.headers[_date]!);

  /// Required for backwards compatibility with UPnP 1.0.
  String? get ext => _data.headers[_ext];

  /// The URL to the UPnP description of the root device.
  Uri? get location => _data.headers[_location] == null
      ? null
      : Uri.parse(_data.headers[_location]!);

  /// Specified by the UPnP vendor, this specifies product tokens for the device.
  String? get server => _data.headers[_server];

  /// The search target. This field changes depending on the search request.
  String get st => _data.headers[_st]!;

  /// Device will respond to M-SEARCH messages sent to this port only if port 1900 is unavailable.
  int? get searchPort => _int(_sp);

  /// Base URL for the scheme component and correct port for a TLS connection.
  String? get secureLocation => _data.headers[_sl];

  /// Get a single extension value for the device.
  ///
  /// Returns `null` if the extension is not defined for this device.
  String? extension(String key) => extensions[key.toLowerCase()];

  int? _int(String key) =>
      _data.headers[key] == null ? null : int.tryParse(_data.headers[key]!);

  Notify(NotifyMessage data) : super(data, Notify._knownKeys);

  @override
  List<Object?> get props => [_data];
}

class NotifyAlive extends _Notify {
  static final List<String> _knownKeys = [
    _host,
    _cacheControl,
    _location,
    _nt,
    _nts,
    _server,
    _sp,
    _sl,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => _parseHost(_data.headers[_host]!);

  /// Max duration, in seconds, after which control points should assume this device
  /// is no longer available.
  String get cacheControl => _data.headers[_cacheControl]!;

  /// URL to the UPnP description of the root device.
  Uri get location => Uri.parse(_data.headers[_location]!);

  /// Notification type.
  String get nt => _data.headers[_nt]!;

  /// Notification subtype.
  NotificationSubtype get nts => NotificationSubtype.alive;

  /// Server name specified by the UPnP vendor.
  ///
  /// Takes the form {OS name}/{OS version} UPnP/2.0 {product name}/{product version}
  String get server => _data.headers[_server]!;

  /// If port 1900 is unavailable, this device is allowed to respond to unicast M-SEARCH
  /// messages on this port.
  int? get searchPort =>
      _data.headers[_sp] == null ? null : int.tryParse(_data.headers[_sp]!);

  /// The base URL for a TLS connection.
  String? get secureLocation => _data.headers[_sl];

  NotifyAlive(
    NotifyMessage data,
  ) : super(data, NotifyAlive._knownKeys);
}

class NotifyByeBye extends _Notify {
  static final List<String> _knownKeys = [
    _host,
    _nt,
    _nts,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => _parseHost(_data.headers[_host]!);

  /// Notification type.
  String get nt => _data.headers[_nt]!;

  /// Notification subtype.
  NotificationSubtype get nts => NotificationSubtype.byebye;

  NotifyByeBye(NotifyMessage data) : super(data, NotifyByeBye._knownKeys);
}

class NotifyUpdate extends _Notify {
  static final List<String> _knownKeys = [
    _host,
    _location,
    _nt,
    _nts,
    _nbid,
    _sp,
    _sl,
  ];

  /// The multicast address and port reserved for SSDP.
  InternetAddress get host => _parseHost(_data.headers[_host]!);

  /// URL to the UPnP description of the root device.
  Uri get location => Uri.parse(_data.headers[_location]!);

  /// Notification type.
  String get nt => _data.headers[_nt]!;

  /// Notification subtype.
  NotificationSubtype get nts => NotificationSubtype.byebye;

  /// The new bootId that the device intends to use in subsequent announcement
  /// messages.
  int get nextBootId => int.parse(_data.headers[_nbid]!);

  /// If port 1900 is unavailable, this device is allowed to respond to unicast M-SEARCH
  /// messages on this port.
  int? get searchPort =>
      _data.headers[_sp] == null ? null : int.tryParse(_data.headers[_sp]!);

  /// The base URL for a TLS connection.
  String? get secureLocation => _data.headers[_sl];

  NotifyUpdate(NotifyMessage data) : super(data, NotifyUpdate._knownKeys);
}

InternetAddress _parseHost(String s) {
  var e = s;
  if (!e.contains(':')) {
    e += ':1900';
  }

  return InternetAddress.tryParse(e)!;
}

part of 'ssdp.dart';

const _cacheControl = 'cache-control';
const _date = 'date';
const _ext = 'ext';
const _location = 'location';
const _opt = 'opt';
const _server = 'server';
const _st = 'st';
const _usn = 'usn';

const _knownKeys = [
  _cacheControl,
  _date,
  _ext,
  _location,
  _opt,
  _server,
  _st,
  _usn,
];

class Device with EquatableMixin {
  final String _raw;
  final Map<String, String> _parsed;
  final UnmodifiableMapView<String, String> _extensions;

  /// After this duration, control points should assume the device is no longer available.
  String? get cacheControl => _parsed['cache-control'];

  /// The RFC1123-date date when this response was generated.
  DateTime? get date =>
      _parsed['date'] == null ? null : HttpDate.parse(_parsed['date']!);

  /// Required for backwards compatibility with UPnP 1.0.
  String? get ext => _parsed['ext'];

  /// The URL to the UPnP description of the root device.
  Uri? get location =>
      _parsed['location'] == null ? null : Uri.parse(_parsed['location']!);

  ///
  String? get opt => _parsed['opt'];

  /// Specified by the UPnP vendor, this specifies product tokens for the device.
  String? get server => _parsed['server'];

  /// The search target. This field changes depending on the search request.
  String? get searchTarget => _parsed['st'];

  /// A unique service name for this device.
  String? get usn => _parsed['usn'];

  UnmodifiableMapView<String, String> get extensions => _extensions;

  String? extension(String key) => extensions[key.toLowerCase()];

  Device._(
    this._raw,
    this._parsed,
    Map<String, String> extensions,
  ) : _extensions = UnmodifiableMapView(extensions);

  factory Device.parse(Uint8List data) {
    final d = utf8.decode(data);
    Map<String, String> known = {};
    Map<String, String> extensions = {};

    for (var segment in d.split('\r\n')) {
      final colon = segment.indexOf(':');

      if (colon != -1) {
        final key = segment.substring(0, colon).trim().toLowerCase();
        final value = segment.substring(colon + 1).trim();

        if (_knownKeys.contains(key)) {
          known.putIfAbsent(key, () => value);
        } else {
          extensions.putIfAbsent(key, () => value);
        }
      }
    }

    return Device._(d, known, extensions);
  }

  @override
  String toString() {
    return _raw;
  }

  @override
  List<Object?> get props => [_raw];
}

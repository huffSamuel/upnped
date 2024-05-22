part of 'ssdp.dart';

class Notify with EquatableMixin {
  static String method = 'NOTIFY';

  final String _raw;
  final UnmodifiableMapView<String, String> _headers;

  Notify(this._raw, this._headers);

  /// All headers in this notification.
  UnmodifiableMapView<String, String> get headers => _headers;

  factory Notify.fromData(
    String data,
  ) {
    final headers = <String, String>{};
    for (var segment in data.split('\r\n')) {
      final colon = segment.indexOf(':');

      if (colon == -1) {
        log('warn', 'Improper header format', {
          'value': segment,
        });
        continue;
      }

      final key = segment.substring(0, colon).trim().toLowerCase().trim();
      final value = segment.substring(colon + 1).trim();

      headers[key] = value;
    }

    return Notify(
      data,
      UnmodifiableMapView(headers),
    );
  }

  @override
  String toString() => _raw;

  @override
  List<Object?> get props => [_raw];
}

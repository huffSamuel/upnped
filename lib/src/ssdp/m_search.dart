part of 'ssdp.dart';

const _unicastTemplate = '''M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
MAN: "ssdp:discover"\r
ST: %s\r
USER-AGENT: %s \r
\r
''';

const _multicastTemplate = '''M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
MAN: "ssdp:discover"\r
MX: %s\r
ST: %s\r
USER-AGENT: %s \r
\r
''';

class MSearch {
  static String method = 'M-SEARCH';

  final String message;

  const MSearch._({
    required this.message,
  });

  /// Create a multicast M-Search request.
  ///
  /// {st} is the search target. Defaults to `'upnp:rootdevice'`
  ///
  /// {mx} is the max wait time in seconds. Defaults to 5. Must be greater than 0.
  ///
  /// {userAgent} is the current user agent.
  factory MSearch.multicast(
    String userAgent, {
    String st = defaultSearchTarget,
    int mx = defaultResponseSeconds,
  }) {
    assert(mx > 0, 'mx must be greater than 0');

    return MSearch._(
      message: sprintf(
        _multicastTemplate,
        [mx.toString(), st, userAgent],
      ),
    );
  }

  /// Create a unicast M-Search request.
  ///
  /// {st} is the search target. Defaults to `'upnp:rootdevice'`.
  ///
  /// {userAgent} is the current user agent.
  factory MSearch.unicast(
    String userAgent, {
    String st = defaultSearchTarget,
  }) {
    return MSearch._(
        message: sprintf(
      _unicastTemplate,
      [st, userAgent],
    ));
  }

  List<int> encode() => utf8.encode(toString());

  @override
  String toString() {
    return message;
  }
}

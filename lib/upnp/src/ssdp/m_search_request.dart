part of ssdp;

const _multicastTemplate = '''M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
MAN: "ssdp:discover"\r
MX: %s\r
ST: %s\r
USER-AGENT: %s \r
\r
''';

class MSearchRequest {
  final String message;

  /// Search target.
  final String st;

  /// Maximum response time.
  ///
  /// Only provided for multicast requests.
  final int? mx;

  const MSearchRequest._({
    required this.message,
    required this.st,
    required this.mx,
  });

  /// Create a multicast M-Search request.
  ///
  /// {st} is the search target. Defaults to `'upnp:rootdevice'`
  ///
  /// {mx} is the max wait time in seconds. Defaults to 5. Must be greater than 0.
  ///
  /// {userAgent} is the current user agent. This value should be obtained from the
  /// {UserAgentFactory}.
  factory MSearchRequest.multicast(
    String userAgent, {
    String st = defaultSearchTarget,
    int mx = defaultResponseSeconds,
  }) {
    assert(mx > 0, 'mx must be greater than 0');

    return MSearchRequest._(
      message: sprintf(_multicastTemplate, [mx.toString(), st, userAgent]),
      st: st,
      mx: mx,
    );
  }

  List<int> encode() => utf8.encode(toString());

  @override
  String toString() {
    return message;
  }
}

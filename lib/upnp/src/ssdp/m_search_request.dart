part of ssdp;

const _multicastTemplate = '''M-SEARCH * HTTP/1.1
HOST: 239.255.255.250:1900
MAN: "ssdp:discover"
MX: %s
ST: %s
USER-AGENT: %s

''';

class MSearchRequest {
  /// Template message
  final String template;

  /// Properties to fill into the template.
  final List<String> props;

  const MSearchRequest._({
    required this.template,
    required this.props,
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
      template: _multicastTemplate,
      props: [
        mx.toString(),
        st,
        userAgent,
      ],
    );
  }

  List<int> encode() => utf8.encode(toString());

  @override
  String toString() {
    return sprintf(template, []);
  }
}

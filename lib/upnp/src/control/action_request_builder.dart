part of control;

const _soapUrn = 'urn:schemas-upnp-org:service:%s:%s';
const _soapArg = '<%s>%s</%s>';
const _soapBody =
    '''<?xml version="1.0"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:%s xmlns:u="%s">%s</u:%s></s:Body></s:Envelope>''';
const _soapActionHeader = 'SOAPAction';
const _soapHeaders = {
  HttpHeaders.contentTypeHeader: 'text/xml; charset="utf-8"'
};

class ActionRequestBuilder {
  final String? _userAgent;

  /// Create a new request builder.
  ///
  /// {userAgent} should only be provided during tests.
  const ActionRequestBuilder({String? userAgent}) : _userAgent = userAgent;

  String _args(Map<String, dynamic> args) =>
      args.keys.where((key) => args[key] != null).map((key) {
        return sprintf(_soapArg, [key, args[key].toString(), key]);
      }).join('\n');

  Uri _controlUrl(
    Uri address,
    ServiceDocument document,
  ) =>
      Uri(
        scheme: address.scheme,
        host: address.host,
        port: address.port,
        path: document.controlUrl.path,
      );

  /// Create a new `ActionRequest`.
  Future<ActionRequest> build(
    ServiceAggregate service,
    String actionName,
    Map<String, dynamic> args,
  ) async {
    final ua = _userAgent ?? await userAgent();

    final urn = sprintf(
      _soapUrn,
      [
        service.document.serviceType,
        service.document.serviceVersion,
      ],
    );

    final body = sprintf(
      _soapBody,
      [
        actionName,
        urn,
        _args(args),
        actionName,
      ],
    );

    final url = _controlUrl(service.location, service.document);

    final headers = {
      ..._soapHeaders,
      HttpHeaders.contentLengthHeader: body.length.toString(),
      HttpHeaders.hostHeader: '${url.host}:${url.port}',
      _soapActionHeader: '"$urn#$actionName"',
      HttpHeaders.userAgentHeader: ua
    };

    return ActionRequest(
      uri: url,
      headers: headers,
      body: body,
    );
  }
}

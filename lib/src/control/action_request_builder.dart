part of 'control.dart';

const _soapUrn = 'urn:schemas-upnp-org:service:%s:%s';
const _soapArg = '<%s>%s</%s>';
const _soapBody =
    '''<?xml version="1.0"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:%s xmlns:u="%s">%s</u:%s></s:Body></s:Envelope>''';
const _soapActionHeader = 'SOAPAction';
const _soapHeaders = {
  HttpHeaders.contentTypeHeader: 'text/xml; charset="utf-8"'
};

class ActionRequestBuilder {
  /// Create a new request builder.
  ///
  /// {userAgent} should only be provided during tests.
  const ActionRequestBuilder();

  String _args(Map<String, dynamic> args) =>
      args.keys.where((key) => args[key] != null).map((key) {
        return sprintf(_soapArg, [key, args[key].toString(), key]);
      }).join('\n');

  Uri _controlUrl(
    Uri address,
    String controlPath,
  ) =>
      Uri(
        scheme: address.scheme,
        host: address.host,
        port: address.port,
        path: controlPath,
      );

  /// Build a new `ActionRequest`.
  ActionRequest build(
    String userAgent,
    ActionParams params,
  ) {
    final urn = sprintf(
      _soapUrn,
      [
        params.serviceType,
        params.serviceVersion,
      ],
    );

    final body = sprintf(
      _soapBody,
      [
        params.actionName,
        urn,
        _args(params.arguments),
        params.actionName,
      ],
    );

    final url = _controlUrl(params.uri, params.controlPath);

    final headers = {
      ..._soapHeaders,
      HttpHeaders.contentLengthHeader: body.length.toString(),
      HttpHeaders.hostHeader: '${url.host}:${url.port}',
      _soapActionHeader: '"$urn#${params.actionName}"',
      HttpHeaders.userAgentHeader: userAgent,
    };

    return ActionRequest(
      uri: url,
      headers: headers,
      body: body,
    );
  }
}

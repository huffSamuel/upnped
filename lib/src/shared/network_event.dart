part of 'shared.dart';

enum NetworkEventProtocol {
  ssdp,
  http,
  soap,
}

enum NetworkEventDirection {
  incoming,
  outgoing,
}

/// A network event that occurred as part of UPnP discovery or control.
abstract class NetworkEvent {
  /// Content contained in this network event.
  final String content;

  /// Direction of the event.
  final NetworkEventDirection direction;

  /// Network protocol that triggered the event.
  final NetworkEventProtocol protocol;

  /// Time when this event was sent or received.
  final DateTime time;

  /// The type of the message.
  final String type;

  /// Host where this message originated.
  final String? from;

  /// Host where this message was sent.
  final String? to;

  NetworkEvent({
    required this.direction,
    required this.protocol,
    required this.type,
    required this.content,
    this.from,
    this.to,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  // TODO: This is part of the public API now for retrieving the content. That needs to be deprecated and removed in a future release.
  @override
  String toString() {
    return content;
  }
}

/// An M-SEARCH event that occurred as part of UPnP discovery.
class MSearchEvent extends NetworkEvent {
  MSearchEvent({
    required super.content,
    super.direction = NetworkEventDirection.outgoing,
    super.from = '127.0.0.1',
    super.time,
  }) : super(
          protocol: NetworkEventProtocol.ssdp,
          type: 'M-SEARCH',
        );
}

/// A NOTIFY event that occurred as part of UPnP discovery.
class NotifyEvent extends NetworkEvent {
  /// URI where this event originated from.
  final Uri uri;

  NotifyEvent(
    this.uri, {
    required super.content,
    super.time,
  }) : super(
          direction: NetworkEventDirection.incoming,
          protocol: NetworkEventProtocol.ssdp,
          type: 'NOTIFY',
          from: uri.host,
        );
}

/// An HTTP event that occurred as part of UPnP discovery or control.
class HttpEvent extends NetworkEvent {
  /// HTTP response object.
  final http.Response response;

  /// HTTP request object.
  http.Request get request => response.request! as http.Request;

  String? _body;

  /// The formatted response body.
  String get responseBody =>
      _body ??= XmlDocument.parse(response.body).toXmlString(pretty: true);

  HttpEvent(
    this.response, {
    super.time,
  }) : super(
          direction: NetworkEventDirection.outgoing,
          protocol: NetworkEventProtocol.http,
          type: 'HTTP ${response.request!.method}',
          from: '127.0.0.1',
          to: response.request!.url.host,
          content: _resolveHttpEventContent(response),
        );
}

String _resolveHttpEventContent(http.Response response) {
  var sb = StringBuffer('HTTP/1.1 ${response.statusCode}\n');
  response.headers.forEach((k, v) => sb.writeln('$k: $v'));
  sb.writeln(response.body);
  return sb.toString();
}

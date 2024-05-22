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
    this.from,
    this.to,
  }) : time = DateTime.now();
}

/// An M-SEARCH event that occurred as part of UPnP discovery.
class MSearchEvent extends NetworkEvent {
  /// Raw content of the M-SEARCH event.
  final String content;

  MSearchEvent(
    this.content, {
    super.direction = NetworkEventDirection.outgoing,
    super.from = '127.0.0.1',
  }) : super(
          protocol: NetworkEventProtocol.ssdp,
          type: 'M-SEARCH',
        );

  @override
  toString() {
    return content;
  }
}

/// A NOTIFY event that occurred as part of UPnP discovery.
class NotifyEvent extends NetworkEvent {
  /// Raw content of the NOTIFY event.
  final String content;

  /// URI where this event originated from.
  final Uri uri;

  NotifyEvent(this.uri, this.content)
      : super(
          direction: NetworkEventDirection.incoming,
          protocol: NetworkEventProtocol.ssdp,
          type: 'NOTIFY',
          from: uri.host,
        );

  @override
  toString() {
    return content;
  }
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
    this.response,
  ) : super(
          direction: NetworkEventDirection.outgoing,
          protocol: NetworkEventProtocol.http,
          type: 'HTTP ${response.request!.method}',
          from: '127.0.0.1',
          to: response.request!.url.host,
        );

  @override
  toString() {
    var sb = StringBuffer('HTTP/1.1 ${response.statusCode}\n');
    response.headers.forEach((k, v) => sb.writeln('$k: $v'));
    sb.writeln(response.body);
    return sb.toString();
  }
}

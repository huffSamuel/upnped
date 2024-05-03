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

abstract class NetworkEvent {
  final NetworkEventDirection direction;
  final NetworkEventProtocol protocol;
  final DateTime time;
  final String messageType;
  final String? from;
  final String? to;

  NetworkEvent({
    required this.direction,
    required this.protocol,
    required this.messageType,
    this.from,
    this.to,
  }) : time = DateTime.now();
}

class MSearchEvent extends NetworkEvent {
  final String content;

  MSearchEvent(this.content)
      : super(
          direction: NetworkEventDirection.outgoing,
          protocol: NetworkEventProtocol.ssdp,
          messageType: 'M-SEARCH',
          from: '127.0.0.1',
        );

  @override
  toString() {
    return content;
  }
}

class NotifyEvent extends NetworkEvent {
  final String content;
  final Uri uri;

  NotifyEvent(this.uri, this.content)
      : super(
          direction: NetworkEventDirection.incoming,
          protocol: NetworkEventProtocol.ssdp,
          messageType: 'NOTIFY',
          from: uri.host,
        );

  @override
  toString() {
    return content;
  }
}

class HttpEvent extends NetworkEvent {
  final http.Response response;
  http.Request get request => response.request! as http.Request;

  String? _body;

  String get responseBody =>
      _body ??= XmlDocument.parse(response.body).toXmlString(pretty: true);

  HttpEvent(
    this.response,
  ) : super(
          direction: NetworkEventDirection.outgoing,
          protocol: NetworkEventProtocol.http,
          messageType: 'HTTP ${response.request!.method}',
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

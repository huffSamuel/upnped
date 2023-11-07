part of upnp;

enum MessageProtocol {
  ssdp,
  http,
  soap,
}

enum MessageDirection {
  incoming,
  outgoing,
}

abstract class NetworkEvent {
  final MessageDirection direction;
  final MessageProtocol protocol;
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
          direction: MessageDirection.outgoing,
          protocol: MessageProtocol.ssdp,
          messageType: 'M-SEARCH',
          from: '0.0.0.0',
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
          direction: MessageDirection.incoming,
          protocol: MessageProtocol.ssdp,
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

  HttpEvent(
    this.response,
  ) : super(
          direction: MessageDirection.outgoing,
          protocol: MessageProtocol.http,
          messageType: 'HTTP ${response.request!.method}',
          from: '0.0.0.0',
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

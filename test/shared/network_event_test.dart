import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:test/test.dart';
import 'package:upnped/src/shared/shared.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  MockSpec<http.Response>(),
  MockSpec<http.Request>(),
])
import 'network_event_test.mocks.dart';

void main() {
  group('MSearchEvent', () {
    group('constructor', () {
      test('should set the default properties', () {
        final event = MSearchEvent('content');

        expect(event.direction, equals(NetworkEventDirection.outgoing));
        expect(event.protocol, equals(NetworkEventProtocol.ssdp));
        expect(event.messageType, equals('M-SEARCH'));
        expect(event.from, equals('127.0.0.1'));
      });
    });

    group('toString', () {
      test('should return content', () {
        const expected = 'content';
        final event = MSearchEvent(expected);

        final actual = event.toString();
        expect(actual, equals(expected));
      });
    });
  });

  group('NotifyEvent', () {
    group('constructor', () {
      test('should set the default properties', () {
        final event = NotifyEvent(Uri(host: 'test.com'), 'content');

        expect(event.direction, equals(NetworkEventDirection.incoming));
        expect(event.protocol, NetworkEventProtocol.ssdp);
        expect(event.messageType, 'NOTIFY');
        expect(event.from, 'test.com');
      });
    });

    group('toString', () {
      test('should return content', () {
        const expected = 'content';
        final event = NotifyEvent(Uri(host: 'test.com'), 'content');

        final actual = event.toString();
        expect(actual, equals(expected));
      });
    });
  });
  group('HttpEvent', () {
    group('constructor', () {
      test('should assign default properties', () {
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('GET');

        final mockResponse = MockResponse();
        when(mockResponse.request).thenReturn(mockRequest);

        final event = HttpEvent(mockResponse);

        expect(event.direction, equals(NetworkEventDirection.outgoing));
        expect(event.protocol, NetworkEventProtocol.http);
        expect(event.messageType, equals('HTTP GET'));
        expect(event.from, equals('127.0.0.1'));
        expect(event.to, equals('test.com'));
      });
    });

    group('responseBody', () {
      test('should return the response body', () {
        const expected = '<foo></foo>';
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('GET');

        final mockResponse = MockResponse();
        when(mockResponse.request).thenReturn(mockRequest);
        when(mockResponse.body).thenReturn('<foo></foo>');

        final event = HttpEvent(mockResponse);

        final actual = event.responseBody;

        expect(actual, equals(expected));
      });
    });

    group('request', () {
      test('should return the responses request', () {
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('GET');

        final mockResponse = MockResponse();
        when(mockResponse.request).thenReturn(mockRequest);

        final event = HttpEvent(mockResponse);

        final actual = event.request;

        expect(actual, equals(mockRequest));
      });
    });

    group('toString', () {
      test('should build from response', () {
        const expected = '''HTTP/1.1 200
CACHE-CONTROL: nocache
body
''';
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('GET');

        final mockResponse = MockResponse();
        when(mockResponse.request).thenReturn(mockRequest);
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.headers).thenReturn({'CACHE-CONTROL': 'nocache'});
        when(mockResponse.body).thenReturn('body');

        final event = HttpEvent(mockResponse);

        final actual = event.toString();

        expect(actual, equals(expected));
      });
    });
  });
}

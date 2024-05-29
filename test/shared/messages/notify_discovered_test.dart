import 'package:test/test.dart';
import 'package:upnped/src/shared/messages.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const message = '''HTTP/1.1 200 OK\r
CACHE-CONTROL: max-age=1800\r
EXT: \r
LOCATION: http://192.168.0.141:52323/dmr.xml\r
SERVER: Linux/3.10 UPnP/1.0 Sony-HTS/2.0\r
ST: upnp:rootdevice\r
USN: uuid:00000000-0000-1010-8000-104fa8f65fab::upnp:rootdevice\r
Date: Thu, 23 May 2024 05:28:01 GMT\r
SEARCHPORT.UPNP.ORG: 1800\r
X-AV-Physical-Unit-Info: pa="HT-CT790";\r
X-AV-Server-Info: av=5.0; cn="Sony Corporation"; mn="HT-CT790"; mv="2.0";\r
''';

void main() {
  group('NotifyDiscovered', () {
    late NotifyDiscovered n;

    setUp(() {
      n = NotifyDiscovered(Notify.parse(message));
    });

    test('cacheControl', () => expect(n.cacheControl, equals('max-age=1800')));
    test('date', () => expect(n.date, DateTime.utc(2024, 5, 23, 5, 28, 01)));
    test('ext', () => expect(n.ext, ''));
    test(
        'location',
        () => expect(
            n.location, Uri.parse('http://192.168.0.141:52323/dmr.xml')));
    test('server', () => expect(n.server, 'Linux/3.10 UPnP/1.0 Sony-HTS/2.0'));
    test('st', () => expect(n.st, 'upnp:rootdevice'));
    test('searchPort', () => expect(n.searchPort, 1800));
    test('secureLocation', () => expect(n.secureLocation, null));
    test('extension',
        () => expect(n.extension('X-AV-Physical-Unit-Info'), 'pa="HT-CT790";'));
  });
}

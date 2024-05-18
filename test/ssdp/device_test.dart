import 'dart:convert';

import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const notify =
    '''CACHE-CONTROL: max-age=1800\r\nEXT: \r\nLOCATION: http://192.168.0.135:64321/bar-cl3-ms.xml\r\nSERVER: Linux/3.10 UPnP/1.0 Sony-BDV/2.0\r\nST: upnp:rootdevice\r\nUSN: uuid:00000001-0000-1010-8000-104fa8f65fab::upnp:rootdevice\r\nDate: Thu, 09 May 2024 04:32:57 GMT\r\nX-AV-Physical-Unit-Info: pa="HT-CT790"; pl=;\r\nX-AV-Server-Info: av=5.0; hn=""; cn="Sony Corporation"; mn="HT-CT-790"; mv="2.0";\r\n''';

void main() {
  group('device', () {
    group('toString', () {
      test('should return expected string', () {
        final device = Notify.parse(utf8.encode(notify));

        expect(device.toString(), equals(notify));
      });
    });

    group('extensions', () {
      test('should return expected map', () {
        final expected = {
          'x-av-physical-unit-info': 'pa="HT-CT790"; pl=;',
          'x-av-server-info':
              'av=5.0; hn=""; cn="Sony Corporation"; mn="HT-CT-790"; mv="2.0";',
        };
        final device = Notify.parse(utf8.encode(notify));

        expect(device.extensions, equals(expected));
      });
    });

    group('props', () {
      test('should return the expected properties', () {
        final device = Notify.parse(utf8.encode(notify));

        expect(device.props, equals([notify]));
      });
    });

    group('parse', () {
      test('should set the expected properties', () {
        final device = Notify.parse(utf8.encode(notify));

        expect(device.cacheControl, equals('max-age=1800'));
        expect(device.date, equals(DateTime.parse('2024-05-09T04:32:57.000Z')));
        expect(device.ext, equals(''));
        expect(
          device.location,
          equals(Uri.parse('http://192.168.0.135:64321/bar-cl3-ms.xml')),
        );
        expect(device.opt, equals(null));
        expect(device.server, equals('Linux/3.10 UPnP/1.0 Sony-BDV/2.0'));
        expect(device.searchTarget, equals('upnp:rootdevice'));
        expect(
          device.usn,
          equals('uuid:00000001-0000-1010-8000-104fa8f65fab::upnp:rootdevice'),
        );
      });
    });
  });
}

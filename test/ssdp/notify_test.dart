import 'dart:collection';

import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const notify = '''NOTIFY * HTTP/1.1
HOST: 239.255.255.250:1900
CACHE-CONTROL: max-age=60
LOCATION: http://192.168.0.1:1900/dryjn/rootDesc.xml
SERVER: TP-LINK/TP-LINK UPnP/1.1 MiniUPnPd/1.8
NT: upnp:rootdevice
USN: uuid:48850ab7-3751-43a2-bbed-a636733f99dd::upnp:rootdevice
NTS: ssdp:alive
OPT: "http://schemas.upnp.org/upnp/1/0/"; ns=01
01-NLS: 1
BOOTID.UPNP.ORG: 1
CONFIGID.UPNP.ORG: 1337
''';

final expectedHeaders = UnmodifiableMapView({
  'host': '239.255.255.250:1900',
  'cache-control': 'max-age=60',
  'location': 'http://192.168.0.1:1900/dryjn/rootDesc.xml',
  'server': 'TP-LINK/TP-LINK UPnP/1.1 MiniUPnPd/1.8',
  'nt': 'upnp:rootdevice',
  'usn': 'uuid:48850ab7-3751-43a2-bbed-a636733f99dd::upnp:rootdevice',
  'nts': 'ssdp:alive',
  'opt': '"http://schemas.upnp.org/upnp/1/0/"; ns=01',
  '01-nls': '1',
  'bootid.upnp.org': '1',
  'configid.upnp.org': '1337'
});

void main() {
  group('parse', () {
    test('should create the expected object', () {
      final expected = Notify(notify, expectedHeaders);

      final actual = Notify.parse(notify);

      expect(actual, equals(expected));
    });

    group('headers', () {
      test('should return the expected map', () {
        final n = Notify(notify, expectedHeaders);

        expect(n.headers, equals(expectedHeaders));
      });
    });

    group('toString', () {
      test('should return the message', () {
        final n = Notify(notify, expectedHeaders);

        expect(n.toString(), equals(notify));
      });
    });
  });
}

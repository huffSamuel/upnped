import 'dart:io';

import 'package:test/test.dart';
import 'package:upnped/src/shared/messages.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const message = '''NOTIFY * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
CACHE-CONTROL: max-age=60\r
LOCATION: http://192.168.0.1:1900/dryjn/rootDesc.xml\r
SERVER: TP-LINK/TP-LINK UPnP/1.1 MiniUPnPd/1.8\r
NT: upnp:rootdevice\r
USN: uuid:48850ab7-3751-43a2-bbed-a636733f99dd::upnp:rootdevice\r
NTS: ssdp:alive\r
OPT: "http://schemas.upnp.org/upnp/1/0/"; ns=01\r
01-NLS: 1\r
BOOTID.UPNP.ORG: 1\r
CONFIGID.UPNP.ORG: 1337\r
''';

final notify = Notify.parse(message);

void main() {
  late NotifyAlive o;

  group('NotifyAlive', () {
    setUp(() {
      o = NotifyAlive(notify);
    });

    test('host', () {
      final expected = InternetAddressAndPort(
        address: InternetAddress('239.255.255.250'),
        port: '1900',
      );

      expect(o.host, equals(expected));
    });

    test('cacheControl', () => expect(o.cacheControl, equals('max-age=60')));
    test(
        'location',
        () => expect(
            o.location,
            equals(Uri(
              scheme: 'http',
              host: '192.168.0.1',
              port: 1900,
              path: 'dryjn/rootDesc.xml',
            ))));
    test('nt', () => expect(o.nt, equals('upnp:rootdevice')));
    test(
        'server',
        () =>
            expect(o.server, equals('TP-LINK/TP-LINK UPnP/1.1 MiniUPnPd/1.8')));
    test('searchPort', () => expect(o.searchPort, equals(null)));
    test('secureLocation', () => expect(o.secureLocation, equals(null)));
  });
}

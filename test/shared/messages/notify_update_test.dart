import 'dart:io';

import 'package:test/test.dart';
import 'package:upnped/src/shared/messages.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const message = '''HTTP/1.1 200 OK\r
CACHE-CONTROL: max-age=1800\r
EXT: \r
LOCATION: http://192.168.0.141:52323/dmr.xml\r
HOST: 239.255.255.250:1900\r
SERVER: Linux/3.10 UPnP/1.0 Sony-HTS/2.0\r
ST: upnp:rootdevice\r
NTS: ssdp:update\r
NT: upnp:rootdevice\r
USN: uuid:00000000-0000-1010-8000-104fa8f65fab::upnp:rootdevice\r
Date: Thu, 23 May 2024 05:28:01 GMT\r
NEXTBOOTID.UPNP.ORG: 2\r
X-AV-Physical-Unit-Info: pa="HT-CT790";\r
X-AV-Server-Info: av=5.0; cn="Sony Corporation"; mn="HT-CT790"; mv="2.0";\r
''';

void main() {
  group('NotifyUpdate', () {
    late NotifyUpdate n;

    setUp(() {
      n = NotifyUpdate(Notify.parse(message));
    });

    test(
        'host',
        () => expect(
            n.host,
            equals(InternetAddressAndPort(
                address: InternetAddress('239.255.255.250'), port: '1900'))));

    test(
        'location',
        () => expect(
            n.location, Uri.parse('http://192.168.0.141:52323/dmr.xml')));

    test('nt', () => expect(n.nt, equals('upnp:rootdevice')));
    test('nextBootId', () => expect(n.nextBootId, 2));
    test('searchPort', () => expect(n.searchPort, null));
    test('secureLocation', () => expect(n.secureLocation, null));
  });
}

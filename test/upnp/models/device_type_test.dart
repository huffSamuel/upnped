import 'package:test/test.dart';
import 'package:upnped/upnped.dart';

void main() {
  group('DeviceType', () {
    late DeviceType d;

    setUp(() {
      d = DeviceType(uri: 'urn:schemas-upnp-org:device:MediaRenderer:1');
    });

    test('domainName', () => expect(d.domainName, equals('schemas-upnp-org')));
    test('deviceType', () => expect(d.deviceType, equals('MediaRenderer')));
    test('version', () => expect(d.version, equals(1)));
  });
}

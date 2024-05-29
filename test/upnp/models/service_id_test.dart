import 'package:test/test.dart';
import 'package:upnped/upnped.dart';

void main() {
  group('ServiceId', () {
    test('parse', () {
      final actual = ServiceId.parse('urn:schemas-sony-com:serviceId:MultiChannel');

      expect(actual.domain, equals('schemas-sony-com'));
      expect(actual.serviceId, equals('MultiChannel'));
    });
  });
}
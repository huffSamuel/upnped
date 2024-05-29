import 'package:test/test.dart';
import 'package:upnped/upnped.dart';

void main() {
  group('Options', () {
    group('constructor', () {
      test('should assign expected defaults', () {
        final actual = Options();

        expect(actual.locale, equals('en'));
        expect(actual.multicastHops, equals(1));
      });
    });
  });
}
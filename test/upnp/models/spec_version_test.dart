import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<specVersion>
    <major>1</major>
    <minor>0</minor>
  </specVersion>''';

void main() {
  group('SpecVersion', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = SpecVersion.fromXml(doc.getElement('specVersion')!);

      expect(actual.major, equals(1));
      expect(actual.minor, equals(0));
    });
  });
}

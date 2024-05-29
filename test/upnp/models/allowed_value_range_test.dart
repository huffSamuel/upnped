import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<allowedValueRange>
        <minimum>0</minimum>
        <maximum>100</maximum>
        <step>1</step>
      </allowedValueRange>''';

void main() {
  group('AllowedValueRange', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final allowedValueRange = AllowedValueRange.fromXml(
          doc.getElement('allowedValueRange') as XmlNode);

      expect(allowedValueRange.maximum, equals('100'));
      expect(allowedValueRange.minimum, equals('0'));
      expect(allowedValueRange.step, equals(1));
    });
  });
}

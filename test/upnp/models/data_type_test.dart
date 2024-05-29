import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<dataType>string</dataType>
''';

void main() {
  group('DataType', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final dt = DataType.fromXml(doc.root.getElement('dataType') as XmlNode);

      expect(dt.type, equals(DataTypeValue.string));
    });
  });
}

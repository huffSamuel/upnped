import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<serviceStateTable>
    <stateVariable sendEvents="yes">
      <name>DefaultConnectionService</name>
      <dataType>string</dataType>
    </stateVariable>
  </serviceStateTable>''';

void main() {
  group('ServiceStateTable', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = ServiceStateTable.fromXml(doc.getElement('serviceStateTable')!);

      expect(actual.stateVariables, hasLength(1));
    });
  });
}
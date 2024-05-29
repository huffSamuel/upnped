import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<stateVariable sendEvents="yes">
      <name>DefaultConnectionService</name>
      <dataType>string</dataType>
    </stateVariable>''';

void main() {
  group('StateVariable', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = StateVariable.fromXml(doc.getElement('stateVariable')!);

      expect(actual.sendEvents, equals(true));
      expect(actual.multicast, false);
      expect(actual.name, equals('DefaultConnectionService'));
      expect(actual.dataType, isNotNull);
      expect(actual.defaultValue, isNull);
      expect(actual.allowedValues, []);
      expect(actual.allowedValueRange, isNull);
    });
  });
}

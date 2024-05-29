import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<action>
      <name>SetDefaultConnectionService</name>
      <argumentList>
        <argument>
          <name>NewDefaultConnectionService</name>
          <direction>in</direction>
          <relatedStateVariable>DefaultConnectionService</relatedStateVariable>
        </argument>
      </argumentList>
    </action>''';

void main() {
  group('Action', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = Action.fromXml(doc.root.getElement('action') as XmlNode);

      expect(actual.name, equals('SetDefaultConnectionService'));
      expect(actual.arguments, isNotNull);
      expect(actual.arguments, hasLength(1));
    });
  });
}
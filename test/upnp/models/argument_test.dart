import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<argument>
          <name>NewDefaultConnectionService</name>
          <direction>in</direction>
          <relatedStateVariable>DefaultConnectionService</relatedStateVariable>
        </argument>''';

void main() {
  group('Argument', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final arg = Argument.fromXml(doc.root.getElement('argument') as XmlNode);

      expect(arg.direction, equals(Direction.input));
      expect(arg.name, equals('NewDefaultConnectionService'));
      expect(arg.relatedStateVariable, equals('DefaultConnectionService'));
    });
  });
}
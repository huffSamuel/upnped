import 'package:test/test.dart';
import 'package:fl_upnp/upnp/control_point.dart';
import 'package:xml/xml.dart';

void main() {
  group('parse', () {

    test('parses responses', () {
      const expected = ActionResponse('Action', {
        'Foo': '42'
      });

      const input =
          '<s:Envelope><s:Body><u:ActionResponse><Foo>42</Foo></u:ActionResponse></s:Body></s:Envelope>';
      final xml = XmlDocument.parse(input);
      final actual = ActionResponse.fromXml(xml);

      expect(actual, equals(expected));
    });
  });
}

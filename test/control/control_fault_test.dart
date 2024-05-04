import 'package:test/test.dart';
import 'package:upnped/src/control/control.dart';
import 'package:xml/xml.dart';

import 'responses.dart';

void main() {
  group('ControlFault', () {
    group('parse()', () {
      test('parses faults', () {
        const expected = ActionFault('404', 'an error');

        const input = faultResponse;
        final actual = ActionFault.parse(input);

        expect(actual, equals(expected));
      });
    });
  });

  group('isFault()', () {
    group('when fault', () {
      test('should return "true"', () {
        const expected = true;
        const input = faultResponse;
        final xml = XmlDocument.parse(input);

        final actual = isFault(xml);

        expect(actual, equals(expected));
      });
    });

    group('when not a fault', () {
      test('should return "false"', () {
        const expected = false;
        const input =
            '<s:Envelope><s:Body><u:ActionResponse></u:ActionResponse></s:Body></s:Envelope>';
        final xml = XmlDocument.parse(input);

        final actual = isFault(xml);

        expect(actual, equals(expected));
      });
    });
  });
}

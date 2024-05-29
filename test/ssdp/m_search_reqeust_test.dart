import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

void main() {
  group('MSearchRequest', () {
    group('multicast', () {
      group('toString()', () {
        test('should create expected request', () {
          const expected =
              'M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: "ssdp:discover"\r\nMX: 1\r\nST: searchTarget\r\nUSER-AGENT: test/1.0 \r\n\r\n';

          final request = MSearch.multicast(
            'test/1.0',
            st: 'searchTarget',
            mx: 1,
          );

          final actual = request.toString();

          expect(actual, equals(expected));
        });
      });
    });

    group('unicast', () {
      group('toString()', () {
        test('should create the expected request', () {
          const expected =
              'M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: "ssdp:discover"\r\nST: searchTarget\r\nUSER-AGENT: test/1.0 \r\n\r\n';

          final request = MSearch.unicast('test/1.0', st: 'searchTarget');

          final actual = request.toString();

          expect(actual, equals(expected));
        });
      });
    });
  });
}

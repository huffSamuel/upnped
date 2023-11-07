import 'package:fl_upnp/upnp/ssdp.dart';
import 'package:test/test.dart';

void main() {
  group('MSearchRequest', () {
    group('multicast', () {
      group('factory', () {
        test('construct with default parameters', () {
          const expectedMx = 5;
          const expectedSt = 'upnp:rootdevice';

          final request = MSearchRequest.multicast('userAgent');

          expect(request.mx, equals(expectedMx));
          expect(request.st, equals(expectedSt));
        });

        test('construct with parameters', () {
          const expectedMx = 3;
          const expectedSt = 'searchTarget';

          final request = MSearchRequest.multicast(
            'userAgent',
            mx: 3,
            st: 'searchTarget',
          );

          expect(request.mx, equals(expectedMx));
          expect(request.st, equals(expectedSt));
        });
      });
      group('toString()', () {
        test('should create expected request', () {
          const expected =
              'M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: "ssdp:discover"\r\nMX: 1\r\nST: searchTarget\r\nUSER-AGENT: test/1.0 \r\n\r\n';

          final request = MSearchRequest.multicast(
            'test/1.0',
            st: 'searchTarget',
            mx: 1,
          );

          final actual = request.toString();

          expect(actual, equals(expected));
        });
      });
    });
  });
}

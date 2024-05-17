import "package:test/test.dart";
import "package:upnped/upnped.dart";

void main() {
    group("SearchTarget", () {
        group("device", () {
            test('should create expected string', () {
                const uuid = 'foo';
                const expected = 'uuid:foo';

                final actual = SearchTarget.device(uuid);

                expect(actual, equals(expected));
                });
            });
        group("deviceType", () {
            test('should create expected string', () {
                const deviceType = 'foo';
                const version = '1';
                const expected = 'urn:schemas-upnp-org:device:foo:1';

                final actual = SearchTarget.deviceType(deviceType, version);

                expect(actual, equals(expected));

            });
        });

        group('serviceType', () {
            test('should create expected string', () {
                const serviceType = 'foo';
                const version = '1';
                const expected = 'urn:schemas-upnp-org:service:foo:1';

                final actual = SearchTarget.serviceType(serviceType, version);

                expect(actual, equals(expected));
            });
        });

        group('vendorDomain', () {
                final cases = [VendorTestCase(
                        domain: 'foo',
                        type: 'bar',
                        version: '1',
                        expected: 'urn:foo:device:bar:1'
                        ), VendorTestCase(domain: 'test.com', type: 'bar', version: '1', expected: 'urn:test-com:device:bar:1',),];

                for(final tc in cases) {

                test('should create expected string', () {
                        final actual = SearchTarget.vendorDomain(tc.domain, tc.type, tc.version);

                        expect(actual, equals(tc.expected));
                        });
                }
                });

        group('vendorService', () {
            final cases = [
                VendorTestCase(
                    domain: 'foo',
                    type: 'bar',
                    version: '1',
                    expected: 'urn:foo:service:bar:1',
                    ), 
                VendorTestCase(
                    domain: 'test.com',
                    type: 'bar',
                    version: '1',
                    expected: 'urn:test-com:service:bar:1',
                )];

                    for(final tc in cases) {
            test('should create expected string', () {
                    final actual = SearchTarget.vendorService(tc.domain, tc.type, tc.version);

                expect(actual, equals(tc.expected));
            }); 
                    }
        });
    });
}

class VendorTestCase {
    final String domain;
    final String type;
    final String version;
    final String expected;

    VendorTestCase({
        required this.domain,
        required this.type,
        required this.version,
        required this.expected,
    });
}

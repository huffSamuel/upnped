import 'package:test/test.dart';
import 'package:fl_upnp/upnp/control.dart';

void main() {
  group('ActionRequestBuilder', () {
    late ActionRequestBuilder builder;

    setUp(() {
      builder = const ActionRequestBuilder(userAgent: 'test/1.0');
    });

    group('build()', () {
      setUp(() {});

      test('should create an ActionRequest', () async {
        final params = ActionRequestParams(
          actionName: 'action',
          serviceType: 'type',
          serviceVersion: '1',
          uri: Uri(),
          controlPath: 'path',
          arguments: {},
        );

        final actual = builder.build(params);

        expect(actual, isA<ActionRequest>());
      });

      test('should return the expected ActionRequest', () async {
        final params = ActionRequestParams(
          actionName: 'action',
          serviceType: 'type',
          serviceVersion: 'version',
          uri: Uri.parse('http://www.upnp.org:4200'),
          controlPath: 'control',
          arguments: {},
        );

        final expected = ActionRequest(
          uri: Uri.parse('http://www.upnp.org:4200/control'),
          headers: {
            'content-type': 'text/xml; charset="utf-8"',
            'content-length': '248',
            'host': 'www.upnp.org:4200',
            'SOAPAction': '"urn:schemas-upnp-org:service:type:version#action"',
            'user-agent': 'test/1.0'
          },
          body:
              '<?xml version="1.0"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:action xmlns:u="urn:schemas-upnp-org:service:type:version"></u:action></s:Body></s:Envelope>',
        );

        final actual = builder.build(params);

        expect(actual.hashCode, equals(expected.hashCode));
      });
    });
  });
}

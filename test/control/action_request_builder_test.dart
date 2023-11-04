import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:fl_upnp/upnp/control_point.dart';
import 'package:fl_upnp/upnp/upnp.dart';

@GenerateNiceMocks([
  MockSpec<ServiceAggregate>(),
  MockSpec<ServiceDocument>(),
])
import 'action_request_builder_test.mocks.dart';

void main() {
  group('ActionRequestBuilder', () {
    late MockServiceAggregate mockAggregate;
    late MockServiceDocument mockDocument;
    late ActionRequestBuilder builder;

    setUp(() {
      builder = const ActionRequestBuilder(userAgent: 'test/1.0');
      mockAggregate = MockServiceAggregate();
      mockDocument = MockServiceDocument();

      when(mockAggregate.document).thenReturn(mockDocument);
    });

    group('build()', () {
      setUp(() {
        when(mockDocument.serviceType).thenReturn('type');
        when(mockDocument.serviceVersion).thenReturn('version');
        when(mockDocument.controlUrl).thenReturn(Uri(path: '/control'));
        when(mockAggregate.location)
            .thenReturn(Uri.parse('http://www.upnp.org:4200'));
      });

      test('should create an ActionRequest', () async {
        final actual = await builder.build(mockAggregate, 'action', {});

        expect(actual, isA<ActionRequest>());
      });

      test('should return the expected ActionRequest', () async {
        final expected = ActionRequest(
          uri: Uri.parse('http://www.upnp.org:4200/control'),
          headers: {
            'content-type': 'text/xml; charset="utf-8"',
            'content-length': '248',
            'host': 'www.upnp.org:4200',
            'SOAPAction': '"urn:schemas-upnp-org:service:type:version#action"',
            'user-agent': 'test/1.0'
          },
          body: '<?xml version="1.0"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:action xmlns:u="urn:schemas-upnp-org:service:type:version"></u:action></s:Body></s:Envelope>',
        );

        final actual = await builder.build(mockAggregate, 'action', {});

        expect(actual.hashCode, equals(expected.hashCode));
      });
    });
  });
}

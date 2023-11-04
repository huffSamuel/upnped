import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:fl_upnp/upnp/control_point.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
])
import 'control_point_test.mocks.dart';
import 'responses.dart';

void main() {
  group('ControlPoint', () {
    late MockClient mockClient;
    late ControlPoint controlPoint;

    setUp(() {
      mockClient = MockClient();
      controlPoint = ControlPoint(client: mockClient);
    });

    group('invoke()', () {
      late MockResponse mockResponse;

      setUp(() {
        mockResponse = MockResponse();
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow('');
      });

      test('makes the expected request', () async {
        final req = ActionRequest(
          uri: Uri.parse('http://www.upnp.org:4200/control'),
          headers: {},
          body: 'hello, world',
        );

        try {
          await controlPoint.invoke(req);
        } catch (_) {}

        verify(
          mockClient.post(
            req.uri,
            headers: argThat(equals(req.headers), named: 'headers'),
            body: argThat(equals(req.body), named: 'body'),
          ),
        );
      });

      group('when response is a fault', () {
        setUp(() {
          when(mockResponse.body).thenReturn(faultResponse);
          reset(mockClient);
          when(mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          )).thenAnswer(
            (_) async => mockResponse,
          );
        });

        test('throws a ControlError', () async {
          final req = ActionRequest(
            uri: Uri.parse('http://www.upnp.org:4200/control'),
            headers: {},
            body: 'hello, world',
          );

          expect(() => controlPoint.invoke(req), throwsA(isA<ControlError>()));
        });
      });

      group('when response is success', () {
        setUp(() {
          when(mockResponse.body).thenReturn(successResponse);
          reset(mockClient);
          when(mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          )).thenAnswer(
            (_) async => mockResponse,
          );
        });

        test('returns an ActionResponse', () async {
          final req = ActionRequest(
            uri: Uri.parse('http://www.upnp.org:4200/control'),
            headers: {},
            body: 'hello, world',
          );

          final actual = await controlPoint.invoke(req);

          expect(actual, isA<ActionResponse>());
        });
      });
    });
  });
}

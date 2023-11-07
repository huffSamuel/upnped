import 'package:fl_upnp/upnp/shared.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:fl_upnp/upnp/control.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
  MockSpec<ActionRequestBuilder>(),
  MockSpec<UserAgentFactory>(),
])
import 'control_point_test.mocks.dart';
import 'responses.dart';

void main() {
  group('ControlPoint', () {
    late MockClient mockClient;
    late ControlPoint controlPoint;
    late MockActionRequestBuilder mockBuilder;
    late MockUserAgentFactory mockUserAgentFactory;

    final params = ActionRequestParams(
      actionName: 'action',
      serviceType: 'test',
      serviceVersion: '1',
      uri: Uri.parse('http://www.upnp.org:4200'),
      controlPath: 'control',
      arguments: {},
    );

    setUp(() {
      mockClient = MockClient();
      mockBuilder = MockActionRequestBuilder();
      mockUserAgentFactory = MockUserAgentFactory();
      controlPoint = ControlPoint.forTest(
        client: mockClient,
        builder: mockBuilder,
        userAgentFactory: mockUserAgentFactory,
      );

      when(mockUserAgentFactory.create()).thenAnswer(
        (realInvocation) => Future.value('userAgent'),
      );
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

      test('calls the request builder', () async {
        when(mockBuilder.build(any)).thenThrow('');

        try {
          await controlPoint.invoke(params);
        } catch (_) {}

        verify(mockBuilder.build(any));
      });

      test('makes the expected request', () async {
        final expected = ActionRequest(
          uri: Uri.parse('http://www.upnp.org:4200'),
          headers: {},
          body: '',
        );

        when(mockBuilder.build(any)).thenReturn(expected);

        try {
          await controlPoint.invoke(params);
        } catch (_) {}

        verify(mockClient.post(
          expected.uri,
          headers: argThat(equals(expected.headers), named: 'headers'),
          body: argThat(equals(expected.body), named: 'body'),
        ));
      });

      group('when response is a fault', () {
        setUp(() {
          when(mockBuilder.build(any)).thenReturn(ActionRequest(
            body: '',
            headers: {},
            uri: Uri(),
          ));
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
          expect(
              () => controlPoint.invoke(params), throwsA(isA<ControlError>()));
        });
      });

      group('when response is success', () {
        setUp(() {
          when(mockBuilder.build(any)).thenReturn(ActionRequest(
            body: '',
            headers: {},
            uri: Uri(),
          ));
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
          final actual = await controlPoint.invoke(params);

          expect(actual, isA<ActionResponse>());
        });
      });
    });
  });
}

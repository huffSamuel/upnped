import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:upnped/src/control/control.dart';
import 'package:upnped/src/shared/shared.dart';

import '../util.dart';
@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
  MockSpec<http.Request>(),
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
        mockClient,
        mockBuilder,
        mockUserAgentFactory,
      );

      when(mockUserAgentFactory.create()).thenResolve('userAgent');
    });

    group('invoke()', () {
      late MockResponse mockResponse;
      late MockRequest mockRequest;

      setUp(() {
        mockResponse = MockResponse();
        mockRequest = MockRequest();
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow('');
      });

      test('gets the current useragent', () async {
        try {
          await controlPoint.invoke(params);
        } catch (_) {}

        verify(mockUserAgentFactory.create()).called(1);
      });

      test('calls the request builder', () async {
        const expectedUserAgent = 'useragent';
        when(mockUserAgentFactory.create()).thenResolve(expectedUserAgent);

        try {
          await controlPoint.invoke(params);
        } catch (_) {}

        verify(mockBuilder.build(expectedUserAgent, any));
      });

      test('makes the expected request', () async {
        final expected = ActionRequest(
          uri: Uri.parse('http://www.upnp.org:4200'),
          headers: {},
          body: '',
        );

        when(mockUserAgentFactory.create()).thenResolve('');
        when(mockBuilder.build(any, any)).thenReturn(expected);

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
          final request = ActionRequest(
            body: '',
            headers: {},
            uri: Uri(),
          );
          when(mockUserAgentFactory.create()).thenResolve('');
          when(mockBuilder.build(any, any)).thenReturn(request);
          when(mockRequest.method).thenReturn('GET');
          when(mockRequest.url)
              .thenReturn(Uri.parse('https://www.samueljhuff.com'));
          when(mockResponse.body).thenReturn(faultResponse);
          when(mockResponse.request).thenReturn(mockRequest);
          reset(mockClient);
          when(mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          )).thenAnswer(
            (_) async => mockResponse,
          );
        });

        test('throws an ActionInvocationException', () async {
          final invoke = controlPoint.invoke(params);
          expectLater(invoke, throwsA(isA<ActionInvocationException>()));
        });
      });

      group('when response is success', () {
        setUp(() {
          when(mockUserAgentFactory.create()).thenResolve('');
          when(mockBuilder.build(any, any)).thenReturn(ActionRequest(
            body: '',
            headers: {},
            uri: Uri(),
          ));
          when(mockRequest.method).thenReturn('GET');
          when(mockRequest.url)
              .thenReturn(Uri.parse('https://www.samueljhuff.com'));
          when(mockResponse.body).thenReturn(successResponse);
          when(mockResponse.request).thenReturn(mockRequest);
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

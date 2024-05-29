import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:upnped/src/control/control.dart';
import 'package:upnped/src/upnp/upnp.dart';

@GenerateNiceMocks([MockSpec<Service>(), MockSpec<ServiceData>()])
import 'action_params_test.mocks.dart';

void main() {
  group('ActionParams', () {
    group('fromService', () {
      test('should build the expected object', () {
        final mockData = MockServiceData();
        when(mockData.serviceType).thenReturn('serviceType');
        when(mockData.serviceVersion).thenReturn('1');
        when(mockData.controlUrl).thenReturn(Uri(path: 'control'));

        final mockService = MockService();
        when(mockService.document).thenReturn(mockData);
        when(mockService.location).thenReturn(Uri(host: '127.0.0.1'));

        final expected = ActionParams(
          actionName: 'actionName',
          serviceType: 'serviceType',
          serviceVersion: '1',
          uri: Uri(host: '127.0.0.1'),
          controlPath: 'control',
          arguments: const {},
        );

        final actual = ActionParams.fromService(
          mockService,
          'actionName',
          const {},
        );

        expect(actual, equals(expected));
      });
    });
  });
}

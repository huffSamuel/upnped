import 'package:test/test.dart';
import 'package:upnped/src/ssdp/ssdp.dart';

const notify =
    '''CACHE-CONTROL: max-age=1800\r\nEXT: \r\nLOCATION: http://192.168.0.135:64321/bar-cl3-ms.xml\r\nSERVER: Linux/3.10 UPnP/1.0 Sony-BDV/2.0\r\nST: upnp:rootdevice\r\nUSN: uuid:00000001-0000-1010-8000-104fa8f65fab::upnp:rootdevice\r\nDate: Thu, 09 May 2024 04:32:57 GMT\r\nX-AV-Physical-Unit-Info: pa="HT-CT790"; pl=;\r\nX-AV-Server-Info: av=5.0; hn=""; cn="Sony Corporation"; mn="HT-CT-790"; mv="2.0";\r\n''';

void main() {
  group('device', () {
    group('toString', () {
      test('should return expected string', () {
        final device = Notify.fromData(notify);

        expect(device.toString(), equals(notify));
      });
    });
    group('props', () {
      test('should return the expected properties', () {
        final device = Notify.fromData(notify);

        expect(device.props, equals([notify]));
      });
    });
  });
}

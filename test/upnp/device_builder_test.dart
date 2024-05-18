import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:upnped/src/ssdp/ssdp.dart';
import 'package:upnped/src/upnp/upnp.dart';

import '../util.dart';
@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
  MockSpec<http.Request>(),
  MockSpec<Notify>(),
])
import 'device_builder_test.mocks.dart';

const notify = '''CACHE-CONTROL: max-age=1800
EXT: 
LOCATION: http://192.168.0.135:64321/bar-cl3-ms.xml
SERVER: Linux/3.10 UPnP/1.0 Sony-BDV/2.0
ST: upnp:rootdevice
USN: uuid:00000001-0000-1010-8000-104fa8f65fab::upnp:rootdevice
Date: Thu, 09 May 2024 04:32:57 GMT
X-AV-Physical-Unit-Info: pa="HT-CT790"; pl=;
X-AV-Server-Info: av=5.0; hn=""; cn="Sony Corporation"; mn="HT-CT-790"; mv="2.0";
''';

const rootDeviceDocument =
    '''This XML file does not appear to have any style information associated with it. The document tree is shown below.
<root xmlns="urn:schemas-upnp-org:device-1-0" xmlns:av="urn:schemas-sony-com:av">
<specVersion>
<major>1</major>
<minor>0</minor>
</specVersion>
<device>
<deviceType>urn:schemas-upnp-org:device:MediaServer:1</deviceType>
<friendlyName>Living room soundbar</friendlyName>
<manufacturer>Sony Corporation</manufacturer>
<manufacturerURL>http://www.sony.net/</manufacturerURL>
<modelName>HT-CT790</modelName>
<modelNumber>BAR-2016</modelNumber>
<UDN>uuid:00000001-0000-1010-8000-104fa8f65fab</UDN>
<iconList>
<icon>
<mimetype>image/jpeg</mimetype>
<width>120</width>
<height>120</height>
<depth>24</depth>
<url>/bar_cl3_device_icon_large.jpg</url>
</icon>
<icon>
<mimetype>image/png</mimetype>
<width>120</width>
<height>120</height>
<depth>24</depth>
<url>/bar_cl3_device_icon_large.png</url>
</icon>
<icon>
<mimetype>image/jpeg</mimetype>
<width>48</width>
<height>48</height>
<depth>24</depth>
<url>/bar_cl3_cdevice_icon_small.jpg</url>
</icon>
<icon>
<mimetype>image/png</mimetype>
<width>48</width>
<height>48</height>
<depth>24</depth>
<url>/bar_cl3_device_icon_small.png</url>
</icon>
</iconList>
<serviceList>
<service>
<serviceType>urn:schemas-upnp-org:service:ContentDirectory:1</serviceType>
<serviceId>urn:upnp-org:serviceId:ContentDirectory</serviceId>
<SCPDURL>/ContentDirectorySCPDMS.xml</SCPDURL>
<controlURL>/upnp/control/ContentDirectory</controlURL>
<eventSubURL>/upnp/event/ContentDirectory</eventSubURL>
</service>
<service>
<serviceType>urn:schemas-upnp-org:service:ConnectionManager:1</serviceType>
<serviceId>urn:upnp-org:serviceId:ConnectionManager</serviceId>
<SCPDURL>/ConnectionManagerSCPDMS.xml</SCPDURL>
<controlURL>/upnp/control/ConnectionManager</controlURL>
<eventSubURL>/upnp/event/ConnectionManager</eventSubURL>
</service>
</serviceList>
<microsoft:magicPacketWakeSupported xmlns:microsoft="urn:schemas-microsoft-com:WMPNSS-1-0"> 1 </microsoft:magicPacketWakeSupported>
<av:songPalLink>00000000</av:songPalLink>
</device>
</root>''';

void main() {
  group('build', () {
    late DeviceBuilder builder;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      builder = DeviceBuilder.forTest(client: mockClient);
    });

    group('build', () {
      test('should get the device document', () async {
        final expectedHeaders = {'accept-language': 'en'};
        final expectedUri = Uri.parse('http://test.com');
        final mockDevice = MockDevice();
        when(mockDevice.location).thenReturn(expectedUri);

        try {
          await builder.build(mockDevice, 'en');
        } catch (_) {}

        verify(
          mockClient.get(
            expectedUri,
            headers: expectedHeaders,
          ),
        );
      });

      test('should get the root device', () async {
        final deviceDocumentUri =
            Uri.parse('http://192.168.0.135:64321/bar-cl3-ms.xml');
        final mockDevice = MockDevice();
        when(mockDevice.location).thenReturn(deviceDocumentUri);
        final mockResponse = MockResponse();
        when(mockResponse.body).thenReturn(rootDeviceDocument);
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('get');
        when(mockResponse.request).thenReturn(mockRequest);

        when(mockDevice.location).thenReturn(deviceDocumentUri);
        when(mockClient.get(
          deviceDocumentUri,
          headers: anyNamed('headers'),
        )).thenResolve(mockResponse);

        try {
          await builder.build(mockDevice, 'en');
        } catch (_) {}

        verify(mockClient.get(
          Uri.parse('http://192.168.0.135:64321/bar-cl3-ms.xml'),
          headers: anyNamed('headers'),
        ));
      });

      test('should get service documents', () async {
        final deviceDocumentUri =
            Uri.parse('http://192.168.0.135:64321/bar-cl3-ms.xml');
        final mockDevice = MockDevice();
        when(mockDevice.location).thenReturn(deviceDocumentUri);
        final mockResponse = MockResponse();
        when(mockResponse.body).thenReturn(rootDeviceDocument);
        final mockRequest = MockRequest();
        when(mockRequest.url).thenReturn(Uri(host: 'test.com'));
        when(mockRequest.method).thenReturn('get');
        when(mockResponse.request).thenReturn(mockRequest);

        when(mockDevice.location).thenReturn(deviceDocumentUri);
        when(mockClient.get(
          deviceDocumentUri,
          headers: anyNamed('headers'),
        )).thenResolve(mockResponse);

        try {
          await builder.build(mockDevice, 'en');
        } catch (_) {}

        verify(mockClient.get(
          Uri.parse('http://192.168.0.135:64321/ContentDirectorySCPDMS.xml'),
          headers: anyNamed('headers'),
        ));
        verify(mockClient.get(
          Uri.parse('http://192.168.0.135:64321/ConnectionManagerSCPDMS.xml'),
          headers: anyNamed('headers'),
        ));
      });
    });
  });
}

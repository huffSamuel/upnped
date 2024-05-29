import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<service>
        <serviceType>urn:schemas-sony-com:service:MultiChannel:1</serviceType>
        <serviceId>urn:schemas-sony-com:serviceId:MultiChannel</serviceId>
        <SCPDURL>/MultiChannelSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/MultiChannel</controlURL>
        <eventSubURL>/upnp/event/MultiChannel</eventSubURL>
      </service>''';

void main() {
  group('ServiceData', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = ServiceData.fromXml(doc.root.getElement('service')!);

      expect(actual.serviceType, equals('MultiChannel'));
      expect(actual.serviceVersion, equals('1'));
      expect(actual.serviceId, isNotNull);
      expect(actual.scpdurl, equals(Uri(path: '/MultiChannelSCPD.xml')));
      expect(
          actual.controlUrl, equals(Uri(path: '/upnp/control/MultiChannel')));
      expect(actual.eventSubUrl, equals(Uri(path: '/upnp/event/MultiChannel')));
    });
  });
}

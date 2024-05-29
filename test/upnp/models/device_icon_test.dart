import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<icon>
        <mimetype>image/jpeg</mimetype>
        <width>120</width>
        <height>120</height>
        <depth>24</depth>
        <url>/bar_cl3_device_icon_large.jpg</url>
      </icon>''';

void main() {
  group('DeviceIcon', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = DeviceIcon.fromXml(doc.root.getElement('icon')!);

      expect(actual.mimeType, equals('image/jpeg'));
      expect(actual.width, equals(120));
      expect(actual.height, equals(120));
      expect(actual.depth, equals('24'));
      expect(actual.url, equals(Uri(path: '/bar_cl3_device_icon_large.jpg')));
    });
  });
}

import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<device>
    <deviceType>urn:schemas-upnp-org:device:MediaRenderer:1</deviceType>
    <friendlyName>Living room soundbar</friendlyName>
    <manufacturer>Sony Corporation</manufacturer>
    <manufacturerURL>http://www.sony.net/</manufacturerURL>
    <modelName>HT-CT790</modelName>
    <modelNumber>BAR-2016</modelNumber>
    <UDN>uuid:00000000-0000-1010-8000-104fa8f65fab</UDN>
    <dlna:X_DLNADOC>DMR-1.50</dlna:X_DLNADOC>
    <dlna:X_DLNACAP>playcontainer-0-0</dlna:X_DLNACAP>
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
        <url>/bar_cl3_device_icon_small.jpg</url>
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
        <serviceType>urn:schemas-upnp-org:service:RenderingControl:1</serviceType>
        <serviceId>urn:upnp-org:serviceId:RenderingControl</serviceId>
        <SCPDURL>/RenderingControlBarSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/RenderingControl</controlURL>
        <eventSubURL>/upnp/event/RenderingControl</eventSubURL>
      </service>
      <service>
        <serviceType>urn:schemas-upnp-org:service:ConnectionManager:1</serviceType>
        <serviceId>urn:upnp-org:serviceId:ConnectionManager</serviceId>
        <SCPDURL>/ConnectionManagerSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/ConnectionManager</controlURL>
        <eventSubURL>/upnp/event/ConnectionManager</eventSubURL>
      </service>
      <service>
        <serviceType>urn:schemas-upnp-org:service:AVTransport:1</serviceType>
        <serviceId>urn:upnp-org:serviceId:AVTransport</serviceId>
        <SCPDURL>/AVTransportBarSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/AVTransport</controlURL>
        <eventSubURL>/upnp/event/AVTransport</eventSubURL>
      </service>
      <service>
        <serviceType>urn:schemas-sony-com:service:Group:1</serviceType>
        <serviceId>urn:schemas-sony-com:serviceId:Group</serviceId>
        <SCPDURL>/GroupSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/Group</controlURL>
        <eventSubURL>/upnp/event/Group</eventSubURL>
      </service>
      <service>
        <serviceType>urn:schemas-sony-com:service:MultiChannel:1</serviceType>
        <serviceId>urn:schemas-sony-com:serviceId:MultiChannel</serviceId>
        <SCPDURL>/MultiChannelSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/MultiChannel</controlURL>
        <eventSubURL>/upnp/event/MultiChannel</eventSubURL>
      </service>
      <service>
        <serviceType>urn:schemas-sony-com:service:ScalarWebAPI:1</serviceType>
        <serviceId>urn:schemas-sony-com:serviceId:ScalarWebAPI</serviceId>
        <SCPDURL>/ScalarWebApiSCPD.xml</SCPDURL>
        <controlURL>/upnp/control/ScalarAPI</controlURL>
        <eventSubURL></eventSubURL>
      </service>
    </serviceList>
    <av:X_StandardDMR>1.1</av:X_StandardDMR>
    <microsoft:magicPacketWakeSupported>1</microsoft:magicPacketWakeSupported>
    <pnpx:X_compatibleId>MS_DigitalMediaDeviceClass_DMR_V001</pnpx:X_compatibleId>
    <pnpx:X_deviceCategory>MediaDevices</pnpx:X_deviceCategory>
    <pnpx:X_hardwareId>VEN_0106&amp;DEV_0400&amp;REV_01</pnpx:X_hardwareId>
    <df:X_deviceCategory>Multimedia.DMR</df:X_deviceCategory>
    <av:X_ScalarWebAPI_DeviceInfo>
      <av:X_ScalarWebAPI_Version>1.0</av:X_ScalarWebAPI_Version>
      <av:X_ScalarWebAPI_BaseURL>http://192.168.0.141:10000/sony</av:X_ScalarWebAPI_BaseURL>
      <av:X_ScalarWebAPI_ServiceList>
        <av:X_ScalarWebAPI_ServiceType>guide</av:X_ScalarWebAPI_ServiceType>
        <av:X_ScalarWebAPI_ServiceType>system</av:X_ScalarWebAPI_ServiceType>
        <av:X_ScalarWebAPI_ServiceType>audio</av:X_ScalarWebAPI_ServiceType>
        <av:X_ScalarWebAPI_ServiceType>avContent</av:X_ScalarWebAPI_ServiceType>
      </av:X_ScalarWebAPI_ServiceList>
    </av:X_ScalarWebAPI_DeviceInfo>
    <av:X_CIS_DeviceInfo>
      <av:X_CIS_Version>1,2</av:X_CIS_Version>
      <av:X_CIS_v1Info>
        <av:X_CIS_Port>33335</av:X_CIS_Port>
      </av:X_CIS_v1Info>
      <av:X_CIS_v2Info>
        <av:X_CIS_Port>33336</av:X_CIS_Port>
      </av:X_CIS_v2Info>
    </av:X_CIS_DeviceInfo>
  </device>''';

void main() {
  group('DeviceDescription', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual =
          DeviceDescription.fromXml(doc.root.getElement('device') as XmlNode);

      expect(actual.deviceType, isNotNull);
      expect(actual.friendlyName, equals('Living room soundbar'));
      expect(actual.manufacturer, equals('Sony Corporation'));
      expect(actual.manufacturerUrl, equals(Uri.parse('http://www.sony.net/')));
      expect(actual.modelDescription, isNull);
      expect(actual.modelName, equals('HT-CT790'));
      expect(actual.modelNumber, equals('BAR-2016'));
      expect(actual.modelUrl, isNull);
      expect(actual.serialNumber, isNull);
      expect(actual.udn, equals('uuid:00000000-0000-1010-8000-104fa8f65fab'));
      expect(actual.upc, isNull);
      expect(actual.iconList, hasLength(4));
      expect(actual.services, hasLength(6));
      expect(actual.devices, hasLength(0));
      expect(actual.presentationUrl, isNull);
    });
  });
}

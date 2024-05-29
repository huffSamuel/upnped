import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:upnped/upnped.dart';
import 'package:xml/xml.dart';

const xml = '''<?xml version="1.0"?>
<scpd xmlns="urn:schemas-upnp-org:service-1-0">
  <specVersion>
    <major>1</major>
    <minor>0</minor>
  </specVersion>
  <actionList>
    <action>
      <name>SetDefaultConnectionService</name>
      <argumentList>
        <argument>
          <name>NewDefaultConnectionService</name>
          <direction>in</direction>
          <relatedStateVariable>DefaultConnectionService</relatedStateVariable>
        </argument>
      </argumentList>
    </action>
    <action>
      <name>GetDefaultConnectionService</name>
      <argumentList>
        <argument>
          <name>NewDefaultConnectionService</name>
          <direction>out</direction>
          <relatedStateVariable>DefaultConnectionService</relatedStateVariable>
        </argument>
      </argumentList>
    </action>
  </actionList>
  <serviceStateTable>
    <stateVariable sendEvents="yes">
      <name>DefaultConnectionService</name>
      <dataType>string</dataType>
    </stateVariable>
  </serviceStateTable>
</scpd>''';

void main() {
  group('ServiceDescription', () {
    test('fromXml', () {
      final doc = XmlDocument.parse(xml);

      final actual = ServiceDescription.fromXml(doc);

      expect(actual.namespace, equals('urn:schemas-upnp-org:service-1-0'));
      expect(actual.specVersion, isNotNull);
      expect(actual.actions, hasLength(2));
      expect(actual.serviceStateTable, isNotNull);
    });
  });
}

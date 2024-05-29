part of '../upnp.dart';

/// The architecture on which the [Device] or [ServiceDescription] was implemented.
class SpecVersion {
  final int major;
  final int minor;

  SpecVersion({
    required this.major,
    required this.minor,
  });

  factory SpecVersion.fromXml(XmlNode node) {
    return SpecVersion(
      major: int.parse(node.getElement('major')!.innerText),
      minor: int.parse(node.getElement('minor')!.innerText),
    );
  }
}

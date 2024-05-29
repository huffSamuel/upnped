part of '../upnp.dart';

/// Defines [Action]s and their [Argument]s, and [StateVariable]s and their [DataType], [AllowedValueRange], and event characteristics.
class ServiceDescription {
  /// The raw XML document
  final XmlDocument xml;

  final String namespace;

  /// The lowest version of the architecture on which the service can be implemented.
  final SpecVersion specVersion;

  /// List of actions available for this service.
  final List<Action> actions;

  /// Collection of state variables for this service.
  final ServiceStateTable serviceStateTable;

  late Service _aggregate;

  ServiceDescription._(
    this.xml, {
    required this.namespace,
    required this.specVersion,
    required this.actions,
    required this.serviceStateTable,
  });

  @override
  String toString() {
    return xml.toString();
  }

  factory ServiceDescription.fromXml(XmlDocument xml) {
    final root = xml.getElement('scpd');

    final svc = ServiceDescription._(
      xml,
      namespace: root!.getAttribute('xmlns')!,
      specVersion: SpecVersion.fromXml(
        root.getElement('specVersion')!,
      ),
      actions: _nodeMapper<Action>(
        root.getElement('actionList'),
        'action',
        (x) => Action.fromXml(x),
      ),
      serviceStateTable: ServiceStateTable.fromXml(
        root.getElement('serviceStateTable')!,
      ),
    );

    for (var element in svc.actions) {
      element._service = svc;
    }

    return svc;
  }
}

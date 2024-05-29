part of '../upnp.dart';

/// The state of a [ServiceDescription].
class ServiceStateTable {
  /// List of [StateVariable]s.
  final List<StateVariable> stateVariables;

  ServiceStateTable({
    required this.stateVariables,
  });

  factory ServiceStateTable.fromXml(XmlNode xml) {
    return ServiceStateTable(
        stateVariables: _nodeMapper<StateVariable>(
      xml,
      'stateVariable',
      StateVariable.fromXml,
    ));
  }
}

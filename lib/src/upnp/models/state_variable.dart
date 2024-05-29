part of '../upnp.dart';

/// A variable that represents a value in the service's state.
class StateVariable {
  /// If event messages are generated when the value of this variable changes.
  final bool? sendEvents;

  /// Defines if event messages will be delivered using multicast eventing.
  final bool? multicast;

  /// Name of the state variable.
  final String name;

  /// DataType of this variable.
  final DataType dataType;

  /// Expected, initial value.
  final String? defaultValue;

  /// Enumerates legal string values.
  final List<String>? allowedValues;

  /// Defines bounds and resolution for numeric values.
  final AllowedValueRange? allowedValueRange;

  StateVariable({
    this.sendEvents,
    this.multicast,
    required this.name,
    required this.dataType,
    this.defaultValue,
    this.allowedValues,
    this.allowedValueRange,
  });

  factory StateVariable.fromXml(XmlNode xml) {
    final sendEvents = xml.getAttribute('sendEvents');
    final multicast = xml.getAttribute('multicast');
    final allowedValueRange = xml.getElement('allowedValueRange');

    return StateVariable(
      sendEvents: sendEvents != null ? sendEvents == 'yes' : false,
      multicast: multicast != null ? multicast == 'yes' : false,
      name: xml.getElement('name')!.innerText,
      dataType: DataType.fromXml(xml.getElement('dataType')!),
      defaultValue: xml.getElement('defaultValue')?.innerText,
      allowedValues: _nodeMapper(
        xml.getElement('allowedValueList'),
        'allowedValue',
        (x) => x.innerText,
      ),
      allowedValueRange: allowedValueRange != null
          ? AllowedValueRange.fromXml(allowedValueRange)
          : null,
    );
  }
}

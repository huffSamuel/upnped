part of '../upnp.dart';

enum Direction {
  input("in"),
  output("out");

  const Direction(this.value);

  factory Direction.fromString(String value) {
    for (final v in Direction.values) {
      if (v.value == value) {
        return v;
      }
    }

    throw 'Unknown argument direction';
  }

  final String value;
}

/// A parameter provided to, or returned from, an [Action] during invocation.
class Argument {
  /// Name of formal parameter.
  final String name;

  /// Defines if this argument is input or output.
  final Direction direction;

  /// Identifies at most one argument as a return value.
  final String? retval;

  /// The name of a [StateVariable] defined in the same [ServiceData] that
  /// defines the data type of this argument.
  ///
  /// There is not necessarily any semantic relationship between this argument
  /// and the related state variable.
  final String relatedStateVariable;

  Argument._({
    required this.name,
    required this.direction,
    this.retval,
    required this.relatedStateVariable,
  });

  factory Argument.fromXml(XmlNode xml) {
    return Argument._(
      name: xml.getElement('name')!.innerText,
      direction: Direction.fromString(xml.getElement('direction')!.innerText),
      retval: xml.getElement('retval')?.innerText,
      relatedStateVariable: xml.getElement('relatedStateVariable')!.innerText,
    );
  }
}

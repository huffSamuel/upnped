part of '../upnp.dart';

/// Defines bounds for legal numeric values.
class AllowedValueRange {
  /// Inclusive lower bound.
  final String minimum;

  /// Inclusive upper bound.
  final String maximum;

  /// Defines the set of allowed values permitted for the state variable between
  /// {minimum} and {maximum}.
  ///
  /// `{maximum} = {minimum} + n * {step}`.
  final int step;

  AllowedValueRange._({
    required this.minimum,
    required this.maximum,
    int? step,
  }): step = step ?? 1;

  factory AllowedValueRange.fromXml(XmlNode xml) {
    String? step = xml.getElement('step')?.innerText;

    return AllowedValueRange._(
      minimum: xml.getElement('minimum')!.innerText,
      maximum: xml.getElement('maximum')!.innerText,
      step: step == null ? 1 : int.parse(step),
    );
  }
}

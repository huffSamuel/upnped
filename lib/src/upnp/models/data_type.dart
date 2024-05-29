part of '../upnp.dart';

/// A data type definition.
enum DataTypeValue {
  /// Unsigned 1 byte int. Same format as [int] but without the leading sign.
  ui1,

  /// Unsigned 2 byte int. Same format as [int] but without the leading sign.
  ui2,

  /// Unsigned 4 byte int. Same format as [int] but without the leading sign.
  ui4,

  /// Unsigned 8 byte int. Same format as [int] but without the leading sign.
  ui8,

  /// 1 byte int. Same format as [int].
  i1,

  /// 2 byte int. Same format as [int].
  i2,

  /// 4 byte int. Same format as [int].
  ///
  /// Shall be between `-2147483648` and `2147483647`.
  i4,

  /// 8 Byte int. Same format as [int].
  ///
  /// Shall be between `−9,223,372,036,854,775,808` and `9,223,372,036,854,775,807`.
  i8,

  /// Fixed point, integer number. Is allowed to have leading zeros, which should be ignored
  /// by the recipient. (No currency symbol and no grouping of digits)
  int,

  /// 4 byte float. Same format as [float].
  ///
  /// Shall be between `3.40282347E+38` to `1.17549435E-38`.
  r4,

  /// 8 byte float. Same format as [float].
  ///
  /// Shall be between `-1.79769313486232E308` and `-4.94065645841247E-324` for negative values.
  /// Shall be between `4.94065645841247E-324` and `1.79769313486232E308` for positive values.
  ///
  /// See: IEEE 64-bit (8-Byte) double
  r8,

  /// Same as [r8].
  number,

  /// Same as [r8] but with no more than 14 digits to the left of the decimal point
  /// and no more than 4 to the right.
  fixed_14_4,

  /// Floating point number.
  ///
  /// Mantissa and/or exponent is allowed to have a leading sign and leading zeros.
  ///
  /// Decimal character in mantissa is a period `"."`.
  ///
  /// Mantissa separated from exponent by `"E"`.
  float,

  /// Unicode string; one character long.
  char,

  /// Unicode string; no limit on length.
  string,

  /// Date in a subset of ISO 8601 format without time data.
  date,

  /// Date in ISO 8601 format with allowed time but no time zone.
  dateTime,

  /// Date in ISO 8601 format with allowed time and time zone.
  // ignore: constant_identifier_names
  dateTime_tz,

  /// Time in a subset of ISO 8601 format with neither date nor time zone.
  time,

  /// Time in a subset of ISO 8601 format with no date.
  // ignore: constant_identifier_names
  time_tz,

  /// `"0"` for false or `"1"` for true.
  boolean,

  /// MIME-style Base64 encoded binary BLOB.
  // ignore: constant_identifier_names
  bin_base64,

  /// Hexadecimal digits represented by octets.
  // ignore: constant_identifier_names
  bin_hex,

  /// Universal Resource Identifier.
  uri,

  /// Universally Unique ID.
  uuid
}

/// A datatype that a [StateVariable] contains.
class DataType {

  /// The underlying type.
  final DataTypeValue type;

  DataType(this.type);

  /// Default value for {type}.
  ///
  /// **Not Spec:**
  /// This property is not from the UPnP spec and is included for convenience.
  String? get defaultValue => _defaultValue(type);

  factory DataType.fromXml(XmlNode xml) {
    DataTypeValue type;

    if (_dataTypeMap.keys.contains(xml.innerText)) {
      type = _dataTypeMap[xml.innerText]!;
    } else {
      type = DataTypeValue.string;
    }

    return DataType(type);
  }
}

String? _defaultValue(DataTypeValue type) {
  switch (type) {
    case DataTypeValue.char:
    case DataTypeValue.string:
    case DataTypeValue.bin_base64:
    case DataTypeValue.bin_hex:
    case DataTypeValue.uri:
      return null;
    case DataTypeValue.date:
      return '1985-04-12';
    case DataTypeValue.dateTime:
      return '1985-04-12T10:15:30';
    case DataTypeValue.dateTime_tz:
      return '1985-04-12T10:15:30+0400';
    case DataTypeValue.time:
      return '23:20:50';
    case DataTypeValue.time_tz:
      return '23:20:50+0100';
    case DataTypeValue.boolean:
      return 'true';
    case DataTypeValue.uuid:
      return '00000000-0000-0000-0000-000000000000';
    default:
      return '0';
  }
}

Map<String, DataTypeValue> _dataTypeMap = {
  for (var v in DataTypeValue.values) v.name: v,
  'fixed.14.4': DataTypeValue.fixed_14_4,
  'dateTime.tz': DataTypeValue.dateTime_tz,
  'time.tz': DataTypeValue.time_tz,
  'bin.base64': DataTypeValue.bin_base64,
  'bin.hex': DataTypeValue.bin_hex,
};
part of 'upnp.dart';

class ServiceAggregate {
  final ServiceDescription document;
  final Service? service;
  final Uri location;

  ServiceAggregate(
    this.document,
    this.service,
    this.location,
  ) {
    service?._aggregate = this;
  }
}

/// A UPnP device.
abstract class Device {
  final _activeController = BehaviorSubject<bool>()..add(true);

  Stream<bool> get isActive => _activeController.stream;

  /// Notify that replied to the SSDP query.
  final NotifyDiscovered? notify;

  final DeviceDocument description;
  final List<ServiceAggregate> services;
  final List<Device> devices;

  Device(
    this.description,
    this.services,
    this.devices, {
    this.notify,
  });
}

/// Internal implementation of a device to hide the status methods.
class _DeviceImpl extends Device {
  Timer? _timer;

  void byebye() {
    _timer?.cancel();
    _timer = null;
    _activeController.add(false);
    log('info', 'Timer elapsed', {
      'device': description.friendlyName,
    });
  }

  void alive(NotifyAlive alive) {
    _activeController.add(true);
    _createTimer(alive.cacheControl);
  }

  void _createTimer(String? cacheControl) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    final duration = parseMaxAge(cacheControl);
    if (duration != null) {
      log('info', 'Refreshing timer', {
        'duration': duration,
        'device': description.friendlyName,
      });
      _timer = Timer(duration, byebye);
    }
  }

  _DeviceImpl(
    super.description,
    super.services,
    super.devices, {
    NotifyDiscovered? notify,
  }) : super(notify: notify) {
    if (notify != null) {
      _createTimer(notify.cacheControl);
    }
  }
}

/// The architecture on which the UPnP device or service was implemented.
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

/// A collection of vendor-specific information, definitions of all embedded
/// devices, URL for presentation of the device, and listings for all services,
/// including URLs for control and eventing
class DeviceDocument {
  /// UPnP device type.
  final DeviceType deviceType;

  /// Short description for end user.
  final String friendlyName;

  /// Manufacturer's name.
  final String manufacturer;

  /// Web site for [manufacturer].
  final Uri? manufacturerUrl;

  /// Long description for end user.
  final String? modelDescription;

  /// Model name.
  final String modelName;

  /// Model number.
  final String? modelNumber;

  /// Web site for model.
  final Uri? modelUrl;

  /// Serial number.
  final String? serialNumber;

  /// Unique device name.
  ///
  /// A universally-unique identifier for the device, whether root or embedded.
  final String udn;

  /// Universal product code.
  ///
  /// A 12-digit, all numeric code that identifies the consumer packages.
  final String? upc;

  /// List of icons that visually represent this device.
  final List<DeviceIcon> iconList;

  /// List of services available on this device.
  final List<ServiceDescription> services;

  /// List of child devices on this device.
  final List<DeviceDocument> devices;

  /// URL to presentation for this device.
  final Uri? presentationUrl;

  DeviceDocument({
    required this.deviceType,
    required this.friendlyName,
    required this.manufacturer,
    this.manufacturerUrl,
    this.modelDescription,
    required this.modelName,
    this.modelNumber,
    this.modelUrl,
    this.serialNumber,
    required this.udn,
    this.upc,
    required this.iconList,
    required this.services,
    required this.devices,
    this.presentationUrl,
  });

  factory DeviceDocument.fromXml(XmlNode xml) {
    final presentationUrl = xml.getElement('presentationURL');

    final modelUrl = xml.getElement('modelURL');
    final manufacturerUrl = xml.getElement('manufacturerURL');

    return DeviceDocument(
      deviceType: DeviceType(uri: xml.getElement('deviceType')!.innerText),
      friendlyName: xml.getElement('friendlyName')!.innerText,
      manufacturer: xml.getElement('manufacturer')!.innerText,
      manufacturerUrl:
          manufacturerUrl != null ? Uri.parse(manufacturerUrl.innerText) : null,
      modelDescription: xml.getElement('modelDescription')?.innerText,
      modelName: xml.getElement('modelName')!.innerText,
      modelNumber: xml.getElement('modelNumber')?.innerText,
      modelUrl: modelUrl != null ? Uri.parse(modelUrl.innerText) : null,
      serialNumber: xml.getElement('serialNumber')?.innerText,
      udn: xml.getElement('UDN')!.innerText,
      upc: xml.getElement('UPC')?.innerText,
      iconList: _nodeMapper(
        xml.getElement('iconList'),
        'icon',
        DeviceIcon.fromXml,
      ),
      services: _nodeMapper(
        xml.getElement('serviceList'),
        'service',
        ServiceDescription.fromXml,
      ),
      devices: _nodeMapper(
        xml.getElement('deviceList'),
        'device',
        DeviceDocument.fromXml,
      ),
      presentationUrl:
          presentationUrl != null ? Uri.parse(presentationUrl.innerText) : null,
    );
  }
}

/// UPnP device type.
class DeviceType {
  final String uri;

  List<String> get _fields => uri.split(':');

  String get domainName => _fields[1];
  String get deviceType => _fields[3];
  int get version => int.parse(_fields[4]);

  DeviceType({
    required this.uri,
  });
}

/// Defines actions and their arguments, and state variables and their data
/// type, range, and event characteristics
class ServiceDescription {
  /// UPnP service type.
  final String serviceType;

  final String serviceVersion;

  /// Service identifier.
  final ServiceId serviceId;

  /// URL for service description.
  final Uri scpdurl;

  /// URL for control.
  final Uri controlUrl;

  /// URL for eventing.
  final Uri eventSubUrl;

  ServiceDescription({
    required this.serviceType,
    required this.serviceVersion,
    required this.serviceId,
    required this.scpdurl,
    required this.controlUrl,
    required this.eventSubUrl,
  });

  factory ServiceDescription.fromXml(XmlNode xml) {
    final scpdurl = xml.getElement('SCPDURL')?.innerText;
    final controlUrl = xml.getElement('controlURL')?.innerText;
    final eventSubUrl = xml.getElement('eventSubURL')?.innerText;
    final serviceType = xml.getElement('serviceType')!.innerText;

    final serviceTypeFields = serviceType.split(':');

    return ServiceDescription(
      serviceType: serviceTypeFields[serviceTypeFields.length - 2],
      serviceVersion: serviceTypeFields[serviceTypeFields.length - 1],
      serviceId: ServiceId.parse(xml.getElement('serviceId')!.innerText),
      scpdurl: Uri.parse(scpdurl!),
      controlUrl: Uri.parse(controlUrl!),
      eventSubUrl: Uri.parse(eventSubUrl!),
    );
  }
}

class ServiceId {
  final String _fields;
  final String domain;
  final String serviceId;

  ServiceId(
    this._fields, {
    required this.domain,
    required this.serviceId,
  });

  factory ServiceId.parse(String str) {
    final fields = str.split(':');

    return ServiceId(
      str,
      domain: fields[1],
      serviceId: fields[3],
    );
  }

  @override
  String toString() {
    return _fields;
  }
}

/// Icon to depict device in a control point UI.
class DeviceIcon {
  /// Icon's MIME type.
  final String mimeType;

  /// Horizontal dimension of the icon, in pixels.
  final int width;

  /// Vertical dimensions of the icon, in pixels.
  final int height;

  /// Number of color bits per pixel.
  final String depth;

  /// Pointer to the icon image.
  ///
  /// Relative to the URL at which the device description is located.
  final Uri url;

  DeviceIcon({
    required this.mimeType,
    required this.width,
    required this.height,
    required this.depth,
    required this.url,
  });

  factory DeviceIcon.fromXml(XmlNode xml) {
    return DeviceIcon(
      mimeType: xml.getElement('mimetype')!.innerText,
      width: int.parse(xml.getElement('width')!.innerText),
      height: int.parse(xml.getElement('height')!.innerText),
      depth: xml.getElement('depth')!.innerText,
      url: Uri.parse(xml.getElement('url')!.innerText),
    );
  }
}

class Service {
  final XmlDocument xml;
  final String namespace;
  final SpecVersion specVersion;
  final List<Action> actions;
  final ServiceStateTable serviceStateTable;

  late ServiceAggregate _aggregate;

  Service(
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

  factory Service.fromXml(XmlDocument xml) {
    final root = xml.getElement('scpd');

    final svc = Service(
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

/// The state of a service.
class ServiceStateTable {
  /// A list of state variables.
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

/// An action that can be invoked on a UPnP device.
class Action {
  /// Name of the action.
  final String name;

  /// Contains arguments required for this action.
  final List<Argument>? arguments;

  late Service _service;

  Future<control.ActionResponse> invoke(
    Map<String, dynamic> args,
  ) async {
    final params = control.ActionParams.fromService(
      _service._aggregate,
      name,
      args,
    );
    return await ControlPoint.getInstance().invoke(params);
  }

  Action({
    required this.name,
    this.arguments,
  });

  factory Action.fromXml(
    XmlNode xml,
  ) {
    return Action(
      name: xml.getElement('name')!.innerText,
      arguments: _nodeMapper(
        xml.getElement('argumentList'),
        'argument',
        Argument.fromXml,
      ),
    );
  }
}

class DataType {
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
    case DataTypeValue.binaryBase64:
    case DataTypeValue.binaryHex:
    case DataTypeValue.uri:
      return null;
    case DataTypeValue.date:
      return '1985-04-12';
    case DataTypeValue.dateTime:
      return '1985-04-12T10:15:30';
    case DataTypeValue.dateTimeTz:
      return '1985-04-12T10:15:30+0400';
    case DataTypeValue.time:
      return '23:20:50';
    case DataTypeValue.timeTz:
      return '23:20:50+0100';
    case DataTypeValue.boolean:
      return 'true';
    case DataTypeValue.uuid:
      return '00000000-0000-0000-0000-000000000000';
    default:
      return '0';
  }
}

enum ArgumentDirection {
  input("in"),
  output("out");

  const ArgumentDirection(this.value);

  factory ArgumentDirection.fromString(String value) {
    for (final v in ArgumentDirection.values) {
      if (v.value == value) {
        return v;
      }
    }

    throw 'Unknown argument direction';
  }

  final String value;
}

/// A parameter provided to or returned from a [Action] during invocation.
class Argument {
  /// Name of formal parameter.
  final String name;

  /// Defines if this argument is input or output.
  final ArgumentDirection direction;

  /// Identifies at most one argument as a return value.
  final String? retval;

  /// The name of a state variable defined in the same service description that
  /// defines the data type of this argument.
  ///
  /// There is not necessarily any semantic relationship between this argument
  /// and the related state variable.
  final String relatedStateVariable;

  Argument({
    required this.name,
    required this.direction,
    this.retval,
    required this.relatedStateVariable,
  });

  factory Argument.fromXml(XmlNode xml) {
    return Argument(
      name: xml.getElement('name')!.innerText,
      direction:
          ArgumentDirection.fromString(xml.getElement('direction')!.innerText),
      retval: xml.getElement('retval')?.innerText,
      relatedStateVariable: xml.getElement('relatedStateVariable')!.innerText,
    );
  }
}

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

Map<String, DataTypeValue> _dataTypeMap = {
  for (var v in DataTypeValue.values) v.name: v,
  'fixed.14.4': DataTypeValue.fixed14_4,
  'dateTime.tz': DataTypeValue.dateTimeTz,
  'time.tz': DataTypeValue.timeTz,
  'bin.base64': DataTypeValue.binaryBase64,
  'bin.hex': DataTypeValue.binaryHex,
};

enum DataTypeValue {
  /// Unsigned 1 byte int. Same format as {int} but without the leading sign.
  ui1,

  /// Unsigned 2 byte int. Same format as {int} but without the leading sign.
  ui2,

  /// Unsigned 4 byte int. Same format as {int} but without the leading sign.
  ui4,

  /// Unsigned 8 byte int. Same format as {int} but without the leading sign.
  ui8,

  /// 1 byte int. Same format as {int}.
  i1,

  /// 2 byte int. Same format as {int}.
  i2,

  /// 4 byte int. Same format as {int}.
  ///
  /// Shall be between `-2147483648` and `2147483647`.
  i4,

  /// 8 Byte int. Same format as int.
  ///
  /// Shall be between `−9,223,372,036,854,775,808` and `9,223,372,036,854,775,807`.
  i8,

  /// Fixed point, integer number. Is allowed to have leading zeros, which should be ignored
  /// by the recipient. (No currency symbol and no grouping of digits)
  int,

  /// 4 byte float. Same format as float.
  ///
  /// Shall be between `3.40282347E+38` to `1.17549435E-38`.
  r4,

  /// 8 byte float. Same format as float.
  ///
  /// Shall be between `-1.79769313486232E308` and `-4.94065645841247E-324` for negative values.
  /// Shall be between `4.94065645841247E-324` and `1.79769313486232E308` for positive values.
  ///
  /// See: IEEE 64-bit (8-Byte) double
  r8,

  /// Same as {r8}.
  number,

  /// Same as {r8} but with no more than 14 digits to the left of the decimal point
  /// and no more than 4 to the right.
  fixed14_4,

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
  dateTimeTz,

  /// Time in a subset of ISO 8601 format with neither date nor time zone.
  time,

  /// Time in a subset of ISO 8601 format with no date.
  timeTz,

  /// `"0"` for false or `"1"` for true.
  boolean,

  /// MIME-style Base64 encoded binary BLOB.
  binaryBase64,

  /// Hexadecimal digits represented by octets.
  binaryHex,

  /// Universal Resource Identifier.
  uri,

  /// Universally Unique ID.
  uuid
}

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

  AllowedValueRange({
    required this.minimum,
    required this.maximum,
    this.step = 1,
  });

  factory AllowedValueRange.fromXml(XmlNode xml) {
    String? step = xml.getElement('step')?.innerText;

    return AllowedValueRange(
      minimum: xml.getElement('minimum')!.innerText,
      maximum: xml.getElement('maximum')!.innerText,
      step: step == null ? 1 : int.parse(step),
    );
  }
}

_nodeMapper<T>(
  XmlNode? xml,
  String elementType,
  T Function(XmlNode) buildFn,
) =>
    xml?.findAllElements(elementType).map<T>(buildFn).toList() ?? [];

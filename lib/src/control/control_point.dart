part of 'control.dart';

/// A control point for controlling UPnP devices.
class ControlPoint {
  static ControlPoint? _instance;

  // coverage:ignore-start
  /// Get the instance of the UPnP device control point.
  static ControlPoint getInstance() {
    return _instance ??= ControlPoint._(
      client: http.Client(),
      builder: const ActionRequestBuilder(),
      userAgentFactory: PlatformUserAgentFactory(),
    );
  }
  // coverage:ignore-end

  final http.Client _client;
  final ActionRequestBuilder _builder;
  final UserAgentFactory _userAgentFactory;

  ControlPoint._({
    required http.Client client,
    required ActionRequestBuilder builder,
    required UserAgentFactory userAgentFactory,
  })  : _client = client,
        _builder = builder,
        _userAgentFactory = userAgentFactory;

  @visibleForTesting
  factory ControlPoint.forTest(
    http.Client client,
    ActionRequestBuilder requestBuilder,
    UserAgentFactory userAgentFactory,
  ) =>
      ControlPoint._(
        client: client,
        builder: requestBuilder,
        userAgentFactory: userAgentFactory,
      );

  /// Invoke an action.
  ///
  /// Prefer calling `invoke()` on the ServiceAction object over calling this method.
  Future<ActionResponse> invoke(
    ActionParams params,
  ) async {
    final userAgent = await _userAgentFactory.create();
    final request = _builder.build(userAgent, params);

    // TODO: Handle timing out and throwing errors
    final response = await _client.post(
      request.uri,
      headers: request.headers,
      body: request.body,
    );

    networkController.add(HttpEvent(response));

    final xml = XmlDocument.parse(response.body);

    if (isFault(xml)) {
      final fault = Fault.parse(response.body);

      throw ActionInvocationException(fault.description, fault.code);
    }

    return ActionResponse.fromXml(xml);
  }
}

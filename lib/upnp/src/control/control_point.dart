part of control;

/// A control point for controlling UPnP devices.
class ControlPoint with EnsureUserAgentMixin {
  late http.Client _client;
  late ActionRequestBuilder _builder;

  ControlPoint._({
    http.Client? client,
    ActionRequestBuilder builder = const ActionRequestBuilder(),
    UserAgentFactory userAgentFactory = const PlatformUserAgentFactory(),
  }) {
    _client = client ?? http.Client();
    _builder = builder;
    super.userAgentFactory = userAgentFactory;
  }

  /// Creates a new ControlPoint.
  factory ControlPoint() => ControlPoint._();

  @visibleForTesting
  factory ControlPoint.forTest({
    http.Client? client,
    ActionRequestBuilder builder = const ActionRequestBuilder(),
    UserAgentFactory userAgentFactory = const PlatformUserAgentFactory(),
  }) =>
      ControlPoint._(
        client: client,
        builder: builder,
        userAgentFactory: userAgentFactory,
      );

  Future<ActionResponse> invoke(
    ActionRequestParams params,
  ) async {
    await ensureUserAgent();

    final request = _builder.build(params);

    // TODO: Handle timing out and throwing errors
    final response = await _client.post(
      request.uri,
      headers: request.headers,
      body: request.body,
    );

    networkController.add(HttpEvent(response));

    final xml = XmlDocument.parse(response.body);

    if (isFault(xml)) {
      final fault = ActionFault.parse(response.body);

      throw ControlError(fault.description, fault.code);
    }

    return ActionResponse.fromXml(xml);
  }
}

part of control;



class ControlPoint {
  final http.Client? _client;

  const ControlPoint({
    http.Client? client,
  }) : _client = client;

  http.Client get _effectiveClient => _client ?? http.Client();

  Future<ActionResponse> invoke(
    ActionRequest request,
  ) async {
    final response = await _effectiveClient.post(
      request.uri,
      headers: request.headers,
      body: request.body,
    );

    final xml = XmlDocument.parse(response.body);

    if (isFault(xml)) {
      final fault = ActionFault.parse(response.body);

      throw ControlError(fault.description, fault.code);
    }

    return ActionResponse.fromXml(xml);
  }
}





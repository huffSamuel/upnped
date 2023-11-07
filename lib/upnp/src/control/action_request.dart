part of control;

class ActionRequest with EquatableMixin {
  final Uri uri;
  final Map<String, String> headers;
  final String body;

  const ActionRequest({
    required this.uri,
    required this.headers,
    required this.body,
  });

  @override
  List<Object?> get props => [uri, headers, body];
}

class ActionRequestParams {
  final String actionName;
  final String serviceType;
  final String serviceVersion;
  final Uri uri;
  final String controlPath;
  final Map<String, dynamic> arguments;

  ActionRequestParams({
    required this.actionName,
    required this.serviceType,
    required this.serviceVersion,
    required this.uri,
    required this.controlPath,
    required this.arguments,
  });

  factory ActionRequestParams.fromService(
    ServiceAggregate service,
    String actionName,
    Map<String, dynamic> arguments,
  ) {
    return ActionRequestParams(
      actionName: actionName,
      serviceType: service.document.serviceType,
      serviceVersion: service.document.serviceVersion,
      uri: service.location,
      controlPath: service.document.controlUrl.path,
      arguments: arguments,
    );
  }
}

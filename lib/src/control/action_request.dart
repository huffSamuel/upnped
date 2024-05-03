part of 'control.dart';

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
  
  /// The name of the action to invoke.
  final String actionName;

  /// The type of the parent service.
  final String serviceType;

  /// The version of the parent service.
  final String serviceVersion;
  
  /// The uri for controlling the parent service.
  final Uri uri;

  /// The control path for this action.
  final String controlPath;

  /// Map of arguments.
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

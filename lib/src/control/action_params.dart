part of 'control.dart';

class ActionParams extends Equatable {
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

  const ActionParams({
    required this.actionName,
    required this.serviceType,
    required this.serviceVersion,
    required this.uri,
    required this.controlPath,
    required this.arguments,
  });

  factory ActionParams.fromService(
    Service service,
    String actionName,
    Map<String, dynamic> arguments,
  ) {
    return ActionParams(
      actionName: actionName,
      serviceType: service.document.serviceType,
      serviceVersion: service.document.serviceVersion,
      uri: service.location,
      controlPath: service.document.controlUrl.path,
      arguments: arguments,
    );
  }

  @override
  List<Object?> get props => [
        actionName,
        serviceType,
        serviceVersion,
        uri,
        controlPath,
        ...arguments.entries
      ];
}

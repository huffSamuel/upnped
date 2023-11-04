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

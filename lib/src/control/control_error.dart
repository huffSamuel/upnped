part of 'control.dart';

/// Exception object thrown when an action invocation fails.
class ActionInvocationException extends Error {
  final String description;
  final String code;

  ActionInvocationException(
    this.description,
    this.code,
  );
}

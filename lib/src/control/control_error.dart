part of 'control.dart';

class ActionInvocationException extends Error {
  final String description;
  final String code;

  ActionInvocationException(
    this.description,
    this.code,
  );
}

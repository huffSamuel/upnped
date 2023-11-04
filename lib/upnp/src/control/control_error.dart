part of control;

class ControlError extends Error {
  final String description;
  final String code;

  ControlError(
    this.description,
    this.code,
  );
}

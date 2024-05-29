part of '../upnp.dart';

/// A unique identifier for a [Service].
///
/// This class splits up a single identifier into its component parts.
class ServiceId {
  final String _fields;
  final String domain;
  final String serviceId;

  ServiceId(
    this._fields, {
    required this.domain,
    required this.serviceId,
  });

  factory ServiceId.parse(String str) {
    final fields = str.split(':');

    return ServiceId(
      str,
      domain: fields[1],
      serviceId: fields[3],
    );
  }

  @override
  String toString() {
    return _fields;
  }
}

part of '../messages.dart';

abstract class NotifyDecorator with EquatableMixin {
  final Notify wrapped;
  final List<String> _known;

  UnmodifiableMapView<String, String>? _extensions;

  NotificationSubtype get nts => NotificationSubtype.values.singleWhere(
        (element) => element.value == headers[NotifyKey.nts],
      );

  /// Unique service name of a device or service.
  String get usn => headers[NotifyKey.usn]!;

  /// The boot instance of the device specified by a monotonically increasing value.
  int get bootId => int.parse(headers[NotifyKey.bid]!);

  /// The configuration number of the root device.
  int get configId => int.parse(headers[NotifyKey.cid]!);

  UnmodifiableMapView<String, String> get headers => wrapped.headers;
  UnmodifiableMapView<String, String> get extensions =>
      _extensions ??= mapViewFromEntries(
          wrapped.headers.entries.where((x) => !_known.contains(x.key)));

  T? allowed<T>(String key, T Function(String value) fn) =>
      headers[key] == null ? null : fn(headers[key]!);

  NotifyDecorator(this.wrapped, List<String> known)
      : _known = [
          ...known,
          NotifyKey.bid,
          NotifyKey.usn,
          NotifyKey.cid,
        ];

  @override
  String toString() => wrapped.toString();

  @override
  List<Object?> get props => wrapped.props;
}

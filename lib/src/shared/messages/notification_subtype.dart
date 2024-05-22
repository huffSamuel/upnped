part of '../messages.dart';

enum NotificationSubtype {
  none(null),
  unknown(''),
  alive('ssdp:alive'),
  byebye('ssdp:byebye'),
  update('ssdp:update');

  const NotificationSubtype(this.value);

  factory NotificationSubtype.parse(String? value) {
    for(final v in NotificationSubtype.values) {
      if (v.value == value) {
        return v;
      }
    }

    return NotificationSubtype.unknown;
  }

  final String? value;
}
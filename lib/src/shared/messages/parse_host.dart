part of '../messages.dart';

InternetAddress parseHost(String s) {
  var e = s;
  if (!e.contains(':')) {
    e += ':1900';
  }

  return InternetAddress.tryParse(e)!;
}
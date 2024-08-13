// coverage:ignore-file

library shared;

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:platform/platform.dart';
import 'package:upnped/src/defaults.dart';
import 'package:xml/xml.dart';

part 'network_event.dart';
part 'user_agent.dart';

final networkController = StreamController<NetworkEvent>.broadcast();

class Log {
  static void info(String message, [Map<String, dynamic>? properties]) =>
      _write('info', message, properties);
  static void warn(String message, [Map<String, dynamic>? properties]) =>
      _write('warn', message, properties);
  static void error(String message, [Map<String, dynamic>? properties]) =>
      _write('error', message, properties);
  static void _write(
    String level,
    String message, [
    Map<String, dynamic>? properties,
  ]) {
    if (!(kDebugMode || UPnPObserver.loggingEnabled)) {
      return;
    }

    var sb = StringBuffer(
        '[upnped][${level.toUpperCase()}] - ${DateTime.now().toIso8601String()}: $message');

    if (properties != null) {
      sb.write(' $properties');
    }

    // ignore: avoid_print
    print(sb.toString());
  }
}

/// Observes actions and events related to UPnP.
class UPnPObserver {
  /// Network events sent/received by the UPnP server.
  static Stream<NetworkEvent> get networkEvents => networkController.stream;

  /// Control non-debug mode logging.
  static bool loggingEnabled = false;
}

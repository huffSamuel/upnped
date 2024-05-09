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

void log(String level, String message, [Map<String, dynamic>? properties]) {
  if (kDebugMode) {
    print(
      '[${level.toUpperCase()}] - ${DateTime.now().toIso8601String()}: $message $properties',
    );
  }
}

class UPnPObserver {
  /// Network events sent/received by the UPnP server.
  static get networkEvents => networkController.stream;

  static bool loggingEnabled = false;
}

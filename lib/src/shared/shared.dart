library shared;

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_upnp/src/defaults.dart';
import 'package:fl_upnp/src/shared/ios_version_strategy.dart';
import 'package:fl_upnp/src/shared/macos_version_strategy.dart';
import 'package:xml/xml.dart';

import 'android_version_strategy.dart';
import 'os_version_strategy.dart';

part 'user_agent.dart';
part 'network_event.dart';

final networkController = StreamController<NetworkEvent>.broadcast();

void log(String level, String message, [Map<String, dynamic>? properties]) {
  if (kDebugMode) {
    print(
        '[${level.toUpperCase()}] - ${DateTime.now().toIso8601String()}: $message $properties');
  }
}

class UPnPObserver {
  /// Network events sent/received by the UPnP server.
  static get networkEvents => networkController.stream;

  static bool loggingEnabled = false;
}

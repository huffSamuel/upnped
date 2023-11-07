library shared;

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fl_upnp/fl_upnp.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'src/shared/user_agent.dart';
part 'src/shared/state.dart';

final networkController = StreamController<NetworkEvent>.broadcast();

Stream<NetworkEvent> get network => networkController.stream;

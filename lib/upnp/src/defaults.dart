import 'dart:io';

import 'package:fl_upnp/upnp/ssdp.dart';

const defaultMulticastHops = 1;
const defaultResponseSeconds = 5;
const defaultSearchTarget = SearchTarget.rootDevice;

/// The current system's locale.
String get defaultLocale => Platform.localeName.substring(0, 2);
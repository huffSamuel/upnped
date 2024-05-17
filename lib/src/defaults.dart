//coverage:ignore-file
import 'dart:io';

import 'package:upnped/src/ssdp/ssdp.dart';

const defaultMulticastHops = 1;
const defaultResponseSeconds = 5;
const defaultResponseDuration = Duration(seconds: defaultResponseSeconds);
const defaultSearchTarget = SearchTarget.rootDevice;

/// The current system's locale.
String get defaultLocale => Platform.localeName.substring(0, 2);

const packageVersion = '1.0.0';
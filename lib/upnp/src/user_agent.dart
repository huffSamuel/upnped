import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Create the user agent string.
///
/// Parameters are provided for testing purposes only.
Future<String> userAgent({
  DeviceInfoPlugin? deviceInfo,
  PackageInfo? packageInfo,
}) async {
  deviceInfo ??= DeviceInfoPlugin();
  packageInfo ??= await PackageInfo.fromPlatform();

  final s = _pickStrategy();
  final os = await s.create(deviceInfo);

  return '$os UPnP/1.1 fl_upnp/${packageInfo.version}';
}

OSVersionStrategy _pickStrategy() {
  if (Platform.isAndroid) {
    return AndroidVersionStrategy();
  } else if (Platform.isIOS) {
    return IOSVersionStrategy();
  }

  throw UnimplementedError('Host OS not supported');
}

abstract class OSVersionStrategy {
  Future<String> create(DeviceInfoPlugin plugin);
}

class AndroidVersionStrategy implements OSVersionStrategy {
  @override
  Future<String> create(DeviceInfoPlugin plugin) async {
    final info = await plugin.androidInfo;

    return 'Android/${info.version.sdkInt}';
  }
}

class IOSVersionStrategy implements OSVersionStrategy {
  @override
  Future<String> create(DeviceInfoPlugin plugin) async {
    final info = await plugin.iosInfo;

    return 'iOS/${info.systemVersion}';
  }
}

import 'package:device_info_plus/device_info_plus.dart';

import 'os_version_strategy.dart';

class MacOSVersionStrategy implements OSVersionStrategy {
  @override
  Future<String> create(DeviceInfoPlugin plugin) async {
    final info = await plugin.macOsInfo;

    return 'MacOS/${info.majorVersion}.${info.minorVersion}.${info.patchVersion}';
  }
}

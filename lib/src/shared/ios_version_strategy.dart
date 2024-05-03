import 'package:device_info_plus/device_info_plus.dart';

import 'os_version_strategy.dart';

class IOSVersionStrategy implements OSVersionStrategy {
  @override
  Future<String> create(DeviceInfoPlugin plugin) async {
    final info = await plugin.iosInfo;

    return 'iOS/${info.systemVersion}';
  }
}

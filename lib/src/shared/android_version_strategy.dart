import 'package:device_info_plus/device_info_plus.dart';

import 'os_version_strategy.dart';

class AndroidVersionStrategy implements OSVersionStrategy {
  @override
  Future<String> create(DeviceInfoPlugin plugin) async {
    final info = await plugin.androidInfo;

    return 'Android/${info.version.sdkInt}';
  }
}

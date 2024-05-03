import 'package:device_info_plus/device_info_plus.dart';

abstract class OSVersionStrategy {
  Future<String> create(DeviceInfoPlugin plugin);
}

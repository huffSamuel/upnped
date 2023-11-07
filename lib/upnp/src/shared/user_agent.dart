part of shared;

abstract class UserAgentFactory {
  Future<String> create();
}

/// Class that creates a user agent string from the current platform
class PlatformUserAgentFactory implements UserAgentFactory {
  final DeviceInfoPlugin? deviceInfo;
  final PackageInfo? packageInfo;

  const PlatformUserAgentFactory({
    this.deviceInfo,
    this.packageInfo,
  });

  @override
  Future<String> create() async {
    final di = deviceInfo ?? DeviceInfoPlugin();
    final pi = packageInfo ?? await PackageInfo.fromPlatform();

    final s = _pickStrategy();
    final os = await s.create(di);

    return '$os UPnP/1.1 fl_upnp/${pi.version}';
  }
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

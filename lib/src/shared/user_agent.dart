part of 'shared.dart';

abstract class UserAgentFactory {
  Future<String> create();
}

/// Creates a user agent string from the current platform.
class PlatformUserAgentFactory implements UserAgentFactory {
  final DeviceInfoPlugin? deviceInfo;

  String? _userAgent;

  PlatformUserAgentFactory({
    this.deviceInfo,
  });

  @override
  Future<String> create() async {
    if (_userAgent == null) {
      final di = deviceInfo ?? DeviceInfoPlugin();

      final s = _pickStrategy();
      final os = await s.create(di);

      _userAgent = '$os UPnP/1.1 upnped/$packageVersion';
    }

    return _userAgent!;
  }
}

OSVersionStrategy _pickStrategy() {
  if (Platform.isAndroid) {
    return AndroidVersionStrategy();
  } else if (Platform.isIOS) {
    return IOSVersionStrategy();
  } else if (Platform.isMacOS) {
    return MacOSVersionStrategy();
  } else if (Platform.isWindows) {
    return WindowsVersionStrategy();
  }

  throw UnimplementedError(
    'Host OS not supported: ${Platform.operatingSystem}',
  );
}

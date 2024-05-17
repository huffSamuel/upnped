part of 'shared.dart';

abstract class UserAgentFactory {
  Future<String> create();
}

/// Creates a user agent string from the current platform.
class PlatformUserAgentFactory implements UserAgentFactory {
  final LocalPlatform localPlatform;
  final DeviceInfoPlugin deviceInfo;

  String? _userAgent;

  @visibleForTesting
  PlatformUserAgentFactory.forTest({
    required this.localPlatform,
    required this.deviceInfo,
  });

  PlatformUserAgentFactory()
      : localPlatform = const LocalPlatform(),
        deviceInfo = DeviceInfoPlugin();

  Future<(String operatingSystem, String version)> _operatingSystem() async {
    if (localPlatform.isAndroid) {
      final i = await deviceInfo.androidInfo;
      return ('Android', i.version.sdkInt.toString());
    }

    if (localPlatform.isIOS) {
      final i = await deviceInfo.iosInfo;
      return ('iOS', i.systemVersion);
    }

    if (localPlatform.isMacOS) {
      final i = await deviceInfo.macOsInfo;
      return ('MacOS', '${i.majorVersion}.${i.minorVersion}');
    }

    if (localPlatform.isWindows) {
      final i = await deviceInfo.windowsInfo;
      return ('Windows', i.buildNumber.toString());
    }

    if (localPlatform.isLinux) {
      final i = await deviceInfo.linuxInfo;
      return ('Linux', i.versionId.toString());
    }

    throw UnimplementedError(
        'Host OS not supported: ${localPlatform.operatingSystem}');
  }

  Future<String> _buildUserAgent() async {
    final os = await _operatingSystem();

    return '${os.$1}/${os.$2} UPnP/2.0 upnped/$packageVersion';
  }

  @override
  Future<String> create() async {
    _userAgent ??= await _buildUserAgent();

    return _userAgent!;
  }
}

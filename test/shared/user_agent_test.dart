import 'package:device_info_plus/device_info_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';
import 'package:test/test.dart';
import 'package:upnped/src/shared/shared.dart';

import '../util.dart';
@GenerateNiceMocks([
  MockSpec<LocalPlatform>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<AndroidDeviceInfo>(),
  MockSpec<AndroidBuildVersion>(),
  MockSpec<IosDeviceInfo>(),
  MockSpec<MacOsDeviceInfo>(),
  MockSpec<WindowsDeviceInfo>(),
  MockSpec<LinuxDeviceInfo>()
])
import 'user_agent_test.mocks.dart';

enum OperatingSystem {
  android(isAndroid: true),
  ios(isIos: true),
  macos(isMacos: true),
  windows(isWindows: true),
  linux(isLinux: true),
  none();

  const OperatingSystem({
    this.isAndroid = false,
    this.isIos = false,
    this.isMacos = false,
    this.isWindows = false,
    this.isLinux = false,
  });

  final bool isAndroid;
  final bool isIos;
  final bool isMacos;
  final bool isWindows;
  final bool isLinux;
}

void withOperatingSystem(MockLocalPlatform platform, OperatingSystem os) {
  when(platform.isAndroid).thenReturn(os.isAndroid);
  when(platform.isIOS).thenReturn(os.isIos);
  when(platform.isMacOS).thenReturn(os.isMacos);
  when(platform.isWindows).thenReturn(os.isWindows);
  when(platform.isLinux).thenReturn(os.isLinux);
}

void main() {
  group('PlatformUserAgentFactory', () {
    late MockLocalPlatform mockLocalPlatform;
    late MockDeviceInfoPlugin mockDeviceInfo;
    late UserAgentFactory factory;

    setUp(() {
      mockLocalPlatform = MockLocalPlatform();
      mockDeviceInfo = MockDeviceInfoPlugin();

      factory = PlatformUserAgentFactory.forTest(
        localPlatform: mockLocalPlatform,
        deviceInfo: mockDeviceInfo,
      );
    });

    group('constructor', () {
      test('should assign default dependencies', () {
        final factory = PlatformUserAgentFactory();

        expect(factory.localPlatform, isNotNull);
        expect(factory.deviceInfo, isNotNull);
      });
    });

    group('create', () {
      group('on first call', () {
        test('should check operating systems', () async {
          withOperatingSystem(mockLocalPlatform, OperatingSystem.none);

          try {
            await factory.create();
          } catch (_) {}

          verify(mockLocalPlatform.isAndroid);
          verify(mockLocalPlatform.isIOS);
          verify(mockLocalPlatform.isMacOS);
          verify(mockLocalPlatform.isWindows);
          verify(mockLocalPlatform.isLinux);
        });

        test(
          'when unknown operating system should throw UnimplementedError',
          () async {
            withOperatingSystem(mockLocalPlatform, OperatingSystem.none);

            final invoke = factory.create();

            expectLater(invoke, throwsA(isA<UnimplementedError>()));
          },
        );

        test(
          'when OS is Android should collect Android device info',
          () async {
            final mockVersion = MockAndroidBuildVersion();
            final mockInfo = MockAndroidDeviceInfo();
            when(mockInfo.version).thenReturn(mockVersion);
            when(mockDeviceInfo.androidInfo).thenResolve(mockInfo);
            withOperatingSystem(mockLocalPlatform, OperatingSystem.android);

            try {
              await factory.create();
            } catch (_) {}

            verify(mockDeviceInfo.androidInfo);
            verify(mockInfo.version);
            verify(mockVersion.sdkInt);
          },
        );

        test('when OS is iOS should collect iOS device info', () async {
          final mockInfo = MockIosDeviceInfo();
          when(mockDeviceInfo.iosInfo).thenResolve(mockInfo);
          withOperatingSystem(mockLocalPlatform, OperatingSystem.ios);

          try {
            await factory.create();
          } catch (_) {}

          verify(mockDeviceInfo.iosInfo);
          verify(mockInfo.systemVersion);
        });

        test('when OS is macOS should collect macOS device info', () async {
          final mockInfo = MockMacOsDeviceInfo();
          when(mockInfo.majorVersion).thenReturn(1);
          when(mockInfo.minorVersion).thenReturn(1);
          when(mockDeviceInfo.macOsInfo).thenResolve(mockInfo);
          withOperatingSystem(mockLocalPlatform, OperatingSystem.macos);

          try {
            await factory.create();
          } catch (_) {}

          verify(mockDeviceInfo.macOsInfo);
          verify(mockInfo.majorVersion);
          verify(mockInfo.minorVersion);
        });

        test('when OS is Windows should collect Windows device info', () async {
          final mockInfo = MockWindowsDeviceInfo();
          when(mockInfo.buildNumber).thenReturn(1);
          when(mockDeviceInfo.windowsInfo).thenResolve(mockInfo);
          withOperatingSystem(mockLocalPlatform, OperatingSystem.windows);

          try {
            await factory.create();
          } catch (_) {}

          verify(mockDeviceInfo.windowsInfo);
          verify(mockInfo.buildNumber);
        });

        test('when OS is Linux should collect Linux device info', () async {
          final mockInfo = MockLinuxDeviceInfo();
          when(mockInfo.versionId).thenReturn('');
          when(mockDeviceInfo.linuxInfo).thenResolve(mockInfo);
          withOperatingSystem(mockLocalPlatform, OperatingSystem.linux);

          try {
            await factory.create();
          } catch (_) {}

          verify(mockDeviceInfo.linuxInfo);
          verify(mockInfo.versionId);
        });
      });
    });
  });
}

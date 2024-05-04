# upnped

upnped is a Dart library for discovering and controlling UPnP devices.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

Install from pub with:

```bash
flutter pub add upnped
```

or by adding upnped as a dependency in `pubspec.yaml`:

```yaml
dependencies:
  upnped: <latest_version>
```

## Usage

### Discover devices

```dart
final server = Server.getInstance();

server.devices.listen((UPnPDevice event) {
    print('Discovered a device: ${event}');
});

await server.listen(Options{
    locale: 'en',
});
await server.search();
```

### Invoke actions

```dart
final control = ControlPoint.getInstance();
UPnPDevice device = getDevice();
ServiceAction action = selectAction(device);
Map<String, dynamic> actionArgs = collectArgs();

action.invoke(control, actionArgs);us
```

### Monitor UPnP Events

```dart
UPnPObserver.networkEvents.listen(print);
```

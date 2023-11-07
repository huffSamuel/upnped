# fl_upnp

fl_upnp is a Flutter library for discovering and controlling UPnP devices.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

Install from pub with:

```bash
flutter pub add fl_upnp
```

or by adding fl_upnp as a dependency in `pubspec.yaml`:

```yaml
dependencies:
  fl_upnp: <latest_version>
```

## Usage

### Discover devices

```dart
import 'package:fl_upnp/fl_upnp.dart' as upnp;

Future<void> main() async {
    final server = upnp.Server();
    final sub = server.devices.listen((device) => print('Found a device'));

    await server.initialize();
    await server.search();
}
```

### Control devices

This snippet assumes that the `_findMyDevice()` function uses the code from [discover](Discover) to find a device.

```dart
import 'package:fl_upnp/fl_upnp.dart';

Future<void> main() async {
    final control = ControlPoint();
    final requestBuilder = ActionRequestBuilder();

    final device = await _findMyDevice();

    final request = await requestBuilder.build(device.service, 'helloWorld', {
        'name': 'Leonardo'
    });
    final response = control.invoke(request);
}

Future<UPnPDevice> _findMyDevice() {
    // ...
}

```

### Misc

This library also provides a stream that emits all network activity for UPnP devices:

```dart
upnp.network.listen((message) => print(message));
```
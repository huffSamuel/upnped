# upnped

A Dart library for discovering and controlling UPnP devices.

[![codecov](https://codecov.io/gh/huffSamuel/upnped/graph/badge.svg?token=VAFSPLCEQV)](https://codecov.io/gh/huffSamuel/upnped)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

This package is implemented around the UPnP 2.0 architecture and supports the following UPnP server features:

- UPnP discovery
- Device and Service information
- Non-standard vendor extensions
- Service control
- Event monitoring

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

## Quickstart

```dart
import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  server.devices.listen((Device event) {
    print('Discovered a device: ${event});
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}
```

## Documentation

Check out the [documentation](https://huffsamuel.github.io/upnped) or [examples](./example).

## Contributing

Find something that's missing? Feel free to open an [issue](https://github.com/huffSamuel/upnped/issues) or submit a pull request.

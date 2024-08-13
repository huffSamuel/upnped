// ignore_for_file: avoid_print

import 'package:upnped/upnped.dart';

Future<void> main() async {
  final devices = <Device>[];
  final server = Server.getInstance();

  // Any device that has the same location URI will not be discovered.
  // The server will receive the NOTIFY event from the device but will not
  // request any device or service description information.
  server.loadPredicate =
      (d) => devices.any((x) => x.notify?.location == d.location);

  server.devices.listen((Device event) {
    devices.add(event);
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}

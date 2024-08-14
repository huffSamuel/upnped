// ignore_for_file: avoid_print

import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  server.devices.listen((Device event) {
    print('Discovered a device: $event');
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}

import 'package:fl_upnp/fl_upnp.dart' as upnp;

Future<void> main() async {
  final server = upnp.Server();
  server.devices.listen((upnp.UPnPDevice event) {
    print('Discovered a device');
    print(event.document.friendlyName);
  });

  await server.start();
  await server.search();
  await server.stop();
}

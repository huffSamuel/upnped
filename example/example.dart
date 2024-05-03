// ignore_for_file: avoid_print
import 'package:upnped/upnped.dart';

Future<void> main() async {
  
  final server = Server.getInstance();
  final control = ControlPoint.getInstance();

  server.devices.listen((UPnPDevice event) {
    print('Discovered a device');
    print(event.document.friendlyName);

    event.services.first.service!.actions.first.invoke(control, {});
  });

  await server.listen(Options(
    locale: 'en',
  ));
  
  await server.search();
  await server.stop();

}

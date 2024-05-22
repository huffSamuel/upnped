// ignore_for_file: avoid_print
import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  server.devices.listen((Device event) {
    print('Discovered a device');
    print(event.description.friendlyName);

    event.services.first.service!.actions.first.invoke({
      'someArgFromList': 'foo'
    });
  });

  await server.listen(Options(
    locale: 'en',
  ));

  await server.search();
  await server.stop();
}

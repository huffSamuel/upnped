// ignore_for_file: avoid_print

import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  UPnPObserver.networkEvents.listen((NetworkEvent event) {
    print('${event.type} event: ${event.content}');
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}
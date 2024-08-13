// ignore_for_file: avoid_print

import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  server.devices.listen((Device event) {
    var s = StringBuffer('Device Information:')
      ..writeln('Name: ${event.description.friendlyName}')
      ..writeln('Manufacturer: ${event.description.manufacturer}')
      ..writeln('Model: ${event.description.modelName}');

    if (event.description.presentationUrl != null) {
      s.writeln('Presentation URL: ${event.description.presentationUrl}');
    }

    s.writeln('Number of services: ${event.services.length}');

    print(s.toString());

    event.isActive.listen((isActive) {
      var s = StringBuffer('${event.description.friendlyName} is ');

      if (!isActive) {
        s.write('not ');
      }

      s.write('active.');
      
      print(s.toString());
    });
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}

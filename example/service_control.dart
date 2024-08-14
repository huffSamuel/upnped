// ignore_for_file: avoid_print

import 'package:upnped/upnped.dart';

Future<void> main() async {
  final server = Server.getInstance();

  server.devices.listen((Device event) async {
    final service = event.services[0];
    final action = service.description!.actions[0];

    final args = _populateActionArgs(action, service);

    try {
      final response = await action.invoke(args);

      print('Command complete: ${response.arguments}');
    } on ActionInvocationException catch (e) {
      print('Something went wrong: $e');
    }
  });

  await server.listen(Options());
  await server.search();
  await server.stop();
}

Map<String, dynamic> _populateActionArgs(Action action, Service service) {
  // Cross reference arguments and state table variables to
  // get all information about the variable, default values,
  // data types, etc.
  final expectedArgs = action.arguments!.map((a) => (
        a,
        _relatedStateVariable(service, a.relatedStateVariable),
      ));

  print(expectedArgs);

  // Some input process here needs to fill out the map of arguments and their values

  return {};
}

StateVariable _relatedStateVariable(Service service, String variableName) {
  return service.description!.serviceStateTable.stateVariables
      .singleWhere((x) => x.name == variableName);
}

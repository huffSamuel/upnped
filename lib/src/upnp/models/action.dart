part of '../upnp.dart';

/// An object that represents an action that can be invoked on a remote [ServiceDescription].
class Action {
  /// The name of this action.
  final String name;

  /// Input and output arguments.
  final List<Argument>? arguments;

  late ServiceDescription _service;

  /// Invoke this action.
  Future<control.ActionResponse> invoke(
    Map<String, dynamic> args,
  ) async {
    final params = control.ActionParams.fromService(
      _service._aggregate,
      name,
      args,
    );
    return await ControlPoint.getInstance().invoke(params);
  }

  Action._({
    required this.name,
    this.arguments,
  });

  factory Action.fromXml(
    XmlNode xml,
  ) {
    return Action._(
      name: xml.getElement('name')!.innerText,
      arguments: _nodeMapper(
        xml.getElement('argumentList'),
        'argument',
        Argument.fromXml,
      ),
    );
  }
}

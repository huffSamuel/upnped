part of 'control.dart';

/// A response from an action invocation.
class ActionResponse with EquatableMixin {
  /// Name of the action that was executed.
  final String actionName;

  /// Output arguments returned from this invocation.
  final Map<String, String> arguments;

  const ActionResponse(
    this.actionName,
    this.arguments,
  );

  factory ActionResponse.fromXml(XmlDocument xml) {
    final Map<String, String> arguments = {};
    final node = xml.rootElement
        .getElement('s:Body')!
        .children
        .firstWhere((el) => el is XmlElement) as XmlElement;

    node.children.whereType<XmlElement>().forEach(
          (x) => arguments[x.localName] = x.innerText,
        );

    return ActionResponse(
      node.localName.replaceAll('Response', ''),
      arguments,
    );
  }
  @override
  List<Object?> get props => [actionName, arguments];
}

part of control;

class ActionFault with EquatableMixin {
  final String code;
  final String description;

  const ActionFault(
    this.code,
    this.description,
  );

  factory ActionFault.parse(String str) {
    final xml = XmlDocument.parse(str);
    final node = xml.rootElement
        .getElement('s:Body')!
        .getElement('s:Fault')!
        .getElement('detail')!
        .getElement('UPnPError')!;

    final code = node.getElement('errorCode')!.innerText;
    final description = node.getElement('errorDescription')!.innerText;

    return ActionFault(code, description);
  }

  @override
  List<Object?> get props => [code, description];
}

bool isFault(XmlDocument xml) {
  final firstElement = xml.rootElement
      .getElement('s:Body')!
      .children
      .firstWhere((el) => el is XmlElement) as XmlElement;

  return firstElement.localName == 'Fault';
}

part of '../upnp.dart';

_elementMapper<T>(
        XmlNode? xml, String elementType, T Function(XmlElement) buildFn) =>
    xml?.findAllElements(elementType).map<T>(buildFn).toList() ?? [];

_nodeMapper<T>(
  XmlNode? xml,
  String elementType,
  T Function(XmlNode) buildFn,
) =>
    xml?.findAllElements(elementType).map<T>(buildFn).toList() ?? [];

part of '../upnp.dart';

/// Icon to depict a [Device] in a control point UI.
class DeviceIcon {
  /// Icon's MIME type.
  final String mimeType;

  /// Horizontal dimension of the icon, in pixels.
  final int width;

  /// Vertical dimensions of the icon, in pixels.
  final int height;

  /// Number of color bits per pixel.
  final String depth;

  /// Pointer to the icon image.
  ///
  /// Relative to the URL at which the device description is located.
  final Uri url;

  DeviceIcon({
    required this.mimeType,
    required this.width,
    required this.height,
    required this.depth,
    required this.url,
  });

  factory DeviceIcon.fromXml(XmlElement xml) {
    return DeviceIcon(
      mimeType: xml.getElement('mimetype')!.innerText,
      width: int.parse(xml.getElement('width')!.innerText),
      height: int.parse(xml.getElement('height')!.innerText),
      depth: xml.getElement('depth')!.innerText,
      url: Uri.parse(xml.getElement('url')!.innerText),
    );
  }
}

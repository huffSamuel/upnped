part of '../upnp.dart';

/// A UPnP Service.
class Service {
  /// Service data obtained from the parent [DeviceDescription].
  final ServiceData document;

  /// Service description.
  ///
  /// This the document obtained from the [ServiceDescription.scpdurl].
  final ServiceDescription? description;

  /// URL used to access this service.
  final Uri location;

  Service(
    this.document,
    this.description,
    this.location,
  ) {
    description?._aggregate = this;
  }
}

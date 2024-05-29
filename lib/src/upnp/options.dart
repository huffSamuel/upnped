part of 'upnp.dart';

/// Properties that control device discovery and control.
class Options {
  /// Device description locale.
  ///
  /// If not provided, defaults to the platform locale.
  ///
  /// Device descriptions *may* respect this locale but are not required to by spec.
  final String locale;

  /// The maximum number of network hops for M-SEARCH requests.
  ///
  /// If not provided this value defaults to **1**, which causes traffic to stay on the local network.
  ///
  /// Increasing this value beyond 1 is not recommended, but is supported by UPnP.
  final int multicastHops;

  Options({
    String? locale,
    this.multicastHops = defaultMulticastHops,
  }) : locale = locale ?? defaultLocale;
}

part of 'upnp.dart';

class Options {
  /// Device description locale.
  ///
  /// If not provided, defaults to the platform locale.
  ///
  /// Device descriptions *may* respect this locale, service descriptions **shall not**
  /// provide locale-specific values.
  final String locale;

  /// The maximum number of network hops for M-SEARCH requests.
  ///
  /// If not provided this value defaults to **1**, which causes traffic to stay on the local network.
  final int multicastHops;

  Options({
    String? locale,
    this.multicastHops = defaultMulticastHops,
  }) : locale = locale ?? defaultLocale;
}

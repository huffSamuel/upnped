part of shared;

String? currentUserAgent;

mixin EnsureUserAgentMixin {
  late final UserAgentFactory userAgentFactory;

  /// Ensure the package's user agent string is set.
  Future<void> ensureUserAgent() async {
    currentUserAgent ??= await userAgentFactory.create();
  }
}

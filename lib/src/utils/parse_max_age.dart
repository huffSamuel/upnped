Duration? parseMaxAge(String? cacheControl) {
  if (cacheControl == null) {
    return null;
  }

  final directives =
      cacheControl.split(',').where((x) => x.contains('max-age='));
  if (directives.isEmpty) {
    return null;
  }
  final maxAge = directives.last.split('=')[1];

  return Duration(seconds: int.parse(maxAge));
}

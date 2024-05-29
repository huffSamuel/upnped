import 'dart:collection';

// coverage:ignore-start
UnmodifiableMapView<T, T2> mapViewFromEntries<T, T2>(
  Iterable<MapEntry<T, T2>> entries,
) =>
    UnmodifiableMapView(Map.fromEntries(entries));
// coverage:ignore-end
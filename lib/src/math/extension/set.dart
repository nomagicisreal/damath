///
///
/// this file contains:
///
/// [SetExtension]
///
///
part of damath_math;

///
///
///
extension SetExtension<K> on Set<K> {
  ///
  /// [containsOr]
  ///
  void containsOr(K value, Consumer<Set<K>> action) =>
      contains(value) ? null : action(this);

  ///
  /// [mapToMap]
  ///
  Map<K, V> mapToMap<V>(Translator<K, V> toValue) =>
      Map.fromIterables(this, map(toValue));

}

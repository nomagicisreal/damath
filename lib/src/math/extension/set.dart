///
///
/// this file contains:
///
/// [SetExtension]
///
///
part of damath_math;

extension SetExtension<K> on Set<K> {
  Map<K, V> valuingToMap<V>(Translator<K, V> valuing) =>
      Map.fromIterables(this, map(valuing));
}
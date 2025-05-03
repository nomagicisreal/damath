part of '../collection.dart';


///
/// [MapNullable]
/// [MapValueSet]
///
///






///
///
/// static methods:
/// [predicateInputYet], ...
///
/// instance methods:
/// [inputSet], ...
///
///
extension MapValueSet<K, V> on Map<K, Set<V>> {
  ///
  ///
  /// static methods
  ///
  ///

  ///
  /// [predicateInputYet]
  /// [predicateInputNew]
  /// [predicateInputExist]
  /// [predicateInputKeep]
  ///
  // return true if not yet contained
  static bool predicateInputYet<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.inputSet(k, v, false);

  // return true if not yet contained or absent
  static bool predicateInputNew<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.inputSet(k, v, true);

  // return true if exist
  static bool predicateInputExist<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.inputSet(k, v, true);

  // return true if exist or absent
  static bool predicateInputKeep<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.inputSet(k, v, false);

  ///
  ///
  /// instance methods
  ///
  ///

  ///
  /// when calling [inputSet], there are three conditions:
  ///   1. value set absent: return [absentReturn]
  ///   2. [value] has exist in value set: return `false`
  ///   3. [value] not yet contained in value set: return `true`
  /// see also [Set.add], [MapExtension.input]
  ///
  bool inputSet(K key, V value, [bool absentReturn = true]) {
    var set = this[key];
    if (set == null) {
      this[key] = {value};
      return absentReturn;
    }
    return set.add(value);
  }
}

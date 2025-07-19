part of '../collection.dart';

///
///
/// [MapKeyComparable]
/// [MapValueInt]
/// [MapValueDouble]
///
///

///
/// instance methods:
/// [keysSorted], ...
///
extension MapKeyComparable<K extends Comparable, V> on Map<K, V> {
  static List<K> keysSorted<K extends Comparable, V>(
    Map<K, V> map, [
    bool increase = true,
  ]) =>
      map.keys.toList(growable: false)
        ..sort(IteratorComparable.comparator(increase));

  // notice that it's not efficient, just for convenience
  static List<V> valuesBySortedKeys<K extends Comparable, V>(
    Map<K, V> map, [
    bool increase = true,
  ]) => keysSorted(map, increase).map((key) => map[key]!).toList();

  static List<MapEntry<K, V>> entriesBySortedKeys<K extends Comparable, V>(
    Map<K, V> map, [
    bool increase = true,
  ]) =>
      keysSorted(
        map,
        increase,
      ).map((key) => MapEntry(key, map[key] as V)).toList();
}

///
/// [plusOn]
///
extension MapValueInt<K, V extends num> on Map<K, int> {
  static void plusOn<K>(Map<K, int> map, K key) =>
      map.update(key, (value) => ++value, ifAbsent: () => 1);
}

///
/// [plusOn]
///
extension MapValueDouble<K> on Map<K, double> {
  static void plusOn<K>(Map<K, double> map, K key) =>
      map.update(key, (value) => ++value, ifAbsent: () => 1);
}

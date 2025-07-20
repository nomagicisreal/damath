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
  ///
  /// [keysSorted], [valuesBySortedKeys], [entriesBySortedKeys]
  ///
  List<K> keysSorted([bool increase = true]) =>
      keys.toList(growable: false)
        ..sort(IteratorComparable.comparator(increase));

  List<V> valuesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).map((key) => this[key]!).toList();

  List<MapEntry<K, V>> entriesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).map((key) => MapEntry(key, this[key] as V)).toList();
}

///
/// [plusOn]
///
extension MapValueInt<K, V extends num> on Map<K, int> {
  ///
  /// [plusOn]
  ///
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}

///
/// [plusOn]
///
extension MapValueDouble<K> on Map<K, double> {
  ///
  /// [plusOn]
  ///
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}

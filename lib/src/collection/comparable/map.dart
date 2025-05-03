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
  List<K> keysSorted([bool increase = true]) =>
      keys.toList(growable: false)
        ..sort(IteratorComparable.comparator(increase));

  // notice that it's not efficient, just for convenience
  List<V> valuesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).mapToList((key) => this[key]!);

  List<MapEntry<K, V>> entriesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).mapToList((key) => MapEntry(key, this[key] as V));
}


///
/// [plusOn]
///
extension MapValueInt<K, V extends num> on Map<K, int> {
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}

///
/// [plusOn]
///
extension MapValueDouble<K> on Map<K, double> {
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}
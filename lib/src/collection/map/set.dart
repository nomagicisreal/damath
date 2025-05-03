part of '../collection.dart';

///
///
/// [isEqualToSet], ...
/// [consistentBy], ...
/// [complementTo], ...
/// [toMap], ...
///
///
extension DamathSet<K> on Set<K> {
  ///
  /// [isEqualToSet]
  ///
  bool isEqualToSet(Set<K> another) => another.iterator.anyBy(
        Set.of(this),
        (set, element) => set.add(element),
      );

  bool isDisjointTo(Set<K> another) => intersection(another).isEmpty;

  ///
  /// [consistentBy]
  ///
  /// sample 1:
  ///   final list = <MapEntry<int, int>>[
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 30),
  ///       MapEntry(2, 0),
  ///   ];
  ///   print(list.iterator.[consistentBy]
  ///   (
  ///     (value) => value.key,
  ///     (value) => value.value,
  ///   )); // true
  ///
  ///   in the sample above, there are two group: group 1, group 2.
  ///   the reason why the method returns true is because
  ///   group 1 elements: {list[0].value, list[1].value, list[2].value}
  ///   has a same on entry.value: list[0].value == list[1].value.
  ///
  /// sample 2:
  ///   final list = <MapEntry<int, int>>[
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 30),
  ///       MapEntry(2, 30),
  ///       MapEntry(3, 20),
  ///   ];
  ///   print(list.iterator.[consistentBy]
  ///   (
  ///     (value) => value.key,
  ///     (value) => value.value,
  ///   )); // false
  ///
  ///   in the sample above, there are three group: group 1, group 2, group 3.
  ///   the reason why the method returns false is that
  ///   each of the groups is identical on value
  ///
  bool consistentBy<E, V>(Mapper<K, E> toKey, Mapper<K, V> toVal) => !iterator
      .existAnyToEachGroup(toKey, toVal, MapExtension.predicateInputYet);

  ///
  /// [complementTo]
  ///
  Set<K> complementTo(Set<K> another) => another.difference(this);

  ///
  /// [toMap]
  ///
  Map<K, V> toMap<V>(Mapper<K, V> toVal) => Map.fromIterables(this, map(toVal));
}

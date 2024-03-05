///
///
/// this file contains:
///
///
/// [MapEntryExtension]
/// [MapEntryIterableExtension]
///
/// [MapExtension]
/// [MapKeyComparableExtension]
///
///
///
///
part of damath_math;

// entry
extension MapEntryExtension<K, V> on MapEntry<K, V> {
  MapEntry<V, K> get reversed => MapEntry(value, key);

  String join([String separator = '']) => '$key$separator$value';
}

// entry iterable
extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get toMap => Map.fromEntries(this);
}

///
/// [notContainsKey]
/// [containsKeys]
/// [updateIfNotNull]
///
/// [keysIntersectionWith], [keysDifferenceWith]
/// [addAllDifference],
/// [removeFrom], [removeDifference], [removeIntersection]
/// [updateFrom], [updateDifference], [updateIntersection]
///
/// [mergeAs]
///
/// [join], [joinKeys], [joinValues]
/// [everyKeys], [everyValues]
/// [anyKeys], [anyValues]
/// [fold], [foldWithIndex], [foldKeys], [foldValues]
/// [reduceKeys], [reduceValues], [reduceTo], [reduceToNum]
///
/// [mapKeys], [mapValues]
///
extension MapExtension<K, V> on Map<K, V> {
  bool notContainsKey(K key) => !containsKey(key);

  bool containsKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (notContainsKey(key)) return false;
    }
    return true;
  }

  void putIfAbsentWhen(bool shouldPut, K key, Supplier<V> ifAbsent) =>
      shouldPut ? putIfAbsent(key, ifAbsent) : null;

  V? updateIfNotNull(K? key, Mapper<V> mapper, {Supplier<V>? ifAbsent}) =>
      key == null ? null : update(key, mapper, ifAbsent: ifAbsent);

  ///
  /// [keysSet]
  /// [keysIntersectionWith], [keysDifferenceWith]
  ///
  Set<K> get keysSet => keys.toSet();

  Iterable<K> keysIntersectionWith(Set<K> another) =>
      keysSet.intersection(another);

  Iterable<K> keysDifferenceWith(Set<K> another) => keysSet.difference(another);

  ///
  /// add
  ///
  void addAllDifference(Set<K> keys, V Function(K key) valuing) =>
      addAll(keys.difference(keysSet).valuingToMap(valuing));

  ///
  /// remove
  ///
  Iterable<V> removeFrom(Iterable<K> keys) sync* {
    for (var key in keys) {
      final value = remove(key);
      if (value != null) yield value;
    }
  }

  Iterable<V> removeIntersection(Set<K> keys) =>
      removeFrom(keysIntersectionWith(keys));

  Iterable<V> removeDifference(Set<K> keys) =>
      removeFrom(keysDifferenceWith(keys));

  ///
  /// update
  ///
  Iterable<V> updateFrom(Iterable<K> keys, Companion<V, K> updating) sync* {
    for (var key in keys) {
      yield update(key, (value) => updating(value, key));
    }
  }

  Iterable<V> updateIntersection(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysIntersectionWith(keys), updating);

  Iterable<V> updateDifference(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysDifferenceWith(keys), updating);

  ///
  /// [mergeAs]
  ///
  Iterable<V> mergeAs(
      Set<K> keys,
      V Function(K key) valuing, {
        Companion<V, K>? update,
      }) sync* {
    yield* removeFrom(keysDifferenceWith(keys));
    yield* updateFrom(keysIntersectionWith(keys), update ?? FCompanion.keep);
    addAllDifference(keys, valuing);
  }

  ///
  /// join
  ///
  String join([String entrySeparator = '', String separator = '']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

  String joinKeys([String separator = ', ']) => keys.join(separator);

  String joinValues([String separator = ', ']) => values.join(separator);

  ///
  /// every, any
  ///
  bool everyKeys(Predicator<K> test) => keys.every(test);

  bool everyValues(Predicator<V> test) => values.every(test);

  bool anyKeys(Predicator<K> test) => keys.any(test);

  bool anyValues(Predicator<V> test) => values.any(test);

  ///
  /// [fold]
  /// [foldWithIndex]
  /// [foldKeys], [foldValues]
  ///
  T fold<T>(
      T initialValue,
      Companion<T, MapEntry<K, V>> foldMap,
      ) =>
      entries.fold<T>(
        initialValue,
            (previousValue, element) => foldMap(previousValue, element),
      );

  T foldWithIndex<T>(
      T initialValue,
      Fusionor<T, MapEntry<K, V>, int, T> fusionor,
      ) {
    int index = -1;
    return entries.fold<T>(
      initialValue,
          (previousValue, element) => fusionor(previousValue, element, ++index),
    );
  }

  S foldKeys<S>(S initialValue, Companion<S, K> companion) =>
      keys.fold(initialValue, companion);

  S foldValues<S>(S initialValue, Companion<S, V> companion) =>
      values.fold(initialValue, companion);

  ///
  /// reduce
  ///
  K reduceKeys(Reducer<K> reducing) => keys.reduce(reducing);

  V reduceValues(Reducer<V> reducing) => values.reduce(reducing);

  S reduceTo<S>(Translator<MapEntry<K, V>, S> translator, Reducer<S> reducer) =>
      entries.reduceTo(reducer, translator);

  N reduceToNum<N extends num>({
    required Reducer<N> reducer,
    required Translator<MapEntry<K, V>, N> translator,
  }) =>
      entries.reduceToNum(reducer: reducer, translator: translator);

  ///
  /// map
  ///
  Map<K, V> mapKeys(Mapper<K> toElement) =>
      map((key, value) => MapEntry(toElement(key), value));

  Map<K, V> mapValues(Mapper<V> toElement) =>
      map((key, value) => MapEntry(key, toElement(value)));
}

extension MapKeyComparableExtension<K extends Comparable, V> on Map<K, V> {
  List<K> sortedKeys([Comparator<K>? compare]) => keys.toList()..sort(compare);

  Iterable<V> sortedValuesByKey([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => this[key]!);

  Iterable<MapEntry<K, V>> sortedEntries([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => MapEntry(key, this[key] as V));
}
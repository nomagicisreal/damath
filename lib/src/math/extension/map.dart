///
///
/// this file contains:
///
/// [MapExtension]
///
/// [MapEntryExtension]
/// [MapEntryIterableExtension]
///
/// [MapKeyComparableExtension]
///
/// [MapValueBoolExtension]
/// [MapValueSetExtension]
///
///
///
///
part of damath_math;

///
///
/// [iteratorKeys], ...
/// [notContainsKey], ...
/// [putIfAbsentWhen], ...
///
/// [any], ...
/// [every], ...
/// [join], ...
/// [fold], ...
/// [reduce], ...
/// [mapKeys], ...
///
/// [keysIntersectionWith], [keysDifferenceWith]
/// [addAllDifference],
/// [removeDifference], [removeIntersection]
/// [updateDifference], [updateIntersection]
/// [mergeAs]
///
extension MapExtension<K, V> on Map<K, V> {
  ///
  /// [copy]
  /// [iteratorKeys]
  /// [iteratorValues]
  /// [keysSet]
  ///
  Map<K, V> get copy => Map.of(this);

  Iterator<K> get iteratorKeys => keys.iterator;

  Iterator<V> get iteratorValues => values.iterator;

  Set<K> get keysSet => keys.toSet();

  ///
  ///
  /// bool
  /// [notContainsKey], [notContainsValue]
  /// [containsAllKeys], [containsAllValues]
  /// [containsThen]
  ///
  /// [valueEqualOr]
  ///
  ///

  ///
  /// [notContainsKey], [notContainsValue]
  /// [containsAllKeys], [containsAllValues]
  /// [containsThen]
  ///
  bool notContainsKey(K key) => !containsKey(key);

  bool notContainsValue(V value) => !containsValue(value);

  bool containsAllKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (notContainsKey(key)) return false;
    }
    return true;
  }

  bool containsAllValues(Iterable<V> values) {
    for (var value in values) {
      if (notContainsValue(value)) return false;
    }
    return true;
  }

  T containsThen<T>(K key, Supplier<T> ifContains, Supplier<T> ifAbsent) =>
      containsKey(key) ? ifContains() : ifAbsent();

  ///
  /// [valueEqualOr]
  ///
  bool valueEqualOr(K key, V value, PredicatorMixer<V?, V> test) {
    var v = this[key];
    if (v == value) return true;
    return test(v, value);
  }

  ///
  /// [putIfAbsentOr]
  /// [putIfAbsentThen]
  /// [putIfAbsentWhen]
  ///
  void putIfAbsentOr(K key, Supplier<V> ifAbsent, Consumer<V> ifExist) {
    final value = this[key];
    value == null ? this[key] = ifAbsent() : ifExist(value);
  }

  T putIfAbsentThen<T>(
    K key,
    Supplier<V> ifAbsent,
    Supplier<T> ifAbsentThen,
    Translator<V, T> ifExistThen,
  ) {
    final value = this[key];
    if (value == null) {
      this[key] = ifAbsent();
      return ifAbsentThen();
    } else {
      return ifExistThen(value);
    }
  }

  void putIfAbsentWhen(bool shouldPut, K key, Supplier<V> ifAbsent) =>
      shouldPut ? putIfAbsent(key, ifAbsent) : null;

  ///
  /// [updateThen]
  /// [updateIfNotNull]
  ///
  T updateThen<T>(
    K key,
    Mapper<V> ifExist,
    Supplier<T> ifExistThen,
    Supplier<V> ifAbsent,
    Supplier<T> ifAbsentThen,
  ) {
    final value = this[key];
    if (value == null) {
      this[key] = ifAbsent();
      return ifExistThen();
    } else {
      this[key] = ifExist(value);
      return ifExistThen();
    }
  }

  V? updateIfNotNull(K? key, Mapper<V> ifExist, {Supplier<V>? ifAbsent}) =>
      key == null ? null : update(key, ifExist, ifAbsent: ifAbsent);

  ///
  /// [removeFrom]
  /// [updateFrom]
  ///
  Iterable<V> removeFrom(Iterable<K> keys) sync* {
    for (var key in keys) {
      final value = remove(key);
      if (value != null) yield value;
    }
  }

  Iterable<V> updateFrom(Iterable<K> keys, Companion<V, K> updating) sync* {
    for (var key in keys) {
      yield update(key, (value) => updating(value, key));
    }
  }

  ///
  /// [any]
  /// [anyKeys], [anyValues]
  ///
  /// [every]
  /// [everyKeys], [everyValues]
  ///
  bool any(Predicator<MapEntry<K, V>> test) => entries.any(test);

  bool anyKeys(Predicator<K> test) => keys.any(test);

  bool anyValues(Predicator<V> test) => values.any(test);

  bool every(Predicator<MapEntry<K, V>> test) => entries.every(test);

  bool everyKeys(Predicator<K> test) => keys.every(test);

  bool everyValues(Predicator<V> test) => values.every(test);

  ///
  /// [join]
  /// [joinKeys]
  /// [joinValues]
  ///
  String join([String entrySeparator = '', String separator = '']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

  String joinKeys([String separator = ', ']) => keys.join(separator);

  String joinValues([String separator = ', ']) => values.join(separator);

  ///
  /// fold, reduce
  /// [fold], [foldKeys], [foldValues]
  /// [foldByIndex]
  ///
  /// [reduceKeys], [reduceValues]
  /// [reduceTo]
  ///
  ///

  ///
  /// [fold], [foldKeys], [foldValues]
  /// [foldByIndex]
  ///
  T fold<T>(T initialValue, Companion<T, MapEntry<K, V>> companion) =>
      entries.fold<T>(
        initialValue,
        (previousValue, element) => companion(previousValue, element),
      );

  S foldKeys<S>(S initialValue, Companion<S, K> companion) =>
      keys.fold(initialValue, companion);

  S foldValues<S>(S initialValue, Companion<S, V> companion) =>
      values.fold(initialValue, companion);

  T foldByIndex<T>(
    T initialValue,
    CompanionGenerator<T, MapEntry<K, V>> companion, [
    int start = 0,
  ]) {
    var index = start - 1;
    return entries.fold<T>(
      initialValue,
      (previousValue, element) => companion(previousValue, element, ++index),
    );
  }

  ///
  /// [reduce]
  /// [reduceTo]
  /// [reduceKeys]
  /// [reduceValues]
  ///
  MapEntry<K, V> reduce(Reducer<MapEntry<K, V>> reducing) =>
      entries.reduce(reducing);

  K reduceKeys(Reducer<K> reducing) => keys.reduce(reducing);

  V reduceValues(Reducer<V> reducing) => values.reduce(reducing);

  S reduceTo<S>(Translator<MapEntry<K, V>, S> toVal, Reducer<S> reducer) =>
      entries.iterator.reduceTo(toVal, reducer);

  ///
  /// [mapKeys]
  /// [mapValues]
  ///
  Map<K, V> mapKeys(Mapper<K> toVal) =>
      map((key, value) => MapEntry(toVal(key), value));

  Map<K, V> mapValues(Mapper<V> toVal) =>
      map((key, value) => MapEntry(key, toVal(value)));

  ///
  /// [addAllDifference]
  ///
  void addAllDifference(Set<K> keys, V Function(K key) valuing) =>
      addAll(keys.difference(keysSet).mapToMap(valuing));

  ///
  /// [keysIntersectionWith], [keysDifferenceWith]
  ///
  Iterable<K> keysIntersectionWith(Set<K> another) =>
      keysSet.intersection(another);

  Iterable<K> keysDifferenceWith(Set<K> another) => keysSet.difference(another);

  ///
  /// remove
  ///
  Iterable<V> removeIntersection(Set<K> keys) =>
      removeFrom(keysIntersectionWith(keys));

  Iterable<V> removeDifference(Set<K> keys) =>
      removeFrom(keysDifferenceWith(keys));

  ///
  /// update
  ///
  Iterable<V> updateIntersection(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysIntersectionWith(keys), updating);

  Iterable<V> updateDifference(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysDifferenceWith(keys), updating);

  ///
  /// [mergeAs]
  ///
  Iterable<V> mergeAs(
    Set<K> keys,
    Translator<K, V> valuing, {
    Companion<V, K>? update,
  }) sync* {
    yield* removeFrom(keysDifferenceWith(keys));
    yield* updateFrom(keysIntersectionWith(keys), update ?? FCompanion.keep);
    addAllDifference(keys, valuing);
  }
}

// entry
extension MapEntryExtension<K, V> on MapEntry<K, V> {
  MapEntry<V, K> get reversed => MapEntry(value, key);

  String join([String separator = '']) => '$key$separator$value';
}

///
/// [keys], ...
///
/// [anyKeys], ...
///
extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  ///
  /// [keys]
  /// [values]
  /// [toMap]
  ///
  Iterable<K> get keys => map((e) => e.key);

  Iterable<V> get values => map((e) => e.value);

  Map<K, V> get toMap => Map.fromEntries(this);

  ///
  /// [anyKeys], [anyValues]
  /// [everyKeys], [everyValues]
  ///
  bool anyKeys(Predicator<K> test) => any((e) => test(e.key));

  bool anyValues(Predicator<V> test) => any((e) => test(e.value));

  bool everyKeys(Predicator<K> test) => every((e) => test(e.key));

  bool everyValues(Predicator<V> test) => every((e) => test(e.value));
}

///
///
///
extension MapKeyComparableExtension<K extends Comparable, V> on Map<K, V> {
  List<K> sortedKeys([Comparator<K>? compare]) => keys.toList()..sort(compare);

  Iterable<V> sortedValuesByKey([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => this[key]!);

  Iterable<MapEntry<K, V>> sortedEntries([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => MapEntry(key, this[key] as V));
}

///
///
///
extension MapValueBoolExtension<K> on Map<K, bool> {
  ///
  /// when calling [updateBool], there are three conditions:
  ///   1. value absent: return [absentReturn]
  ///   2. [value] is equal to value in map: return `false`
  ///   3. [value] is different to value in map: return `true`
  /// see also [MapValueSetExtension.updateSet], [Set.add]
  ///
  bool updateBool(K key, bool value, [bool absentReturn = true]) {
    var vOld = this[key];
    if (vOld == null) {
      this[key] = value;
      return absentReturn;
    }
    if (vOld == value) return false;
    this[key] = value;
    return true;
  }
}

///
///
///
extension MapValueSetExtension<K, V> on Map<K, Set<V>> {
  ///
  /// when calling [updateSet], there are three conditions:
  ///   1. value set absent: return [absentReturn]
  ///   2. [value] has exist in value set: return `false`
  ///   3. [value] not yet contained in value set: return `true`
  /// see also [Set.add], [MapValueBoolExtension.updateBool]
  ///
  bool updateSet(K key, V value, [bool absentReturn = true]) {
    var set = this[key];
    if (set == null) {
      this[key] = {value};
      return absentReturn;
    }
    return set.add(value);
  }
}

part of '../collection.dart';

///
///
/// [MapEntryExtension]
/// [MapExtension]
///
///
///

///
/// Notice that [Record] is efficient than [MapEntry] for frequent creation
///
/// static methods:
/// [mix], ...
/// [predicateKeyEqual], ...
/// [reduceMaxKeyInt], ...
///
/// instance methods:
/// [join]
/// [record], [recordReversed]
///
///
extension MapEntryExtension<K, V> on MapEntry<K, V> {
  ///
  /// [mix], [mixReverse]
  ///
  static MapEntry<K, V> mix<K, V>(K k, V v) => MapEntry(k, v);

  static MapEntry<V, K> mixReverse<K, V>(K k, V v) => MapEntry(v, k);

  ///
  /// predicate
  /// [predicateKeyEqual], [predicateKeyDifferent]
  /// [predicateKeyNumEqual], [predicateKeyNumDifferent], [predicateKeyNumLess], [predicateKeyNumLarger]
  ///
  static bool predicateKeyEqual<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key == b.key;

  static bool predicateKeyDifferent<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key != b.key;

  static bool predicateKeyNumEqual<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key == b.key;

  static bool predicateKeyNumDifferent<V>(
    MapEntry<num, V> a,
    MapEntry<num, V> b,
  ) => a.key != b.key;

  static bool predicateKeyNumLess<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key < b.key;

  static bool predicateKeyNumLarger<V>(
    MapEntry<num, V> a,
    MapEntry<num, V> b,
  ) => a.key > b.key;

  ///
  /// reduce
  ///
  // key
  static MapEntry<int, K> reduceMaxKeyInt<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) => v1.key > v2.key ? v1 : v2;

  static MapEntry<int, K> reduceMinKeyInt<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) => v1.key < v2.key ? v1 : v2;

  static MapEntry<double, K> reduceMaxKeyDouble<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) => v1.key > v2.key ? v1 : v2;

  static MapEntry<double, K> reduceMinKeyDouble<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) => v1.key < v2.key ? v1 : v2;

  // value
  static MapEntry<K, int> reduceMaxValueInt<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) => v1.value > v2.value ? v1 : v2;

  static MapEntry<K, int> reduceMinValueInt<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) => v1.value < v2.value ? v1 : v2;

  static MapEntry<K, double> reduceMaxValueDouble<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) => v1.value > v2.value ? v1 : v2;

  static MapEntry<K, double> reduceMinValueDouble<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) => v1.value < v2.value ? v1 : v2;

  ///
  ///
  ///
  String join([String separator = '']) => '$key$separator$value';

  ///
  /// [record], [recordReversed] (record is lightly efficient than [MapEntry])
  ///
  (K, V) get record => (key, value);

  (V, K) get recordReversed => (value, key);
}

///
///
/// static methods:
/// [predicateInputYet], ...
///
/// instance methods:
/// [putIfAbsentWhen], ...
/// [input], ...
///
/// [join], ...
/// [mapKeys], ...
///
/// [keysIntersectionWith], [keysDifferenceWith]
/// [addAllDifference],
/// [removeDifference], [removeIntersection]
/// [updateDifference], [updateIntersection]
/// [migrateInto]
///
extension MapExtension<K, V> on Map<K, V> {
  ///
  /// [predicateInputYet]
  /// [predicateInputNew]
  /// [predicateInputExist]
  /// [predicateInputKeep]
  ///
  // return true if not yet contained
  static bool predicateInputYet<K, V>(Map<K, V> map, K key, V value) =>
      map.input(key, value, false);

  // return true if not yet contained or absent
  static bool predicateInputNew<K>(Map<K, bool> map, K key, bool value) =>
      map.input(key, value, true);

  // return true if exist
  static bool predicateInputExist<K>(Map<K, bool> map, K key, bool value) =>
      !map.input(key, value, true);

  // return true if exist or absent
  static bool predicateInputKeep<K>(Map<K, bool> map, K key, bool value) =>
      !map.input(key, value, false);

  ///
  /// [containsAllKeys], [containsAllValues]
  /// [containsThen]
  ///
  bool containsAllKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (!containsKey(key)) return false;
    }
    return true;
  }

  bool containsAllValues(Iterable<V> values) {
    for (var value in values) {
      if (!containsValue(value)) return false;
    }
    return true;
  }

  T containsThen<T>(K key, Supplier<T> ifContains, Supplier<T> ifAbsent) =>
      containsKey(key) ? ifContains() : ifAbsent();

  bool valueEqualOr(K key, V value, PredicatorMixer<V?, V> test) {
    var v = this[key];
    if (v == value) return true;
    return test(v, value);
  }

  ///
  ///
  ///
  void putIfAbsentWhen(bool shouldPut, K key, Supplier<V> ifAbsent) =>
      shouldPut ? putIfAbsent(key, ifAbsent) : null;

  void putIfAbsentOr(K key, Supplier<V> ifAbsent, Consumer<V> ifExist) {
    final value = this[key];
    value == null ? this[key] = ifAbsent() : ifExist(value);
  }

  T putIfAbsentThen<T>(
    K key,
    Supplier<V> ifAbsent,
    Supplier<T> ifAbsentThen,
    Mapper<V, T> ifExistThen,
  ) {
    final value = this[key];
    if (value == null) {
      this[key] = ifAbsent();
      return ifAbsentThen();
    } else {
      return ifExistThen(value);
    }
  }

  ///
  ///
  ///
  T updateThen<T>(
    K key,
    Applier<V> ifExist,
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

  V? updateIfNotNull(K? key, Applier<V> ifExist, {Supplier<V>? ifAbsent}) =>
      key == null ? null : update(key, ifExist, ifAbsent: ifAbsent);

  ///
  ///
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
  /// when calling [input], there are three conditions:
  ///   1. return [absentReturn] if key is absent
  ///   2. [value] equal to old value returns `false`
  ///   3. update old value to new [value] returns `true`
  /// see also [predicateInputYet], ..., [MapValueSet.inputSet], [Set.add], ...
  ///
  bool input(K key, V value, [bool absentReturn = true]) {
    var vOld = this[key];
    if (vOld == null) {
      this[key] = value;
      return absentReturn;
    }
    if (vOld == value) return false;
    this[key] = value;
    return true;
  }

  ///
  /// [join]
  /// [joinKeys], [joinValues]
  /// [joinEntries]
  ///
  String join([String entrySeparator = ', ', String separator = '\n']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

  String joinKeys([String separator = ', ']) => keys.join(separator);

  String joinValues([String separator = ', ']) => values.join(separator);

  String joinEntries(
    Mapper<MapEntry<K, V>, String> mapper, [
    String separator = '\n',
  ]) => entries.map(mapper).join(separator);

  ///
  /// [mapKeys]
  /// [mapValues]
  ///
  Map<T, V> mapKeys<T>(Mapper<K, T> toVal) =>
      map((key, value) => MapEntry(toVal(key), value));

  Map<K, T> mapValues<T>(Mapper<V, T> toVal) =>
      map((key, value) => MapEntry(key, toVal(value)));

  ///
  /// [addAllDifference]
  ///
  void addAllDifference(Set<K> keys, V Function(K key) valuing) =>
      addAll(keys.difference(keys.toSet()).toMap(valuing));

  ///
  /// [keysIntersectionWith], [keysDifferenceWith]
  ///
  Iterable<K> keysIntersectionWith(Set<K> another) =>
      keys.toSet().intersection(another);

  Iterable<K> keysDifferenceWith(Set<K> another) =>
      keys.toSet().difference(another);

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
  /// [migrateInto]
  ///
  Iterable<V> migrateInto(
    Set<K> keys,
    Mapper<K, V> valuing, [
    Companion<V, K>? update,
  ]) sync* {
    yield* removeFrom(keysDifferenceWith(keys));
    yield* updateFrom(keysIntersectionWith(keys), update ?? FKeep.companion);
    addAllDifference(keys, valuing);
  }
}

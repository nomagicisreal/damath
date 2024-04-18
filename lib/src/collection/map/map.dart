///
///
/// this file contains:
///
/// [MapEntryExtension]
///
///
/// [MapExtension]
/// [MapKeyComparable]
///
/// [MapValueInt]
/// [MapValueDouble]
/// [MapValueSet]
///
///
///
part of damath_collection;

///
/// [Record] is lightly efficient than [MapEntry] in creation
///

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
  ) =>
      a.key != b.key;

  static bool predicateKeyNumLess<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key < b.key;

  static bool predicateKeyNumLarger<V>(
          MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key > b.key;

  ///
  /// reduce
  ///
  // key
  static MapEntry<int, K> reduceMaxKeyInt<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) =>
      v1.key > v2.key ? v1 : v2;

  static MapEntry<int, K> reduceMinKeyInt<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) =>
      v1.key < v2.key ? v1 : v2;

  static MapEntry<double, K> reduceMaxKeyDouble<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) =>
      v1.key > v2.key ? v1 : v2;

  static MapEntry<double, K> reduceMinKeyDouble<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) =>
      v1.key < v2.key ? v1 : v2;

  // value
  static MapEntry<K, int> reduceMaxValueInt<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) =>
      v1.value > v2.value ? v1 : v2;

  static MapEntry<K, int> reduceMinValueInt<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) =>
      v1.value < v2.value ? v1 : v2;

  static MapEntry<K, double> reduceMaxValueDouble<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) =>
      v1.value > v2.value ? v1 : v2;

  static MapEntry<K, double> reduceMinValueDouble<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) =>
      v1.value < v2.value ? v1 : v2;

  ///
  ///
  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  ///
  ///

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
/// [iteratorKeys], ...
/// [notContainsKey], ...
/// [putIfAbsentWhen], ...
/// [input], ...
///
/// [join], ...
/// [any], ...
/// [fold], ...
/// [reduce], ...
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
  /// [clone]
  /// [iteratorKeys]
  /// [iteratorValues]
  /// [keysSet]
  ///
  Map<K, V> get clone => Map.of(this);

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
  /// [putIfAbsentWhen]
  /// [putIfAbsentOr]
  /// [putIfAbsentThen]
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
  /// [updateThen]
  /// [updateIfNotNull]
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
  /// when calling [input], there are three conditions:
  ///   1. value set absent: return [absentReturn]
  ///   2. [value] has exist in value set: return `false`
  ///   3. [value] not yet contained in value set: return `true`
  /// see also [MapValueSet.inputSet], [Set.add]
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
  /// [joinKeys]
  /// [joinValues]
  ///
  String join([String entrySeparator = '', String separator = '']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

  String joinKeys([String separator = ', ']) => keys.join(separator);

  String joinValues([String separator = ', ']) => values.join(separator);

  ///
  /// [any]
  /// [anyKeys], [anyValues]
  ///
  bool any(Predicator<MapEntry<K, V>> test) => entries.any(test);

  bool anyKeys(Predicator<K> test) => keys.any(test);

  bool anyValues(Predicator<V> test) => values.any(test);

  ///
  /// fold, reduce
  /// [fold], [foldKeys], [foldValues]
  /// [foldByIndex]
  ///
  /// [reduce], [reduceKeys], [reduceValues]
  /// [reduceByIndex]
  /// [reduceTo], [reduceToByIndex], [reduceToByIndexInitialized]
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
  ]) =>
      entries.iterator.foldByIndex(initialValue, companion, start);

  ///
  /// [reduce], [reduceKeys], [reduceValues]
  /// [reduceByIndex]
  /// [reduceTo], [reduceToByIndex], [reduceToByIndexInitialized]
  ///
  MapEntry<K, V> reduce(Reducer<MapEntry<K, V>> reducing) =>
      entries.reduce(reducing);

  K reduceKeys(Reducer<K> reducing) => keys.reduce(reducing);

  V reduceValues(Reducer<V> reducing) => values.reduce(reducing);

  MapEntry<K, V> reduceByIndex(
    ReducerGenerator<MapEntry<K, V>> reducing, [
    int start = 0,
  ]) =>
      entries.iterator.reduceByIndex(reducing, start);

  S reduceTo<S>(Mapper<MapEntry<K, V>, S> toVal, Reducer<S> reducer) =>
      entries.iterator.reduceTo(toVal, reducer);

  S reduceToByIndex<S>(
    Mapper<MapEntry<K, V>, S> toVal,
    ReducerGenerator<S> reducing, [
    int start = 0,
  ]) =>
      entries.iterator.reduceToByIndex(toVal, reducing, start);

  S reduceToByIndexInitialized<S>(
    Mapper<MapEntry<K, V>, S> toVal,
    CompanionGenerator<S, MapEntry<K, V>> reducing, [
    int start = 0,
  ]) =>
      entries.iterator.reduceToInitializedByIndex(toVal, reducing, start);

  ///
  /// [mapKeys]
  /// [mapValues]
  ///
  Map<K, V> mapKeys(Applier<K> toVal) =>
      map((key, value) => MapEntry(toVal(key), value));

  Map<K, V> mapValues(Applier<V> toVal) =>
      map((key, value) => MapEntry(key, toVal(value)));

  ///
  /// [addAllDifference]
  ///
  void addAllDifference(Set<K> keys, V Function(K key) valuing) =>
      addAll(keys.difference(keysSet).toMap(valuing));

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

///
///
///
extension MapKeyComparable<K extends Comparable, V> on Map<K, V> {
  ///
  /// [keysSorted]
  /// [valuesBySortedKeys]
  /// [entriesBySortedKeys]
  ///
  List<K> keysSorted([bool increase = true]) => keys.toList(growable: false)
    ..sort(IteratorComparable.comparator(increase));

  List<V> valuesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).mapToList((key) => this[key]!);

  List<MapEntry<K, V>> entriesBySortedKeys([bool increase = true]) =>
      keysSorted(increase).mapToList((key) => MapEntry(key, this[key] as V));
}

///
/// [plusOn]
///
extension MapValueInt<K> on Map<K, int> {
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}

///
/// [plusOn]
///
extension MapValueDouble<K> on Map<K, double> {
  void plusOn(K key) => update(key, (value) => ++value, ifAbsent: () => 1);
}

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

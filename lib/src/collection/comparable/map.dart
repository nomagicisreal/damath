part of '../collection.dart';

///
///
/// [MapKeyComparable]
/// [MapValueInt]
/// [MapValueDouble]
/// [SplayTreeMapKeyInt]
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

///
///
///
extension SplayTreeMapKeyInt<V> on SplayTreeMap<int, V> {
  static int? toFirstKey(SplayTreeMap<int, dynamic> field) => field.firstKey();

  static int? toFirstKeyAfter(SplayTreeMap<int, dynamic> field, int key) =>
      field.firstKeyAfter(key);

  static int? toLastKey(SplayTreeMap<int, dynamic> field) => field.lastKey();

  static int? toLastKeyBefore(SplayTreeMap<int, dynamic> field, int key) =>
      field.lastKeyBefore(key);
}

extension SplayTreeMapKeyIntKeyInt<V>
    on SplayTreeMap<int, SplayTreeMap<int, V>> {
  ///
  ///
  ///
  void record<T>(
    (int, int, T) record, {
    required SplayTreeMap<int, V> Function(int keyKey, T value) newKeyKey,
    required V Function(T value) newValue,
    required void Function(V values, T) setValue,
  }) {
    final valueMap = this[record.$1];
    if (valueMap == null) {
      this[record.$1] = newKeyKey(record.$2, record.$3);
      return;
    }
    final values = valueMap[record.$2];
    if (values == null) {
      valueMap[record.$2] = newValue(record.$3);
      return;
    }
    setValue(values, record.$3);
  }

  void removeRecord<T>(
    (int, int, T) record, {
    required void Function(V values, T) clearValue,
    required Predicator<V> ensureRemove,
  }) {
    final months = this[record.$1];
    if (months == null) return;
    final days = months[record.$2];
    if (days == null) return;

    clearValue(days, record.$3);
    if (ensureRemove(days)) {
      months.remove(record.$2);
      if (months.isNotEmpty) return;
      remove(record.$2);
    }
  }

  ///
  /// [recordInts]
  /// [recordIntsKey]
  /// [recordIntsKeyKeys]
  ///
  void recordInts(
    int key,
    int keyKey,
    int begin,
    int end, {
    required SplayTreeMap<int, V> Function(int keyKey, int value) newKeyKey,
    required V Function(int value) newValue,
    required void Function(V values, int) setValue,
  }) {
    record(
      (key, keyKey, begin),
      newKeyKey: newKeyKey,
      newValue: newValue,
      setValue: setValue,
    );
    final previous = this[key]![keyKey] as V;
    for (var i = begin + 1; i <= end; i++) {
      setValue(previous, i);
    }
  }

  void recordIntsKeyKeys(
    int key,
    int begin,
    int end,
    Reducer<int> toValueBegin,
    Reducer<int> toValueEnd, {
    required SplayTreeMap<int, V> Function(int keyKey, int value) newKeyKey,
    required V Function(int value) newValue,
    required void Function(V values, int) setValue,
  }) {
    recordInts(
      key,
      begin,
      toValueBegin(key, begin),
      toValueEnd(key, end),
      newKeyKey: newKeyKey,
      newValue: newValue,
      setValue: setValue,
    );
    for (var j = begin + 1; j <= end; j++) {
      recordInts(
        key,
        j,
        toValueBegin(key, j),
        toValueEnd(key, j),
        newKeyKey: newKeyKey,
        newValue: newValue,
        setValue: setValue,
      );
    }
  }

  void recordIntsKey(
    int begin,
    int end,
    Applier<int> toKeyKeyBegin,
    Applier<int> toKeyKeyEnd,
    Reducer<int> toValueBegin,
    Reducer<int> toValueEnd, {
    required SplayTreeMap<int, V> Function(int keyKey, int value) newKeyKey,
    required V Function(int value) newValue,
    required void Function(V values, int) setValue,
  }) {
    recordIntsKeyKeys(
      begin,
      toKeyKeyBegin(begin),
      toKeyKeyEnd(begin),
      toValueBegin,
      toValueEnd,
      newKeyKey: newKeyKey,
      newValue: newValue,
      setValue: setValue,
    );
    for (var key = begin + 1; key <= end; key++) {
      recordIntsKeyKeys(
        key,
        toKeyKeyBegin(key),
        toKeyKeyEnd(key),
        toValueBegin,
        toValueEnd,
        newKeyKey: newKeyKey,
        newValue: newValue,
        setValue: setValue,
      );
    }
  }
}

part of '../collection.dart';

///
///
/// [MapKeyComparable]
/// [MapValueInt]
/// [MapValueDouble]
/// [SplayTreeMapKeyInt]
///
/// [SplayTreeMapIntIntInt]
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

///
///
///
class SplayTreeMapIntIntInt<V> {
  final SplayTreeMap<int, SplayTreeMap<int, V>> field;
  final void Function(int value, V values) setValue;
  final void Function(int value, V values) clearValue;
  final bool Function(V values) ensureRemove;
  final V Function(int value) newValue;
  final SplayTreeMap<int, V> Function(int key, int keyKey, int value) newKeyKey;
  final Applier<int> toKeyKeyBegin;
  final Applier<int> toKeyKeyLimit;
  final Reducer<int> toValueBegin;
  final Reducer<int> toValueLimit;
  late final BiCallback<(int, int, int)> includesRange;
  late final BiCallback<(int, int, int)> excludesRange;

  SplayTreeMapIntIntInt(
    this.field, {
    required this.setValue,
    required this.clearValue,
    required this.ensureRemove,
    required this.newValue,
    required this.newKeyKey,
    required this.toKeyKeyBegin,
    required this.toKeyKeyLimit,
    required this.toValueBegin,
    required this.toValueLimit,
  }) {
    includesRange = Record3Int.biCallbackFrom(
      setRecord,
      toKeyKeyBegin,
      toKeyKeyLimit,
      toValueBegin,
      toValueLimit,
    );
    excludesRange = Record3Int.biCallbackFrom(
      setRecord,
      toKeyKeyBegin,
      toKeyKeyLimit,
      toValueBegin,
      toValueLimit,
    );
  }

  ///
  ///
  ///
  void setRecord(int a, int b, int c) {
    final valueMap = field[a];
    if (valueMap == null) {
      field[a] = newKeyKey(a, b, c);
      return;
    }
    final values = valueMap[b];
    if (values == null) {
      valueMap[b] = newValue(c);
      return;
    }
    setValue(c, values);
  }

  void removeRecord(int a, int b, int c) {
    final months = field[a];
    if (months == null) return;
    final days = months[b];
    if (days == null) return;

    clearValue(c, days);
    if (ensureRemove(days)) {
      months.remove(b);
      if (months.isNotEmpty) return;
      field.remove(b);
    }
  }

  ///
  /// [setRecordInts]
  /// [setRecordIntsKey]
  /// [setRecordIntsKeyKeys]
  ///
  void setRecordInts(int key, int keyKey, int? begin, int? end) {
    begin ??= toValueBegin(key, keyKey);
    end ??= toValueLimit(key, keyKey);
    setRecord(key, keyKey, begin);
    final values = field[key]![keyKey] as V;
    for (var p = begin + 1; p < end; p++) {
      setValue(p, values);
    }
  }

  void setRecordIntsKeyKeys(int key, int? begin, int? end) {
    begin ??= toKeyKeyBegin(key);
    end ??= toKeyKeyLimit(key);
    setRecordInts(key, begin, toValueBegin(key, begin), toValueLimit(key, end));
    for (var j = begin + 1; j < end; j++) {
      setRecordInts(key, j, toValueBegin(key, j), toValueLimit(key, j));
    }
  }

  void setRecordIntsKey(int begin, int limit) {
    for (var key = begin; key < limit; key++) {
      setRecordIntsKeyKeys(key, toKeyKeyBegin(key), toKeyKeyLimit(key));
    }
  }

  void clear() => field.clear();
}

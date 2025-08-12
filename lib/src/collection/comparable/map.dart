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
  final Applier<int> toKeyKeyEnd;
  final Reducer<int> toValueBegin;
  final Reducer<int> toValueEnd;

  SplayTreeMapIntIntInt(
    this.field, {
    required this.setValue,
    required this.clearValue,
    required this.ensureRemove,
    required this.newValue,
    required this.newKeyKey,
    required this.toKeyKeyBegin,
    required this.toKeyKeyEnd,
    required this.toValueBegin,
    required this.toValueEnd,
  });

  ///
  ///
  ///
  void setRecord((int, int, int) record) {
    final valueMap = field[record.$1];
    if (valueMap == null) {
      field[record.$1] = newKeyKey(record.$1, record.$2, record.$3);
      return;
    }
    final values = valueMap[record.$2];
    if (values == null) {
      valueMap[record.$2] = newValue(record.$3);
      return;
    }
    setValue(record.$3, values);
  }

  void removeRecord((int, int, int) record) {
    final months = field[record.$1];
    if (months == null) return;
    final days = months[record.$2];
    if (days == null) return;

    clearValue(record.$3,days);
    if (ensureRemove(days)) {
      months.remove(record.$2);
      if (months.isNotEmpty) return;
      field.remove(record.$2);
    }
  }

  ///
  /// [setRecordInts]
  /// [setRecordIntsKey]
  /// [setRecordIntsKeyKeys]
  ///
  void setRecordInts(int key, int keyKey, int? begin, int? end) {
    begin ??= toValueBegin(key, keyKey);
    end ??= toValueEnd(key, keyKey);
    setRecord((key, keyKey, begin));
    final values = field[key]![keyKey] as V;
    for (var p = begin + 1; p <= end; p++) {
      setValue(p, values);
    }
  }

  void setRecordIntsKeyKeys(int key, int? begin, int? end) {
    begin ??= toKeyKeyBegin(key);
    end ??= toKeyKeyEnd(key);
    setRecordInts(key, begin, toValueBegin(key, begin), toValueEnd(key, end));
    for (var j = begin + 1; j <= end; j++) {
      setRecordInts(key, j, toValueBegin(key, j), toValueEnd(key, j));
    }
  }

  void setRecordIntsKey(int begin, int end) {
    for (var key = begin; key <= end; key++) {
      setRecordIntsKeyKeys(key, toKeyKeyBegin(key), toKeyKeyEnd(key));
    }
  }

  void clear() => field.clear();
}

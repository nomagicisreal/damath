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

  ///
  ///
  ///
  bool operator []((int, int, int) index) {
    assert(index.isValidDate);
    final months = field[index.$1];
    if (months == null) return false;
    final days = months[index.$2];
    if (days == null) return false;
    throw UnimplementedError();
    // return days[0] >> index.$3 - 1 == 1;
  }

  void operator []=((int, int, int) index, bool value) {
    assert(index.isValidDate);
    value
        ? setRecord(index.$1, index.$2, index.$3)
        : removeRecord(index.$1, index.$2, index.$3);
  }

  void clear() => field.clear();

  ///
  ///
  /// [_errorEmptyFlagsNotRemoved], [_excluding]
  /// [_findKey], [_findKeyKey], [_findFlag]
  /// [_findEntryInKey], [_findEntryNearBy]
  ///
  ///
  ///
  // static StateError _errorEmptyFlagsNotRemoved(int key, int keyKey) =>
  //     StateError('empty flags key: ($key, $keyKey) should be removed');
  //
  // static bool _excluding(TypedDataList<int> list) {
  //   final length = list.length;
  //   for (var j = 0; j < length; j++) {
  //     if (list[j] != 0) return false;
  //   }
  //   return true;
  // }
  //
  // int? _findKey(_MapperSplayTreeMapInt toKey) => toKey(field);
  //
  // (int, int)? _findKeyKey(_MapperSplayTreeMapInt toKey) {
  //   final field = this.field;
  //   final key = toKey(field);
  //   if (key == null) return null;
  //   return (key, toKey(field[key]!)!);
  // }
  //
  // (int, int, int)? _findFlag(
  //   _MapperSplayTreeMapInt toKey,
  //   _BitsListToInt toBits,
  // ) {
  //   final field = this.field;
  //   final key = toKey(field);
  //   if (key == null) return null;
  //   final valueMap = field[key]!;
  //   final keyKey = toKey(valueMap)!;
  //   final value = toBits(valueMap[keyKey]!, _sizeEach);
  //   if (value != null) return (key, keyKey, value);
  //   throw _errorEmptyFlagsNotRemoved(key, keyKey);
  // }
  //
  // ///
  // /// [_findEntryInKey]
  // /// [_findEntryNearBy]
  // ///
  // (int, int, int)? _findEntryInKey(
  //   int key,
  //   _MapperSplayTreeMapInt toKey,
  //   _BitsListToInt toPosition,
  // ) {
  //   final valueMap = field[key];
  //   if (valueMap == null) return null;
  //   final keyKey = toKey(valueMap)!;
  //   final value = toPosition(valueMap[keyKey]!, _sizeEach);
  //   if (value != null) return (key, keyKey, value);
  //   throw _errorEmptyFlagsNotRemoved(key, keyKey);
  // }
  //
  // (int, int, int)? _findEntryNearBy(
  //   (int, int, int) record,
  //   _MapperSplayTreeMapInt toKey,
  //   _MapperSplayTreeMapIntBy toKeyBy,
  //   PredicatorReducer<int> predicate,
  //   _BitsListToInt toPosition,
  //   _BitsListToIntFrom toPositionFrom,
  // ) {
  //   final field = this.field;
  //   var key = toKey(field);
  //   if (key == null) return null;
  //
  //   // recent key > a || latest key < a
  //   final a = record.$1;
  //   if (predicate(key, a)) return _findEntryInKey(key, toKey, toPosition);
  //
  //   // recent keyKey > b || latest keyKey < b
  //   if (key == a) {
  //     final b = record.$2;
  //     final valueMap = field[a]!;
  //     int? keyKey = toKey(valueMap)!;
  //     if (predicate(keyKey, b)) {
  //       return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
  //     }
  //
  //     // recent value > c || latest value < c
  //     if (keyKey == b) {
  //       final c = record.$3;
  //       final value = toPositionFrom(valueMap[b]!, c, _sizeEach);
  //       if (value != null) return (a, b, value);
  //     }
  //
  //     // next keyKey > b || previous keyKey < b
  //     keyKey = toKeyBy(valueMap, b);
  //     if (keyKey != null) {
  //       return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
  //     }
  //   }
  //
  //   // next key > a || previous keyKey < a
  //   key = toKeyBy(field, a);
  //   if (key != null) return _findEntryInKey(key, toKey, toPosition);
  //
  //   return null;
  // }
}

// typedef _MapperSplayTreeMapInt<T> = int? Function(SplayTreeMap<int, T> map);
// typedef _MapperSplayTreeMapIntBy<T> =
//     int? Function(SplayTreeMap<int, T> map, int by);
//
// typedef _BitsListToInt = int? Function(TypedDataList<int> list, int size);
// typedef _BitsListToIntFrom =
//     int? Function(TypedDataList<int> list, int k, int size);

part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [_MapperSplayTreeMapInt], ...
/// [_SplayTreeMapIntIntTypedInt]
///
/// [_PFieldMapSplay]
/// [FieldMapDate]
/// [FieldMapHourDate]
/// todo: extract functions from this file, remove map utils
///
///

///
///
///
typedef _MapperSplayTreeMapInt<T> = int? Function(SplayTreeMap<int, T> map);
typedef _MapperSplayTreeMapIntBy<T> =
int? Function(SplayTreeMap<int, T> map, int by);

typedef _BitsListToInt = int? Function(TypedDataList<int> list, int size);
typedef _BitsListToIntFrom =
int? Function(TypedDataList<int> list, int k, int size);

///
///
///
extension _SplayTreeMapIntIntTypedInt<T extends TypedDataList<int>>
on SplayTreeMap<int, SplayTreeMap<int, T>> {
  ///
  /// [_valuesAvailable]
  ///
  Iterable<int> _valuesAvailable(int sizeEach, int key, int keyKey) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapPAvailable(sizeEach, FKeep.applier);
  }

  ///
  /// [_records], [_recordsInKey], [_recordsInKeyKey]
  /// [_recordsWithinKeyKey]
  /// [_recordsWithin]
  /// [_recordsWithinValues]
  ///
  ///

  ///
  /// [_records]
  /// [_recordsInKey]
  /// [_recordsInKeyKey]
  ///
  Iterable<(int, int, int)> _records(int sizeEach) sync* {
    for (var eA in entries) {
      final key = eA.key;
      for (var eB in eA.value.entries) {
        final keyKey = eB.key;
        yield* eB.value.mapPAvailable(sizeEach, (v) => (key, keyKey, v));
      }
    }
  }

  Iterable<(int, int, int)> _recordsInKey(int sizeEach, int key) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    for (var entry in valueMap.entries) {
      final keyKey = entry.key;
      yield* entry.value.mapPAvailable(sizeEach, (v) => (key, keyKey, v));
    }
  }

  Iterable<(int, int, int)> _recordsInKeyKey(
      int sizeEach,
      int key,
      int keyKey,
      ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapPAvailable(sizeEach, (v) => (key, keyKey, v));
  }

  ///
  /// [_recordsWithinValues]
  /// [_recordsWithinKeyKey]
  /// [_recordsWithin]
  ///
  Iterable<(int, int, int)> _recordsWithinValues(
      int sizeEach,
      int key,
      int keyKey,
      int? begin,
      int? end,
      ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapPAvailableBetween(
      sizeEach,
      begin,
      end,
          (v) => (key, keyKey, v),
    );
  }

  Iterable<(int, int, int)> _recordsWithinKeyKey(
      int sizeEach,
      int key,
      int begin,
      int end,
      ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    for (
    int? keyKey = begin;
    keyKey != null && keyKey <= end;
    keyKey = valueMap.firstKeyAfter(keyKey)
    ) {
      final values = valueMap[keyKey]!;
      yield* values.mapPAvailable(sizeEach, (v) => (key, keyKey!, v));
    }
  }

  Iterable<(int, int, int)> _recordsWithinKey(
      int sizeEach,
      int begin,
      int end,
      ) sync* {
    for (
    int? key = begin;
    key != null && key <= end;
    key = firstKeyAfter(key)
    ) {
      final valueMap = this[key]!;
      for (var entry in valueMap.entries) {
        final keyKey = entry.key;
        yield* entry.value.mapPAvailable(sizeEach, (v) => (key!, keyKey, v));
      }
    }
  }

  Iterable<(int, int, int)> _recordsWithin(
      int sizeEach,
      (int, int, int) begin,
      (int, int, int) end,
      ) sync* {
    final keyBegin = begin.$1;
    final keyEnd = end.$1;
    assert(keyBegin <= keyEnd);

    final keyKeyBegin = begin.$2;
    final keyKeyEnd = end.$2;
    final valueBegin = begin.$3;
    final valueEnd = end.$3;

    // ==
    if (keyEnd == keyBegin) {
      assert(keyKeyBegin <= keyKeyEnd);

      // ==
      if (keyKeyBegin == keyKeyEnd) {
        assert(valueBegin <= valueEnd);
        yield* _recordsWithinValues(
          sizeEach,
          keyBegin,
          keyKeyBegin,
          valueBegin,
          valueEnd,
        );
        return;
      }

      // <
      final valueMap = this[keyBegin];
      if (valueMap == null) return;

      // keyKey begin
      var values = valueMap[keyKeyBegin];
      if (values != null) {
        yield* values.mapPAvailableFrom(
          sizeEach,
          valueBegin,
              (v) => (keyBegin, keyKeyBegin, v),
        );
      }

      // keyKeys between
      for (
      var keyKey = valueMap.firstKeyAfter(keyKeyBegin);
      keyKey != null && keyKey < keyKeyEnd;
      keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapPAvailable(
          sizeEach,
              (v) => (keyBegin, keyKey!, v),
        );
      }

      // keyKey end
      values = valueMap[keyKeyEnd];
      if (values != null) {
        yield* values.mapPAvailableTo(
          sizeEach,
          valueEnd,
              (v) => (keyBegin, keyKeyEnd, v),
        );
      }
      return;
    }

    // <
    // key begin
    var valueMap = this[keyBegin];
    if (valueMap != null) {
      final values = valueMap[keyKeyBegin];
      if (values != null) {
        yield* values.mapPAvailableFrom(
          sizeEach,
          valueBegin,
              (v) => (keyBegin, keyKeyBegin, v),
        );
      }
      for (
      var keyKey = valueMap.firstKeyAfter(keyKeyBegin);
      keyKey != null;
      keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapPAvailable(
          sizeEach,
              (v) => (keyBegin, keyKey!, v),
        );
      }
    }

    // keys between
    for (
    var key = firstKeyAfter(keyBegin);
    key != null && key < keyEnd;
    key = firstKeyAfter(key)
    ) {
      valueMap = this[key]!;
      for (
      var keyKey = valueMap.firstKey();
      keyKey != null;
      keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapPAvailable(
          sizeEach,
              (v) => (key!, keyKey!, v),
        );
      }
    }

    // key end
    valueMap = this[keyEnd];
    if (valueMap != null) {
      for (
      var keyKey = valueMap.firstKey();
      keyKey != null && keyKey < keyKeyEnd;
      keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapPAvailable(
          sizeEach,
              (v) => (keyEnd, keyKey!, v),
        );
      }
      final values = valueMap[keyKeyEnd];
      if (values == null) return;
      yield* values.mapPAvailableTo(
        sizeEach,
        valueEnd,
            (v) => (keyEnd, keyKeyEnd, v),
      );
    }
  }
}


///
///
///

///
///
/// [_errorEmptyFlagsNotRemoved], ...
/// [_findKey], ...
///
///
sealed class _PFieldMapSplay
    with _MBitsFlagsField
    implements _AFieldIdentical, _AFlagsContainer<(int, int, int), bool> {
  ///
  /// [_map], [_field]
  /// [_errorEmptyFlagsNotRemoved]
  /// [_excluding]
  ///
  late final SplayTreeMapIntIntInt<TypedDataList<int>> _map;

  SplayTreeMap<int, SplayTreeMap<int, TypedDataList<int>>> get _field =>
      _map.field;

  static StateError _errorEmptyFlagsNotRemoved(int key, int keyKey) =>
      StateError('empty flags key: ($key, $keyKey) should be removed');

  static bool _excluding(TypedDataList<int> list) {
    final length = list.length;
    for (var j = 0; j < length; j++) {
      if (list[j] != 0) return false;
    }
    return true;
  }

  _PFieldMapSplay.empty({
    bool Function(dynamic potentialKey)? isValidKey,
    int Function(int, int)? compareKeyKey,
    bool Function(dynamic)? Function(int)? isValidKeyKey,
    required int Function(int) toKeyKeyBegin,
    required int Function(int) toKeyKeyEnd,
    required int Function(int, int) toValueBegin,
    required int Function(int, int) toValueEnd,
  }) {
    final bool Function(dynamic)? Function(int) validate =
        isValidKeyKey ?? (_) => null;
    SplayTreeMap<int, TypedDataList<int>> newKeyKey(
      int key,
      int keyKey,
      int value,
    ) =>
        SplayTreeMap(compareKeyKey, validate(key))
          ..[keyKey] = _bitSetNewField(value);

    _map = SplayTreeMapIntIntInt(
      SplayTreeMap(Comparable.compare, isValidKey),
      setValue: _bitSet,
      clearValue: _bitClear,
      ensureRemove: _excluding,
      newValue: _bitSetNewField,
      newKeyKey: newKeyKey,
      toKeyKeyBegin: toKeyKeyBegin,
      toKeyKeyLimit: toKeyKeyEnd,
      toValueBegin: toValueBegin,
      toValueLimit: toValueEnd,
    );
  }

  ///
  ///
  ///
  @override
  bool operator []((int, int, int) index) {
    assert(index.isValidDate);
    final months = _map.field[index.$1];
    if (months == null) return false;
    final days = months[index.$2];
    if (days == null) return false;
    return days[0] >> index.$3 - 1 == 1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(index.isValidDate);
    value
        ? _map.setRecord(index.$1, index.$2, index.$3)
        : _map.removeRecord(index.$1, index.$2, index.$3);
  }

  @override
  void clear() => _map.clear();

  @override
  bool get isEmpty => _map.field.isEmpty;

  @override
  bool get isNotEmpty => _map.field.isNotEmpty;

  ///
  ///
  /// [_findKey], [_findKeyKey], [_findFlag]
  /// [_findEntryInKey], [_findEntryNearBy]
  ///
  ///

  ///
  /// [_findKey]
  /// [_findKeyKey]
  /// [_findFlag]
  ///
  int? _findKey(_MapperSplayTreeMapInt toKey) => toKey(_map.field);

  (int, int)? _findKeyKey(_MapperSplayTreeMapInt toKey) {
    final field = _map.field;
    final key = toKey(field);
    if (key == null) return null;
    return (key, toKey(field[key]!)!);
  }

  (int, int, int)? _findFlag(
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt toBits,
  ) {
    final field = _map.field;
    final key = toKey(field);
    if (key == null) return null;
    final valueMap = field[key]!;
    final keyKey = toKey(valueMap)!;
    final value = toBits(valueMap[keyKey]!, _sizeEach);
    if (value != null) return (key, keyKey, value);
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  ///
  /// [_findEntryInKey]
  /// [_findEntryNearBy]
  ///
  (int, int, int)? _findEntryInKey(
    int key,
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt toPosition,
  ) {
    final valueMap = _map.field[key];
    if (valueMap == null) return null;
    final keyKey = toKey(valueMap)!;
    final value = toPosition(valueMap[keyKey]!, _sizeEach);
    if (value != null) return (key, keyKey, value);
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  (int, int, int)? _findEntryNearBy(
    (int, int, int) record,
    _MapperSplayTreeMapInt toKey,
    _MapperSplayTreeMapIntBy toKeyBy,
    PredicatorReducer<int> predicate,
    _BitsListToInt toPosition,
    _BitsListToIntFrom toPositionFrom,
  ) {
    final field = _map.field;
    var key = toKey(field);
    if (key == null) return null;

    // recent key > a || latest key < a
    final a = record.$1;
    if (predicate(key, a)) return _findEntryInKey(key, toKey, toPosition);

    // recent keyKey > b || latest keyKey < b
    if (key == a) {
      final b = record.$2;
      final valueMap = field[a]!;
      int? keyKey = toKey(valueMap)!;
      if (predicate(keyKey, b)) {
        return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
      }

      // recent value > c || latest value < c
      if (keyKey == b) {
        final c = record.$3;
        final value = toPositionFrom(valueMap[b]!, c, _sizeEach);
        if (value != null) return (a, b, value);
      }

      // next keyKey > b || previous keyKey < b
      keyKey = toKeyBy(valueMap, b);
      if (keyKey != null) {
        return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
      }
    }

    // next key > a || previous keyKey < a
    key = toKeyBy(field, a);
    if (key != null) return _findEntryInKey(key, toKey, toPosition);

    return null;
  }
}

///
///
/// [yearsAvailable], ...
///
///
class FieldMapDate extends _PFieldMapSplay with _MFlagsO32 {
  FieldMapDate.empty()
    : super.empty(
        isValidKeyKey: DateTimeExtension.isValidMonthDynamicOf,
        toKeyKeyBegin: DateTimeExtension.apply_monthBegin,
        toKeyKeyEnd: DateTimeExtension.apply_monthEnd,
        toValueBegin: IntExtension.reduce_1,
        toValueEnd: DateTimeExtension.monthDaysOf,
      );

  ///
  ///
  /// [firstDateAfter]
  /// [lastDateBefore]
  ///
  ///
  (int, int, int)? firstDateAfter((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedIntList.getPFirst1,
    TypedIntList.getPFirst1From,
  );

  (int, int, int)? lastDateBefore((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_less,
    TypedIntList.getPLast1,
    TypedIntList.getPLast1From,
  );

  ///
  ///
  /// [datesWithinDays], [datesWithinMonths], [datesWithinYears]
  ///
  ///
  Iterable<(int, int, int)> datesWithinDays(
    int year,
    int month,
    int begin,
    int end,
  ) => _field._recordsWithinValues(_sizeEach, year, month, begin, end);

  Iterable<(int, int, int)> datesWithinMonths(int year, int begin, int end) =>
      _field._recordsWithinKeyKey(_sizeEach, year, begin, end);

  Iterable<(int, int, int)> datesWithinYears(int begin, int end) =>
      _field._recordsWithinKey(_sizeEach, begin, end);

  Iterable<(int, int, int)> datesWithin(
    (int, int, int) begin,
    (int, int, int) end,
  ) => _field._recordsWithin(_sizeEach, begin, end);

  ///
  ///
  ///
  @override
  bool validateIndex((int, int, int) index) => index.isValidDate;

  @override
  Uint32List get _newField => Uint32List(1);
}

///
///
///
class FieldMapHourDate extends _PFieldMapSplay {
  final int year;

  FieldMapHourDate.emptyOn(this.year)
    : super.empty(
        isValidKey: DateTimeExtension.isValidMonthDynamicOf(year),
        isValidKeyKey: DateTimeExtension.isValidDaysDynamicOf(year),
        toKeyKeyBegin: IntExtension.apply_1,
        toKeyKeyEnd: DateTimeExtension.applier_daysEnd(year),
        toValueBegin: DateTimeExtension.reducer_hourBegin,
        toValueEnd: DateTimeExtension.reducer_hourEnd,
      );

  FieldMapHourDate.empty() : this.emptyOn(DateTime.now().year);

  ///
  /// [firstMonth], [firstDate], [firstHour]
  /// [lastMonth], [lastDate], [lastHour]
  /// [firstDayInMonth], [firstHourAfter]
  /// [lastDayInMonth], [lastHourBefore]
  ///
  int? get firstMonth => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstDate => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int, int)? get firstHour =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedIntList.getPFirst1);

  int? get lastMonth => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastDate => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get lastHour =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedIntList.getPLast1);

  (int, int, int)? firstDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toFirstKey,
    TypedIntList.getPLast1,
  );

  (int, int, int)? firstHourAfter((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedIntList.getPFirst1,
    TypedIntList.getPFirst1From,
  );

  (int, int, int)? lastDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toLastKey,
    TypedIntList.getPLast1,
  );

  (int, int, int)? lastHourBefore((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_larger,
    TypedIntList.getPLast1,
    TypedIntList.getPFirst1From,
  );

  ///
  ///
  /// [monthsAvailable], [daysAvailable], [hoursAvailable]
  /// [hours], [hoursInMonth], [hoursInDay]
  /// [hoursWithinMonths], [hoursWithinDays], [hoursWithin]
  ///
  ///

  //
  Iterable<int> get monthsAvailable => _field.keys;

  Iterable<int>? daysAvailable(int month) => _field[month]?.keys;

  Iterable<int> hoursAvailable(int month, int day) =>
      _field._valuesAvailable(_sizeEach, month, day);

  //
  Iterable<(int, int, int)> get hours => _field._records(_sizeEach);

  Iterable<(int, int, int)> hoursInMonth(int month) =>
      _field._recordsInKey(_sizeEach, month);

  Iterable<(int, int, int)> hoursInDay(int month, int day) =>
      _field._recordsInKeyKey(_sizeEach, month, day);

  //
  Iterable<(int, int, int)> hoursWithinMonths(int begin, int end) =>
      _field._recordsWithinKey(_sizeEach, begin, end);

  Iterable<(int, int, int)> hoursWithinDays(int month, int begin, int end) =>
      _field._recordsWithinKeyKey(_sizeEach, month, begin, end);

  Iterable<(int, int, int)> hoursWithin(
    (int, int, int) begin,
    (int, int, int) end,
  ) => _field._recordsWithin(_sizeEach, begin, end);

  ///
  ///
  ///
  @override
  int get _sizeEach => TypedIntList.sizeEach8 * 3;

  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  bool validateIndex((int, int, int) index) {
    final month = index.$1;
    return DateTimeExtension.isValidMonth(month) &&
        DateTimeExtension.isValidDay(year, month, index.$2) &&
        DateTimeExtension.isValidHour(index.$3);
  }

  @override
  Uint8List get _newField => Uint8List(3);
}

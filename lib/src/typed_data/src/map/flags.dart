part of '../../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [_FlagsParentMapSplay]
/// [FlagsMapDate]
/// [FlagsMapHourDate]
///
///
///

///
///
/// [_bufferApplyField], ...
/// [_errorEmptyFlagsNotRemoved], ...
/// [_findKey], ...
///
///
abstract class _FlagsParentMapSplay
    with _MixinFlagsInsertAble
    implements _FlagsContainer<(int, int, int)> {
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

  _FlagsParentMapSplay.empty({
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
          ..[keyKey] = _newInsertion(value);

    _map = SplayTreeMapIntIntInt(
      SplayTreeMap(Comparable.compare, isValidKey),
      setValue: _mutateBitSet,
      clearValue: _mutateBitClear,
      ensureRemove: _excluding,
      newValue: _newInsertion,
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

  ///
  ///
  ///
  int get _toStringFieldTitleLength;

  void _bufferApplyField(
    StringBuffer buffer,
    int key,
    int keyKey,
    TypedDataList<int> values,
  );

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
    final pad = _toStringFieldTitleLength;
    for (var entry in _map.field.entries) {
      final key = entry.key;
      buffer.write('|');
      buffer.write('($key'.padLeft(pad));
      buffer.write(',');
      var padding = false;
      for (var valueEntry in entry.value.entries) {
        if (padding) {
          buffer.write('|');
          buffer.writeRepeat(pad + 1, ' ');
        } else {
          padding = true;
        }
        final keyKey = valueEntry.key;
        buffer.write('$keyKey)'.padLeft(4));
        buffer.write(' : ');
        _bufferApplyField(buffer, key, keyKey, valueEntry.value);
        buffer.writeln();
      }
    }
  }
}

///
///
/// [FlagsMapDate.empty]
/// [includesRange], ...
/// [firstYear], ...
/// [yearsAvailable], ...
///
///
class FlagsMapDate extends _FlagsParentMapSplay with _MixinFlagsOperate32 {
  FlagsMapDate.empty()
    : super.empty(
        isValidKeyKey: DateTimeExtension.isValidMonthDynamicOf,
        toKeyKeyBegin: DateTimeExtension.apply_monthBegin,
        toKeyKeyEnd: DateTimeExtension.apply_monthEnd,
        toValueBegin: IntExtension.reduce_1,
        toValueEnd: DateTimeExtension.monthDaysOf,
      );

  factory FlagsMapDate.from((int, int, int) date) {
    assert(date.isValidDate);
    return FlagsMapDate.empty()..[date] = true;
  }

  factory FlagsMapDate.fromIterable(Iterable<(int, int, int)> iterable) =>
      iterable.iterator.inductInited(FlagsMapDate.from, (flags, date) {
        assert(date.isValidDate);
        return flags..[date] = true;
      });

  ///
  ///
  /// [firstYear], [firstMonth], [lastYear], [lastMonth]
  /// [firstDate], [lastDate]
  /// [firstDateInYear], [firstDateAfter]
  /// [lastDateInYear], [lastDateBefore]
  ///
  ///
  int? get firstYear => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstMonth => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  int? get lastYear => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastMonth => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get firstDate =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedIntList.getBitFirst1);

  (int, int, int)? get lastDate =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedIntList.getBitLast1);

  (int, int, int)? firstDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toFirstKey,
    TypedIntList.getBitLast1,
  );

  (int, int, int)? firstDateAfter((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedIntList.getBitFirst1,
    TypedIntList.getBitFirst1From,
  );

  (int, int, int)? lastDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toLastKey,
    TypedIntList.getBitLast1,
  );

  (int, int, int)? lastDateBefore((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_less,
    TypedIntList.getBitLast1,
    TypedIntList.getBitLast1From,
  );

  ///
  ///
  /// [yearsAvailable], [monthsAvailable], [daysAvailable]
  /// [dates], [datesInYear], [datesInMonth]
  /// [datesWithinDays], [datesWithinMonths], [datesWithinYears]
  ///
  ///

  //
  Iterable<int> get yearsAvailable => _field.keys;

  Iterable<int>? monthsAvailable(int year) => _field[year]?.keys;

  Iterable<int> daysAvailable(int year, int month) =>
      _field._valuesAvailable(_sizeEach, year, month);

  //
  Iterable<(int, int, int)> get dates => _field._records(_sizeEach);

  Iterable<(int, int, int)> datesInYear(int year) =>
      _field._recordsInKey(_sizeEach, year);

  Iterable<(int, int, int)> datesInMonth(int year, int month) =>
      _field._recordsInKeyKey(_sizeEach, year, month);

  //
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
  Uint32List get _newList => Uint32List(1);

  @override
  int get _toStringFieldTitleLength => 6; // for '([year]'

  @override
  int get _toStringFieldBorderLength => 15 + 32 + 4;

  @override
  void _bufferApplyField(
    StringBuffer buffer,
    int year,
    int month,
    TypedDataList<int> values,
  ) => buffer.writeBitsOfMonth(
    values[0],
    DateTimeExtension.monthDaysOf(year, month),
  );
}

///
///
///
class FlagsMapHourDate extends _FlagsParentMapSplay {
  final int year;

  FlagsMapHourDate.emptyOn(this.year)
    : super.empty(
        isValidKey: DateTimeExtension.isValidMonthDynamicOf(year),
        isValidKeyKey: DateTimeExtension.isValidDaysDynamicOf(year),
        toKeyKeyBegin: IntExtension.apply_1,
        toKeyKeyEnd: DateTimeExtension.applier_daysEnd(year),
        toValueBegin: DateTimeExtension.reducer_hourBegin,
        toValueEnd: DateTimeExtension.reducer_hourEnd,
      );

  FlagsMapHourDate.empty() : this.emptyOn(DateTime.now().year);

  ///
  /// [firstMonth], [firstDate], [firstHour]
  /// [lastMonth], [lastDate], [lastHour]
  /// [firstDayInMonth], [firstHourAfter]
  /// [lastDayInMonth], [lastHourBefore]
  ///
  int? get firstMonth => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstDate => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int, int)? get firstHour =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedIntList.getBitFirst1);

  int? get lastMonth => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastDate => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get lastHour =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedIntList.getBitLast1);

  (int, int, int)? firstDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toFirstKey,
    TypedIntList.getBitLast1,
  );

  (int, int, int)? firstHourAfter((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedIntList.getBitFirst1,
    TypedIntList.getBitFirst1From,
  );

  (int, int, int)? lastDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toLastKey,
    TypedIntList.getBitLast1,
  );

  (int, int, int)? lastHourBefore((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_larger,
    TypedIntList.getBitLast1,
    TypedIntList.getBitFirst1From,
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
        DateTimeExtension.isValidDays(year, month, index.$2) &&
        DateTimeExtension.isValidHour(index.$3);
  }

  @override
  Uint8List get _newList => Uint8List(3);

  @override
  int get _toStringFieldTitleLength => 4; // for '([month]'

  @override
  int get _toStringFieldBorderLength =>
      _toStringFieldTitleLength + 5 + 3 + 32 + 4;

  @override
  void _bufferApplyField(
    StringBuffer buffer,
    int key,
    int keyKey,
    TypedDataList<int> values,
  ) {
    final size = TypedIntList.sizeEach8;
    for (var j = 0; j < 3; j++) {
      var i = 0;
      var bits = values[j];
      while (i < size) {
        buffer.writeBit(bits);
        bits >>= 1;
        i++;
      }
      buffer.write(' ');
    }
  }
}

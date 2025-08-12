part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FlagsDateMap]
/// [FlagsHourMonthMap]
/// [FlagsHourWeekdayMap]
/// [FlagsADay]
///   --[_FlagsADayOf8]
///   --[_FlagsADayOf16]
///
///
///

///
///
/// [FlagsMapDate.empty]
/// [include], ...
/// [firstYear], ...
/// [yearsAvailable], ...
///
///
class FlagsDateMap extends _FlagsSplayIndexIndex<Uint32List>
    with _MixinFlagsOperatableOf32 {
  FlagsDateMap.empty()
    : super.empty(
        isValidKeyKey: DateTimeExtension.isValidMonthDynamicOf,
        toKeyKeyBegin: DateTimeExtension.apply_monthBegin,
        toKeyKeyEnd: DateTimeExtension.apply_monthEnd,
        toValueBegin: IntExtension.reduce_1,
        toValueEnd: DateTimeExtension.monthDaysOf,
      );

  factory FlagsDateMap.from((int, int, int) date) =>
      FlagsDateMap.empty()..include(date);

  factory FlagsDateMap.fromIterable(Iterable<(int, int, int)> iterable) =>
      iterable.iterator.inductInited(
        FlagsDateMap.from,
        (flags, date) => flags..include(date),
      );

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
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedDataListInt.getBitFirst1);

  (int, int, int)? get lastDate =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedDataListInt.getBitLast1);

  (int, int, int)? firstDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toFirstKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? firstDateAfter((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitFirst1,
    TypedDataListInt.getBitFirst1From,
  );

  (int, int, int)? lastDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toLastKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? lastDateBefore((int, int, int) date) => _findEntryNearBy(
    date,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_less,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitLast1From,
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
    TypedDataList<int> value,
  ) => buffer.writeBitsOfMonth(
    value[0],
    DateTimeExtension.monthDaysOf(year, month),
  );
}

///
///
///
class FlagsHourMonthMap extends _FlagsSplayIndexIndex<Uint8List>
    with _MixinFlagsInsertableHoursADay {
  FlagsHourMonthMap.emptyOn(int year)
    : super.empty(
        isValidKey: DateTimeExtension.isValidMonthDynamicOf(year),
        isValidKeyKey: DateTimeExtension.isValidDaysDynamicOf(year),
        toKeyKeyBegin: IntExtension.apply_1,
        toKeyKeyEnd: DateTimeExtension.applier_daysEnd(year),
        toValueBegin: DateTimeExtension.reducer_hourBegin,
        toValueEnd: DateTimeExtension.reducer_hourEnd,
      );

  FlagsHourMonthMap.empty() : this.emptyOn(DateTime.now().year);

  ///
  /// [firstMonth], [firstDate], [firstHour]
  /// [lastMonth], [lastDate], [lastHour]
  /// [firstDayInMonth], [firstHourAfter]
  /// [lastDayInMonth], [lastHourBefore]
  ///
  int? get firstMonth => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstDate => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int, int)? get firstHour =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedDataListInt.getBitFirst1);

  int? get lastMonth => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastDate => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get lastHour =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedDataListInt.getBitLast1);

  (int, int, int)? firstDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toFirstKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? firstHourAfter((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitFirst1,
    TypedDataListInt.getBitFirst1From,
  );

  (int, int, int)? lastDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toLastKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? lastHourBefore((int, int, int) hour) => _findEntryNearBy(
    hour,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitFirst1From,
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
  int get _toStringFieldTitleLength => 4; // for '([month]'

  @override
  int get _toStringFieldBorderLength =>
      _toStringFieldTitleLength + 5 + 3 + 32 + 4;

  @override
  void _bufferApplyField(
    StringBuffer buffer,
    int key,
    int keyKey,
    TypedDataList<int> value,
  ) => _bufferApplyHours(buffer, value);
}

///
///
///
class FlagsHourWeekdayMap extends _FlagsParent
    with
        _MixinFlagsMutable,
        _MixinFlagsInsertable,
        _MixinFlagsInsertableHoursADay
    implements _FlagsContainer {
  final Map<Weekday, TypedDataList<int>> _field;

  FlagsHourWeekdayMap.empty() : _field = {};

  @override
  bool get isEmpty => _field.isEmpty;

  @override
  bool get isNotEmpty => _field.isNotEmpty;

  @override
  bool contains(covariant (Weekday, int) record) {
    final hour = record.$2;
    assert(DateTimeExtension.isValidHour(hour));

    final hours = _field[record.$1];
    return hours == null ? false : _mutateBitOn(hour, hours);
  }

  @override
  void include(covariant (Weekday, int) record) {
    final hour = record.$2;
    assert(DateTimeExtension.isValidHour(hour));

    final hours = _field[record.$1];
    if (hours == null) {
      _field[record.$1] = _newValue(hour);
      return;
    }
    _mutateBitSet(hour, hours);
  }

  @override
  void exclude(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) return;
    final hour = record.$2;
    assert(DateTimeExtension.isValidHour(hour));
    _mutateBitClear(hour, hours);
    for (var j = 0; j < 3; j++) {
      if (hours[j] != 0) return;
    }
    _field.remove(record.$1);
  }

  @override
  void clear() => _field.clear();

  ///
  ///
  ///
  @override
  int get _toStringFieldBorderLength => 10 + 3 + 24 + 3;

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    for (var entry in _field.entries) {
      final week = entry.key;
      final hours = entry.value;
      buffer.write('|');
      buffer.write(week.name.padLeft(10));
      buffer.write(' ');
      buffer.write('(${week.index + 1})');
      buffer.write(' : ');
      _bufferApplyHours(buffer, hours);
      buffer.writeln();
    }
  }
}

///
///
///
abstract class FlagsADay extends _FlagsParentFieldContainer<(int, int)> {
  factory FlagsADay.perHour() = _FlagsADayOf8.perHour;

  factory FlagsADay.per30Minute() = _FlagsADayOf16.per30Minute;

  factory FlagsADay.per20Minute() = _FlagsADayOf8.per30Minute;

  factory FlagsADay.per10Minute() = _FlagsADayOf16.per10Minute;

  static const String invalidMinute_errorName = 'invalid minute';
  static const String invalidMinutePeriod_errorName = 'invalid minute period';

  static ArgumentError invalidMinute_erroring(int minute) =>
      ArgumentError.value(minute, invalidMinute_errorName);

  ///
  ///
  ///
  int get _hourDivision;

  int get _minuteModulus;

  Predicator<int> get validateMinute;

  static bool _validateMinute_perHour(int minute) => minute == 0;

  static bool _validateMinute_per30Minute(int minute) =>
      minute == 0 || minute == 30;

  static bool _validateMinute_per20Minute(int minute) =>
      minute == 0 || minute == 20 || minute == 40;

  static bool _validateMinute_per10Minute(int minute) =>
      minute == 0 ||
      minute == 10 ||
      minute == 20 ||
      minute == 30 ||
      minute == 40 ||
      minute == 50;

  ///
  ///
  ///
  @override
  bool validateRecord((int, int) record) =>
      DateTimeExtension.isValidHour(record.$1) && validateMinute(record.$2);

  @override
  int _positionOf((int, int) record) {
    assert(validateRecord(record));
    return record.$1 * _hourDivision + record.$2 ~/ _minuteModulus + 1;
  }

  int get _toStringHoursPerLine;

  @override
  int get _toStringFieldBorderLength =>
      1 + 3 + 3 + 5 + 3 + (_hourDivision + 1) * _toStringHoursPerLine;

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final list = _field;
    final shift = _shift;
    final mask = _mask;
    var p = 0;
    final division = _hourDivision;
    final hoursPerLine = _toStringHoursPerLine;
    final sizeLimit = hoursPerLine * division + 1;
    final lines = 24 ~/ hoursPerLine;
    for (var j = 0; j < lines; j++) {
      buffer.write('|');
      final h = j * hoursPerLine;
      buffer.write('$h'.padLeft(3));
      buffer.write(' ~ ');
      buffer.write('${h + hoursPerLine - 1}'.padRight(3));
      buffer.write('hr');
      buffer.write(' : ');
      for (var m = 1; m < sizeLimit; m++) {
        buffer.writeBit(list[p >> shift] >> (p & mask));
        p++;
        if (m % division == 0) buffer.write(' ');
      }
      buffer.writeln();
    }
  }

  FlagsADay._(super._field);
}

//
class _FlagsADayOf8 extends FlagsADay with _MixinFlagsOperatableOf8 {
  @override
  final int _hourDivision;
  @override
  final int _minuteModulus;
  @override
  final Predicator<int> validateMinute;
  @override
  final int _toStringHoursPerLine;

  _FlagsADayOf8.perHour() // 24 bits
    : _toStringHoursPerLine = 6,
      _hourDivision = 1,
      _minuteModulus = 60,
      validateMinute = FlagsADay._validateMinute_perHour,
      super._(Uint8List(3));

  _FlagsADayOf8.per30Minute() // 72 bits
    : _toStringHoursPerLine = 4,
      _hourDivision = 3,
      _minuteModulus = 20,
      validateMinute = FlagsADay._validateMinute_per20Minute,
      super._(Uint8List(9));
}

//
class _FlagsADayOf16 extends FlagsADay with _MixinFlagsOperatableOf16 {
  @override
  final int _hourDivision;
  @override
  final int _minuteModulus;
  @override
  final Predicator<int> validateMinute;
  @override
  final int _toStringHoursPerLine;

  _FlagsADayOf16.per30Minute() // 48 bits
    : _toStringHoursPerLine = 4,
      _hourDivision = 2,
      _minuteModulus = 30,
      validateMinute = FlagsADay._validateMinute_per30Minute,
      super._(Uint16List(3));

  _FlagsADayOf16.per10Minute() // 144 bits
    : _toStringHoursPerLine = 3,
      _hourDivision = 6,
      _minuteModulus = 10,
      validateMinute = FlagsADay._validateMinute_per10Minute,
      super._(Uint16List(9));
}

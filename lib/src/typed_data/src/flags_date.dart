part of '../typed_data.dart';

///
///
/// see also the comment above [BitFlags]
///
/// [_DateFlags]
///   --[_DateFlagsSplayDoubleIndex]
///   |   --[DateFlags]           with [_DateFlagsHour]
///   |   --[MonthHourFlags]------|
///   --[WeekHourFlags]-----------| * [Weekday]
///
///

///
///
/// [DateFlags.empty]
/// [include], ...
/// [firstYear], ...
/// [yearsAvailable], ...
///
///
class DateFlags extends _DateFlagsSplayDoubleIndex<Uint32List> {
  static const int _howMany32List = 1;

  @override
  Uint32List get _newList => Uint32List(_howMany32List);

  @override
  int get _sizeEach => _BitFlags32.sizeEach;

  @override
  int get _shift => _BitFlags32.shift;

  @override
  int get _mask => _BitFlags32.mask;

  @override
  int get _toStringFieldPadLeft => 6; // for '([year]'

  @override
  void _bufferApplyField(
    StringBuffer buffer,
    int year,
    int month,
    Uint32List value,
  ) {
    var i = 0;
    var bits = value[0];

    // 1 ~ 24
    for (var j = 1; j < 4; j++) {
      final last = j * 8;
      while (i < last) {
        buffer.writeBit(bits);
        bits >>= 1;
        i++;
      }
      buffer.write(' ');
    }

    // 25 ~ last
    final last = DateTimeExtension.monthDaysOf(year, month);
    while (i < last) {
      buffer.writeBit(bits);
      bits >>= 1;
      i++;
    }
  }

  ///
  ///
  ///
  DateFlags.empty()
    : super.empty(
        isValidKeyKey: DateTimeExtension.isValidMonthDynamic,
        toKeyKeyBegin: DateTimeExtension.apply_monthBegin,
        toKeyKeyEnd: DateTimeExtension.apply_monthEnd,
        toValueBegin: IntExtension.reduce_1,
        toValueEnd: DateTimeExtension.monthDaysOf,
      );

  factory DateFlags.from((int, int, int) date) {
    final flags = DateFlags.empty();
    flags._field[date.$1] = flags._newKeyKey(date.$2, date.$3);
    return flags;
  }

  factory DateFlags.fromIterable(Iterable<(int, int, int)> iterable) => iterable
      .iterator
      .inductInited(DateFlags.from, (flags, date) => flags..include(date));

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

  (int, int, int)? firstDateAfter((int, int, int) date) => _findEntryAfter(
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

  (int, int, int)? lastDateBefore((int, int, int) date) => _findEntryAfter(
    date,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_less,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitLast1From,
  );

  ///
  /// [yearsAvailable], [monthsAvailable], [daysAvailable]
  /// [dates], [datesWithinMonthsInYear], [datesWithinMonths]
  ///
  Iterable<int> get yearsAvailable => _keysAvailable;

  Iterable<int> monthsAvailable(int year) => _keyKeysAvailable(year);

  Iterable<int> daysAvailable(int year, int month) =>
      _valuesAvailable(year, month);

  Iterable<(int, int, int)> get dates => _entries;

  Iterable<(int, int, int)> datesWithinMonthsInYear(
    int year,
    int begin,
    int end,
  ) => _entriesWithinKeyKeyInKey(year, begin, end);

  Iterable<(int, int, int)> datesWithinMonths(
    (int, int) begin,
    (int, int) end,
  ) => _entriesWithinKeyKey(begin, end);

  // Iterable<(int, int, int)> datesWithin((int, int, int) begin, (int, int, int) end) =>
  //     _entriesWithin(begin, end);
}

///
///
///
class MonthHourFlags extends _DateFlagsSplayDoubleIndex<Uint8List>
    with _DateFlagsHour {
  @override
  int get _toStringFieldPadLeft => 4; // for '([month]'

  @override
  void _bufferApplyField(
    StringBuffer buffer,
    int key,
    int keyKey,
    Uint8List value,
  ) => _DateFlagsHour._bufferApplyHours(buffer, value);

  ///
  ///
  ///
  MonthHourFlags.emptyOn(int year)
    : super.empty(
        isValidKey: DateTimeExtension.isValidMonthDynamic,
        isValidKeyKey: DateTimeExtension.isValidDaysDynamic,
        toKeyKeyBegin: IntExtension.apply_1,
        toKeyKeyEnd: DateTimeExtension.applier_daysEnd(year),
        toValueBegin: DateTimeExtension.reducer_hourBegin,
        toValueEnd: DateTimeExtension.reducer_hourEnd,
      );

  MonthHourFlags.empty() : this.emptyOn(DateTime.now().year);

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

  (int, int, int)? firstHourAfter((int, int, int) hour) => _findEntryAfter(
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

  (int, int, int)? lastHourBefore((int, int, int) hour) => _findEntryAfter(
    hour,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitFirst1From,
  );

  ///
  /// [monthsAvailable], [daysAvailable], [hoursAvailable]
  /// [hours], [hoursWithinMonths], [hoursWithin]
  ///
  Iterable<int> get monthsAvailable => _keysAvailable;

  Iterable<int> daysAvailable(int month) => _keyKeysAvailable(month);

  Iterable<int> hoursAvailable(int month, int day) =>
      _valuesAvailable(month, day);

  Iterable<(int, int, int)> get hours => _entries;

  Iterable<(int, int, int)> hoursWithinMonths(int month, int begin, int end) =>
      _entriesWithinKeyKeyInKey(month, begin, end);

  Iterable<(int, int, int)> hoursWithin((int, int) begin, (int, int) end) =>
      _entriesWithinKeyKey(begin, end);
}

///
///
///
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory Weekday.from(DateTime dateTime) => switch (dateTime.weekday) {
    DateTime.monday => monday,
    DateTime.tuesday => tuesday,
    DateTime.wednesday => wednesday,
    DateTime.thursday => thursday,
    DateTime.friday => friday,
    DateTime.saturday => saturday,
    DateTime.sunday => sunday,
    _ => throw ArgumentError('date time weekday: ${dateTime.weekday}'),
  };
}

///
///
///
class WeekHourFlags extends _DateFlags<Uint8List> with _DateFlagsHour {
  @override
  int get _toStringFieldPadLeft => 10; // for '[weekday]'

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final pad = _toStringFieldPadLeft;
    for (var entry in _field.entries) {
      final week = entry.key;
      final hours = entry.value;
      buffer.write('|');
      buffer.write(week.name.padLeft(pad));
      buffer.write(' ');
      buffer.write('(${week.index + 1})');
      buffer.write(' : ');
      _DateFlagsHour._bufferApplyHours(buffer, hours);
      buffer.writeln();
    }
  }

  ///
  ///
  ///
  final Map<Weekday, Uint8List> _field;

  WeekHourFlags.empty() : _field = {};

  @override
  bool get isEmpty => _field.isEmpty;

  @override
  bool get isNotEmpty => _field.isNotEmpty;

  @override
  bool contains(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    return hours == null ? false : _bitOn(hours, record.$2);
  }

  @override
  void include(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) {
      _field[record.$1] = _newValue(record.$2);
      return;
    }
    _bitSet(hours, record.$2);
  }

  @override
  void exclude(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) return;
    _bitClear(hours, record.$2);
    final length = _DateFlagsHour.howManyList8;
    for (var j = 0; j < length; j++) {
      if (hours[j] != 0) return;
    }
    _field.remove(record.$1);
  }

  @override
  void clear() => _field.clear();
}

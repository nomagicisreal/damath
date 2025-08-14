part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FlagsMapDate]
/// [FlagsMapHourDate]
///
///
///

///
///
/// [FlagsMapDate.empty]
/// [includes], ...
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

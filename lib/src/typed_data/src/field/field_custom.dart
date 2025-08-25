part of '../../typed_data.dart';

///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [FieldDatesInMonths]
/// [FieldAB]
///
///

///
///
///
class FieldDatesInMonths extends FieldParent
    with
        _MFlagsContainerScopedDate<bool>,
        _MBitsFieldMonthsDates,
        _MFieldContainerMonthsDates,
        _MSetFieldMonthsDatesScoped,
        _MSetFieldBitsMonthsDates,
        _MOperatableField<FieldDatesInMonths> {
  @override
  final (int, int) begin;
  @override
  final (int, int) end;

  FieldDatesInMonths(this.begin, this.end)
    : assert(
        DateTimeExtension.isValidYearMonthScope(begin, end),
        'invalid date $begin ~ $end',
      ),
      super(Uint32List(begin.monthsToYearMonth(end.$1, end.$2) + 1));

  @override
  FieldDatesInMonths get newZero => FieldDatesInMonths(begin, end);

  ///
  /// [_sub] is the same algorithm with [Record3Int.biCallbackFrom]
  ///
  @override
  void _sub(
    TriCallback<int> consume,
    (int, int, int) begin,
    (int, int, int)? limit,
  ) {
    assert(validateIndex(begin));
    assert(limit == null || (validateIndex(limit) && begin < limit));

    final yBegin = begin.$1;
    final mBegin = begin.$2;
    final dBegin = begin.$3;
    final yEnd = limit?.$1 ?? end.$1;
    final mEnd = limit?.$2 ?? end.$2;
    final dEnd = limit?.$3 ?? DateTimeExtension.monthDaysOf(yEnd, mEnd);
    assert(yBegin <= yEnd);

    // ==
    if (yBegin == yEnd) {
      assert(mBegin <= mEnd);

      // ==
      if (mBegin == mEnd) {
        assert(dBegin <= dEnd);
        for (var i = dBegin; i <= dEnd; i++) {
          consume(yBegin, mBegin, i);
        }
        return;
      }

      // <
      final daysOf = DateTimeExtension.monthDaysOf;
      var i = dBegin;
      var limit = daysOf(yBegin, mBegin);
      for (; i < limit; i++) {
        consume(yBegin, mBegin, i);
      }
      for (var j = mBegin + 1; j < mEnd; j++) {
        limit = daysOf(yBegin, j);
        for (i = 1; i < limit; i++) {
          consume(yBegin, j, i);
        }
      }
      for (i = 1; i <= dEnd; i++) {
        consume(yBegin, mEnd, i);
      }
      return;
    }

    // <
    final daysOf = DateTimeExtension.monthDaysOf;
    var i = dBegin;
    var iLimit = daysOf(yBegin, mBegin);
    for (; i < iLimit; i++) {
      consume(yBegin, mBegin, i);
    }
    var j = mBegin + 1;
    for (; j < 13; j++) {
      iLimit = daysOf(yBegin, j);
      for (i = 1; i < iLimit; i++) {
        consume(yBegin, j, i);
      }
    }
    for (var k = yBegin + 1; k < yEnd; k++) {
      for (j = 1; j < 13; j++) {
        iLimit = daysOf(k, j);
        for (i = 1; i < iLimit; i++) {
          consume(k, j, i);
        }
      }
    }
    for (j = 1; j < mEnd; j++) {
      iLimit = daysOf(yEnd, j);
      for (i = 1; i < iLimit; i++) {
        consume(yEnd, j, i);
      }
    }
    iLimit = daysOf(yEnd, mEnd);
    for (i = 1; i < iLimit; i++) {
      consume(yEnd, mEnd, i);
    }
  }
}

///
///
///
abstract class FieldAB extends FieldParent
    with
        _MSetFieldIndexable<(int, int)>,
        _MBitsField,
        _MFieldContainerPositionAble<(int, int)>,
        _MSetFieldBits<(int, int)>,
        _MOperatableField<FieldAB> {
  final int aLimit;
  final Predicator<int> bValidate;
  final int bDivision;
  final int bSize;
  final int bSizeDivision;

  FieldAB._(
    this.bValidate,
    this.bDivision,
    super._field, {
    this.aLimit = DateTimeExtension.hoursADay,
    this.bSize = DateTimeExtension.minutesAHour,
  }) : assert(
         bSize % bDivision == 0,
         'invalid division: $bDivision for $bSize',
       ),
       bSizeDivision = bSize ~/ bDivision;

  factory FieldAB.dayPerHour() = _FieldAB8.dayPerHour;

  factory FieldAB.dayPer10Minute() = _FieldAB16.dayPer10Minute;

  factory FieldAB.dayPer12Minute() = _FieldAB8.dayPer12Minute;

  factory FieldAB.dayPer15Minute() = _FieldAB16.dayPer15Minute;

  factory FieldAB.dayPer20Minute() = _FieldAB8.dayPer20Minute;

  factory FieldAB.dayPer30Minute() = _FieldAB16.dayPer30Minute;

  @override
  bool validateIndex((int, int) index) {
    final a = index.$1;
    return !a.isNegative && a < aLimit && bValidate(index.$2);
  }

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return index.$1 * bDivision + index.$2 ~/ bSizeDivision;
  }

  @override
  (int, int) _indexOf(int position) {
    final division = bDivision;
    return (position ~/ division, position % division);
  }

  @override
  void _ranges(Consumer<int> consume, (int, int) begin, (int, int)? limit) {
    assert(validateIndex(begin));
    assert(limit == null || (validateIndex(limit) && begin < limit));

    final division = bDivision;
    final sizeDivision = bSizeDivision;
    final aBegin = begin.$1 * division;
    final aEnd = (limit?.$1 ?? aLimit - 1) * division;
    var d = begin.$2 ~/ sizeDivision;
    for (; d < sizeDivision; d++) {
      consume(aBegin + d);
    }
    for (var a = aBegin; a < aEnd; a += division) {
      for (d = 0; d < sizeDivision; d++) {
        consume(a + d);
      }
    }
    final dEnd = (limit?.$2 ?? size) ~/ sizeDivision;
    for (d = 0; d <= dEnd; d++) {
      consume(aEnd + d);
    }
  }
}

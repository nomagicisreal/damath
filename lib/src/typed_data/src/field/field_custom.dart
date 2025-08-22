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
class FieldDatesInMonths extends _PFieldScoped<(int, int)>
    with
        _MBitsFieldMonthsDates,
        _MFieldContainerBitsMonthsDates,
        _MFieldBitsSetMonthsDates,
        _MSetFieldMonthsDatesScoped,
        _MFieldOperatable<FieldDatesInMonths>
    implements _AFlagsContainer<(int, int, int), bool> {
  FieldDatesInMonths((int, int) begin, (int, int) end)
    : assert(
        DateTimeExtension.isValidMonth(begin.$2) &&
            DateTimeExtension.isValidMonth(end.$2),
        'invalid date $begin ~ $end',
      ),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      super(
        begin,
        end,
        Uint32List(begin.monthsToYearMonth(end.$1, end.$2) + 1),
      );

  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate &&
      begin.lessOrEqualThan3(index) &&
      end.largerOrEqualThan3(index);

  @override
  int _fieldIndexOf(int year, int month) =>
      begin.monthsToYearMonth(year, month);

  ///
  /// [_ranges] is the same algorithm with [Record3Int.biCallbackFrom]
  ///
  @override
  void _ranges(
    (int, int, int) begin,
    (int, int, int) end,
    TriCallback<int> consume,
  ) {
    assert(validateIndex(begin));
    assert(validateIndex(end));
    assert(begin < end);

    final yBegin = begin.$1;
    final mBegin = begin.$2;
    final dBegin = begin.$3;
    final yEnd = end.$1;
    final mEnd = end.$2;
    final dEnd = end.$3;
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
    var limit = daysOf(yBegin, mBegin);
    for (; i < limit; i++) {
      consume(yBegin, mBegin, i);
    }
    var j = mBegin + 1;
    for (; j < 13; j++) {
      limit = daysOf(yBegin, j);
      for (i = 1; i < limit; i++) {
        consume(yBegin, j, i);
      }
    }
    for (var k = yBegin + 1; k < yEnd; k++) {
      for (j = 1; j < 13; j++) {
        limit = daysOf(k, j);
        for (i = 1; i < limit; i++) {
          consume(k, j, i);
        }
      }
    }
    for (j = 1; j < mEnd; j++) {
      limit = daysOf(yEnd, j);
      for (i = 1; i < limit; i++) {
        consume(yEnd, j, i);
      }
    }
    limit = daysOf(yEnd, mEnd);
    for (i = 1; i < limit; i++) {
      consume(yEnd, mEnd, i);
    }
  }

  @override
  FieldDatesInMonths get newZero => FieldDatesInMonths(begin, end);
}

///
///
///
abstract class FieldAB extends FieldParent
    with
        _MSetFieldIndexable<(int, int)>,
        _MBitsField,
        _MFieldContainerBits<(int, int)>,
        _MFieldBitsSet<(int, int)>,
        _MFieldOperatable<FieldAB> {
  final int aLimit;
  final Predicator<int> bValidate;
  final int bDivision;
  final int bSizeDivision;

  FieldAB._(
    this.bValidate,
    this.bDivision,
    super._field, {
    this.aLimit = 25,
    int bSize = DateTimeExtension.minutesAHour,
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
  void _ranges((int, int) begin, (int, int) limit, Consumer<int> consume) {
    assert(validateIndex(begin));
    assert(validateIndex(limit));
    assert(begin < limit);

    final division = bDivision;
    final sizeDivision = bSizeDivision;
    final aBegin = begin.$1 * division;
    final aEnd = limit.$1 * division;
    var d = begin.$2 ~/ sizeDivision;
    for (; d < sizeDivision; d++) {
      consume(aBegin + d);
    }
    for (var a = aBegin; a < aEnd; a += division) {
      for (d = 0; d < sizeDivision; d++) {
        consume(a + d);
      }
    }
    final dEnd = limit.$2 ~/ sizeDivision;
    for (d = 0; d <= dEnd; d++) {
      consume(aEnd + d);
    }
  }
}

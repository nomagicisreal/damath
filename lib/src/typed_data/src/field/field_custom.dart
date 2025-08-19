part of '../../typed_data.dart';

///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FieldDatesInMonths]
/// [FieldAB]
///
///

///
///
///
class FieldDatesInMonths extends _FieldParentScope<(int, int)>
    with _MixinFieldOperatable<FieldDatesInMonths>
    implements _FlagsContainer<(int, int, int)> {
  late final int Function((int, int, int) index) _fieldIndexFrom;
  late final BiCallback<(int, int, int)> includes;
  late final BiCallback<(int, int, int)> excludes;

  FieldDatesInMonths((int, int) begin, (int, int) end)
    : assert(
        DateTimeExtension.isValidMonth(begin.$2) &&
            DateTimeExtension.isValidMonth(end.$2),
        'invalid date $begin ~ $end',
      ),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      super(begin, end, Uint32List(begin.monthsToMonth(end) + 1)) {
    final field = _field;
    final index = begin.monthsToYearMonth;
    void including(int y, int m, int d) => field[index(y, m)] |= 1 << d - 1;
    void excluding(int y, int m, int d) => field[index(y, m)] &= ~(1 << d - 1);
    _fieldIndexFrom = begin.monthsToDates;
    includes = (begin, end) {
      assert(validateIndex(begin));
      assert(validateIndex(end));
      assert(begin < end);
      _ranges(including, begin, end);
    };
    excludes = (begin, end) {
      assert(validateIndex(begin));
      assert(validateIndex(end));
      assert(begin < end);
      _ranges(excluding, begin, end);
    };
  }

  ///
  ///
  ///
  @override
  int get _sizeEach => TypedIntList.sizeEach32;

  @override
  FieldDatesInMonths get newFieldZero => FieldDatesInMonths(begin, end);

  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate &&
      begin.lessOrEqualThan3(index) &&
      end.largerOrEqualThan3(index);

  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return _field[_fieldIndexFrom(index)] >> index.$3 - 1 & 1 == 1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    if (value) {
      _field[_fieldIndexFrom(index)] |= 1 << index.$3 - 1;
      return;
    }
    _field[_fieldIndexFrom(index)] &= ~(1 << index.$3 - 1);
  }

  ///
  /// [_ranges] is the same algorithm with [Record3Int.biCallbackFrom]
  ///
  static void _ranges(
    TriCallback<int> consume,
    (int, int, int) begin,
    (int, int, int) end,
  ) {
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

  ///
  ///
  ///
  @override
  int get _toStringFieldBorderLength => 15 + 32 + 4;

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
    final field = _field;
    final december = DateTime.december;
    final daysOf = DateTimeExtension.monthDaysOf;
    final begin = this.begin;
    var year = begin.$1;
    var month = begin.$2;

    final limit = _field.length;
    for (var j = 0; j < limit; j++) {
      buffer.write('|');
      buffer.write('($year'.padLeft(6));
      buffer.write(',');
      buffer.write('$month)'.padLeft(4));
      buffer.write(' :');
      buffer.write(' ');
      buffer.writeBitsOfMonth(field[j], daysOf(year, month));
      buffer.writeln(' |');
      month++;
      if (month > december) {
        month = 1;
        year++;
      }
    }
  }
}

///
///
///
abstract class FieldAB extends _FieldParent
    with
        _MixinFieldIterableIndex<(int, int)>,
        _MixinFieldPositionAble,
        _MixinFieldPositionAbleContainer<(int, int)>,
        _MixinFieldPositionAbleIterable<(int, int)>,
        _MixinFieldOperatable<FieldAB> {
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
  void _ranges(Consumer<int> consume, (int, int) begin, (int, int) limit) {
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

  ///
  ///
  ///
  @override
  int get _toStringFieldBorderLength =>
      3 + 6 + 2 + _toStringHoursPerLine(bDivision) * (bDivision + 1) + 2;

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
    final field = _field;
    final shift = _shift;
    final mask = _mask;
    final division = bDivision;
    final hoursPerLine = _toStringHoursPerLine(division);
    final size = hoursPerLine * division;

    final limit = (aLimit - 1) ~/ hoursPerLine;
    var i = 0;
    for (var j = 0; j < limit; j++) {
      final h = j * hoursPerLine;
      buffer.write('|');
      buffer.write('$h'.padLeft(3));
      buffer.write(' ~');
      buffer.write('${h + hoursPerLine - 1}'.padLeft(3));
      buffer.write(' :');
      for (var m = 0; m < size; m++) {
        if (m % division == 0) buffer.write(' ');
        buffer.writeBit(field[i >> shift] >> (i & mask));
        i++;
      }
      buffer.writeln(' |');
    }
  }

  static int _toStringHoursPerLine(int division) => switch (division) {
    1 => 6,
    2 || 3 => 4,
    _ => 3,
  };
}

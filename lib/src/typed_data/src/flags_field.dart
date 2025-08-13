part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FieldADay]
///   --[_FieldADayFrom8]
///   --[_FieldADayFrom16]
/// [FieldMonthDates]
/// [Field2D]
///   --[_Flags2D8], [_Flags2D16]
///   --[_Flags2D32], [_Flags2D64]
///
///
///

///
///
///
class FieldMonthDates extends _FieldParent implements _FlagsContainer {
  final (int, int, int) begin;
  final (int, int, int) end;

  FieldMonthDates(this.begin, this.end)
    : assert(begin.isValidDate && end.isValidDate, 'invalid date $begin, $end'),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      super(Uint32List(1 + begin.monthsToDates(end.$1, end.$2)));

  int _indexOf(int year, int month) => begin.monthsToDates(year, month);

  @override
  int get _sizeEach => _FieldBits32.sizeEach;

  @override
  bool contains(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    return 1 == _field[_indexOf(record.$1, record.$2)] >> record.$3 - 1 & 1;
  }

  @override
  void includes(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    _field[_indexOf(record.$1, record.$2)] |= 1 << record.$3 - 1;
  }

  @override
  void excludes(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    _field[_indexOf(record.$1, record.$2)] &= ~(1 << record.$3 - 1);
  }

  @override
  int get _toStringFieldBorderLength => 15 + 32 + 4;

  @override
  int get _toStringFlagsBodyLines => _field.length;

  @override
  Consumer<int> _toStringFlagsBodyApplyEachLine(StringBuffer buffer) {
    final field = _field;
    final december = DateTime.december;
    final daysOf = DateTimeExtension.monthDaysOf;
    final begin = this.begin;
    var year = begin.$1;
    var month = begin.$2;
    return (j) {
      buffer.write('($year'.padLeft(6));
      buffer.write(',');
      buffer.write('$month)'.padLeft(4));
      buffer.write(' :');
      buffer.write(' ');
      buffer.writeBitsOfMonth(field[j], daysOf(year, month));
      buffer.writeln();
      month++;
      if (month > december) {
        month = 1;
        year++;
      }
    };
  }
}

///
///
///
abstract class FieldADay extends _FieldParentPositionAble<(int, int)> {
  factory FieldADay.perHour() = _FieldADayFrom8.perHour;

  factory FieldADay.per30Minute() = _FieldADayFrom16.per30Minute;

  factory FieldADay.per20Minute() = _FieldADayFrom8.per30Minute;

  factory FieldADay.per10Minute() = _FieldADayFrom16.per10Minute;

  static const String invalidMinute_errorName = 'invalid minute';
  static const String invalidMinutePeriod_errorName = 'invalid minute period';

  static ArgumentError invalidMinute_erroring(int minute) =>
      ArgumentError.value(minute, invalidMinute_errorName);

  ///
  ///
  ///
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
  final int _hourDivision;

  final int _minuteModulus;

  final Predicator<int> validateMinute;

  @override
  bool validateRecord((int, int) record) =>
      DateTimeExtension.isValidHour(record.$1) && validateMinute(record.$2);

  @override
  int _positionOf((int, int) record) {
    assert(validateRecord(record));
    return record.$1 * _hourDivision + record.$2 ~/ _minuteModulus + 1;
  }

  final int _toStringHoursPerLine;

  @override
  int get _toStringFieldBorderLength =>
      1 + 3 + 3 + 5 + 3 + (_hourDivision + 1) * _toStringHoursPerLine;

  @override
  Consumer<int> _toStringFlagsBodyApplyEachLine(StringBuffer buffer) {
    final field = _field;
    final shift = _shift;
    final mask = _mask;
    final division = _hourDivision;
    final hoursPerLine = _toStringHoursPerLine;
    final sizeLimit = hoursPerLine * division + 1;
    var p = 0;
    return (j) {
      final h = j * hoursPerLine;
      buffer.write('$h'.padLeft(3));
      buffer.write(' ~ ');
      buffer.write('${h + hoursPerLine - 1}'.padRight(3));
      buffer.write('hr');
      buffer.write(' : ');
      for (var m = 1; m < sizeLimit; m++) {
        buffer.writeBit(field[p >> shift] >> (p & mask));
        p++;
        if (m % division == 0) buffer.write(' ');
      }
    };
  }

  @override
  int get _toStringFlagsBodyLines => 24 ~/ _toStringHoursPerLine;

  FieldADay._(
    this.validateMinute,
    this._toStringHoursPerLine,
    this._hourDivision,
    this._minuteModulus,
    super._field,
  );
}

//
class _FieldADayFrom8 extends FieldADay with _MixinFlagsOperate8 {
  _FieldADayFrom8.perHour() // 24 bits
    : super._(FieldADay._validateMinute_perHour, 6, 1, 60, Uint8List(3));

  _FieldADayFrom8.per30Minute() // 72 bits
    : super._(FieldADay._validateMinute_per20Minute, 4, 3, 20, Uint8List(9));
}

//
class _FieldADayFrom16 extends FieldADay with _MixinFlagsOperate16 {
  _FieldADayFrom16.per30Minute() // 48 bits
    : super._(FieldADay._validateMinute_per30Minute, 4, 2, 30, Uint16List(3));

  _FieldADayFrom16.per10Minute() // 144 bits
    : super._(FieldADay._validateMinute_per10Minute, 3, 6, 10, Uint16List(9));
}

///
///
///
abstract class Field2D extends _FieldParentPositionAble<(int, int)> {
  final int begin;
  final int width;
  final int height;

  factory Field2D(int begin, int limit, int count, [bool native = false]) {
    final width = limit - begin; // hours per day
    final size = width * count; // hours total
    if (size < _FieldBits8.limit) return _Flags2D8(begin, width, count);
    if (size < _FieldBits16.limit) return _Flags2D16(begin, width, count);
    if (size > _FieldBits32.sizeEach && native) {
      return _Flags2D64(begin, width, count, size);
    }
    return _Flags2D32(begin, width, count, size);
  }

  static bool checkValidDaysHours(int begin, int limit, int count) =>
      DateTimeExtension.isValidHour(begin) &&
      DateTimeExtension.isValidHour(limit) &&
      count > 1 &&
      limit - begin > 1; // hours per day > 1

  @override
  bool validateRecord((int, int) record) =>
      record.$1.isRangeClose(1, height) &&
      record.$2.isRangeOpenUpper(begin, begin + width);

  ///
  ///
  ///
  @override
  int _positionOf((int, int) record) {
    assert(validateRecord(record));
    return (record.$1 - 1) * width + record.$2 - begin + 1;
  }

  @override
  int get _toStringFieldBorderLength =>
      2 + '$height'.length + 2 + (width + 5) ~/ 6 * 7 + 2;

  @override
  void _toStringFlagsBodyApply(StringBuffer buffer) {
    final height = this.height;
    final pad = '$height'.length + 1;
    final begin = this.begin; // hour begin
    final width = this.width; // hour per day

    //
    buffer.write('|');
    buffer.writeRepeat(pad + 2, ' ');
    for (var per = 0; per < width; per += 6) {
      buffer.write(' ');
      buffer.write('${begin + per}'.padRight(6, ' '));
    }
    buffer.write(' ');
    buffer.write('|');

    buffer.writeln();
    buffer.write('|');
    buffer.writeRepeat(pad + 2, ' ');
    for (var per = 0; per < width; per += 6) {
      buffer.write(' ');
      buffer.write('v');
      buffer.writeRepeat(5, ' ');
    }
    buffer.write(' ');
    buffer.write('|');
    buffer.writeln();
    super._toStringFlagsBodyApply(buffer);
  }

  @override
  int get _toStringFlagsBodyLines => height;

  @override
  Consumer<int> _toStringFlagsBodyApplyEachLine(StringBuffer buffer) {
    final field = _field;
    final mask = _mask;
    final width = this.width;
    final pad = '$height'.length + 1;
    final only1Bits = field.length == 1;
    final spaceAfterBits =
        // (width + 5) ~/ 6 * 7 - width - (width + 5) ~/ 6 + 1;
        (width + 5) ~/ 6 * 6 - width + 1;

    var i = 0;
    var bits = field[i];
    i++;
    return (d) {
      buffer.write('${d + 1}'.padLeft(pad));
      buffer.write(' :');
      var h = 0;
      final hoursRouted = d * width;
      while (true) {
        if (h % 6 == 0) buffer.write(' ');
        buffer.writeBit(bits);
        bits >>= 1;
        h++;
        if (h == width) break;
        if (!only1Bits && hoursRouted + h & mask == 0) {
          bits = field[i];
          i++;
        }
      }
      buffer.writeRepeat(spaceAfterBits, ' ');
      buffer.write('|');
    };
  }

  const Field2D._(this.begin, this.width, this.height, super._field);
}

class _Flags2D8 extends Field2D with _MixinFlagsOperate8 {
  _Flags2D8(int hB, int hpd, int dc) : super._(hB, hpd, dc, Uint8List(1));
}

class _Flags2D16 extends Field2D with _MixinFlagsOperate16 {
  _Flags2D16(int hb, int hpd, int dc) : super._(hb, hpd, dc, Uint16List(1));
}

class _Flags2D32 extends Field2D with _MixinFlagsOperate32 {
  _Flags2D32(int hb, int hpd, int dc, int ht)
    : super._(
        hb,
        hpd,
        dc,
        Uint32List(ht + _FieldBits32.mask >> _FieldBits32.shift),
      );
}

class _Flags2D64 extends Field2D with _MixinFlagsOperate64 {
  _Flags2D64(int hb, int hpd, int dc, int ht)
    : super._(
        hb,
        hpd,
        dc,
        Uint64List(ht + _FieldBits64.mask >> _FieldBits64.shift),
      );
}

///
///
///
abstract class Field3D extends _FieldParentPositionAble<(int, int, int)> {
  final int begin;
  final int width;
  final int height;
  final int depth;

  // factory Field3D(int begin, int limit, int )

  // @override
  // int _positionOf((int, int, int) record) {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // bool validateRecord((int, int, int) record) {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // int get _toStringFieldBorderLength => throw UnimplementedError();
  //
  // @override
  // Consumer<int> _toStringFlagsBodyApplyEachLine(StringBuffer buffer) {
  //   throw UnimplementedError();
  // }
  //
  // @override
  // int get _toStringFlagsBodyLines => throw UnimplementedError();

  const Field3D._(this.begin, this.width, this.height, this.depth, super.field);
}

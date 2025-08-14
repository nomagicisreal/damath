part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FieldMonthDates]
/// [FieldADay]
/// [Field2D]
/// [Field3D]
///
///
///

///
///
///
class FieldMonthDates extends _FieldParent
    implements _FlagsContainer<(int, int, int)> {
  final (int, int, int) begin;
  final (int, int, int) end;

  FieldMonthDates(this.begin, this.end)
    : assert(begin.isValidDate && end.isValidDate, 'invalid date $begin, $end'),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      super(Uint32List(1 + begin.monthsToDates(end.$1, end.$2)));

  int _indexOf(int year, int month) => begin.monthsToDates(year, month);

  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate && begin <= index && index <= end;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;

  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return 1 == _field[_indexOf(index.$1, index.$2)] >> index.$3 - 1 & 1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    if (value) {
      _field[_indexOf(index.$1, index.$2)] |= 1 << index.$3 - 1;
      return;
    }
    _field[_indexOf(index.$1, index.$2)] &= ~(1 << index.$3 - 1);
  }

  @override
  int get _toStringFieldBorderLength => 15 + 32 + 4;

  @override
  int get _toStringFlagsIterationLimit => _field.length;

  @override
  Consumer<int> _toStringFlagsEachLineBy(
    StringBuffer buffer, [
    int i = 0,
    int modulo = 0,
  ]) {
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
abstract class FieldADay extends _FieldParentOperatable<FieldADay, (int, int)>
    with _MixinContainerFieldPositionAble<(int, int)> {
  factory FieldADay.perHour() = _FieldADay8.perHour;

  factory FieldADay.per30Minute() = _FieldADay16.per30Minute;

  factory FieldADay.per20Minute() = _FieldADay8.per30Minute;

  factory FieldADay.per10Minute() = _FieldADay16.per10Minute;

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
  final int _toStringHoursPerLine;

  @override
  bool validateIndex((int, int) index) =>
      DateTimeExtension.isValidHour(index.$1) && validateMinute(index.$2);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return index.$1 * _hourDivision + index.$2 ~/ _minuteModulus;
  }

  @override
  int get _toStringFieldBorderLength =>
      1 + 3 + 3 + 5 + 3 + (_hourDivision + 1) * _toStringHoursPerLine;

  @override
  Consumer<int> _toStringFlagsEachLineBy(
    StringBuffer buffer, [
    int i = 0,
    int modulo = 0,
  ]) {
    final field = _field;
    final shift = _shift;
    final mask = _mask;
    final division = _hourDivision;
    final hoursPerLine = _toStringHoursPerLine;
    final size = hoursPerLine * division;
    return (j) {
      final h = j * hoursPerLine;
      buffer.write('$h'.padLeft(3));
      buffer.write(' ~ ');
      buffer.write('${h + hoursPerLine - 1}'.padRight(3));
      buffer.write('hr');
      buffer.write(' : ');
      for (var m = 0; m < size; m++) {
        buffer.writeBit(field[i >> shift] >> (i & mask));
        i++;
        if (m % division == 0) buffer.write(' ');
      }
    };
  }

  @override
  int get _toStringFlagsIterationLimit => 24 ~/ _toStringHoursPerLine;

  FieldADay._(
    this.validateMinute,
    this._toStringHoursPerLine,
    this._hourDivision,
    this._minuteModulus,
    super._field,
  );
}

///
///
///
sealed class Field2D extends _FieldParentSpace<Field2D, (int, int)> {
  factory Field2D(int width, int height, {bool native = false}) {
    final size = width * height;
    if (size < TypedIntList.limit8) return _Field2D8(width, height);
    if (size < TypedIntList.limit16) return _Field2D16(width, height);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field2D64(width, height, TypedIntList.quotientCeil64(size));
    }
    return _Field2D32(width, height, TypedIntList.quotientCeil32(size));
  }

  ///
  ///
  ///
  static bool validateDaysHours(int limit, int count, [int begin = 0]) =>
      DateTimeExtension.isValidHour(begin) &&
      DateTimeExtension.isValidHour(limit) &&
      count > 1 &&
      limit - begin > 1; // hours per day > 1

  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRangeClose(1, height) && index.$2.isRangeOpenUpper(0, width);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * width + index.$2;
  }

  const Field2D._(super.width, super.height, super._field);
}

///
///
///
sealed class Field3D extends _FieldParentSpace<Field3D, (int, int, int)> {
  final int depth;

  factory Field3D(int width, int height, int depth, [bool native = false]) {
    final size = width * height * depth;
    if (size < TypedIntList.limit8) return _Field3D8(width, height, depth);
    if (size < TypedIntList.limit16) return _Field3D16(width, height, depth);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field3D64(
        width,
        height,
        depth,
        TypedIntList.quotientCeil64(size),
      );
    }
    return _Field3D32(width, height, depth, TypedIntList.quotientCeil32(size));
  }

  @override
  bool validateIndex((int, int, int) index) =>
      index.$1.isRangeClose(1, depth) &&
      index.$2.isRangeClose(1, height) &&
      index.$3.isRangeOpenUpper(0, width);

  @override
  int _positionOf((int, int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * width * height + (index.$2 - 1) * width + index.$3;
  }

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int i = 0, int shift = 0]) {
    final depth = this.depth;
    final width = this.width;
    final height = this.height;
    final sizeEach = _sizeEach;
    final borderLength = _toStringFieldBorderLength;
    for (var d = 0; d < depth; d++) {
      final start = d * width * height;
      super._toStringFlagsBy(buffer, start ~/ sizeEach, start % sizeEach);
      if (d < depth - 1) {
        buffer.write('\\');
        buffer.write('${d + 1}/'.padLeft(borderLength - 1, '-'));
        buffer.writeln();

        buffer.write('/${d + 2}'.padRight(borderLength - 1, '-'));
        buffer.write('\\');
        buffer.writeln();
      }
    }
  }

  const Field3D._(super.width, super.height, this.depth, super.field);
}

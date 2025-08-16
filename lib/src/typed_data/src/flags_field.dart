part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [Field] ~ [Field4D]
/// [FieldDatesInMonths]
/// [FieldAB]
///
///
///

///
///
///
abstract class Field extends _FieldParentSpatial1
    with _MixinFieldOperatable<Field>
    implements _FlagsContainer<int> {
  factory Field(int width, [bool native = false]) {
    assert(width > 1);
    if (width < TypedIntList.limit8) return _Field8(width);
    if (width < TypedIntList.limit16) return _Field16(width);
    if (width > TypedIntList.sizeEach32 && native) {
      return _Field64(width, TypedIntList.quotientCeil64(width));
    }
    return _Field32(width, TypedIntList.quotientCeil32(width));
  }

  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, spatial1);

  @override
  bool operator [](int index) {
    assert(validateIndex(index));
    return _bitOn(index);
  }

  @override
  void operator []=(int index, bool value) {
    assert(validateIndex(index));
    return value ? _bitSet(index) : _bitClear(index);
  }

  const Field._(super.spatial1, super._field);
}

///
///
///
abstract class Field2D extends _FieldParentSpatial2
    with
        _MixinFieldPositionAbleContainer<(int, int)>,
        _MixinFieldOperatable<Field2D>
    implements _FieldSpatialCollapse<Field> {
  factory Field2D(int width, int height, {bool native = false}) {
    assert(width > 1 && height > 1);
    final size = width * height;
    if (size < TypedIntList.limit8) return _Field2D8(width, height);
    if (size < TypedIntList.limit16) return _Field2D16(width, height);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field2D64(width, height, TypedIntList.quotientCeil64(size));
    }
    return _Field2D32(width, height, TypedIntList.quotientCeil32(size));
  }

  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRangeClose(1, spatial2) &&
      index.$2.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * spatial1 + index.$2;
  }

  @override
  Field collapseOn(int index) {
    assert(index.isRangeClose(1, spatial2));
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1;
    final result = Field(spatial1);
    for (var i = 0; i < spatial1; i++) {
      if (_bitOn(start + i)) result._bitSet(i);
    }
    return result;
  }

  const Field2D._(super.spatial1, super.spatial2, super.field);
}

///
///
///
abstract class Field3D extends _FieldParentSpatial3
    with
        _MixinFieldPositionAbleContainer<(int, int, int)>,
        _MixinFieldOperatable<Field3D>
    implements _FieldSpatialCollapse<Field2D> {
  factory Field3D(int width, int height, int depth, [bool native = false]) {
    assert(width > 1 && height > 1 && depth > 1);
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
      index.$1.isRangeClose(1, spatial3) &&
      index.$2.isRangeClose(1, spatial2) &&
      index.$3.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int, int) index) {
    assert(validateIndex(index));
    final spatial1 = this.spatial1;
    return (index.$1 - 1) * spatial1 * spatial2 +
        (index.$2 - 1) * spatial1 +
        index.$3;
  }

  @override
  Field2D collapseOn(int index) {
    assert(index.isRangeClose(1, spatial3));
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial2 * spatial1;
    final result = Field2D(spatial1, spatial2);
    for (var j = 0; j < spatial2; j++) {
      final begin = j * spatial1;
      for (var i = 0; i < spatial1; i++) {
        final p = begin + i;
        if (_bitOn(start + p)) result._bitSet(p);
      }
    }
    return result;
  }

  const Field3D._(super.spatial1, super.spatial2, super.spatial3, super.field);
}

///
///
///
abstract class Field4D extends _FieldParentSpatial4
    with
        _MixinFieldPositionAbleContainer<(int, int, int, int)>,
        _MixinFieldOperatable<Field4D>
    implements _FieldSpatialCollapse<Field3D> {
  factory Field4D(int s1, int s2, int s3, int s4, [bool native = false]) {
    assert(s1 > 1 && s2 > 1 && s3 > 1 && s4 > 1);
    final size = s1 * s2 * s3 * s4;
    if (size < TypedIntList.limit8) return _Field4D8(s1, s2, s3, s4);
    if (size < TypedIntList.limit16) return _Field4D16(s1, s2, s3, s4);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field4D64(s1, s2, s3, s4, TypedIntList.quotientCeil64(size));
    }
    return _Field4D32(s1, s2, s3, s4, TypedIntList.quotientCeil32(size));
  }

  @override
  bool validateIndex((int, int, int, int) index) =>
      index.$1.isRangeClose(1, spatial4) &&
      index.$2.isRangeClose(1, spatial3) &&
      index.$3.isRangeClose(1, spatial2) &&
      index.$4.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int, int, int) index) {
    assert(validateIndex(index));
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final spatial12 = spatial1 * spatial2;
    return (index.$1 - 1) * spatial12 * spatial3 +
        (index.$2 - 1) * spatial12 +
        (index.$3 - 1) * spatial1 +
        index.$4;
  }

  @override
  Field3D collapseOn(int index) {
    assert(index.isRangeClose(1, spatial4));
    final spatial3 = this.spatial3;
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1 * spatial2 * spatial3;
    final result = Field3D(spatial1, spatial2, spatial3);
    for (var k = 0; k < spatial3; k++) {
      final b1 = k * spatial2;
      for (var j = 0; j < spatial2; j++) {
        final b2 = j * spatial1;
        for (var i = 0; i < spatial1; i++) {
          final p = b1 + b2 + i;
          if (_bitOn(start + p)) result._bitSet(p);
        }
      }
    }
    return result;
  }

  const Field4D._(
    super.spatial1,
    super.spatial2,
    super.spatial3,
    super.spatial4,
    super.field,
  );
}

///
///
///
class FieldDatesInMonths extends _FieldParentScope<(int, int)>
    with _MixinFieldOperatable<FieldDatesInMonths>
    implements _FlagsContainer<(int, int, int)> {
  final int Function((int, int, int) record) _indexOf;

  FieldDatesInMonths((int, int) begin, (int, int) end)
    : assert(
        DateTimeExtension.isValidMonth(begin.$2) &&
            DateTimeExtension.isValidMonth(end.$2),
        'invalid date $begin ~ $end',
      ),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      _indexOf = begin.monthsToDates,
      super(begin, end, Uint32List(begin.monthsToMonth(end) + 1));

  ///
  ///
  ///
  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate &&
      begin.lessOrEqualThan3(index) &&
      end.largerOrEqualThan3(index);

  @override
  int get _sizeEach => TypedIntList.sizeEach32;

  @override
  FieldDatesInMonths get newFieldZero => FieldDatesInMonths(begin, end);

  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return _field[_indexOf(index)] >> index.$3 - 1 & 1 == 1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    if (value) {
      _field[_indexOf(index)] |= 1 << index.$3 - 1;
      return;
    }
    _field[_indexOf(index)] &= ~(1 << index.$3 - 1);
  }

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
        _MixinFieldPositionAble,
        _MixinFieldPositionAbleContainer<(int, int)>,
        _MixinFieldOperatable<FieldAB> {
  factory FieldAB.dayPerHour() = _FieldAB8.dayPerHour;

  factory FieldAB.dayPer10Minute() = _FieldAB16.dayPer10Minute;

  factory FieldAB.dayPer12Minute() = _FieldAB8.dayPer12Minute;

  factory FieldAB.dayPer15Minute() = _FieldAB16.dayPer15Minute;

  factory FieldAB.dayPer20Minute() = _FieldAB8.dayPer20Minute;

  factory FieldAB.dayPer30Minute() = _FieldAB16.dayPer30Minute;

  ///
  ///
  ///
  final int aLimit;
  final Predicator<int> bValidate;
  final int bDivision;
  final int bDivisionSize;

  @override
  bool validateIndex((int, int) index) {
    final a = index.$1;
    return -1 < a && a < aLimit && bValidate(index.$2);
  }

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return index.$1 * bDivision + index.$2 ~/ bDivisionSize;
  }

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

  FieldAB._(
    this.bValidate,
    this.bDivision,
    super._field, {
    this.aLimit = 25,
    int bSizeTotal = DateTimeExtension.minutesAHour,
  }) : bDivisionSize = bSizeTotal ~/ bDivision;
}

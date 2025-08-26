part of '../typed_data.dart';

///
///
///
/// mixin:
/// [_MFlagsO8], [_MFlagsO16], [_MFlagsO32], [_MFlagsO64]
///
/// [_MFlagsContainerSpatial1]
/// [_MFlagsContainerSpatial2]
/// [_MFlagsContainerSpatial3]
/// [_MFlagsContainerSpatial4]
/// [_MFlagsContainerScopedDate]
/// [_MFlagsScopedDatePositionDay]
///
/// [_MBitsField]
/// [_MBitsFieldMonthsDates]
/// [_MBitsFlagsField]
///
/// [_MFieldContainerPositionAble]
/// [_MFieldContainerMonthsDates]
/// [_MSlotContainerPositionAble]
///
///
/// [_MOperatableField]
/// [_MEquatableSlot]
///
///

///
///
///
///
mixin _MFlagsO8 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  int get _sizeEach => TypedIntList.sizeEach8;
}

mixin _MFlagsO16 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift16;

  @override
  int get _mask => TypedIntList.mask16;

  @override
  int get _sizeEach => TypedIntList.sizeEach16;
}

mixin _MFlagsO32 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift32;

  @override
  int get _mask => TypedIntList.mask32;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MFlagsO64 implements _AFieldBits, _AFieldIdentical {
  @override
  int get _shift => TypedIntList.shift64;

  @override
  int get _mask => TypedIntList.mask64;

  @override
  int get _sizeEach => TypedIntList.sizeEach64;
}

///
///
///
mixin _MFlagsContainerSpatial1<T>
    implements _AFlagsContainer<int, T>, _AFlagsSpatial1 {
  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, spatial1);
}

mixin _MFlagsContainerSpatial2<T>
    implements
        _AFlagsContainer<(int, int), T>,
        _AFlagsSpatial2,
        _AFlagsPositionAble<(int, int)> {
  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRangeClose(1, spatial2) &&
      index.$2.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * spatial1 + index.$2;
  }
}

mixin _MFlagsContainerSpatial3<T>
    implements
        _AFlagsContainer<(int, int, int), T>,
        _AFlagsSpatial3,
        _AFlagsPositionAble<(int, int, int)> {
  @override
  bool validateIndex((int, int, int) index) =>
      index.$1.isRangeClose(1, spatial3) &&
      index.$2.isRangeClose(1, spatial2) &&
      index.$3.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int, int) index) {
    assert(validateIndex(index));
    return ((index.$1 - 1) * spatial2 + index.$2 - 1) * spatial1 + index.$3;
  }
}

mixin _MFlagsContainerSpatial4<T>
    implements
        _AFlagsContainer<(int, int, int, int), T>,
        _AFlagsSpatial4,
        _AFlagsPositionAble<(int, int, int, int)> {
  @override
  bool validateIndex((int, int, int, int) index) =>
      index.$1.isRangeClose(1, spatial4) &&
      index.$2.isRangeClose(1, spatial3) &&
      index.$3.isRangeOpenUpper(0, spatial2) &&
      index.$4.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int, int, int) index) {
    assert(validateIndex(index));
    return (((index.$1 - 1) * spatial3 + index.$2 - 1) * spatial2 +
                index.$3 -
                1) *
            spatial1 +
        index.$4;
  }
}

mixin _MFlagsContainerScopedDate<T>
    implements _AFlagsContainer<(int, int, int), T>, _AFlagsScoped<(int, int)> {
  @override
  bool validateIndex((int, int, int) index) =>
      index.isValidDate &&
      begin.lessOrEqualThan3(index) &&
      end.largerOrEqualThan3(index);
}

mixin _MFlagsScopedDatePositionDay
    implements _AFlagsScoped<(int, int)>, _AFlagsPositionAble<(int, int, int)> {
  @override
  int _positionOf((int, int, int) index) =>
      begin.daysToDate(index.$1, index.$2, index.$3);
}

///
///
///
///
mixin _MBitsField implements _AField, _AFieldBits {
  bool _bitOn(int position) => _field.pOn(position, _shift, _mask);

  void _bitSet(int position) => _field.pSet(position, _shift, _mask);

  void _bitClear(int position) => _field.pClear(position, _shift, _mask);
}

mixin _MBitsFieldMonthsDates
    implements _AField, _AFieldIdentical, _AFlagsScoped<(int, int)> {
  bool _bitOn(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] >> day - 1 & 1 == 1;

  void _bitSet(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] |= 1 << day - 1;

  void _bitClear(int year, int month, int day) =>
      _field[begin.monthsToYearMonth(year, month)] &= ~(1 << day - 1);

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MBitsFlagsField implements _AFieldBits {
  bool _bitOn(int position, TypedDataList<int> list) =>
      list.pOn(position, _shift, _mask);

  void _bitSet(int position, TypedDataList<int> list) =>
      list.pSet(position, _shift, _mask);

  void _bitClear(int position, TypedDataList<int> list) =>
      list.pClear(position, _shift, _mask);

  TypedDataList<int> get _newField;

  TypedDataList<int> _bitSetNewField(int position) =>
      _newField..[position >> _shift] = 1 << (position & _mask) - 1;

  bool get isEmpty;

  bool get isNotEmpty;
}

///
///
///
mixin _MFieldContainerPositionAble<I> on _MBitsField
    implements _AFlagsContainer<I, bool>, _AFlagsPositionAble<I> {
  @override
  bool operator [](I index) {
    assert(validateIndex(index));
    return _bitOn(_positionOf(index));
  }

  @override
  void operator []=(I index, bool value) {
    assert(validateIndex(index));
    value ? _bitSet(_positionOf(index)) : _bitClear(_positionOf(index));
  }
}

mixin _MFieldContainerMonthsDates
    implements _AFlagsContainer<(int, int, int), bool>, _MBitsFieldMonthsDates {
  @override
  bool operator []((int, int, int) index) {
    assert(validateIndex(index));
    return _bitOn(index.$1, index.$2, index.$3);
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(validateIndex(index));
    value
        ? _bitSet(index.$1, index.$2, index.$3)
        : _bitClear(index.$1, index.$2, index.$3);
  }
}

mixin _MSlotContainerPositionAble<I, T>
    implements _AFlagsContainer<I, T?>, _AFlagsPositionAble<I>, _ASlot<T> {
  @override
  T? operator [](I index) {
    assert(validateIndex(index));
    return _slot[_positionOf(index)];
  }

  @override
  void operator []=(I index, T? value) {
    assert(validateIndex(index));
    _slot[_positionOf(index)] = value;
  }
}

///
///
///
mixin _MOperatableField<F extends FieldParent>
    implements _AField, _AFieldIdentical, _AFlagsOperatable<F> {
  @override
  bool isSizeEqual(F other) {
    if (_sizeEach != other._sizeEach) return false;
    return _field.length == other._field.length;
  }

  @override
  bool operator ==(Object other) {
    if (other is! F) return false;
    if (_sizeEach != other._sizeEach) return false;
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    if (length != fB.length) return false;
    for (var i = 0; i < length; i++) {
      if (fA[i] != fB[i]) return false;
    }
    return true;
  }

  @override
  F operator &(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] & fB[i];
    }
    return result;
  }

  @override
  F operator |(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] | fB[i];
    }
    return result;
  }

  @override
  F operator ^(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newZero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] ^ fB[i];
    }
    return result;
  }

  @override
  void setAnd(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] &= fB[i];
    }
  }

  @override
  void setOr(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] |= fB[i];
    }
  }

  @override
  void setXOr(F other) {
    assert(isSizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] ^= fB[i];
    }
  }
}

mixin _MEquatableSlot<T, S extends ParentSlot<T>>
    implements _ASlot<T>, _AFlagsEquatable<S> {
  @override
  bool isSizeEqual(S other) => _slot.length == other._slot.length;

  @override
  bool operator ==(Object other) {
    if (other is! S) return false;
    final sA = _slot;
    final sB = other._slot;
    final length = sA.length;
    if (length != sB.length) return false;
    for (var i = 0; i < length; i++) {
      if (sA[i] != sB[i]) return false;
    }
    return true;
  }
}

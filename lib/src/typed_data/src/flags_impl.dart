part of '../typed_data.dart';

///
///
///
/// mixin:
/// [_MFlagsO8]
/// [_MFlagsO16]
/// [_MFlagsO32]
/// [_MFlagsO64]
///
/// [_MFieldOperatable]
///
/// [_MBitsField]
/// [_MBitsFieldMonthsDates]
/// [_MBitsFlagsField]
///
/// [_MFieldContainerBits]
/// [_MFieldContainerBitsMonthsDates]
/// [_MFieldBitsIterable]
/// [_MFieldBitsIterableMonthsDates]
///
/// [_MIterableField]
/// [_MIterableFieldIndexable]
/// [_MIterableFieldMonthsDatesScoped]
///
///
///

///
///
///
///
mixin _MFlagsO8 implements _AFlagsBits, _AFlagsIdentical {
  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  int get _sizeEach => TypedIntList.sizeEach8;
}

mixin _MFlagsO16 implements _AFlagsBits, _AFlagsIdentical {
  @override
  int get _shift => TypedIntList.shift16;

  @override
  int get _mask => TypedIntList.mask16;

  @override
  int get _sizeEach => TypedIntList.sizeEach16;
}

mixin _MFlagsO32 implements _AFlagsBits, _AFlagsIdentical {
  @override
  int get _shift => TypedIntList.shift32;

  @override
  int get _mask => TypedIntList.mask32;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MFlagsO64 implements _AFlagsBits, _AFlagsIdentical {
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
///

///
///
/// [isIdentical], [newZero]
/// [==], [&], [|], [^]
/// [setAnd], [setOr], [setXOr]
///
///
mixin _MFieldOperatable<F extends _PField> on _PField
    implements _AFlagsOperatable<F> {
  @override
  bool isIdentical(F other) {
    if (_sizeEach != other._sizeEach) return false;
    return _field.length == other._field.length;
  }

  @override
  F get newZero;

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
    assert(isIdentical(other));
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
    assert(isIdentical(other));
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
    assert(isIdentical(other));
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
    assert(isIdentical(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] &= fB[i];
    }
  }

  @override
  void setOr(F other) {
    assert(isIdentical(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] |= fB[i];
    }
  }

  @override
  void setXOr(F other) {
    assert(isIdentical(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] ^= fB[i];
    }
  }
}

///
///
///
mixin _MBitsField on _PField implements _AFlagsBits {
  bool _bitOn(int position) => _field.bitOn(position, _shift, _mask);

  void _bitSet(int position) => _field.bitSet(position, _shift, _mask);

  void _bitClear(int position) => _field.bitClear(position, _shift, _mask);
}

mixin _MBitsFieldMonthsDates on _PField implements _AFlagsIdentical {
  @override
  int get _sizeEach => TypedIntList.sizeEach32;

  int _fieldIndexFrom(int year, int month);

  bool _bitOn(int year, int month, int day) =>
      _field[_fieldIndexFrom(year, month)] >> day - 1 & 1 == 1;

  void _bitSet(int year, int month, int day) =>
      _field[_fieldIndexFrom(year, month)] |= 1 << day - 1;

  void _bitClear(int year, int month, int day) =>
      _field[_fieldIndexFrom(year, month)] &= ~(1 << day - 1);
}

mixin _MBitsFlagsField implements _AFlagsBits {
  bool _bitOn(int position, TypedDataList<int> list) =>
      list.bitOn(position, _shift, _mask);

  void _bitSet(int position, TypedDataList<int> list) =>
      list.bitSet(position, _shift, _mask);

  void _bitClear(int position, TypedDataList<int> list) =>
      list.bitClear(position, _shift, _mask);

  TypedDataList<int> get _newField;

  TypedDataList<int> _bitSetNewField(int position) =>
      _newField..[position >> _shift] = 1 << (position & _mask) - 1;

  bool get isEmpty;

  bool get isNotEmpty;
}

///
///
///
mixin _MFieldContainerBits<T> on _MBitsField implements _AFlagsContainer<T> {
  @override
  bool operator [](covariant T index) {
    assert(validateIndex(index));
    return _bitOn(_positionOf(index));
  }

  @override
  void operator []=(covariant T index, bool value) {
    assert(validateIndex(index));
    value ? _bitSet(_positionOf(index)) : _bitClear(_positionOf(index));
  }

  int _positionOf(T index);
}

mixin _MFieldContainerBitsMonthsDates on _MBitsFieldMonthsDates
    implements _AFlagsContainer<(int, int, int)> {
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

///
///
///
mixin _MFieldBitsIterable<T> on _MBitsField implements _AFlagsIterable<T> {
  @override
  void includesRange(T begin, T limit) => _ranges(_bitSet, begin, limit);

  @override
  void excludesRange(T begin, T limit) => _ranges(_bitClear, begin, limit);

  void _ranges(Consumer<int> consume, T begin, T limit);
}

mixin _MFieldBitsIterableMonthsDates on _MBitsFieldMonthsDates
    implements _AFlagsIterable<(int, int, int)> {
  @override
  void includesRange((int, int, int) begin, (int, int, int) limit) =>
      _ranges(_bitSet, begin, limit);

  @override
  void excludesRange((int, int, int) begin, (int, int, int) limit) =>
      _ranges(_bitClear, begin, limit);

  void _ranges(
    TriCallback<int> consume,
    (int, int, int) begin,
    (int, int, int) limit,
  );
}

///
///
///
mixin _MIterableField on _PField implements _AFlagsIterable<int> {
  @override
  int? get flagFirst => _field.bitFirst(_sizeEach);

  @override
  int? get flagLast => _field.bitLast(_sizeEach);
}

mixin _MIterableFieldIndexable<T> on _PField implements _AFlagsIterable<T> {
  @override
  T? get flagFirst => _field.bitFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get flagLast => _field.bitLast(_sizeEach).nullOrMap(_indexOf);

  T _indexOf(int position);
}

mixin _MIterableFieldMonthsDatesScoped on _PFieldScoped<(int, int)>
    implements _AFlagsIterable<(int, int, int)> {
  @override
  (int, int, int)? get flagFirst {
    final begin = this.begin;
    final field = _field;
    final length = field.length;

    var y = begin.$1;
    var m = begin.$2;
    for (var i = 0; i < length; i++) {
      for (var bits = field[i], d = 1; bits > 0; bits >>= 1, d++) {
        if (bits & 1 == 1) return (y, m, d);
      }

      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return null;
  }

  @override
  (int, int, int)? get flagLast {
    final end = this.end;
    final field = _field;

    var y = end.$1;
    var m = end.$2;
    for (var i = field.length - 1; i > -1; i++) {
      for (
        var bits = field[i], mask = 1 << 30, d = 31;
        mask > 0;
        mask >>= 1, d--
      ) {
        if ((bits & mask) >> d - 1 == 1) return (y, m, d);
      }

      m--;
      if (m < 1) {
        m = 12;
        y--;
      }
    }
    return null;
  }
}

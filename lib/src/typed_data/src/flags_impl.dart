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
/// [_MBitsField]
/// [_MBitsFieldMonthsDates]
/// [_MBitsFlagsField]
///
/// [_MFieldContainerBits]
/// [_MFieldContainerBitsMonthsDates]
/// [_MFieldBitsSet]
/// [_MFieldBitsSetMonthsDates]
///
/// [_MSetField]
/// [_MSetFieldIndexable]
/// [_MSetFieldMonthsDatesScoped]
///
/// [_MFieldOperatable]
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
///
mixin _MBitsField implements _AField, _AFieldBits {
  bool _bitOn(int position) => _field.bitOn(position, _shift, _mask);

  void _bitSet(int position) => _field.bitSet(position, _shift, _mask);

  void _bitClear(int position) => _field.bitClear(position, _shift, _mask);
}

mixin _MBitsFieldMonthsDates implements _AField, _AFieldIdentical {
  bool _bitOn(int year, int month, int day) =>
      _field[_fieldIndexOf(year, month)] >> day - 1 & 1 == 1;

  void _bitSet(int year, int month, int day) =>
      _field[_fieldIndexOf(year, month)] |= 1 << day - 1;

  void _bitClear(int year, int month, int day) =>
      _field[_fieldIndexOf(year, month)] &= ~(1 << day - 1);

  @override
  int get _sizeEach => TypedIntList.sizeEach32;

  int _fieldIndexOf(int year, int month);
}

mixin _MBitsFlagsField implements _AFieldBits {
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
mixin _MFieldContainerBits<I> on _MBitsField
    implements _AFlagsContainer<I, bool> {
  @override
  bool operator [](covariant I index) {
    assert(validateIndex(index));
    return _bitOn(_positionOf(index));
  }

  @override
  void operator []=(covariant I index, bool value) {
    assert(validateIndex(index));
    value ? _bitSet(_positionOf(index)) : _bitClear(_positionOf(index));
  }

  int _positionOf(I index);
}

mixin _MFieldContainerBitsMonthsDates on _MBitsFieldMonthsDates
    implements _AFlagsContainer<(int, int, int), bool> {
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

// mixin _MSlotContainerBits<I, T> implements _ASlot<T>, _AFlagsContainer<I, T?> {
//   @override
//   T? operator [](covariant I index) {
//     assert(validateIndex(index));
//     return _slot[_positionOf(index)];
//   }
//
//   @override
//   void operator []=(covariant I index, covariant T value) {
//     assert(validateIndex(index));
//     _slot[_positionOf(index)] = value;
//   }
//
//   int _positionOf(I index);
// }
//
// mixin _MSlotContainerBitsMonthsDates<T>
//     implements _ASlot<T>, _AFlagsContainer<(int, int, int), T?> {
//   @override
//   T? operator []((int, int, int) index) {
//     assert(validateIndex(index));
//     return _slot[daysOf(index.$1, index.$2, index.$3)];
//   }
//
//   @override
//   void operator []=((int, int, int) index, T? value) {
//     assert(validateIndex(index));
//     _slot[daysOf(index.$1, index.$2, index.$3)] = value;
//   }
//
//   int daysOf(int year, int month, int day);
// }

///
///
///
mixin _MFieldBitsSet<T> on _MBitsField implements _AFieldSet<T> {
  @override
  void includesRange(T begin, T limit) => _ranges(begin, limit, _bitSet);

  @override
  void excludesRange(T begin, T limit) => _ranges(begin, limit, _bitClear);

  void _ranges(T begin, T limit, Consumer<int> consume);
}

mixin _MFieldBitsSetMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int)> {
  @override
  void includesRange((int, int, int) begin, (int, int, int) limit) =>
      _ranges(begin, limit, _bitSet);

  @override
  void excludesRange((int, int, int) begin, (int, int, int) limit) =>
      _ranges(begin, limit, _bitClear);

  void _ranges(
    (int, int, int) begin,
    (int, int, int) limit,
    TriCallback<int> consume,
  );
}

///
///
///
mixin _MSetField implements _AField, _AFieldIdentical, _AFlagsSet<int> {
  @override
  int? get first => _field.bitFirst(_sizeEach);

  @override
  int? get last => _field.bitLast(_sizeEach);
}

mixin _MSetFieldIndexable<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T> {
  @override
  T? get first => _field.bitFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.bitLast(_sizeEach).nullOrMap(_indexOf);

  T _indexOf(int position);
}

mixin _MSetFieldMonthsDatesScoped on _PFieldScoped<(int, int)>
    implements _AFlagsSet<(int, int, int)> {
  @override
  (int, int, int)? get first {
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
  (int, int, int)? get last {
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

mixin _MSetSlot<T> implements _ASlot<T>, _ASlotSet<T> {
  @override
  T? get first {
    final slot = _slot;
    final length = slot.length;
    for (var i = 0; i < length; i++) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? get last {
    final slot = _slot;
    final length = slot.length;
    for (var i = length - 1; i > -1; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> filterOn(FieldParent field) sync* {
    final slot = _slot;
    final length = slot.length;
    final f = field._field;
    final sizeEach = field._sizeEach;
    final count = f.length;
    assert(length == sizeEach * count);
    for (var j = 0; j < count; j++) {
      final start = j * sizeEach;
      for (var i = 0, bits = f[j]; i < sizeEach; i++, bits >>= 1) {
        if (bits & 1 == 1) {
          final value = slot[start + i];
          if (value != null) yield value;
        }
      }
    }
  }
}

///
///
///
mixin _MFieldOperatable<F extends FieldParent>
    implements _AField, _AFieldIdentical, _AFlagsOperatable<F> {
  @override
  bool isSizeEqual(F other) {
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

mixin _MSlotInit<T, S extends _PSlot<T>> implements _ASlot<T>, _AFlagsInit<S> {
  @override
  bool isSizeEqual(S other) => _slot.length == other._slot.length;

  @override
  S get newZero;

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

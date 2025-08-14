part of '../typed_data.dart';

///
///
/// mixin:
/// [_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
/// [_MixinFlagsInsertAble]
/// [_MixinFieldPositionAble], [_MixinFieldOperatable]
/// [_MixinContainerFieldPositionAble]
///
/// concrete class:
/// [_Field8], ...
/// [_Field2D8], ...
/// [_Field3D8], ...
///
///
///

///
///
///
///
///
///
mixin _MixinFlagsOperate8 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift8;

  @override
  int get _mask => TypedIntList.mask8;

  @override
  int get _sizeEach => TypedIntList.sizeEach8;
}

mixin _MixinFlagsOperate16 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift16;

  @override
  int get _mask => TypedIntList.mask16;

  @override
  int get _sizeEach => TypedIntList.sizeEach16;
}

mixin _MixinFlagsOperate32 implements _FlagsOperator {
  @override
  int get _shift => TypedIntList.shift32;

  @override
  int get _mask => TypedIntList.mask32;

  @override
  int get _sizeEach => TypedIntList.sizeEach32;
}

mixin _MixinFlagsOperate64 implements _FlagsOperator {
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
mixin _MixinFlagsInsertAble implements _FlagsOperator {
  bool _mutateBitOn(int position, TypedDataList<int> list) =>
      list.bitOn(position, _shift, _mask);

  void _mutateBitSet(int position, TypedDataList<int> list) =>
      list.bitSet(position, _shift, _mask);

  void _mutateBitClear(int position, TypedDataList<int> list) =>
      list.bitClear(position, _shift, _mask);

  TypedDataList<int> get _newList;

  TypedDataList<int> _newInsertion(int position) =>
      _newList..[position >> _shift] = 1 << (position & _mask) - 1;

  bool get isEmpty;

  bool get isNotEmpty;
}

///
///
///
mixin _MixinFieldPositionAble implements _FlagsOperator, _FlagsField {
  bool _bitOn(int position) => _field.bitOn(position, _shift, _mask);

  void _bitSet(int position) => _field.bitSet(position, _shift, _mask);

  void _bitClear(int position) => _field.bitClear(position, _shift, _mask);
}

mixin _MixinFieldOperatable<F extends _FieldParent>
    implements _FlagsOperator, _FlagsField {
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

  ///
  /// [sizeEqual], [zero]
  /// [&], [|], [^]
  /// [setAnd], [setOr], [setXOr]
  ///
  bool sizeEqual(F other) {
    if (_sizeEach != other._sizeEach) return false;
    return _field.length == other._field.length;
  }

  F get zero;

  F operator &(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = zero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] & fB[i];
    }
    return result;
  }

  F operator |(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = zero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] | fB[i];
    }
    return result;
  }

  F operator ^(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = zero;
    final fB = other._field;
    final fR = result._field;
    for (var i = 0; i < length; i++) {
      fR[i] = fA[i] ^ fB[i];
    }
    return result;
  }

  void setAnd(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] &= fB[i];
    }
  }

  void setOr(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final fB = other._field;
    final length = fA.length;
    for (var i = 0; i < length; i++) {
      fA[i] |= fB[i];
    }
  }

  void setXOr(F other) {
    assert(sizeEqual(other));
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
mixin _MixinContainerFieldPositionAble<T>
    implements _FlagsContainer<T>, _MixinFieldPositionAble {
  int _positionOf(T index);

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
}

//
class _Field8 extends Field with _MixinFlagsOperate8 {
  _Field8(int width) : super._(width, Uint8List(1));

  @override
  Field get zero => _Field8(width);
}

class _Field16 extends Field with _MixinFlagsOperate16 {
  _Field16(int width) : super._(width, Uint16List(1));

  @override
  Field get zero => _Field16(width);
}

class _Field32 extends Field with _MixinFlagsOperate32 {
  _Field32(int s) : super._(s, Uint32List(s));

  @override
  Field get zero => _Field32(_field.length);
}

class _Field64 extends Field with _MixinFlagsOperate64 {
  _Field64(int s) : super._(s, Uint64List(s));

  @override
  Field get zero => _Field64(_field.length);
}

//
class _Field2D8 extends Field2D with _MixinFlagsOperate8 {
  _Field2D8(int w, int h) : super._(w, h, Uint8List(1));

  @override
  Field2D get zero => _Field2D8(width, height);
}

class _Field2D16 extends Field2D with _MixinFlagsOperate16 {
  _Field2D16(int w, int h) : super._(w, h, Uint16List(1));

  @override
  Field2D get zero => _Field2D8(width, height);
}

class _Field2D32 extends Field2D with _MixinFlagsOperate32 {
  _Field2D32(int w, int h, int s) : super._(w, h, Uint32List(s));

  @override
  Field2D get zero => _Field2D32(width, height, _field.length);
}

class _Field2D64 extends Field2D with _MixinFlagsOperate64 {
  _Field2D64(int w, int h, int s) : super._(w, h, Uint64List(s));

  @override
  Field2D get zero => _Field2D64(width, height, _field.length);
}

//
class _Field3D8 extends Field3D with _MixinFlagsOperate8 {
  _Field3D8(int w, int h, int d) : super._(w, h, d, Uint8List(1));

  @override
  Field3D get zero => _Field3D8(width, height, depth);
}

class _Field3D16 extends Field3D with _MixinFlagsOperate16 {
  _Field3D16(int w, int h, int d) : super._(w, h, d, Uint16List(1));

  @override
  Field3D get zero => _Field3D16(width, height, depth);
}

class _Field3D32 extends Field3D with _MixinFlagsOperate32 {
  _Field3D32(int w, int h, int d, int s) : super._(w, h, d, Uint32List(s));

  @override
  Field3D get zero => _Field3D32(width, height, depth, _field.length);
}

class _Field3D64 extends Field3D with _MixinFlagsOperate64 {
  _Field3D64(int w, int h, int d, int s) : super._(w, h, d, Uint64List(s));

  @override
  Field3D get zero => _Field3D64(width, height, depth, _field.length);
}

//
class _FieldADay8 extends FieldADay with _MixinFlagsOperate8 {
  _FieldADay8.perHour() // 24 bits
    : super._(FieldADay._validateMinute_perHour, 6, 1, 60, Uint8List(3));

  _FieldADay8.per30Minute() // 72 bits
    : super._(FieldADay._validateMinute_per20Minute, 4, 3, 20, Uint8List(9));

  _FieldADay8._(
    super.validateMinute,
    super._toStringHoursPerLine,
    super._hourDivision,
    super._minuteModulus,
    super._field,
  ) : super._();

  @override
  FieldADay get zero => _FieldADay8._(
    validateMinute,
    _toStringHoursPerLine,
    _hourDivision,
    _minuteModulus,
    Uint8List(_field.length),
  );
}

class _FieldADay16 extends FieldADay with _MixinFlagsOperate16 {
  _FieldADay16.per30Minute() // 48 bits
    : super._(FieldADay._validateMinute_per30Minute, 4, 2, 30, Uint16List(3));

  _FieldADay16.per10Minute() // 144 bits
    : super._(FieldADay._validateMinute_per10Minute, 3, 6, 10, Uint16List(9));

  _FieldADay16._(
    super.validateMinute,
    super._toStringHoursPerLine,
    super._hourDivision,
    super._minuteModulus,
    super._field,
  ) : super._();

  @override
  FieldADay get zero => _FieldADay16._(
    validateMinute,
    _toStringHoursPerLine,
    _hourDivision,
    _minuteModulus,
    Uint16List(_field.length),
  );
}

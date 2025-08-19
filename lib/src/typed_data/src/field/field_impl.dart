part of '../../typed_data.dart';

///
///
/// mixin:
/// [_MixinFieldOperatable]
/// [_MixinFieldPositionAble]
/// [_MixinFieldPositionAbleContainer]
/// [_MixinFieldIterable]
/// [_MixinFieldIterableIndex]
///
/// concrete class:
/// [_Field8], ...
/// [_Field2D8], ...
/// [_Field3D8], ...
/// [_Field4D8], ...
/// [_FieldAB8], ...
///
///

///
///
/// [sizeEqual], [newFieldZero]
/// [==], [&], [|], [^]
/// [setAnd], [setOr], [setXOr]
///
///
mixin _MixinFieldOperatable<F extends _FieldParent> on _FieldParent {
  bool sizeEqual(F other) {
    if (_sizeEach != other._sizeEach) return false;
    return _field.length == other._field.length;
  }

  F get newFieldZero;

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

  F operator &(F other) {
    assert(sizeEqual(other));
    final fA = _field;
    final length = fA.length;
    final result = newFieldZero;
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
    final result = newFieldZero;
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
    final result = newFieldZero;
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
mixin _MixinFieldPositionAble on _FieldParent implements _FlagsOperator {
  bool _bitOn(int position) => _field.bitOn(position, _shift, _mask);

  void _bitSet(int position) => _field.bitSet(position, _shift, _mask);

  void _bitClear(int position) => _field.bitClear(position, _shift, _mask);
}

mixin _MixinFieldPositionAbleIterable<T> on _MixinFieldPositionAble
    implements _FlagsIterable<T> {
  @override
  void includesRange(T begin, T end) => _ranges(_bitSet, begin, end);

  @override
  void excludesRange(T begin, T end) => _ranges(_bitClear, begin, end);

  void _ranges(Consumer<int> consume, T begin, T limit);
}

mixin _MixinFieldPositionAbleContainer<T> on _MixinFieldPositionAble
    implements _FlagsContainer<T> {
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

mixin _MixinFieldIterable on _FieldParent implements _FlagsIterable<int> {
  @override
  int? get flagFirst => _field.bitFirst(_sizeEach);

  @override
  int? get flagLast => _field.bitLast(_sizeEach);
}

mixin _MixinFieldIterableIndex<T> on _FieldParent implements _FlagsIterable<T> {
  @override
  T? get flagFirst => _field.bitFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get flagLast => _field.bitLast(_sizeEach).nullOrMap(_indexOf);

  T _indexOf(int position);
}

///
///
///
///
///
///
///

//
class _Field8 extends Field with _MixinFlagsOperate8 {
  _Field8(int width) : super._(width, Uint8List(1));

  @override
  Field get newFieldZero => _Field8(spatial1);
}

class _Field16 extends Field with _MixinFlagsOperate16 {
  _Field16(int width) : super._(width, Uint16List(1));

  @override
  Field get newFieldZero => _Field16(spatial1);
}

class _Field32 extends Field with _MixinFlagsOperate32 {
  _Field32(int width, int s) : super._(width, Uint32List(s));

  @override
  Field get newFieldZero => _Field32(spatial1, _field.length);
}

class _Field64 extends Field with _MixinFlagsOperate64 {
  _Field64(int width, int s) : super._(width, Uint64List(s));

  @override
  Field get newFieldZero => _Field64(spatial1, _field.length);
}

//
class _Field2D8 extends Field2D with _MixinFlagsOperate8 {
  _Field2D8(int w, int h) : super._(w, h, Uint8List(1));

  @override
  Field2D get newFieldZero => _Field2D8(spatial1, spatial2);
}

class _Field2D16 extends Field2D with _MixinFlagsOperate16 {
  _Field2D16(int w, int h) : super._(w, h, Uint16List(1));

  @override
  Field2D get newFieldZero => _Field2D8(spatial1, spatial2);
}

class _Field2D32 extends Field2D with _MixinFlagsOperate32 {
  _Field2D32(int w, int h, int s) : super._(w, h, Uint32List(s));

  @override
  Field2D get newFieldZero => _Field2D32(spatial1, spatial2, _field.length);
}

class _Field2D64 extends Field2D with _MixinFlagsOperate64 {
  _Field2D64(int w, int h, int s) : super._(w, h, Uint64List(s));

  @override
  Field2D get newFieldZero => _Field2D64(spatial1, spatial2, _field.length);
}

//
class _Field3D8 extends Field3D with _MixinFlagsOperate8 {
  _Field3D8(int w, int h, int d) : super._(w, h, d, Uint8List(1));

  @override
  Field3D get newFieldZero => _Field3D8(spatial1, spatial2, spatial3);
}

class _Field3D16 extends Field3D with _MixinFlagsOperate16 {
  _Field3D16(int w, int h, int d) : super._(w, h, d, Uint16List(1));

  @override
  Field3D get newFieldZero => _Field3D16(spatial1, spatial2, spatial3);
}

class _Field3D32 extends Field3D with _MixinFlagsOperate32 {
  _Field3D32(int w, int h, int d, int s) : super._(w, h, d, Uint32List(s));

  @override
  Field3D get newFieldZero =>
      _Field3D32(spatial1, spatial2, spatial3, _field.length);
}

class _Field3D64 extends Field3D with _MixinFlagsOperate64 {
  _Field3D64(int w, int h, int d, int s) : super._(w, h, d, Uint64List(s));

  @override
  Field3D get newFieldZero =>
      _Field3D64(spatial1, spatial2, spatial3, _field.length);
}

//
class _Field4D8 extends Field4D with _MixinFlagsOperate8 {
  _Field4D8(int a, int b, int c, int d) : super._(a, b, c, d, Uint8List(1));

  @override
  Field4D get newFieldZero => _Field4D8(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D16 extends Field4D with _MixinFlagsOperate16 {
  _Field4D16(int a, int b, int c, int d) : super._(a, b, c, d, Uint16List(1));

  @override
  Field4D get newFieldZero =>
      _Field4D16(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D32 extends Field4D with _MixinFlagsOperate32 {
  _Field4D32(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint32List(s));

  @override
  Field4D get newFieldZero =>
      _Field4D32(spatial1, spatial2, spatial3, spatial4, _field.length);
}

class _Field4D64 extends Field4D with _MixinFlagsOperate64 {
  _Field4D64(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint64List(s));

  @override
  Field4D get newFieldZero =>
      _Field4D64(spatial1, spatial2, spatial3, spatial4, _field.length);
}

//
class _FieldAB8 extends FieldAB with _MixinFlagsOperate8 {
  _FieldAB8.dayPer12Minute() : super._(_validate_per12m, 5, Uint8List(9));

  _FieldAB8.dayPer20Minute() : super._(_validate_per20m, 3, Uint8List(9));

  _FieldAB8.dayPerHour() : super._(_validate_perH, 1, Uint8List(3));

  _FieldAB8._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newFieldZero =>
      _FieldAB8._(bValidate, bDivision, Uint8List(_field.length));

  static bool _validate_perH(int minute) => minute == 0;

  static bool _validate_per20m(int minute) =>
      minute == 0 || minute == 20 || minute == 40;

  static bool _validate_per12m(int minute) =>
      minute == 0 ||
      minute == 12 ||
      minute == 24 ||
      minute == 36 ||
      minute == 48;
}

class _FieldAB16 extends FieldAB with _MixinFlagsOperate16 {
  _FieldAB16.dayPer10Minute() : super._(_validate_per10m, 6, Uint16List(9));

  _FieldAB16.dayPer15Minute() : super._(_validate_per15m, 4, Uint16List(9));

  _FieldAB16.dayPer30Minute() : super._(_validate_per30m, 2, Uint16List(3));

  _FieldAB16._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newFieldZero =>
      _FieldAB16._(bValidate, bDivision, Uint16List(_field.length));

  static bool _validate_per30m(int minute) => minute == 0 || minute == 30;

  static bool _validate_per15m(int minute) =>
      minute == 0 || minute == 15 || minute == 30 || minute == 45;

  static bool _validate_per10m(int minute) =>
      minute == 0 ||
      minute == 10 ||
      minute == 20 ||
      minute == 30 ||
      minute == 40 ||
      minute == 50;
}

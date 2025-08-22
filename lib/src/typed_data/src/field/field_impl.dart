part of '../../typed_data.dart';

///
///
/// concrete class:
/// [_Field8], ...
/// [_Field2D8], ...
/// [_Field3D8], ...
/// [_Field4D8], ...
/// [_FieldAB8], ...
///
///

//
class _Field8 extends Field with _MFlagsO8 {
  _Field8(int width) : super._(width, Uint8List(1));

  @override
  Field get newZero => _Field8(spatial1);
}

class _Field16 extends Field with _MFlagsO16 {
  _Field16(int width) : super._(width, Uint16List(1));

  @override
  Field get newZero => _Field16(spatial1);
}

class _Field32 extends Field with _MFlagsO32 {
  _Field32(int width, int s) : super._(width, Uint32List(s));

  @override
  Field get newZero => _Field32(spatial1, _field.length);
}

class _Field64 extends Field with _MFlagsO64 {
  _Field64(int width, int s) : super._(width, Uint64List(s));

  @override
  Field get newZero => _Field64(spatial1, _field.length);
}

//
class _Field2D8 extends Field2D with _MFlagsO8 {
  _Field2D8(int w, int h) : super._(w, h, Uint8List(1));

  @override
  Field2D get newZero => _Field2D8(spatial1, spatial2);
}

class _Field2D16 extends Field2D with _MFlagsO16 {
  _Field2D16(int w, int h) : super._(w, h, Uint16List(1));

  @override
  Field2D get newZero => _Field2D8(spatial1, spatial2);
}

class _Field2D32 extends Field2D with _MFlagsO32 {
  _Field2D32(int w, int h, int s) : super._(w, h, Uint32List(s));

  @override
  Field2D get newZero => _Field2D32(spatial1, spatial2, _field.length);
}

class _Field2D64 extends Field2D with _MFlagsO64 {
  _Field2D64(int w, int h, int s) : super._(w, h, Uint64List(s));

  @override
  Field2D get newZero => _Field2D64(spatial1, spatial2, _field.length);
}

//
class _Field3D8 extends Field3D with _MFlagsO8 {
  _Field3D8(int w, int h, int d) : super._(w, h, d, Uint8List(1));

  @override
  Field3D get newZero => _Field3D8(spatial1, spatial2, spatial3);
}

class _Field3D16 extends Field3D with _MFlagsO16 {
  _Field3D16(int w, int h, int d) : super._(w, h, d, Uint16List(1));

  @override
  Field3D get newZero => _Field3D16(spatial1, spatial2, spatial3);
}

class _Field3D32 extends Field3D with _MFlagsO32 {
  _Field3D32(int w, int h, int d, int s) : super._(w, h, d, Uint32List(s));

  @override
  Field3D get newZero =>
      _Field3D32(spatial1, spatial2, spatial3, _field.length);
}

class _Field3D64 extends Field3D with _MFlagsO64 {
  _Field3D64(int w, int h, int d, int s) : super._(w, h, d, Uint64List(s));

  @override
  Field3D get newZero =>
      _Field3D64(spatial1, spatial2, spatial3, _field.length);
}

//
class _Field4D8 extends Field4D with _MFlagsO8 {
  _Field4D8(int a, int b, int c, int d) : super._(a, b, c, d, Uint8List(1));

  @override
  Field4D get newZero => _Field4D8(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D16 extends Field4D with _MFlagsO16 {
  _Field4D16(int a, int b, int c, int d) : super._(a, b, c, d, Uint16List(1));

  @override
  Field4D get newZero =>
      _Field4D16(spatial1, spatial2, spatial3, spatial4);
}

class _Field4D32 extends Field4D with _MFlagsO32 {
  _Field4D32(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint32List(s));

  @override
  Field4D get newZero =>
      _Field4D32(spatial1, spatial2, spatial3, spatial4, _field.length);
}

class _Field4D64 extends Field4D with _MFlagsO64 {
  _Field4D64(int a, int b, int c, int d, int s)
    : super._(a, b, c, d, Uint64List(s));

  @override
  Field4D get newZero =>
      _Field4D64(spatial1, spatial2, spatial3, spatial4, _field.length);
}

//
class _FieldAB8 extends FieldAB with _MFlagsO8 {
  _FieldAB8.dayPer12Minute() : super._(_validate_per12m, 5, Uint8List(9));

  _FieldAB8.dayPer20Minute() : super._(_validate_per20m, 3, Uint8List(9));

  _FieldAB8.dayPerHour() : super._(_validate_perH, 1, Uint8List(3));

  _FieldAB8._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newZero =>
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

class _FieldAB16 extends FieldAB with _MFlagsO16 {
  _FieldAB16.dayPer10Minute() : super._(_validate_per10m, 6, Uint16List(9));

  _FieldAB16.dayPer15Minute() : super._(_validate_per15m, 4, Uint16List(9));

  _FieldAB16.dayPer30Minute() : super._(_validate_per30m, 2, Uint16List(3));

  _FieldAB16._(super.bValidate, super.bDivision, super._field) : super._();

  @override
  FieldAB get newZero =>
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

part of '../typed_data.dart';

///
///
/// prefix 'A' stands for abstraction, with contract
/// [_AFlagsContainer]
/// [_AFlagsBits]
/// [_AFlagsOperatable]
/// [_AFlagsIterable]
/// [_AFlagsIdentical]
/// [_AFieldCollapse]
///
/// prefix 'P' stands for parent class, with  (with field)
/// [_PField]
/// [_PFieldSpatial1]
/// [_PFieldSpatial2]
/// [_PFieldSpatial3]
/// [_PFieldSpatial4]
/// [_PFieldScoped]
///
///

abstract class _AFlagsContainer<T> implements _PFlags {
  const _AFlagsContainer();

  bool validateIndex(T index);

  bool operator [](T index);

  void operator []=(T index, bool value);
}

abstract class _AFlagsIdentical implements _PFlags {
  const _AFlagsIdentical();

  int get _sizeEach;
}

abstract class _AFlagsBits implements _PFlags {
  const _AFlagsBits();

  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;
}

abstract class _AFlagsOperatable<F> implements _PFlags {
  const _AFlagsOperatable();

  bool isIdentical(F other);

  F get newZero;

  F operator &(F other);

  F operator |(F other);

  F operator ^(F other);

  void setAnd(F other);

  void setOr(F other);

  void setXOr(F other);
}

abstract class _AFlagsIterable<T> implements _PFlags {
  const _AFlagsIterable();

  T? get flagFirst;

  T? get flagLast;

  void includesRange(T begin, T limit);

  void excludesRange(T begin, T limit);

  // T? flagsFirstAfter(int position);
  //
  // T? flagsLastBefore(int position);
  //
  // Iterable<T> get flags;
  //
  // Iterable<T> flagsFrom(int position, [bool inclusive = true]);
  //
  // Iterable<T> flagsTo(int position, [bool inclusive = true]);
  //
  // Iterable<T> flagsBetween(int pBegin, int pEnd, [bool inclusive = true]);
}

abstract class _AFieldCollapse<S> implements _PFieldSpatial2 {
  const _AFieldCollapse();

  S collapseOn(int index);
}

///
///
///
abstract class _PField extends _PFlags implements _AFlagsIdentical {
  final TypedDataList<int> _field;

  const _PField(this._field);

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }

  int get sizeField => _sizeEach * _field.length;
}

//
sealed class _PFieldSpatial1 extends _PField with _MBitsField {
  final int spatial1;

  const _PFieldSpatial1(this.spatial1, super._field);
}

abstract class _PFieldSpatial2 extends _PFieldSpatial1 {
  final int spatial2;

  const _PFieldSpatial2(super.spatial1, this.spatial2, super.field);
}

abstract class _PFieldSpatial3 extends _PFieldSpatial2 {
  final int spatial3;

  const _PFieldSpatial3(
    super.spatial1,
    super.spatial2,
    this.spatial3,
    super.field,
  );
}

abstract class _PFieldSpatial4 extends _PFieldSpatial3 {
  final int spatial4;

  const _PFieldSpatial4(
    super.spatial1,
    super.spatial2,
    super.spatial3,
    this.spatial4,
    super.field,
  );
}

///
///
///
abstract class _PFieldScoped<T> extends _PField {
  final T begin;
  final T end;

  const _PFieldScoped(this.begin, this.end, super.field);
}

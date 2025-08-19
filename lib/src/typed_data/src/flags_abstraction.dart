part of '../typed_data.dart';

///
///
/// abstract contract
/// [_FlagsContainer]
/// [_FlagsOperator]
/// [_FlagsIterable]
/// [_FieldSpatialCollapse]
///
/// parent class:
/// [_FieldParent]
/// [_FieldParentSpatial1]
/// [_FieldParentSpatial2]
/// [_FieldParentSpatial3]
/// [_FieldParentSpatial4]
/// [_FieldParentScope]
///
///

///
/// the abstract functions be in [_FlagsContainer], instead of be in [_FieldParent],
/// preventing redundant, ambiguous generic type pass through out many-level inheritance.
///
abstract class _FlagsContainer<T> implements _FlagsParent {
  const _FlagsContainer();

  bool validateIndex(T index);

  bool operator [](T index);

  void operator []=(T index, bool value);
}

abstract class _FlagsOperator implements _FlagsParent {
  const _FlagsOperator();

  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;
}

abstract class _FlagsIterable<T> implements _FlagsParent {
  const _FlagsIterable();

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

abstract class _FieldSpatialCollapse<S> implements _FieldParentSpatial2 {
  const _FieldSpatialCollapse();

  S collapseOn(int index);
}

///
///
///
///
///
///
abstract class _FieldParent extends _FlagsParent {
  final TypedDataList<int> _field;

  const _FieldParent(this._field);

  int get sizeField => _sizeEach * _field.length;

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }
}

//
sealed class _FieldParentSpatial1 extends _FieldParent
    with _MixinFieldPositionAble {
  final int spatial1;

  const _FieldParentSpatial1(this.spatial1, super._field);
}

abstract class _FieldParentSpatial2 extends _FieldParentSpatial1 {
  final int spatial2;

  const _FieldParentSpatial2(super.spatial1, this.spatial2, super.field);
}

abstract class _FieldParentSpatial3 extends _FieldParentSpatial2 {
  final int spatial3;

  const _FieldParentSpatial3(
    super.spatial1,
    super.spatial2,
    this.spatial3,
    super.field,
  );
}

abstract class _FieldParentSpatial4 extends _FieldParentSpatial3 {
  final int spatial4;

  const _FieldParentSpatial4(
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
abstract class _FieldParentScope<T> extends _FieldParent {
  final T begin;
  final T end;

  const _FieldParentScope(this.begin, this.end, super.field);
}

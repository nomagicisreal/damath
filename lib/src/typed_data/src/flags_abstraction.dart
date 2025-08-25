part of '../typed_data.dart';

///
///
/// prefix 'A' stands for abstraction, with contract
/// [_AFlagsContainer]
/// [_AFlagsSpatial1], [_AFlagsSpatial2], [_AFlagsSpatial3], [_AFlagsSpatial4]
/// [_AFlagsCollapse]
/// [_AFlagsOperatable]
/// [_AField]
/// [_AFieldBits]
/// [_AFlagsSet]
/// [_AFieldIdentical]
///
/// prefix 'P' stands for parent class, with  (with field)
/// [FieldParent]
/// [_PFieldSpatial1]
/// [_PFieldSpatial2]
/// [_PFieldSpatial3]
/// [_PFieldSpatial4]
/// [_PFieldScoped]
///
///

abstract class _AFlagsContainer<I, S> implements _PFlags {
  bool validateIndex(I index);

  S operator [](I index);

  void operator []=(I index, S value);
}

abstract class _AFlagsScoped<T> implements _PFlags {
  T get begin;

  T get end;
}

abstract class _AFlagsSpatial1 implements _PFlags {
  int get spatial1;
}

abstract class _AFlagsSpatial2 implements _AFlagsSpatial1 {
  int get spatial2;
}

abstract class _AFlagsSpatial3 implements _AFlagsSpatial2 {
  int get spatial3;
}

abstract class _AFlagsSpatial4 implements _AFlagsSpatial3 {
  int get spatial4;
}

abstract class _AFlagsPositionAble<I> implements _PFlags {
  int _positionOf(I index);
}

abstract class _AFlagsCollapse<S> implements _PFlags {
  S collapseOn(int index);
}

abstract class _AFlagsEquatable<F> implements _PFlags {
  bool isSizeEqual(F other);

}

abstract class _AFlagsOperatable<F> implements _AFlagsEquatable<F> {
  F get newZero;

  F operator &(F other);

  F operator |(F other);

  F operator ^(F other);

  void setAnd(F other);

  void setOr(F other);

  void setXOr(F other);
}

abstract class _AFlagsSet<T> implements _PFlags {
  T? get first;

  T? get last;

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

///
///
///
abstract class _AField implements _PFlags {
  TypedDataList<int> get _field;
}

abstract class _AFieldIdentical implements _PFlags {
  int get _sizeEach;
}

abstract class _AFieldBits implements _PFlags {
  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;
}

abstract class _AFieldSet<T> implements _AFlagsSet<T> {
  void includesSub(T begin, [T? limit]);

  void excludesSub(T begin, [T? limit]);

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

//
sealed class FieldParent extends _PFlags implements _AField, _AFieldIdentical {
  @override
  final TypedDataList<int> _field;

  const FieldParent(this._field);

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }

  int get size => _sizeEach * _field.length;
}

///
///
///
abstract class _ASlot<T> implements _PFlags {
  List<T?> get _slot;
}

abstract class _ASlotSet<I, T> implements _AFlagsSet<T> {
  Iterable<T> filterOn(FieldParent field);

  void pasteSub(T value, I begin, [I? limit]);

  void includesFrom(Iterable<T> iterable, I begin, [bool inclusive]);
  void includesTo(Iterable<T> iterable, I limit, [bool inclusive]);
}

abstract class ParentSlot<T> extends _PFlags implements _ASlot<T> {
  @override
  final List<T?> _slot;

  ParentSlot(int size) : _slot = List.filled(size, null);

  @override
  void clear() => _slot.filled(null);
}

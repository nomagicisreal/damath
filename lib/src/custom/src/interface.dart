part of '../custom.dart';

///
///
/// [IOperatableScalable]
/// [IOperatableStepable]
/// [IOperatableIndexable], [IOperatableIndexableAssignable]
///
/// [_ILayby]
///
/// [_IEnqueueable]
/// [IEnqueueable]
///
///
/// [MComparable]
/// [ComparableState]
///
///

///
///
///
abstract interface class IOperatableDirectable<I, O> {
  O operator -();

  O operator +(covariant I another);

  O operator -(covariant I another);
}

///
///
///
abstract interface class IOperatableScalable<I, O> {
  O operator *(covariant I another);

  O operator /(covariant I another);
}

///
///
///
abstract interface class IOperatableStepable<I, O> {
  O operator ~/(covariant I another);

  O operator %(covariant I another);
}

///
///
///
abstract interface class IOperatableIndexable<T> {
  T operator [](int i);
}

abstract interface class IOperatableIndexableAssignable<T>
    implements IOperatableIndexable<T> {
  void operator []=(int i, T data);
}

///
///
///

///
///
///
mixin MComparable<C extends Comparable<C>> implements Comparable<C> {
  @override
  int compareTo(C other);

  bool operator >(C another) => compareTo(another) > 0;

  bool operator <(C another) => compareTo(another) < 0;

  bool operator >=(C another) => compareTo(another) >= 0;

  bool operator <=(C another) => compareTo(another) <= 0;
}

enum ComparableState {
  requireDecrease(-1),
  requireIncrease(1);

  final int value;

  const ComparableState(this.value);
}

part of '../custom.dart';

///
///
/// [IOperatableScalable]
/// [IOperatableStepable]
/// [IOperatableIndexable], [IOperatableIndexableAssignable]
///
/// [IIteratorPrevious]
///
/// [IInsertable]
/// [IEnqueueable]
///
///
/// [MComparable]
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
abstract interface class IIteratorPrevious<I> implements Iterator<I> {
  bool movePrevious();
}

///
///
///
abstract interface class IInsertable<T> {
  void insert(T element);

  void insertAll(Iterable<T> iterable);
}

abstract interface class IEnqueueable<T> {
  void enqueue(T element);

  void enqueueAll(Iterable<T> iterable);
}


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
///
///
/// this file contains:
///
/// [IInsertable]
/// [IEnqueueable]
///
///
/// [IOperatableScalable]
/// [IOperatableStepable]
/// [IOperatableComplex]
/// [IOperatableIndexable], [IOperatableIndexableAssignable]
/// [BOperatableComparable]
///
///
///
///
///
///
part of '../core.dart';

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
///
///
///
/// operatable
///
///
///
///
///
///

///
/// directable
///
abstract interface class IOperatableDirectable<I, O> {
  O operator -();

  O operator +(covariant I another);

  O operator -(covariant I another);
}

///
/// scalable
///
abstract interface class IOperatableScalable<I, O> {
  O operator *(covariant I another);

  O operator /(covariant I another);
}

abstract interface class IOperatableModuleable<I, O> {
  O operator %(covariant I another);
}

///
/// stepable
///
abstract interface class IOperatableStepable<I, O> {
  O operator ~/(covariant I another);
}

///
/// complex
///
abstract interface class IOperatableComplex<I, O> {
  O operator &(covariant I another);

  O operator ^(covariant I another);

  O operator >>(covariant I another);

  O operator <<(covariant I another);
}

///
/// indexable
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
/// base
///
///
///
///
///
///
///

///
/// comparable
///
abstract base class BOperatableComparable<C extends Comparable<C>>
    implements Comparable<C> {
  const BOperatableComparable();

  @override
  int compareTo(C another);

  bool operator >(C another) => compareTo(another) > 0;

  bool operator <(C another) => compareTo(another) < 0;

  bool operator >=(C another) => compareTo(another) >= 0;

  bool operator <=(C another) => compareTo(another) <= 0;
}

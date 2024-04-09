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
/// [IOperatableIndexable]
///   |-[BOperatableIndexableList]
///
/// [BOperatableComparable]
///
///
///
///
///
///
part of damath_core;

///
///
///
abstract interface class IIteratorRedo<I> implements Iterator<I>{
  bool moveNextRedo();
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
abstract interface class IOperatableDirectable<O> {
  Object operator -();

  Object operator +(covariant O other);

  Object operator -(covariant O other);
}

///
/// scalable
///
abstract interface class IOperatableScalable<O> {
  Object operator *(covariant O other);

  Object operator /(covariant O other);

  Object operator %(covariant O other);
}

///
/// stepable
///
abstract interface class IOperatableStepable<O> {
  Object operator ~/(covariant O other);
}

///
/// complex
///
abstract interface class IOperatableComplex<O> {
  Object operator &(covariant O other);

  Object operator ^(covariant O other);

  Object operator >>(covariant O other);

  Object operator <<(covariant O other);
}

///
/// indexable
///
abstract interface class IOperatableIndexable<T> {
  T operator [](int index);
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
  int compareTo(C other);

  bool operator >(C other) => compareTo(other) > 0;

  bool operator <(C other) => compareTo(other) < 0;

  bool operator >=(C other) => compareTo(other) >= 0;

  bool operator <=(C other) => compareTo(other) <= 0;
}

///
/// indexable list
///
abstract base class BOperatableIndexableList<T>
    implements IOperatableIndexable<T> {
  List<T> get list;

  @override
  T operator [](int index) => list[index];

  int get length => list.length;
}

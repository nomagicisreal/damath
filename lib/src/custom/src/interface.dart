part of '../custom.dart';
// ignore_for_file: camel_case_types

///
///
/// [I_ToUnmodifiable], ...
/// [I_Pushable], ...
/// [I_OperatableScalable], ...
///
/// [M_Comparable], ...
///
///

///
///
///
abstract interface class I_ToUnmodifiable<T> {
  // return null if already unmodifiable, return instance if change to unmodifiable
  T? get toUnmodifiable;
}

abstract interface class I_ToFixed<T> {
  // return null if already fixed, return instance if change to fixed
  T? get toFixed;
}

///
/// To improve performance of concrete instance, the methods should be as less as possible.
/// 'all' operation is better defined as static methods. (append all, insert all, enqueue all)
///
abstract interface class I_Pushable<T, S> {
  S push(T element);
}

abstract interface class I_Enqueueable<T, S> {
  // to prevent holding comparator in item objects, comparing methodology should be as argument
  S enqueue(T element, ComparableMethod<T> method);

  static S? enqueueIterable<T, S extends I_Enqueueable<T, void>>(
    S head,
    Iterable<T> iterable,
    ComparableMethod<T> method,
  ) => iterable.fold(head, (node, element) => head..enqueue(element, method));
}

// abstract interface class ILayby<S> {
//   S layby();
// }

///
///
///
abstract interface class I_OperatableAppendable<I, O> {
  O operator +(covariant I element);
}

abstract interface class I_OperatableDirectable<I, O>
    implements I_OperatableAppendable<I, O> {
  O operator -();

  O operator -(covariant I element);
}

///
///
///
abstract interface class I_OperatableScalable<I, O> {
  O operator *(covariant I element);

  O operator /(covariant I element);
}

///
///
///
abstract interface class I_OperatableStepable<I, O> {
  O operator ~/(covariant I element);

  O operator %(covariant I element);
}

///
///
///
abstract interface class I_OperatableIndexable<T> {
  T operator [](int index);
}

abstract interface class I_OperatableIndexableAssignable<T>
    implements I_OperatableIndexable<T> {
  void operator []=(int index, T element);
}

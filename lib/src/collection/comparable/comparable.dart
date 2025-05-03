// ignore_for_file: camel_case_types
part of '../collection.dart';

///
/// [M_Comparable]
/// [ComparableState]
/// [ComparableMethod]
///
/// [ComparableExtension]
///
///

///
///
///
mixin M_Comparable<C extends Comparable<C>> implements Comparable<C> {
  @override
  int compareTo(C other);

  bool operator >(C another) => compareTo(another) > 0;

  bool operator <(C another) => compareTo(another) < 0;

  bool operator >=(C another) => compareTo(another) >= 0;

  bool operator <=(C another) => compareTo(another) <= 0;
}

///
///
///
enum ComparableState {
  requireDecrease(-1),
  requireIncrease(1),
  requireEqual(0);

  final int value;

  const ComparableState(this.value);
}

///
/// pass [Comparable.compare] to compare primaries be like [num], [String]
///
final class ComparableMethod<T> {
  final Comparator<T> comparator;
  final ComparableState state;

  const ComparableMethod.requireIncreaseOf(this.comparator)
    : state = ComparableState.requireIncrease;

  const ComparableMethod.requireDecreaseOf(this.comparator)
    : state = ComparableState.requireDecrease;

  ///
  ///
  ///
  bool predicate(T element, T current, {bool includeEqual = false}) {
    final value = comparator(element, current);
    return value == state.value || (includeEqual && value == 0);
  }
  // future: compare to multiple result by comparator (return many kinds of integers)
}

///
/// [orderBefore], ...
/// [compareToIncreaseTernary], ...
///
extension ComparableExtension<C> on Comparable<C> {
  bool orderBefore(C other) => compareTo(other) == -1;

  bool orderAfter(C other) => compareTo(other) == 1;

  ///
  /// there is no compiletime error but runtime error when "[comparator_orderBefore]<[T]>",
  /// while [T] is not bound to [Comparable]
  ///
  // static bool comparator_orderBefore<C extends Comparable>(C a, C b) =>
  //     a.orderBefore(b);
  static bool comparator_orderBefore<C>(C a, C b) =>
      (a as Comparable).orderBefore(b);

  static bool comparator_orderAfter<C>(C a, C b) =>
      (a as Comparable).orderAfter(b);

  ///
  ///
  ///
  bool? compareToIncreaseTernary(C other) {
    final value = compareTo(other);
    return switch (value) {
      0 => null,
      1 => false,
      -1 => true,
      _ => throw Erroring.invalidComparableResult(value),
    };
  }

  bool? compareToDecreaseTernary(C other) {
    final value = compareTo(other);
    return switch (value) {
      0 => null,
      1 => true,
      -1 => false,
      _ => throw Erroring.invalidComparableResult(value),
    };
  }

  static bool? ofTernaryIncrease<C extends Comparable>(C a, C b) =>
      a.compareToIncreaseTernary(b);

  static bool? ofTernaryDecrease<C extends Comparable>(C a, C b) =>
      a.compareToDecreaseTernary(b);
}

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

enum OrderLinear { increase, decrease }

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
extension ComparableExtension<C extends Comparable> on C {
  static bool orderBefore<C extends Comparable>(C current, C other) =>
      current.compareTo(other) == -1;

  static bool orderAfter<C extends Comparable>(C current, C other) =>
      current.compareTo(other) == 1;

  ///
  ///
  ///
  static bool? compareToIncreaseTernary<C extends Comparable>(
    C current,
    C other,
  ) {
    final value = current.compareTo(other);
    return switch (value) {
      0 => null,
      1 => false,
      -1 => true,
      _ => throw Erroring.invalidComparableResult(value),
    };
  }

  static bool? compareToDecreaseTernary<C extends Comparable>(
    C current,
    C other,
  ) {
    final value = current.compareTo(other);
    return switch (value) {
      0 => null,
      1 => true,
      -1 => false,
      _ => throw Erroring.invalidComparableResult(value),
    };
  }

  static bool? ofTernaryIncrease<C extends Comparable>(C a, C b) =>
      compareToIncreaseTernary(a, b);

  static bool? ofTernaryDecrease<C extends Comparable>(C a, C b) =>
      compareToDecreaseTernary(a, b);
}

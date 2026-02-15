// ignore_for_file: camel_case_types
part of '../collection.dart';

///
/// [OrderLinear]
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
/// [ternaryIncrease], ...
///
extension ComparableExtension<C extends Comparable> on C {
  ///
  ///
  ///
  bool orderBefore(C other) => compareTo(other) == -1;

  bool orderAfter(C other) => compareTo(other) == 1;

  static bool orderingBefore<C extends Comparable>(C current, C other) =>
      current.compareTo(other) == -1;

  static bool orderingAfter<C extends Comparable>(C current, C other) =>
      current.compareTo(other) == 1;

  static const String _ucv = 'unimplement comparable value';

  ///
  ///
  ///
  bool? ternaryIncrease(C other) => switch (compareTo(other)) {
    0 => null,
    1 => false,
    -1 => true,
    _ => throw UnimplementedError('$_ucv: ${compareTo(other)}'),
  };

  bool? ternaryDecrease(C other) => switch (compareTo(other)) {
    0 => null,
    1 => true,
    -1 => false,
    _ => throw UnimplementedError('$_ucv: ${compareTo(other)}'),
  };

  static bool? ternaryIncreasing<C extends Comparable>(C current, C other) =>
      switch (current.compareTo(other)) {
        0 => null,
        1 => false,
        -1 => true,
        _ => throw UnimplementedError('$_ucv: ${current.compareTo(other)}'),
      };

  static bool? ternaryDecreasing<C extends Comparable>(C current, C other) =>
      switch (current.compareTo(other)) {
        0 => null,
        1 => true,
        -1 => false,
        _ => throw UnimplementedError('$_ucv: ${current.compareTo(other)}'),
      };
}

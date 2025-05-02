part of '../collection.dart';
// ignore_for_file: camel_case_types

///
/// [DamathComparableExtension], ...
/// [M_Comparable]
/// [ComparableState]
/// [ComparableMethod]
///
/// [DamathIteratorComparable]
/// [DamathIterableComparable]
/// [DamathListComparable]
///
///

///
/// [orderBefore], ...
/// [compareToIncreaseTernary], ...
///
extension DamathComparableExtension<C> on Comparable<C> {
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

  // bool? ternary(T element, T current) => switch (state) {
  //   ComparableState.requireIncrease => () {
  //     final value = comparator(element, current);
  //     return switch (value) {
  //       0 => null,
  //       1 => false,
  //       -1 => true,
  //       _ => throw Erroring.invalidComparableResult(value),
  //     };
  //   }(),
  //   ComparableState.requireDecrease => () {
  //     final value = comparator(element, current);
  //     return switch (value) {
  //       0 => null,
  //       1 => true,
  //       -1 => false,
  //       _ => throw Erroring.invalidComparableResult(value),
  //     };
  //   }(),
  //   ComparableState.requireEqual => throw UnimplementedError(),
  // };
}

///
/// static methods:
/// [comparator], [compareReverse]
/// [isEqual], ...
///
/// instance methods:
/// [isSorted], ...
/// [consecutiveCounted], ...
///
///
extension DamathIteratorComparable<C extends Comparable> on Iterator<C> {
  ///
  /// [comparator], [compareReverse]
  ///
  static Comparator<C> comparator<C extends Comparable>(bool increase) =>
      increase ? Comparable.compare : DamathIteratorComparable.compareReverse;

  /// it is the reverse version of [Comparable.compare]
  static int compareReverse<C extends Comparable>(C a, C b) => b.compareTo(a);

  ///
  /// [isEqual], [notEqual]
  /// [isIncrease], [isDecrease]
  /// [notIncrease], [notDecrease]
  ///
  // require a == b
  static bool isEqual<C extends Comparable>(C a, C b) => a.compareTo(b) == 0;

  // require a != b
  static bool notEqual<C extends Comparable>(C a, C b) => a.compareTo(b) != 0;

  // require a < b
  static bool isIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) == -1;

  // require a > b
  static bool isDecrease<C extends Comparable>(C a, C b) => a.compareTo(b) == 1;

  // require a >= b
  static bool notIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != -1;

  // require a <= b
  static bool notDecrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != 1;

  ///
  /// [predicateLower]
  /// [predicateUpper]
  ///
  static Predicator<C> predicateLower<C extends Comparable>(
    C min, [
    bool orSame = false,
  ]) =>
      orSame
          ? (C value) => DamathIteratorComparable.notIncrease(min, value)
          : (C value) => DamathIteratorComparable.isDecrease(min, value);

  static Predicator<C> predicateUpper<C extends Comparable>(
    C max, [
    bool orSame = false,
  ]) =>
      orSame
          ? (C value) => DamathIteratorComparable.notDecrease(max, value)
          : (C value) => DamathIteratorComparable.isIncrease(max, value);

  ///
  /// [_invalidFor]
  /// [_ternarateFor]
  /// in convention, the validation for [PredicatorReducer] should pass in order of (lower, upper)
  ///
  static PredicatorReducer<C> _validFor<C extends Comparable>(
    bool increase, [
    bool strictly = false,
  ]) =>
      strictly
          ? increase
              ? isIncrease
              : isDecrease
          : increase
          ? notDecrease
          : notIncrease;

  // static PredicatorReducer<C> _invalidFor<C extends Comparable>(
  //   bool increase, [
  //   bool strictly = false,
  // ]) =>
  //     strictly
  //         ? increase
  //             ? notDecrease
  //             : notIncrease
  //         : increase
  //         ? isDecrease
  //         : isIncrease;
  //
  // ///
  // /// [isSorted]
  // ///
  // bool isSorted(bool increase, [bool identical = false]) =>
  //     !exist(_invalidFor(increase, identical));
  //
  // ///
  // /// [checkSorted]
  // /// [checkSortedForSupply]
  // /// [checkSortedForListen]
  // ///
  // void checkSorted([bool increase = true]) {
  //   if (!isSorted(increase)) {
  //     throw StateError(Erroring.comparableDisordered);
  //   }
  // }
  //
  // void checkSortedForListen(Listener listen, [bool increase = true]) =>
  //     isSorted(increase)
  //         ? listen()
  //         : throw StateError(Erroring.comparableDisordered);
  //
  // S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
  //     isSorted(increase)
  //         ? supply()
  //         : throw StateError(Erroring.comparableDisordered);
}

///
///
/// instance methods:
/// [mergeSorted], ...
/// [isOrdered], ...
/// [permutations], ...
/// [consecutive], ...
///
///
extension DamathIterableComparable<C extends Comparable> on Iterable<C> {
  ///
  ///
  ///
  void checkSortedForListen<S>(Listener listen, [bool increase = true]) =>
      isSorted(DamathIteratorComparable.comparator(increase))
          ? listen()
          : throw Erroring.comparableDisordered;

  S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
      isSorted(DamathIteratorComparable.comparator(increase))
          ? supply()
          : throw Erroring.comparableDisordered;

  ///
  ///
  ///
  void mergeSorted(Iterable<C> another, [bool increase = true]) =>
      checkSortedForListen(
        () => iterator.pairMerge(
          another.checkSortedForSupply(() => another.iterator, increase),
          increase
              ? DamathIteratorComparable.isDecrease
              : DamathIteratorComparable.isIncrease,
        ),
        increase,
      );

  ///
  /// [isOrdered]
  ///
  bool isOrdered([bool strictly = false]) =>
      !iterator.existEvery(
        DamathIteratorComparable._validFor(true, strictly),
      ) ||
      !iterator.existEvery(DamathIteratorComparable._validFor(false, strictly));

  ///
  /// [everyRangeIn]
  ///
  bool everyUpperThan(C min, [bool orSame = false]) =>
      !any(DamathIteratorComparable.predicateLower(min, orSame));

  bool everyLowerThan(C max, [bool orSame = false]) =>
      !any(DamathIteratorComparable.predicateUpper(max, orSame));

  bool everyRangeIn(
    C min,
    C max, {
    bool inclusiveMin = true,
    bool inclusiveMax = true,
  }) {
    final lower = DamathIteratorComparable.predicateLower(min, !inclusiveMin);
    final upper = DamathIteratorComparable.predicateUpper(max, !inclusiveMax);
    return !any((value) => lower(value) || upper(value));
  }

  ///
  /// [permutations]
  ///
  int permutations([bool requireIdentical = false]) {
    if (!isOrdered(requireIdentical)) {
      throw StateError(Erroring.comparableDisordered);
    }
    if (requireIdentical) return IntExtension.factorial(length);

    final iterator = this.iterator..moveNext();
    var previous = iterator.current;
    var val = 1;
    var frequency = 1;
    for (var i = 2; iterator.moveNext(); i++) {
      val *= i;
      if (previous == iterator.current) {
        frequency++;
        continue;
      }
      if (frequency > 1) val ~/= IntExtension.factorial(frequency);
      previous = iterator.current;
      frequency = 1;
    }
    if (frequency > 1) val ~/= IntExtension.factorial(frequency);
    return val;
  }

  ///
  /// [consecutive]
  /// [consecutiveOccurred]
  ///
  Iterable<(C, int)> consecutive([bool onlyRepeated = true]) =>
      isOrdered(false)
          ? onlyRepeated
              ? iterator.consecutiveRepeated
              : iterator.consecutiveCounted
          : throw StateError(Erroring.comparableDisordered);

  Iterable<int> get consecutiveOccurred =>
      isOrdered(false)
          ? iterator.consecutiveOccurred
          : throw StateError(Erroring.comparableDisordered);

  // ///
  // /// [groupToIterable]
  // ///
  // // instead of list.add, it's better to insert by binary general comparable
  // Iterable<Iterable<C>> groupToIterable([bool increase = true]) =>
  //     iterator.checkSortedForSupply(
  //       () {
  //         final iterator = this.iterator;
  //         return iterator.moveNextSupply(() sync* {
  //           var previous = iterator.current;
  //           while (iterator.moveNext()) {
  //             yield takeWhile(
  //                 (value) => IteratorComparable.isEqual(previous, value));
  //             throw UnimplementedError();
  //           }
  //         });
  //       },
  //       increase,
  //     );
}

///
/// instance methods:
/// [indexSearch], ...
/// [median], ...
/// [cloneSorted], ...
///
/// [order], ...
/// [percentile], ...
/// [mergeSorted], ...
///
extension DamathListComparable<C extends Comparable> on List<C> {
  // static Iterable<List<C>> permutations<C extends Comparable>(List<C> list)

  ///
  /// [indexSearch] is a function same as [binarySearch] in collection
  ///
  /// find index of an integer item on list with 100 integer (2025/05/01)
  ///   A: [indexSearch] without assertion
  ///   B: [binarySearch]
  /// round 1:
  ///   A: 0:00:00.006940
  ///   B: 0:00:00.013164
  /// round 2:
  ///   A: 0:00:00.007324
  ///   B: 0:00:00.013878
  /// round 3:
  ///   A: 0:00:00.007552
  ///   B: 0:00:00.013759
  ///
  ///
  static int indexSearch<C extends Comparable>(
    List<C> list,
    C value, [
    Comparator<C>? comparator,
  ]) {
    comparator ??= Comparable.compare;
    assert(list.isSorted(comparator));

    var min = 0;
    var max = list.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final v = comparator(list[mid], value);
      if (v == 0) return mid;
      if (v == -1) {
        min = mid + 1;
        continue;
      }
      max = mid;
    }
    return -1;
  }

  ///
  /// [median]
  ///
  C median([bool evenPrevious = true]) =>
      length.isEven ? this[length ~/ 2 - 1] : this[length ~/ 2];

  List<C> cloneSorted([bool increase = false]) =>
      List.of(this)..sort(DamathIteratorComparable.comparator(increase));

  ///
  ///
  /// [order], [rank]
  ///
  ///

  ///
  /// [order]
  /// it returns the indexes helping us to figure out the positions where elements go to make it sorted. for example,
  ///   list = [2, 3, 5, 1, 2];         // [2, 3, 5, 1, 2]
  ///   sorted = List.of(list)..sort(); // [1, 2, 2, 3, 5]
  ///   order = list.order();           // [4, 1, 5, 2, 3]
  ///
  List<int> order({bool increase = true, int from = 1}) {
    final length = this.length;
    C? previous;
    var exist = 0;
    var index = -1;
    return cloneSorted(increase).iterator.mapToList((vSorted) {
      if (vSorted != previous) {
        exist = 0;
        for (var i = 0; i < length; i++) {
          final current = this[i];
          if (vSorted == current) {
            previous = current;
            index = i;
            break;
          }
        }
      } else {
        for (var i = index + 1; i < length; i++) {
          if (vSorted == this[i]) {
            if (exist == 0) {
              exist++;
              index = i;
              break;
            } else {
              exist--;
              continue;
            }
          }
        }
      }

      return from + index;
    });
  }

  ///
  /// [rank]
  /// it returns the rank of elements. for example,
  ///   list = [1, 8, 4, 8, 9];         // [1, 8, 4, 8, 9]
  ///   sorted = List.of(list)..sort(); // [1, 4, 8, 8, 9]
  ///   rank = list.rank();             // [1.0, 3.5, 2.0, 3.5, 5.0]
  ///
  /// [tieToMin] == null (tie to average)
  /// [tieToMin] == true (tie to min)
  /// [tieToMax] == false (tie to max)
  ///
  List<double> rank({bool increase = true, bool? tieToMin}) {
    final length = this.length;
    final sorted = cloneSorted(increase);

    C? previous;
    var rank = -1.0;
    return iterator.mapToList(
      // tie to average
      tieToMin == null
          ? (v) {
            if (v == previous) return rank;

            var exist = 0;
            for (var i = 0; i < length; i++) {
              final current = sorted[i];

              if (exist == 0) {
                if (current == v) exist++;

                // exist != 0
              } else {
                if (current != v) {
                  rank = i + (1 - exist) / 2;
                  return rank;
                }
                exist++;
              }
            }
            rank = length + (1 - exist) / 2;
            return rank;
          }
          : tieToMin
          ? (v) {
            if (v == previous) return rank;

            rank = (sorted.indexWhere((s) => s == v) + 1).toDouble();
            return rank;
          }
          // tie to max
          : (v) {
            if (v == previous) return rank;

            var exist = false;
            for (var i = 0; i < length; i++) {
              final current = sorted[i];

              if (current == v) exist = true;
              if (exist && current != v) {
                rank = i.toDouble();
                return rank;
              }
            }
            rank = length.toDouble();
            return rank;
          },
    );
  }

  ///
  ///
  /// [percentile]
  /// [percentileQuartile]
  /// [percentileCumulative]
  ///
  ///

  ///
  ///
  /// [percentile]
  /// [percentileQuartile]
  ///
  ///
  C percentile(double value) {
    if (!value.isRangeClose(0, 1)) {
      throw StateError(Erroring.percentileOutOfBoundary);
    }
    late final C element;
    final length = this.length;
    for (var i = 0; i < length; i++) {
      if ((i + 1) / length > value) element = this[i];
    }
    return element;
  }

  Iterable<C> get percentileQuartile sync* {
    var step = 0.25;
    final length = this.length;
    for (var i = 0; i < length; i++) {
      if ((i + 1) / length > step) {
        step += 0.25;
        yield this[i];
      }
    }
  }

  ///
  /// [percentileCumulative]
  ///
  Iterable<MapEntry<C, double>> percentileCumulative([
    bool increase = true,
  ]) sync* {
    assert(isSorted(DamathIteratorComparable.comparator(increase)));
    final percent = 1 / length;

    var previous = first;
    var cumulative = 0.0;
    for (var i = 1; i < length; i++) {
      final current = this[i];
      cumulative += percent;

      if (current != previous) {
        yield MapEntry(previous, cumulative);
        cumulative = 0;
        previous = current;
      }
    }
    yield MapEntry(previous, cumulative);
  }
}

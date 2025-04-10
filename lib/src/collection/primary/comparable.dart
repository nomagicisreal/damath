///
///
/// this file contains:
///
/// [IteratorComparable]
/// [IterableComparable]
/// [ListComparable]
///
///
///
part of '../collection.dart';
// ignore_for_file: curly_braces_in_flow_control_structures

///
/// static methods:
/// [comparator], [compare]
/// [isEqual], ...
///
/// instance methods:
/// [isSorted], ...
/// [consecutiveCounted], ...
///
///
extension IteratorComparable<C extends Comparable> on Iterator<C> {
  ///
  /// [comparator], [compare]
  ///
  static Comparator<C> comparator<C extends Comparable>(bool increase) =>
      increase ? Comparable.compare : compare;

  /// it is the reverse version of [Comparable.compare]
  static int compare<C extends Comparable>(C a, C b) => b.compareTo(a);

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
  /// [increaseOrNot]
  /// [decreaseOrNot]
  ///
  static bool? increaseOrNot<C extends Comparable>(C a, C b) =>
      switch (a.compareTo(b)) {
        0 => null,
        -1 => true,
        1 => false,
        _ => throw StateError(FErrorMessage.comparableValueNotProvided),
      };

  static bool? decreaseOrNot<C extends Comparable>(C a, C b) =>
      switch (a.compareTo(b)) {
        0 => null,
        1 => true,
        -1 => false,
        _ => throw StateError(FErrorMessage.comparableValueNotProvided),
      };

  ///
  /// [_invalidFor]
  /// [_ternarateFor]
  /// in convention, the validation for [PredicatorFusionor] should pass in order of (lower, upper)
  ///
  static PredicatorFusionor<C> _validFor<C extends Comparable>(
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

  static PredicatorFusionor<C> _invalidFor<C extends Comparable>(
    bool increase, [
    bool strictly = false,
  ]) =>
      strictly
          ? increase
              ? notDecrease
              : notIncrease
          : increase
              ? isDecrease
              : isIncrease;

  static TernaratorFusionor<C> _ternarateFor<C extends Comparable>(
    bool increase,
  ) =>
      increase ? increaseOrNot : decreaseOrNot;

  ///
  /// [isSorted]
  ///
  bool isSorted(bool increase, [bool identical = false]) =>
      !exist(_invalidFor(increase, identical));

  ///
  /// [checkSorted]
  /// [checkSortedForSupply]
  /// [checkSortedForListen]
  ///
  void checkSorted([bool increase = true]) {
    if (!isSorted(increase)) {
      throw StateError(FErrorMessage.comparableDisordered);
    }
  }

  void checkSortedForListen(Listener listen, [bool increase = true]) =>
      isSorted(increase)
          ? listen()
          : throw StateError(FErrorMessage.comparableDisordered);

  S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
      isSorted(increase)
          ? supply()
          : throw StateError(FErrorMessage.comparableDisordered);
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
extension IterableComparable<C extends Comparable> on Iterable<C> {
  ///
  ///
  /// [mergeSorted]
  ///
  ///
  void mergeSorted(Iterable<C> another, [bool increase = true]) =>
      iterator.checkSortedForListen(
        () => iterator.pairMerge(
          another.iterator.checkSortedForSupply(
            () => another.iterator,
            increase,
          ),
          increase
              ? IteratorComparable.isDecrease
              : IteratorComparable.isIncrease,
        ),
        increase,
      );

  ///
  /// [isOrdered]
  ///
  bool isOrdered([bool strictly = false]) =>
      !iterator.existEvery(IteratorComparable._validFor(true, strictly)) ||
      !iterator.existEvery(IteratorComparable._validFor(false, strictly));

  ///
  /// [rangeIn]
  /// [boundIn]
  ///
  bool rangeIn(
    C lower,
    C upper, [
    bool increase = true,
    bool strictly = false,
  ]) =>
      iterator.checkSortedForSupply(() {
        final validate = IteratorComparable._invalidFor(increase, strictly);
        return validate(lower, upper)
            ? validate(lower, first) && validate(last, upper)
            : throw StateError(FErrorMessage.iterableBoundaryInvalid);
      });

  bool boundIn(
    C lower,
    C? upper, {
    bool increase = true,
    bool strictly = false,
  }) =>
      upper != null
          ? rangeIn(lower, upper, increase, strictly)
          : iterator.checkSortedForSupply(
              () => IteratorComparable._invalidFor(increase, strictly)(
                  lower, first),
            );

  ///
  /// [permutations]
  ///
  int permutations([bool requireIdentical = false]) {
    if (!isOrdered(requireIdentical)) {
      throw StateError(FErrorMessage.comparableDisordered);
    }
    if (requireIdentical) return length.factorial;

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
      if (frequency > 1) val ~/= frequency.factorial;
      previous = iterator.current;
      frequency = 1;
    }
    if (frequency > 1) val ~/= frequency.factorial;
    return val;
  }

  ///
  /// [consecutive]
  /// [consecutiveOccurred]
  ///
  Iterable<(C, int)> consecutive([bool onlyRepeated = true]) => isOrdered(false)
      ? onlyRepeated
          ? iterator.consecutiveRepeated
          : iterator.consecutiveCounted
      : throw StateError(FErrorMessage.comparableDisordered);

  Iterable<int> get consecutiveOccurred => isOrdered(false)
      ? iterator.consecutiveOccurred
      : throw StateError(FErrorMessage.comparableDisordered);

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
extension ListComparable<C extends Comparable> on List<C> {
  // static Iterable<List<C>> permutations<C extends Comparable>(List<C> list)

  ///
  /// [indexSearch], (binary search)
  ///
  int indexSearch(C value, [bool requireIncreased = true]) {
    assert(iterator.isSorted(requireIncreased));
    var min = 0;
    var max = length;
    final ternarate = IteratorComparable._ternarateFor(requireIncreased);
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      switch (ternarate(this[mid], value)) {
        case null:
          return mid;
        case true:
          min = mid + 1;
        case false:
          max = mid;
      }
    }
    return -1;
  }

  ///
  /// [median]
  ///
  C median([bool evenPrevious = true]) =>
      length.isEven ? this[length ~/ 2 - 1] : this[length ~/ 2];

  ///
  /// [cloneSorted]
  ///
  List<C> cloneSorted([bool increase = true]) => List.of(this)..sort();

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
      throw StateError(FErrorMessage.percentileOutOfBoundary);
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
  Iterable<MapEntry<C, double>> percentileCumulative([bool increase = true]) =>
      iterator.checkSortedForSupply(() sync* {
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
      });
}

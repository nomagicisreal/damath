///
///
/// this file contains:
///
/// [IteratorComparable]
/// [IterableComparable]
/// [ListComparable]
///
part of damath_collection;


///
/// static methods:
/// [comparator], [compare]
/// [isEqual], ...
///
/// instance methods:
/// [isSorted], ...
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
  static PredicatorFusionor<C> _invalidFor<C extends Comparable>(
      bool increase,
      bool close,
      ) =>
      close
          ? increase
          ? notDecrease
          : notIncrease
          : increase
          ? isIncrease
          : isDecrease;

  static TernaratorCombiner<C> _ternarateFor<C extends Comparable>(
      bool increase,
      ) =>
      increase ? increaseOrNot : decreaseOrNot;

  ///
  /// [isSorted]
  /// [checkSortedForSupply]
  ///
  bool isSorted(bool increase) => exist(_invalidFor(increase, true));

  S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
      isSorted(increase)
          ? supply()
          : throw StateError(FErrorMessage.comparableDisordered);
}


///
///
///
/// [rangeIn], ...
///
///
///
extension IterableComparable<C extends Comparable> on Iterable<C> {
  ///
  /// [rangeIn]
  ///
  bool rangeIn(C lower, C upper, {bool increase = true, bool isClose = true}) =>
      iterator.checkSortedForSupply(() {
        final validate = IteratorComparable._invalidFor(increase, isClose);
        assert(validate(lower, upper));
        return validate(lower, first) && validate(last, upper);
      });

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
///
/// [sortMerge], ...
///
extension ListComparable<C extends Comparable> on List<C> {
  ///
  /// [indexSearch], (binary search)
  ///
  int indexSearch(C value, [bool requireIncrease = true]) {
    assert(iterator.isSorted(requireIncrease));
    var min = 0;
    var max = length;
    final ternarate = IteratorComparable._ternarateFor(requireIncrease);
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
    if (!value.rangeClose(0, 1)) {
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

  ///
  ///
  /// [sortMerge], [_sortMerge]
  /// [sortPivot], [_sortPivot]
  ///
  ///

  ///
  /// [sortMerge] aka merge sort:
  ///   1. regarding current list as the mix of 2 elements sublist, sorting for each sublist
  ///   2. regarding current list as the mix of sorted sublists, merging sublists into bigger ones
  ///     (2 elements -> 4 elements -> 8 elements -> ... -> n elements)
  ///
  /// when [increasing] = true,
  /// it's means that when 'list item a' > 'list item b', element a should switch with b.
  /// see [_sortMerge] for full implementation.
  ///
  void sortMerge([bool increasing = true]) {
    final value = increasing ? 1 : -1;
    final length = this.length;

    final max = length.isEven ? length : length - 1;
    for (var begin = 0; begin < max; begin += 2) {
      final a = this[begin];
      final b = this[begin + 1];
      if (a.compareTo(b) == value) {
        this[begin] = b;
        this[begin + 1] = a;
      }
    }
    int sorted = 2;

    while (sorted * 2 <= length) {
      final target = sorted * 2;
      final fixed = length - length % target;
      int begin = 0;

      for (; begin < fixed; begin += target) {
        final i = begin + sorted;
        final end = begin + target;
        replaceRange(
          begin,
          end,
          _sortMerge(sublist(begin, i), sublist(i, end), increasing),
        );
      }
      if (fixed > 0) {
        replaceRange(
          0,
          length,
          _sortMerge(sublist(0, fixed), sublist(fixed, length), increasing),
        );
      }
      sorted *= 2;
    }
  }

  ///
  /// before calling [_sortMerge], [listA] and [listB] must be sorted.
  /// when [increase] = true,
  /// it's means that when 'listA item a' < 'listB item b', result should add a before add b.
  ///
  static List<C> _sortMerge<C extends Comparable>(
      List<C> listA,
      List<C> listB, [
        bool increase = true,
      ]) {
    final value = increase ? -1 : 1;
    final result = <C>[];
    final lengthA = listA.length;
    final lengthB = listB.length;
    int i = 0;
    int j = 0;
    while (i < lengthA && j < lengthB) {
      final a = listA[i];
      final b = listB[j];
      if (a.compareTo(b) == value) {
        result.add(a);
        i++;
      } else {
        result.add(b);
        j++;
      }
    }
    return result..addAll(i < lengthA ? listA.sublist(i) : listB.sublist(j));
  }

  ///
  /// [sortPivot] separate list by the pivot item,
  /// continue updating pivot item, sorting elements by comparing to pivot item.
  /// see [_sortPivot] for full implementation
  ///
  void sortPivot([bool isIncreasing = true]) {
    void sorting(int low, int high) {
      if (low < high) {
        final iPivot = _sortPivot(low, high, isIncreasing);
        sorting(low, iPivot - 1);
        sorting(iPivot + 1, high);
      }
    }

    if (length > 1) sorting(0, length - 1);
  }

  ///
  /// [_sortPivot] partition list by the the pivot item list[high], and return new pivot position.
  ///
  /// when [isIncreasing] = true,
  /// it meas that the pivot point should search for how much item that is less than itself,
  /// ensuring the items that less/large than pivot are in front of list,
  /// preparing to switch the larger after the position of 'how much item' that pivot had found less than itself
  ///
  int _sortPivot(int low, int high, [bool isIncreasing = true]) {
    final increasing = isIncreasing ? 1 : -1;
    final pivot = this[high];
    var i = low;
    var j = low;

    for (; j < high; j++) {
      if (pivot.compareTo(this[j]) == increasing) {
        i++;
      } else {
        break;
      }
    }

    for (; j < high; j++) {
      final current = this[j];
      if (pivot.compareTo(current) == increasing) {
        this[j] = this[i];
        this[i] = current;
        i++;
      }
    }

    this[high] = this[i];
    this[i] = pivot;

    return i;
  }
}

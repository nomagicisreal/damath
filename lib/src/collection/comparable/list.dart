part of '../collection.dart';

///
///
/// [ListComparable]
/// [ListDouble]
/// [List2DComparable]
/// [List2DInt]
///
///

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
      List.of(this)..sort(IteratorComparable.comparator(increase));

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

  Iterable<MapEntry<C, double>> percentileCumulative([
    bool increase = true,
  ]) sync* {
    assert(isSorted(IteratorComparable.comparator(increase)));
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

///
/// [interquartileRange]
///
extension ListDouble on List<double> {
  ///
  /// [interquartileRange]
  ///
  double get interquartileRange {
    final interquartile = percentileQuartile;
    return interquartile.last - interquartile.first;
  }
}


///
/// static methods:
/// [_comparatorAccordingly], ...
///
/// instance methods:
/// [sortByFirst], ...
///
extension List2DComparable<C extends Comparable> on List2D<C> {
  ///
  /// [_comparatorAccordingly]
  ///
  static Comparator<List<C>> _comparatorAccordingly<C extends Comparable>(
      Comparator<C> keepAFirst,
      ) => (a, b) {
    final maxIndex = math.max(a.length, b.length);
    int compareBy(int i) {
      final value = keepAFirst(a[i], b[i]);
      return value != 0 || i == maxIndex - 1 ? value : compareBy(i + 1);
    }

    return compareBy(0);
  };

  ///
  /// [sortByFirst]
  /// [sortAccordingly]
  ///
  void sortByFirst([bool increasing = true]) => sort(
    increasing
        ? (a, b) => a.first.compareTo(b.first)
        : (a, b) => b.first.compareTo(a.first),
  );

  void sortAccordingly([bool increase = true]) => sort(
    List2DComparable._comparatorAccordingly(
      increase ? Comparable.compare : IteratorComparable.compareReverse,
    ),
  );

///
///
/// when [isIncrease] == true, [compareLastElement] == false, this is an example
///   // [
///   //  [2, 5, 1],
///   //  [2, 5, 6, 1],
///   //  [2, 5, 6, 9],
///   //  [2, 5, 6, 1, 90],
///   // ]
///
/// when [isIncrease] == true, [compareLastElement] == true, this is an example
///   // [
///   //  [2, 5, 10],
///   //  [2, 5, 6, 10],
///   //  [2, 5, 6, 10, 90],
///   //  [2, 5, 6, 9],
///   // ]
///
/// when [isIncrease] == true, [compareLastElement] == false, this is an example
///   // [
///   //  [2, 5, 10],
///   //  [2, 5, 6, 9],
///   //  [2, 5, 6, 10],
///   //  [2, 5, 6, 9, 90],
///   // ]
///

// // notice that it's not efficient.
// void sortDirty([bool increase = true, bool compareLastElement = false]) {
//   assert(everyElementSorted(increase));
//   if (compareLastElement) throw UnimplementedError();
//   collection
//       .groupBy(this, (value) => value.length)
//       .map((length, sub) => MapEntry(length, sub..sortAccordingly(increase))).valuesBySortedKeys();
// }
}

///
///
///
extension List2DInt on List2D<int> {
  ///
  /// [summationIntoIdentity]
  ///
  List2D<int> summationIntoIdentity(int length) =>
      copyIntoIdentity(IntExtension.reduce_plus, length, 1);
}


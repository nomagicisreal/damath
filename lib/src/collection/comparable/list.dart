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
  static C median<C extends Comparable>(
    List<C> items, [
    bool evenPrevious = true,
  ]) =>
      items.length.isEven
          ? items[items.length ~/ 2 - 1]
          : items[items.length ~/ 2];

  static List<C> cloneSorted<C extends Comparable>(
    Iterable<C> source, [
    bool increase = false,
  ]) => List.of(source)..sort(IteratorComparable.comparator(increase));

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
  static List<int> order<C extends Comparable>(
    List<C> source, {
    bool increase = true,
    int from = 1,
  }) {
    final length = source.length;
    C? previous;
    var exist = 0;
    var index = -1;

    return IteratorTo.mapToList(cloneSorted(source, increase).iterator, (
      vSorted,
    ) {
      if (vSorted != previous) {
        exist = 0;
        for (var i = 0; i < length; i++) {
          final current = source[i];
          if (vSorted == current) {
            previous = current;
            index = i;
            break;
          }
        }
      } else {
        for (var i = index + 1; i < length; i++) {
          if (vSorted == source[i]) {
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
}

///
/// [interquartileRange]
///
extension ListDouble on List<double> {
  // ///
  // /// [interquartileRange]
  // ///
  // double get interquartileRange {
  //   final interquartile = percentileQuartile;
  //   return interquartile.last - interquartile.first;
  // }
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
  static void sortByFirst<C extends Comparable>(
    List2D<C> list2D, [
    bool increasing = true,
  ]) => list2D.sort(
    increasing
        ? (a, b) => a.first.compareTo(b.first)
        : (a, b) => b.first.compareTo(a.first),
  );

  static void sortAccordingly<C extends Comparable>(
    List2D<C> list2D, [
    bool increase = true,
  ]) => list2D.sort(
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
  static List2D<int> summationIntoIdentity(List2D<int> list2D, int length) =>
      list2D.copyIntoIdentity(IntExtension.reduce_plus, length, 1);
}

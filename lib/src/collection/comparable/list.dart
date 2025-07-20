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
/// [median], ...
/// [cloneSorted], ...
///
/// [order], ...
///
extension ListComparable<C extends Comparable> on List<C> {
  // static Iterable<List<C>> permutations<C extends Comparable>(List<C> list)
  ///
  /// [median]
  ///
  C median([bool evenPrevious = true]) =>
      length.isEven ? this[length ~/ 2 - 1] : this[length ~/ 2];

  ///
  /// [cloneSorted]
  ///
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
}

///
/// static methods:
/// [comparatorAccordingly], ...
///
/// instance methods:
/// [sortByFirst], ...
///
extension List2DComparable<C extends Comparable> on List2D<C> {
  ///
  /// [comparatorAccordingly]
  ///
  static Comparator<List<C>> comparatorAccordingly<C extends Comparable>(
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
  /// [sortByFirst], [sortAccordingly]
  ///
  void sortByFirst([bool increasing = true]) => sort(
    increasing
        ? (a, b) => a.first.compareTo(b.first)
        : (a, b) => b.first.compareTo(a.first),
  );

  void sortAccordingly([bool increase = true]) => sort(
    List2DComparable.comparatorAccordingly(
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

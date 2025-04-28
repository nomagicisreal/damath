part of '../collection.dart';

///
/// [DamathIteratorSet]
///
/// [DamathIterableIterable]
/// [DamathIterableIterableComparable]
///
/// [DamathListListComparable]
/// [DamathListSet]
///


///
/// [everyIdentical], ...
/// [reduceMerged]
///
extension DamathIteratorSet<K> on Iterator<Set<K>> {
  ///
  /// [everyIdentical]
  ///
  bool get everyIdentical => supplyMoveNext(() {
        final set = Set.of(current);
        while (moveNext()) {
          if (current.any(set.add)) return false;
        }
        return true;
      });

  ///
  /// [reduceMerged]
  ///
  Set<K> reduceMerged([bool requireIdentical = false]) => requireIdentical
      ? supplyMoveNext(() {
          final set = Set.of(current);
          while (moveNext()) {
            if (current.any(set.add)) {
              throw StateError(ErrorMessages.setNotIdentical(current, set));
            }
          }
          return set;
        })
      : fold({}, (set, other) => set..addAll(other));
}

///
/// [size]
/// [toStringPadLeft], [toStringMapJoin]
/// [isEqualElementsLengthTo]
/// [foldWith2D]
///
extension DamathIterableIterable<I> on Iterable<Iterable<I>> {
  ///
  /// [predicateChildrenLength]
  ///
  static Predicator<Iterable<I>> predicateChildrenLength<I>(int n) =>
      (element) => element.length == n;

  ///
  /// [size]
  ///
  int get size =>
      iterator.induct(DamathIterable.toLength, IntExtension.reducePlus);

  ///
  /// [toStringMapJoin]
  /// [toStringPadLeft]
  ///
  String toStringMapJoin([
    Mapper<Iterable<I>, String>? mapping,
    String separator = "\n",
  ]) =>
      map(mapping ?? (e) => e.toString()).join(separator);

  String toStringPadLeft(int space) => toStringMapJoin(
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
      );

  ///
  /// [isEqualElementsLengthTo]
  ///
  bool isEqualElementsLengthTo<P>(Iterable<Iterable<P>> another) =>
      !anyWith(another, DamathIterable.predicateLengthDifferent);

  bool isEqualToNested(Iterable<Iterable<I>> another) =>
      !anyWith(another, DamathIterable.predicateDifferent);

  ///
  /// [foldWith2D]
  ///
  S foldWith2D<S, P>(
    Iterable<Iterable<P>> another,
    S initialValue,
    Forcer<S, I, P> fusionor,
  ) =>
      foldWith(
        another,
        initialValue,
        (value, e, eAnother) => value = e.foldWith(eAnother, value, fusionor),
      );

  ///
  /// [whereLengthIs]
  ///
  Iterable<Iterable<I>> whereLengthIs(int n) =>
      where(predicateChildrenLength(n));

  ///
  /// [mapToListWhereLengthIs]
  /// [mapToListListWhereLengthIs]
  ///
  List<Iterable<I>> mapToListWhereLengthIs(int n) =>
      [...where(predicateChildrenLength(n))];

  List<List<I>> mapToListListWhereLengthIs(int n) {
    final result = <List<I>>[];
    for (final element in this) {
      result.addWhen(element.length == n, () => element.toList());
    }
    return result;
  }

  ///
  /// [flatted]
  /// [flattedList]
  ///
  Iterable<I> get flatted sync* {
    for (final element in this) {
      yield* element;
    }
  }

  List<I> get flattedList {
    final result = <I>[];
    for (final element in this) {
      result.addAll(element);
    }
    return result;
  }
}

///
///
///
///
extension DamathIterableIterableComparable<C extends Comparable>
    on Iterable<Iterable<C>> {
  ///
  /// [everyElementSorted]
  /// [everyElementSortedThen]
  ///
  bool everyElementSorted([bool increase = true]) =>
      every((element) => element.iterator.isSorted(increase));

  void everyElementSortedThen(Listener listen, [bool increase = true]) =>
      every((element) => element.iterator.isSorted(increase))
          ? listen()
          : throw StateError(ErrorMessages.comparableDisordered);
}

///
///
///
///
///
/// list
///
///
///
///
///
extension ListList<T> on List2D<T> {
  ///
  /// [copyIntoIdentity]
  ///
  List2D<T> copyIntoIdentity(Reducer<T> reducing, int length, T fill) {
    final identity = List.filled(length, fill);
    return mapToList((t) => identity..updateReduce(reducing, t));
  }
}

///
///
///
extension ListListInt on List2D<int> {
  ///
  /// [summationIntoIdentity]
  ///
  List2D<int> summationIntoIdentity(int length) =>
      copyIntoIdentity(IntExtension.reducePlus, length, 1);
}

///
/// static methods:
/// [accordinglyIncrease], ...
///
/// instance methods:
/// [sortByFirst], ...
///
extension DamathListListComparable<C extends Comparable> on List2D<C> {
  ///
  /// [_accordinglySort]
  ///
  static Comparator<List<C>> _accordinglySort<C extends Comparable>(
    Comparator<C> keepAFirst,
  ) =>
      (a, b) {
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

  void sortAccordingly([bool increase = true]) => sort(_accordinglySort(
        increase ? Comparable.compare : DamathIteratorComparable.compareReverse,
      ));
}

///
/// [mergeToThis], ...
///
extension DamathListSet<I> on List<Set<I>> {
  ///
  /// [mergeToThis]
  /// [mergeToThat]
  /// [mergeWhereToTrailing]
  ///
  void mergeToThis(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeToThat(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereToTrailing(Predicator<Set<I>> test) =>
      add(removalWhere(test).iterator.reduceMerged());
}

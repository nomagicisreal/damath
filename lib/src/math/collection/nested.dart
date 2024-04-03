///
///
/// this file contains:
///
///
/// [IterableIterableExtension]
///
///
/// [ListListComparableExtension]
/// [ListSetExtension]
///
///
part of damath_math;


///
/// [size]
/// [toStringPadLeft], [toStringMapJoin]
/// [isEqualElementsLengthTo]
/// [foldWith2D]
///
extension IterableIterableExtension<I> on Iterable<Iterable<I>> {
  ///
  /// [size]
  ///
  int get size =>
      iterator.reduceTo(IterableExtension.toLength, FReducer.intAdd);

  ///
  /// [toStringMapJoin]
  /// [toStringPadLeft]
  ///
  String toStringMapJoin([
    Mapper<Iterable<I>, String>? mapper,
    String separator = "\n",
  ]) =>
      map(mapper ?? (e) => e.toString()).join(separator);

  String toStringPadLeft(int space) => toStringMapJoin(
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
  );

  ///
  /// [isEqualElementsLengthTo]
  ///
  bool isEqualElementsLengthTo<P>(Iterable<Iterable<P>> another) =>
      !anyElementWith(another, FPredicatorCombiner.iterableIsLengthDifferent);

  bool isEqualToNested(Iterable<Iterable<I>> another) =>
      !anyElementWith(another, FPredicatorCombiner.iterableIsDifferent);

  ///
  /// [foldWith2D]
  ///
  S foldWith2D<S, P>(
      Iterable<Iterable<P>> another,
      S initialValue,
      Collector<S, I, P> fusionor,
      ) =>
      foldWith(
        another,
        initialValue,
            (value, e, eAnother) => value = e.foldWith(eAnother, value, fusionor),
      );
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

///
/// [sortByFirst]
/// [sortAccordingly]
///
extension ListListComparableExtension<C extends Comparable> on List<List<C>> {
  ///
  /// [accordingly]
  ///
  static int accordingly<C extends Comparable>(
      List<C> a,
      List<C> b,
      Comparator<C> comparing,
      ) {
    final maxIndex = math.max(a.length, b.length);
    int compareBy(int i) {
      final value = comparing(a[i], b[i]);
      return value == 0 && i < maxIndex ? compareBy(i + 1) : value;
    }

    return compareBy(0);
  }

  ///
  /// [sortByFirst]
  ///
  void sortByFirst([bool increasing = true]) => sort(
    increasing
        ? (a, b) => a.first.compareTo(b.first)
        : (a, b) => b.first.compareTo(a.first),
  );

  ///
  /// [sortAccordingly]
  ///
  void sortAccordingly([bool increase = true]) => sort(
    increase
        ? (a, b) => accordingly(a, b, Comparable.compare)
        : (a, b) => accordingly(a, b, ListComparableExtension.reverse),
  );
}

///
/// [mergeToThis], ...
///
extension ListSetExtension<I> on List<Set<I>> {
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
      add(removeWhereAndGet(test).iterator.merged);
}
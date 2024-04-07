///
///
/// this file contains:
///
/// [IteratorSet]
///
/// [IterableIterable]
/// [IterableIterableComparable]
///
/// [ListListComparable]
/// [ListSet]
///
///
part of damath_math;

///
/// static methods:
/// [_errorSetNotIdentical], ...
///
/// instance methods:
/// [everyIdentical], ...
/// [merged], ...
///
extension IteratorSet<K> on Iterator<Set<K>> {
  ///
  /// [_errorSetNotIdentical]
  ///
  static StateError _errorSetNotIdentical<K>(Set<K> a, Set<K> b) =>
      StateError('set not identical:\n$a\n$b');

  ///
  /// [everyIdentical]
  ///
  bool get everyIdentical => moveNextSupply(() {
        final set = current.copy;
        while (moveNext()) {
          if (current.any(set.add)) return false;
        }
        return true;
      });

  ///
  /// [merged]
  /// [mergedIfIdentical]
  ///
  Set<K> get merged => fold({}, (set, other) => set..addAll(other));

  Set<K> get mergedIfIdentical => moveNextSupply(() {
        final set = current.copy;
        while (moveNext()) {
          if (current.any(set.add)) throw _errorSetNotIdentical(set, current);
        }
        return set;
      });
}

///
/// [size]
/// [toStringPadLeft], [toStringMapJoin]
/// [isEqualElementsLengthTo]
/// [foldWith2D]
///
extension IterableIterable<I> on Iterable<Iterable<I>> {
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
extension IterableIterableComparable<C extends Comparable>
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
          : throw IteratorComparable._errorIteratorDisorder();
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
/// static methods:
/// [accordinglyIncrease], ...
///
/// instance methods:
/// [sortByFirst], ...
///
extension ListListComparable<C extends Comparable> on List<List<C>> {
  ///
  /// [accordinglyIncrease]
  /// [accordinglyDecrease]
  ///
  static int accordinglyIncrease<C extends Comparable>(List<C> a, List<C> b) {
    final maxIndex = math.max(a.length, b.length);
    int compareBy(int i) {
      final value = Comparable.compare(a[i], b[i]);
      return value == 0 && i < maxIndex ? compareBy(i + 1) : value;
    }

    return compareBy(0);
  }

  // it's redundant
  static int accordinglyDecrease<C extends Comparable>(List<C> a, List<C> b) {
    final maxIndex = math.max(a.length, b.length);
    int compareBy(int i) {
      final value = IteratorComparable.compare(a[i], b[i]);
      return value == 0 && i < maxIndex ? compareBy(i + 1) : value;
    }

    return compareBy(0);
  }

  ///
  /// [sortByFirst]
  /// [sortAccordingly]
  ///
  void sortByFirst([bool increasing = true]) => sort(
        increasing
            ? (a, b) => a.first.compareTo(b.first)
            : (a, b) => b.first.compareTo(a.first),
      );

  void sortAccordingly([bool increase = true]) =>
      sort(increase ? accordinglyIncrease : accordinglyDecrease);
}

///
/// [mergeToThis], ...
///
extension ListSet<I> on List<Set<I>> {
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

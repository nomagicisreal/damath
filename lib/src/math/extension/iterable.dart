///
///
/// this file contains:
///
/// [IteratorExtension]
///
/// [IterableExtension]
/// [IterableIntExtension], [IterableDoubleExtension]
/// [IterableIterableExtension], [IterableSetExtension]
///
///
/// about graph:
/// [IterableEdgeExtension]
///
///
///
///
part of damath_math;

///
/// static methods:
/// [generateFrom], ...
/// [fill], ...
///
/// instance getter and methods
/// [notContains], ...
/// [containsThen], ...
/// [anyEqual]
/// [everyEqual], ...
///
/// [foldWith], ...
/// [reduceWith], ...
/// [expandWith], ...
///
/// [flat], ...
///
/// [intersection], ...
/// [difference], ...
///
/// [groupBy], ...
/// [mirrored], ...
/// [chunk], ...
/// [combinationsWith]
///
extension IterableExtension<I> on Iterable<I> {
  static int toLength<I>(Iterable<I> iterable) => iterable.length;

  ///
  /// [generateFrom]
  ///
  static Iterable<I> generateFrom<I>(
    int count, [
    Generator<I>? generator,
    int start = 1,
  ]) {
    if (generator == null && I != int) throw UnimplementedError();
    return Iterable.generate(
      count,
      generator == null ? (i) => start + i as I : (i) => generator(start + i),
    );
  }

  ///
  /// [fill]
  ///
  static Iterable<I> fill<I>(int count, I value) =>
      Iterable.generate(count, FGenerator.fill(value));

  ///
  /// [isVariantTo]
  ///
  bool isVariantTo(Iterable<I> another) =>
      length == another.length && iterator.containsAll(another.iterator);

  ///
  /// any, every
  /// [anyEqual], [anyDifferent], [anyDifferentBy]
  /// [anyElementWith], [anyElementIsEqualWith], [anyElementIsDifferentWith]
  /// [everyEqual], [everyDifferent], [everyDifferentBy]
  /// [everyElementsWith], [everyElementsAreEqualWith], [everyElementsAreDifferentWith]
  ///
  ///

  ///
  /// [anyEqual]
  /// [anyDifferent]
  /// [anyDifferentBy]
  /// [anyEqualBy]
  ///
  /// Instead of [IteratorExtension.predicateNToN],
  /// the reason why [anyDifferent], [anyDifferentBy] invoke [IteratorExtension.predicate1ToN]
  /// is that when each elements passed by a [anyDifferent] call and not return true,
  /// it indicates that the previous element is equal to current element.
  /// it's redundant to check if the next element is equal to both of current element and previous element.
  ///
  bool get anyDifferent =>
      iterator.predicate1ToN(FPredicatorCombiner.isNotEqual);

  bool get anyEqual => iterator.predicateNToN(FPredicatorCombiner.isEqual);

  bool anyDifferentBy<T>(Translator<I, T> toId) =>
      iterator.predicate1ToNBy(toId, FPredicatorCombiner.isNotEqual);

  bool anyEqualBy<T>(Translator<I, T> toId) =>
      !iterator.predicateNToNBy(toId, FPredicatorCombiner.isEqual);

  ///
  /// [anyElementWith]
  /// [anyElementIsEqualWith]
  /// [anyElementIsDifferentWith]
  ///
  bool anyElementWith<P>(Iterable<P> another, PredicatorMixer<I, P> test) {
    assert(length == another.length);
    return iterator.interAny(another.iterator, test);
  }

  bool anyElementIsEqualWith(Iterable<I> another) =>
      anyElementWith(another, FPredicatorCombiner.isEqual);

  bool anyElementIsDifferentWith(Iterable<I> another) =>
      anyElementWith(another, FPredicatorCombiner.isNotEqual);

  ///
  /// [everyDifferent], [everyEqual]
  /// [everyDifferentBy], [everyEqualBy]
  /// [everyElementsWith], [everyElementsAreEqualWith], [everyElementsAreDifferentWith]
  ///
  bool get everyDifferent => !anyEqual;

  bool get everyEqual => !anyDifferent;

  bool everyDifferentBy<T>(Translator<I, T> toId) => !anyEqualBy(toId);

  bool everyEqualBy<T>(Translator<I, T> toId) => !anyDifferentBy(toId);

  bool everyElementsWith<P>(Iterable<P> another, PredicatorMixer<I, P> test) {
    assert(length == another.length);
    return iterator.interEvery(another.iterator, test);
  }

  bool everyElementsAreEqualWith(Iterable<I> another) =>
      !anyElementIsDifferentWith(another);

  bool everyElementsAreDifferentWith(Iterable<I> another) =>
      !anyElementIsEqualWith(another);

  ///
  ///
  /// fold, reduce, expand
  /// [foldWith], [foldTogether]
  /// [reduceWith], [reduceTogether]
  /// [expandWith], [expandTogether]
  ///

  ///
  /// [foldWith]
  /// [foldTogether]
  ///
  S foldWith<S, T>(
    Iterable<T> another,
    S initialValue,
    Companion2<S, I, T> companion,
  ) {
    assert(another.length == length);
    return iterator.interFold(initialValue, another.iterator, companion);
  }

  S foldTogether<E, S>(
    S initialValue,
    Iterable<E> another,
    Companion<S, I> companion,
    Companion<S, E> companionAnother,
    Reducer2<S> combine,
  ) {
    assert(length == another.length);
    return iterator.interFold(
      initialValue,
      another.iterator,
      (value, a, b) => combine(
        value,
        companion(value, a),
        companionAnother(value, b),
      ),
    );
  }

  ///
  /// [reduceWith]
  /// [reduceTogether]
  ///
  I reduceWith(Iterable<I> another, Reducer<I> initialize, Reducer2<I> mutual) {
    assert(another.length == length);
    return iterator.interReduce(another.iterator, initialize, mutual);
  }

  I reduceTogether(
    Iterable<I> another,
    Reducer<I> initialize,
    Reducer2<I> reducer,
  ) {
    assert(length == another.length);
    return iterator.interReduce(another.iterator, initialize, reducer);
  }

  ///
  /// [expandWith]
  /// [expandTogether]
  ///
  Iterable<I> expandWith<E>(
    Iterable<E> another,
    Mixer<I, E, Iterable<I>> expanding,
  ) {
    assert(another.length == length);
    return iterator.interExpand(another.iterator, expanding);
  }

  Iterable<I> expandTogether<E>(
    Iterable<E> another,
    Translator<I, Iterable<I>> expanding,
    Translator<E, Iterable<I>> expandingAnother,
    Reducer<Iterable<I>> combine,
  ) {
    assert(length == another.length);
    return iterator.interExpand(
      another.iterator,
      (p, q) => combine(expanding(p), expandingAnother(q)),
    );
  }

  ///
  /// intersection, difference
  /// [intersection], [intersectionIndex], [intersectionDetail]
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  ///

  ///
  /// [intersection]
  /// [intersectionIndex]
  /// [intersectionDetail]
  ///
  List<I> intersection(Iterable<I> another) => iterator.interFold(
        [],
        another.iterator,
        (list, v1, v2) => list..addWhen(v1 == v2, v1),
      );

  List<int> intersectionIndex(Iterable<I> another) =>
      iterator.interFoldIndexable(
        [],
        another.iterator,
        (list, v1, v2, index) => list..addWhen(v1 == v2, index),
        0,
      );

  Map<int, I> intersectionDetail(Iterable<I> another) =>
      iterator.interFoldIndexable(
        {},
        another.iterator,
        (map, v1, v2, index) => map..putIfAbsentWhen(v1 == v2, index, () => v1),
        0,
      );

  ///
  /// [difference]
  /// [differenceIndex]
  /// [differenceDetail]
  ///
  List<I> difference(Iterable<I> another) => iterator.diffFold(
        [],
        another.iterator,
        (list, v1, v2) => list..addWhen(v1 != v2, v1),
        (list, another) => list..add(another),
      );

  List<int> differenceIndex(Iterable<I> another, [int start = 0]) =>
      iterator.diffFoldIndexable(
        [],
        another.iterator,
        (value, e1, e2, index) => value..addWhen(e1 != e2, index),
        (value, element, index) => value..add(index),
        start,
      );

  ///
  /// [MapEntry.key] is the value in this instance that different with [another]
  /// [MapEntry.value] is the value in [another] that different with this instance
  ///
  Map<int, MapEntry<I, I?>> differenceDetail(Iterable<I> another) =>
      iterator.diffFoldIndexable(
        {},
        another.iterator,
        (value, e1, e2, index) =>
            value..putIfAbsentWhen(e1 != e2, index, () => MapEntry(e1, e2)),
        (value, element, index) =>
            value..putIfAbsent(index, () => MapEntry(element, null)),
        0,
      );

  ///
  /// [groupBy]
  ///
  Map<K, List<I>> groupBy<K>(Translator<I, K> toKey) => fold(
        {},
        (map, item) => map
          ..update(
            toKey(item),
            (value) => value..add(item),
            ifAbsent: () => [item],
          ),
      );

  ///
  /// [mirrored]
  ///
  List<E> mirrored<E>(Generator<E> generator) =>
      [for (var i = 0; i < length; i++) generator(i)];

  ///
  /// [chunk]
  ///

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.chunk([2, 1, 3, 1]); // [[2, 3], [4], [6, 10, 3], [9]]
  ///
  Iterable<List<I>> chunk(Iterable<int> lengthOfEachChunk) sync* {
    assert(lengthOfEachChunk.sum == length);
    final iterator = this.iterator;
    for (var l in lengthOfEachChunk) {
      final list = <I>[];
      for (var i = 0; i < l; i++) {
        iterator.moveNext();
        list.add(iterator.current);
      }
      yield list;
    }
  }

  ///
  /// [combinationsWith]
  ///

  ///
  /// listA = [1, 2, 3];
  /// listB = [101, 102];
  /// result = [combinationsWith] ([listA, listB]);
  /// print(result); // [
  ///   [MapEntry(1, 101), MapEntry(1, 102)],
  ///   [MapEntry(2, 101), MapEntry(2, 102)],
  ///   [MapEntry(3, 101), MapEntry(3, 102)],
  /// }
  ///
  Iterable<Iterable<MapEntry<I, V>>> combinationsWith<V>(Iterable<V> another) =>
      iterator.yieldingTo(another.iterator.yieldingToEntriesByKey);
}

///
/// [sum]
///
extension IterableIntExtension on Iterable<int> {
  int get sum => iterator.reduce(FReducer.intAdd);
}

///
/// [sum], [sumSquared]
///
extension IterableDoubleExtension on Iterable<double> {
  double get sum => iterator.reduce(FReducer.doubleAdd);

  double get sumSquared => iterator.reduce(FReducer.doubleAddSquared);
}

///
/// [size]
/// [toStringPadLeft], [toStringByMapJoin]
/// [everyElementsLengthAreEqualWith]
/// [foldWith2D]
///
extension IterableIterableExtension<I> on Iterable<Iterable<I>> {
  ///
  /// [size]
  ///
  int get size =>
      iterator.reduceTo(IterableExtension.toLength, FReducer.intAdd);

  ///
  /// [toStringPadLeft]
  /// [toStringByMapJoin]
  ///
  String toStringPadLeft(int space) => toStringByMapJoin(
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
      );

  String toStringByMapJoin([
    Translator<Iterable<I>, String>? mapper,
    String separator = "\n",
  ]) =>
      map(mapper ?? (e) => e.toString()).join(separator);

  ///
  /// [everyElementsLengthAreEqualWith]
  ///
  bool everyElementsLengthAreEqualWith<P>(Iterable<Iterable<P>> another) =>
      length == another.length &&
      everyElementsWith(
        another,
        (v1, v2) => v1.length == v2.length,
      );

  ///
  /// [foldWith2D]
  ///
  S foldWith2D<S, P>(
    Iterable<Iterable<P>> another,
    S initialValue,
    Companion2<S, I, P> fusionor,
  ) {
    assert(everyElementsLengthAreEqualWith(another));
    return foldWith(
      another,
      initialValue,
      (value, e, eAnother) => value = e.foldWith(eAnother, value, fusionor),
    );
  }
}

///
/// [merged]
/// [forEachWithAddAll]
///
extension IterableSetExtension<I> on Iterable<Set<I>> {
  Set<I> get merged => reduce((a, b) => a..addAll(b));

  void forEachWithAddAll(List<Set<I>> another) =>
      iterator.inter(another.iterator, (a, b) => a..addAll(b));
}

///
///
///
///
/// graph
///
///
///
///

///
/// [toVertices]
///
extension IterableEdgeExtension<T, S, V extends VertexAncestor<T?>>
    on Iterable<EdgeAncestor<T, S, V>> {
  Set<V> get toVertices => fold(
        {},
        (set, edge) => set
          ..add(edge._source)
          ..add(edge._destination),
      );
}

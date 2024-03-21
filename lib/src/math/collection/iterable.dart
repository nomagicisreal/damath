///
///
/// this file contains:
///
/// [IteratorExtension]
///
/// [IterableExtension]
/// [IterableIntExtension], [IterableDoubleExtension]
/// [IterableIterableExtension]
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
/// [fill], ...
/// [generateFrom], ...
///
/// instance getter and methods
/// [isVariantTo], ...
/// [anyElementWith], ...
/// [append], ...
///
/// [foldWith], ...
/// [reduceWith], ...
/// [expandWith], ...
///
/// [intersection], ...
/// [difference], ...
/// [interval], ...
///
/// [groupBy], ...
/// [mirrored], ...
/// [chunk], ...
/// [combinationsWith]
///
extension IterableExtension<I> on Iterable<I> {
  static int toLength<I>(Iterable<I> iterable) => iterable.length;

  ///
  /// [fill]
  /// [generateFrom]
  ///
  static Iterable<I> fill<I>(int count, I value) sync* {
    for (var i = 0; i < count; i++) {
      yield value;
    }
  }

  static Iterable<I> generateFrom<I>(
    int count,
    Generator<I> generator, [
    int start = 1,
  ]) sync* {
    for (var i = start; i < count; i++) {
      yield generator(i);
    }
  }

  ///
  /// [isVariantTo]
  ///
  bool isVariantTo(Iterable<I> another) =>
      length == another.length && iterator.containsAll(another.iterator);

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
  /// append
  /// [append], [appendAll]
  ///
  Iterable<I> append(I value) sync* {
    yield* this;
    yield value;
  }

  Iterable<I> appendAll(Iterable<I> other) sync* {
    yield* this;
    yield* other;
  }

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
    Collector<S, I, T> companion,
  ) {
    assert(length == another.length);
    return iterator.interFold(initialValue, another.iterator, companion);
  }

  S foldTogether<E, S>(
    S initialValue,
    Iterable<E> another,
    Companion<S, I> companion,
    Companion<S, E> companionAnother,
    Collapser<S> combine,
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
  I reduceWith(
      Iterable<I> another, Reducer<I> initialize, Collapser<I> mutual) {
    assert(length == another.length);
    return iterator.interReduce(another.iterator, initialize, mutual);
  }

  I reduceTogether(
    Iterable<I> another,
    Reducer<I> initialize,
    Collapser<I> reducer,
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
    assert(length == another.length);
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
  Iterable<I> intersection(Iterable<I> another) => iterator.interYieldingWhere(
        another.iterator,
        FPredicatorCombiner.isEqual,
        FReducer.keepCurrent,
      );

  Iterable<int> intersectionIndex(Iterable<I> another, [int start = 0]) =>
      iterator.interYieldingIndexableWhere(
        another.iterator,
        FPredicatorCombiner.isEqual,
        (p, q, index) => index,
        start,
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
  Iterable<I> difference(Iterable<I> another) => iterator.diffYieldingWhere(
        another.iterator,
        FPredicatorCombiner.isNotEqual,
        FPredicator.alwaysTrue,
        FReducer.keepCurrent,
        FMapper.keep,
      );

  Iterable<int> differenceIndex(Iterable<I> another, [int start = 0]) =>
      iterator.diffYieldingIndexableWhere(
        another.iterator,
        FPredicatorCombiner.isNotEqual,
        FPredicator.alwaysTrue,
        (p, q, index) => index,
        (value, index) => index,
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
        (map, e1, e2, index) =>
            map..putIfAbsentWhen(e1 != e2, index, () => MapEntry(e1, e2)),
        (map, e1, index) => map..putIfAbsent(index, () => MapEntry(e1, null)),
        0,
      );

  ///
  /// [interval]
  ///
  Iterable<S> interval<T, S>(Iterable<T> another, Linker<I, T, S> link) {
    assert(another.length + 1 == length);
    return iterator.interval(another.iterator, link);
  }

  ///
  /// [groupBy]
  ///
  Map<K, Iterable<I>> groupBy<K>(Translator<I, K> toKey) => fold(
        {},
        (map, value) => map
          ..update(
            toKey(value),
            FMapper.iterableAppend(value),
            ifAbsent: FSupplier.iterableElement(value),
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
/// static methods:
/// [sequence], ...
///
/// instance methods:
/// [sum], ...
///
extension IterableIntExtension on Iterable<int> {
  static Iterable<int> sequence(int length, [int start = 1]) =>
      Iterable.generate(length, (i) => start + i);

  static Iterable<int> seq(int begin, int end) sync* {
    for (var i = begin; i <= end; i++) {
      yield i;
    }
  }

  int get sum => reduce(FReducer.intAdd);
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
/// [toStringPadLeft], [toStringMapJoin]
/// [anyElementsLengthIsDifferentWith]
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
    Translator<Iterable<I>, String>? mapper,
    String separator = "\n",
  ]) =>
      map(mapper ?? (e) => e.toString()).join(separator);

  String toStringPadLeft(int space) => toStringMapJoin(
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
      );

  ///
  /// [anyElementsLengthIsDifferentWith]
  ///
  bool anyElementsLengthIsDifferentWith<P>(Iterable<Iterable<P>> another) =>
      anyElementWith(another, FPredicatorCombiner.iterableIsLengthDifferent);

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

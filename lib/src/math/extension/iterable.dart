///
///
/// this file contains:
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
/// [conditionalConsume], ...
/// [predicateToOthers], ...
///
/// [anyIsEqual]
/// [everyIsEqual], ...
///
/// [whereMap], ...
///
/// [foldByIndex], ...
/// [reduceByIndex], ...
///
/// [expandWithIndex], ...
/// [flat], ...
/// [mapToList], ...
///
/// [intersectionIterate], ...
/// [differenceIterate], ...
///
/// [chunk], ...
/// [groupBy], ...
///
extension IterableExtension<I> on Iterable<I> {
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
  /// [notContains]
  /// [containsOr]
  ///
  bool notContains(I element) => !contains(element);

  void containsOr(I value, Consumer<Iterable<I>> action) =>
      contains(value) ? null : action(this);

  ///
  /// [containsAll]
  /// [isCombinationOf]
  ///

  ///
  /// let m = [length], n = [another].length,
  /// iterate on [another] to find:
  ///   worst: m * n
  ///   best : n
  ///   avg  : m + 1
  ///
  /// remove element in [another] after found:
  ///   worst: m * n + n
  ///   best : m
  ///   avg  : m + 1 + m/n
  ///
  bool containsAll(Iterable<I> another) =>
      another.every((element) => contains(element));

  bool isCombinationOf(Iterable<I> another) =>
      length == another.length && containsAll(another);

  ///
  /// [conditionalConsume]
  ///
  void conditionalConsume(Predicator<I> test, Consumer<I> consume) {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (test(current)) consume(current);
    }
  }

  ///
  /// [predicateToOthers]
  ///
  bool predicateToOthers(PredicateCombiner<I> predicate) {
    final iterator = this.iterator..moveNext();
    final List<I> list = [iterator.current];
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (list.any((e) => predicate(current, e))) return true;
      list.add(current);
    }
    return false;
  }

  ///
  /// [anyIsEqual]
  /// [anyIsDifferent]
  ///
  bool get anyIsEqual => predicateToOthers(FPredicatorCombiner.isEqual);

  bool get anyIsDifferent => predicateToOthers(FPredicatorCombiner.isNotEqual);

  ///
  /// [anyIndexable]
  ///
  bool anyIndexable(Checker<I> checker) {
    var i = -1;
    return any((element) => checker(++i, element));
  }

  ///
  /// [anyElementWith]
  /// [anyElementIsEqualWith]
  /// [anyElementIsDifferentWith]
  ///
  bool anyElementWith<P>(
    Iterable<P> another,
    Differentiator<I, P> differentiate, {
    int expect = 0,
  }) {
    assert(length == another.length);
    final i1 = iterator;
    final i2 = another.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      if (differentiate(i1.current, i2.current) == expect) return true;
    }
    return false;
  }

  bool anyElementIsEqualWith(Iterable<I> another) => anyElementWith(
        another,
        (v1, v2) => v1 == v2 ? 0 : -1,
        expect: 0,
      );

  bool anyElementIsDifferentWith(Iterable<I> another) => anyElementWith(
        another,
        (v1, v2) => v1 != v2 ? 0 : -1,
        expect: 0,
      );

  ///
  /// [everyIsEqual]
  /// [everyIsDifferent]
  /// [everyIsIdenticalOn]
  ///
  bool get everyIsEqual => !anyIsDifferent;

  bool get everyIsDifferent => !anyIsEqual;

  bool everyIsIdenticalOn<T>(Translator<I, T> toId) => toSet().length == length;

  ///
  /// [everyIndexable]
  ///
  bool everyIndexable(Checker<I> checker) {
    var i = -1;
    return every((element) => checker(++i, element));
  }

  ///
  /// [everyElementsWith]
  /// [everyElementsAreEqualWith]
  /// [everyElementsAreDifferentWith]
  ///
  bool everyElementsWith<P>(
    Iterable<P> another,
    Differentiator<I, P> differentiate, {
    int expect = 0,
  }) {
    assert(length == another.length);
    final i1 = iterator;
    final i2 = another.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      if (differentiate(i1.current, i2.current) != expect) {
        return false;
      }
    }
    return true;
  }

  bool everyElementsAreEqualWith(Iterable<I> another) =>
      !anyElementIsDifferentWith(another);

  bool everyElementsAreDifferentWith(Iterable<I> another) =>
      !anyElementIsEqualWith(another);

  ///
  /// [whereMap]
  ///
  Iterable<T> whereMap<T>(Predicator<I> test, Translator<I, T> toValue) sync* {
    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (test(current)) yield toValue(current);
    }
  }

  ///
  /// [firstWhereOrNull]
  /// [firstWhereMap]
  ///
  I? firstWhereOrNull(Predicator<I> test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  S firstWhereMap<S>(
    Predicator<I> test,
    Translator<I, S> toValue, [
    Supplier<I>? orElse,
  ]) =>
      toValue(firstWhere(test, orElse: orElse));

  ///
  /// [foldByIndex]
  ///
  S foldByIndex<S>(
    S initialValue,
    CompanionGenerator<S, I> combine, {
    int start = 0,
  }) {
    int index = start - 1;
    return fold(
      initialValue,
      (value, element) => combine(value, element, ++index),
    );
  }

  ///
  /// [foldWith]
  /// [foldWithIndex]
  ///
  S foldWith<S, T>(
    Iterable<T> another,
    S initialValue,
    Companion2<S, I, T> companion,
  ) {
    assert(another.length == length);
    return intersectionFold(initialValue, another, companion);
  }

  S foldWithIndex<S, T>(
    Iterable<T> another,
    S initialValue,
    Companion2Generator<S, I, T> companion, [
    int start = 0,
  ]) {
    assert(another.length == length);
    return intersectionFoldIndexable(initialValue, another, companion);
  }

  ///
  /// [reduceByIndex]
  ///
  I reduceByIndex(
    ReducerGenerator<I> generator, {
    int start = 0,
  }) {
    int index = start - 1;
    return reduce((value, element) => generator(value, element, ++index));
  }

  ///
  /// [reduceWith]
  /// [reduceWithIndex]
  ///
  I reduceWith(Iterable<I> another, Reducer2<I> mutual) {
    assert(another.length == length);
    return intersectionReduce(another, mutual);
  }

  I reduceWithIndex(Iterable<I> another, Reducer2Generator<I> mutual) {
    assert(another.length == length);
    return intersectionReduceIndexable(another, mutual);
  }

  ///
  /// [reduceTogether]
  /// [reduceTogetherIndex]
  ///
  I reduceTogether<S>(
    Iterable<S> another,
    Reducer<I> reducer,
    Reducer<S> reducerAnother,
    Companion<I, S> companion,
  ) {
    assert(length == another.length);
    final iterator = another.iterator..moveNext();
    var current = iterator.current;
    return reduce((v1, v2) {
      iterator.moveNext();
      current = reducerAnother(current, iterator.current);
      return companion(reducer(v1, v2), current);
    });
  }

  I reduceTogetherIndex<S>(
    Iterable<S> another,
    Reducer<I> reducer,
    Reducer<S> reducerAnother,
    CompanionGenerator<I, S> companion, [
    int start = 0,
  ]) {
    var i = start - 1;
    return reduceTogether(
      another,
      reducer,
      reducerAnother,
      (origin, another) => companion(origin, another, ++i),
    );
  }

  ///
  /// [reduceFrom]
  /// [reduceTo]
  ///
  S reduceFrom<S>(Translator<I, S> initialize, Companion<S, I> combine) {
    final iterator = this.iterator..moveNext();
    var val = initialize(iterator.current);
    while (iterator.moveNext()) {
      val = combine(val, iterator.current);
    }
    return val;
  }

  S reduceTo<S>(Translator<I, S> toElement, Reducer<S> combine) =>
      reduceFrom(toElement, (o, another) => combine(o, toElement(another)));

  ///
  /// [expandWithIndex]
  /// [expandWith]
  ///
  Iterable<S> expandWithIndex<S>(Mixer<I, int, Iterable<S>> mix) {
    int index = 0;
    return expand((element) => mix(element, index++));
  }

  Iterable<S> expandWith<S, Q>(List<Q> another, Mixer<I, Q, Iterable<S>> mix) {
    int index = 0;
    return expand((element) => mix(element, another[index++]));
  }

  ///
  /// [flat]
  /// [flattedLength]
  ///
  Iterable<S> flat<S>() => fold<List<S>>(
        [],
        (list, element) => switch (element) {
          S() => list..add(element),
          Iterable<S>() => list..addAll(element),
          Iterable<Iterable<dynamic>>() => list..addAll(element.flat()),
          _ => throw UnimplementedError('$element is not iterable or $S'),
        },
      );

  int flattedLength<S>() => reduceTo<int>(
        (element) => switch (element) {
          S() => 1,
          Iterable<S>() => element.length,
          Iterable<Iterable>() => element.flattedLength(),
          _ => throw UnimplementedError('unknown type: $element for $S'),
        },
        FReducer.intAdd,
      );

  ///
  /// [mapToList]
  /// [mapToListByGenerate]
  /// [mapToSet]
  ///
  List<T> mapToList<T>(Translator<I, T> toElement) {
    final iterator = this.iterator;
    return [for (; iterator.moveNext();) toElement(iterator.current)];
  }

  List<E> mapToListByGenerate<E>(Generator<E> generator) =>
      [for (var i = 0; i < length; i++) generator(i)];

  Set<K> mapToSet<K>(Translator<I, K> toElement) {
    final iterator = this.iterator;
    return {for (; iterator.moveNext();) toElement(iterator.current)};
  }

  ///
  ///
  /// set operations, see also [Set.intersection], [Set.difference],
  ///
  /// [intersectionIterate], [intersectionIterateIndexable]
  /// [intersectionIterateCombine]
  /// [intersectionReduceFrom], [intersectionReduceTo]
  /// [intersectionFold], [intersectionFoldIndexable]
  ///
  /// [differenceIterate], [differenceIterateIndexable]
  /// [differenceReduceFrom], [differenceReduceTo]
  /// [differenceFold], [differenceFoldIndexable]
  ///

  ///
  /// [intersectionIterate]
  /// [intersectionIterateIndexable]
  ///
  void intersectionIterate<T>(Iterable<T> another, Intersector<I, T> mutual) {
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      mutual(iterator.current, iteratorAnother.current);
    }
  }

  void intersectionIterateIndexable<T>(
    Iterable<T> another,
    IntersectorIndexable<I, T> mutual, [
    int start = 0,
  ]) {
    var i = start - 1;
    intersectionIterate(another, (a, b) => mutual(a, b, ++i));
  }

  ///
  /// [intersectionIterateCombine]
  ///
  Iterable<MapEntry<I, V>> intersectionIterateCombine<V>(
    Iterable<V> another,
  ) sync* {
    final iterator = this.iterator;
    final iteratorValues = another.iterator;

    while (iterator.moveNext() && iteratorValues.moveNext()) {
      yield MapEntry(iterator.current, iteratorValues.current);
    }
  }

  ///
  /// [intersectionReduce]
  /// [intersectionReduceIndexable]
  ///
  I intersectionReduce(Iterable<I> another, Reducer2<I> mutual) {
    final iterator = this.iterator..moveNext();
    final iteratorAnother = another.iterator;

    var val = iterator.current;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      val = mutual(val, iterator.current, iteratorAnother.current);
    }
    return val;
  }

  I intersectionReduceIndexable(
    Iterable<I> another,
    Reducer2Generator<I> mutual, [
    int start = 0,
  ]) {
    var i = start - 1;
    return intersectionReduce(another, (c, v1, v2) => mutual(c, v1, v2, ++i));
  }

  ///
  /// [intersectionReduceFrom]
  /// [intersectionReduceTo]
  ///
  S intersectionReduceFrom<S, T>(
    Iterable<T> another,
    Translator<I, S> initialize,
    Companion2<S, I, T> mutual,
  ) {
    final iterator = this.iterator..moveNext();
    final iteratorAnother = another.iterator;

    var val = initialize(iterator.current);
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      val = mutual(val, iterator.current, iteratorAnother.current);
    }
    return val;
  }

  S intersectionReduceTo<S, T>(
    Iterable<T> another,
    Translator<I, S> toElement,
    Companion2<S, S, T> mutual,
  ) =>
      intersectionReduceFrom(
        another,
        toElement,
        (origin, a, b) => mutual(origin, toElement(a), b),
      );

  ///
  /// [intersectionFold]
  /// [intersectionFoldIndexable]
  ///
  S intersectionFold<S, T>(
    S initialValue,
    Iterable<T> another,
    Companion2<S, I, T> companion,
  ) {
    var result = initialValue;
    intersectionIterate(
      another,
      (valueA, valueB) => result = companion(initialValue, valueA, valueB),
    );
    return result;
  }

  S intersectionFoldIndexable<S, T>(
    S initialValue,
    Iterable<T> another,
    Companion2Generator<S, I, T> companion,
  ) {
    var result = initialValue;
    intersectionIterateIndexable(
      another,
      (e1, e2, i) => result = companion(initialValue, e1, e2, i),
    );
    return result;
  }

  ///
  /// [differenceIterate]
  /// [differenceIterateIndexable]
  ///
  void differenceIterate<T>(
    Iterable<T> another,
    Intersector<I, T> mutual,
    Consumer<I> overflow,
  ) {
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iteratorAnother.moveNext()) {
      if (iterator.moveNext()) {
        mutual(iterator.current, iteratorAnother.current);
      }
    }
    while (iterator.moveNext()) {
      overflow(iterator.current);
    }
  }

  void differenceIterateIndexable<T>(
    Iterable<T> another,
    IntersectorIndexable<I, T> mutual,
    ConsumerIndexable<I> overflow, [
    int start = 0,
  ]) {
    var i = start - 1;
    differenceIterate(
      another,
      (a, b) => mutual(a, b, ++i),
      (a) => overflow(a, ++i),
    );
  }

  ///
  /// [differenceReduceFrom]
  /// [differenceReduceTo]
  ///
  S differenceReduceFrom<S, T>(
    Iterable<T> another,
    Translator<I, S> initialize,
    Companion2<S, I, T> mutual,
    Companion<S, I> overflow,
  ) {
    final iterator = this.iterator..moveNext();
    final iteratorAnother = another.iterator;

    var val = initialize(iterator.current);
    while (iteratorAnother.moveNext()) {
      if (iterator.moveNext()) {
        val = mutual(val, iterator.current, iteratorAnother.current);
      }
    }
    while (iterator.moveNext()) {
      val = overflow(val, iterator.current);
    }
    return val;
  }

  S differenceReduceTo<S, T>(
    Iterable<T> another,
    Translator<I, S> toElement,
    Companion2<S, S, T> mutual,
    Reducer<S> overflow,
  ) =>
      differenceReduceFrom(
        another,
        toElement,
        (origin, a, b) => mutual(origin, toElement(a), b),
        (origin, another) => overflow(origin, toElement(another)),
      );

  ///
  /// [differenceFold]
  /// [differenceFoldIndexable]
  ///
  S differenceFold<S, T>(
    S initialValue,
    Iterable<T> another,
    Companion2<S, I, T> combineMutual,
    Companion<S, I> combineOverflow,
  ) {
    var result = initialValue;
    differenceIterate(
      another,
      (v1, v2) => result = combineMutual(result, v1, v2),
      (value) => result = combineOverflow(result, value),
    );
    return result;
  }

  S differenceFoldIndexable<S, T>(
    S initialValue,
    Iterable<T> another,
    Companion2Generator<S, I, T> combineMutual,
    CompanionGenerator<S, I> combineOverflow, [
    int start = 0,
  ]) {
    var result = initialValue;
    differenceIterateIndexable(
      another,
      (v1, v2, i) => result = combineMutual(result, v1, v2, i),
      (value, i) => result = combineOverflow(result, value, i),
      start,
    );
    return result;
  }

  ///
  /// [chunk]
  ///

  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.chunk([2, 1, 3, 1]); // [[2, 3], [4], [6, 10, 3], [9]]
  ///
  List<List<I>> chunk(Iterable<int> lengthOfEachChunk) {
    assert(lengthOfEachChunk.reduce((a, b) => a + b) == length);
    final iterator = this.iterator;
    final result = <List<I>>[];
    for (var l in lengthOfEachChunk) {
      final list = <I>[];
      for (var i = 0; i < l; i++) {
        iterator.moveNext();
        list.add(iterator.current);
      }
      result.add(list);
    }
    return result;
  }

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
}

///
/// [sum]
///
extension IterableIntExtension on Iterable<int> {
  int get sum => reduce((value, element) => value + element);
}

///
/// [sum], [sumSquared]
///
extension IterableDoubleExtension on Iterable<double> {
  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);
}

///
/// [lengths]
/// [toStringPadLeft], [toStringByMapJoin]
/// [everyElementsLengthAreEqualWith]
/// [foldWith2D]
///
extension IterableIterableExtension<I> on Iterable<Iterable<I>> {
  ///
  /// [lengths]
  ///
  int get lengths => fold(0, (value, element) => value + element.length);

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
        (v1, v2) => v1.length == v2.length ? 0 : -1,
        expect: 0,
      );

  ///
  /// [foldWith2D]
  ///
  S foldWith2D<S, P>(
    Iterable<Iterable<P>> another,
    S initialValue,
    Fusionor<S, I, P, S> fusionor,
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
      intersectionIterate(another, (a, b) => a..addAll(b));
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

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
///
/// [forEachWith], ...
/// [predicateToOthers], ...
///
/// [intersectionIterate], ...
/// [differenceIterate], ...
///
/// [anyIsEqual]
/// [everyIsEqual], ...
///
/// [whereMap], ...
///
/// [foldWithIndex], ...
/// [reduceWithIndex], ...
///
/// [expandWithIndex], ...
/// [flat], ...
///
/// [mapToList], ...
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
  /// [containsAll]
  /// [isCombinationOf]
  ///
  bool notContains(I element) => !contains(element);

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
  /// [forEachWith]
  /// [forEachCombine]
  ///
  void forEachWith<S>(Iterable<S> another, Absorber<I, S> absorber) {
    assert(length == another.length, 'length must be equal');
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      absorber(iterator.current, iteratorAnother.current);
    }
  }

  Iterable<MapEntry<I, V>> forEachCombine<V>(Iterable<V> values) sync* {
    assert(length == values.length, 'length must be equal');
    final iterator = this.iterator;
    final iteratorValues = values.iterator;
    while (iterator.moveNext() && iteratorValues.moveNext()) {
      yield MapEntry(iterator.current, iteratorValues.current);
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
  ///
  /// set operations, see also [Set.intersection], [Set.difference],
  ///
  /// [intersectionIterate], [intersectionIterateIndexable]
  /// [intersectionFold], [intersectionFoldIndexable]
  /// [differenceIterate], [differenceIterateIndexable]
  /// [differenceFold], [differenceFoldIndexable]
  ///

  ///
  /// [intersectionIterate]
  /// [intersectionIterateIndexable]
  ///
  void intersectionIterate(Iterable<I> another, Intersector<I> mutual) {
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      mutual(iterator.current, iteratorAnother.current);
    }
  }

  void intersectionIterateIndexable(
    Iterable<I> another,
    IntersectorIndexable<I> mutual,
  ) {
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    int i = -1;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      mutual(iterator.current, iteratorAnother.current, ++i);
    }
  }

  ///
  /// [intersectionFold]
  /// [intersectionFoldIndexable]
  ///
  S intersectionFold<S>(
    S initialValue,
    Iterable<I> another,
    Companion2<S, I> companion,
  ) {
    var result = initialValue;
    intersectionIterate(
      another,
      (valueA, valueB) => result = companion(initialValue, valueA, valueB),
    );
    return result;
  }

  S intersectionFoldIndexable<S>(
    S initialValue,
    Iterable<I> another,
    Companion2Generator<S, I> companion,
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
  void differenceIterate(
    Iterable<I> another,
    Intersector<I> mutual,
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

  void differenceIterateIndexable(
    Iterable<I> another,
    IntersectorIndexable<I> mutual,
    ConsumerIndexable<I> overflow,
  ) {
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    var i = -1;
    while (iteratorAnother.moveNext()) {
      if (iterator.moveNext()) {
        mutual(iterator.current, iteratorAnother.current, ++i);
      }
    }
    while (iterator.moveNext()) {
      overflow(iterator.current, ++i);
    }
  }

  ///
  /// [differenceFold]
  /// [differenceFoldIndexable]
  ///
  S differenceFold<S>(
    S initialValue,
    Iterable<I> another,
    Companion2<S, I> combineMutual,
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

  S differenceFoldIndexable<S>(
    S initialValue,
    Iterable<I> another,
    Companion2Generator<S, I> combineMutual,
    CompanionGenerator<S, I> combineOverflow,
  ) {
    var result = initialValue;
    differenceIterateIndexable(
      another,
      (v1, v2, i) => result = combineMutual(result, v1, v2, i),
      (value, i) => result = combineOverflow(result, value, i),
    );
    return result;
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

  S firstWhereMap<S>(Predicator<I> test, Translator<I, S> toValue) =>
      toValue(firstWhere(test));

  ///
  /// [foldWithIndex]
  /// [foldWith]
  ///
  S foldWithIndex<S>(
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

  S foldWith<S, P>(
    Iterable<P> another,
    S initialValue,
    Fusionor<S, I, P, S> fusionor,
  ) {
    var value = initialValue;
    forEachWith(
      another,
      (e, eAnother) => value = fusionor(value, e, eAnother),
    );
    return value;
  }

  ///
  /// [reduceWithIndex]
  /// [reduceWith]
  ///
  I reduceWithIndex(
    ReducerGenerator<I> reducing, {
    int start = 0,
  }) {
    int index = start - 1;
    return reduce((value, element) => reducing(value, element, ++index));
  }

  I reduceWith<S>(
    Iterable<S> another,
    Fusionor<S, I, I, I> fusionor, {
    int start = 0,
  }) {
    assert(isNotEmpty && another.isNotEmpty);
    final iterator = another.iterator;
    return reduce((v1, v2) {
      iterator.moveNext();
      return fusionor(iterator.current, v1, v2);
    });
  }

  ///
  /// [reduceTo]
  /// [reduceToNum]
  /// [reduceToString]
  ///
  S reduceTo<S>(
    Reducer<S> reducer,
    Translator<I, S> translator,
  ) {
    assert(isNotEmpty);
    final iterator = this.iterator..moveNext();
    S val = translator(iterator.current);
    while (iterator.moveNext()) {
      val = reducer(val, translator(iterator.current));
    }
    return val;
  }

  N reduceToNum<N extends num>({
    required Reducer<N> reducer,
    required Translator<I, N> translator,
  }) =>
      reduceTo(reducer, translator);

  String reduceToString([String separator = '\n']) =>
      fold('', (s1, s2) => '$s1$separator$s2');

  ///
  /// [reduceTogether]
  ///
  S reduceTogether<S>(
    Iterable<S> another,
    Fusionor<S, S, S, S> reducer,
    Translator<I, S> translator,
  ) {
    assert(another.isNotEmpty);
    final iterator = another.iterator;
    return reduceTo(
      (v1, v2) {
        iterator.moveNext();
        return reducer(iterator.current, v1, v2);
      },
      translator,
    );
  }

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

  int flattedLength<S>() => reduceToNum(
        reducer: (v1, v2) => v1 + v2,
        translator: (element) => switch (element) {
          S() => 1,
          Iterable<S>() => element.length,
          Iterable<Iterable>() => element.flattedLength(),
          _ => throw UnimplementedError('unknown type: $element for $S'),
        },
      );

  ///
  /// [mapToList]
  /// [mapToListByGenerate]
  ///
  List<T> mapToList<T>(Translator<I, T> toElement) {
    final iterator = this.iterator;
    return [for (; iterator.moveNext();) toElement(iterator.current)];
  }

  List<E> mapToListByGenerate<E>(Generator<E> generator) =>
      [for (var i = 0; i < length; i++) generator(i)];

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
      forEachWith(another, (a, b) => a..addAll(b));
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

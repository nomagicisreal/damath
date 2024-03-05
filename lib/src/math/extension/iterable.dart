///
///
/// this file contains:
///
/// [IterableExtension]
/// [IterableIntExtension], [IterableDoubleExtension]
/// [IterableIterableExtension], [IterableSetExtension]
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
/// [forEachWith], ...
///
/// [anyOf], ...
/// [everyIsEqual], ...
///
/// [firstWhereOrNull], ...
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
/// [combine], ...
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
  ///
  void forEachWith<S>(Iterable<S> another, Absorber<I, S> absorber) {
    assert(length == another.length, 'length must be equal');
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      absorber(iterator.current, iteratorAnother.current);
    }
  }

  ///
  /// [anyOf]
  ///
  bool anyOf(Comparator<I> compare, {int expect = 0}) {
    final iterator = this.iterator..moveNext();
    final List<I> list = [iterator.current];
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (list.any((e) => compare(e, current) == expect)) return true;
      list.add(current);
    }
    return false;
  }

  ///
  /// [anyIsEqual]
  /// [anyIsDifferent]
  ///
  bool get anyIsEqual => anyOf((a, b) => a == b ? 0 : -1, expect: 0);

  bool get anyIsDifferent => anyOf((a, b) => a != b ? 0 : -1, expect: 0);

  ///
  /// [anyWithIndex]
  ///
  bool anyWithIndex(Checker<I> checker, {int start = 0}) {
    int index = start - 1;
    return any((element) => checker(++index, element));
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
  ///
  bool get everyIsEqual => !anyIsDifferent;

  bool get everyIsDifferent => !anyIsEqual;

  ///
  /// [everyIsIdenticalOn]
  /// [everyWithIndex]
  ///
  bool everyIsIdenticalOn<T>(Translator<I, T> toId) => toSet().length == length;

  bool everyWithIndex(Checker<I> checker, {int start = 0}) {
    int index = start - 1;
    return every((element) => checker(++index, element));
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
  /// [firstWhereOrNull]
  ///
  I? firstWhereOrNull(Predicator<I> test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

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
  ///
  List<T> mapToList<T>(Translator<I, T> toElement) {
    final iterator = this.iterator;
    final list = <T>[];
    while (iterator.moveNext()) {
      list.add(toElement(iterator.current));
    }
    return list;
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
  Map<S, List<I>> groupBy<S>(Translator<I, S> translator) {
    final map = <S, List<I>>{};
    for (var item in this) {
      map.update(
        translator(item),
        (value) => value..add(item),
        ifAbsent: () => [item],
      );
    }
    return map;
  }

  ///
  /// [combine]
  ///
  List<MapEntry<I, V>> combine<V>(Iterable<V> values) =>
      foldWith(
        values,
        [],
        (list, key, value) => list..add(MapEntry(key, value)),
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
///
extension IterableSetExtension<I> on Iterable<Set<I>> {
  Set<I> get merged => reduce((a, b) => a..addAll(b));
}

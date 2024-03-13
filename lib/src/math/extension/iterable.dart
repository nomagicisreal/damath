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
/// iterator extension
/// [_errorNoElement], ...
/// [actionWhere], ...
///
/// [inter], ...
/// [diff], ...
///
/// [leadThen], ...
///
/// (prevent nested invocation if not duplicate too much)
///
extension IteratorExtension<I> on Iterator<I> {
  static UnsupportedError get _errorNoElement => UnsupportedError('no element');

  ///
  /// generic usages:
  /// [actionWhere], [actionFirstWhere]
  /// [cumulativeWhere]
  ///
  /// [moveNextThen], [moveNextThenWith]
  ///
  /// [reduceTo], [reduceToCombined]
  ///
  /// [entriesByKey], [entriesByValue]
  ///
  /// [mapToList], [mapToSet]
  /// [mapByIndex], [mapToListByIndex]
  ///

  ///
  /// [actionWhere]
  /// [actionFirstWhere]
  ///
  void actionWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) action(current);
    }
  }

  void actionFirstWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) return action(current);
    }
  }

  ///
  /// [cumulativeWhere]
  ///
  int cumulativeWhere(Predicator<I> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current)) val++;
    }
    return val;
  }

  ///
  /// [moveNextThen]
  /// [moveNextThenWith]
  ///
  S moveNextThen<S>(Supplier<S> supplier) =>
      moveNext() ? supplier() : throw _errorNoElement;

  S moveNextThenWith<E, S>(Iterator<E> another, Supplier<S> supplier) =>
      moveNext() && another.moveNext() ? supplier() : throw _errorNoElement;

  ///
  /// [reduceTo]
  /// [reduceToCombined]
  ///
  E reduceTo<E>(Translator<I, E> toElement, Reducer<E> reducer) =>
      moveNextThen(() {
        var val = toElement(current);
        while (moveNext()) {
          val = reducer(val, toElement(current));
        }
        return val;
      });

  E reduceToCombined<E>(Translator<I, E> initialize, Companion<E, I> combine) =>
      moveNextThen(() {
        var val = initialize(current);
        while (moveNext()) {
          val = combine(val, current);
        }
        return val;
      });

  ///
  /// [entriesByKey]
  /// [entriesByValue]
  /// [yielding]
  ///
  Iterable<MapEntry<K, I>> entriesByKey<K>(K key) sync* {
    while (moveNext()) {
      yield MapEntry(key, current);
    }
  }

  Iterable<MapEntry<I, V>> entriesByValue<V>(V value) sync* {
    while (moveNext()) {
      yield MapEntry(current, value);
    }
  }

  Iterable<S> yielding<S>(Translator<I, S> toElement) sync* {
    while (moveNext()) {
      yield toElement(current);
    }
  }

  ///
  /// [mapToList], [mapToSet]
  /// [mapToListByList], [mapToListByMap]
  /// [mapToSetBySet]
  ///
  List<T> mapToList<T>(Translator<I, T> toElement) =>
      [for (; moveNext();) toElement(current)];

  Set<K> mapToSet<K>(Translator<I, K> toElement) =>
      {for (; moveNext();) toElement(current)};

  List<T> mapToListByList<T, R>(List<R> list, Mixer<I, List<R>, T> mixer) =>
      [for (; moveNext();) mixer(current, list)];

  List<T> mapToListByMap<T, K, V>(Map<K, V> map, Mixer<I, Map<K, V>, T> mixer) =>
      [for (; moveNext();) mixer(current, map)];

  Set<K> mapToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) =>
      {for (; moveNext();) mixer(current, set)};

  ///
  /// [mapByIndex]
  /// [mapToListByIndex]
  ///
  Iterable<S> mapByIndex<S>(
    TranslatorGenerator<I, S> toElement,
    int start,
  ) sync* {
    for (var i = start; moveNext(); i++) {
      yield toElement(current, i);
    }
  }

  List<S> mapToListByIndex<S>(
    TranslatorGenerator<I, S> toElement, [
    int start = 0,
  ]) =>
      [for (var i = start; moveNext(); i++) toElement(current, i)];

  ///
  ///
  /// intersection
  /// [inter], [interIndexable]
  ///
  /// [interYield], [interYielding]
  /// [interYieldIndexable], [interYieldingIndexable]
  /// [interYieldEntry], [interYieldingEntries]
  ///
  /// [interFold], [interFoldIndexable]
  /// [interReduceTo], [interReduceToIndexable]
  /// [interReduce], [interReduceIndexable]
  ///

  ///
  /// [inter]
  /// [interIndexable]
  ///
  void inter<E>(Iterator<E> another, Intersector<I, E> mutual) {
    while (moveNext() && another.moveNext()) {
      mutual(current, another.current);
    }
  }

  void interIndexable<E>(
    Iterator<E> another,
    IntersectorIndexable<I, E> mutual,
    int start,
  ) {
    var i = start - 1;
    while (moveNext() && another.moveNext()) {
      mutual(current, another.current, ++i);
    }
  }

  ///
  /// [interYield]
  /// [interYielding]
  ///
  Iterable<S> interYield<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> combine,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield combine(current, another.current);
    }
  }

  Iterable<S> interYielding<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> combine,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield* combine(current, another.current);
    }
  }

  ///
  /// [interYieldIndexable]
  /// [interYieldingIndexable]
  ///
  Iterable<S> interYieldIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> combine,
    int start,
  ) sync* {
    var i = start - 1;
    while (moveNext() && another.moveNext()) {
      yield combine(current, another.current, ++i);
    }
  }

  Iterable<S> interYieldingIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> combine,
    int start,
  ) sync* {
    var i = start - 1;
    while (moveNext() && another.moveNext()) {
      yield* combine(current, another.current, ++i);
    }
  }

  ///
  /// [interYieldEntry]
  /// [interYieldingEntries]
  ///
  Iterable<MapEntry<I, E>> interYieldEntry<E>(Iterator<E> values) sync* {
    while (moveNext() && values.moveNext()) {
      yield MapEntry(current, values.current);
    }
  }

  Iterable<MapEntry<I, E>> interYieldingEntries<E>(
    Iterator<E> values,
    Mixer<I, E, Iterable<MapEntry<I, E>>> mixer,
  ) sync* {
    while (moveNext() && values.moveNext()) {
      yield* mixer(current, values.current);
    }
  }

  ///
  /// [interFold]
  /// [interFoldIndexable]
  ///
  S interFold<E, S>(
    S initialValue,
    Iterator<E> another,
    Companion2<S, I, E> mutual,
  ) {
    var val = initialValue;
    while (moveNext() && another.moveNext()) {
      val = mutual(val, current, another.current);
    }
    return val;
  }

  S interFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> another,
    Companion2Generator<S, I, E> mutual,
    int start,
  ) {
    var i = start - 1;
    return interFold(
      initialValue,
      another,
      (value, a, b) => mutual(value, a, b, ++i),
    );
  }

  ///
  /// [interReduceTo]
  /// [interReduceToIndexable]
  ///
  S interReduceTo<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> initialize,
    Companion2<S, I, E> mutual,
  ) =>
      moveNextThenWith(another, () {
        var val = initialize(current, another.current);
        while (moveNext() && another.moveNext()) {
          val = mutual(val, current, another.current);
        }
        return val;
      });

  S interReduceToIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> initialize,
    Companion2Generator<S, I, E> mutual,
    int start,
  ) {
    var i = start - 1;
    return interReduceTo(
      another,
      (origin, another) => initialize(origin, another, ++i),
      (o, value, e) => mutual(o, value, e, ++i),
    );
  }

  ///
  /// [interReduce]
  /// [interReduceIndexable]
  ///
  I interReduce(
    Iterator<I> another,
    Reducer<I> initialize,
    Reducer2<I> mutual,
  ) =>
      interReduceTo(another, initialize, mutual);

  I interReduceIndexable(
    Iterator<I> another,
    ReducerGenerator<I> initialize,
    Reducer2Generator<I> mutual,
    int start,
  ) {
    var i = start - 1;
    return interReduceTo(
      another,
      (origin, another) => initialize(origin, another, ++i),
      (o, value, e) => mutual(o, value, e, ++i),
    );
  }

  ///
  /// difference
  /// [diff], [diffIndexable]
  ///
  /// [diffYield], [diffYielding]
  /// [diffYieldIndexable], [diffYieldingIndexable]
  /// [diffYieldEntry], [diffYieldingEntries]
  ///
  /// [diffFold], [diffFoldIndexable]
  /// [diffReduceTo], [diffReduceToIndexable]
  /// [diffReduce], [diffReduceIndexable]
  ///

  ///
  /// [diff]
  /// [diffIndexable]
  ///
  void diff<E>(
    Iterator<E> another,
    Intersector<I, E> mutual,
    Consumer<I> overflow,
  ) {
    while (another.moveNext()) {
      if (moveNext()) mutual(current, another.current);
    }
    while (moveNext()) {
      overflow(current);
    }
  }

  void diffIndexable<E>(
    Iterator<E> another,
    IntersectorIndexable<I, E> mutual,
    ConsumerIndexable<I> overflow,
    int start,
  ) {
    var i = start - 1;
    while (another.moveNext()) {
      if (moveNext()) mutual(current, another.current, ++i);
    }
    while (moveNext()) {
      overflow(current, ++i);
    }
  }

  ///
  /// [diffYield]
  /// [diffYielding]
  ///
  Iterable<S> diffYield<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
    Translator<I, S> overflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext()) yield mixer(current, another.current);
    }
    while (moveNext()) {
      yield overflow(current);
    }
  }

  Iterable<S> diffYielding<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> mixer,
    Translator<I, Iterable<S>> overflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext()) yield* mixer(current, another.current);
    }
    while (moveNext()) {
      yield* overflow(current);
    }
  }

  ///
  /// [diffYieldIndexable]
  /// [diffYieldingIndexable]
  ///
  Iterable<S> diffYieldIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> mixer,
    TranslatorGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYield(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffYieldingIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> mixer,
    TranslatorGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYielding(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  ///
  /// [diffYieldEntry]
  /// [diffYieldingEntries]
  ///
  Iterable<MapEntry<I, V>> diffYieldEntry<V>(
    Iterator<V> values,
    Translator<I, MapEntry<I, V>> overflow,
    int start,
  ) =>
      diffYield(values, (p, q) => MapEntry(p, q), overflow);

  Iterable<MapEntry<I, V>> diffYieldingEntries<V>(
    Iterator<V> values,
    Mixer<I, V, Iterable<MapEntry<I, V>>> mixer,
    Translator<I, Iterable<MapEntry<I, V>>> overflow,
    int start,
  ) =>
      diffYielding(values, mixer, overflow);

  ///
  /// [diffFold]
  /// [diffFoldIndexable]
  ///
  S diffFold<E, S>(
    S initialValue,
    Iterator<E> another,
    Companion2<S, I, E> companion,
    Companion<S, I> overflow,
  ) {
    var val = initialValue;
    while (another.moveNext()) {
      if (moveNext()) val = companion(val, current, another.current);
    }
    while (moveNext()) {
      val = overflow(val, current);
    }
    return val;
  }

  S diffFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> another,
    Companion2Generator<S, I, E> companion,
    CompanionGenerator<S, I> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffFold(
      initialValue,
      another,
      (value, a, b) => companion(value, a, b, ++i),
      (origin, another) => overflow(origin, another, ++i),
    );
  }

  ///
  /// [diffReduceTo]
  /// [diffReduceToIndexable]
  ///
  S diffReduceTo<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> initialize,
    Companion2<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      moveNextThenWith(another, () {
        var val = initialize(current, another.current);
        while (another.moveNext()) {
          if (moveNext()) val = mutual(val, current, another.current);
        }
        while (moveNext()) {
          val = overflow(val, current);
        }
        return val;
      });

  S diffReduceToIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> initialize,
    Companion2Generator<S, I, E> mutual,
    CompanionGenerator<S, I> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffReduceTo(
      another,
      (origin, another) => initialize(origin, another, ++start),
      (o, value, e) => mutual(o, value, e, ++i),
      (current, value) => overflow(current, value, ++i),
    );
  }

  ///
  /// [diffReduce]
  /// [diffReduceIndexable]
  ///
  I diffReduce(
    Iterator<I> another,
    Reducer<I> initialize,
    Reducer2<I> mutual,
    Reducer<I> overflow,
  ) =>
      diffReduceTo(another, initialize, mutual, overflow);

  I diffReduceIndexable(
    Iterator<I> another,
    ReducerGenerator<I> initialize,
    Reducer2Generator<I> mutual,
    ReducerGenerator<I> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffReduceTo(
      another,
      (origin, another) => initialize(origin, another, ++i),
      (o, value, e) => mutual(o, value, e, ++i),
      (origin, another) => overflow(origin, another, ++i),
    );
  }

  ///
  /// lead then
  /// [leadThen]
  /// [leadThenInterFold], [leadThenDiffFold]
  /// [leadThenInterReduceTo], [leadThenDiffReduceTo]
  ///

  ///
  /// [leadThen]
  ///
  S leadThen<S>(int from, Supplier<S> supply) {
    for (var i = -1; i < from; i++) {
      if (!moveNext()) throw UnsupportedError('invalid lead from: $from');
    }
    return supply();
  }

  ///
  /// [leadThenInterFold]
  /// [leadThenDiffFold]
  ///
  S leadThenInterFold<E, S>(
    int from,
    Translator<I, S> initialize,
    Iterator<E> another,
    Companion2<S, I, E> mutual,
  ) =>
      leadThen(from, () => interFold(initialize(current), another, mutual));

  S leadThenDiffFold<E, S>(
    int from,
    Translator<I, S> initialize,
    Iterator<E> another,
    Companion2<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      leadThen(
        from,
        () => diffFold(initialize(current), another, mutual, overflow),
      );

  ///
  /// [leadThenInterReduceTo]
  /// [leadThenDiffReduceTo]
  ///
  S leadThenInterReduceTo<E, S>(
    int from,
    Iterator<E> another,
    Mixer<I, E, S> initialize,
    Companion2<S, I, E> mutual,
  ) =>
      leadThen(from, () => interReduceTo(another, initialize, mutual));

  S leadThenDiffReduceTo<E, S>(
    int from,
    Iterator<E> another,
    Mixer<I, E, S> initialize,
    Companion2<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      leadThen(
        from,
        () => diffReduceTo(another, initialize, mutual, overflow),
      );
}

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
/// [whereMap], ...
///
/// [foldByIndex], ...
/// [reduceByIndex], ...
/// [expandByIndex], ...
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
  ///
  bool notContains(I element) => !contains(element);

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

  ///
  /// [isVariantTo]
  ///
  bool isVariantTo(Iterable<I> another) =>
      length == another.length && containsAll(another);

  ///
  /// [containsThen]
  ///
  S containsThen<S>(I value, Supplier<S> onContained, Supplier<S> onNot) =>
      contains(value) ? onContained() : onNot();

  ///
  /// any, every
  /// [_predicate1ToN], [_predicateNToN]
  ///
  /// [anyEqual], [anyDifferent], [anyIdenticalOn], [anyIndexable]
  /// [anyElementWith], [anyElementIsEqualWith], [anyElementIsDifferentWith]
  /// [everyEqual], [everyDifferent], [everyIdenticalOn], [everyIndexable]
  /// [everyElementsWith], [everyElementsAreEqualWith], [everyElementsAreDifferentWith]
  ///

  ///
  /// [_predicate1ToN]
  /// [_predicateNToN]
  ///
  bool _predicate1ToN(PredicateCombiner<I> predicate) {
    final iterator = this.iterator..moveNext();
    var val = iterator.current;
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (predicate(val, current)) return true;
      val = current;
    }
    return false;
  }

  bool _predicateNToN(PredicateCombiner<I> predicate) {
    final iterator = this.iterator..moveNext();
    final list = <I>[iterator.current];
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (list.any((e) => predicate(current, e))) return true;
      list.add(current);
    }
    return false;
  }

  ///
  /// [anyEqual]
  /// [anyDifferent]
  /// [anyIdenticalOn]
  /// [anyIndexable]
  ///
  bool get anyDifferent => _predicate1ToN(FPredicatorCombiner.isNotEqual);

  bool get anyEqual => _predicateNToN(FPredicatorCombiner.isEqual);

  bool anyIdenticalOn<T>(Translator<I, T> toId) =>
      iterator.mapToSet(toId).length != length;

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
  /// [everyEqual]
  /// [everyDifferent]
  /// [everyIdenticalOn]
  /// [everyIndexable]
  ///
  bool get everyEqual => !anyDifferent;

  bool get everyDifferent => !anyEqual;

  bool everyIdenticalOn<T>(Translator<I, T> toId) => !anyIdenticalOn(toId);

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
  ///
  /// where
  /// [whereMap]
  /// [firstWhereOrNull], [firstWhereMap]
  ///
  ///

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
  ///
  /// fold, reduce, expand
  /// [foldByIndex], [foldWith], [foldTogether]
  /// [reduceByIndex], [reduceWith]
  /// [expandByIndex], [expandWith]
  ///

  ///
  /// [foldByIndex]
  /// [foldWith]
  ///
  S foldByIndex<S>(
    S initialValue,
    CompanionGenerator<S, I> combine, {
    int start = 0,
  }) {
    var i = start - 1;
    return fold(initialValue, (v, element) => combine(v, element, ++i));
  }

  S foldWith<S, T>(
    Iterable<T> another,
    S initialValue,
    Companion2<S, I, T> companion,
  ) {
    assert(another.length == length);
    return iterator.interFold(initialValue, another.iterator, companion);
  }

  ///
  /// [foldAccompany]
  /// [foldTogether]
  ///
  S foldAccompany<R, S>(
    S initialValue,
    R accompany,
    Companion2<S, I, R> combine,
    Companion2<R, I, S> after,
  ) {
    var val = accompany;
    return fold(initialValue, (v, element) {
      final result = combine(v, element, val);
      val = after(val, element, result);
      return result;
    });
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
  /// [reduceByIndex]
  /// [reduceWith]
  ///
  I reduceByIndex(
    ReducerGenerator<I> generator, {
    int start = 0,
  }) {
    int index = start - 1;
    return reduce((value, element) => generator(value, element, ++index));
  }

  I reduceWith(Iterable<I> another, Reducer<I> initialize, Reducer2<I> mutual) {
    assert(another.length == length);
    return iterator.interReduce(another.iterator, initialize, mutual);
  }

  ///
  /// [expandByIndex]
  /// [expandWith]
  ///
  Iterable<S> expandByIndex<S>(
    TranslatorGenerator<I, Iterable<S>> generator, [
    int start = 0,
  ]) {
    var i = start - 1;
    return expand((element) => generator(element, ++i));
  }

  Iterable<S> expandWith<E, S>(
    Iterable<E> another,
    Mixer<I, E, Iterable<S>> mixer,
  ) {
    assert(another.length == length);
    return iterator.interYielding(another.iterator, mixer);
  }

  ///
  /// flat
  /// [flat], [flattedLength]
  ///

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

  int flattedLength<S>() => iterator.reduceTo<int>(
        (element) => switch (element) {
          S() => 1,
          Iterable<S>() => element.length,
          Iterable<Iterable>() => element.flattedLength(),
          _ => throw UnimplementedError('unknown type: $element for $S'),
        },
        FReducer.intAdd,
      );

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

  List<int> intersectionIndex(Iterable<I> another, [int start = 0]) =>
      iterator.interFoldIndexable(
        [],
        another.iterator,
        (list, v1, v2, index) => list..addWhen(v1 == v2, index),
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
      iterator.yielding(another.iterator.entriesByKey);
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

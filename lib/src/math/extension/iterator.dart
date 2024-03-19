///
///
/// this file contains:
///
/// [IteratorExtension]
///
///
part of damath_math;

///
/// [_errorNoElement], ...
///
/// [actionWhere], ...
/// [moveNextThen], ...
///
/// [any], [every], ...
///
/// [fold], ...
/// [reduce], ...
/// [yielding], ...
/// [expand], ...
///
/// [inter], ...
/// [diff], ...
/// [leadThen], ...
///
/// [cumulativeWhere], ...
///
///
extension IteratorExtension<I> on Iterator<I> {
  static StateError _errorNoElement() => StateError('no element');

  static StateError _errorElementNotFound() => StateError('element not found');

  static StateError _errorElementNotNest<I, T>(I element) =>
      StateError('$element not nested element of $T');

  ///
  /// [actionWhere]
  /// [actionFirstWhere]
  ///
  void actionWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) action(current);
    }
  }

  ///
  /// [moveNextThen]
  /// [moveNextThenWith]
  ///
  void actionFirstWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) return action(current);
    }
  }

  ///
  /// [moveNextThen]
  /// [moveNextThenWith]
  ///
  S moveNextThen<S>(Supplier<S> supplier) =>
      moveNext() ? supplier() : throw _errorNoElement();

  S moveNextThenWith<E, S>(Iterator<E> another, Supplier<S> supplier) =>
      moveNext() && another.moveNext() ? supplier() : throw _errorNoElement();

  ///
  /// predication
  /// [any], [every]
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
  /// [containsThen]
  ///
  /// [predicate1ToN], [predicateNToN]
  /// [predicate1ToNBy], [predicateNToNBy]
  /// [predicate1ToNByFirst]
  ///
  ///

  ///
  /// [any], [every]
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
  /// [containsThen]
  ///
  bool any(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return true;
    }
    return false;
  }

  bool every(Predicator<I> test) {
    while (moveNext()) {
      if (!test(current)) return false;
    }
    return true;
  }

  bool contains(I element) {
    while (moveNext()) {
      if (element == current) return true;
    }
    return false;
  }

  bool containsAll(Iterator<I> other) {
    while (moveNext()) {
      if (other.notContains(current)) return false;
    }
    return true;
  }

  bool notContains(I element) {
    while (moveNext()) {
      if (element == current) return false;
    }
    return true;
  }

  bool notContainsAll(Iterator<I> other) {
    while (moveNext()) {
      if (other.contains(current)) return false;
    }
    return true;
  }

  S containsThen<S>(I value, Supplier<S> onContained, Supplier<S> onNot) =>
      contains(value) ? onContained() : onNot();

  ///
  /// [predicate1ToN], [predicateNToN]
  /// [predicate1ToNBy], [predicateNToNBy]
  /// [predicate1ToNByFirst]
  ///
  bool predicate1ToN(PredicatorCombiner<I> test) => moveNextThen(() {
        var val = current;
        while (moveNext()) {
          if (test(val, current)) return true;
          val = current;
        }
        return false;
      });

  bool predicateNToN(PredicatorCombiner<I> test) => moveNextThen(() {
        final list = <I>[current];
        while (moveNext()) {
          if (list.any((val) => test(val, current))) return true;
          list.add(current);
        }
        return false;
      });

  bool predicate1ToNBy<T>(
    Translator<I, T> toVal,
    PredicatorCombiner<T> test,
  ) =>
      moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          final v = toVal(current);
          if (test(val, v)) return true;
          val = v;
        }
        return false;
      });

  bool predicateNToNBy<T>(
    Translator<I, T> toVal,
    PredicatorCombiner<T> test,
  ) =>
      moveNextThen(() {
        final list = <T>[toVal(current)];
        while (moveNext()) {
          final v = toVal(current);
          if (list.any((val) => test(val, v))) return true;
          list.add(v);
        }
        return false;
      });

  bool predicate1ToNByFirst<T>(
    Translator<I, T> toVal,
    PredicatorCombiner<T> test,
  ) =>
      moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          if (test(val, toVal(current))) return true;
        }
        return false;
      });

  ///
  /// first where
  /// [firstWhere], [firstWhereOrNull], [firstWhereOrElse]
  /// [firstWhereMap], [firstWhereMapOrNull], [firstWhereMapOrElse]
  ///

  ///
  /// [firstWhere]
  /// [firstWhereOrNull]
  /// [firstWhereOrElse]
  ///
  I firstWhere(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    throw _errorElementNotFound();
  }

  I? firstWhereOrNull(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return null;
  }

  I firstWhereOrElse(Predicator<I> test, Supplier<I> orElse) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return orElse();
  }

  ///
  /// [firstWhereMap]
  /// [firstWhereMapOrNull]
  /// [firstWhereMapOrElse]
  ///
  T firstWhereMap<T>(Predicator<I> test, Translator<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    throw _errorElementNotFound();
  }

  T? firstWhereMapOrNull<T>(Predicator<I> test, Translator<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return null;
  }

  T firstWhereMapOrElse<T>(
    Predicator<I> test,
    Translator<I, T> toVal,
    Supplier<T> orElse,
  ) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return orElse();
  }

  ///
  /// fold
  /// [fold]
  /// [foldByIndex], [foldAccompany], [foldNested]
  ///
  /// reduce
  /// [reduce]
  /// [reduceByIndex], [reduceAccompany], [reduceTo], [reduceToInitialized]
  ///
  /// yielding
  /// [yielding]
  /// [yieldingByIndex], [yieldingAccompany], [yieldingTo]
  /// [yieldingWhere], [yieldingWhereTo]
  /// [yieldingToEntries], [yieldingToEntriesByKey], [yieldingToEntriesByValue]
  /// [yieldingToList], [yieldingToListByIndex], [yieldingToListByList], [yieldingToListByMap]
  /// [yieldingToSet], [yieldingToSetBySet]
  ///
  /// expand
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandTo]
  ///

  ///
  /// [fold]
  /// [foldByIndex]
  /// [foldAccompany]
  /// [foldNested]
  ///
  T fold<T>(T initialValue, Companion<T, I> companion) {
    var value = initialValue;
    while (moveNext()) {
      value = companion(value, current);
    }
    return value;
  }

  T foldByIndex<T>(
    T initialValue,
    CompanionGenerator<T, I> companion, [
    int start = 0,
  ]) {
    var val = initialValue;
    for (var i = start; moveNext(); i++) {
      val = companion(val, current, i);
    }
    return val;
  }

  S foldAccompany<R, S>(
    S initialValue,
    R initialElement,
    Companion2<S, I, R> companion,
    Companion2<R, I, S> after,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (moveNext()) {
      val = companion(val, current, ele);
      ele = after(ele, current, val);
    }
    return val;
  }

  Iterable<T> foldNested<T>() => fold<List<T>>(
        [],
        (list, element) => switch (element) {
          T() => list..add(element),
          Iterable<T>() => list..addAll(element),
          Iterable<Iterable>() => list..addAll(element.iterator.foldNested()),
          _ => throw _errorElementNotNest<I, T>(element),
        },
      );

  ///
  /// [reduce]
  /// [reduceByIndex]
  /// [reduceAccompany]
  /// [reduceTo]
  /// [reduceToInitialized]
  ///
  I reduce(Reducer<I> reducing) => moveNextThen(() {
        var val = current;
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  I reduceByIndex(ReducerGenerator<I> reducing, [int start = 0]) =>
      moveNextThen(() {
        var val = current;
        for (var i = start; moveNext(); i++) {
          val = reducing(val, current, i);
        }
        return val;
      });

  I reduceAccompany<R>(
    R initialElement,
    ReducerCompanion<I, R> reducing,
    CompanionReducer<R, I> after,
  ) =>
      moveNextThen(() {
        var val = current;
        var ele = initialElement;
        while (moveNext()) {
          val = reducing(val, current, ele);
          ele = after(ele, current, val);
        }
        return val;
      });

  T reduceTo<T>(Translator<I, T> toVal, Reducer<T> reducing) =>
      moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          val = reducing(val, toVal(current));
        }
        return val;
      });

  T reduceToInitialized<T>(
    Translator<I, T> initialize,
    Companion<T, I> reducing,
  ) =>
      moveNextThen(() {
        var val = initialize(current);
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  ///
  /// [yielding]
  /// [yieldingByIndex], [yieldingAccompany], [yieldingTo]
  /// [yieldingWhere], [yieldingWhereTo]
  /// [yieldingToEntries], [yieldingToEntriesByKey], [yieldingToEntriesByValue]
  /// [yieldingToList], [yieldingToListByIndex], [yieldingToListByList], [yieldingToListByMap]
  /// [yieldingToSet], [yieldingToSetBySet]
  ///
  Iterable<I> yielding() sync* {
    while (moveNext()) {
      yield current;
    }
  }

  Iterable<I> yieldingAccompany<T>(T value, Companion<I, T> toVal) sync* {
    while (moveNext()) {
      yield toVal(current, value);
    }
  }

  Iterable<S> yieldingTo<S>(Translator<I, S> toVal) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<S> yieldingByIndex<S>(
    TranslatorGenerator<I, S> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) {
      yield toVal(current, i);
    }
  }

  Iterable<I> yieldingWhere(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  Iterable<S> yieldingWhereTo<S>(
    Predicator<I> test,
    Translator<I, S> toVal,
  ) sync* {
    while (moveNext()) {
      if (test(current)) yield toVal(current);
    }
  }

  ///
  ///
  Iterable<MapEntry<K, V>> yieldingToEntries<K, V>(
    Translator<I, MapEntry<K, V>> toVal,
  ) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<MapEntry<K, I>> yieldingToEntriesByKey<K>(K key) sync* {
    while (moveNext()) {
      yield MapEntry(key, current);
    }
  }

  Iterable<MapEntry<I, V>> yieldingToEntriesByValue<V>(V value) sync* {
    while (moveNext()) {
      yield MapEntry(current, value);
    }
  }

  ///
  ///
  List<T> yieldingToList<T>(Translator<I, T> toVal) =>
      [for (; moveNext();) toVal(current)];

  List<S> yieldingToListByIndex<S>(
    TranslatorGenerator<I, S> toVal, [
    int start = 0,
  ]) =>
      [for (var i = start; moveNext(); i++) toVal(current, i)];

  List<T> yieldingToListByList<T, R>(
          List<R> list, Mixer<I, List<R>, T> mixer) =>
      [for (; moveNext();) mixer(current, list)];

  List<T> yieldingToListByMap<T, K, V>(
    Map<K, V> map,
    Mixer<I, Map<K, V>, T> mixer,
  ) =>
      [for (; moveNext();) mixer(current, map)];

  ///
  ///
  Set<K> yieldingToSet<K>(Translator<I, K> toVal) =>
      {for (; moveNext();) toVal(current)};

  Set<K> yieldingToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) =>
      {for (; moveNext();) mixer(current, set)};

  ///
  /// [expand]
  /// [expandByIndex]
  /// [expandAccompany]
  /// [expandTo]
  ///
  Iterable<I> expand(Translator<I, Iterable<I>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  Iterable<I> expandByIndex(
    TranslatorGenerator<I, Iterable<I>> expanding, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) {
      yield* expanding(current, i);
    }
  }

  Iterable<I> expandAccompany<T>(
    T value,
    Mixer<I, T, Iterable<I>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current, value);
    }
  }

  Iterable<T> expandTo<T>(Translator<I, Iterable<T>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  ///
  /// intersection
  /// [inter], [interIndexable]
  ///
  /// [interAny], [interAnyTernary]
  /// [interEvery], [interEveryTernary]
  ///
  /// [interYielding], [interExpand]
  /// [interYieldingWhere], [interExpandWhere]
  /// [interYieldingIndexable], [interExpandIndexable]
  /// [interYieldingEntry], [interExpandEntries]
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
  /// [interAny]
  /// [interAnyTernary]
  ///
  bool interAny<E>(Iterator<E> another, PredicatorMixer<I, E> test) {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) return true;
    }
    return false;
  }

  bool interAnyTernary<E>(
    Iterator<E> another,
    Differentiator<I, E> differentiate, [
    int except = 0,
  ]) {
    while (moveNext() && another.moveNext()) {
      if (differentiate(current, another.current) == except) return true;
    }
    return false;
  }

  ///
  /// [interEvery]
  /// [interEveryTernary]
  ///
  bool interEvery<E>(Iterator<E> another, PredicatorMixer<I, E> test) {
    while (moveNext() && another.moveNext()) {
      if (!test(current, another.current)) return false;
    }
    return true;
  }

  bool interEveryTernary<E>(
    Iterator<E> another,
    Differentiator<I, E> differentiate, [
    int except = 0,
  ]) {
    while (moveNext() && another.moveNext()) {
      if (differentiate(current, another.current) != except) return false;
    }
    return true;
  }

  ///
  /// [interYielding], [interExpand]
  /// [interYieldingWhere], [interExpandWhere]
  ///
  Iterable<S> interYielding<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> combine,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield combine(current, another.current);
    }
  }

  Iterable<S> interExpand<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield* expanding(current, another.current);
    }
  }

  Iterable<S> interYieldingWhere<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
    PredicatorMixer<I, E> test,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) {
        yield mixer(current, another.current);
      }
    }
  }

  Iterable<S> interExpandWhere<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> mixer,
    PredicatorMixer<I, E> test,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) {
        yield* mixer(current, another.current);
      }
    }
  }

  ///
  /// [interYieldingIndexable]
  /// [interExpandIndexable]
  ///
  Iterable<S> interYieldingIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> combine,
    int start,
  ) sync* {
    var i = start - 1;
    while (moveNext() && another.moveNext()) {
      yield combine(current, another.current, ++i);
    }
  }

  Iterable<S> interExpandIndexable<E, S>(
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
  /// [interYieldingEntry]
  /// [interExpandEntries]
  ///
  Iterable<MapEntry<I, E>> interYieldingEntry<E>(Iterator<E> values) sync* {
    while (moveNext() && values.moveNext()) {
      yield MapEntry(current, values.current);
    }
  }

  Iterable<MapEntry<I, E>> interExpandEntries<E>(
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
  /// [diffYielding], [diffExpand]
  /// [diffYieldingWhere], [diffExpandWhere]
  /// [diffYieldingIndexable], [diffExpandIndexable]
  /// [diffYieldingEntry], [diffExpandEntries]
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
  /// [diffYielding], [diffExpand]
  /// [diffYieldingWhere], [diffExpandWhere]
  ///
  Iterable<S> diffYielding<E, S>(
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

  Iterable<S> diffExpand<E, S>(
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

  Iterable<S> diffYieldingWhere<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
    Translator<I, S> overflow,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext() && test(current, another.current)) {
        yield mixer(current, another.current);
      }
    }
    while (moveNext()) {
      if (testOverflow(current)) yield overflow(current);
    }
  }

  Iterable<S> diffExpandWhere<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> mixer,
    Translator<I, Iterable<S>> overflow,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext() && test(current, another.current)) {
        yield* mixer(current, another.current);
      }
    }
    while (moveNext()) {
      if (testOverflow(current)) yield* overflow(current);
    }
  }

  ///
  /// [diffYieldingIndexable]
  /// [diffExpandIndexable]
  ///
  Iterable<S> diffYieldingIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> mixer,
    TranslatorGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYielding(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffExpandIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> mixer,
    TranslatorGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffExpand(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  ///
  /// [diffYieldingEntry]
  /// [diffExpandEntries]
  ///
  Iterable<MapEntry<I, V>> diffYieldingEntry<V>(
    Iterator<V> values,
    Translator<I, MapEntry<I, V>> overflow,
    int start,
  ) =>
      diffYielding(values, (p, q) => MapEntry(p, q), overflow);

  Iterable<MapEntry<I, V>> diffExpandEntries<V>(
    Iterator<V> values,
    Mixer<I, V, Iterable<MapEntry<I, V>>> mixer,
    Translator<I, Iterable<MapEntry<I, V>>> overflow,
    int start,
  ) =>
      diffExpand(values, mixer, overflow);

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

  ///
  /// cumulative
  /// [cumulativeWhere]
  /// [cumulativeBy]
  /// [cumulativeNested]
  ///
  int cumulativeWhere(Predicator<I> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current)) val++;
    }
    return val;
  }

  int cumulativeBy<T>(T value, PredicatorMixer<I, T> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current, value)) val++;
    }
    return val;
  }

  int cumulativeNested<T>() => reduceTo<int>(
        (element) => switch (element) {
          T() => 1,
          Iterable<T>() => element.length,
          Iterable<Iterable>() => element.iterator.cumulativeNested(),
          _ => throw _errorElementNotNest<I, T>(element),
        },
        FReducer.intAdd,
      );
}

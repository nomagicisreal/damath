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
/// [any], ...
/// [fold], ...
/// [reduce], ...
/// [yielding], ...
/// [expand], ...
///
/// [inter], ...
/// [diff], ...
///
/// [interval], ...
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
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
  /// [containsThen]
  ///
  /// [any], [every]
  /// [till1ToN], [tillNToN]
  /// [till1ToNBy], [tillNToNBy]
  /// [till1ToNByFirst]
  ///
  /// [anyEqual], [anyDifferent], [anyDifferentBy]
  /// [anyDifferentByGroups], [anyEqualByGroups]
  /// [anyDifferentByGroupsBool], [anyEqualByGroupsBool]
  ///

  ///
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
  /// [containsThen]
  ///
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

  T containsThen<T>(I value, Supplier<T> ifContains, Supplier<T> ifAbsent) =>
      contains(value) ? ifContains() : ifAbsent();

  ///
  /// [any]
  ///
  bool any(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return true;
    }
    return false;
  }

  ///
  /// [till1ToN], [tillNToN]
  /// [till1ToNBy], [tillNToNBy]
  ///
  bool till1ToN(PredicatorCombiner<I> test) => moveNextThen(() {
        var val = current;
        while (moveNext()) {
          if (test(val, current)) return true;
          val = current;
        }
        return false;
      });

  bool tillNToN(PredicatorCombiner<I> test) => moveNextThen(() {
        final list = <I>[current];
        while (moveNext()) {
          if (list.any((val) => test(val, current))) return true;
          list.add(current);
        }
        return false;
      });

  bool till1ToNBy<T>(
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

  bool tillNToNBy<T>(
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

  ///
  /// [till1ToNByFirst]
  /// [tillNToNByGroupSet]
  /// [tillNToNByGroup]
  ///
  bool till1ToNByFirst<T>(
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

  bool tillNToNByGroupSet<K, V>(
    Translator<I, K> toKey,
    Translator<I, V> toVal,
    PredicatorFusionor<Map<K, Set<V>>, K, V> fusion,
  ) =>
      moveNextThen(() {
        final map = <K, Set<V>>{
          toKey(current): {toVal(current)}
        };
        while (moveNext()) {
          if (fusion(map, toKey(current), toVal(current))) return true;
        }
        return false;
      });

  bool tillNToNByGroup<K, V>(
    Translator<I, K> toKey,
    Translator<I, V> toVal,
    PredicatorFusionor<Map<K, V>, K, V> fusion,
  ) =>
      moveNextThen(() {
        final map = <K, V>{toKey(current): toVal(current)};
        while (moveNext()) {
          if (fusion(map, toKey(current), toVal(current))) return true;
        }
        return false;
      });

  ///
  /// [anyDifferent], [anyEqual]
  /// [anyDifferentBy], [anyEqualBy]
  ///
  /// Instead of [IteratorExtension.tillNToN],
  /// the reason why [anyDifferent], [anyDifferentBy] invoke [IteratorExtension.till1ToN]
  /// is that when each elements passed by a [anyDifferent] call and not return true,
  /// it indicates that the previous element is equal to current element.
  /// it's redundant to check if the next element is equal to both of current element and previous element.
  ///
  bool get anyDifferent => till1ToN(FPredicatorCombiner.isNotEqual);

  bool get anyEqual => tillNToN(FPredicatorCombiner.isEqual);

  bool anyDifferentBy<T>(Translator<I, T> toId) =>
      till1ToNBy(toId, FPredicatorCombiner.isNotEqual);

  bool anyEqualBy<T>(Translator<I, T> toId) =>
      tillNToNBy(toId, FPredicatorCombiner.isEqual);

  ///
  /// [anyDifferentByGroups], [anyEqualByGroups]
  /// [anyDifferentByGroupsBool], [anyEqualByGroupsBool]
  ///
  /// sample 1:
  ///   ```
  ///   final list = <MapEntry<int, int>>[
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 30),
  ///       MapEntry(2, 0),
  ///   ];
  ///   print(list.iterator.anyEqualByGroups(
  ///     (value) => value.key,
  ///     (value) => value.value,
  ///   )); // true
  ///   ```
  ///   in the sample above, there are two group: group 1, group 2.
  ///   the reason why [anyEqualByGroups] returns true is that
  ///   group 1 elements--- {list[0].value, list[1].value, list[2].value}
  ///   has same value--- list[0].value == list[1].value.
  ///
  /// sample 2:
  ///   ```
  ///   final list = <MapEntry<int, int>>[
  ///       MapEntry(1, 20),
  ///       MapEntry(1, 30),
  ///       MapEntry(2, 30),
  ///       MapEntry(3, 20),
  ///   ];
  ///   print(list.iterator.anyEqualByGroups(
  ///     (value) => value.key,
  ///     (value) => value.value,
  ///   )); // false
  ///   ```
  ///   in the sample above, there are three group: group 1, group 2, group 3.
  ///   the reason why [anyEqualByGroups] returns false is that
  ///   each of the groups is identical on value
  ///
  /// the concept of [anyDifferentByGroups], [anyDifferentByGroupsBool], [anyEqualByGroupsBool]
  /// are similar to [anyEqualByGroups].
  ///

  ///
  bool anyDifferentByGroups<K, T>(
    Translator<I, K> toKey,
    Translator<I, T> toId,
  ) =>
      tillNToNByGroupSet<K, T>(
        toKey,
        toId,
        FPredicatorFusionor.mapValueSetUpdateYet,
      );

  bool anyEqualByGroups<K, T>(Translator<I, K> toKey, Translator<I, T> toId) =>
      tillNToNByGroupSet<K, T>(
        toKey,
        toId,
        FPredicatorFusionor.mapValueSetUpdateExist,
      );

  bool anyDifferentByGroupsBool<K>(
    Translator<I, K> toKey,
    Translator<I, bool> toVal,
  ) =>
      tillNToNByGroup(
        toKey,
        toVal,
        FPredicatorFusionor.mapValueBoolUpdateYet,
      );

  bool anyEqualByGroupsBool<K>(
    Translator<I, K> toKey,
    Translator<I, bool> toVal,
  ) =>
      tillNToNByGroup(
        toKey,
        toVal,
        FPredicatorFusionor.mapValueBoolUpdateExist,
      );

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
  /// [reduceByIndex], [reduceAccompany]
  /// [reduceTo], [reduceToByIndex]
  /// [reduceToInitialized], [reduceToInitializedByIndex]
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
    Collector<S, I, R> companion,
    Collector<R, I, S> after,
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
  /// [reduceByIndex], [reduceAccompany]
  /// [reduceTo], [reduceToByIndex]
  /// [reduceToInitialized], [reduceToInitializedByIndex]
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
    Forcer<I, R> reducing,
    Absorber<R, I> after,
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

  ///
  T reduceTo<T>(Translator<I, T> toVal, Reducer<T> reducing) =>
      moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          val = reducing(val, toVal(current));
        }
        return val;
      });

  T reduceToByIndex<T>(
    Translator<I, T> toVal,
    ReducerGenerator<T> reducing, [
    int start = 0,
  ]) =>
      moveNextThen(() {
        var val = toVal(current);
        for (var i = start; moveNext(); i++) {
          val = reducing(val, toVal(current), i);
        }
        return val;
      });

  T reduceToInitialized<T>(Translator<I, T> init, Companion<T, I> reducing) =>
      moveNextThen(() {
        var val = init(current);
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  T reduceToInitializedByIndex<T>(
    Translator<I, T> init,
    CompanionGenerator<T, I> reducing, [
    int start = 0,
  ]) =>
      moveNextThen(() {
        var val = init(current);
        for (var i = start; moveNext(); i++) {
          val = reducing(val, current, i);
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
  /// [expandByIndex], [expandAccompany], [expandTo]
  /// [expandWhere], [expandWhereTo]
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

  Iterable<S> expandTo<S>(Translator<I, Iterable<S>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  Iterable<I> expandWhere(
    Predicator<I> test,
    Translator<I, Iterable<I>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  Iterable<S> expandWhereTo<S>(
    Predicator<I> test,
    Translator<I, Iterable<S>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  ///
  /// intersection
  /// [inter], [interIndexable]
  /// [interAny], [interAnyTernary]
  ///
  /// [interYielding], [interExpand]
  /// [interYieldingWhere], [interExpandWhere]
  /// [interYieldingIndexable], [interExpandIndexable]
  /// [interYieldingIndexableWhere], [interExpandIndexableWhere]
  /// [interYieldingEntry], [interExpandEntries]
  ///
  /// [interFold], [interFoldIndexable]
  /// [interReduceTo], [interReduceToIndexable]
  /// [interReduceToInitialized], [interReduceToInitializedIndexable]
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
  /// [interYielding]
  /// [interExpand]
  ///
  Iterable<S> interYielding<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield mixer(current, another.current);
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

  ///
  /// [interYieldingWhere]
  /// [interExpandWhere]
  ///
  Iterable<S> interYieldingWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Mixer<I, E, S> mixer,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) {
        yield mixer(current, another.current);
      }
    }
  }

  Iterable<S> interExpandWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) {
        yield* expanding(current, another.current);
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
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield combine(current, another.current, i);
    }
  }

  Iterable<S> interExpandIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> combine,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield* combine(current, another.current, i);
    }
  }

  ///
  /// [interYieldingIndexableWhere]
  /// [interExpandIndexableWhere]
  ///
  Iterable<S> interYieldingIndexableWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, S> mixer,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      if (test(current, another.current)) {
        yield mixer(current, another.current, i);
      }
    }
  }

  Iterable<S> interExpandIndexableWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, Iterable<S>> expanding,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      if (test(current, another.current)) {
        yield* expanding(current, another.current, i);
      }
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
    Collector<S, I, E> mutual,
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
    CollectorGenerator<S, I, E> mutual,
    int start,
  ) {
    var val = initialValue;
    for (var i = start; moveNext() && another.moveNext(); i++) {
      val = mutual(val, current, another.current, i);
    }
    return val;
  }

  ///
  /// [interReduceTo], [interReduceToIndexable]
  /// [interReduceToInitialized], [interReduceToInitializedIndexable]
  /// [interReduce], [interReduceIndexable]
  ///
  S interReduceTo<E, S>(
    Iterator<E> another,
    Translator<I, S> toVal,
    Translator<E, S> toValAnother,
    Reducer<S> init,
    Collapser<S> mutual,
  ) =>
      moveNextThenWith(another, () {
        var val = init(toVal(current), toValAnother(another.current));
        while (moveNext() && another.moveNext()) {
          val = mutual(val, toVal(current), toValAnother(another.current));
        }
        return val;
      });

  S interReduceToIndexable<E, S>(
    Iterator<E> another,
    Translator<I, S> toVal,
    Translator<E, S> toValAnother,
    Reducer<S> init,
    CollapserGenerator<S> mutual,
    int start,
  ) =>
      moveNextThenWith(another, () {
        var val = init(toVal(current), toValAnother(another.current));
        for (var i = start + 1; moveNext() && another.moveNext(); i++) {
          val = mutual(val, toVal(current), toValAnother(another.current), i);
        }
        return val;
      });

  S interReduceToInitialized<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
  ) =>
      moveNextThenWith(another, () {
        var val = init(current, another.current);
        while (moveNext() && another.moveNext()) {
          val = mutual(val, current, another.current);
        }
        return val;
      });

  S interReduceToInitializedIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> init,
    CollectorGenerator<S, I, E> mutual,
    int start,
  ) =>
      moveNextThenWith(another, () {
        var val = init(current, another.current, start);
        for (var i = start + 1; moveNext() && another.moveNext(); i++) {
          val = mutual(val, current, another.current, i);
        }
        return val;
      });

  I interReduce(Iterator<I> another, Reducer<I> init, Collapser<I> mutual) =>
      interReduceToInitialized(another, init, mutual);

  I interReduceIndexable(
    Iterator<I> another,
    ReducerGenerator<I> init,
    CollapserGenerator<I> mutual,
    int start,
  ) =>
      interReduceToInitializedIndexable(another, init, mutual, start);

  ///
  /// difference
  /// [diff], [diffIndexable]
  ///
  /// [diffYielding], [diffExpand]
  /// [diffYieldingWhere], [diffExpandWhere]
  /// [diffYieldingIndexable], [diffExpandIndexable]
  /// [diffYieldingIndexableWhere], [diffExpandIndexableWhere]
  /// [diffYieldingEntry], [diffExpandEntries]
  ///
  /// [diffFold], [diffFoldIndexable]
  /// [diffReduceToInitialized], [diffReduceToInitializedIndexable]
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
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, S> mixer,
    Translator<I, S> overflow,
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
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, Iterable<S>> mixer,
    Translator<I, Iterable<S>> overflow,
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
  /// [diffYieldingIndexableWhere]
  /// [diffExpandIndexableWhere]
  ///
  Iterable<S> diffYieldingIndexableWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    MixerGenerator<I, E, S> mixer,
    TranslatorGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYieldingWhere(
      another,
      test,
      testOverflow,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffExpandIndexableWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    MixerGenerator<I, E, Iterable<S>> mixer,
    TranslatorGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffExpandWhere(
      another,
      test,
      testOverflow,
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
    Collector<S, I, E> companion,
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
    CollectorGenerator<S, I, E> companion,
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
  /// [diffReduceToInitialized], [diffReduceToInitializedIndexable]
  /// [diffReduce], [diffReduceIndexable]
  ///
  S diffReduceToInitialized<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      moveNextThenWith(another, () {
        var val = init(current, another.current);
        while (another.moveNext()) {
          if (moveNext()) val = mutual(val, current, another.current);
        }
        while (moveNext()) {
          val = overflow(val, current);
        }
        return val;
      });

  S diffReduceToInitializedIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> init,
    CollectorGenerator<S, I, E> mutual,
    CompanionGenerator<S, I> overflow,
    int start,
  ) =>
      moveNextThenWith(another, () {
        var i = start - 1;
        var val = init(current, another.current, ++i);
        while (another.moveNext()) {
          if (moveNext()) val = mutual(val, current, another.current, ++i);
        }
        while (moveNext()) {
          val = overflow(val, current, ++i);
        }
        return val;
      });

  I diffReduce(
    Iterator<I> another,
    Reducer<I> init,
    Collapser<I> mutual,
    Reducer<I> overflow,
  ) =>
      diffReduceToInitialized(another, init, mutual, overflow);

  I diffReduceIndexable(
    Iterator<I> another,
    ReducerGenerator<I> init,
    CollapserGenerator<I> mutual,
    ReducerGenerator<I> overflow,
    int start,
  ) =>
      diffReduceToInitializedIndexable(another, init, mutual, overflow, start);

  ///
  /// interval
  /// [interval]
  /// [intervalBy]
  ///
  ///

  ///
  /// [interval]
  /// [intervalBy]
  ///
  Iterable<I> interval(Reducer<I> reducing) => moveNextThen(() sync* {
        var previous = current;
        while (moveNext()) {
          yield reducing(previous, current);
          previous = current;
        }
      });

  ///
  /// [intervalBy] for example:
  ///   final node = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  ///   final interval = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  ///   print(node.iterator.[intervalBy]
  ///   (
  ///     interval,
  ///     (v1, v2, other) => (v1 + v2) / 2 + other,
  ///   ));
  ///   // (16.0, 27.0, 38.0, 49.0, 60.0, 71.0, 82.0, 93.0, 104.0)
  ///
  Iterable<S> intervalBy<T, S>(Iterator<T> interval, Linker<I, T, S> link) =>
      moveNextThen(
        () sync* {
          var previous = current;
          while (moveNext() && interval.moveNext()) {
            yield link(previous, current, interval.current);
            previous = current;
          }
        },
      );

  ///
  /// lead then
  /// [leadThen]
  /// [leadThenInterFold], [leadThenDiffFold]
  ///

  ///
  /// [leadThen]
  ///
  S leadThen<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw UnsupportedError('invalid lead ahead: $ahead');
    }
    return supply();
  }

  ///
  /// [leadThenInterFold]
  /// [leadThenDiffFold]
  ///
  S leadThenInterFold<E, S>(
    int ahead,
    Translator<I, S> init,
    Iterator<E> another,
    Collector<S, I, E> mutual,
  ) =>
      leadThen(ahead, () => interFold(init(current), another, mutual));

  S leadThenDiffFold<E, S>(
    int ahead,
    Translator<I, S> init,
    Iterator<E> another,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      leadThen(
        ahead,
        () => diffFold(init(current), another, mutual, overflow),
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

///
///
/// double
///
///
///
/// [sum], ...
///
extension IteratorDoubleExtension on Iterator<double> {
  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);

  double get norm => math.sqrt(sumSquared);

  ///
  ///
  ///
  double get mean {
    var total = 0.0;
    var length = 0;
    while (moveNext()) {
      total += current;
      length++;
    }
    return total / length;
  }
}

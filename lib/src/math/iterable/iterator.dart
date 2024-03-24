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
/// [leadThen], ...
///
/// [any], ...
/// [fold], ...
/// [reduce], ...
/// [yielding], ...
/// [expand], ...
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
  /// [leadThen]
  ///
  S leadThen<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw _errorNoElement();
    }
    return supply();
  }

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
    Mapper<I, T> toVal,
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
    Mapper<I, T> toVal,
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
    Mapper<I, T> toVal,
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
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
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
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
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

  bool anyDifferentBy<T>(Mapper<I, T> toId) =>
      till1ToNBy(toId, FPredicatorCombiner.isNotEqual);

  bool anyEqualBy<T>(Mapper<I, T> toId) =>
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
    Mapper<I, K> toKey,
    Mapper<I, T> toId,
  ) =>
      tillNToNByGroupSet<K, T>(
        toKey,
        toId,
        FPredicatorFusionor.mapValueSetUpdateYet,
      );

  bool anyEqualByGroups<K, T>(Mapper<I, K> toKey, Mapper<I, T> toId) =>
      tillNToNByGroupSet<K, T>(
        toKey,
        toId,
        FPredicatorFusionor.mapValueSetUpdateExist,
      );

  bool anyDifferentByGroupsBool<K>(
    Mapper<I, K> toKey,
    Mapper<I, bool> toVal,
  ) =>
      tillNToNByGroup(
        toKey,
        toVal,
        FPredicatorFusionor.mapValueBoolUpdateYet,
      );

  bool anyEqualByGroupsBool<K>(
    Mapper<I, K> toKey,
    Mapper<I, bool> toVal,
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
  T firstWhereMap<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    throw _errorElementNotFound();
  }

  T? firstWhereMapOrNull<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return null;
  }

  T firstWhereMapOrElse<T>(
    Predicator<I> test,
    Mapper<I, T> toVal,
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
  /// [yieldingToByIndex], [yieldingAccompany], [yieldingTo]
  /// [yieldingWhere], [yieldingToWhere]
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
  T reduceTo<T>(Mapper<I, T> toVal, Reducer<T> reducing) => moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          val = reducing(val, toVal(current));
        }
        return val;
      });

  T reduceToByIndex<T>(
    Mapper<I, T> toVal,
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

  T reduceToInitialized<T>(Mapper<I, T> init, Companion<T, I> reducing) =>
      moveNextThen(() {
        var val = init(current);
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  T reduceToInitializedByIndex<T>(
    Mapper<I, T> init,
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
  /// [yieldingApply], [yieldingAccompany], [yieldingWhere]
  /// [yieldingTo], ...
  ///
  Iterable<I> yielding() sync* {
    while (moveNext()) {
      yield current;
    }
  }

  Iterable<I> yieldingApply(Applier<I> apply) sync* {
    while (moveNext()) {
      yield apply(current);
    }
  }

  Iterable<I> yieldingAccompany<T>(T value, Companion<I, T> toVal) sync* {
    while (moveNext()) {
      yield toVal(current, value);
    }
  }

  Iterable<I> yieldingWhere(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  ///
  /// [yieldingTo], [yieldingToByIndex], [yieldingToWhere]
  /// [yieldingToEntries], [yieldingToEntriesByKey], [yieldingToEntriesByValue]
  /// [yieldingToList], [yieldingToListByIndex], [yieldingToListByList], [yieldingToListByMap]
  /// [yieldingToSet], [yieldingToSetBySet]
  ///
  Iterable<S> yieldingTo<S>(Mapper<I, S> toVal) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<S> yieldingToByIndex<S>(
    TranslatorGenerator<I, S> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) {
      yield toVal(current, i);
    }
  }

  Iterable<S> yieldingToWhere<S>(
    Predicator<I> test,
    Mapper<I, S> toVal,
  ) sync* {
    while (moveNext()) {
      if (test(current)) yield toVal(current);
    }
  }

  ///
  ///
  Iterable<MapEntry<K, V>> yieldingToEntries<K, V>(
    Mapper<I, MapEntry<K, V>> toVal,
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
  List<T> yieldingToList<T>(Mapper<I, T> toVal) =>
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
  Set<K> yieldingToSet<K>(Mapper<I, K> toVal) =>
      {for (; moveNext();) toVal(current)};

  Set<K> yieldingToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) =>
      {for (; moveNext();) mixer(current, set)};

  ///
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandWhere]
  /// [expandTo], ...
  ///
  Iterable<I> expand(Mapper<I, Iterable<I>> expanding) sync* {
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

  Iterable<I> expandWhere(
    Predicator<I> test,
    Mapper<I, Iterable<I>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  /// [expandTo]
  /// [expandWhereTo]
  ///
  Iterable<S> expandTo<S>(Mapper<I, Iterable<S>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  Iterable<S> expandWhereTo<S>(
    Predicator<I> test,
    Mapper<I, Iterable<S>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

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

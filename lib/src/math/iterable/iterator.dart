///
///
/// this file contains:
///
/// [IteratorExtension]
/// [IteratorNullableExtension]
///
///
part of damath_math;

///
/// [_errorNoElement], ...
///
/// [actionWhere], ...
/// [moveNextThen], ...
///
/// [contains], ...
/// [any], ...
/// [exist], ...
///
/// [fold], ...
/// [reduce], ...
///
/// [yieldingApply], ...
/// [where], ...
/// [map], ...
/// [expand], ...
/// [emit], ...
///
/// [cumulativeWhere], ...
/// [frequencies], ...
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
  /// [leadThen]
  ///
  S moveNextThen<S>(Supplier<S> supply) =>
      moveNext() ? supply() : throw _errorNoElement();

  S moveNextThenWith<E, S>(Iterator<E> another, Supplier<S> supply) =>
      moveNext() && another.moveNext() ? supply() : throw _errorNoElement();

  S leadThen<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw _errorNoElement();
    }
    return supply();
  }

  ///
  ///
  ///
  /// predication
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
  ///
  /// [any]
  ///
  /// [exist], [existBy], [existByFirst]
  /// [existAny], [existAnyBy], [existAnyForEachGroup], [existAnyForEachGroupSet]
  /// [existDifferent], [existDifferentBy], [existEqual],  [existEqualBy]
  ///
  ///
  ///

  ///
  /// [contains], [containsAll]
  /// [notContains], [notContainsAll]
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
  /// [exist]
  /// [existBy]
  /// [existByFirst]
  ///
  bool exist(PredicatorCombiner<I> test) => moveNextThen(() {
        var val = current;
        while (moveNext()) {
          if (test(val, current)) return true;
          val = current;
        }
        return false;
      });

  bool existBy<T>(
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

  bool existByFirst<T>(Mapper<I, T> toVal, PredicatorCombiner<T> test) =>
      moveNextThen(() {
        var val = toVal(current);
        while (moveNext()) {
          if (test(val, toVal(current))) return true;
        }
        return false;
      });

  ///
  /// [existAny]
  /// [existAnyBy]
  /// [existAnyForEachGroup]
  /// [existAnyForEachGroupSet]
  ///
  bool existAny(PredicatorCombiner<I> test) => moveNextThen(() {
        final list = <I>[current];
        while (moveNext()) {
          if (list.any((val) => test(val, current))) return true;
          list.add(current);
        }
        return false;
      });

  bool existAnyBy<T>(
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

  bool existAnyForEachGroup<K, V>(
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

  bool existAnyForEachGroupSet<K, V>(
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

  ///
  /// [existDifferent],
  /// [existDifferentBy]
  /// [existEqual]
  /// [existEqualBy]
  ///
  bool get existDifferent => exist(FPredicatorCombiner.isNotEqual);

  bool existDifferentBy<T>(Mapper<I, T> toId) =>
      existBy(toId, FPredicatorCombiner.isNotEqual);

  bool get existEqual => existAny(FPredicatorCombiner.isEqual);

  bool existEqualBy<T>(Mapper<I, T> toId) =>
      existAnyBy(toId, FPredicatorCombiner.isEqual);

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
  /// [foldByIndex], [foldNested],
  /// [foldAccompanyBefore], [foldAccompanyAfter],
  ///
  /// reduce
  /// [reduce]
  /// [reduceByIndex], [reduceAccompany]
  /// [reduceTo], [reduceToByIndex]
  /// [reduceToInitialized], [reduceToInitializedByIndex]
  ///
  /// yielding
  /// [mapByIndex], [yieldingAccompany], [map]
  /// [where], [mapWhere]
  /// [mapToEntries], [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToList], [mapToListByIndex], [mapToListBySet], [mapToListByMap]
  /// [mapToSet], [mapToSetBySet]
  ///
  /// expand
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandTo]
  ///

  ///
  /// [fold]
  /// [foldByIndex]
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
  /// [foldAccompanyBefore]
  /// [foldAccompanyAfter]
  ///
  S foldAccompanyBefore<R, S>(
    S initialValue,
    R initialElement,
    Companion<R, I> before,
    Collector<S, I, R> companion,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (moveNext()) {
      ele = before(ele, current);
      val = companion(val, current, ele);
    }
    return val;
  }

  S foldAccompanyAfter<R, S>(
    S initialValue,
    R initialElement,
    Collector<S, I, R> companion,
    Companion<R, I> after,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (moveNext()) {
      val = companion(val, current, ele);
      ele = after(ele, current);
    }
    return val;
  }

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
  /// [yieldingApply]
  /// [yieldingAccompany]
  ///
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

  ///
  /// [where]
  /// [whereUntil], [headUntil], [tailFrom]
  ///
  Iterable<I> where(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  Iterable<I> whereUntil(Predicator<I> test, Predicator<I> until) sync* {
    while (moveNext()) {
      if (until(current)) break;
      if (test(current)) yield current;
    }
  }

  Iterable<I> headUntil(Predicator<I> until) sync* {
    while (moveNext()) {
      if (until(current)) break;
      yield current;
    }
  }

  Iterable<I> tailFrom(Predicator<I> from) sync* {
    while (moveNext()) {
      if (from(current)) break;
    }
    while (moveNext()) {
      yield current;
    }
  }

  ///
  /// [map], [mapByIndex], [mapWhere]
  /// [mapToEntries], [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToList], [mapToListByIndex], [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToSet], [mapToSetBySet]
  ///
  Iterable<S> map<S>(Mapper<I, S> toVal) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<S> mapByIndex<S>(
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) {
      yield toVal(current, i);
    }
  }

  Iterable<S> mapWhere<S>(
    Predicator<I> test,
    Mapper<I, S> toVal,
  ) sync* {
    while (moveNext()) {
      if (test(current)) yield toVal(current);
    }
  }

  ///
  ///
  Iterable<MapEntry<K, V>> mapToEntries<K, V>(
    Mapper<I, MapEntry<K, V>> toVal,
  ) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<MapEntry<K, I>> mapToEntriesByKey<K>(K key) sync* {
    while (moveNext()) {
      yield MapEntry(key, current);
    }
  }

  Iterable<MapEntry<I, V>> mapToEntriesByValue<V>(V value) sync* {
    while (moveNext()) {
      yield MapEntry(current, value);
    }
  }

  ///
  ///
  List<T> mapToList<T>(Mapper<I, T> toVal) =>
      [for (; moveNext();) toVal(current)];

  List<S> mapToListByIndex<S>(
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) =>
      [for (var i = start; moveNext(); i++) toVal(current, i)];

  List<T> mapToListByList<T, R>(
    List<R> list,
    Mixer<I, List<R>, T> mixer,
  ) =>
      [for (; moveNext();) mixer(current, list)];

  List<T> mapToListBySet<T, R>(
    Set<R> set,
    Mixer<I, Set<R>, T> mixer,
  ) =>
      [for (; moveNext();) mixer(current, set)];

  List<T> mapToListByMap<T, K, V>(
    Map<K, V> map,
    Mixer<I, Map<K, V>, T> mixer,
  ) =>
      [for (; moveNext();) mixer(current, map)];

  ///
  ///
  Set<K> mapToSet<K>(Mapper<I, K> toVal) =>
      {for (; moveNext();) toVal(current)};

  Set<K> mapToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) =>
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
    MapperGenerator<I, Iterable<I>> expanding, [
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
  /// [emit]
  /// [emitFrom], [emitTo]
  ///
  Iterable<I> emit(
    Predicator<I> startWhen,
    Predicator<I> endWhen, [
    bool includeEnd = true,
  ]) sync* {
    while (moveNext()) {
      if (startWhen(current)) break;
    }
    while (moveNext()) {
      if (!endWhen(current)) {
        if (includeEnd) yield current;
        break;
      }
      yield current;
    }
  }

  Iterable<I> emitFrom(
    int start,
    Predicator<I> endWhen, [
    bool includeEnd = true,
  ]) sync* {
    for (var i = 0; i < start; i++) {
      moveNext();
    }
    while (moveNext()) {
      if (!endWhen(current)) {
        if (includeEnd) yield current;
        break;
      }
      yield current;
    }
  }

  Iterable<I> emitTo(
    Predicator<I> startWhen,
    int end, [
    bool includeEnd = true,
  ]) sync* {
    var i = 0;
    while (moveNext()) {
      i++;
      if (startWhen(current)) break;
    }
    while (moveNext()) {
      if (i == end) {
        if (includeEnd) yield current;
        break;
      }
      yield current;
      i++;
    }
  }

  ///
  /// cumulative
  /// [cumulativeWhere], [cumulativeWhereBy]
  /// [cumulativeNested]
  /// [cumulativeGroups]
  ///
  int cumulativeWhere(Predicator<I> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current)) val++;
    }
    return val;
  }

  int cumulativeWhereBy<T>(T value, PredicatorMixer<I, T> test) {
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

  Map<I, int> get cumulativeGroups => fold(
        {},
        (map, current) => map..update(current, (c) => ++c, ifAbsent: () => 1),
      );

  ///
  /// [frequencies]
  ///
  Map<I, double> get frequencies {
    final map = <I, double>{};
    var length = 0;
    while (moveNext()) {
      map.update(current, (c) => ++c, ifAbsent: () => 1);
      length++;
    }
    return map..updateAll((key, value) => value / length);
  }
}

///
///
/// [validFrequencies]
///
///
extension IteratorNullableExtension<I> on Iterator<I?> {
  ///
  /// [validFrequencies]
  ///
  Map<I, double> validFrequencies([bool lengthValid = true]) {
    final map = <I, double>{};
    var length = 0;

    final Consumer<I?> consume = lengthValid
        ? (current) => current.consumeNotNull((key) {
              map.plusOn(key);
              length++;
            })
        : (current) {
            current.consumeNotNull(map.plusOn);
            length++;
          };

    while (moveNext()) {
      consume(current);
    }
    return map..updateAll((key, value) => value / length);
  }
}

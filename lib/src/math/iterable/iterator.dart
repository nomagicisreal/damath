part of damath_math;

///
/// [_errorNoElement], ...
///
/// [whereConsume], ...
/// [moveNextThen], ...
///
/// [contains], ...
/// [any], ...
/// [exist], ...
///
/// [cumulate], ...
///
/// [find], ...
/// [take], ...
/// [where], ...
/// [expand], ...
/// [map], ...
///
/// [fold], ...
/// [reduce], ...
///
/// [toMap], ...
///
///
extension IteratorExtension<I> on Iterator<I> {
  static StateError _errorNoElement() => StateError('no element');

  static StateError _errorElementNotFound() => StateError('element not found');

  static StateError _errorOutOfBoundary(int index) =>
      StateError('out of boundary: $index');

  static StateError _errorElementNotNest<I, T>(I element) =>
      StateError('$element not nested element of $T');

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
  bool get existDifferent => exist(FPredicatorCombiner.isDifferent);

  bool existDifferentBy<T>(Mapper<I, T> toId) =>
      existBy(toId, FPredicatorCombiner.isDifferent);

  bool get existEqual => existAny(FPredicatorCombiner.isEqual);

  bool existEqualBy<T>(Mapper<I, T> toId) =>
      existAnyBy(toId, FPredicatorCombiner.isEqual);

  ///
  ///
  ///
  /// find / [Iterable.firstWhere]
  /// [find], [findConsume]
  /// [findOrNull], [findOrElse]
  /// [findMap], [findMapOrNull], [findMapOrElse]
  /// [findIndex], [findCheck]
  ///
  ///
  /// take / [Iterable.take]
  /// [take], [takeWhile]
  /// [takeAllApply], [takeAllAccompany],
  /// [takeUntil], [takeFrom], [takeBetween]
  ///
  ///
  /// where / [Iterable.where]
  /// [where], [whereConsume]
  /// [whereUntil], [whereFrom], [whereBetween]
  /// [whereIndex]
  /// [whereIndexUntil], [whereIndexFrom], [whereIndexBetween]
  /// [whereCheck]
  /// [whereCheckUntil], [whereCheckFrom], [whereCheckBetween]
  ///
  ///
  ///

  ///
  /// find
  /// [find], [findConsume]
  /// [findOrNull], [findOrElse]
  /// [findMap], [findMapOrNull], [findMapOrElse]
  /// [findIndex], [findCheck]
  ///

  ///
  /// [find]
  /// [findConsume]
  ///
  I find(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    throw _errorElementNotFound();
  }

  void findConsume(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) return action(current);
    }
  }

  ///
  /// [findOrNull]
  /// [findOrElse]
  ///
  I? findOrNull(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return null;
  }

  I findOrElse(Predicator<I> test, Supplier<I> orElse) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return orElse();
  }

  ///
  /// [findMap]
  /// [findMapOrNull]
  /// [findMapOrElse]
  ///
  T findMap<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    throw _errorElementNotFound();
  }

  T? findMapOrNull<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return null;
  }

  T findMapOrElse<T>(
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
  /// [findIndex]
  /// [findCheck]
  ///
  int findIndex(Predicator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current)) return i;
      i++;
    }
    throw _errorElementNotFound();
  }

  int findCheck(PredicatorGenerator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current, i)) return i;
      i++;
    }
    throw _errorElementNotFound();
  }

  ///
  /// take
  /// [take], [takeWhile]
  /// [takeAllApply], [takeAllAccompany],
  /// [takeUntil], [takeFrom], [takeBetween]
  ///

  ///
  /// [take]
  /// [takeWhile]
  ///
  Iterable<I> take(int count) sync* {
    var i = 0;
    for (; moveNext() && i < count; i++) {
      yield current;
    }
    if (count > i) throw _errorOutOfBoundary(count);
  }

  Iterable<I> takeWhile(Predicator<I> test) sync* {
    while (moveNext()) {
      if (!test(current)) break;
      yield current;
    }
  }

  ///
  /// [takeAllApply]
  /// [takeAllAccompany]
  ///
  Iterable<I> takeAllApply(Applier<I> apply) sync* {
    while (moveNext()) {
      yield apply(current);
    }
  }

  Iterable<I> takeAllAccompany<T>(T value, Companion<I, T> toVal) sync* {
    while (moveNext()) {
      yield toVal(current, value);
    }
  }

  ///
  /// [takeUntil], [takeFrom]
  /// [takeBetween]
  ///
  Iterable<I> takeUntil(
    Predicator<I> testEnd, [
    bool includeEnd = false,
  ]) sync* {
    while (moveNext()) {
      if (testEnd(current)) {
        if (includeEnd) yield current;
        break;
      }
      yield current;
    }
  }

  Iterable<I> takeFrom(
    Predicator<I> testStart, [
    bool includeStart = true,
  ]) sync* {
    while (moveNext()) {
      if (testStart(current)) {
        if (includeStart) yield current;
        break;
      }
    }
    while (moveNext()) {
      yield current;
    }
  }

  Iterable<I> takeBetween(
    Predicator<I> testStart,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    while (moveNext()) {
      if (testStart(current)) {
        if (includeStart) yield current;
        break;
      }
    }
    while (moveNext()) {
      if (testEnd(current)) {
        if (includeEnd) yield current;
        break;
      }
      yield current;
    }
  }

  ///
  /// where
  /// [where], [whereConsume]
  /// [whereUntil], [whereFrom], [whereBetween]
  /// [whereIndex]
  /// [whereIndexUntil], [whereIndexFrom], [whereIndexBetween]
  /// [whereCheck]
  /// [whereCheckUntil], [whereCheckFrom], [whereCheckBetween]
  ///

  ///
  /// [where]
  /// [whereConsume]
  ///
  Iterable<I> where(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  void whereConsume(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) action(current);
    }
  }

  ///
  /// [whereUntil]
  /// [whereFrom]
  /// [whereBetween]
  ///
  Iterable<I> whereUntil(
    Predicator<I> test,
    Predicator<I> testEnd, [
    bool includeEnd = false,
  ]) sync* {
    while (moveNext()) {
      if (testEnd(current)) {
        if (includeEnd) yield current;
        break;
      }
      if (test(current)) yield current;
    }
  }

  Iterable<I> whereFrom(
    Predicator<I> testStart,
    Predicator<I> test, [
    bool includeStart = true,
  ]) sync* {
    while (moveNext()) {
      if (testStart(current)) {
        if (includeStart) yield current;
        break;
      }
    }
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  Iterable<I> whereBetween(
    Predicator<I> testStart,
    Predicator<I> test,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    while (moveNext()) {
      if (testStart(current)) {
        if (includeStart) yield current;
        break;
      }
    }
    while (moveNext()) {
      if (testEnd(current)) {
        if (includeEnd) yield current;
        break;
      }
      if (test(current)) yield current;
    }
  }

  ///
  /// [whereIndex]
  ///
  Iterable<int> whereIndex(Predicator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current)) yield i;
    }
  }

  ///
  /// [whereIndexUntil]
  /// [whereIndexFrom]
  /// [whereIndexBetween]
  ///
  Iterable<int> whereIndexUntil(
    Predicator<I> test,
    Predicator<I> testEnd, [
    bool includeEnd = false,
  ]) sync* {
    for (var i = 0; moveNext(); i++) {
      if (testEnd(current)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(current)) yield i;
    }
  }

  Iterable<int> whereIndexFrom(
    Predicator<I> testStart,
    Predicator<I> test, [
    bool includeStart = true,
  ]) sync* {
    var i = 0;
    for (; moveNext(); i++) {
      if (testStart(current)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; moveNext(); i++) {
      if (test(current)) yield i;
    }
  }

  Iterable<int> whereIndexBetween(
    Predicator<I> testStart,
    Predicator<I> test,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    var i = 0;
    for (; moveNext(); i++) {
      if (testStart(current)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; moveNext(); i++) {
      if (testEnd(current)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(current)) yield i;
    }
  }

  ///
  /// [whereCheck]
  ///
  Iterable<int> whereCheck(PredicatorGenerator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current, i)) yield i;
    }
  }

  ///
  /// [whereCheckUntil]
  /// [whereCheckFrom]
  /// [whereCheckBetween]
  ///
  Iterable<int> whereCheckUntil(
    PredicatorGenerator<I> test,
    PredicatorGenerator<I> testEnd, [
    bool includeEnd = false,
  ]) sync* {
    for (var i = 0; moveNext(); i++) {
      if (testEnd(current, i)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(current, i)) yield i;
    }
  }

  Iterable<int> whereCheckFrom(
    PredicatorGenerator<I> testStart,
    PredicatorGenerator<I> test, [
    bool includeStart = true,
  ]) sync* {
    var i = 0;
    for (; moveNext(); i++) {
      if (testStart(current, i)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; moveNext(); i++) {
      if (test(current, i)) yield i;
    }
  }

  Iterable<int> whereCheckBetween(
    PredicatorGenerator<I> testStart,
    PredicatorGenerator<I> test,
    PredicatorGenerator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    var i = 0;
    for (; moveNext(); i++) {
      if (testStart(current, i)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; moveNext(); i++) {
      if (testEnd(current, i)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(current, i)) yield i;
    }
  }

  ///
  /// expand
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandWhere]
  ///
  /// map
  /// [map], [mapByIndex]
  /// [mapToEntries], [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToList], [mapToListByIndex], [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToSet], [mapToSetBySet]
  /// [mapExpand], [mapWhere], [mapWhereExpand]
  ///
  ///

  ///
  /// expand
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandWhere]
  ///
  ///

  ///
  /// [expand]
  /// [expandByIndex], [expandAccompany], [expandWhere]
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
  /// map
  /// [map], [mapByIndex]
  /// [mapToEntries], [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToList], [mapToListByIndex], [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToSet], [mapToSetBySet]
  /// [mapExpand], [mapWhere], [mapWhereExpand]
  ///

  ///
  /// [map]
  /// [mapByIndex]
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

  ///
  /// [mapToEntries]
  /// [mapToEntriesByKey]
  /// [mapToEntriesByValue]
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
  /// [mapToList]
  /// [mapToListByIndex]
  /// [mapToListByList]
  /// [mapToListBySet]
  /// [mapToListByMap]
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
  /// [mapToSet]
  /// [mapToSetBySet]
  ///
  Set<K> mapToSet<K>(Mapper<I, K> toVal) =>
      {for (; moveNext();) toVal(current)};

  Set<K> mapToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) =>
      {for (; moveNext();) mixer(current, set)};

  ///
  /// [mapExpand]
  /// [mapWhere]
  /// [mapWhereExpand]
  ///
  Iterable<S> mapExpand<S>(Mapper<I, Iterable<S>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  Iterable<S> mapWhere<S>(Predicator<I> test, Mapper<I, S> toVal) sync* {
    while (moveNext()) {
      if (test(current)) yield toVal(current);
    }
  }

  Iterable<S> mapWhereExpand<S>(
    Predicator<I> test,
    Mapper<I, Iterable<S>> expanding,
  ) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  /// cumulative
  /// [cumulate]
  /// [cumulateBy]
  /// [cumulateLengthNested]
  ///

  ///
  /// [cumulate]
  /// [cumulateBy]
  /// [cumulateLengthNested]
  ///
  int cumulate(Predicator<I> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current)) val++;
    }
    return val;
  }

  int cumulateBy<T>(T value, PredicatorMixer<I, T> test) {
    var val = 0;
    while (moveNext()) {
      if (test(current, value)) val++;
    }
    return val;
  }

  int cumulateLengthNested<T>() => reduceTo<int>(
        (element) => switch (element) {
          T() => 1,
          Iterable<T>() => element.length,
          Iterable<Iterable>() => element.iterator.cumulateLengthNested(),
          _ => throw _errorElementNotNest<I, T>(element),
        },
        FReducer.intAdd,
      );

  ///
  ///
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
  ///
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
  /// to map
  /// [toMap]
  /// [toMapCounted]
  /// [toMapFrequencies]
  ///
  ///

  ///
  /// [toMap]
  /// [toMapCounted]
  /// [toMapFrequencies]
  ///
  Map<int, I> get toMap => foldByIndex(
        {},
        (map, value, i) => map..putIfAbsent(i, () => value),
      );

  Map<I, int> get toMapCounted => fold(
        {},
        (map, current) => map..update(current, (c) => ++c, ifAbsent: () => 1),
      );

  Map<I, double> get toMapFrequencies {
    final map = <I, double>{};
    var length = 0;
    while (moveNext()) {
      map.update(current, (c) => ++c, ifAbsent: () => 1);
      length++;
    }
    return map..updateAll((key, value) => value / length);
  }
}

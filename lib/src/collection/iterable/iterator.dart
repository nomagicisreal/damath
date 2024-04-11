part of damath_collection;

///
///
///
/// [hasNextConsume], ...
/// [moveNextConsume], ...
///
/// [contains], ...
/// [any], ...
/// [exist], ...
///
/// [cumulate], ...
///
/// [first], ...
/// [find], ...
///
/// [take], ...
/// [skip], ...
/// [where], ...
/// [expand], ...
/// [reduce], ...
///
///
///
///
extension IteratorExtension<I> on Iterator<I> {
  ///
  /// [hasNextConsume]
  ///
  void hasNextConsume(Consumer<Iterator<I>> consume) {
    if (moveNext()) consume(this);
  }

  ///
  /// [consumeAll]
  /// [consumeAllByIndex]
  ///
  void consumeAll(Consumer<I> consume) {
    while (moveNext()) {
      consume(current);
    }
  }

  void consumeAllByIndex(ConsumerIndexable<I> consume, [int start = 0]) {
    for (var i = start; moveNext(); i++) {
      consume(current, i);
    }
  }

  ///
  /// [accompany]
  /// [accompanyByIndex]
  ///
  void accompany(I value, Accompanier<I> consume) {
    while (moveNext()) {
      consume(current, value);
    }
  }

  void accompanyByIndex(I value, AccompanierIndexable<I> consume, [int start = 0]) {
    for (var i = start; moveNext(); i++) {
      consume(current, value, i);
    }
  }

  ///
  /// [moveNextConsume]
  /// [moveNextApply]
  ///
  void moveNextConsume(Consumer<I> consume) => moveNext()
      ? consume(current)
      : throw StateError(KErrorMessage.iteratorNoElement);

  I moveNextApply(Applier<I> apply) => moveNext()
      ? apply(current)
      : throw StateError(KErrorMessage.iteratorNoElement);

  ///
  /// [leadApply]
  ///
  I leadApply(int ahead, Applier<I> apply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(KErrorMessage.iteratorNoElement);
    }
    return apply(current);
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
  /// [anyBy]
  ///
  bool any(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return true;
    }
    return false;
  }

  bool anyBy<T>(T element, PredicatorMixer<T, I> test) {
    while (moveNext()) {
      if (test(element, current)) return true;
    }
    return false;
  }

  ///
  /// [exist]
  /// [existBy]
  /// [existByFirst]
  ///
  bool exist(PredicatorCombiner<I> test) => moveNextSupply(() {
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
      moveNextSupply(() {
        var val = toVal(current);
        while (moveNext()) {
          final v = toVal(current);
          if (test(val, v)) return true;
          val = v;
        }
        return false;
      });

  bool existByFirst<T>(Mapper<I, T> toVal, PredicatorCombiner<T> test) =>
      moveNextSupply(() {
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
  bool existAny(PredicatorCombiner<I> test) => moveNextSupply(() {
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
      moveNextSupply(() {
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
      moveNextSupply(() {
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
      moveNextSupply(() {
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
          _ => throw StateError(KErrorMessage.iteratorElementNotNest),
        },
        FReducer.intAdd,
      );

  ///
  ///
  /// [first], [last]
  ///
  /// find
  /// [find], [findConsume]
  /// [findOrNull], [findOrElse]
  /// [findMap], [findMapOrNull], [findMapOrElse]
  /// [findIndex], [findCheck]
  ///
  /// take
  /// [take], [takeUntil]
  /// [takeAllApply], [takeAllApplyBy],
  /// [takeUntil], [takeFrom], [takeBetween]
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

  ///
  /// [first], [last]
  ///
  I get first => moveNextSupply(() => current);

  I get last => moveNextApply((val) {
        while (moveNext()) {
          val = current;
        }
        return val;
      });

  ///
  /// find / [Iterable.firstWhere]
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
    throw StateError(KErrorMessage.iteratorElementNotFound);
  }

  void findConsume(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) return action(current);
    }
    throw StateError(KErrorMessage.iteratorElementNotFound);
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
    throw StateError(KErrorMessage.iteratorElementNotFound);
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
    throw StateError(KErrorMessage.iteratorElementNotFound);
  }

  int findCheck(PredicatorGenerator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current, i)) return i;
      i++;
    }
    throw StateError(KErrorMessage.iteratorElementNotFound);
  }

  ///
  /// take / [Iterable.take]
  /// [take], [takeAll]
  /// [takeAllApply], [takeAllApplyBy],
  /// [takeWhile], [takeExistWhile],
  /// [takeUntil], [takeExistUntil],
  /// [takeFrom],
  /// [takeBetween],
  /// [mapByIndexExistUntil],
  ///
  /// [takeList], [takeListAll]
  /// [takeListWhile], [takeListExistWhile],
  /// [takeListUntil], [takeListExistUntil],
  /// [mapToListByIndexUntil], [mapToListByIndexExistUntil]
  ///
  ///
  ///
  ///

  ///
  /// [take]
  /// [takeAll]
  ///
  Iterable<I> take(int count) sync* {
    var i = 0;
    for (; moveNext() && i < count; i++) {
      yield current;
    }
    if (count > i) throw RangeError(KErrorMessage.indexOutOfBoundary);
  }

  Iterable<I> get takeAll sync* {
    while (moveNext()) {
      yield current;
    }
  }

  ///
  /// [takeAllApply]
  /// [takeAllApplyBy]
  ///
  Iterable<I> takeAllApply(Applier<I> apply) sync* {
    while (moveNext()) {
      yield apply(current);
    }
  }

  Iterable<I> takeAllApplyBy<T>(T value, Companion<I, T> toVal) sync* {
    while (moveNext()) {
      yield toVal(current, value);
    }
  }

  ///
  /// [takeWhile]
  /// [takeExistWhile]
  ///
  Iterable<I> takeWhile(Predicator<I> test) sync* {
    while (moveNext()) {
      if (!test(current)) break;
      yield current;
    }
  }

  Iterable<I> takeExistWhile(PredicatorCombiner<I> test) =>
      moveNextSupply(() sync* {
        final val = current;
        yield val;
        while (moveNext()) {
          if (!test(val, current)) break;
          yield current;
        }
      });

  ///
  /// [takeUntil]
  /// [takeExistUntil]
  ///
  Iterable<I> takeUntil(
    Predicator<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) sync* {
    while (moveNext()) {
      if (testInvalid(current)) {
        if (includeFirstInvalid) yield current;
        break;
      }
      yield current;
    }
  }

  Iterable<I> takeExistUntil(
    PredicatorCombiner<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) =>
      moveNextSupply(() sync* {
        final val = current;
        yield val;
        while (moveNext()) {
          if (testInvalid(val, current)) {
            if (includeFirstInvalid) yield current;
            break;
          }
          yield current;
        }
      });

  ///
  /// [takeFrom]
  /// [takeBetween]
  ///
  Iterable<I> takeFrom(
    Predicator<I> testValid, [
    bool includeStart = true,
  ]) sync* {
    while (moveNext()) {
      if (testValid(current)) {
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
  /// [takeList]
  /// [takeListAll]
  ///
  List<I> takeList(int count) {
    final list = <I>[];
    var i = 0;
    for (; moveNext() && i < count; i++) {
      list.add(current);
    }
    if (count > i) throw RangeError(KErrorMessage.indexOutOfBoundary);
    return list;
  }

  List<I> get takeListAll {
    final list = <I>[];
    while (moveNext()) {
      list.add(current);
    }
    return list;
  }

  //
  List<I> get takeListRemain {
    final list = <I>[];
    try {
      do {
        list.add(current);
      } while (moveNext());
    } catch (e) {
      if (e.runtimeType.toString() != '_TypeError') rethrow; // no element
    }
    return list;
  }

  ///
  /// [takeListWhile]
  /// [takeListExistWhile]
  ///
  List<I> takeListWhile(Predicator<I> test) {
    final list = <I>[];
    while (moveNext()) {
      if (!test(current)) break;
      list.add(current);
    }
    return list;
  }

  List<I> takeListExistWhile(PredicatorCombiner<I> test) => moveNextSupply(() {
        final val = current;
        final list = [val];
        while (moveNext()) {
          if (!test(val, current)) break;
          list.add(current);
        }
        return list;
      });

  ///
  /// [takeListUntil]
  /// [takeListExistUntil]
  ///
  List<I> takeListUntil(
    Predicator<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) {
    final list = <I>[];
    while (moveNext()) {
      if (testInvalid(current)) {
        if (includeFirstInvalid) list.add(current);
        break;
      }
      list.add(current);
    }
    return list;
  }

  List<I> takeListExistUntil(
    PredicatorCombiner<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) =>
      moveNextSupply(() {
        final val = current;
        final list = [val];
        while (moveNext()) {
          if (testInvalid(val, current)) {
            if (includeFirstInvalid) list.add(current);
            break;
          }
          list.add(current);
        }
        return list;
      });

  ///
  /// skip / [Iterable.skip]
  /// [skip]
  ///
  ///
  Iterable<I> skip(int count) {
    var i = 0;
    for (; moveNext() && i < count; i++) {}
    if (count > i) throw RangeError(KErrorMessage.indexOutOfBoundary);
    return takeAll;
  }

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
  /// reduce
  /// [reduce]
  /// [reduceByIndex], [reduceAccompany]
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
  ///
  ///
  /// reduce
  /// [reduce]
  /// [reduceByIndex], [reduceAccompany]
  ///
  ///
  ///

  ///
  /// [reduce]
  /// [reduceByIndex], [reduceAccompany]
  ///
  I reduce(Reducer<I> reducing) => moveNextApply((val) {
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  I reduceByIndex(ReducerGenerator<I> reducing, [int start = 0]) =>
      moveNextApply((val) {
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
      moveNextApply((val) {
        var val = current;
        var ele = initialElement;
        while (moveNext()) {
          val = reducing(val, current, ele);
          ele = after(ele, current, val);
        }
        return val;
      });
}

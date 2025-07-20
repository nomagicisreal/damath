part of '../collection.dart';

///
///
/// void callback             --> [consumeHasNext], ...
/// return bool               --> [any], ...
/// return int                --> [indexFound], ...
/// return current type item  --> [first], ...
/// return iterable           --> [take], ...
/// return iterable int       --> [indexesWhere], ...
/// return list               --> [takeList], ...
///
///
extension IteratorExtension<I> on Iterator<I> {
  ///
  ///
  /// [consumeHasNext], [consumeMoveNext]
  /// [consumeFound]
  /// [consumeAll], [consumeAllByIndex]
  /// [consumePair], [consumePairByIndex]
  /// [consumeAccompany], [consumeAccompanyByIndex]
  ///
  ///

  ///
  /// [consumeHasNext], [consumeMoveNext]
  ///
  void consumeHasNext(Consumer<Iterator<I>> consume) {
    if (moveNext()) consume(this);
  }

  void consumeMoveNext(Consumer<I> consume) =>
      moveNext()
          ? consume(current)
          : throw StateError(Erroring.iterableNoElement);

  ///
  /// [consumeFound], [consumeWhere]
  ///
  void consumeFound(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) return action(current);
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  void consumeWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) action(current);
    }
  }

  ///
  /// [consumeAll], [consumeAllByIndex]
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
  /// [consumePair], [consumePairByIndex]
  ///
  void consumePair(Intersector<I> paring, [Consumer<I>? trailing]) {
    late I a;
    late I b;
    while (moveNext()) {
      a = current;
      if (!moveNext()) {
        trailing?.call(a);
        return;
      }
      b = current;
      paring(a, b);
    }
  }

  void consumePairByIndex(
    IntersectorIndexable<I> paring, [
    Consumer<I>? trailing,
    int start = 0,
  ]) {
    late I a;
    late I b;
    for (var i = start; moveNext(); i++) {
      a = current;
      if (!moveNext()) {
        trailing?.call(a);
        return;
      }
      b = current;
      paring(a, b, i);
    }
  }

  ///
  /// [consumeAccompany], [consumeAccompanyByIndex]
  ///
  void consumeAccompany(I value, Intersector<I> paring) {
    while (moveNext()) {
      paring(current, value);
    }
  }

  void consumeAccompanyByIndex(
    I value,
    IntersectorIndexable<I> paring, [
    int start = 0,
  ]) {
    for (var i = start; moveNext(); i++) {
      paring(current, value, i);
    }
  }

  ///
  ///
  ///
  /// [any], [anyBy]
  /// [exist], [existTo], [existToInited]
  /// [existAny], [existAnyTo], [existDifferent], [existDifferentTo], [existEqual],  [existEqualTo]
  /// [existAnyToEachGroup], [existAnyToEachGroupSet]
  ///
  ///
  ///

  ///
  /// [any], [anyBy]
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
  /// [exist], [existTo], [existToInited]
  ///
  bool exist(PredicatorReducer<I> test) => supplyMoveNext(() {
    var val = current;
    while (moveNext()) {
      if (test(val, current)) return true;
      val = current;
    }
    return false;
  });

  bool existTo<T>(Mapper<I, T> toVal, PredicatorReducer<T> test) =>
      supplyMoveNext(() {
        var val = toVal(current);
        while (moveNext()) {
          final v = toVal(current);
          if (test(val, v)) return true;
          val = v;
        }
        return false;
      });

  bool existToInited<T>(Mapper<I, T> toVal, PredicatorReducer<T> test) =>
      supplyMoveNext(() {
        var val = toVal(current);
        while (moveNext()) {
          if (test(val, toVal(current))) return true;
        }
        return false;
      });

  ///
  /// [existAny], [existAnyTo]
  ///
  bool existAny(PredicatorReducer<I> test) => supplyMoveNext(() {
    final list = <I>[current];
    while (moveNext()) {
      if (list.any((val) => test(val, current))) return true;
      list.add(current);
    }
    return false;
  });

  bool existAnyTo<T>(Mapper<I, T> toVal, PredicatorReducer<T> test) =>
      supplyMoveNext(() {
        final list = <T>[toVal(current)];
        while (moveNext()) {
          final v = toVal(current);
          if (list.any((val) => test(val, v))) return true;
          list.add(v);
        }
        return false;
      });

  ///
  /// [existDifferent], [existDifferentTo]
  /// [existEqual], [existEqualTo]
  ///
  bool get existDifferent => exist(FPredicatorFusionor.isDifferent);

  bool existDifferentTo<T>(Mapper<I, T> toId) =>
      existTo(toId, FPredicatorFusionor.isDifferent);

  bool existEqual() => existAny(FPredicatorFusionor.isEqual);

  bool existEqualTo<T>(Mapper<I, T> toId) =>
      existAnyTo(toId, FPredicatorFusionor.isEqual);

  ///
  /// [existAnyToEachGroup], [existAnyToEachGroupSet]
  ///
  bool existAnyToEachGroup<K, V>(
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, V>, K, V> listen,
  ) => supplyMoveNext(() {
    final map = <K, V>{toKey(current): toVal(current)};
    while (moveNext()) {
      if (listen(map, toKey(current), toVal(current))) {
        return true;
      }
    }
    return false;
  });

  bool existAnyToEachGroupSet<K, V>(
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, Set<V>>, K, V> listen,
  ) => supplyMoveNext(() {
    final map = <K, Set<V>>{
      toKey(current): {toVal(current)},
    };
    while (moveNext()) {
      if (listen(map, toKey(current), toVal(current))) {
        return true;
      }
    }
    return false;
  });

  ///
  ///
  ///
  /// [indexFound], [indexFoundChecked]
  /// [cumulate], [cumulateBy], [cumulateLengthNested]
  ///
  ///
  ///
  ///

  ///
  /// [indexFound], [indexFoundChecked]
  ///
  int indexFound(Predicator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current)) return i;
      i++;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  int indexFoundChecked(PredicatorGenerator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current, i)) return i;
      i++;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  ///
  /// [cumulate], [cumulateBy], [cumulateLengthNested]
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

  int cumulateLengthNested<T>() => induct<int>(
    (element) => switch (element) {
      T() => 1,
      Iterable<T>() => element.length,
      Iterable<Iterable>() => element.iterator.cumulateLengthNested<T>(),
      _ => throw StateError(Erroring.iterableElementNotNest),
    },
    IntExtension.reduce_plus,
  );

  ///
  ///
  /// [first], [last]
  /// [applyMoveNext], [applyLead]
  /// [find], [findOr], [findOrNull]
  /// [reduce], [reduceByIndex], [reduceBy]
  ///
  ///

  ///
  /// [first], [last]
  ///
  I get first => supplyMoveNext(() => current);

  I get last => applyMoveNext((val) {
    var lastVal = val;
    while (moveNext()) {
      lastVal = current;
    }
    return lastVal;
  });

  ///
  /// [applyMoveNext], [applyLead]
  ///
  I applyMoveNext(Applier<I> apply) =>
      moveNext()
          ? apply(current)
          : throw StateError(Erroring.iterableNoElement);

  I applyLead(int ahead, Applier<I> apply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(Erroring.iterableNoElement);
    }
    return apply(current);
  }

  ///
  /// [find], [findOr], [findOrNull]
  ///
  I find(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  I findOr(Predicator<I> test, Supplier<I> supply) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return supply();
  }

  I? findOrNull(Predicator<I> test) {
    while (moveNext()) {
      if (test(current)) return current;
    }
    return null;
  }

  ///
  /// [reduce], [reduceByIndex], [reduceBy]
  ///
  I reduce(Reducer<I> reducing) => applyMoveNext((val) {
    var result = val;
    while (moveNext()) {
      result = reducing(result, current);
    }
    return result;
  });

  I reduceByIndex(ReducerGenerator<I> reducing, [int start = 0]) =>
      applyMoveNext((val) {
        var result = val;
        for (var i = start; moveNext(); i++) {
          result = reducing(result, current, i);
        }
        return result;
      });

  I reduceBy<T>(
    T initialElement,
    Collector<I, T> reducing,
    Absorber<T, I> after,
  ) => applyMoveNext((val) {
    var result = val;
    var ele = initialElement;
    while (moveNext()) {
      result = reducing(result, current, ele);
      ele = after(ele, current, result);
    }
    return result;
  });

  ///
  ///
  ///
  /// [take], [takeAll]
  /// [takeAllApply], [takeAllCompanion],
  /// [takeWhile], [takeWhileExist],
  /// [takeUntil], [takeUntilExist],
  /// [takeFrom], [takeBetween],
  ///
  /// [where], [whereUntil]
  /// [whereFrom], [whereBetween],
  ///
  /// [expand]
  /// [expandByIndex], [expandBy], [expandWhere]
  ///
  /// [skip]
  /// [sub]
  ///
  /// [mergeBy]
  /// [interval]
  ///
  ///
  ///

  ///
  /// [take], [takeAll]
  ///
  Iterable<I> take(int count) sync* {
    var i = 0;
    for (; i < count && moveNext(); i++) {
      yield current;
    }
    if (count > i) throw RangeError.range(count, 0, i);
  }

  Iterable<I> get takeAll => [for (; moveNext();) current];

  ///
  /// [takeAllApply], [takeAllCompanion]
  ///
  Iterable<I> takeAllApply(Applier<I> apply) sync* {
    while (moveNext()) {
      yield apply(current);
    }
  }

  Iterable<I> takeAllCompanion<T>(T value, Companion<I, T> companion) sync* {
    while (moveNext()) {
      yield companion(current, value);
    }
  }

  ///
  /// [takeWhile], [takeWhileExist]
  ///
  Iterable<I> takeWhile(Predicator<I> test) sync* {
    while (moveNext()) {
      if (!test(current)) break;
      yield current;
    }
  }

  Iterable<I> takeWhileExist(
    PredicatorReducer<I> test, [
    bool includeFirst = true,
  ]) => supplyMoveNext(() sync* {
    final val = current;
    if (includeFirst) yield val;
    while (moveNext()) {
      if (!test(val, current)) break;
      yield current;
    }
  });

  ///
  /// [takeUntil], [takeUntilExist]
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

  Iterable<I> takeUntilExist(
    PredicatorReducer<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) => supplyMoveNext(() sync* {
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
  /// [takeFrom], [takeBetween]
  ///
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
  /// [where], [whereUntil]
  ///
  Iterable<I> where(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

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

  ///
  /// [whereFrom], [whereBetween]
  ///
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
  /// [expand]
  ///
  Iterable<I> expand(Mapper<I, Iterable<I>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  ///
  /// [expandBy], [expandByIndex], [expandWhere]
  ///
  Iterable<I> expandBy<T>(T value, Mixer<I, T, Iterable<I>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current, value);
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

  Iterable<I> expandWhere(
    Predicator<I> test,
    Mapper<I, Iterable<I>> expanding,
  ) => [for (; moveNext() && test(current);) ...expanding(current)];

  ///
  /// [skip], [sub]
  ///
  Iterable<I> skip(int count) {
    var i = 0;
    for (; moveNext() && i < count; i++) {}
    if (count > i) throw RangeError.range(count, 0, i);
    return takeAll;
  }

  Iterable<I> sub(int start, [int? end]) sync* {
    var i = 0;
    for (; i < start && moveNext(); i++) {}

    if (end == null) {
      while (moveNext()) {
        yield current;
      }
      return;
    }
    for (; i < end && moveNext(); i++) {
      yield current;
    }
  }

  ///
  /// [mergeBy]
  ///
  Iterable<I> mergeBy(int split, PredicatorReducer<I> keep) =>
      [...take(split)].iterator.pairMerge(this, keep);

  ///
  /// [interval]
  ///
  Iterable<I> interval(Reducer<I> reducing) => supplyMoveNext(() sync* {
    var previous = current;
    while (moveNext()) {
      yield reducing(previous, current);
      previous = current;
    }
  });

  ///
  ///
  /// [indexesWhere], [indexesWhereUntil], [indexesWhereFrom], [indexesWhereBetween],
  /// [indexesWhereChecked], [indexesWhereCheckedUntil], [indexesWhereCheckedFrom], [indexesWhereCheckedBetween],
  ///
  ///

  ///
  /// [indexesWhere], [indexesWhereUntil]
  ///
  Iterable<int> indexesWhere(Predicator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current)) yield i;
    }
  }

  Iterable<int> indexesWhereUntil(
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

  ///
  /// [indexesWhereFrom], [indexesWhereBetween]
  ///
  Iterable<int> indexesWhereFrom(
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

  Iterable<int> indexesWhereBetween(
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
  /// [indexesWhereChecked]
  /// [indexesWhereCheckedUntil]
  ///
  Iterable<int> indexesWhereChecked(PredicatorGenerator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current, i)) yield i;
    }
  }

  Iterable<int> indexesWhereCheckedUntil(
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

  ///
  /// [indexesWhereCheckedFrom]
  /// [indexesWhereCheckedBetween]
  ///
  Iterable<int> indexesWhereCheckedFrom(
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

  Iterable<int> indexesWhereCheckedBetween(
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
  ///
  /// [takeList], [takeListAll]
  /// [takeListWhile], [takeListWhileExistOnFirst],
  /// [takeListUntil], [takeListUntilExist],
  ///
  ///

  ///
  /// [takeList], [takeListAll]
  /// [takeListWhile], [takeListWhileExistOnFirst]
  ///
  List<I> takeList(int count) {
    final list = <I>[];
    var i = 0;
    for (; i < count && moveNext(); i++) {
      list.add(current);
    }
    if (count > i) throw RangeError.range(count, 0, i);
    return list;
  }

  List<I> takeListAll() => [for (; moveNext();) current];

  List<I> takeListWhile(Predicator<I> test) => [
    for (; moveNext() && test(current);) current,
  ];

  List<I> takeListWhileExistOnFirst(PredicatorReducer<I> test) =>
      supplyMoveNext(() {
        final val = current;
        return [for (; moveNext() && test(val, current);) current];
      });

  ///
  /// [takeListUntil]
  /// [takeListUntilExist]
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

  List<I> takeListUntilExist(
    PredicatorReducer<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) => supplyMoveNext(() {
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
}

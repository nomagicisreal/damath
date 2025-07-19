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
  /// [consumeHasNext]
  /// [consumeMoveNext]
  ///
  static void consumeHasNext<I>(
    Iterator<I> iterator,
    Consumer<Iterator<I>> consume,
  ) {
    if (iterator.moveNext()) consume(iterator);
  }

  static void consumeMoveNext<I>(Iterator<I> iterator, Consumer<I> consume) =>
      iterator.moveNext()
          ? consume(iterator.current)
          : throw StateError(Erroring.iterableNoElement);

  ///
  /// [consumeFound], [consumeWhere]
  ///
  static void consumeFound<I>(
    Iterator<I> iterator,
    Predicator<I> test,
    Consumer<I> action,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return action(iterator.current);
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  static void consumeWhere<I>(
    Iterator<I> iterator,
    Predicator<I> test,
    Consumer<I> action,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) action(iterator.current);
    }
  }

  ///
  /// [consumeAll]
  /// [consumeAllByIndex]
  ///
  static void consumeAll<I>(Iterator<I> iterator, Consumer<I> consume) {
    while (iterator.moveNext()) {
      consume(iterator.current);
    }
  }

  static void consumeAllByIndex<I>(
    Iterator<I> iterator,
    ConsumerIndexable<I> consume, [
    int start = 0,
  ]) {
    for (var i = start; iterator.moveNext(); i++) {
      consume(iterator.current, i);
    }
  }

  ///
  /// [consumePair]
  /// [consumePairByIndex]
  ///
  static void consumePair<I>(
    Iterator<I> iterator,
    Intersector<I> paring, [
    Consumer<I>? trailing,
  ]) {
    late I a;
    late I b;
    while (iterator.moveNext()) {
      a = iterator.current;
      if (!iterator.moveNext()) {
        trailing?.call(a);
        return;
      }
      b = iterator.current;
      paring(a, b);
    }
  }

  static void consumePairByIndex<I>(
    Iterator<I> iterator,
    IntersectorIndexable<I> paring, [
    Consumer<I>? trailing,
    int start = 0,
  ]) {
    late I a;
    late I b;
    for (var i = start; iterator.moveNext(); i++) {
      a = iterator.current;
      if (!iterator.moveNext()) {
        trailing?.call(a);
        return;
      }
      b = iterator.current;
      paring(a, b, i);
    }
  }

  ///
  /// [consumeAccompany]
  /// [consumeAccompanyByIndex]
  ///
  static void consumeAccompany<I>(
    Iterator<I> iterator,
    I value,
    Intersector<I> paring,
  ) {
    while (iterator.moveNext()) {
      paring(iterator.current, value);
    }
  }

  static void consumeAccompanyByIndex<I>(
    Iterator<I> iterator,
    I value,
    IntersectorIndexable<I> paring, [
    int start = 0,
  ]) {
    for (var i = start; iterator.moveNext(); i++) {
      paring(iterator.current, value, i);
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
  /// [any]
  /// [anyBy]
  ///
  static bool any<I>(Iterator<I> iterator, Predicator<I> test) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return true;
    }
    return false;
  }

  static bool anyBy<I, T>(
    Iterator<I> iterator,
    T element,
    PredicatorMixer<T, I> test,
  ) {
    while (iterator.moveNext()) {
      if (test(element, iterator.current)) return true;
    }
    return false;
  }

  ///
  /// [exist]
  /// [existTo]
  /// [existToInited]
  ///
  static bool exist<I>(Iterator<I> iterator, PredicatorReducer<I> test) =>
      IteratorTo.supplyMoveNext(iterator, () {
        var val = iterator.current;
        while (iterator.moveNext()) {
          if (test(val, iterator.current)) return true;
          val = iterator.current;
        }
        return false;
      });

  static bool existTo<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> toVal,
    PredicatorReducer<T> test,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    var val = toVal(iterator.current);
    while (iterator.moveNext()) {
      final v = toVal(iterator.current);
      if (test(val, v)) return true;
      val = v;
    }
    return false;
  });

  static bool existToInited<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> toVal,
    PredicatorReducer<T> test,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    var val = toVal(iterator.current);
    while (iterator.moveNext()) {
      if (test(val, toVal(iterator.current))) return true;
    }
    return false;
  });

  ///
  /// [existAny]
  /// [existAnyTo]
  ///
  static bool existAny<I>(Iterator<I> iterator, PredicatorReducer<I> test) =>
      IteratorTo.supplyMoveNext(iterator, () {
        final list = <I>[iterator.current];
        while (iterator.moveNext()) {
          if (list.any((val) => test(val, iterator.current))) return true;
          list.add(iterator.current);
        }
        return false;
      });

  static bool existAnyTo<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> toVal,
    PredicatorReducer<T> test,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    final list = <T>[toVal(iterator.current)];
    while (iterator.moveNext()) {
      final v = toVal(iterator.current);
      if (list.any((val) => test(val, v))) return true;
      list.add(v);
    }
    return false;
  });

  ///
  /// [existDifferent], [existDifferentTo]
  /// [existEqual], [existEqualTo]
  ///
  static bool existDifferent<I>(Iterator<I> iterator) =>
      exist(iterator, FPredicatorFusionor.isDifferent);

  static bool existDifferentTo<I, T>(Iterator<I> iterator, Mapper<I, T> toId) =>
      existTo(iterator, toId, FPredicatorFusionor.isDifferent);

  static bool existEqual<I>(Iterator<I> iterator) =>
      existAny(iterator, FPredicatorFusionor.isEqual);

  static bool existEqualTo<I, T>(Iterator<I> iterator, Mapper<I, T> toId) =>
      existAnyTo(iterator, toId, FPredicatorFusionor.isEqual);

  ///
  /// [existAnyToEachGroup]
  /// [existAnyToEachGroupSet]
  ///
  static bool existAnyToEachGroup<I, K, V>(
    Iterator<I> iterator,
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, V>, K, V> listen,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    final map = <K, V>{toKey(iterator.current): toVal(iterator.current)};
    while (iterator.moveNext()) {
      if (listen(map, toKey(iterator.current), toVal(iterator.current))) {
        return true;
      }
    }
    return false;
  });

  static bool existAnyToEachGroupSet<I, K, V>(
    Iterator<I> iterator,
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, Set<V>>, K, V> listen,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    final map = <K, Set<V>>{
      toKey(iterator.current): {toVal(iterator.current)},
    };
    while (iterator.moveNext()) {
      if (listen(map, toKey(iterator.current), toVal(iterator.current))) {
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
  /// [indexFound]
  /// [indexFoundChecked]
  ///
  static int indexFound<I>(Iterator<I> iterator, Predicator<I> test) {
    var i = 0;
    while (iterator.moveNext()) {
      if (test(iterator.current)) return i;
      i++;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  static int indexFoundChecked<I>(
      Iterator<I> iterator,
      PredicatorGenerator<I> test,
      ) {
    var i = 0;
    while (iterator.moveNext()) {
      if (test(iterator.current, i)) return i;
      i++;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  ///
  /// [cumulate]
  /// [cumulateBy]
  /// [cumulateLengthNested]
  ///
  static int cumulate<I>(Iterator<I> iterator, Predicator<I> test) {
    var val = 0;
    while (iterator.moveNext()) {
      if (test(iterator.current)) val++;
    }
    return val;
  }

  static int cumulateBy<I, T>(
      Iterator<I> iterator,
      T value,
      PredicatorMixer<I, T> test,
      ) {
    var val = 0;
    while (iterator.moveNext()) {
      if (test(iterator.current, value)) val++;
    }
    return val;
  }

  static int cumulateLengthNested<I, T>(Iterator<I> iterator) =>
      IteratorTo.induct<I, int>(
        iterator,
            (element) => switch (element) {
          T() => 1,
          Iterable<T>() => element.length,
          Iterable<Iterable>() => IteratorExtension.cumulateLengthNested(
            element.iterator,
          ),
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
  static I first<I>(Iterator<I> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () => iterator.current);

  static I last<I>(Iterator<I> iterator) =>
      IteratorExtension.applyMoveNext(iterator, (val) {
        while (iterator.moveNext()) {
          val = iterator.current;
        }
        return val;
      });

  ///
  /// [applyMoveNext], [applyLead]
  ///
  static I applyMoveNext<I>(Iterator<I> iterator, Applier<I> apply) =>
      iterator.moveNext()
          ? apply(iterator.current)
          : throw StateError(Erroring.iterableNoElement);

  static I applyLead<I>(Iterator<I> iterator, int ahead, Applier<I> apply) {
    for (var i = -1; i < ahead; i++) {
      if (!iterator.moveNext()) {
        throw StateError(Erroring.iterableNoElement);
      }
    }
    return apply(iterator.current);
  }

  ///
  /// [find], [findOr], [findOrNull]
  ///
  static I find<I>(Iterator<I> iterator, Predicator<I> test) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return iterator.current;
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  static I findOr<I>(
    Iterator<I> iterator,
    Predicator<I> test,
    Supplier<I> supply,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return iterator.current;
    }
    return supply();
  }

  static I? findOrNull<I>(Iterator<I> iterator, Predicator<I> test) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return iterator.current;
    }
    return null;
  }

  ///
  /// [reduce]
  /// [reduceByIndex], [reduceBy]
  ///
  static I reduce<I>(Iterator<I> iterator, Reducer<I> reducing) =>
      applyMoveNext(iterator, (val) {
        while (iterator.moveNext()) {
          val = reducing(val, iterator.current);
        }
        return val;
      });

  static I reduceByIndex<I>(
    Iterator<I> iterator,
    ReducerGenerator<I> reducing, [
    int start = 0,
  ]) => applyMoveNext(iterator, (val) {
    var val = iterator.current;
    for (var i = start; iterator.moveNext(); i++) {
      val = reducing(val, iterator.current, i);
    }
    return val;
  });

  static I reduceBy<I, T>(
    Iterator<I> iterator,
    T initialElement,
    Collector<I, T> reducing,
    Absorber<T, I> after,
  ) => applyMoveNext(iterator, (val) {
    var val = iterator.current;
    var ele = initialElement;
    while (iterator.moveNext()) {
      val = reducing(val, iterator.current, ele);
      ele = after(ele, iterator.current, val);
    }
    return val;
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
  static Iterable<I> take<I>(Iterator<I> iterator, int count) sync* {
    var i = 0;
    for (; i < count && iterator.moveNext(); i++) {
      yield iterator.current;
    }
    if (count > i) throw RangeError.range(count, 0, i);
  }

  static Iterable<I> takeAll<I>(Iterator<I> iterator) => [
    for (; iterator.moveNext();) iterator.current,
  ];

  ///
  /// [takeAllApply], [takeAllCompanion]
  ///
  static Iterable<I> takeAllApply<I>(
    Iterator<I> iterator,
    Applier<I> apply,
  ) sync* {
    while (iterator.moveNext()) {
      yield apply(iterator.current);
    }
  }

  static Iterable<I> takeAllCompanion<I, T>(
    Iterator<I> iterator,
    T value,
    Companion<I, T> companion,
  ) sync* {
    while (iterator.moveNext()) {
      yield companion(iterator.current, value);
    }
  }

  ///
  /// [takeWhile]
  /// [takeWhileExist]
  ///
  static Iterable<I> takeWhile<I>(
    Iterator<I> iterator,
    Predicator<I> test,
  ) sync* {
    while (iterator.moveNext()) {
      if (!test(iterator.current)) break;
      yield iterator.current;
    }
  }

  static Iterable<I> takeWhileExist<I>(
    Iterator<I> iterator,
    PredicatorReducer<I> test, [
    bool includeFirst = true,
  ]) => IteratorTo.supplyMoveNext(iterator, () sync* {
    final val = iterator.current;
    if (includeFirst) yield val;
    while (iterator.moveNext()) {
      if (!test(val, iterator.current)) break;
      yield iterator.current;
    }
  });

  ///
  /// [takeUntil]
  /// [takeUntilExist]
  ///
  static Iterable<I> takeUntil<I>(
    Iterator<I> iterator,
    Predicator<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) sync* {
    while (iterator.moveNext()) {
      if (testInvalid(iterator.current)) {
        if (includeFirstInvalid) yield iterator.current;
        break;
      }
      yield iterator.current;
    }
  }

  static Iterable<I> takeUntilExist<I>(
    Iterator<I> iterator,
    PredicatorReducer<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) => IteratorTo.supplyMoveNext(iterator, () sync* {
    final val = iterator.current;
    yield val;
    while (iterator.moveNext()) {
      if (testInvalid(val, iterator.current)) {
        if (includeFirstInvalid) yield iterator.current;
        break;
      }
      yield iterator.current;
    }
  });

  ///
  /// [takeFrom]
  /// [takeBetween]
  ///
  static Iterable<I> takeFrom<I>(
    Iterator<I> iterator,
    Predicator<I> testStart, [
    bool includeStart = true,
  ]) sync* {
    while (iterator.moveNext()) {
      if (testStart(iterator.current)) {
        if (includeStart) yield iterator.current;
        break;
      }
    }
    while (iterator.moveNext()) {
      yield iterator.current;
    }
  }

  static Iterable<I> takeBetween<I>(
    Iterator<I> iterator,
    Predicator<I> testStart,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    while (iterator.moveNext()) {
      if (testStart(iterator.current)) {
        if (includeStart) yield iterator.current;
        break;
      }
    }
    while (iterator.moveNext()) {
      if (testEnd(iterator.current)) {
        if (includeEnd) yield iterator.current;
        break;
      }
      yield iterator.current;
    }
  }

  ///
  /// [where], [whereUntil]
  ///
  static Iterable<I> where<I>(Iterator<I> iterator, Predicator<I> test) sync* {
    while (iterator.moveNext()) {
      if (test(iterator.current)) yield iterator.current;
    }
  }

  static Iterable<I> whereUntil<I>(
      Iterator<I> iterator,
      Predicator<I> test,
      Predicator<I> testEnd, [
        bool includeEnd = false,
      ]) sync* {
    while (iterator.moveNext()) {
      if (testEnd(iterator.current)) {
        if (includeEnd) yield iterator.current;
        break;
      }
      if (test(iterator.current)) yield iterator.current;
    }
  }

  ///
  /// [whereFrom], [whereBetween]
  ///
  static Iterable<I> whereFrom<I>(
    Iterator<I> iterator,
    Predicator<I> testStart,
    Predicator<I> test, [
    bool includeStart = true,
  ]) sync* {
    while (iterator.moveNext()) {
      if (testStart(iterator.current)) {
        if (includeStart) yield iterator.current;
        break;
      }
    }
    while (iterator.moveNext()) {
      if (test(iterator.current)) yield iterator.current;
    }
  }

  static Iterable<I> whereBetween<I>(
    Iterator<I> iterator,
    Predicator<I> testStart,
    Predicator<I> test,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    while (iterator.moveNext()) {
      if (testStart(iterator.current)) {
        if (includeStart) yield iterator.current;
        break;
      }
    }
    while (iterator.moveNext()) {
      if (testEnd(iterator.current)) {
        if (includeEnd) yield iterator.current;
        break;
      }
      if (test(iterator.current)) yield iterator.current;
    }
  }

  ///
  /// [expand]
  ///
  static Iterable<I> expand<I>(
      Iterator<I> iterator,
      Mapper<I, Iterable<I>> expanding,
      ) sync* {
    while (iterator.moveNext()) {
      yield* expanding(iterator.current);
    }
  }

  ///
  /// [expandBy], [expandByIndex], [expandWhere]
  ///
  static Iterable<I> expandBy<I, T>(
      Iterator<I> iterator,
      T value,
      Mixer<I, T, Iterable<I>> expanding,
      ) sync* {
    while (iterator.moveNext()) {
      yield* expanding(iterator.current, value);
    }
  }

  static Iterable<I> expandByIndex<I>(
      Iterator<I> iterator,
      MapperGenerator<I, Iterable<I>> expanding, [
        int start = 0,
      ]) sync* {
    for (var i = start; iterator.moveNext(); i++) {
      yield* expanding(iterator.current, i);
    }
  }

  static Iterable<I> expandWhere<I>(
      Iterator<I> iterator,
      Predicator<I> test,
      Mapper<I, Iterable<I>> expanding,
      ) => [
    for (; iterator.moveNext() && test(iterator.current);)
      ...expanding(iterator.current),
  ];

  ///
  /// [skip], [sub]
  ///
  static Iterable<I> skip<I>(Iterator<I> iterator, int count) {
    var i = 0;
    for (; iterator.moveNext() && i < count; i++) {}
    if (count > i) throw RangeError.range(count, 0, i);
    return takeAll(iterator);
  }

  static Iterable<I> sub<I>(Iterator<I> iterator, int start, [int? end]) sync* {
    var i = 0;
    for (; i < start && iterator.moveNext(); i++) {}

    if (end == null) {
      while (iterator.moveNext()) {
        yield iterator.current;
      }
      return;
    }
    for (; i < end && iterator.moveNext(); i++) {
      yield iterator.current;
    }
  }

  ///
  /// [mergeBy]
  ///
  static Iterable<I> mergeBy<I>(
    Iterator<I> iterator,
    int split,
    PredicatorReducer<I> keep,
  ) => IteratorTogether.pairMerge(
    [...take(iterator, split)].iterator,
    iterator,
    keep,
  );

  ///
  /// [interval]
  ///
  static Iterable<I> interval<I>(Iterator<I> iterator, Reducer<I> reducing) =>
      IteratorTo.supplyMoveNext(iterator, () sync* {
        var previous = iterator.current;
        while (iterator.moveNext()) {
          yield reducing(previous, iterator.current);
          previous = iterator.current;
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
  static Iterable<int> indexesWhere<I>(
    Iterator<I> iterator,
    Predicator<I> test,
  ) sync* {
    for (var i = 0; iterator.moveNext(); i++) {
      if (test(iterator.current)) yield i;
    }
  }

  static Iterable<int> indexesWhereUntil<I>(
      Iterator<I> iterator,
      Predicator<I> test,
      Predicator<I> testEnd, [
        bool includeEnd = false,
      ]) sync* {
    for (var i = 0; iterator.moveNext(); i++) {
      if (testEnd(iterator.current)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(iterator.current)) yield i;
    }
  }

  ///
  /// [indexesWhereFrom], [indexesWhereBetween]
  ///
  static Iterable<int> indexesWhereFrom<I>(
    Iterator<I> iterator,
    Predicator<I> testStart,
    Predicator<I> test, [
    bool includeStart = true,
  ]) sync* {
    var i = 0;
    for (; iterator.moveNext(); i++) {
      if (testStart(iterator.current)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; iterator.moveNext(); i++) {
      if (test(iterator.current)) yield i;
    }
  }

  static Iterable<int> indexesWhereBetween<I>(
    Iterator<I> iterator,
    Predicator<I> testStart,
    Predicator<I> test,
    Predicator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    var i = 0;
    for (; iterator.moveNext(); i++) {
      if (testStart(iterator.current)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; iterator.moveNext(); i++) {
      if (testEnd(iterator.current)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(iterator.current)) yield i;
    }
  }

  ///
  /// [indexesWhereChecked]
  /// [indexesWhereCheckedUntil]
  ///
  static Iterable<int> indexesWhereChecked<I>(
    Iterator<I> iterator,
    PredicatorGenerator<I> test,
  ) sync* {
    for (var i = 0; iterator.moveNext(); i++) {
      if (test(iterator.current, i)) yield i;
    }
  }

  static Iterable<int> indexesWhereCheckedUntil<I>(
      Iterator<I> iterator,
      PredicatorGenerator<I> test,
      PredicatorGenerator<I> testEnd, [
        bool includeEnd = false,
      ]) sync* {
    for (var i = 0; iterator.moveNext(); i++) {
      if (testEnd(iterator.current, i)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(iterator.current, i)) yield i;
    }
  }

  ///
  /// [indexesWhereCheckedFrom]
  /// [indexesWhereCheckedBetween]
  ///
  static Iterable<int> indexesWhereCheckedFrom<I>(
    Iterator<I> iterator,
    PredicatorGenerator<I> testStart,
    PredicatorGenerator<I> test, [
    bool includeStart = true,
  ]) sync* {
    var i = 0;
    for (; iterator.moveNext(); i++) {
      if (testStart(iterator.current, i)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; iterator.moveNext(); i++) {
      if (test(iterator.current, i)) yield i;
    }
  }

  static Iterable<int> indexesWhereCheckedBetween<I>(
    Iterator<I> iterator,
    PredicatorGenerator<I> testStart,
    PredicatorGenerator<I> test,
    PredicatorGenerator<I> testEnd, {
    bool includeStart = true,
    bool includeEnd = false,
  }) sync* {
    var i = 0;
    for (; iterator.moveNext(); i++) {
      if (testStart(iterator.current, i)) {
        if (includeStart) yield i;
        break;
      }
    }
    for (; iterator.moveNext(); i++) {
      if (testEnd(iterator.current, i)) {
        if (includeEnd) yield i;
        break;
      }
      if (test(iterator.current, i)) yield i;
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
  static List<I> takeList<I>(Iterator<I> iterator, int count) {
    final list = <I>[];
    var i = 0;
    for (; i < count && iterator.moveNext(); i++) {
      list.add(iterator.current);
    }
    if (count > i) throw RangeError.range(count, 0, i);
    return list;
  }

  static List<I> takeListAll<I>(Iterator<I> iterator) => [
    for (; iterator.moveNext();) iterator.current,
  ];

  static List<I> takeListWhile<I>(Iterator<I> iterator, Predicator<I> test) => [
    for (; iterator.moveNext() && test(iterator.current);) iterator.current,
  ];

  static List<I> takeListWhileExistOnFirst<I>(
      Iterator<I> iterator,
      PredicatorReducer<I> test,
      ) => IteratorTo.supplyMoveNext(iterator, () {
    final val = iterator.current;
    return [
      for (; iterator.moveNext() && test(val, iterator.current);)
        iterator.current,
    ];
  });

  ///
  /// [takeListUntil]
  /// [takeListUntilExist]
  ///
  static List<I> takeListUntil<I>(
      Iterator<I> iterator,
      Predicator<I> testInvalid, [
        bool includeFirstInvalid = false,
      ]) {
    final list = <I>[];
    while (iterator.moveNext()) {
      if (testInvalid(iterator.current)) {
        if (includeFirstInvalid) list.add(iterator.current);
        break;
      }
      list.add(iterator.current);
    }
    return list;
  }

  static List<I> takeListUntilExist<I>(
      Iterator<I> iterator,
      PredicatorReducer<I> testInvalid, [
        bool includeFirstInvalid = false,
      ]) => IteratorTo.supplyMoveNext(iterator, () {
    final val = iterator.current;
    final list = [val];
    while (iterator.moveNext()) {
      if (testInvalid(val, iterator.current)) {
        if (includeFirstInvalid) list.add(iterator.current);
        break;
      }
      list.add(iterator.current);
    }
    return list;
  });
}

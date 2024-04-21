part of damath_collection;
// ignore_for_file: curly_braces_in_flow_control_structures

///
///
/// [consumeHasNext], ...
/// [applyMoveNext], ...
///
/// [any], ...
/// [exist], ...
///
/// [first], ...
/// [find], ...
/// [reduce], ...
///
/// [take], ...
/// [where], ...
/// [skip], ...
/// [sub], ...
/// [expand], ...
/// [mergeBy], ...
/// [interval]
///
/// [indexFound], ...
/// [cumulate], ...
///
/// [combination2FromFirst], ...
///
///
extension IteratorExtension<I> on Iterator<I> {
  ///
  ///
  ///
  S getCurrentOrDefault<S>(Mapper<I, S> toVal, S ifAbsent) {
    try {
      return toVal(current);
    } catch (e) {
      if (!e.runtimeType.isTypeError) rethrow;
    }
    return ifAbsent;
  }

  ///
  /// consume
  /// [consumeHasNext]
  /// [consumeMoveNext]
  /// [consumeFound]
  /// [consumeAll], [consumeAllByIndex]
  /// [consumePair], [consumePairByIndex]
  /// [consumeAccompany], [consumeAccompanyByIndex]
  ///
  ///

  ///
  /// [consumeHasNext], [consumeMoveNext]
  /// [consumeFound], [consumeWhere]
  ///
  void consumeHasNext(Consumer<Iterator<I>> consume) {
    if (moveNext()) consume(this);
  }

  void consumeMoveNext(Consumer<I> consume) => moveNext()
      ? consume(current)
      : throw StateError(FErrorMessage.iteratorNoElement);

  void consumeFound(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) if (test(current)) return action(current);
    throw StateError(FErrorMessage.iteratorElementNotFound);
  }

  void consumeWhere(Predicator<I> test, Consumer<I> action) {
    while (moveNext()) {
      if (test(current)) action(current);
    }
  }

  ///
  /// [consumeAll]
  /// [consumeAllByIndex]
  ///
  void consumeAll(Consumer<I> consume) {
    while (moveNext()) consume(current);
  }

  void consumeAllByIndex(ConsumerIndexable<I> consume, [int start = 0]) {
    for (var i = start; moveNext(); i++) consume(current, i);
  }

  ///
  /// [consumePair]
  /// [consumePairByIndex]
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
  /// [consumeAccompany]
  /// [consumeAccompanyByIndex]
  ///
  void consumeAccompany(I value, Intersector<I> paring) {
    while (moveNext()) paring(current, value);
  }

  void consumeAccompanyByIndex(
    I value,
    IntersectorIndexable<I> paring, [
    int start = 0,
  ]) {
    for (var i = start; moveNext(); i++) paring(current, value, i);
  }

  ///
  ///
  /// apply
  /// [applyMoveNext]
  /// [applyLead]
  ///
  ///
  ///

  ///
  /// [applyMoveNext]
  /// [applyLead]
  ///
  I applyMoveNext(Applier<I> apply) => moveNext()
      ? apply(current)
      : throw StateError(FErrorMessage.iteratorNoElement);

  I applyLead(int ahead, Applier<I> apply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(FErrorMessage.iteratorNoElement);
    }
    return apply(current);
  }

  ///
  ///
  ///
  /// predication
  /// [any], [anyBy]
  ///
  /// [exist], [existTo], [existToInited]
  /// [existAny], [existAnyTo], [existAnyToEachGroup], [existAnyToEachGroupSet]
  /// [existDifferent], [existDifferentTo], [existEqual],  [existEqualTo]
  ///
  ///
  ///

  ///
  /// [any]
  /// [anyBy]
  ///
  bool any(Predicator<I> test) {
    while (moveNext()) if (test(current)) return true;
    return false;
  }

  bool anyBy<T>(T element, PredicatorMixer<T, I> test) {
    while (moveNext()) if (test(element, current)) return true;
    return false;
  }

  ///
  /// [exist]
  /// [existTo]
  /// [existToInited]
  ///
  bool exist(PredicatorFusionor<I> test) => supplyMoveNext(() {
        var val = current;
        while (moveNext()) {
          if (test(val, current)) return true;
          val = current;
        }
        return false;
      });

  bool existTo<T>(
    Mapper<I, T> toVal,
    PredicatorFusionor<T> test,
  ) =>
      supplyMoveNext(() {
        var val = toVal(current);
        while (moveNext()) {
          final v = toVal(current);
          if (test(val, v)) return true;
          val = v;
        }
        return false;
      });

  bool existToInited<T>(Mapper<I, T> toVal, PredicatorFusionor<T> test) =>
      supplyMoveNext(() {
        var val = toVal(current);
        while (moveNext()) {
          if (test(val, toVal(current))) return true;
        }
        return false;
      });

  ///
  /// [existAny]
  /// [existAnyTo]
  /// [existAnyToEachGroup]
  /// [existAnyToEachGroupSet]
  ///
  bool existAny(PredicatorFusionor<I> test) => supplyMoveNext(() {
        final list = <I>[current];
        while (moveNext()) {
          if (list.any((val) => test(val, current))) return true;
          list.add(current);
        }
        return false;
      });

  bool existAnyTo<T>(
    Mapper<I, T> toVal,
    PredicatorFusionor<T> test,
  ) =>
      supplyMoveNext(() {
        final list = <T>[toVal(current)];
        while (moveNext()) {
          final v = toVal(current);
          if (list.any((val) => test(val, v))) return true;
          list.add(v);
        }
        return false;
      });

  bool existAnyToEachGroup<K, V>(
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, V>, K, V> listen,
  ) =>
      supplyMoveNext(() {
        final map = <K, V>{toKey(current): toVal(current)};
        while (moveNext()) {
          if (listen(map, toKey(current), toVal(current))) return true;
        }
        return false;
      });

  bool existAnyToEachGroupSet<K, V>(
    Mapper<I, K> toKey,
    Mapper<I, V> toVal,
    PredicatorSynthesizer<Map<K, Set<V>>, K, V> listen,
  ) =>
      supplyMoveNext(() {
        final map = <K, Set<V>>{
          toKey(current): {toVal(current)}
        };
        while (moveNext()) {
          if (listen(map, toKey(current), toVal(current))) return true;
        }
        return false;
      });

  ///
  /// [existEvery]
  ///
  bool existEvery(PredicatorFusionor<I> expect) => supplyMoveNext(() {
        var val = current;
        while (moveNext()) {
          if (!expect(val, current)) return false;
          val = current;
        }
        return true;
      });

  ///
  /// [existDifferent], [existDifferentTo]
  /// [existEqual], [existEqualTo]
  ///
  bool get existDifferent => exist(FPredicatorFusionor.isDifferent);

  bool existDifferentTo<T>(Mapper<I, T> toId) =>
      existTo(toId, FPredicatorFusionor.isDifferent);

  bool get existEqual => existAny(FPredicatorFusionor.isEqual);

  bool existEqualTo<T>(Mapper<I, T> toId) =>
      existAnyTo(toId, FPredicatorFusionor.isEqual);

  ///
  ///
  /// [first], [last]
  ///
  /// find
  /// [find], [consumeFound]
  /// [findOrNull], [findOr]
  /// [mapFound], [mapFoundOrNull], [mapFoundOr]
  /// [indexFound], [indexFoundChecked]
  ///
  /// take
  /// [take], [takeUntil]
  /// [takeAllApply], [takeAllCompanion],
  /// [takeUntil], [takeFrom], [takeBetween]
  ///
  /// where
  /// [where], [consumeWhere]
  /// [whereUntil], [whereFrom], [whereBetween]
  /// [indexesWhere]
  /// [indexesWhereUntil], [indexesWhereFrom], [indexesWhereBetween]
  /// [indexesWhereChecked]
  /// [indexesWhereCheckedUntil], [indexesWhereCheckedFrom], [indexesWhereCheckedBetween]
  ///
  ///

  ///
  /// [first], [last]
  ///
  I get first => supplyMoveNext(() => current);

  I get last => applyMoveNext((val) {
        while (moveNext()) val = current;
        return val;
      });

  ///
  ///
  ///
  /// find / [Iterable.firstWhere]
  /// [find]
  /// [findOr], [findOrNull]
  ///
  ///
  /// reduce / [Iterable.reduce]
  /// [reduce]
  /// [reduceByIndex], [reduceBy]
  ///
  ///
  ///

  ///
  /// [find]
  /// [findOr]
  /// [findOrNull]
  ///
  I find(Predicator<I> test) {
    while (moveNext()) if (test(current)) return current;
    throw StateError(FErrorMessage.iteratorElementNotFound);
  }

  I findOr(Predicator<I> test, Supplier<I> supply) {
    while (moveNext()) if (test(current)) return current;
    return supply();
  }

  I? findOrNull(Predicator<I> test) {
    while (moveNext()) if (test(current)) return current;
    return null;
  }

  ///
  /// [reduce]
  /// [reduceByIndex], [reduceBy]
  ///
  I reduce(Reducer<I> reducing) => applyMoveNext((val) {
        while (moveNext()) val = reducing(val, current);
        return val;
      });

  I reduceByIndex(ReducerGenerator<I> reducing, [int start = 0]) =>
      applyMoveNext((val) {
        var val = current;
        for (var i = start; moveNext(); i++) val = reducing(val, current, i);
        return val;
      });

  I reduceBy<T>(
    T initialElement,
    Collector<I, T> reducing,
    Absorber<T, I> after,
  ) =>
      applyMoveNext((val) {
        var val = current;
        var ele = initialElement;
        while (moveNext()) {
          val = reducing(val, current, ele);
          ele = after(ele, current, val);
        }
        return val;
      });

  ///
  ///
  ///
  ///
  /// take / [Iterable.take]
  /// [take], [takeAll]
  /// [takeAllApply], [takeAllCompanion],
  /// [takeWhile], [takeWhileExist],
  /// [takeUntil], [takeUntilExist],
  /// [takeFrom], [takeBetween],
  ///
  /// [takeList], [takeListAll]
  /// [takeListWhile], [takeListWhileExistOnFirst],
  /// [takeListUntil], [takeListUntilExist],
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
    for (; i < count && moveNext(); i++) yield current;
    if (count > i) throw RangeError(FErrorMessage.indexOutOfBoundary);
  }

  Iterable<I> get takeAll => [for (; moveNext();) current];

  Iterable<I> get takeRemain => getCurrentOrDefault(
        (value) => [value, for (; moveNext();) current],
        Iterable.empty(),
      );

  ///
  /// [takeAllApply]
  /// [takeAllCompanion]
  ///
  Iterable<I> takeAllApply(Applier<I> apply) sync* {
    while (moveNext()) yield apply(current);
  }

  Iterable<I> takeAllCompanion<T>(T value, Companion<I, T> companion) sync* {
    while (moveNext()) yield companion(current, value);
  }

  ///
  /// [takeWhile]
  /// [takeWhileExist]
  ///
  Iterable<I> takeWhile(Predicator<I> test) sync* {
    while (moveNext()) {
      if (!test(current)) break;
      yield current;
    }
  }

  Iterable<I> takeWhileExist(
    PredicatorFusionor<I> test, [
    bool includeFirst = true,
  ]) =>
      supplyMoveNext(() sync* {
        final val = current;
        if (includeFirst) yield val;
        while (moveNext()) {
          if (!test(val, current)) break;
          yield current;
        }
      });

  ///
  /// [takeUntil]
  /// [takeUntilExist]
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
    PredicatorFusionor<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) =>
      supplyMoveNext(() sync* {
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
    Predicator<I> testStart, [
    bool includeStart = true,
  ]) sync* {
    while (moveNext()) {
      if (testStart(current)) {
        if (includeStart) yield current;
        break;
      }
    }
    while (moveNext()) yield current;
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
  /// [takeListRemain]
  ///
  List<I> takeList(int count) {
    final list = <I>[];
    var i = 0;
    for (; i < count && moveNext(); i++) list.add(current);
    if (count > i) throw RangeError(FErrorMessage.indexOutOfBoundary);
    return list;
  }

  List<I> get takeListAll => [for (; moveNext();) current];

  List<I> get takeListRemain {
    late final List<I> list;
    try {
      list = [current, for (; moveNext();) current];
    } catch (e) {
      if (!e.runtimeType.isTypeError) rethrow;
    }
    return list;
  }

  ///
  /// [takeListWhile]
  /// [takeListWhileExistOnFirst]
  ///
  List<I> takeListWhile(Predicator<I> test) =>
      [for (; moveNext() && test(current);) current];

  List<I> takeListWhileExistOnFirst(PredicatorFusionor<I> test) =>
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
    PredicatorFusionor<I> testInvalid, [
    bool includeFirstInvalid = false,
  ]) =>
      supplyMoveNext(() {
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
  /// where / [Iterable.where]
  /// [where]
  /// [whereUntil], [whereFrom], [whereBetween]
  /// [indexesWhere]
  /// [indexesWhereUntil], [indexesWhereFrom], [indexesWhereBetween]
  /// [indexesWhereChecked]
  /// [indexesWhereCheckedUntil], [indexesWhereCheckedFrom], [indexesWhereCheckedBetween]
  ///

  ///
  /// [where]
  ///
  Iterable<I> where(Predicator<I> test) sync* {
    while (moveNext()) {
      if (test(current)) yield current;
    }
  }

  ///
  /// [whereFrom]
  /// [whereBetween]
  /// [whereUntil]
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
    while (moveNext()) if (test(current)) yield current;
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
  /// skip / [Iterable.skip]
  /// [skip]
  ///
  /// sub / [List.sublist]
  /// [sub]
  ///

  ///
  /// [skip]
  /// [sub]
  ///
  Iterable<I> skip(int count) {
    var i = 0;
    for (; moveNext() && i < count; i++) {}
    if (count > i) throw RangeError(FErrorMessage.indexOutOfBoundary);
    return takeAll;
  }

  Iterable<I> sub(int start, [int? end]) sync* {
    var i = 0;
    for (; i < start && moveNext(); i++) {}

    if (end == null) {
      while (moveNext()) yield current;
      return;
    }
    for (; i < end && moveNext(); i++) yield current;
  }

  ///
  ///
  /// expand / [Iterable.expand]
  /// [expand]
  /// [expandByIndex], [expandBy], [expandWhere]
  ///
  ///

  ///
  /// [expand]
  /// [expandBy], [expandByIndex], [expandWhere]
  ///
  Iterable<I> expand(Mapper<I, Iterable<I>> expanding) sync* {
    while (moveNext()) yield* expanding(current);
  }

  Iterable<I> expandBy<T>(
    T value,
    Mixer<I, T, Iterable<I>> expanding,
  ) sync* {
    while (moveNext()) yield* expanding(current, value);
  }

  Iterable<I> expandByIndex(
    MapperGenerator<I, Iterable<I>> expanding, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) yield* expanding(current, i);
  }

  Iterable<I> expandWhere(
    Predicator<I> test,
    Mapper<I, Iterable<I>> expanding,
  ) =>
      [for (; moveNext() && test(current);) ...expanding(current)];

  ///
  ///
  ///
  /// [pairMerge]
  /// [mergeBy]
  /// [interval]
  ///
  ///
  Iterable<I> mergeBy(int split, PredicatorFusionor<I> keep) =>
      [...take(split)].iterator.pairMerge(this, keep);

  Iterable<I> interval(Reducer<I> reducing) => supplyMoveNext(() sync* {
        var previous = current;
        while (moveNext()) {
          yield reducing(previous, current);
          previous = current;
        }
      });

  ///
  ///
  /// functions that returns integers
  ///
  /// index / [List.indexWhere]
  /// [indexFound]
  /// [indexFoundChecked]
  /// [indexesWhere]
  /// [indexesWhereFrom], [indexesWhereBetween], [indexesWhereUntil]
  /// [indexesWhereChecked], [indexesWhereCheckedFrom], [indexesWhereCheckedBetween], [indexesWhereCheckedUntil]
  ///
  /// cumulate:
  /// [cumulate]
  /// [cumulateBy]
  /// [cumulateLengthNested]
  ///
  ///
  ///

  ///
  /// [indexFound]
  /// [indexFoundChecked]
  ///
  int indexFound(Predicator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current)) return i;
      i++;
    }
    throw StateError(FErrorMessage.iteratorElementNotFound);
  }

  int indexFoundChecked(PredicatorGenerator<I> test) {
    var i = 0;
    while (moveNext()) {
      if (test(current, i)) return i;
      i++;
    }
    throw StateError(FErrorMessage.iteratorElementNotFound);
  }

  ///
  /// [indexesWhere]
  ///
  Iterable<int> indexesWhere(Predicator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current)) yield i;
    }
  }

  ///
  /// [indexesWhereUntil]
  /// [indexesWhereFrom]
  /// [indexesWhereBetween]
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
  /// [indexesWhereChecked]
  ///
  Iterable<int> indexesWhereChecked(PredicatorGenerator<I> test) sync* {
    for (var i = 0; moveNext(); i++) {
      if (test(current, i)) yield i;
    }
  }

  ///
  /// [indexesWhereCheckedFrom]
  /// [indexesWhereCheckedBetween]
  /// [indexesWhereCheckedUntil]
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
  /// [cumulate]
  /// [cumulateBy]
  /// [cumulateLengthNested]
  ///
  int cumulate(Predicator<I> test) {
    var val = 0;
    while (moveNext()) if (test(current)) val++;
    return val;
  }

  int cumulateBy<T>(T value, PredicatorMixer<I, T> test) {
    var val = 0;
    while (moveNext()) if (test(current, value)) val++;
    return val;
  }

  int cumulateLengthNested<T>() => induct<int>(
        (element) => switch (element) {
          T() => 1,
          Iterable<T>() => element.length,
          Iterable<Iterable>() => element.iterator.cumulateLengthNested(),
          _ => throw StateError(FErrorMessage.iteratorElementNotNest),
        },
        IntExtension.reducePlus,
      );
}

///
///
/// iterable comes from the same iterator is not consistent.
/// ```
///   final itA = iterator.take(4);
///   print(itA); // (2, 9, 3, 7)
///   print(itA); // (1, 1, 4, 5)
/// ```
///
///
/// iterable comes from iterator only yield once,
/// ```
///   final another = [2, 5, 2, 4, 3].iterator.sub(2, 10);
///   print(another); // (2, 4, 3)
///   print(another); // ()
/// ```
///
///
/// it's necessary to store values as list
/// ```
///   final another = [...[2, 5, 2, 4, 3].iterator.sub(2, 10)];
///   print(another); // [2, 4, 3]
///   print(another); // [2, 3, 3]
/// ```
///
///
/// It's better not to get iterator from the same iterator,
/// ```
///   final list = [2, 9, 3, 7, 1, 1, 4, 5];
///   final iterator = list.iterator;
///
///   final itA = iterator.take(4).iterator;
///   final itB = iterator.take(4).iterator;
///   while (itA.moveNext() & itB.moveNext()) {
///     print('${itB.current}, ${itB.takeAll}'); // 9, (3, 7, 1)
///     print('${itA.current}, ${itA.takeAll}'); // 2, (1, 4, 5)
///   }
/// ```

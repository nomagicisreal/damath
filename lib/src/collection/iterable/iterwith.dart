part of damath_collection;

///
///
/// static methods:
/// [predicateLengthEqual], ...
///
///
/// instance methods:
/// [moveNextCompanionWith], ...
/// ---------------intersection:
/// [inter], ...
/// [interTake], ...
/// [interMap], ...
/// [interFold], ...
/// [interReduceTo], ...
/// [intersection], ...
/// ---------------difference:
/// [diff], ...
/// [diffTake], ...
/// [diffMap], ...
/// [diffFold], ...
/// [diffReduceToInitialized], ...
/// [difference]
/// ---------------others:
/// [leadThenInterFold], ...
/// [interval], ...
/// [cartesianProduct], ...
///
///
extension IteratorWithExtension<I> on Iterator<I> {
  ///
  /// [predicateLengthEqual], [predicateLengthDifferent]
  /// [predicateEqual], [predicateDifferent]
  ///
  static bool predicateLengthEqual<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length == b.length;

  static bool predicateLengthDifferent<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length != b.length;

  static bool predicateEqual<I>(Iterable<I> a, Iterable<I> b) => a.isEqualTo(b);

  static bool predicateDifferent<I>(Iterable<I> a, Iterable<I> b) =>
      a.anyElementIsDifferentWith(b);

  ///
  ///
  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  ///
  /// [moveNextWith]
  /// [moveNextCompanionWith]
  ///
  I moveNextWith(Iterator<I> another, Reducer<I> combine) =>
      moveNext() && another.moveNext()
          ? combine(current, another.current)
          : throw StateError(KErrorMessage.iteratorNoElement);

  I moveNextCompanionWith<E>(Iterator<E> another, Applier<I> apply) =>
      moveNext() && another.moveNext()
          ? apply(current)
          : throw StateError(KErrorMessage.iteratorNoElement);

  ///
  /// [inter], [interIndexable]
  /// [interAny], [interAnyTernary]
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
  /// [interTake]
  /// [interTakeOn]
  /// [interTakeCumulate]
  ///
  Iterable<I> interTake(Iterator<I> another, Reducer<I> combine) sync* {
    while (moveNext() && another.moveNext()) {
      yield combine(current, another.current);
    }
  }

  Iterable<I> interTakeOn(Iterator<bool> where) sync* {
    while (moveNext() && where.moveNext()) {
      if (where.current) current;
    }
  }

  I interTakeCumulate(
    Iterator<I> another,
    Reducer<I> combine,
    Reducer<I> reducing,
  ) =>
      moveNextWith(
        another,
        (v1, v2) {
          var val = combine(v1, v2);
          while (moveNext() && another.moveNext()) {
            val = reducing(val, combine(current, another.current));
          }
          return val;
        },
      );

  ///
  /// [interMap], [interExpandTo]
  /// [interMapWhere], [interExpandToWhere]
  /// [interMapIndexable], [interExpandToIndexable]
  /// [interMapIndexableWhere], [interExpandToIndexableWhere]
  /// [interMapList], [interExpandToList]
  /// [interMapEntry], [interExpandToEntries]
  ///

  ///
  /// [interMap]
  /// [interExpandTo]
  ///
  Iterable<S> interMap<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield mixer(current, another.current);
    }
  }

  Iterable<S> interExpandTo<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield* expanding(current, another.current);
    }
  }

  ///
  /// [interMapWhere]
  /// [interExpandToWhere]
  ///
  Iterable<S> interMapWhere<E, S>(
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

  Iterable<S> interExpandToWhere<E, S>(
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
  /// [interMapIndexable]
  /// [interMapIndexableWhere]
  ///
  Iterable<S> interMapIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> combine,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield combine(current, another.current, i);
    }
  }

  Iterable<S> interMapIndexableWhere<E, S>(
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

  ///
  /// [interExpandToIndexable]
  /// [interExpandToIndexableWhere]
  ///
  Iterable<S> interExpandToIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> combine,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield* combine(current, another.current, i);
    }
  }

  Iterable<S> interExpandToIndexableWhere<E, S>(
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
  /// [interMapList]
  /// [interExpandToList]
  ///
  List<S> interMapList<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
  ) =>
      [
        for (; moveNext() && another.moveNext();)
          mixer(current, another.current)
      ];

  List<S> interExpandToList<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) =>
      [
        for (; moveNext() && another.moveNext();)
          ...expanding(current, another.current)
      ];

  ///
  /// [interMapEntry]
  /// [interExpandToEntries]
  ///
  Iterable<MapEntry<I, E>> interMapEntry<E>(Iterator<E> values) sync* {
    while (moveNext() && values.moveNext()) {
      yield MapEntry(current, values.current);
    }
  }

  Iterable<MapEntry<I, E>> interExpandToEntries<E>(
    Iterator<E> values,
    Mixer<I, E, Iterable<MapEntry<I, E>>> mixer,
  ) sync* {
    while (moveNext() && values.moveNext()) {
      yield* mixer(current, values.current);
    }
  }

  ///
  /// [interFold], [interFoldIndexable]
  ///

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
  /// [interReduce]
  /// [interReduceTo], [interReduceToIndexable]
  /// [interReduceToInitialized], [interReduceToInitializedIndexable]
  /// [interReduceInitialized], [interReduceInitializedIndexable]
  ///

  ///
  /// [interReduce]
  ///
  I interReduce(Iterator<I> another, Reducer<I> combine) => moveNextWith(
        another,
        (v1, v2) {
          var val = combine(v1, v2);
          while (moveNext()) {
            val = combine(current, another.current);
          }
          return val;
        },
      );

  ///
  /// [interReduceTo]
  /// [interReduceToIndexable]
  ///
  S interReduceTo<E, S>(
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    Collapser<S> mutual,
  ) =>
      moveNextSupplyWith(another, () {
        var val = init(toVal(current), toValAnother(another.current));
        while (moveNext() && another.moveNext()) {
          val = mutual(val, toVal(current), toValAnother(another.current));
        }
        return val;
      });

  S interReduceToIndexable<E, S>(
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    CollapserGenerator<S> mutual,
    int start,
  ) =>
      moveNextSupplyWith(another, () {
        var val = init(toVal(current), toValAnother(another.current));
        for (var i = start + 1; moveNext() && another.moveNext(); i++) {
          val = mutual(val, toVal(current), toValAnother(another.current), i);
        }
        return val;
      });

  ///
  /// [interReduceToInitialized]
  /// [interReduceToInitializedIndexable]
  ///
  S interReduceToInitialized<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
  ) =>
      moveNextSupplyWith(another, () {
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
      moveNextSupplyWith(another, () {
        var val = init(current, another.current, start);
        for (var i = start + 1; moveNext() && another.moveNext(); i++) {
          val = mutual(val, current, another.current, i);
        }
        return val;
      });

  ///
  /// [interReduceInitialized]
  /// [interReduceInitializedIndexable]
  ///
  I interReduceInitialized(
          Iterator<I> another, Reducer<I> init, Collapser<I> mutual) =>
      interReduceToInitialized(another, init, mutual);

  I interReduceInitializedIndexable(
    Iterator<I> another,
    ReducerGenerator<I> init,
    CollapserGenerator<I> mutual,
    int start,
  ) =>
      interReduceToInitializedIndexable(another, init, mutual, start);

  ///
  /// [intersection], [intersectionIndex], [intersectionDetail]
  ///

  ///
  /// [intersection]
  /// [intersectionIndex]
  /// [intersectionDetail]
  ///
  Iterable<I> intersection(Iterable<I> another) => interMapWhere(
        another.iterator,
        FPredicatorCombiner.isEqual,
        FKeep.reduceV1,
      );

  Iterable<int> intersectionIndex(Iterable<I> another, [int start = 0]) =>
      interMapIndexableWhere(
        another.iterator,
        FPredicatorCombiner.isEqual,
        (p, q, index) => index,
        start,
      );

  Map<int, I> intersectionDetail(Iterable<I> another) => interFoldIndexable(
        {},
        another.iterator,
        (map, v1, v2, index) => map..putIfAbsentWhen(v1 == v2, index, () => v1),
        0,
      );

  ///
  ///
  ///
  ///
  /// difference
  ///
  ///
  ///
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
  ///
  /// [diffTake]
  ///
  ///
  Iterable<I> diffTake(
    Iterator<I> another,
    PredicatorCombiner<I> test,
    Reducer<I> reducing,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext() && test(current, another.current)) {
        yield reducing(current, another.current);
      }
    }
    while (moveNext()) {
      yield current;
    }
  }

  Iterable<I> diffTakeByIndex(
    Iterator<I> another,
    PredicatorCombiner<I> test,
    ReducerGenerator<I> reducing, [
    int start = 0,
  ]) sync* {
    var i = start;
    for (; another.moveNext(); i++) {
      if (moveNext() && test(current, another.current)) {
        yield reducing(current, another.current, i);
      }
    }
    while (moveNext()) {
      yield current;
    }
  }

  ///
  /// [diffMap], [diffExpandTo]
  /// [diffMapWhere], [diffExpandWhere]
  /// [diffMapByIndex], [diffExpandToIndexable]
  /// [diffMapByIndexWhere], [diffExpandToIndexableWhere]
  /// [diffMapEntry], [diffExpandToEntries]
  ///

  ///
  /// [diffMap]
  /// [diffMapWhere]
  ///
  Iterable<S> diffMap<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> mixer,
    Mapper<I, S> overflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext()) yield mixer(current, another.current);
    }
    while (moveNext()) {
      yield overflow(current);
    }
  }

  Iterable<S> diffMapWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, S> mixer,
    Mapper<I, S> overflow,
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

  ///
  /// [diffExpandTo]
  /// [diffExpandWhere]
  ///
  Iterable<S> diffExpandTo<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> mixer,
    Mapper<I, Iterable<S>> overflow,
  ) sync* {
    while (another.moveNext()) {
      if (moveNext()) yield* mixer(current, another.current);
    }
    while (moveNext()) {
      yield* overflow(current);
    }
  }

  Iterable<S> diffExpandWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, Iterable<S>> mixer,
    Mapper<I, Iterable<S>> overflow,
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
  /// [diffMapByIndex]
  /// [diffMapByIndexWhere]
  ///
  Iterable<S> diffMapByIndex<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> mixer,
    MapperGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffMap(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffMapByIndexWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, S> mixer,
    MapperGenerator<I, S> overflow, [
    int start = 0,
  ]) sync* {
    var i = start;
    for (; another.moveNext(); i++) {
      if (moveNext() && test(current, another.current)) {
        yield mixer(current, another.current, i);
      }
    }
    while (moveNext()) {
      yield overflow(current, ++i);
    }
  }

  Iterable<S> diffExpandToIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> mixer,
    MapperGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffExpandTo(
      another,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  ///
  /// [diffExpandToIndexable]
  /// [diffExpandToIndexableWhere]
  ///
  Iterable<S> diffExpandToIndexableWhere<E, S>(
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    MixerGenerator<I, E, Iterable<S>> mixer,
    MapperGenerator<I, Iterable<S>> overflow,
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
  /// [diffMapEntry]
  /// [diffExpandToEntries]
  ///
  Iterable<MapEntry<I, V>> diffMapEntry<V>(
    Iterator<V> values,
    Mapper<I, MapEntry<I, V>> overflow,
    int start,
  ) =>
      diffMap(values, (p, q) => MapEntry(p, q), overflow);

  Iterable<MapEntry<I, V>> diffExpandToEntries<V>(
    Iterator<V> values,
    Mixer<I, V, Iterable<MapEntry<I, V>>> mixer,
    Mapper<I, Iterable<MapEntry<I, V>>> overflow,
    int start,
  ) =>
      diffExpandTo(values, mixer, overflow);

  ///
  ///
  ///
  /// [diffFold], [diffFoldIndexable]
  ///
  ///
  ///

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
  ///
  /// [diffReduceToInitialized], [diffReduceToInitializedIndexable]
  /// [diffReduce], [diffReduceIndexable]
  ///
  ///

  ///
  /// [diffReduceToInitialized]
  /// [diffReduceToInitializedIndexable]
  ///
  S diffReduceToInitialized<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      moveNextSupplyWith(another, () {
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
      moveNextSupplyWith(another, () {
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

  ///
  /// [diffReduce]
  /// [diffReduceIndexable]
  ///
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
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  ///
  /// [difference]
  /// [differenceIndex]
  /// [differenceDetail]
  ///
  Iterable<I> difference(Iterable<I> another) => diffTake(
        another.iterator,
        FPredicatorCombiner.isDifferent,
        FKeep.reduceV1,
      );

  Iterable<int> differenceIndex(Iterable<I> another, [int start = 0]) =>
      diffMapByIndexWhere(
        another.iterator,
        FPredicatorCombiner.isDifferent,
        (p, q, index) => index,
        (value, index) => index,
        start,
      );

  ///
  /// [MapEntry.key] is the value in this instance that different with [another]
  /// [MapEntry.value] is the value in [another] that different with this instance
  ///
  Map<int, MapEntry<I, I?>> differenceDetail(Iterable<I> another) =>
      diffFoldIndexable(
        {},
        another.iterator,
        (map, e1, e2, index) =>
            map..putIfAbsentWhen(e1 != e2, index, () => MapEntry(e1, e2)),
        (map, e1, index) => map..putIfAbsent(index, () => MapEntry(e1, null)),
        0,
      );

  ///
  /// lead then
  /// [leadThenInterFold]
  /// [leadThenDiffFold]
  ///

  ///
  /// [leadThenInterFold]
  /// [leadThenDiffFold]
  ///
  S leadThenInterFold<E, S>(
    int ahead,
    Mapper<I, S> init,
    Iterator<E> another,
    Collector<S, I, E> mutual,
  ) =>
      leadSupply(ahead, () => interFold(init(current), another, mutual));

  S leadThenDiffFold<E, S>(
    int ahead,
    Mapper<I, S> init,
    Iterator<E> another,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      leadSupply(
        ahead,
        () => diffFold(init(current), another, mutual, overflow),
      );

  ///
  /// interval
  /// [interval]
  /// [intervalBy]
  ///

  ///
  /// [interval]
  /// [intervalBy]
  ///
  Iterable<I> interval(Reducer<I> combine) => moveNextSupply(() sync* {
        var previous = current;
        while (moveNext()) {
          yield combine(previous, current);
          previous = current;
        }
      });

  ///
  /// [intervalBy] for example:
  ///   final general = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  ///   final interval = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  ///   print(general.iterator.[intervalBy]
  ///   (
  ///     interval,
  ///     (v1, v2, other) => (v1 + v2) / 2 + another,
  ///   ));
  ///   // (16.0, 27.0, 38.0, 49.0, 60.0, 71.0, 82.0, 93.0, 104.0)
  ///
  Iterable<S> intervalBy<T, S>(Iterator<T> interval, Linker<I, T, S> link) =>
      moveNextSupply(() sync* {
        var previous = current;
        while (moveNext() && interval.moveNext()) {
          yield link(previous, current, interval.current);
          previous = current;
        }
      });

  ///
  /// [cartesianProduct]
  /// [cartesianProductFlatted]
  ///

  ///
  /// listA = [1, 2, 3];
  /// listB = [101, 102];
  /// result = [cartesianProduct] ([listA, listB]);
  /// print(result); // [
  ///   [MapEntry(1, 101), MapEntry(1, 102)],
  ///   [MapEntry(2, 101), MapEntry(2, 102)],
  ///   [MapEntry(3, 101), MapEntry(3, 102)],
  /// }
  ///
  Iterable<Iterable<(I, V)>> cartesianProduct<V>(Iterator<V> another) =>
      map(another.mapToRecordBy1);

  Iterable<(I, V)> cartesianProductFlatted<V>(Iterator<V> another) =>
      mapExpand(another.mapToRecordBy1);
}

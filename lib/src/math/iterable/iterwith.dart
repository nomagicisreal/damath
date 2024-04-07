part of damath_math;

///
/// intersection:
/// [inter], ...
/// [interYieldingTo], ...
/// [interFold], ...
/// [interReduceTo], ...
/// [intersection], ...
///
/// difference:
/// [diff], ...
/// [diffYieldingTo], ...
/// [diffFold], ...
/// [diffReduceToInitialized], ...
/// [difference]
///
/// others:
/// [leadThenInterFold], ...
/// [interval], ...
/// [combinationsWith], ...
///
///
extension IteratorWithExtension<I> on Iterator<I> {
  ///
  /// [inter], [interIndexable]
  /// [interAny], [interAnyTernary]
  /// [interYieldingOn], [interYieldingApply]
  ///

  ///
  /// [inter]
  /// [interIndexable]
  ///
  void inter<E>(Iterator<E> other, Intersector<I, E> mutual) {
    while (moveNext() && other.moveNext()) {
      mutual(current, other.current);
    }
  }

  void interIndexable<E>(
    Iterator<E> other,
    IntersectorIndexable<I, E> mutual,
    int start,
  ) {
    var i = start - 1;
    while (moveNext() && other.moveNext()) {
      mutual(current, other.current, ++i);
    }
  }

  ///
  /// [interAny]
  /// [interAnyTernary]
  ///
  bool interAny<E>(Iterator<E> other, PredicatorMixer<I, E> test) {
    while (moveNext() && other.moveNext()) {
      if (test(current, other.current)) return true;
    }
    return false;
  }

  bool interAnyTernary<E>(
    Iterator<E> other,
    Differentiator<I, E> differentiate, [
    int except = 0,
  ]) {
    while (moveNext() && other.moveNext()) {
      if (differentiate(current, other.current) == except) return true;
    }
    return false;
  }

  ///
  /// [interYieldingOn]
  /// [interYieldingApply]
  ///
  Iterable<I> interYieldingOn(Iterator<bool> where) sync* {
    while (moveNext() && where.moveNext()) {
      if (where.current) current;
    }
  }

  Iterable<I> interYieldingApply(Iterator<I> other, Reducer<I> reducing) sync* {
    while (moveNext() && other.moveNext()) {
      yield reducing(current, other.current);
    }
  }

  ///
  /// [interYieldingTo], [interExpandTo]
  /// [interYieldingToWhere], [interExpandToWhere]
  /// [interYieldingToIndexable], [interExpandToIndexable]
  /// [interYieldingToIndexableWhere], [interExpandToIndexableWhere]
  /// [interYieldingToList], [interExpandToList]
  /// [interYieldingToEntry], [interExpandToEntries]
  ///

  ///
  /// [interYieldingTo]
  /// [interExpandTo]
  ///
  Iterable<S> interYieldingTo<E, S>(
    Iterator<E> other,
    Mixer<I, E, S> mixer,
  ) sync* {
    while (moveNext() && other.moveNext()) {
      yield mixer(current, other.current);
    }
  }

  Iterable<S> interExpandTo<E, S>(
    Iterator<E> other,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && other.moveNext()) {
      yield* expanding(current, other.current);
    }
  }

  ///
  /// [interYieldingToWhere]
  /// [interExpandToWhere]
  ///
  Iterable<S> interYieldingToWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Mixer<I, E, S> mixer,
  ) sync* {
    while (moveNext() && other.moveNext()) {
      if (test(current, other.current)) {
        yield mixer(current, other.current);
      }
    }
  }

  Iterable<S> interExpandToWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && other.moveNext()) {
      if (test(current, other.current)) {
        yield* expanding(current, other.current);
      }
    }
  }

  ///
  /// [interYieldingToIndexable]
  /// [interYieldingToIndexableWhere]
  ///
  Iterable<S> interYieldingToIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, S> combine,
    int start,
  ) sync* {
    for (var i = start; moveNext() && other.moveNext(); i++) {
      yield combine(current, other.current, i);
    }
  }

  Iterable<S> interYieldingToIndexableWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, S> mixer,
    int start,
  ) sync* {
    for (var i = start; moveNext() && other.moveNext(); i++) {
      if (test(current, other.current)) {
        yield mixer(current, other.current, i);
      }
    }
  }

  ///
  /// [interExpandToIndexable]
  /// [interExpandToIndexableWhere]
  ///
  Iterable<S> interExpandToIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, Iterable<S>> combine,
    int start,
  ) sync* {
    for (var i = start; moveNext() && other.moveNext(); i++) {
      yield* combine(current, other.current, i);
    }
  }

  Iterable<S> interExpandToIndexableWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, Iterable<S>> expanding,
    int start,
  ) sync* {
    for (var i = start; moveNext() && other.moveNext(); i++) {
      if (test(current, other.current)) {
        yield* expanding(current, other.current, i);
      }
    }
  }

  ///
  /// [interYieldingToList]
  /// [interExpandToList]
  ///
  List<S> interYieldingToList<E, S>(
    Iterator<E> other,
    Mixer<I, E, S> mixer,
  ) =>
      [for (; moveNext() && other.moveNext();) mixer(current, other.current)];

  List<S> interExpandToList<E, S>(
    Iterator<E> other,
    Mixer<I, E, Iterable<S>> expanding,
  ) =>
      [
        for (; moveNext() && other.moveNext();)
          ...expanding(current, other.current)
      ];

  ///
  /// [interYieldingToEntry]
  /// [interExpandToEntries]
  ///
  Iterable<MapEntry<I, E>> interYieldingToEntry<E>(Iterator<E> values) sync* {
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
    Iterator<E> other,
    Collector<S, I, E> mutual,
  ) {
    var val = initialValue;
    while (moveNext() && other.moveNext()) {
      val = mutual(val, current, other.current);
    }
    return val;
  }

  S interFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> other,
    CollectorGenerator<S, I, E> mutual,
    int start,
  ) {
    var val = initialValue;
    for (var i = start; moveNext() && other.moveNext(); i++) {
      val = mutual(val, current, other.current, i);
    }
    return val;
  }

  ///
  /// [interReduceTo], [interReduceToIndexable]
  /// [interReduceToInitialized], [interReduceToInitializedIndexable]
  /// [interReduce], [interReduceIndexable]
  ///

  ///
  /// [interReduceTo]
  /// [interReduceToIndexable]
  ///
  S interReduceTo<E, S>(
    Iterator<E> other,
    Mapper<I, S> toVal,
    Mapper<E, S> toValother,
    Reducer<S> init,
    Collapser<S> mutual,
  ) =>
      moveNextSupplyWith(other, () {
        var val = init(toVal(current), toValother(other.current));
        while (moveNext() && other.moveNext()) {
          val = mutual(val, toVal(current), toValother(other.current));
        }
        return val;
      });

  S interReduceToIndexable<E, S>(
    Iterator<E> other,
    Mapper<I, S> toVal,
    Mapper<E, S> toValother,
    Reducer<S> init,
    CollapserGenerator<S> mutual,
    int start,
  ) =>
      moveNextSupplyWith(other, () {
        var val = init(toVal(current), toValother(other.current));
        for (var i = start + 1; moveNext() && other.moveNext(); i++) {
          val = mutual(val, toVal(current), toValother(other.current), i);
        }
        return val;
      });

  ///
  /// [interReduceToInitialized]
  /// [interReduceToInitializedIndexable]
  ///
  S interReduceToInitialized<E, S>(
    Iterator<E> other,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
  ) =>
      moveNextSupplyWith(other, () {
        var val = init(current, other.current);
        while (moveNext() && other.moveNext()) {
          val = mutual(val, current, other.current);
        }
        return val;
      });

  S interReduceToInitializedIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, S> init,
    CollectorGenerator<S, I, E> mutual,
    int start,
  ) =>
      moveNextSupplyWith(other, () {
        var val = init(current, other.current, start);
        for (var i = start + 1; moveNext() && other.moveNext(); i++) {
          val = mutual(val, current, other.current, i);
        }
        return val;
      });

  ///
  /// [interReduce]
  /// [interReduceIndexable]
  ///
  I interReduce(Iterator<I> other, Reducer<I> init, Collapser<I> mutual) =>
      interReduceToInitialized(other, init, mutual);

  I interReduceIndexable(
    Iterator<I> other,
    ReducerGenerator<I> init,
    CollapserGenerator<I> mutual,
    int start,
  ) =>
      interReduceToInitializedIndexable(other, init, mutual, start);

  ///
  /// [intersection], [intersectionIndex], [intersectionDetail]
  ///

  ///
  /// [intersection]
  /// [intersectionIndex]
  /// [intersectionDetail]
  ///
  Iterable<I> intersection(Iterable<I> another) => interYieldingToWhere(
        another.iterator,
        FPredicatorCombiner.isEqual,
        FReducer.keepV1,
      );

  Iterable<int> intersectionIndex(Iterable<I> another, [int start = 0]) =>
      interYieldingToIndexableWhere(
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
    Iterator<E> other,
    Intersector<I, E> mutual,
    Consumer<I> overflow,
  ) {
    while (other.moveNext()) {
      if (moveNext()) mutual(current, other.current);
    }
    while (moveNext()) {
      overflow(current);
    }
  }

  void diffIndexable<E>(
    Iterator<E> other,
    IntersectorIndexable<I, E> mutual,
    ConsumerIndexable<I> overflow,
    int start,
  ) {
    var i = start - 1;
    while (other.moveNext()) {
      if (moveNext()) mutual(current, other.current, ++i);
    }
    while (moveNext()) {
      overflow(current, ++i);
    }
  }

  ///
  /// [diffYieldingTo], [diffExpandTo]
  /// [diffYieldingToWhere], [diffExpandWhere]
  /// [diffYieldingToIndexable], [diffExpandToIndexable]
  /// [diffYieldingToIndexableWhere], [diffExpandToIndexableWhere]
  /// [diffYieldingToEntry], [diffExpandToEntries]
  ///

  ///
  /// [diffYieldingTo]
  /// [diffYieldingToWhere]
  ///
  Iterable<S> diffYieldingTo<E, S>(
    Iterator<E> other,
    Mixer<I, E, S> mixer,
    Mapper<I, S> overflow,
  ) sync* {
    while (other.moveNext()) {
      if (moveNext()) yield mixer(current, other.current);
    }
    while (moveNext()) {
      yield overflow(current);
    }
  }

  Iterable<S> diffYieldingToWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, S> mixer,
    Mapper<I, S> overflow,
  ) sync* {
    while (other.moveNext()) {
      if (moveNext() && test(current, other.current)) {
        yield mixer(current, other.current);
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
    Iterator<E> other,
    Mixer<I, E, Iterable<S>> mixer,
    Mapper<I, Iterable<S>> overflow,
  ) sync* {
    while (other.moveNext()) {
      if (moveNext()) yield* mixer(current, other.current);
    }
    while (moveNext()) {
      yield* overflow(current);
    }
  }

  Iterable<S> diffExpandWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    Mixer<I, E, Iterable<S>> mixer,
    Mapper<I, Iterable<S>> overflow,
  ) sync* {
    while (other.moveNext()) {
      if (moveNext() && test(current, other.current)) {
        yield* mixer(current, other.current);
      }
    }
    while (moveNext()) {
      if (testOverflow(current)) yield* overflow(current);
    }
  }

  ///
  /// [diffYieldingToIndexable]
  /// [diffYieldingToIndexableWhere]
  ///
  Iterable<S> diffYieldingToIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, S> mixer,
    MapperGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYieldingTo(
      other,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffYieldingToIndexableWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    MixerGenerator<I, E, S> mixer,
    MapperGenerator<I, S> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffYieldingToWhere(
      other,
      test,
      testOverflow,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  Iterable<S> diffExpandToIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, Iterable<S>> mixer,
    MapperGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffExpandTo(
      other,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  ///
  /// [diffExpandToIndexable]
  /// [diffExpandToIndexableWhere]
  ///
  Iterable<S> diffExpandToIndexableWhere<E, S>(
    Iterator<E> other,
    PredicatorMixer<I, E> test,
    Predicator<I> testOverflow,
    MixerGenerator<I, E, Iterable<S>> mixer,
    MapperGenerator<I, Iterable<S>> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffExpandWhere(
      other,
      test,
      testOverflow,
      (p, q) => mixer(p, q, ++i),
      (value) => overflow(value, ++i),
    );
  }

  ///
  /// [diffYieldingToEntry]
  /// [diffExpandToEntries]
  ///
  Iterable<MapEntry<I, V>> diffYieldingToEntry<V>(
    Iterator<V> values,
    Mapper<I, MapEntry<I, V>> overflow,
    int start,
  ) =>
      diffYieldingTo(values, (p, q) => MapEntry(p, q), overflow);

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
    Iterator<E> other,
    Collector<S, I, E> companion,
    Companion<S, I> overflow,
  ) {
    var val = initialValue;
    while (other.moveNext()) {
      if (moveNext()) val = companion(val, current, other.current);
    }
    while (moveNext()) {
      val = overflow(val, current);
    }
    return val;
  }

  S diffFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> other,
    CollectorGenerator<S, I, E> companion,
    CompanionGenerator<S, I> overflow,
    int start,
  ) {
    var i = start - 1;
    return diffFold(
      initialValue,
      other,
      (value, a, b) => companion(value, a, b, ++i),
      (origin, other) => overflow(origin, other, ++i),
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
    Iterator<E> other,
    Mixer<I, E, S> init,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      moveNextSupplyWith(other, () {
        var val = init(current, other.current);
        while (other.moveNext()) {
          if (moveNext()) val = mutual(val, current, other.current);
        }
        while (moveNext()) {
          val = overflow(val, current);
        }
        return val;
      });

  S diffReduceToInitializedIndexable<E, S>(
    Iterator<E> other,
    MixerGenerator<I, E, S> init,
    CollectorGenerator<S, I, E> mutual,
    CompanionGenerator<S, I> overflow,
    int start,
  ) =>
      moveNextSupplyWith(other, () {
        var i = start - 1;
        var val = init(current, other.current, ++i);
        while (other.moveNext()) {
          if (moveNext()) val = mutual(val, current, other.current, ++i);
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
    Iterator<I> other,
    Reducer<I> init,
    Collapser<I> mutual,
    Reducer<I> overflow,
  ) =>
      diffReduceToInitialized(other, init, mutual, overflow);

  I diffReduceIndexable(
    Iterator<I> other,
    ReducerGenerator<I> init,
    CollapserGenerator<I> mutual,
    ReducerGenerator<I> overflow,
    int start,
  ) =>
      diffReduceToInitializedIndexable(other, init, mutual, overflow, start);

  ///
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  ///
  /// [difference]
  /// [differenceIndex]
  /// [differenceDetail]
  ///
  Iterable<I> difference(Iterable<I> another) => diffYieldingToWhere(
        another.iterator,
        FPredicatorCombiner.isDifferent,
        FPredicator.alwaysTrue,
        FReducer.keepV1,
        FApplier.keep,
      );

  Iterable<int> differenceIndex(Iterable<I> another, [int start = 0]) =>
      diffYieldingToIndexableWhere(
        another.iterator,
        FPredicatorCombiner.isDifferent,
        FPredicator.alwaysTrue,
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
    Iterator<E> other,
    Collector<S, I, E> mutual,
  ) =>
      leadSupply(ahead, () => interFold(init(current), other, mutual));

  S leadThenDiffFold<E, S>(
    int ahead,
    Mapper<I, S> init,
    Iterator<E> other,
    Collector<S, I, E> mutual,
    Companion<S, I> overflow,
  ) =>
      leadSupply(
        ahead,
        () => diffFold(init(current), other, mutual, overflow),
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
  Iterable<I> interval(Reducer<I> reducing) => moveNextSupply(() sync* {
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
      moveNextSupply(() sync* {
        var previous = current;
        while (moveNext() && interval.moveNext()) {
          yield link(previous, current, interval.current);
          previous = current;
        }
      });

  ///
  /// combination
  /// [combinationsWith]
  ///

  ///
  /// listA = [1, 2, 3];
  /// listB = [101, 102];
  /// result = [combinationsWith] ([listA, listB]);
  /// print(result); // [
  ///   [MapEntry(1, 101), MapEntry(1, 102)],
  ///   [MapEntry(2, 101), MapEntry(2, 102)],
  ///   [MapEntry(3, 101), MapEntry(3, 102)],
  /// }
  ///
  Iterable<Iterable<MapEntry<I, V>>> combinationsWith<V>(Iterator<V> another) =>
      map(another.mapToEntriesByKey);
}

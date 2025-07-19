part of '../collection.dart';

///
///
/// [moveNextTogetherReduce], ...
///
/// [pair], ...
///   |- [pairAny], ...(predication)
///   |- [pairFold], ...(fold, collapse, force)
///   |- [pairMap], ...(to [Iterable]/[List]/[Map]...)
///       |- [pairFollowMapWhereIndexable], ...
///       |
///       |- [pairMerge], ...
///       |- [pairInterval], ...
///       |
///       |- [intersection], ...
///       |     |- [interReduce], ...
///       |
///       |- [combination2FromFirst], ...
///
/// [sandwich], ...
///
///
///
extension IteratorTogether<I> on Iterator<I> {
  ///
  /// [moveNextTogetherReduce]
  /// [moveNextTogetherSupply]
  /// [moveNextTogetherCompanion]
  ///
  static I moveNextTogetherReduce<I>(
    Iterator<I> iterator,
    Iterator<I> another,
    Reducer<I> reducing,
  ) =>
      iterator.moveNext() && another.moveNext()
          ? reducing(iterator.current, another.current)
          : throw StateError(Erroring.iterableNoElement);

  static I moveNextTogetherCompanion<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    Companion<I, E> companion,
  ) =>
      iterator.moveNext() && another.moveNext()
          ? companion(iterator.current, another.current)
          : throw StateError(Erroring.iterableNoElement);

  static S moveNextTogetherSupply<I, T, S>(
    Iterator<I> iterator,
    Iterator<T> another,
    Supplier<S> supply,
  ) =>
      iterator.moveNext() && another.moveNext()
          ? supply()
          : throw StateError(Erroring.iterableNoElement);

  ///
  /// [pair]
  /// [pairIndexable]
  ///
  static void pair<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    Pairitor<I, E> mutual,
  ) {
    while (iterator.moveNext() && another.moveNext()) {
      mutual(iterator.current, another.current);
    }
  }

  static void pairIndexable<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    PairitorIndexable<I, E> mutual,
    int start,
  ) {
    for (var i = start; iterator.moveNext() && another.moveNext(); i++) {
      mutual(iterator.current, another.current, i);
    }
  }

  ///
  /// [pairFollow]
  /// [pairFollowIndexable]
  ///
  static void pairFollow<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    Pairitor<I, E> mutual,
    Consumer<I> overflow,
  ) {
    while (another.moveNext()) {
      if (iterator.moveNext()) mutual(iterator.current, another.current);
    }
    while (iterator.moveNext()) {
      overflow(iterator.current);
    }
  }

  static void pairFollowIndexable<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    PairitorIndexable<I, E> mutual,
    ConsumerIndexable<I> overflow,
    int start,
  ) {
    var i = start - 1;
    while (another.moveNext()) {
      if (iterator.moveNext()) mutual(iterator.current, another.current, ++i);
    }
    while (iterator.moveNext()) {
      overflow(iterator.current, ++i);
    }
  }

  ///
  /// [pairAny]
  ///
  static bool pairAny<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    PredicatorMixer<I, E> test,
  ) {
    while (iterator.moveNext() && another.moveNext()) {
      if (test(iterator.current, another.current)) return true;
    }
    return false;
  }

  ///
  ///
  ///
  /// to val
  ///
  ///
  ///
  ///
  ///
  /// fold, collapse, force
  ///
  static S pairFold<I, E, S>(
    Iterator<I> iterator,
    S initialValue,
    Iterator<E> another,
    Forcer<S, I, E> mutual,
  ) {
    var val = initialValue;
    while (iterator.moveNext() && another.moveNext()) {
      val = mutual(val, iterator.current, another.current);
    }
    return val;
  }

  static S pairFoldIndexable<I, E, S>(
    Iterator<I> iterator,
    S initialValue,
    Iterator<E> another,
    ForcerGenerator<S, I, E> mutual,
    int start,
  ) {
    var val = initialValue;
    for (var i = start; iterator.moveNext() && another.moveNext(); i++) {
      val = mutual(val, iterator.current, another.current, i);
    }
    return val;
  }

  ///
  ///
  ///
  static S pairCollapse<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    Collapser<S> mutual,
  ) => moveNextTogetherSupply(iterator, another, () {
    var val = init(toVal(iterator.current), toValAnother(another.current));
    while (iterator.moveNext() && another.moveNext()) {
      val = mutual(val, toVal(iterator.current), toValAnother(another.current));
    }
    return val;
  });

  static S pairCollapseIndexable<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    CollapserGenerator<S> mutual,
    int start,
  ) => moveNextTogetherSupply(iterator, another, () {
    var val = init(toVal(iterator.current), toValAnother(another.current));
    for (var i = start + 1; iterator.moveNext() && another.moveNext(); i++) {
      val = mutual(
        val,
        toVal(iterator.current),
        toValAnother(another.current),
        i,
      );
    }
    return val;
  });

  ///
  ///
  ///
  static S pairForcer<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, S> init,
    Forcer<S, I, E> mutual,
  ) => moveNextTogetherSupply(iterator, another, () {
    var val = init(iterator.current, another.current);
    while (iterator.moveNext() && another.moveNext()) {
      val = mutual(val, iterator.current, another.current);
    }
    return val;
  });

  static S pairForcerIndexable<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, S> init,
    ForcerGenerator<S, I, E> mutual,
    int start,
  ) => moveNextTogetherSupply(iterator, another, () {
    var val = init(iterator.current, another.current);
    for (var i = start; iterator.moveNext() && another.moveNext();) {
      val = mutual(val, iterator.current, another.current, ++i);
    }
    return val;
  });

  ///
  /// follow
  ///
  static S followFoldIndexable<I, E, S>(
    Iterator<I> iterator,
    S initialValue,
    Iterator<E> another,
    ForcerGenerator<S, I, E> mutual,
    CompanionGenerator<S, I> overflow,
    int start,
  ) {
    var val = initialValue;
    var i = start;
    while (another.moveNext()) {
      if (iterator.moveNext()) {
        val = mutual(val, iterator.current, another.current, ++i);
      }
    }
    while (iterator.moveNext()) {
      val = overflow(val, iterator.current, ++i);
    }
    return val;
  }

  ///
  ///
  ///
  /// to iterable
  ///
  ///
  ///
  ///
  static Iterable<I> pairTake<I, E>(
    Iterator<I> iterator,
    Iterator<E> another,
    Companion<I, E> companion,
  ) sync* {
    while (iterator.moveNext() && another.moveNext()) {
      yield companion(iterator.current, another.current);
    }
  }

  ///
  ///
  ///
  static Iterable<S> pairMap<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, S> mixer,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      mixer(iterator.current, another.current),
  ];

  static Iterable<S> pairMapWhere<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Mixer<I, E, S> mixer,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      if (test(iterator.current, another.current))
        mixer(iterator.current, another.current),
  ];

  static Iterable<S> pairMapIndexable<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    MixerGenerator<I, E, S> mix,
    int start,
  ) => [
    for (var i = start; iterator.moveNext() && another.moveNext(); i++)
      mix(iterator.current, another.current, i),
  ];

  static Iterable<S> pairMapIndexableWhere<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, S> mixer,
    int start,
  ) => [
    for (var i = start; iterator.moveNext() && another.moveNext(); i++)
      if (test(iterator.current, another.current))
        mixer(iterator.current, another.current, i),
  ];

  static List<S> pairMapList<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, S> mixer,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      mixer(iterator.current, another.current),
  ];

  ///
  /// expand
  ///
  static Iterable<S> pairExpand<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      ...expanding(iterator.current, another.current),
  ];

  static Iterable<S> pairExpandWhere<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    Mixer<I, E, Iterable<S>> expanding,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      if (test(iterator.current, another.current))
        ...expanding(iterator.current, another.current),
  ];

  static Iterable<S> pairExpandIndexable<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> mix,
    int start,
  ) => [
    for (var i = start; iterator.moveNext() && another.moveNext(); i++)
      ...mix(iterator.current, another.current, i),
  ];

  static Iterable<S> pairExpandIndexableWhere<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    PredicatorMixer<I, E> test,
    MixerGenerator<I, E, Iterable<S>> expanding,
    int start,
  ) => [
    for (var i = start; iterator.moveNext() && another.moveNext(); i++)
      if (test(iterator.current, another.current))
        ...expanding(iterator.current, another.current, i),
  ];

  static List<S> pairExpandList<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) => [
    for (; iterator.moveNext() && another.moveNext();)
      ...expanding(iterator.current, another.current),
  ];

  ///
  /// [pairFollowMapWhereIndexable]
  ///
  static Iterable<S> pairFollowMapWhereIndexable<I, E, S>(
    Iterator<I> iterator,
    Iterator<E> another,
    MixerGenerator<I, E, S> mutual,
    MapperGenerator<I, S> overflow,
    PredicatorMixer<I, E> test,
    int start, [
    bool includeTrailing = true,
  ]) sync* {
    var i = start;
    for (; another.moveNext(); i++) {
      if (iterator.moveNext() && test(iterator.current, another.current)) {
        yield mutual(iterator.current, another.current, i);
      }
    }
    if (includeTrailing) {
      while (iterator.moveNext()) {
        yield overflow(iterator.current, i++);
      }
    }
  }

  ///
  ///
  /// [pairMerge]
  ///
  ///
  static Iterable<I> pairMerge<I>(
    Iterator<I> iterator,
    Iterator<I> another,
    PredicatorReducer<I> keep,
  ) => moveNextTogetherSupply(iterator, another, () sync* {
    while (true) {
      if (keep(iterator.current, another.current)) {
        yield iterator.current;
        if (!iterator.moveNext()) {
          yield another.current;
          yield* IteratorExtension.takeAll(another);
          return;
        }
        continue;
      }
      yield another.current;
      if (!another.moveNext()) {
        yield iterator.current;
        yield* IteratorExtension.takeAll(iterator);
        return;
      }
    }
  });

  ///
  /// [pairInterval] for example:
  ///   final general = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  ///   final interval = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  ///   print(general.iterator.[pairInterval]
  ///   (
  ///     interval,
  ///     (v1, v2, other) => (v1 + v2) / 2 + another,
  ///   ));
  ///   // (16.0, 27.0, 38.0, 49.0, 60.0, 71.0, 82.0, 93.0, 104.0)
  ///
  static Iterable<S> pairInterval<I, T, S>(
    Iterator<I> iterator,
    Iterator<T> interval,
    Linker<I, T, S> link,
  ) => IteratorTo.supplyMoveNext(iterator, () sync* {
    var previous = iterator.current;
    while (iterator.moveNext() && interval.moveNext()) {
      yield link(previous, iterator.current, interval.current);
      previous = iterator.current;
    }
  });

  static S pairIntervalInduct<I, T, S>(
    Iterator<I> iterator,
    Iterator<T> interval,
    Mapper<I, S> toVal,
    Chainer<I, T, S> link,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    var previous = toVal(iterator.current);
    while (iterator.moveNext() && interval.moveNext()) {
      previous = link(previous, iterator.current, interval.current);
    }
    return previous;
  });

  ///
  ///
  ///
  ///
  ///
  ///
  ///

  ///
  /// [intersection], [intersectionIndex], [intersectionDetail],
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  static Iterable<I> intersection<I>(
    Iterator<I> iterator,
    Iterable<I> another,
  ) => pairMapWhere(
    iterator,
    another.iterator,
    FPredicatorFusionor.isEqual,
    FKeep.reduceV1,
  );

  static Iterable<int> intersectionIndex<I>(
    Iterator<I> iterator,
    Iterable<I> another, [
    int start = 0,
  ]) => pairMapIndexableWhere(
    iterator,
    another.iterator,
    FPredicatorFusionor.isEqual,
    (p, q, index) => index,
    start,
  );

  static Map<int, I> intersectionDetail<I>(
    Iterator<I> iterator,
    Iterable<I> another,
  ) => pairFoldIndexable(
    iterator,
    {},
    another.iterator,
    (map, v1, v2, index) => map..putIfAbsentWhen(v1 == v2, index, () => v1),
    0,
  );

  static Iterable<I> difference<I>(Iterator<I> iterator, Iterable<I> another) =>
      [
        ...pairMapWhere(
          iterator,
          another.iterator,
          FPredicatorFusionor.isDifferent,
          FKeep.reduceV1,
        ),
        ...IteratorExtension.takeAll(iterator),
      ];

  static Iterable<int> differenceIndex<I>(
    Iterator<I> iterator,
    Iterable<I> another, [
    int start = 0,
  ]) => pairFollowMapWhereIndexable(
    iterator,
    another.iterator,
    (p, q, index) => index,
    (p, index) => index,
    FPredicatorFusionor.isDifferent,
    start,
  );

  static Map<int, (I, I?)> differenceDetail<I>(
    Iterator<I> iterator,
    Iterable<I> another,
  ) => followFoldIndexable(
    iterator,
    {},
    another.iterator,
    (map, e1, e2, index) =>
        map..putIfAbsentWhen(e1 != e2, index, () => (e1, e2)),
    (map, e1, index) => map..putIfAbsent(index, () => (e1, null)),
    0,
  );

  ///
  /// [interReduce]
  ///
  static I interReduce<I>(
    Iterator<I> iterator,
    Iterator<I> another,
    Reducer<I> fusion,
    Reducer<I> reducing,
  ) => moveNextTogetherReduce(iterator, another, (v1, v2) {
    var val = fusion(v1, v2);
    while (iterator.moveNext() && another.moveNext()) {
      val = reducing(val, fusion(iterator.current, another.current));
    }
    return val;
  });

  ///
  ///
  ///
  ///
  static Iterable<I> sandwich<I>(Iterator<I> iterator, Iterator<I> meat) sync* {
    while (iterator.moveNext() && meat.moveNext()) {
      yield iterator.current;
      yield meat.current;
    }
    try {
      yield iterator.current;
      try {
        final remains = [meat.current, ...IteratorExtension.takeAll(meat)];
        throw StateError('excess meat: $remains');
      } on Error {
        return;
      }
    } on Error {
      try {
        final remains = [meat.current, ...IteratorExtension.takeAll(meat)];
        throw StateError('inadequate bread for meat: $remains');
      } on Error {
        throw StateError('lack of last bread');
      }
    }
  }

  ///
  /// [combination2FromFirst]
  /// [combineToRecord]
  /// [combineToRecordExpanded]
  ///

  ///
  /// [combination2FromFirst]
  ///
  static Iterable<Iterable<I>> combination2FromFirst<I>(Iterator<I> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () sync* {
        final first = iterator.current;
        while (iterator.moveNext()) {
          yield [first, iterator.current];
        }
      });

  ///
  /// listA = [1, 2, 3];
  /// listB = [101, 102];
  /// result = [combineToRecord] ([listA, listB]);
  /// print(result); // [
  ///   [MapEntry(1, 101), MapEntry(1, 102)],
  ///   [MapEntry(2, 101), MapEntry(2, 102)],
  ///   [MapEntry(3, 101), MapEntry(3, 102)],
  /// }
  ///
  static Iterable<Iterable<(I, V)>> combineToRecord<I, V>(
    Iterator<I> iterator,
    Iterator<V> another,
  ) => IteratorTo.map(
    iterator,
    (value) => IteratorTo.mapToRecordBy1(another, value),
  );

  static Iterable<(I, V)> combineToRecordExpanded<I, V>(
    Iterator<I> iterator,
    Iterator<V> another,
  ) => IteratorTo.mapExpand(
    iterator,
    (value) => IteratorTo.mapToRecordBy1(another, value),
  );
}

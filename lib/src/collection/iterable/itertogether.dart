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
  I moveNextTogetherReduce(Iterator<I> another, Reducer<I> reducing) =>
      moveNext() && another.moveNext()
          ? reducing(current, another.current)
          : throw StateError(Erroring.iterableNoElement);

  I moveNextTogetherCompanion<E>(
    Iterator<E> another,
    Companion<I, E> companion,
  ) =>
      moveNext() && another.moveNext()
          ? companion(current, another.current)
          : throw StateError(Erroring.iterableNoElement);

  S moveNextTogetherSupply<T, S>(Iterator<T> another, Supplier<S> supply) =>
      moveNext() && another.moveNext()
          ? supply()
          : throw StateError(Erroring.iterableNoElement);

  ///
  /// [pair]
  /// [pairIndexable]
  ///
  void pair<E>(Iterator<E> another, Pairitor<I, E> mutual) {
    while (moveNext() && another.moveNext()) {
      mutual(current, another.current);
    }
  }

  void pairIndexable<E>(
    Iterator<E> another,
    PairitorIndexable<I, E> mutual,
    int start,
  ) {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      mutual(current, another.current, i);
    }
  }

  ///
  /// [pairFollow]
  /// [pairFollowIndexable]
  ///
  void pairFollow<E>(
    Iterator<E> another,
    Pairitor<I, E> mutual,
    Consumer<I> overflow,
  ) {
    while (another.moveNext()) {
      if (moveNext()) mutual(current, another.current);
    }
    while (moveNext()) {
      overflow(current);
    }
  }

  void pairFollowIndexable<E>(
    Iterator<E> another,
    PairitorIndexable<I, E> mutual,
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
  /// [pairAny]
  ///
  bool pairAny<E>(Iterator<E> another, PredicatorMixer<I, E> test) {
    while (moveNext() && another.moveNext()) {
      if (test(current, another.current)) return true;
    }
    return false;
  }

  ///
  ///
  /// fold, collapse, force
  ///
  ///

  ///
  ///
  ///
  S pairFold<E, S>(
    S initialValue,
    Iterator<E> another,
    Forcer<S, I, E> mutual,
  ) {
    var val = initialValue;
    while (moveNext() && another.moveNext()) {
      val = mutual(val, current, another.current);
    }
    return val;
  }

  S pairFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> another,
    ForcerGenerator<S, I, E> mutual,
    int start,
  ) {
    var val = initialValue;
    for (var i = start; moveNext() && another.moveNext(); i++) {
      val = mutual(val, current, another.current, i);
    }
    return val;
  }

  ///
  ///
  ///
  S pairCollapse<E, S>(
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    Collapser<S> mutual,
  ) => moveNextTogetherSupply(another, () {
    var val = init(toVal(current), toValAnother(another.current));
    while (moveNext() && another.moveNext()) {
      val = mutual(val, toVal(current), toValAnother(another.current));
    }
    return val;
  });

  S pairCollapseIndexable<E, S>(
    Iterator<E> another,
    Mapper<I, S> toVal,
    Mapper<E, S> toValAnother,
    Reducer<S> init,
    CollapserGenerator<S> mutual,
    int start,
  ) => moveNextTogetherSupply(another, () {
    var val = init(toVal(current), toValAnother(another.current));
    for (var i = start + 1; moveNext() && another.moveNext(); i++) {
      val = mutual(val, toVal(current), toValAnother(another.current), i);
    }
    return val;
  });

  ///
  ///
  ///
  S pairForcer<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    Forcer<S, I, E> mutual,
  ) => moveNextTogetherSupply(another, () {
    var val = init(current, another.current);
    while (moveNext() && another.moveNext()) {
      val = mutual(val, current, another.current);
    }
    return val;
  });

  S pairForcerIndexable<E, S>(
    Iterator<E> another,
    Mixer<I, E, S> init,
    ForcerGenerator<S, I, E> mutual,
    int start,
  ) => moveNextTogetherSupply(another, () {
    var val = init(current, another.current);
    for (var i = start; moveNext() && another.moveNext();) {
      val = mutual(val, current, another.current, ++i);
    }
    return val;
  });

  ///
  /// follow
  ///
  S followFoldIndexable<E, S>(
    S initialValue,
    Iterator<E> another,
    ForcerGenerator<S, I, E> mutual,
    CompanionGenerator<S, I> overflow,
    int start,
  ) {
    var val = initialValue;
    var i = start;
    while (another.moveNext()) {
      if (moveNext()) {
        val = mutual(val, current, another.current, ++i);
      }
    }
    while (moveNext()) {
      val = overflow(val, current, ++i);
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

  ///
  /// [pairTake], [pairMap]
  ///
  Iterable<I> pairTake<E>(
    Iterator<E> another,
    Companion<I, E> companion,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield companion(current, another.current);
    }
  }

  Iterable<S> pairMap<E, S>(Iterator<E> another, Mixer<I, E, S> mixer) => [
    for (; moveNext() && another.moveNext();) mixer(current, another.current),
  ];

  ///
  ///
  ///
  Iterable<S> pairMapWhere<E, S>(
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

  Iterable<S> pairMapIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> mix,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield mix(current, another.current, i);
    }
  }

  Iterable<S> pairMapIndexableWhere<E, S>(
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

  List<S> pairMapList<E, S>(Iterator<E> another, Mixer<I, E, S> mixer) {
    final list = <S>[];
    while (moveNext() && another.moveNext()) {
      list.add(mixer(current, another.current));
    }
    return list;
  }

  ///
  /// expand
  ///
  Iterable<S> pairExpand<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && another.moveNext()) {
      yield* expanding(current, another.current);
    }
  }

  Iterable<S> pairExpandWhere<E, S>(
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

  Iterable<S> pairExpandIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, Iterable<S>> mix,
    int start,
  ) sync* {
    for (var i = start; moveNext() && another.moveNext(); i++) {
      yield* mix(current, another.current, i);
    }
  }

  Iterable<S> pairExpandIndexableWhere<E, S>(
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

  List<S> pairExpandList<E, S>(
    Iterator<E> another,
    Mixer<I, E, Iterable<S>> expanding,
  ) {
    final list = <S>[];
    while (moveNext() && another.moveNext()) {
      list.addAll(expanding(current, another.current));
    }
    return list;
  }

  ///
  /// [pairFollowMapWhereIndexable]
  ///
  Iterable<S> pairFollowMapWhereIndexable<E, S>(
    Iterator<E> another,
    MixerGenerator<I, E, S> mutual,
    MapperGenerator<I, S> overflow,
    PredicatorMixer<I, E> test,
    int start, [
    bool includeTrailing = true,
  ]) sync* {
    var i = start;
    for (; another.moveNext(); i++) {
      if (moveNext() && test(current, another.current)) {
        yield mutual(current, another.current, i);
      }
    }
    if (includeTrailing) {
      while (moveNext()) {
        yield overflow(current, i++);
      }
    }
  }

  ///
  ///
  /// [pairMerge]
  ///
  ///
  Iterable<I> pairMerge(Iterator<I> another, PredicatorReducer<I> keep) =>
      moveNextTogetherSupply(another, () sync* {
        while (true) {
          if (keep(current, another.current)) {
            yield current;
            if (!moveNext()) {
              yield another.current;
              yield* takeAll;
              return;
            }
            continue;
          }
          yield another.current;
          if (!another.moveNext()) {
            yield current;
            yield* another.takeAll;
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
  Iterable<S> pairInterval<T, S>(Iterator<T> interval, Linker<I, T, S> link) =>
      supplyMoveNext(() sync* {
        var previous = current;
        while (moveNext() && interval.moveNext()) {
          yield link(previous, current, interval.current);
          previous = current;
        }
      });

  S pairIntervalInduct<T, S>(
    Iterator<T> interval,
    Mapper<I, S> toVal,
    Chainer<I, T, S> link,
  ) => supplyMoveNext(() {
    var previous = toVal(current);
    while (moveNext() && interval.moveNext()) {
      previous = link(previous, current, interval.current);
    }
    return previous;
  });

  ///
  ///
  ///
  ///
  /// [intersection], [intersectionIndex], [intersectionDetail],
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  ///
  ///

  ///
  /// [intersection], [intersectionIndex], [intersectionDetail],
  ///
  Iterable<I> intersection(Iterable<I> another) => pairMapWhere(
    another.iterator,
    FPredicatorFusionor.isEqual,
    FKeep.reduceV1,
  );

  Iterable<int> intersectionIndex(Iterable<I> another, [int start = 0]) =>
      pairMapIndexableWhere(
        another.iterator,
        FPredicatorFusionor.isEqual,
        (p, q, index) => index,
        start,
      );

  Map<int, I> intersectionDetail(Iterable<I> another) => pairFoldIndexable(
    {},
    another.iterator,
    (map, v1, v2, index) => map..putIfAbsentWhen(v1 == v2, index, () => v1),
    0,
  );

  ///
  /// [difference], [differenceIndex], [differenceDetail]
  ///
  Iterable<I> difference(Iterable<I> another) sync* {
    yield* pairMapWhere(
      another.iterator,
      FPredicatorFusionor.isDifferent,
      FKeep.reduceV1,
    );
    yield* takeAll;
  }

  Iterable<int> differenceIndex(Iterable<I> another, [int start = 0]) =>
      pairFollowMapWhereIndexable(
        another.iterator,
        (p, q, index) => index,
        (p, index) => index,
        FPredicatorFusionor.isDifferent,
        start,
      );

  Map<int, (I, I?)> differenceDetail(Iterable<I> another) =>
      followFoldIndexable(
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
  I interReduce(Iterator<I> another, Reducer<I> fusion, Reducer<I> reducing) =>
      moveNextTogetherReduce(another, (v1, v2) {
        var val = fusion(v1, v2);
        while (moveNext() && another.moveNext()) {
          val = reducing(val, fusion(current, another.current));
        }
        return val;
      });

  Iterable<I> sandwich(Iterator<I> meat) sync* {
    while (moveNext() && meat.moveNext()) {
      yield current;
      yield meat.current;
    }
    try {
      yield current;
      try {
        final remains = [meat.current, ...takeAll];
        throw StateError('excess meat: $remains');
      } on Error {
        return;
      }
    } on Error {
      try {
        final remains = [meat.current, ...takeAll];
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
  Iterable<Iterable<I>> get combination2FromFirst => supplyMoveNext(() sync* {
    final first = current;
    while (moveNext()) {
      yield [first, current];
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
  Iterable<Iterable<(I, V)>> combineToRecord<V>(Iterator<V> another) =>
      map(another.mapToRecordBy1);

  Iterable<(I, V)> combineToRecordExpanded<V>(Iterator<V> another) =>
      mapExpand(another.mapToRecordBy1);
}

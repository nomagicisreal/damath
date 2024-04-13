part of damath_collection;

///
///
///
///
/// [moveNextSupply], ...
/// [leadSupply], ...
///
///
/// [map], ...
/// [mirrored], ...
/// [fold], ...
/// [reduceTo], ...
///
/// [toMap], ...
///
///
///
///
extension ItertoExtension<I> on Iterator<I> {
  ///
  /// [moveNextSupply]
  /// [moveNextSupplyWith]
  ///
  S moveNextSupply<S>(Supplier<S> supply) =>
      moveNext() ? supply() : throw StateError(FErrorMessage.iteratorNoElement);

  S moveNextSupplyWith<E, S>(Iterator<E> another, Supplier<S> supply) =>
      moveNext() && another.moveNext()
          ? supply()
          : throw StateError(FErrorMessage.iteratorNoElement);

  ///
  /// [leadSupply]
  ///
  S leadSupply<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(FErrorMessage.iteratorNoElement);
    }
    return supply();
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
  /// [mapUntil]
  /// [mapByIndexExistUntil]
  ///
  /// [mapToListByIndexUntil]
  /// [mapToListByIndexExistUntil]
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
  /// [mapToEntries], [mapToEntriesByKey], [mapToEntriesByValue]
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
  /// [mapToRecord], [mapToRecordBy1], [mapToRecordBy2]
  ///
  Iterable<(A, B)> mapToRecord<A, B>(Mapper<I, (A, B)> toVal) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<(A, I)> mapToRecordBy1<A>(A key) sync* {
    while (moveNext()) {
      yield (key, current);
    }
  }

  Iterable<(I, B)> mapToRecordBy2<B>(B value) sync* {
    while (moveNext()) {
      yield (current, value);
    }
  }

  ///
  /// [mapToList]
  /// [mapToListByIndex]
  /// [mapToListByList], [mapToListBySet], [mapToListByMap]
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
      if (test(current)) yield* expanding(current);
    }
  }

  ///
  /// [mapUntil]
  /// [mapByIndexExistUntil]
  ///
  Iterable<S> mapUntil<S>(
    Predicator<I> testInvalid,
    Mapper<I, S> toVal, [
    bool includeFirstInvalid = false,
  ]) sync* {
    while (moveNext()) {
      if (testInvalid(current)) {
        if (includeFirstInvalid) toVal(current);
        break;
      }
      yield toVal(current);
    }
  }

  Iterable<S> mapByIndexExistUntil<S>(
    PredicatorFusionor<I> testInvalid,
    MapperGenerator<I, S> toVal, {
    bool includeFirst = true,
    bool includeInvalid = false,
    int start = 0,
  }) =>
      moveNextSupply(() sync* {
        final first = current;
        if (includeFirst) yield toVal(first, 0);
        for (var i = start + 1; moveNext(); i++) {
          if (testInvalid(first, current)) {
            if (includeInvalid) yield toVal(current, i);
            break;
          }
          yield toVal(current, i);
        }
      });

  ///
  /// [mapToListByIndexUntil]
  /// [mapToListByIndexExistUntil]
  ///
  List<T> mapToListByIndexUntil<T>(
    Predicator<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeInvalid = false,
    int start = 0,
  }) {
    final list = <T>[];
    for (var i = start; moveNext(); i++) {
      if (testInvalid(current)) {
        if (includeInvalid) list.add(toVal(current, i));
        break;
      }
      list.add(toVal(current, i));
    }
    return list;
  }

  List<T> mapToListByIndexExistUntil<T>(
    PredicatorFusionor<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeFirst = true,
    bool includeFirstInvalid = false,
    int start = 0,
  }) =>
      moveNextSupply(() {
        final first = current;
        final list = <T>[if (includeFirst) toVal(first, 0)];
        for (var i = start + 1; moveNext(); i++) {
          if (testInvalid(first, current)) {
            if (includeFirstInvalid) list.add(toVal(current, i));
            break;
          }
          list.add(toVal(current, i));
        }
        return list;
      });

  ///
  /// [mirrored]
  ///
  Iterable<E> mirrored<E>(Generator<E> generator, [int start = 0]) =>
      [for (var i = start; moveNext(); i++) generator(i)];

  ///
  ///
  ///
  /// fold
  /// [fold]
  /// [foldByIndex], [foldNested],
  /// [foldAccompanyBefore], [foldAccompanyAfter],
  ///
  /// reduce to
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
          _ => throw StateError(FErrorMessage.iteratorElementNotNest),
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
  ///
  /// [reduceTo], [reduceToByIndex]
  /// [reduceToInitialized], [reduceToInitializedByIndex]
  ///
  ///

  ///
  /// [reduceTo]
  /// [reduceToByIndex]
  ///
  T reduceTo<T>(Mapper<I, T> toVal, Reducer<T> reducing) => moveNextSupply(() {
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
      moveNextSupply(() {
        var val = toVal(current);
        for (var i = start; moveNext(); i++) {
          val = reducing(val, toVal(current), i);
        }
        return val;
      });

  ///
  /// [reduceToInitialized]
  /// [reduceToInitializedByIndex]
  ///
  T reduceToInitialized<T>(Mapper<I, T> init, Companion<T, I> reducing) =>
      moveNextSupply(() {
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
      moveNextSupply(() {
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
  /// [groupBy]
  ///

  ///
  /// [toMap]
  /// [toMapCounted]
  /// [toMapFrequencies]
  ///
  Map<int, I> toMap([int start = 0]) => foldByIndex(
        {},
        (map, value, i) => map..putIfAbsent(i, () => value),
        start,
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

  ///
  /// [groupBy]
  ///
  Map<K, Iterable<I>> groupBy<K>(Mapper<I, K> toKey) => fold(
        {},
        (map, value) => map
          ..update(
            toKey(value),
            IterableExtension.applyAppend(value),
            ifAbsent: () => [value],
          ),
      );
}

part of '../collection.dart';

///
///
/// return typed item             --> [supplyMoveNext], ...
/// return typed item iterable    --> [generating], ...
/// return typed item list        --> [mapToList], ...
/// return typed item set         --> [mapToSet], ...
/// return typed iterable entries --> [fillIterableEntryValues], ...
/// return typed map              --> [toMap], ...
/// return counted result         --> [consecutiveCounted]
///
///
extension IteratorTo<I> on Iterator<I> {
  ///
  ///
  /// [supplyMoveNext], [supplyLead]
  /// [mapFound], [mapFoundOr], [mapFoundOrNull]
  ///
  /// [fold], [foldByIndex],
  /// [foldByBefore], [foldByAfter],
  ///
  /// [induct], [inductByIndex]
  /// [inductInited], [inductInitedByIndex]
  ///
  ///
  ///

  ///
  /// [supplyMoveNext], [supplyLead]
  ///
  static S supplyMoveNext<I, S>(Iterator<I> iterator, Supplier<S> supply) =>
      iterator.moveNext()
          ? supply()
          : throw StateError(Erroring.iterableNoElement);

  static S supplyLead<I, S>(
    Iterator<I> iterator,
    int ahead,
    Supplier<S> supply,
  ) {
    for (var i = -1; i < ahead; i++) {
      if (!iterator.moveNext()) throw StateError(Erroring.iterableNoElement);
    }
    return supply();
  }

  ///
  /// [mapFound], [mapFoundOr], [mapFoundOrNull]
  ///
  static T mapFound<I, T>(
    Iterator<I> iterator,
    Predicator<I> test,
    Mapper<I, T> toVal,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return toVal(iterator.current);
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  static T mapFoundOr<I, T>(
    Iterator<I> iterator,
    Predicator<I> test,
    Mapper<I, T> toVal,
    Supplier<T> orElse,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return toVal(iterator.current);
    }
    return orElse();
  }

  static T? mapFoundOrNull<I, T>(
    Iterator<I> iterator,
    Predicator<I> test,
    Mapper<I, T> toVal,
  ) {
    while (iterator.moveNext()) {
      if (test(iterator.current)) return toVal(iterator.current);
    }
    return null;
  }

  ///
  /// [fold], [foldByIndex]
  ///
  static T fold<I, T>(
    Iterator<I> iterator,
    T initialValue,
    Companion<T, I> companion,
  ) {
    var value = initialValue;
    while (iterator.moveNext()) {
      value = companion(value, iterator.current);
    }
    return value;
  }

  static T foldByIndex<I, T>(
    Iterator<I> iterator,
    T initialValue,
    CompanionGenerator<T, I> companion, [
    int start = 0,
  ]) {
    var val = initialValue;
    for (var i = start; iterator.moveNext(); i++) {
      val = companion(val, iterator.current, i);
    }
    return val;
  }

  ///
  /// [foldByBefore], [foldByAfter]
  ///
  static S foldByBefore<I, E, S>(
    Iterator<I> iterator,
    S initialValue,
    E initialElement,
    Companion<E, I> before,
    Forcer<S, I, E> companion,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (iterator.moveNext()) {
      ele = before(ele, iterator.current);
      val = companion(val, iterator.current, ele);
    }
    return val;
  }

  static S foldByAfter<I, R, S>(
    Iterator<I> iterator,
    S initialValue,
    R initialElement,
    Forcer<S, I, R> companion,
    Companion<R, I> after,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (iterator.moveNext()) {
      val = companion(val, iterator.current, ele);
      ele = after(ele, iterator.current);
    }
    return val;
  }

  ///
  /// [induct], [inductByIndex]
  ///
  static T induct<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> toVal,
    Reducer<T> reducing,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    var val = toVal(iterator.current);
    while (iterator.moveNext()) {
      val = reducing(val, toVal(iterator.current));
    }
    return val;
  });

  static T inductByIndex<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> toVal,
    ReducerGenerator<T> reducing, [
    int start = 0,
  ]) => IteratorTo.supplyMoveNext(iterator, () {
    var val = toVal(iterator.current);
    for (var i = start; iterator.moveNext(); i++) {
      val = reducing(val, toVal(iterator.current), i);
    }
    return val;
  });

  ///
  /// [inductInited], [inductInitedByIndex]
  ///
  static T inductInited<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> init,
    Companion<T, I> reducing,
  ) => IteratorTo.supplyMoveNext(iterator, () {
    var val = init(iterator.current);
    while (iterator.moveNext()) {
      val = reducing(val, iterator.current);
    }
    return val;
  });

  static T inductInitedByIndex<I, T>(
    Iterator<I> iterator,
    Mapper<I, T> init,
    CompanionGenerator<T, I> reducing, [
    int start = 0,
  ]) => IteratorTo.supplyMoveNext(iterator, () {
    var val = init(iterator.current);
    for (var i = start; iterator.moveNext(); i++) {
      val = reducing(val, iterator.current, i);
    }
    return val;
  });

  ///
  ///
  ///
  /// [generating]
  ///
  /// [map], [mapByIndex]
  /// [mapToEntriesByKey], [mapToEntriesByValue], [mapToRecordBy1], [mapToRecordBy2]
  /// [mapExpand]
  /// [mapWhere], [mapWhereExpand]
  /// [mapUntil], [mapUntilByIndexExist]
  ///
  /// [foldNested]
  ///
  ///
  ///
  ///

  ///
  /// [generating]
  ///
  static Iterable<E> generating<I, E>(
    Iterator<I> iterator,
    Generator<E> generator, [
    int start = 0,
  ]) => [for (var i = start; iterator.moveNext(); i++) generator(i)];

  ///
  /// [map], [mapNotNull]
  ///
  static Iterable<S> map<I, S>(Iterator<I> iterator, Mapper<I, S> toVal) => [
    for (; iterator.moveNext();) toVal(iterator.current),
  ];

  static Iterable<S> mapNotNull<I, S>(
    Iterable<I> iterable,
    Mapper<I, S?> mapper,
  ) sync* {
    for (final item in iterable) {
      final value = mapper(item);
      if (value == null) continue;
      yield value;
    }
  }

  ///
  /// [mapByIndex]
  ///
  static Iterable<S> mapByIndex<I, S>(
    Iterator<I> iterator,
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) => [
    for (var i = start; iterator.moveNext(); i++) toVal(iterator.current, i),
  ];

  ///
  /// [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToRecordBy1], [mapToRecordBy2]
  ///
  static Iterable<MapEntry<K, I>> mapToEntriesByKey<I, K>(
    Iterator<I> iterator,
    K key,
  ) => [for (; iterator.moveNext();) MapEntry(key, iterator.current)];

  static Iterable<MapEntry<I, V>> mapToEntriesByValue<I, V>(
    Iterator<I> iterator,
    V value,
  ) => [for (; iterator.moveNext();) MapEntry(iterator.current, value)];

  static Iterable<(A, I)> mapToRecordBy1<I, A>(Iterator<I> iterator, A value) =>
      [for (; iterator.moveNext();) (value, iterator.current)];

  static Iterable<(I, B)> mapToRecordBy2<I, B>(Iterator<I> iterator, B value) =>
      [for (; iterator.moveNext();) (iterator.current, value)];

  ///
  /// [mapExpand], [mapWhere],
  ///
  static Iterable<S> mapExpand<I, S>(
    Iterator<I> iterator,
    Mapper<I, Iterable<S>> expanding,
  ) => [for (; iterator.moveNext();) ...expanding(iterator.current)];

  static Iterable<S> mapWhere<I, S>(
    Iterator<I> iterator,
    Predicator<I> test,
    Mapper<I, S> toVal,
  ) => [
    for (; iterator.moveNext() && test(iterator.current);)
      toVal(iterator.current),
  ];

  ///
  /// [mapWhereByIndex], [mapWhereExpand]
  ///
  static Iterable<S> mapWhereByIndex<I, S>(
    Iterator<I> iterator,
    Predicator<I> test,
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) => [
    for (var i = start; iterator.moveNext() && test(iterator.current); i++)
      toVal(iterator.current, i),
  ];

  static Iterable<S> mapWhereExpand<I, S>(
    Iterator<I> iterator,
    Predicator<I> test,
    Mapper<I, Iterable<S>> expanding,
  ) => [
    for (; iterator.moveNext() && test(iterator.current);)
      ...expanding(iterator.current),
  ];

  ///
  /// [mapUntil], [mapUntilByIndexExist]
  ///
  static Iterable<S> mapUntil<I, S>(
    Iterator<I> iterator,
    Predicator<I> testInvalid,
    Mapper<I, S> toVal, [
    bool includeFirstInvalid = false,
  ]) sync* {
    while (iterator.moveNext()) {
      if (testInvalid(iterator.current)) {
        if (includeFirstInvalid) toVal(iterator.current);
        break;
      }
      yield toVal(iterator.current);
    }
  }

  static Iterable<S> mapUntilByIndexExist<I, S>(
    Iterator<I> iterator,
    PredicatorReducer<I> testInvalid,
    MapperGenerator<I, S> toVal, {
    bool includeFirst = true,
    bool includeInvalid = false,
    int start = 0,
  }) => IteratorTo.supplyMoveNext(iterator, () sync* {
    final first = iterator.current;
    if (includeFirst) yield toVal(first, 0);
    for (var i = start + 1; iterator.moveNext(); i++) {
      if (testInvalid(first, iterator.current)) {
        if (includeInvalid) yield toVal(iterator.current, i);
        break;
      }
      yield toVal(iterator.current, i);
    }
  });

  ///
  /// [foldNested]
  ///
  static Iterable<T> foldNested<I, T>(Iterator<I> iterator) => fold<I, List<T>>(
    iterator,
    [],
    (list, element) => switch (element) {
      T() => list..add(element),
      Iterable<T>() => list..addAll(element),
      Iterable<Iterable>() => list..addAll(foldNested(element.iterator)),
      _ => throw StateError(Erroring.iterableElementNotNest),
    },
  );

  ///
  ///
  /// [mapToList], [mapToListNotNull]
  /// [mapToListByIndex]
  /// [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToListUntilByIndex], [mapToListUntilByIndexExist]
  ///
  ///

  ///
  /// [mapToList], [mapToListByIndex]
  ///
  static List<T> mapToList<I, T>(Iterator<I> iterator, Mapper<I, T> toVal) => [
    for (; iterator.moveNext();) toVal(iterator.current),
  ];

  static List<S> mapToListNotNull<I, S>(
    Iterable<I> iterable,
    Mapper<I, S?> mapper,
  ) {
    final list = <S>[];
    for (final item in iterable) {
      list.addIfNotNull(mapper(item));
    }
    return list;
  }

  ///
  /// [mapToListByIndex]
  ///
  static List<S> mapToListByIndex<I, S>(
    Iterator<I> iterator,
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) => [
    for (var i = start; iterator.moveNext(); i++) toVal(iterator.current, i),
  ];

  ///
  /// [mapToListByList], [mapToListBySet], [mapToListByMap]
  ///
  static List<T> mapToListByList<I, T, E>(
    Iterator<I> iterator,
    List<E> list,
    Mixer<I, List<E>, T> mixer,
  ) => [for (; iterator.moveNext();) mixer(iterator.current, list)];

  static List<T> mapToListBySet<I, T, E>(
    Iterator<I> iterator,
    Set<E> set,
    Mixer<I, Set<E>, T> mixer,
  ) => [for (; iterator.moveNext();) mixer(iterator.current, set)];

  static List<T> mapToListByMap<I, T, K, V>(
    Iterator<I> iterator,
    Map<K, V> map,
    Mixer<I, Map<K, V>, T> mixer,
  ) => [for (; iterator.moveNext();) mixer(iterator.current, map)];

  ///
  /// [mapToListUntilByIndex]
  /// [mapToListUntilByIndexExist]
  ///
  static List<T> mapToListUntilByIndex<I, T>(
    Iterator<I> iterator,
    Predicator<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeInvalid = false,
    int start = 0,
  }) {
    final list = <T>[];
    for (var i = start; iterator.moveNext(); i++) {
      if (testInvalid(iterator.current)) {
        if (includeInvalid) list.add(toVal(iterator.current, i));
        break;
      }
      list.add(toVal(iterator.current, i));
    }
    return list;
  }

  static List<T> mapToListUntilByIndexExist<I, T>(
    Iterator<I> iterator,
    PredicatorReducer<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeFirst = true,
    bool includeFirstInvalid = false,
    int start = 0,
  }) => IteratorTo.supplyMoveNext(iterator, () {
    final first = iterator.current;
    final list = <T>[if (includeFirst) toVal(first, 0)];
    for (var i = start + 1; iterator.moveNext(); i++) {
      if (testInvalid(first, iterator.current)) {
        if (includeFirstInvalid) list.add(toVal(iterator.current, i));
        break;
      }
      list.add(toVal(iterator.current, i));
    }
    return list;
  });

  ///
  ///
  ///
  /// [mapToSet], [mapToSetBySet]
  ///
  ///
  ///

  ///
  /// [mapToSet], [mapToSetBySet]
  ///
  static Set<K> mapToSet<I, K>(Iterator<I> iterator, Mapper<I, K> toVal) => {
    for (; iterator.moveNext();) toVal(iterator.current),
  };

  static Set<K> mapToSetBySet<I, K>(
    Iterator<I> iterator,
    Set<K> set,
    Mixer<I, Set<K>, K> mixer,
  ) => {for (; iterator.moveNext();) mixer(iterator.current, set)};

  ///
  ///
  /// [fillIterableEntryValues], [fillIterableEntryKeys]
  ///
  ///

  ///
  /// [fillIterableEntryValues]
  /// [fillIterableEntryKeys]
  ///
  static Iterable<MapEntry<I, V?>> fillIterableEntryValues<I, V>(
    Iterator<I> iterator, {
    V? fill,
  }) => map(iterator, (key) => MapEntry(key, fill));

  static Iterable<MapEntry<K?, I>> fillIterableEntryKeys<I, K>(
    Iterator<I> iterator, {
    K? fill,
  }) => map(iterator, (value) => MapEntry(fill, value));

  ///
  ///
  ///
  /// [toMap], [toMapKeys]
  /// [toMapIndexable], [toMapCounted], [toMapFrequencies]
  ///
  /// [groupBy]
  ///
  ///
  ///

  ///
  /// [toMap], [toMapKeys]
  ///
  static Map<K, V> toMap<I, K, V>(
    Iterator<I> iterator, [
    Mapper<dynamic, K>? toKey,
    Mapper<dynamic, V>? toValue,
  ]) => Map<K, V>.fromIterable(
    IteratorExtension.takeAll(iterator),
    key: toKey,
    value: toValue,
  );

  static Map<I, V?> toMapKeys<I, V>(Iterator<I> iterator, {V? fill}) =>
      Map.fromEntries(fillIterableEntryValues(iterator, fill: fill));

  ///
  /// [groupBy]
  /// group to list see [collection.groupBy]
  ///
  static Map<K, Iterable<I>> groupBy<I, K>(
    Iterator<I> iterator,
    Mapper<I, K> toKey,
  ) => fold(
    iterator,
    {},
    (map, value) =>
        map..update(
          toKey(value),
          IterableExtension.applyAppend(value),
          ifAbsent: () => [value],
        ),
  );

  ///
  ///
  ///
  /// [consecutiveCounted], [consecutiveRepeated]
  /// [consecutiveOccurred]
  ///
  /// [toMapIndexable], [toMapCounted], [toMapFrequencies]
  ///
  ///
  ///

  ///
  /// [consecutiveCounted]
  ///
  static Iterable<(I, int)> consecutiveCounted<I>(Iterator<I> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () sync* {
        var val = iterator.current;
        var frequency = 1;
        while (iterator.moveNext()) {
          if (val == iterator.current) {
            frequency++;
            continue;
          }
          yield (val, frequency);
          val = iterator.current;
          frequency = 1;
        }
        yield (val, frequency);
      });

  ///
  /// [consecutiveRepeated]
  ///
  static Iterable<(I, int)> consecutiveRepeated<I>(Iterator<I> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () sync* {
        var val = iterator.current;
        var frequency = 1;
        while (iterator.moveNext()) {
          if (val == iterator.current) {
            frequency++;
            continue;
          }
          if (frequency > 1) yield (val, frequency);
          val = iterator.current;
          frequency = 1;
        }
        if (frequency > 1) yield (val, frequency);
      });

  ///
  /// [consecutiveOccurred]
  ///
  static Iterable<int> consecutiveOccurred<I>(Iterator<I> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () sync* {
        var val = iterator.current;
        var frequency = 1;
        while (iterator.moveNext()) {
          if (val == iterator.current) {
            frequency++;
            continue;
          }
          if (frequency > 1) yield frequency;
          val = iterator.current;
          frequency = 1;
        }
        if (frequency > 1) yield frequency;
      });

  ///
  /// [toMapIndexable], [toMapCounted], [toMapFrequencies]
  ///
  static Map<int, I> toMapIndexable<I>(Iterator<I> iterator, [int start = 0]) =>
      foldByIndex(
        iterator,
        {},
        (map, value, i) => map..putIfAbsent(i, () => value),
        start,
      );

  static Map<I, int> toMapCounted<I>(Iterator<I> iterator) => fold(
    iterator,
    {},
    (map, current) => map..update(current, (c) => ++c, ifAbsent: () => 1),
  );

  static Map<I, double> toMapFrequencies<I>(Iterator<I> iterator) {
    final map = <I, double>{};
    var length = 0;
    while (iterator.moveNext()) {
      map.update(iterator.current, (c) => ++c, ifAbsent: () => 1);
      length++;
    }
    return map..updateAll((key, value) => value / length);
  }
}

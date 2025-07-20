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
  S supplyMoveNext<S>(Supplier<S> supply) =>
      moveNext() ? supply() : throw StateError(Erroring.iterableNoElement);

  S supplyLead<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(Erroring.iterableNoElement);
    }
    return supply();
  }

  ///
  /// [mapFound], [mapFoundOr], [mapFoundOrNull]
  ///
  T mapFound<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    throw StateError(Erroring.iterableElementNotFound);
  }

  T mapFoundOr<T>(Predicator<I> test, Mapper<I, T> toVal, Supplier<T> orElse) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return orElse();
  }

  T? mapFoundOrNull<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) {
      if (test(current)) return toVal(current);
    }
    return null;
  }

  ///
  /// [fold], [foldByIndex]
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

  ///
  /// [foldByBefore], [foldByAfter]
  ///
  S foldByBefore<E, S>(
    S initialValue,
    E initialElement,
    Companion<E, I> before,
    Forcer<S, I, E> companion,
  ) {
    var val = initialValue;
    var ele = initialElement;
    while (moveNext()) {
      ele = before(ele, current);
      val = companion(val, current, ele);
    }
    return val;
  }

  S foldByAfter<R, S>(
    S initialValue,
    R initialElement,
    Forcer<S, I, R> companion,
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
  /// [induct], [inductByIndex]
  ///
  T induct<T>(Mapper<I, T> toVal, Reducer<T> reducing) => supplyMoveNext(() {
    var val = toVal(current);
    while (moveNext()) {
      val = reducing(val, toVal(current));
    }
    return val;
  });

  T inductByIndex<T>(
    Mapper<I, T> toVal,
    ReducerGenerator<T> reducing, [
    int start = 0,
  ]) => supplyMoveNext(() {
    var val = toVal(current);
    for (var i = start; moveNext(); i++) {
      val = reducing(val, toVal(current), i);
    }
    return val;
  });

  ///
  /// [inductInited], [inductInitedByIndex]
  ///
  T inductInited<T>(Mapper<I, T> init, Companion<T, I> reducing) =>
      supplyMoveNext(() {
        var val = init(current);
        while (moveNext()) {
          val = reducing(val, current);
        }
        return val;
      });

  T inductInitedByIndex<T>(
    Mapper<I, T> init,
    CompanionGenerator<T, I> reducing, [
    int start = 0,
  ]) => supplyMoveNext(() {
    var val = init(current);
    for (var i = start; moveNext(); i++) {
      val = reducing(val, current, i);
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
  Iterable<E> generating<E>(Generator<E> generator, [int start = 0]) sync* {
    for (var i = start; moveNext(); i++) {
      yield generator(i);
    }
  }

  ///
  /// [map], [mapNotNull]
  ///
  Iterable<S> map<S>(Mapper<I, S> toVal) sync* {
    while (moveNext()) {
      yield toVal(current);
    }
  }

  Iterable<S> mapNotNull<S>(Mapper<I, S?> mapper) sync* {
    while (moveNext()) {
      final value = mapper(current);
      if (value == null) continue;
      yield value;
    }
  }

  ///
  /// [mapByIndex]
  ///
  Iterable<S> mapByIndex<S>(
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext(); i++) {
      yield toVal(current, i);
    }
  }

  ///
  /// [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToRecordBy1], [mapToRecordBy2]
  ///
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

  Iterable<(A, I)> mapToRecordBy1<A>(A value) sync* {
    while (moveNext()) {
      yield (value, current);
    }
  }

  Iterable<(I, B)> mapToRecordBy2<B>(B value) sync* {
    while (moveNext()) {
      yield (current, value);
    }
  }

  ///
  /// [mapExpand], [mapWhere],
  ///
  Iterable<S> mapExpand<S>(Mapper<I, Iterable<S>> expanding) sync* {
    while (moveNext()) {
      yield* expanding(current);
    }
  }

  Iterable<S> mapWhere<S>(Predicator<I> test, Mapper<I, S> toVal) sync* {
    while (moveNext() && test(current)) {
      yield toVal(current);
    }
  }

  ///
  /// [mapWhereByIndex], [mapWhereExpand]
  ///
  Iterable<S> mapWhereByIndex<S>(
    Predicator<I> test,
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; moveNext() && test(current); i++) {
      yield toVal(current, i);
    }
  }

  Iterable<S> mapWhereExpand<S>(
    Predicator<I> test,
    Mapper<I, Iterable<S>> expanding,
  ) sync* {
    while (moveNext() && test(current)) {
      yield* expanding(current);
    }
  }

  ///
  /// [mapUntil], [mapUntilByIndexExist]
  ///
  Iterable<S> mapUntil<S>(
    Predicator<I> testInvalid,
    Mapper<I, S> toVal, [
    bool includeFirstInvalid = false,
  ]) sync* {
    while (moveNext()) {
      if (testInvalid(current)) {
        if (includeFirstInvalid) yield toVal(current);
        break;
      }
      yield toVal(current);
    }
  }

  Iterable<S> mapUntilByIndexExist<S>(
    PredicatorReducer<I> testInvalid,
    MapperGenerator<I, S> toVal, {
    bool includeFirst = true,
    bool includeInvalid = false,
    int start = 0,
  }) sync* {
    yield* supplyMoveNext(() sync* {
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
  }

  ///
  /// [foldNested]
  ///
  Iterable<T> foldNested<T>() {
    return fold<List<T>>(
      [],
      (list, element) => switch (element) {
        T() => list..add(element),
        Iterable<T>() => list..addAll(element),
        Iterable<Iterable>() => list..addAll(element.iterator.foldNested<T>()),
        _ => throw StateError(Erroring.iterableElementNotNest),
      },
    );
  }

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
  List<T> mapToList<T>(Mapper<I, T> toVal) {
    final list = <T>[];
    while (moveNext()) {
      list.add(toVal(current));
    }
    return list;
  }

  List<S> mapToListNotNull<S>(Mapper<I, S?> mapper) {
    final list = <S>[];
    while (moveNext()) {
      final value = mapper(current);
      if (value != null) {
        list.add(value);
      }
    }
    return list;
  }

  ///
  /// [mapToListByIndex]
  /// [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToListUntilByIndex], [mapToListUntilByIndexExist]
  ///
  List<S> mapToListByIndex<S>(MapperGenerator<I, S> toVal, [int start = 0]) {
    final list = <S>[];
    for (var i = start; moveNext(); i++) {
      list.add(toVal(current, i));
    }
    return list;
  }

  List<T> mapToListByList<T, E>(List<E> list, Mixer<I, List<E>, T> mixer) {
    final result = <T>[];
    while (moveNext()) {
      result.add(mixer(current, list));
    }
    return result;
  }

  List<T> mapToListBySet<T, E>(Set<E> set, Mixer<I, Set<E>, T> mixer) {
    final result = <T>[];
    while (moveNext()) {
      result.add(mixer(current, set));
    }
    return result;
  }

  List<T> mapToListByMap<T, K, V>(Map<K, V> map, Mixer<I, Map<K, V>, T> mixer) {
    final result = <T>[];
    while (moveNext()) {
      result.add(mixer(current, map));
    }
    return result;
  }

  List<T> mapToListUntilByIndex<T>(
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

  List<T> mapToListUntilByIndexExist<T>(
    PredicatorReducer<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeFirst = true,
    bool includeFirstInvalid = false,
    int start = 0,
  }) => supplyMoveNext(() {
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
  ///
  ///
  /// [mapToSet], [mapToSetBySet]
  ///
  ///
  ///

  ///
  /// [mapToSet], [mapToSetBySet]
  ///
  Set<K> mapToSet<K>(Mapper<I, K> toVal) => {
    for (; moveNext();) toVal(current),
  };

  Set<K> mapToSetBySet<K>(Set<K> set, Mixer<I, Set<K>, K> mixer) => {
    for (; moveNext();) mixer(current, set),
  };

  ///
  ///
  /// [fillIterableEntryValues], [fillIterableEntryKeys]
  ///
  ///

  ///
  /// [fillIterableEntryValues]
  /// [fillIterableEntryKeys]
  ///
  Iterable<MapEntry<I, V?>> fillIterableEntryValues<V>({V? fill}) =>
      map((key) => MapEntry(key, fill));

  Iterable<MapEntry<K?, I>> fillIterableEntryKeys<K>({K? fill}) =>
      map((value) => MapEntry(fill, value));

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
  Map<K, V> toMap<K, V>([
    Mapper<dynamic, K>? toKey,
    Mapper<dynamic, V>? toValue,
  ]) => Map<K, V>.fromIterable(takeAll, key: toKey, value: toValue);

  Map<I, V?> toMapKeys<V>({V? fill}) =>
      Map.fromEntries(fillIterableEntryValues(fill: fill));

  ///
  /// [groupBy]
  /// group to list see [collection.groupBy]
  ///
  Map<K, Iterable<I>> groupBy<K>(Mapper<I, K> toKey) => fold(
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
  Iterable<(I, int)> get consecutiveCounted => supplyMoveNext(() sync* {
    var val = current;
    var frequency = 1;
    while (moveNext()) {
      if (val == current) {
        frequency++;
        continue;
      }
      yield (val, frequency);
      val = current;
      frequency = 1;
    }
    yield (val, frequency);
  });

  ///
  /// [consecutiveRepeated]
  ///
  Iterable<(I, int)> get consecutiveRepeated => supplyMoveNext(() sync* {
    var val = current;
    var frequency = 1;
    while (moveNext()) {
      if (val == current) {
        frequency++;
        continue;
      }
      if (frequency > 1) yield (val, frequency);
      val = current;
      frequency = 1;
    }
    if (frequency > 1) yield (val, frequency);
  });

  ///
  /// [consecutiveOccurred]
  ///
  Iterable<int> get consecutiveOccurred => supplyMoveNext(() sync* {
    var val = current;
    var frequency = 1;
    while (moveNext()) {
      if (val == current) {
        frequency++;
        continue;
      }
      if (frequency > 1) yield frequency;
      val = current;
      frequency = 1;
    }
    if (frequency > 1) yield frequency;
  });

  ///
  /// [toMapIndexable], [toMapCounted], [toMapFrequencies]
  ///
  Map<int, I> toMapIndexable([int start = 0]) => foldByIndex(
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
}

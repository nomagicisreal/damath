part of '../collection.dart';
// ignore_for_file: curly_braces_in_flow_control_structures

///
///
/// [supplyMoveNext], ...
///
/// [generating], ...
/// [map], ...
/// [fold], ...
/// [induct], ...
///
/// [toMap], ...
/// [groupBy], ...
///
///
///
extension IteratorTo<I> on Iterator<I> {
  ///
  /// [supplyMoveNext]
  /// [supplyLead]
  ///
  S supplyMoveNext<S>(Supplier<S> supply) =>
      moveNext() ? supply() : throw StateError(FErrorMessage.iteratorNoElement);

  S supplyLead<S>(int ahead, Supplier<S> supply) {
    for (var i = -1; i < ahead; i++) {
      if (!moveNext()) throw StateError(FErrorMessage.iteratorNoElement);
    }
    return supply();
  }

  ///
  /// [generating]
  ///
  Iterable<E> generating<E>(Generator<E> generator, [int start = 0]) =>
      [for (var i = start; moveNext(); i++) generator(i)];

  ///
  ///
  ///
  /// map / [Iterable.map]
  /// [map], [mapByIndex], [mapCurrentOrDefault], [mapRemain]
  /// [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToRecordBy1], [mapToRecordBy2]
  /// [mapToList], [mapToListByIndex], [mapToListByList], [mapToListBySet], [mapToListByMap]
  /// [mapToSet], [mapToSetBySet]
  /// [mapExpand]
  /// [mapWhere], [mapWhereExpand]
  ///
  /// [mapFound], [mapFoundOr], [mapFoundOrNull]
  /// [mapUntil]
  /// [mapUntilByIndexExist]
  ///
  /// [mapToListUntilByIndex]
  /// [mapToListUntilByIndexExist]
  ///
  ///
  ///

  ///
  /// [map]
  /// [mapByIndex]
  /// [mapCurrentOrDefault]
  /// [mapRemain]
  ///
  Iterable<S> map<S>(Mapper<I, S> toVal) =>
      [for (; moveNext();) toVal(current)];

  Iterable<S> mapByIndex<S>(MapperGenerator<I, S> toVal, [int start = 0]) =>
      [for (var i = start; moveNext(); i++) toVal(current, i)];

  S mapCurrentOrDefault<S>(Mapper<I, S> toVal, S ifAbsent) {
    try {
      return toVal(current);
    } catch (e) {
      if (!e.runtimeType.isTypeError) rethrow;
    }
    return ifAbsent;
  }

  Iterable<S> mapRemain<S>(Mapper<I, S> toVal) => mapCurrentOrDefault(
        (value) => [toVal(value), for (; moveNext();) toVal(current)],
        Iterable.empty(),
      );

  ///
  /// [mapToEntriesByKey], [mapToEntriesByValue]
  /// [mapToRecordBy1], [mapToRecordBy2]
  ///
  Iterable<MapEntry<K, I>> mapToEntriesByKey<K>(K key) =>
      [for (; moveNext();) MapEntry(key, current)];

  Iterable<MapEntry<I, V>> mapToEntriesByValue<V>(V value) =>
      [for (; moveNext();) MapEntry(current, value)];

  Iterable<(A, I)> mapToRecordBy1<A>(A value) =>
      [for (; moveNext();) (value, current)];

  Iterable<(I, B)> mapToRecordBy2<B>(B value) =>
      [for (; moveNext();) (current, value)];

  ///
  /// [mapToList]
  /// [mapToListByIndex]
  /// [mapToListByList], [mapToListBySet], [mapToListByMap]
  ///
  List<T> mapToList<T>(Mapper<I, T> toVal) =>
      [for (; moveNext();) toVal(current)];

  List<S> mapToListByIndex<S>(MapperGenerator<I, S> toVal, [int start = 0]) =>
      [for (var i = start; moveNext(); i++) toVal(current, i)];

  List<T> mapToListByList<T, E>(List<E> list, Mixer<I, List<E>, T> mixer) =>
      [for (; moveNext();) mixer(current, list)];

  List<T> mapToListBySet<T, E>(Set<E> set, Mixer<I, Set<E>, T> mixer) =>
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
  /// [mapWhere], [mapWhereByIndex]
  /// [mapWhereExpand]
  ///
  Iterable<S> mapExpand<S>(Mapper<I, Iterable<S>> expanding) =>
      [for (; moveNext();) ...expanding(current)];

  Iterable<S> mapWhere<S>(Predicator<I> test, Mapper<I, S> toVal) =>
      [for (; moveNext() && test(current);) toVal(current)];

  Iterable<S> mapWhereByIndex<S>(
    Predicator<I> test,
    MapperGenerator<I, S> toVal, [
    int start = 0,
  ]) =>
      [for (var i = start; moveNext() && test(current); i++) toVal(current, i)];

  Iterable<S> mapWhereExpand<S>(
    Predicator<I> test,
    Mapper<I, Iterable<S>> expanding,
  ) =>
      [for (; moveNext() && test(current);) ...expanding(current)];

  ///
  /// [mapFound]
  /// [mapFoundOr]
  /// [mapFoundOrNull]
  ///
  T mapFound<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) if (test(current)) return toVal(current);
    throw StateError(FErrorMessage.iteratorElementNotFound);
  }

  T mapFoundOr<T>(Predicator<I> test, Mapper<I, T> toVal, Supplier<T> orElse) {
    while (moveNext()) if (test(current)) return toVal(current);
    return orElse();
  }

  T? mapFoundOrNull<T>(Predicator<I> test, Mapper<I, T> toVal) {
    while (moveNext()) if (test(current)) return toVal(current);
    return null;
  }

  ///
  /// [mapUntil]
  /// [mapUntilByIndexExist]
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

  Iterable<S> mapUntilByIndexExist<S>(
    PredicatorFusionor<I> testInvalid,
    MapperGenerator<I, S> toVal, {
    bool includeFirst = true,
    bool includeInvalid = false,
    int start = 0,
  }) =>
      supplyMoveNext(() sync* {
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
  /// [mapToListUntilByIndex]
  /// [mapToListUntilByIndexExist]
  ///
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
    PredicatorFusionor<I> testInvalid,
    MapperGenerator<I, T> toVal, {
    bool includeFirst = true,
    bool includeFirstInvalid = false,
    int start = 0,
  }) =>
      supplyMoveNext(() {
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
  /// fold / [Iterable.fold]
  /// [fold]
  /// [foldByIndex], [foldNested],
  /// [foldByBefore], [foldByAfter],
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
    while (moveNext()) value = companion(value, current);
    return value;
  }

  T foldByIndex<T>(
    T initialValue,
    CompanionGenerator<T, I> companion, [
    int start = 0,
  ]) {
    var val = initialValue;
    for (var i = start; moveNext(); i++) val = companion(val, current, i);
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
  /// [foldByBefore]
  /// [foldByAfter]
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
  ///
  ///
  /// induct
  /// [induct], [inductByIndex]
  /// [inductInited], [inductInitedByIndex]
  ///
  ///
  ///

  ///
  /// [induct]
  /// [inductByIndex]
  ///
  T induct<T>(Mapper<I, T> toVal, Reducer<T> reducing) => supplyMoveNext(() {
        var val = toVal(current);
        while (moveNext()) val = reducing(val, toVal(current));
        return val;
      });

  T inductByIndex<T>(
    Mapper<I, T> toVal,
    ReducerGenerator<T> reducing, [
    int start = 0,
  ]) =>
      supplyMoveNext(() {
        var val = toVal(current);
        for (var i = start; moveNext(); i++) {
          val = reducing(val, toVal(current), i);
        }
        return val;
      });

  ///
  /// [inductInited]
  /// [inductInitedByIndex]
  ///
  T inductInited<T>(Mapper<I, T> init, Companion<T, I> reducing) =>
      supplyMoveNext(() {
        var val = init(current);
        while (moveNext()) val = reducing(val, current);
        return val;
      });

  T inductInitedByIndex<T>(
    Mapper<I, T> init,
    CompanionGenerator<T, I> reducing, [
    int start = 0,
  ]) =>
      supplyMoveNext(() {
        var val = init(current);
        for (var i = start; moveNext(); i++) val = reducing(val, current, i);
        return val;
      });

  ///
  ///
  ///
  /// record
  /// [consecutiveCounted], [consecutiveRepeated]
  /// [consecutiveOccurred]
  ///
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
  ///
  ///
  /// map / [Map.fromIterable]
  /// [toMap]
  /// [toMapIndexable]
  /// [toMapCounted]
  /// [toMapFrequencies]
  ///
  /// [groupBy]
  ///
  ///
  ///

  ///
  /// [toMap], [toMapIndexable]
  /// [toMapCounted], [toMapFrequencies]
  ///
  Map<K, V> toMap<K, V>([
    Mapper<dynamic, K>? toKey,
    Mapper<dynamic, V>? toValue,
  ]) =>
      Map<K, V>.fromIterable(takeAll, key: toKey, value: toValue);

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

  ///
  /// [groupBy]
  /// [groupToListBy]
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

  Map<K, List<I>> groupToListBy<K>(Mapper<I, K> toKey) => fold(
        {},
        (map, value) => map
          ..update(
            toKey(value),
            ListExtension.applyAdd(value),
            ifAbsent: () => [value],
          ),
      );
}

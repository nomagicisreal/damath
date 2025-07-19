part of '../collection.dart';

///
///
/// void callback             --> [pair], ...
/// return bool               --> [containsAll], ...
/// return int                --> [lengthOf], ...
/// return string             --> [joinToLines], ...
/// reduce current type item  --> [reduceTogether], ...
/// return typed item         --> [foldWith], ...
/// return iterable           --> [takeOn], ...
/// return list               --> [mapToListWhere], ...
/// return nested iterable    --> [chunk], ...
/// return map                --> [toMapByFilterOr], ...
/// return custom function    --> [applyAppend], ...
///
///
extension IterableExtension<I> on Iterable<I> {
  ///
  /// [pair], [copyInto]
  ///
  static void pair<I>(
    Iterable<I> iterable,
    Iterable<I> another,
    Intersector<I> paring, [
    Listener? onSizeDiff,
  ]) =>
      iterable.length == another.length
          ? IteratorTogether.pair(iterable.iterator, another.iterator, paring)
          : onSizeDiff?.call();

  static void copyInto<I>(
    Iterable<I> iterable,
    List<I> out, {
    Listener? onOutLarger,
    Listener? onOutSmaller,
  }) =>
      iterable.length == out.length
          ? IteratorExtension.consumeAllByIndex(
            iterable.iterator,
            (value, i) => out[i] = value,
          )
          : out.length > iterable.length
          ? onOutLarger?.call()
          : onOutSmaller?.call();

  ///
  ///
  /// [containsAll]
  /// [isLengthEqual], [isLengthDifferent]
  /// [isEqual], [isVariation]
  /// [anyWith], [anyWithEqual], [anyWithDifferent]
  ///
  ///

  ///
  /// [containsAll]
  ///
  static bool containsAll<I>(Iterable<I> iterable, Iterable<I> another) {
    for (final element in another) {
      if (!iterable.contains(element)) return false;
    }
    return true;
  }

  ///
  /// [isLengthEqual], [isLengthDifferent]
  /// [isEqual], [isVariation]
  ///
  static bool isLengthEqual<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length == b.length;

  static bool isLengthDifferent<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length != b.length;

  static bool isVariation<I>(Iterable<I> iterable, Iterable<I> another) {
    final iterableSet = iterable.toSet();
    final anotherSet = another.toSet();
    return iterableSet.length == anotherSet.length &&
        iterableSet.containsAll(anotherSet);
  }

  static bool isEqual<I>(Iterable<I> iterable, Iterable<I> another) =>
      iterable.length == another.length &&
      !IteratorTogether.pairAny(
        iterable.iterator,
        another.iterator,
        FPredicatorFusionor.isDifferent,
      );

  ///
  /// [anyWith]
  /// [anyWithEqual]
  /// [anyWithDifferent]
  ///
  static bool anyWith<I, P>(
    Iterable<I> iterable,
    Iterable<P> another,
    PredicatorMixer<I, P> test, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      iterable.length == another.length
          ? IteratorTogether.pairAny(iterable.iterator, another.iterator, test)
          : onSizeDiff?.call() ??
              (throw StateError(Erroring.iterableSizeInvalid));

  static bool anyWithEqual<I>(
    Iterable<I> iterable,
    Iterable<I> another, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      iterable.length == another.length
          ? IteratorTogether.pairAny(
            iterable.iterator,
            another.iterator,
            FPredicatorFusionor.isEqual,
          )
          : onSizeDiff?.call() ??
              (throw StateError(Erroring.iterableSizeInvalid));

  static bool anyWithDifferent<I>(
    Iterable<I> iterable,
    Iterable<I> another, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      iterable.length == another.length
          ? IteratorTogether.pairAny(
            iterable.iterator,
            another.iterator,
            FPredicatorFusionor.isDifferent,
          )
          : onSizeDiff?.call() ??
              (throw StateError(Erroring.iterableSizeInvalid));

  ///
  /// [lengthOf], [cardinalityOf]
  ///
  static int lengthOf<I>(Iterable<I> iterable) => iterable.length;

  static int cardinalityOf<I>(Iterable<I> iterable) => iterable.toSet().length;

  ///
  /// [joinToLines]
  ///
  static String joinToLines<I>(Iterable<I> iterable) => iterable.join('\n');

  ///
  /// [reduceTogether]
  ///
  static I reduceTogether<I>(
    Iterable<I> iterable,
    Iterable<I> another,
    Reducer<I> initialize,
    Collapser<I> collapse, [
    Supplier<I>? onSizeDiff,
  ]) =>
      iterable.length == another.length
          ? IteratorTogether.pairForcer(
            iterable.iterator,
            another.iterator,
            initialize,
            collapse,
          )
          : onSizeDiff?.call() ??
              (throw StateError(Erroring.iterableSizeInvalid));

  ///
  /// [foldWith]
  /// [foldTogether]
  ///
  static S foldWith<I, T, S>(
    Iterable<I> iterable,
    Iterable<T> another,
    S initialValue,
    Forcer<S, I, T> companion,
  ) =>
      iterable.length == another.length
          ? IteratorTogether.pairFold(
            iterable.iterator,
            initialValue,
            another.iterator,
            companion,
          )
          : throw StateError(Erroring.iterableSizeInvalid);

  static S foldTogether<I, E, S>(
    Iterable<I> iterable,
    S initialValue,
    Iterable<E> another,
    Companion<S, I> companion,
    Companion<S, E> companionAnother,
    Collapser<S> collapse,
  ) =>
      iterable.length == another.length
          ? IteratorTogether.pairFold(
            iterable.iterator,
            initialValue,
            another.iterator,
            (value, a, b) => collapse(
              value,
              companion(value, a),
              companionAnother(value, b),
            ),
          )
          : throw StateError(Erroring.iterableSizeInvalid);

  ///
  ///
  /// [takeOn], [sub]
  /// [expandWith], [expandTogether]
  /// [interval], [takeFor]
  ///
  ///

  ///
  /// [takeOn], [sub]
  ///
  static Iterable<I> takeOn<I>(Iterable<I> iterable, Iterable<bool> where) =>
      iterable.length == where.length
          ? where.iterator.takeFor(iterable.iterator)
          : throw StateError(Erroring.iterableSizeInvalid);

  static Iterable<I> sub<I>(Iterable<I> iterable, int start, [int? end]) =>
      iterable.length.isUpperClose(start, end)
          ? throw StateError(Erroring.iterableBoundaryInvalid)
          : IteratorExtension.sub(
            iterable.iterator,
            start,
            end ?? iterable.length,
          );

  ///
  /// [expandWith]
  /// [expandTogether]
  ///
  static Iterable<I> expandWith<I, E>(
    Iterable<I> iterable,
    Iterable<E> another,
    Mixer<I, E, Iterable<I>> expanding,
  ) =>
      iterable.length == another.length
          ? IteratorTogether.pairExpand(
            iterable.iterator,
            another.iterator,
            expanding,
          )
          : throw StateError(Erroring.iterableSizeInvalid);

  static Iterable<I> expandTogether<I, E>(
    Iterable<I> iterable,
    Iterable<E> another,
    Mapper<I, Iterable<I>> expanding,
    Mapper<E, Iterable<I>> expandingAnother,
    Reducer<Iterable<I>> reducing,
  ) =>
      iterable.length == another.length
          ? IteratorTogether.pairExpand(
            iterable.iterator,
            another.iterator,
            (p, q) => reducing(expanding(p), expandingAnother(q)),
          )
          : throw StateError(Erroring.iterableSizeInvalid);

  ///
  /// [interval], [takeFor]
  ///
  static Iterable<S> interval<I, T, S>(
    Iterable<I> iterable,
    Iterable<T> another,
    Linker<I, T, S> link,
  ) =>
      another.length + 1 == iterable.length
          ? IteratorTogether.pairInterval(
            iterable.iterator,
            another.iterator,
            link,
          )
          : throw StateError(Erroring.iterableSizeInvalid);

  static Iterable<I> takeFor<I>(
    Iterable<I> iterable,
    Iterable<bool> positions,
  ) =>
      positions.length == iterable.length
          ? positions.iterator.takeFor(iterable.iterator)
          : throw StateError(Erroring.iterableSizeInvalid);

  ///
  /// [mapToListWhere]
  ///
  static List<I> mapToListWhere<I>(Iterable<I> iterable, Predicator<I> test) {
    final result = <I>[];
    for (var element in iterable) {
      if (test(element)) result.add(element);
    }
    return result;
  }

  ///
  ///
  /// [chunk]
  /// [combination2]
  ///
  ///

  ///
  /// [chunk]
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.chunk([2, 1, 3, 1]); // [[2, 3], [4], [6, 10, 3], [9]]
  ///
  static Iterable<List<I>> chunk<I>(
    Iterable<I> iterable,
    Iterable<int> chunks,
  ) sync* {
    assert(chunks.sum == iterable.length);
    final iterator = iterable.iterator;
    for (var l in chunks) {
      final list = <I>[];
      for (var i = 0; i < l; i++) {
        iterator.moveNext();
        list.add(iterator.current);
      }
      yield list;
    }
  }

  ///
  /// [combination2]
  ///
  static Iterable<Iterable<I>> combination2<I>(Iterable<I> iterable) sync* {
    final length = iterable.length - 1;
    for (var i = 0; i < length; i++) {
      yield* IteratorTogether.combination2FromFirst(iterable.iterator);
      iterable = iterable.skip(1);
    }
  }

  ///
  /// [toMapByFilterOr]
  ///
  static Map<I, V> toMapByFilterOr<I, V>(
    Iterable<I> iterable,
    Map<I, V> keyValue,
    V nullFill,
  ) => Map.fromIterables(
    iterable,
    iterable.map((key) => keyValue[key] ?? nullFill),
  );

  ///
  /// [applyAppend]
  ///
  static Applier<Iterable<I>> applyAppend<I>(I value) =>
      (iterable) => [...iterable, value];
}

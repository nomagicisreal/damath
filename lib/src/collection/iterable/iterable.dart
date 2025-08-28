part of '../collection.dart';

///
///
/// static methods:
/// return bool               --> [predicateLengthEqual], ...
/// return int                --> [lengthOf], ...
/// return String             --> [joinToLines], ...
/// return custom function    --> [applyAppend], ...
///
/// instance methods:
/// void callback             --> [pair], ...
/// return bool               --> [containsAll], ...
/// return int                --> [cardinality], ...
/// reduce current type item  --> [reduceTogether], ...
/// return typed item         --> [foldWith], ...
/// return iterable string    --> [toIterableString], ...
/// return iterable           --> [takeOn], ...
/// return list               --> [mapToListWhere], ...
/// return nested iterable    --> [chunk], ...
/// return map                --> [toMapByFilterOr], ...
///
///
extension IterableExtension<I> on Iterable<I> {
  ///
  /// [predicateLengthEqual], [predicateLengthDifferent]
  /// [predicateVariation], [predicateAnyWithDifferent]
  ///
  static bool predicateLengthEqual<I>(Iterable<I> a, Iterable<I> b) =>
      a.length == b.length;

  static bool predicateLengthDifferent<I>(Iterable<I> a, Iterable<I> b) =>
      a.length != b.length;

  static bool predicateVariation<I>(Iterable<I> a, Iterable<I> b) {
    final thisSet = a.toSet();
    final anotherSet = b.toSet();
    return thisSet.length == anotherSet.length &&
        thisSet.containsAll(anotherSet);
  }

  static bool predicateAnyWithDifferent<I>(
    Iterable<I> a,
    Iterable<I> b, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      a.length == b.length
          ? a.iterator.pairAny(b.iterator, FPredicatorFusionor.isDifferent)
          : onSizeDiff?.call() ??
              (throw StateError(ErrorMessage.iterableSizeInvalid));

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
  /// [applyAppend]
  ///
  static Applier<Iterable<I>> applyAppend<I>(I value) =>
      (iterable) => [...iterable, value];

  ///
  ///
  /// [consumeAll]
  /// [pair]
  /// [copyInto]
  ///
  ///

  ///
  /// [consumeAll], [pair], [copyInto]
  ///
  void consumeAll(Consumer<I> listen) {
    for (var item in this) {
      listen(item);
    }
  }

  void pair(
    Iterable<I> another,
    BiCallback<I> paring, [
    Callback? onSizeDiff,
  ]) =>
      length == another.length
          ? iterator.pair(another.iterator, paring)
          : onSizeDiff?.call();

  void copyInto(List<I> out, {Callback? onOutLarger, Callback? onOutSmaller}) =>
      length == out.length
          ? iterator.consumeAllByIndex((value, i) => out[i] = value)
          : out.length > length
          ? onOutLarger?.call()
          : onOutSmaller?.call();

  ///
  ///
  /// [containsAll]
  /// [predicateLengthEqual], [predicateLengthDifferent]
  /// [isEqual], [isVariantTo]
  /// [anyWith], [anyWithEqual], [anyWithDifferent]
  ///
  ///

  ///
  /// [containsAll]
  ///
  ///
  /// [containsAll], [predicateLengthEqual], [predicateLengthDifferent]
  /// [isEqual], [isVariantTo]
  ///
  bool containsAll(Iterable<I> another) {
    for (final element in another) {
      if (!contains(element)) return false;
    }
    return true;
  }

  bool isVariantTo(Iterable<I> another) {
    final thisSet = toSet();
    final anotherSet = another.toSet();
    return thisSet.length == anotherSet.length &&
        thisSet.containsAll(anotherSet);
  }

  bool isEqual(Iterable<I> another) =>
      length == another.length &&
      !iterator.pairAny(another.iterator, FPredicatorFusionor.isDifferent);

  ///
  /// [anyWith]
  /// [anyWithEqual]
  /// [anyWithDifferent]
  ///

  ///
  /// [anyWith], [anyWithEqual], [anyWithDifferent]
  ///
  bool anyWith<P>(
    Iterable<P> another,
    PredicatorMixer<I, P> test, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, test)
          : onSizeDiff?.call() ??
              (throw StateError(ErrorMessage.iterableSizeInvalid));

  bool anyWithEqual(Iterable<I> another, [Supplier<bool>? onSizeDiff]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, FPredicatorFusionor.isEqual)
          : onSizeDiff?.call() ??
              (throw StateError(ErrorMessage.iterableSizeInvalid));

  bool anyWithDifferent(Iterable<I> another, [Supplier<bool>? onSizeDiff]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, FPredicatorFusionor.isDifferent)
          : onSizeDiff?.call() ??
              (throw StateError(ErrorMessage.iterableSizeInvalid));

  ///
  /// [cardinality]
  ///
  int get cardinality => toSet().length;

  ///
  /// [reduceTogether]
  ///

  ///
  /// [reduceTogether]
  ///
  I reduceTogether(
    Iterable<I> another,
    Reducer<I> initialize,
    Collapser<I> collapse, [
    Supplier<I>? onSizeDiff,
  ]) =>
      length == another.length
          ? iterator.pairForcer(another.iterator, initialize, collapse)
          : onSizeDiff?.call() ??
              (throw StateError(ErrorMessage.iterableSizeInvalid));

  ///
  /// [foldWith]
  /// [foldTogether]
  ///
  S foldWith<T, S>(
    Iterable<T> another,
    S initialValue,
    Forcer<S, I, T> companion,
  ) =>
      length == another.length
          ? iterator.pairFold(initialValue, another.iterator, companion)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  S foldTogether<E, S>(
    S initialValue,
    Iterable<E> another,
    Companion<S, I> companion,
    Companion<S, E> companionAnother,
    Collapser<S> collapse,
  ) =>
      length == another.length
          ? iterator.pairFold(
            initialValue,
            another.iterator,
            (value, a, b) => collapse(
              value,
              companion(value, a),
              companionAnother(value, b),
            ),
          )
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  ///
  /// [toIterableString]
  ///
  Iterable<String> get toIterableString sync* {
    for (var item in this) {
      yield '$item';
    }
  }

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
  Iterable<I> takeOn(Iterable<bool> where) =>
      length == where.length
          ? where.iterator.takeFor(iterator)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  Iterable<I> sub(int start, [int? end]) =>
      length.isUpperClose(start, end)
          ? throw StateError(ErrorMessage.iterableBoundaryInvalid)
          : iterator.sub(start, end ?? length);

  ///
  /// [expandWith], [expandTogether]
  ///
  Iterable<I> expandWith<E>(
    Iterable<E> another,
    Mixer<I, E, Iterable<I>> expanding,
  ) =>
      length == another.length
          ? iterator.pairExpand(another.iterator, expanding)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  Iterable<I> expandTogether<E>(
    Iterable<E> another,
    Mapper<I, Iterable<I>> expanding,
    Mapper<E, Iterable<I>> expandingAnother,
    Reducer<Iterable<I>> reducing,
  ) =>
      length == another.length
          ? iterator.pairExpand(
            another.iterator,
            (p, q) => reducing(expanding(p), expandingAnother(q)),
          )
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  ///
  /// [interval], [takeFor]
  ///
  Iterable<S> interval<T, S>(Iterable<T> another, Linker<I, T, S> link) =>
      another.length + 1 == length
          ? iterator.pairInterval(another.iterator, link)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  Iterable<I> takeFor(Iterable<bool> positions) =>
      positions.length == length
          ? positions.iterator.takeFor(iterator)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  ///
  /// [mapToListWhere]
  ///
  List<I> mapToListWhere(Predicator<I> test) {
    final result = <I>[];
    for (var element in this) {
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
  Iterable<List<I>> chunk(Iterable<int> chunks) sync* {
    assert(chunks.sum == length);
    final iterator = this.iterator;
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
  Iterable<Iterable<I>> combination2() sync* {
    var iterable = this;
    final length = iterable.length - 1;
    for (var i = 0; i < length; i++) {
      yield* iterable.iterator.combination2FromFirst;
      iterable = iterable.skip(1);
    }
  }

  ///
  /// [toMapByFilterOr]
  ///
  Map<I, V> toMapByFilterOr<V>(Map<I, V> keyValue, V nullFill) =>
      Map.fromIterables(this, map((key) => keyValue[key] ?? nullFill));
}

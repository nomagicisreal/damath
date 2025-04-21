part of '../collection.dart';

///
/// static methods:
/// [toLength], ...
/// [fill], ...
/// [generateFrom], ...
///
/// instance getter and methods
/// [pair], ...
/// [copyInto], ...
///
/// [containsAll], ...
/// [isVariationTo], ...
/// [anyWith], ...
///
/// [joinToLines], ...
///
/// [reduceTogether], ...
///
/// [cloneIterable], ...
/// [append], ...
/// [expandWith], ...
/// [interval], ...
///
/// [foldWith], ...
///
/// [cardinality], ...
///
/// [chunk], ...
/// [combination2], ...
/// [toMapByFilterOr], ...
///
///
extension DamathIterable<I> on Iterable<I> {
  ///
  /// [toLength]
  /// [applyAppend]
  ///
  static int toLength<I>(Iterable<I> iterable) => iterable.length;

  static Applier<Iterable<I>> applyAppend<I>(I value) =>
      (iterable) => iterable.append(value);

  ///
  /// [fill]
  /// [generateFrom]
  ///
  static Iterable<I> fill<I>(int count, I value) =>
      [for (var i = 0; i < count; i++) value];

  static Iterable<I> generateFrom<I>(
    int count,
    Generator<I> generator, [
    int start = 1,
  ]) =>
      [for (var i = start; i < count; i++) generator(i)];

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
      a.anyWithDifferent(b);

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  void pair(Iterable<I> another, Intersector<I> paring,
          [Listener? onSizeDiff]) =>
      length == another.length
          ? iterator.pair(another.iterator, paring)
          : onSizeDiff?.call();

  ///
  /// [copyInto]
  ///
  void copyInto(List<I> out, {Listener? onOutLarger, Listener? onOutSmaller}) =>
      length == out.length
          ? iterator.consumeAllByIndex((value, i) => out[i] = value)
          : out.length > length
              ? onOutLarger?.call()
              : onOutSmaller?.call();

  ///
  ///
  ///
  ///
  /// predication
  /// [containsAll], [notContains], [notContainsAll]
  /// [isVariationTo], [isEqualTo]
  /// [anyWith], [anyWithEqual], [anyWithDifferent]
  ///
  ///
  ///
  ///

  ///
  /// [containsAll]
  /// [notContains], [notContainsAll]
  ///
  bool containsAll(Iterable<I> another) {
    for (final element in another) if (notContains(element)) return false;
    return true;
  }

  bool notContains(I element) {
    for (final value in this) if (value == element) return false;
    return true;
  }

  bool notContainsAll(Iterable<I> another) {
    for (final element in another) if (contains(element)) return false;
    return true;
  }

  ///
  /// [isVariationTo]
  /// [isEqualTo]
  ///
  bool isVariationTo(Iterable<I> another) => another.cardinality == cardinality;

  bool isEqualTo(Iterable<I> another) =>
      length == another.length &&
      !iterator.pairAny(another.iterator, FPredicatorFusionor.isDifferent);

  ///
  /// [anyWith]
  /// [anyWithEqual]
  /// [anyWithDifferent]
  ///
  bool anyWith<P>(
    Iterable<P> another,
    PredicatorMixer<I, P> test, [
    Supplier<bool>? onSizeDiff,
  ]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, test)
          : onSizeDiff?.call() ??
              (throw StateError(FErrorMessage.iterableSizeInvalid));

  bool anyWithEqual(Iterable<I> another, [Supplier<bool>? onSizeDiff]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, FPredicatorFusionor.isEqual)
          : onSizeDiff?.call() ??
              (throw StateError(FErrorMessage.iterableSizeInvalid));

  bool anyWithDifferent(Iterable<I> another, [Supplier<bool>? onSizeDiff]) =>
      length == another.length
          ? iterator.pairAny(another.iterator, FPredicatorFusionor.isDifferent)
          : onSizeDiff?.call() ??
              (throw StateError(FErrorMessage.iterableSizeInvalid));

  ///
  /// [joinToLines]
  ///
  String get joinToLines => join('\n');

  ///
  ///
  /// [reduceTogether]
  ///
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
              (throw StateError(FErrorMessage.iterableSizeInvalid));

  ///
  ///
  /// [cloneIterable], [takeOn], [subIterable]
  /// [append], [appendAll]
  /// [stack], [stackAll]
  /// [expandWith], [expandTogether]
  /// [interval]
  ///
  ///
  ///
  ///

  ///
  /// [cloneIterable]
  /// [mapToListWhere]
  /// [takeOn]
  /// [subIterable]
  ///
  Iterable<I> get cloneIterable sync* {
    yield* this;
  }

  List<I> mapToListWhere(Predicator<I> test) {
    final result = <I>[];
    for (var element in this) {
      if (test(element)) result.add(element);
    }
    return result;
  }

  Iterable<I> takeOn(Iterable<bool> where) => length == where.length
      ? where.iterator.takeFor(iterator)
      : throw StateError(FErrorMessage.iterableSizeInvalid);

  Iterable<I> subIterable(int start, [int? end]) {
    if (length.isBoundClose(start, end)) {
      throw StateError(FErrorMessage.iterableBoundaryInvalid);
    }
    return iterator.sub(start, end ?? length);
  }

  ///
  /// [append], [appendAll]
  /// [stack], [stackAll]
  ///
  Iterable<I> append(I value) sync* {
    yield* this;
    yield value;
  }

  Iterable<I> appendAll(Iterable<I> other) sync* {
    yield* this;
    yield* other;
  }

  Iterable<I> stack(I value) sync* {
    yield value;
    yield* this;
  }

  Iterable<I> stackAll(Iterable<I> other) sync* {
    yield* other;
    yield* this;
  }

  ///
  /// [expandWith]
  /// [expandTogether]
  ///
  Iterable<I> expandWith<E>(
    Iterable<E> another,
    Mixer<I, E, Iterable<I>> expanding,
  ) =>
      length == another.length
          ? iterator.pairExpand(another.iterator, expanding)
          : throw StateError(FErrorMessage.iterableSizeInvalid);

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
          : throw StateError(FErrorMessage.iterableSizeInvalid);

  ///
  /// [interval]
  ///
  Iterable<S> interval<T, S>(Iterable<T> another, Linker<I, T, S> link) =>
      another.length + 1 == length
          ? iterator.pairInterval(another.iterator, link)
          : throw StateError(FErrorMessage.iterableSizeInvalid);

  ///
  ///
  ///
  Iterable<I> takeFor(Iterable<bool> positions) => positions.length == length
      ? positions.iterator.takeFor(iterator)
      : throw StateError(FErrorMessage.iterableSizeInvalid);

  ///
  ///
  ///
  /// [foldWith], [foldTogether]
  ///
  ///
  ///

  ///
  ///
  /// [foldWith]
  /// [foldTogether]
  ///
  S foldWith<S, T>(
    Iterable<T> another,
    S initialValue,
    Forcer<S, I, T> companion,
  ) =>
      length == another.length
          ? iterator.pairFold(initialValue, another.iterator, companion)
          : throw StateError(FErrorMessage.iterableSizeInvalid);

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
          : throw StateError(FErrorMessage.iterableSizeInvalid);

  ///
  ///
  ///
  ///
  /// [cardinality]
  ///
  ///
  ///
  ///

  ///
  /// [cardinality]
  ///
  int get cardinality => toSet().length;

  ///
  ///
  ///
  ///
  ///
  ///
  /// [chunk]
  /// [combination2]
  ///
  ///
  ///
  ///
  ///

  ///
  /// [chunk]
  ///

  ///
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
  Iterable<Iterable<I>> get combination2 sync* {
    final length = this.length - 1;
    var iterable = this;
    for (var i = 0; i < length; i++) {
      yield* iterable.iterator.combination2FromFirst;
      iterable = iterable.skip(1);
    }
  }

  ///
  ///
  ///
  Map<I, V> toMapByFilterOr<V>(Map<I, V> keyValue, V nullFill) =>
      Map.fromIterables(this, map((key) => keyValue[key] ?? nullFill));
}

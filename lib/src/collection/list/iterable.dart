part of damath_collection;

///
/// static methods:
/// [toLength], ...
/// [fill], ...
/// [generateFrom], ...
///
/// instance getter and methods
/// [cardinality]
/// [anyElementWith], ...
/// [append], ...
///
/// [foldWith], ...
/// [reduceWith], ...
/// [expandWith], ...
///
/// [isEqualTo], ...
/// [interval], ...
/// [copyInto], ...
///
/// [chunk], ...
///
extension IterableExtension<I> on Iterable<I> {
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
  static Iterable<I> fill<I>(int count, I value) sync* {
    for (var i = 0; i < count; i++) {
      yield value;
    }
  }

  static Iterable<I> generateFrom<I>(
    int count,
    Generator<I> generator, [
    int start = 1,
  ]) sync* {
    for (var i = start; i < count; i++) {
      yield generator(i);
    }
  }

  ///
  /// [cardinality]
  /// [isVariationTo]
  ///
  int get cardinality => toSet().length;

  bool isVariationTo(Iterable<I> another) => another.cardinality == cardinality;

  ///
  /// [anyElementWith]
  /// [anyElementIsEqualWith]
  /// [anyElementIsDifferentWith]
  ///
  bool anyElementWith<P>(Iterable<P> another, PredicatorMixer<I, P> test) {
    assert(length == another.length);
    return iterator.interAny(another.iterator, test);
  }

  bool anyElementIsEqualWith(Iterable<I> another) =>
      anyElementWith(another, FPredicatorCombiner.isEqual);

  bool anyElementIsDifferentWith(Iterable<I> another) =>
      anyElementWith(another, FPredicatorCombiner.isDifferent);

  ///
  /// append
  /// [append], [appendAll]
  ///
  Iterable<I> append(I value) sync* {
    yield* this;
    yield value;
  }

  Iterable<I> appendAll(Iterable<I> other) sync* {
    yield* this;
    yield* other;
  }

  ///
  ///
  /// get, fold, reduce, expand
  /// [takeOn]
  /// [foldWith], [foldTogether]
  /// [reduceWith], [reduceTogether]
  /// [expandWith], [expandTogether]
  ///
  Iterable<I> takeOn(Iterable<bool> where) {
    assert(length == where.length);
    return iterator.interTakeOn(where.iterator);
  }

  ///
  /// [foldWith]
  /// [foldTogether]
  ///
  S foldWith<S, T>(
    Iterable<T> another,
    S initialValue,
    Collector<S, I, T> companion,
  ) {
    assert(length == another.length);
    return iterator.interFold(initialValue, another.iterator, companion);
  }

  S foldTogether<E, S>(
    S initialValue,
    Iterable<E> another,
    Companion<S, I> companion,
    Companion<S, E> companionAnother,
    Collapser<S> combine,
  ) {
    assert(length == another.length);
    return iterator.interFold(
      initialValue,
      another.iterator,
      (value, a, b) => combine(
        value,
        companion(value, a),
        companionAnother(value, b),
      ),
    );
  }

  ///
  /// [reduceWith]
  /// [reduceTogether]
  ///
  I reduceWith(
      Iterable<I> another, Reducer<I> initialize, Collapser<I> mutual) {
    assert(length == another.length);
    return iterator.interReduceInitialized(another.iterator, initialize, mutual);
  }

  I reduceTogether(
    Iterable<I> another,
    Reducer<I> initialize,
    Collapser<I> reducer,
  ) {
    assert(length == another.length);
    return iterator.interReduceInitialized(another.iterator, initialize, reducer);
  }

  ///
  /// [expandWith]
  /// [expandTogether]
  ///
  Iterable<I> expandWith<E>(
    Iterable<E> another,
    Mixer<I, E, Iterable<I>> expanding,
  ) {
    assert(length == another.length);
    return iterator.interExpandTo(another.iterator, expanding);
  }

  Iterable<I> expandTogether<E>(
    Iterable<E> another,
    Mapper<I, Iterable<I>> expanding,
    Mapper<E, Iterable<I>> expandingAnother,
    Reducer<Iterable<I>> combine,
  ) {
    assert(length == another.length);
    return iterator.interExpandTo(
      another.iterator,
      (p, q) => combine(expanding(p), expandingAnother(q)),
    );
  }

  ///
  /// [isEqualTo]
  ///
  bool isEqualTo(Iterable<I> another) =>
      length == another.length &&
      !iterator.interAny(another.iterator, FPredicatorCombiner.isDifferent);

  ///
  /// [interval]
  ///
  Iterable<S> interval<T, S>(Iterable<T> another, Linker<I, T, S> link) {
    assert(another.length + 1 == length);
    return iterator.intervalBy(another.iterator, link);
  }

  ///
  /// [copyInto]
  ///
  void copyInto(List<I> out) {
    assert(length == out.length);
    iterator.consumeAllByIndex((value, i) => out[i] = value);
  }

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
}

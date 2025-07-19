part of '../collection.dart';

///
///
/// [IterableComparable]
/// [IterableInt]
/// [IterableDouble]
/// [Iterable2DComparable]
///
/// 'flutter pub add statistics' for advance statistic analyze
///
///

///
///
/// [mergeSorted], ...
/// [isOrdered], ...
/// [permutations], ...
/// [consecutive], ...
///
///
extension IterableComparable<C extends Comparable> on Iterable<C> {
  ///
  ///
  ///
  static void checkSortedForListen<C extends Comparable, S>(
    Iterable<C> iterable,
    Listener listen, [
    bool increase = true,
  ]) =>
      iterable.isSorted(IteratorComparable.comparator(increase))
          ? listen()
          : throw Erroring.comparableDisordered;

  static S checkSortedForSupply<C extends Comparable, S>(
    Iterable<C> iterable,
    Supplier<S> supply, [
    bool increase = true,
  ]) =>
      iterable.isSorted(IteratorComparable.comparator(increase))
          ? supply()
          : throw Erroring.comparableDisordered;

  ///
  ///
  ///
  static void mergeSorted<C extends Comparable>(
    Iterable<C> first,
    Iterable<C> another, [
    bool increase = true,
  ]) => checkSortedForListen(
    first,
    () => IteratorTogether.pairMerge(
      first.iterator,
      checkSortedForSupply(another, () => another.iterator, increase),
      increase ? IteratorComparable.isDecrease : IteratorComparable.isIncrease,
    ),
    increase,
  );

  ///
  /// [isOrdered]
  ///
  static bool isOrdered<C extends Comparable>(
    Iterable<C> iterable, {
    OrderLinear? order,
    bool strictly = false,
  }) => switch (order) {
    OrderLinear.increase => IteratorExtension.exist(
      iterable.iterator,
      IteratorComparable.invalidFor(OrderLinear.increase, strictly),
    ),
    OrderLinear.decrease => IteratorExtension.exist(
      iterable.iterator,
      IteratorComparable.invalidFor(OrderLinear.decrease, strictly),
    ),
    null =>
      IteratorExtension.exist(
            iterable.iterator,
            IteratorComparable.invalidFor(OrderLinear.increase, strictly),
          ) ||
          IteratorExtension.exist(
            iterable.iterator,
            IteratorComparable.invalidFor(OrderLinear.decrease, strictly),
          ),
  };

  ///
  /// [everyRangeIn]
  ///
  static bool everyUpperThan<C extends Comparable>(
    Iterable<C> iterable,
    C min, [
    bool orSame = false,
  ]) => !iterable.any(IteratorComparable.predicateLower(min, orSame));

  static bool everyLowerThan<C extends Comparable>(
    Iterable<C> iterable,
    C max, [
    bool orSame = false,
  ]) => !iterable.any(IteratorComparable.predicateUpper(max, orSame));

  static bool everyRangeIn<C extends Comparable>(
    Iterable<C> iterable,
    C min,
    C max, {
    bool inclusiveMin = true,
    bool inclusiveMax = true,
  }) {
    final lower = IteratorComparable.predicateLower(min, !inclusiveMin);
    final upper = IteratorComparable.predicateUpper(max, !inclusiveMax);
    return !iterable.any((value) => lower(value) || upper(value));
  }

  ///
  /// [permutations]
  ///
  static int permutations<C extends Comparable>(
    Iterable<C> iterable, [
    bool requireIdentical = false,
  ]) {
    if (!isOrdered(iterable, strictly: requireIdentical)) {
      throw StateError(Erroring.comparableDisordered);
    }
    if (requireIdentical) return IntExtension.factorial(iterable.length);

    final iterator = iterable.iterator..moveNext();
    var previous = iterator.current;
    var val = 1;
    var frequency = 1;
    for (var i = 2; iterator.moveNext(); i++) {
      val *= i;
      if (previous == iterator.current) {
        frequency++;
        continue;
      }
      if (frequency > 1) val ~/= IntExtension.factorial(frequency);
      previous = iterator.current;
      frequency = 1;
    }
    if (frequency > 1) val ~/= IntExtension.factorial(frequency);
    return val;
  }

  ///
  /// [consecutive]
  /// [consecutiveOccurred]
  ///
  static Iterable<(C, int)> consecutive<C extends Comparable>(
    Iterable<C> iterable, [
    bool onlyRepeated = true,
  ]) =>
      isOrdered(iterable, strictly: false)
          ? onlyRepeated
              ? IteratorTo.consecutiveRepeated(iterable.iterator)
              : IteratorTo.consecutiveCounted(iterable.iterator)
          : throw StateError(Erroring.comparableDisordered);

  static Iterable<int> consecutiveOccurred<C extends Comparable>(
    Iterable<C> iterable,
  ) =>
      isOrdered(iterable, strictly: false)
          ? IteratorTo.consecutiveOccurred(iterable.iterator)
          : throw StateError(Erroring.comparableDisordered);

  // ///
  // /// [groupToIterable]
  // ///
  // // instead of list.add, it's better to insert by binary general comparable
  // Iterable<Iterable<C>> groupToIterable([bool increase = true]) =>
  //     iterator.checkSortedForSupply(
  //       () {
  //         final iterator = this.iterator;
  //         return iterator.moveNextSupply(() sync* {
  //           var previous = iterator.current;
  //           while (iterator.moveNext()) {
  //             yield takeWhile(
  //                 (value) => IteratorComparable.isEqual(previous, value));
  //             throw UnimplementedError();
  //           }
  //         });
  //       },
  //       increase,
  //     );
}

///
/// [sequence], ...
///
extension IterableInt on Iterable<int> {
  static Iterable<int> sequence(int length, [int start = 1]) =>
      Iterable.generate(length, (i) => start + i);

  static Iterable<int> seq(int begin, int end) => [
    for (var i = begin; i <= end; i++) i,
  ];
}

///
///
/// [distanceTo], ...
/// [normalized], ...
/// [statisticAnalyze], ...
///
///
extension IterableDouble on Iterable<double> {
  ///
  /// [dot]
  ///
  static double dot(Iterable<double> vector, Iterable<double> another) {
    assert(vector.length == another.length);
    return IteratorTogether.interReduce(
      vector.iterator,
      another.iterator,
      DoubleExtension.reduceMultiply,
      DoubleExtension.reducePlus,
    );
  }

  ///
  /// [distanceTo], [distanceFrom]
  /// [distanceEachTo], [distanceEachFrom]
  ///
  static double distanceTo(
    Iterable<double> vector,
    Iterable<double> destination,
  ) {
    assert(destination.length == vector.length);
    return IteratorDouble.interDistanceCumulate(
      destination.iterator,
      vector.iterator,
    );
  }

  static double distanceFrom(Iterable<double> vector, Iterable<double> source) {
    assert(source.length == vector.length);
    return IteratorDouble.interDistanceCumulate(
      vector.iterator,
      source.iterator,
    );
  }

  static Iterable<double> distanceEachTo(
    Iterable<double> vector,
    Iterable<double> destination,
  ) {
    assert(destination.length == vector.length);
    return IteratorDouble.interDistanceTo(
      destination.iterator,
      vector.iterator,
    );
  }

  static Iterable<double> distanceEachFrom(
    Iterable<double> vector,
    Iterable<double> source,
  ) {
    assert(source.length == vector.length);
    return IteratorDouble.interDistanceFrom(vector.iterator, source.iterator);
  }

  ///
  /// [normalized]
  /// [normalizeInto]
  ///
  static Iterable<double> normalized(Iterable<double> vector) =>
      IteratorExtension.takeAllCompanion(
        vector.iterator,
        IteratorDouble.distance(vector.iterator),
        DoubleExtension.reduceDivided,
      );

  static void normalizeInto(Iterable<double> vector, List<double> out) {
    assert(out.length == vector.length);
    IteratorExtension.consumeAccompanyByIndex(
      vector.iterator,
      IteratorDouble.distance(vector.iterator),
      (value, d, i) => out[i] = value / d,
    );
  }

  ///
  /// [statisticAnalyze]
  ///
  static Iterable<double> statisticAnalyze(
    Iterable<double> iterable, {
    bool requireLength = true,
    bool requireMean = true,
    bool requireStandardDeviation = true,
    bool requireStandardError = true,
    bool? requireTScores, // t scores or z scores
    double? requireConfidenceInterval = 0.95,
  }) sync* {
    /// n, µ
    var n = 0.0;
    var total = 0.0;
    for (var value in iterable) {
      total += value;
      n++;
    }
    final mean = total / n;
    if (requireLength) yield n;
    if (requireMean) yield mean;

    ///
    /// standard deviation, standard error
    ///
    var sum = 0.0;
    for (var value in iterable) {
      sum += (value - mean).squared;
    }
    final sd = sum / n;
    final se = sd / math.sqrt(n);
    if (requireStandardDeviation) yield sd;
    if (requireStandardError) yield se;

    ///
    /// scores
    ///
    if (requireTScores != null) {
      yield* requireTScores
          ? IteratorExtension.takeAllApply(
            iterable.iterator,
            (x) => (x - mean) / sd * 10 + 50,
          )
          : IteratorExtension.takeAllApply(
            iterable.iterator,
            (x) => (x - mean) / sd,
          );
    }

    ///
    /// confidence interval (µ - z * se ~ µ + z(se))
    ///
    if (requireConfidenceInterval != null) {
      final z = switch (requireConfidenceInterval) {
        0.95 => 1.96,
        0.99 => 2.576,
        _ => throw UnimplementedError(),
      };
      yield mean - z * se;
      yield mean + z * se;
    }
  }
}

///
///
///
extension Iterable2DComparable<C extends Comparable> on Iterable2D<C> {
  ///
  /// [everyElementSorted]
  /// [everyElementSortedThen]
  ///
  static bool everyElementSorted<C extends Comparable>(
    Iterable2D<C> iterable2D, [
    bool increase = true,
  ]) => iterable2D.every(
    (sub) => sub.isSorted(IteratorComparable.comparator(increase)),
  );

  static void everyElementSortedThen<C extends Comparable>(
    Iterable2D<C> iterable2D,
    Listener listen, [
    bool increase = true,
  ]) =>
      iterable2D.every(
            (sub) => sub.isSorted(IteratorComparable.comparator(increase)),
          )
          ? listen()
          : throw StateError(Erroring.comparableDisordered);
}

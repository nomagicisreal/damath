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
  void checkSortedForListen(Callback listen, [bool increase = true]) =>
      isSorted(IteratorComparable.comparator(increase))
          ? listen()
          : throw ErrorMessage.comparableDisordered;

  S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
      isSorted(IteratorComparable.comparator(increase))
          ? supply()
          : throw ErrorMessage.comparableDisordered;

  ///
  ///
  ///
  void mergeSorted(Iterable<C> another, [bool increase = true]) =>
      checkSortedForListen(
        () => iterator.pairMerge(
          another.checkSortedForSupply(() => another.iterator, increase),
          increase
              ? IteratorComparable.isDecrease
              : IteratorComparable.isIncrease,
        ),
        increase,
      );

  ///
  /// [isNotOrdered]
  /// [isOrdered]
  ///
  /// see also [collection].[isSorted], which requires a [Comparator]
  ///
  bool isNotOrdered({OrderLinear? order, bool strictly = false}) {
    final invalid = IteratorComparable.predicateInvalid;
    if (order != null) return iterator.exist(invalid(order, strictly));
    return iterator.exist(invalid(OrderLinear.increase, strictly)) ||
        iterator.exist(invalid(OrderLinear.decrease, strictly));
  }

  bool isOrdered({OrderLinear? order, bool strictly = false}) =>
      !isNotOrdered(order: order, strictly: strictly);

  ///
  /// [everyUpperThan]
  /// [everyLowerThan]
  /// [everyRangeIn]
  ///
  bool everyUpperThan(C min, [bool orSame = false]) =>
      !any(IteratorComparable.predicateLower(min, orSame));

  bool everyLowerThan(C max, [bool orSame = false]) =>
      !any(IteratorComparable.predicateUpper(max, orSame));

  bool everyRangeIn(
    C min,
    C max, {
    bool inclusiveMin = true,
    bool inclusiveMax = true,
  }) {
    final lower = IteratorComparable.predicateLower(min, !inclusiveMin);
    final upper = IteratorComparable.predicateUpper(max, !inclusiveMax);
    return !any((value) => lower(value) || upper(value));
  }

  ///
  /// [permutations]
  ///
  int permutations([bool requireIdentical = false]) {
    if (!isOrdered(strictly: requireIdentical)) {
      throw StateError(ErrorMessage.comparableDisordered);
    }
    if (requireIdentical) return IntExtension.factorial(length);

    final iterator = this.iterator..moveNext();
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
  Iterable<(C, int)> consecutive([bool onlyRepeated = true]) =>
      isOrdered(strictly: false)
          ? onlyRepeated
              ? iterator.consecutiveRepeated
              : iterator.consecutiveCounted
          : throw StateError(ErrorMessage.comparableDisordered);

  Iterable<int> get consecutiveOccurred =>
      isOrdered(strictly: false)
          ? iterator.consecutiveOccurred
          : throw StateError(ErrorMessage.comparableDisordered);

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
  double dot(Iterable<double> another) {
    assert(length == another.length);
    return iterator.interReduce(
      another.iterator,
      DoubleExtension.reduceMultiply,
      DoubleExtension.reducePlus,
    );
  }

  ///
  /// [distanceTo], [distanceFrom]
  /// [distanceEachTo], [distanceEachFrom]
  ///
  double distanceTo(Iterable<double> destination) {
    assert(destination.length == length);
    return destination.iterator.interDistanceCumulate(iterator);
  }

  double distanceFrom(Iterable<double> source) {
    assert(source.length == length);
    return iterator.interDistanceCumulate(source.iterator);
  }

  Iterable<double> distanceEachTo(Iterable<double> destination) {
    assert(destination.length == length);
    return destination.iterator.interDistanceTo(iterator);
  }

  Iterable<double> distanceEachFrom(Iterable<double> source) {
    assert(source.length == length);
    return iterator.interDistanceFrom(source.iterator);
  }

  Iterable<double> get normalized => iterator.takeAllCompanion(
    iterator.distance,
    DoubleExtension.reduceDivided,
  );

  void normalizeInto(List<double> out) {
    assert(out.length == length);
    iterator.consumeAccompanyByIndex(
      iterator.distance,
      (value, d, i) => out[i] = value / d,
    );
  }

  Iterable<double> statisticAnalyze({
    bool requireLength = true,
    bool requireMean = true,
    bool requireStandardDeviation = true,
    bool requireStandardError = true,
    bool? requireTScores,
    double? requireConfidenceInterval = 0.95,
  }) sync* {
    var n = 0.0;
    var total = 0.0;
    for (var value in this) {
      total += value;
      n++;
    }
    final mean = total / n;
    if (requireLength) yield n;
    if (requireMean) yield mean;

    var sum = 0.0;
    for (var value in this) {
      sum += (value - mean).squared;
    }
    final sd = sum / n;
    final se = sd / math.sqrt(n);
    if (requireStandardDeviation) yield sd;
    if (requireStandardError) yield se;

    if (requireTScores != null) {
      yield* requireTScores
          ? iterator.takeAllApply((x) => (x - mean) / sd * 10 + 50)
          : iterator.takeAllApply((x) => (x - mean) / sd);
    }

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
  bool everyElementSorted([bool increase = true]) =>
      every((sub) => sub.isSorted(IteratorComparable.comparator(increase)));

  void everyElementSortedThen(Callback listen, [bool increase = true]) =>
      every((sub) => sub.isSorted(IteratorComparable.comparator(increase)))
          ? listen()
          : throw StateError(ErrorMessage.comparableDisordered);
}

///
///
/// this file contains:
///
/// [IteratorBool]
/// [IteratorDouble]
/// [IterableMapEntry]
///
/// [IterableDouble]
/// [IterableInt]
///
/// [ListDouble]
///
///
/// 'flutter pub add statistics' for advance statistic analyze
///
///
part of damath_collection;

///
/// static methods:
/// [_keep], ...
///
/// instance getters, methods:
/// [isSatisfiable], ...
///
///
extension IteratorBool on Iterator<bool> {
  static bool _keep(bool value) => value;

  static bool _reverse(bool value) => !value;

  ///
  /// [isSatisfiable], [isTautology], [isContradiction], [isContingency]
  ///
  bool get isSatisfiable => any(_keep);

  bool get isTautology => !any(_reverse);

  bool get isContradiction => !any(_keep);

  bool get isContingency => existDifferent;
}

///
///
/// static methods:
/// [maxDistance], ...
///
/// instance methods:
/// [min], ...
/// [sum], ...
/// [distance], ...
///
/// [abs], ...
/// [interDistanceTo], ...
///
///
///
extension IteratorDouble on Iterator<double> {
  ///
  /// iterator
  ///
  static Iterator<double> maxDistance(Iterator<double> a, Iterator<double> b) =>
      a.distance > b.distance ? a : b;

  static Iterator<double> minDoubleDistance(
          Iterator<double> a, Iterator<double> b) =>
      a.distance < b.distance ? a : b;

  ///
  /// [min], [max], [mode]
  /// [range], [boundary]
  ///
  double get min => reduce(FReducer.doubleMin);

  double get max => reduce(FReducer.doubleMax);

  double get mode => toMapCounted.reduce(FReducer.entryValueIntMax).key;

  double get range => moveNextApply((value) {
        var min = value;
        var max = value;
        while (moveNext()) {
          if (current < min) min = current;
          if (current > max) max = current;
        }
        return max - min;
      });

  (double, double) get boundary => moveNextSupply(() {
        var min = current;
        var max = current;
        while (moveNext()) {
          if (current < min) min = current;
          if (current > max) max = current;
        }
        return (min, max);
      });

  ///
  /// [sum], [sumSquared]
  /// [meanArithmetic], [meanGeometric]
  ///
  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);

  double get meanArithmetic => moveNextApply((total) {
        var length = 1;
        while (moveNext()) {
          total += current;
          length++;
        }
        return total / length;
      });

  double get meanGeometric => moveNextApply((total) {
        var length = 1;
        while (moveNext()) {
          total *= current;
          length++;
        }
        return math.pow(total, 1 / length).toDouble();
      });

  ///
  /// [distance], [volume]
  ///
  double get distance => math.sqrt(reduce(FReducer.doubleAddSquared));

  double get volume => reduce(FReducer.doubleMultiply);

  ///
  /// [abs], [rounded], [roundUpTo]
  /// [takeAllPlus], [takeAllSubtract], [takeAllMultiply], [takeAllDivide], [takeAllDivideToInt]
  ///
  Iterable<double> get abs => takeAllApply((v) => v.abs());

  Iterable<double> get rounded => takeAllApply((v) => v.roundToDouble());

  Iterable<double> roundUpTo(int d) => takeAllApply((v) => v.roundUpTo(d));

  Iterable<double> takeAllPlus(int v) => takeAllApply((o) => o + v);

  Iterable<double> takeAllSubtract(int v) => takeAllApply((o) => o - v);

  Iterable<double> takeAllMultiply(int v) => takeAllApply((o) => o * v);

  Iterable<double> takeAllDivide(int v) => takeAllApply((o) => o / v);

  Iterable<int> takeAllDivideToInt(int v) => map((o) => o ~/ v);

  ///
  ///
  /// intersection
  ///
  ///

  ///
  /// [interDistanceTo], [interDistanceFrom]
  /// [interDistanceHalfTo], [interDistanceHalfFrom]
  /// [interDistanceCumulate]
  ///
  Iterable<double> interDistanceTo(Iterator<double> destination) =>
      destination.interTake(this, FReducer.doubleSubtract);

  Iterable<double> interDistanceFrom(Iterator<double> source) =>
      interTake(source, FReducer.doubleSubtract);

  Iterable<double> interDistanceHalfTo(Iterator<double> destination) =>
      destination.interTake(this, FReducer.doubleSubtractThenHalf);

  Iterable<double> interDistanceHalfFrom(Iterator<double> source) =>
      interTake(source, FReducer.doubleSubtractThenHalf);

  double interDistanceCumulate(Iterator<double> another) =>
      interTakeCumulate(another, FReducer.doubleSubtract, FReducer.doubleAdd);
}

///
///
///
extension IterableMapEntry<K, V> on Iterable<MapEntry<K, V>> {
  ///
  /// [toMap], [keys], [values]
  ///
  Map<K, V> get toMap => Map.fromEntries(this);

  Iterable<K> get keys => map((e) => e.key);

  Iterable<V> get values => map((e) => e.value);
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
    return iterator.interTakeCumulate(
      another.iterator,
      FReducer.doubleMultiply,
      FReducer.doubleAdd,
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

  ///
  /// [normalized]
  /// [normalizeInto]
  ///
  Iterable<double> get normalized =>
      iterator.takeAllApplyBy(iterator.distance, FReducer.doubleDivide);

  void normalizeInto(List<double> out) {
    assert(out.length == length);
    iterator.accompanyByIndex(
      iterator.distance,
      (value, d, i) => out[i] = value / d,
    );
  }

  ///
  /// [statisticAnalyze]
  ///
  Iterable<double> statisticAnalyze({
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
    for (var value in this) {
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
    for (var value in this) {
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
          ? iterator.takeAllApply((x) => (x - mean) / sd * 10 + 50)
          : iterator.takeAllApply((x) => (x - mean) / sd);
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
/// static methods:
/// [sequence], ...
///
/// instance methods:
/// [sum], ...
///
extension IterableInt on Iterable<int> {
  static Iterable<int> sequence(int length, [int start = 1]) =>
      Iterable.generate(length, (i) => start + i);

  static Iterable<int> seq(int begin, int end) =>
      [for (var i = begin; i <= end; i++) i];

  int get sum => reduce(FReducer.intAdd);
}

///
/// [interquartileRange]
///
extension ListDouble on List<double> {
  ///
  /// [interquartileRange]
  ///
  double get interquartileRange {
    final interquartile = percentileQuartile;
    return interquartile.last - interquartile.first;
  }
}

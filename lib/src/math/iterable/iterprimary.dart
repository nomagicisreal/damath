///
///
/// this file contains:
///
/// [IteratorBoolExtension]
/// [IteratorDoubleExtension]
///
/// [IterableDoubleExtension]
/// [IterableIntExtension]
///
///
///
/// 'flutter pub add statistics' for advance statistic analyze
///
///
part of damath_math;

///
/// static methods:
/// [_keep], ...
///
/// instance getters, methods:
/// [isSatisfiable], ...
///
///
extension IteratorBoolExtension on Iterator<bool> {
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
///
/// [anyFinite], ...
/// [min], ...
///
/// [range], ...
///
/// [abs], ...
/// [interValuesTo], ...
///
///
///
extension IteratorDoubleExtension on Iterator<double> {
  ///
  /// [anyFinite], [anyInFinite]
  /// [anyZero], [anyPositive], [anyNegative]
  ///
  bool get anyFinite => any((value) => value.isFinite);

  bool get anyInFinite => any((value) => value.isInfinite);

  bool get anyZero => any((value) => value == 0);

  bool get anyPositive => any((value) => value > 0);

  bool get anyNegative => any((value) => value < 0);

  ///
  /// [min], [max], [meanArithmetic], [meanGeometric]
  /// [sum], [sumSquared]
  /// [distance], [volume]
  /// [distanceTo], [distanceHalfTo]
  ///
  double get min => reduce(FReducer.doubleMin);

  double get max => reduce(FReducer.doubleMax);

  double get meanArithmetic => moveNextThen(() {
        var total = current;
        var length = 1;
        while (moveNext()) {
          total += current;
          length++;
        }
        return total / length;
      });

  double get meanGeometric => moveNextThen(() {
        var total = current;
        var length = 1;
        while (moveNext()) {
          total *= current;
          length++;
        }
        return math.pow(total, 1 / length).toDouble();
      });

  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);

  double get distance => math.sqrt(reduce(FReducer.doubleAddSquared));

  double get volume => reduce(FReducer.doubleMultiply);

  double distanceTo(Iterator<double> other) => other.distance - distance;

  double distanceHalfTo(Iterator<double> other) =>
      (other.distance - distance) / 2;

  ///
  /// [range]
  ///
  (double, double) get range => moveNextThen(() {
        var min = current;
        var max = current;
        while (moveNext()) {
          if (current < min) min = current;
          if (current > max) max = current;
        }
        return (min, max);
      });

  ///
  /// [abs], [rounded], [roundUpTo]
  /// [operatePlus], [operateSubtract], [operateMultiply], [operateDivide], [operateDivideToInt]
  ///
  Iterable<double> get abs => yieldingApply((v) => v.abs());

  Iterable<double> get rounded => yieldingApply((v) => v.roundToDouble());

  Iterable<double> roundUpTo(int d) => yieldingApply((v) => v.roundUpTo(d));

  Iterable<double> operatePlus(int v) => yieldingApply((o) => o + v);

  Iterable<double> operateSubtract(int v) => yieldingApply((o) => o - v);

  Iterable<double> operateMultiply(int v) => yieldingApply((o) => o * v);

  Iterable<double> operateDivide(int v) => yieldingApply((o) => o / v);

  Iterable<double> operateDivideToInt(int v) =>
      yieldingApply((o) => (o ~/ v).toDouble());

  ///
  ///
  /// intersection
  ///
  ///

  ///
  /// [interValuesTo], [interValuesFrom]
  /// [interValuesHalfTo], [interValuesHalfFrom]
  ///
  Iterable<double> interValuesTo(Iterator<double> destination) =>
      destination.interYieldingApply(this, FReducer.doubleSubtract);

  Iterable<double> interValuesFrom(Iterator<double> source) =>
      interYieldingApply(source, FReducer.doubleSubtract);

  Iterable<double> interValuesHalfTo(Iterator<double> destination) =>
      destination.interYieldingApply(this, FReducer.doubleSubtractThenHalf);

  Iterable<double> interValuesHalfFrom(Iterator<double> source) =>
      interYieldingApply(source, FReducer.doubleSubtractThenHalf);
}

///
///
///
///
/// iterable
///
///
///
///
///

///
///
///
extension IterableDoubleExtension on Iterable<double> {
  ///
  /// [valuesTo], [valuesFrom]
  ///
  Iterable<double> valuesTo(Iterable<double> destination) {
    assert(destination.length == length);
    return destination.iterator.interValuesTo(destination.iterator);
  }

  Iterable<double> valuesFrom(Iterable<double> source) {
    assert(source.length == length);
    return iterator.interValuesFrom(source.iterator);
  }

  ///
  /// [standardUnit]
  ///
  Iterable<double> get standardUnit {
    final distance = iterator.distance;
    return iterator.yieldingApply((value) => value / distance);
  }

  ///
  /// [analyzing]
  ///
  /// see also [IteratorDoubleExtension.meanArithmetic]
  ///
  Iterable<double> analyzing([
    bool requireLength = true,
    bool requireMean = true,
    bool requireStandardDeviation = true,
    bool? requireTScores, // t scores or z scores
  ]) sync* {
    /// length, µ
    var length = 0.0;
    var total = 0.0;
    for (var value in this) {
      total += value;
      length++;
    }
    final mean = total / length;
    if (requireLength) yield length;
    if (requireMean) yield mean;

    ///
    /// standard deviation
    ///
    var sum = 0.0;
    for (var value in this) {
      sum += (value - mean).squared;
    }
    final sd = sum / length;
    if (requireStandardDeviation) {
      yield sd;
    }

    ///
    /// scores
    ///
    if (requireTScores != null) {
      yield* requireTScores
          ? iterator.yieldingApply((x) => (x - mean) / sd * 10 + 50)
          : iterator.yieldingApply((x) => (x - mean) / sd);
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
extension IterableIntExtension on Iterable<int> {
  static Iterable<int> sequence(int length, [int start = 1]) =>
      Iterable.generate(length, (i) => start + i);

  static Iterable<int> seq(int begin, int end) sync* {
    for (var i = begin; i <= end; i++) {
      yield i;
    }
  }

  int get sum => reduce(FReducer.intAdd);
}

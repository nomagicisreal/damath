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
/// [distance], ...
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
  /// [min], [max], [mean]
  /// [sum], [sumSquared]
  ///
  double get min => reduce(FReducer.doubleMin);

  double get max => reduce(FReducer.doubleMax);

  double get mean {
    var total = 0.0;
    var length = 0;
    while (moveNext()) {
      total += current;
      length++;
    }
    return total / length;
  }

  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);

  ///
  /// [distance], [volume]
  /// [distanceTo], [distanceHalfTo]
  ///
  double get distance => math.sqrt(reduce(FReducer.doubleAddSquared));

  double get volume => reduce(FReducer.doubleMultiply);

  double distanceTo(Iterator<double> other) => other.distance - distance;

  double distanceHalfTo(Iterator<double> other) =>
      (other.distance - distance) / 2;

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
  /// see also [IteratorDoubleExtension.mean]
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
    final standardDeviation = sum / length;
    if (requireStandardDeviation) {
      yield standardDeviation;
    }

    ///
    /// scores
    ///
    // requireTScores.expandTo((value) {
    //
    // });
    if (requireTScores != null) {
      if (requireTScores) {
        for (var value in this) {
          yield ((value - mean) / standardDeviation) * 10 + 50; // t scores
        }
      } else {
        for (var value in this) {
          yield (value - mean) / standardDeviation; // z scores
        }
      }
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

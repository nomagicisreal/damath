part of '../core.dart';

///
///
/// statics:
/// [sqrt2], ...
/// [proximateInfinityOf], ...
/// [predicateFinite], ...
/// [lerp], ...
///
/// instances:
/// [filterInfinity], ...
/// [isNearlyInt], ...
///
///
extension DoubleExtension on double {
  static const double sqrt2 = math.sqrt2;
  static const double sqrt3 = 1.7320508075688772;
  static const double sqrt5 = 2.23606797749979;
  static const double sqrt6 = 2.44948974278317;
  static const double sqrt7 = 2.6457513110645907;
  static const double sqrt8 = 2.8284271247461903;
  static const double sqrt10 = 3.1622776601683795;
  static const double sqrt1_2 = math.sqrt1_2;
  static const double sqrt1_3 = 0.5773502691896257;
  static const double sqrt1_5 = 0.4472135954999579;
  static const double sqrt1_6 = 0.408248290463863;
  static const double sqrt1_7 = 0.3779644730092272;
  static const double sqrt1_8 = 0.3535533905932738;
  static const double sqrt1_10 = 0.31622776601683794;

  ///
  ///
  /// static methods
  ///
  ///

  ///
  /// [proximateInfinityOf], [proximateNegativeInfinityOf]
  ///
  static double proximateInfinityOf(double precision) =>
      1.0 / math.pow(0.1, precision);

  static double proximateNegativeInfinityOf(double precision) =>
      -1.0 / math.pow(0.1, precision);

  ///
  ///
  /// [predicateFinite], [predicateInfinite]
  /// [predicateInt], [predicateNearlyInt]
  /// [predicateZero], [predicatePositive], [predicateNegative], [predicateNaN]
  ///
  static bool predicateFinite(double value) => value.isFinite;

  static bool predicateInfinite(double value) => value.isInfinite;

  static bool predicateInt(double value) => value.isInteger;

  static bool predicateNearlyInt(double value) => value.isNearlyInt;

  static bool predicateZero(double value) => value == 0;

  static bool predicatePositive(double value) => value > 0;

  static bool predicateNegative(double value) => value < 0;

  static bool predicateNaN(double value) => value.isNaN;

  ///
  ///
  ///
  /// applier
  /// [applyKeep], [applyZero]
  /// [applyOnPlus], [applyOnMinus], [applyOnMultiply], [applyOnDivided], [applyOnMod]
  /// [applyOnTimesFactor]
  /// [applyOnPeriod], [applyOnPeriodSinByTimes], [applyOnPeriodCosByTimes], [applyOnPeriodTanByTimes]
  ///
  ///

  ///
  /// [applyKeep], [applyZero], [applyNegate], [applyRound]
  /// [applyOnPlus], [applyOnMinus], [applyOnMultiply], [applyOnDivided]
  ///
  static double applyKeep(double v) => v;

  static double applyZero(double value) => 0;

  static double applyNegate(double v) => -v;

  static double applyRound(double v) => v.roundToDouble();

  static Applier<double> applyOnPlus(double value) => (v) => v + value;

  static Applier<double> applyOnMinus(double value) => (v) => v - value;

  static Applier<double> applyOnMultiply(double value) => (v) => v * value;

  static Applier<double> applyOnDivided(double value) => (v) => v / value;

  static Applier<double> applyOnMod(double value) => (v) => v % value;

  static Applier<double> applyOnDividedToInt(double value) =>
      (v) => (v ~/ value).toDouble();

  ///
  /// [applyOnTimesFactor]
  /// [applyOnPeriod]
  ///   [applyOnPeriodSinByTimes]
  ///   [applyOnPeriodCosByTimes]
  ///   [applyOnPeriodTanByTimes]
  ///
  static Applier<double> applyOnTimesFactor(
    double times,
    double factor, [
    Applier<double> transform = math.sin,
  ]) {
    assert(times.isFinite && factor.isFinite);
    return (value) => transform(times * value) * factor;
  }

  // sin period: (0 ~ 1 ~ 0 ~ -1 ~ 0)
  // cos period: (1 ~ 0 ~ -1 ~ 0 ~ 1)
  static Applier<double> applyOnPeriod(
    double period, [
    Applier<double> transform = math.sin,
  ]) {
    if (transform != math.sin && transform != math.cos) {
      throw UnimplementedError('$transform');
    }
    final times = math.pi * 2 * period;
    return (value) => transform(times * value);
  }

  static Applier<double> applyOnPeriodSinByTimes(int times) =>
      applyOnPeriod(times.toDouble(), math.sin);

  static Applier<double> applyOnPeriodCosByTimes(int times) =>
      applyOnPeriod(times.toDouble(), math.cos);

  static Applier<double> applyOnPeriodTanByTimes(int times) =>
      applyOnPeriod(times.toDouble(), math.tan);

  ///
  /// reduce
  /// [reducePlus], [reduceMinus], [reduceMultiply], [reduceDivided], [reduceMod]
  /// [reducePlusSquared], [reduceMinusThenHalf]
  ///
  static double reduceMax(double v1, double v2) => math.max(v1, v2);

  static double reduceMin(double v1, double v2) => math.min(v1, v2);

  static double reducePlus(double v1, double v2) => v1 + v2;

  static double reduceMinus(double v1, double v2) => v1 - v2;

  static double reduceMultiply(double v1, double v2) => v1 * v2;

  static double reduceDivided(double v1, double v2) => v1 / v2;

  static double reduceMod(double v1, double v2) => v1 % v2;

  static double reduceDivideToInt(double v1, double v2) =>
      (v1 ~/ v2).toDouble();

  // chained operation
  static double reducePlusSquared(double v1, double v2) => v1 * v1 + v2 * v2;

  static double reduceMinusThenHalf(double v1, double v2) => (v1 - v2) / 2;

  ///
  ///
  static Lerper<double> lerp(double begin, double end) =>
      (t) => begin * (1.0 - t) + end * t;

  ///
  /// [filterInfinity]
  /// [roundUpTo]
  /// [clampDouble]
  ///
  double filterInfinity(double precision) => switch (this) {
    double.infinity => proximateInfinityOf(precision),
    double.negativeInfinity => proximateNegativeInfinityOf(precision),
    _ => this,
  };

  double roundUpTo(int digit) {
    final value = math.pow(10, digit);
    return (this * value).roundToDouble() / value;
  }

  double clampDouble(double lowerLimit, double upperLimit) {
    if (this < lowerLimit) return lowerLimit;
    if (this > upperLimit) return upperLimit;
    if (isNaN) return upperLimit;
    return this;
  }

  ///
  /// [isInteger], [isNearlyInt]
  /// [squared], [squareRoot]
  /// [clampPositive], [clampNegative], [clamp01]
  ///
  bool get isInteger {
    final value = roundToDouble();
    return value == ceil() && value == floor();
  }

  bool get isNearlyInt => (ceil() - this) <= 0.01;

  double get squared => this * this;

  double get squareRoot => math.sqrt(this);
}

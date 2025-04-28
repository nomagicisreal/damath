part of '../primary.dart';

///
/// constants:
///
/// statics usages:
/// [sqrt2], ...
/// [radian_angle1], ..., [radian_fromAngle], ...
/// [proximateInfinityOf], ...
/// [predicateFinite], ...
/// [lerp], ...
///
/// instance usages:
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
  ///
  static const double radian_angle1 = math.pi / 180;
  static const double radian_angle5 = math.pi / 36;
  static const double radian_angle10 = math.pi / 18;
  static const double radian_angle15 = math.pi / 12;
  static const double radian_angle20 = math.pi / 9;
  static const double radian_angle30 = math.pi / 6;
  static const double radian_angle40 = math.pi * 2 / 9;
  static const double radian_angle45 = math.pi / 4;
  static const double radian_angle50 = math.pi * 5 / 18;
  static const double radian_angle60 = math.pi / 3;
  static const double radian_angle70 = math.pi * 7 / 18;
  static const double radian_angle75 = math.pi * 5 / 12;
  static const double radian_angle80 = math.pi * 4 / 9;
  static const double radian_angle85 = math.pi * 17 / 36;
  static const double radian_angle90 = math.pi / 2;
  static const double radian_angle120 = math.pi * 2 / 3;
  static const double radian_angle135 = math.pi * 3 / 4;
  static const double radian_angle150 = math.pi * 5 / 6;
  static const double radian_angle180 = math.pi;
  static const double radian_angle225 = math.pi * 5 / 4;
  static const double radian_angle240 = math.pi * 4 / 3;
  static const double radian_angle270 = math.pi * 3 / 2;
  static const double radian_angle315 = math.pi * 7 / 4;
  static const double radian_angle360 = math.pi * 2;
  static const double radian_angle390 = math.pi * 13 / 6;
  static const double radian_angle420 = math.pi * 7 / 3;
  static const double radian_angle450 = math.pi * 5 / 2;

  static double radian_fromAngle(double angle) =>
      angle * DoubleExtension.radian_angle1;

  static double radian_complementary(double radian) {
    assert(radian.isRangeClose(0, radian_angle90));
    return (90 - radian / radian_angle1) * radian_angle1;
  }

  static double radian_supplementary(double radian) {
    assert(radian.isRangeClose(0, radian_angle180));
    return (180 - radian / radian_angle1) * radian_angle1;
  }

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
  /// [applyOnPeriod]
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

///
///
/// this file contains:
/// [FListener]
/// [FPredicator], [FPredicatorCombiner]
/// [FMapper]
/// [FGenerator], [FGeneratorOffset]
/// [FTranslator]
/// [FReducer]
/// [FCompanion]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of damath_math;
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

///
///
/// listener
///
///
extension FListener on Listener {
  static void none() {}

  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

///
///
/// predicator
///
///
extension FPredicator on Predicator {
  static Predicator<DateTime> isSameDayWith(DateTime? day) =>
      (currentDay) => DateTimeExtension.isSameDay(currentDay, day);
}

extension FPredicatorCombiner on PredicateCombiner<num> {
  // bool
  static bool boolEqual(bool a, bool b) => a == b;

  static bool boolUnequal(bool a, bool b) => a != b;

  // num
  static bool numEqual(num a, num b) => a == b;

  static bool numIsALess(num a, num b) => a < b;

  static bool numIsALarger(num a, num b) => a > b;

  // int
  static bool intEqual(int a, int b) => a == b;

  static bool intIsALess(int a, int b) => a < b;

  static bool intIsALarger(int a, int b) => a > b;

  // double
  static bool doubleEqual(double a, double b) => a == b;

  static bool doubleIsALess(double a, double b) => a < b;

  static bool doubleIsALarger(double a, double b) => a > b;

  // entry key
  static bool entryIsNumKeyLess<T>(MapEntry<num, T> a, MapEntry<num, T> b) =>
      a.key < b.key;

  static bool entryIsNumKeyLarger<T>(MapEntry<num, T> a, MapEntry<num, T> b) =>
      a.key > b.key;

  // always
  static bool alwaysTrue<T>(T a, T b) => true;

  static bool alwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysTrue<T>(T a, T b) => true;

  static bool? ternaryAlwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysNull<T>(T a, T b) => null;

  // ternary equal, less, larger
  static bool? ternaryIntEqualOrLessOrLarger(int a, int b) => switch (a - b) {
        0 => true,
        < 0 => false,
        _ => null,
      };
}

///
///
///
///
///
/// mapper
///
///
///
///
///

extension FMapper on Mapper {
  static T keep<T>(T value) => value;

  static Space3 keepSpace3(Space3 v) => v;

  static double keepDouble(double value) => value;

  ///
  /// [doubleOf], [doubleZero]
  /// [doubleOnPlus], [doubleOnMinus], [doubleOnMultiply], [doubleOnDivide]
  ///
  static double doubleOf(double v) => v;

  static double doubleZero(double value) => 0;

  static Mapper<double> doubleOnPlus(double value) => (v) => v + value;

  static Mapper<double> doubleOnMinus(double value) => (v) => v - value;

  static Mapper<double> doubleOnMultiply(double value) => (v) => v * value;

  static Mapper<double> doubleOnDivide(double value) => (v) => v / value;

  static Mapper<double> doubleOnOperate(Operator operator, double value) =>
      operator.doubleCompanion(value);

  ///
  /// [doubleOnTimesFactor]
  /// [doubleOnPeriod]
  ///   [doubleOnPeriodSinByTimes]
  ///   [doubleOnPeriodCosByTimes]
  ///   [doubleOnPeriodTanByTimes]
  ///
  static Mapper<double> doubleOnTimesFactor(
    double times,
    double factor, [
    Mapper<double> transform = math.sin,
  ]) {
    assert(times.isFinite && factor.isFinite);
    return (value) => transform(times * value) * factor;
  }

  // sin period: (0 ~ 1 ~ 0 ~ -1 ~ 0)
  // cos period: (1 ~ 0 ~ -1 ~ 0 ~ 1)
  static Mapper<double> doubleOnPeriod(
    double period, [
    Mapper<double> transform = math.sin,
  ]) {
    assert(transform == math.sin || transform == math.cos);
    final times = Radian.angle_360 * period;
    return lerp<double>(0, 1, (value) => transform(times * value));
  }

  static Mapper<double> doubleOnPeriodSinByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.sin);

  static Mapper<double> doubleOnPeriodCosByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.cos);

  static Mapper<double> doubleOnPeriodTanByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.tan);

  ///
  /// lerpOf
  ///
  static OnLerp<T> lerp<T>(T begin, T end, OnLerp<T> transform) =>
      (value) {
        if (value == 0) return begin;
        if (value == 1) return end;
        return transform(value);
      };
}

///
///
///
///
///
///
///
/// generator
///
///
///
///
///
///
///
extension FGenerator on Generator {
  static Generator<T> fill<T>(T value) => (i) => value;

  static double toDouble(int index) => index.toDouble();

  static Generator2D<T> fill2D<T>(T value) => (i, j) => value;
}

///
///
///
///
///
///
///
///
/// translator
///
///
///
///
///
///
///
///
extension FTranslator on Translator {
  static Translator<int, bool> oddOrEvenCheckerAs(int value) =>
      value.isOdd ? (v) => v.isOdd : (v) => v.isEven;

  static Translator<int, bool> oddOrEvenCheckerOpposite(int value) =>
      value.isOdd ? (v) => v.isEven : (v) => v.isOdd;
}

///
/// [doubleMax], [doubleMin]
/// [intMax], [intMin]
/// [doubleAdd], ...
/// [intAdd], ...
///
extension FReducer<N> on Reducer<N> {
  static const Reducer<double> doubleMax = math.max<double>;
  static const Reducer<double> doubleMin = math.min<double>;
  static const Reducer<int> intMax = math.max<int>;
  static const Reducer<int> intMin = math.min<int>;

  static double doubleAdd(double v1, double v2) => v1 + v2;

  static double doubleSubtract(double v1, double v2) => v1 - v2;

  static double doubleMultiply(double v1, double v2) => v1 * v2;

  static double doubleDivide(double v1, double v2) => v1 / v2;

  static double doubleAddSquared(double v1, double v2) => v1 * v1 + v2 * v2;

  static int intAdd(int v1, int v2) => v1 + v2;

  static int intSubtract(int v1, int v2) => v1 - v2;

  static int intMultiply(int v1, int v2) => v1 * v2;

  static int intDivide(int v1, int v2) => v1 ~/ v2;

  static int intAddSquared(int v1, int v2) => v1 * v1 + v2 * v2;
}

extension FCompanion on Companion {
  static T keep<T, S>(T origin, S another) => origin;
}

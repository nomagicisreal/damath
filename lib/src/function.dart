///
///
/// this file contains:
/// [FListener]
/// [FPredicator], [FPredicatorCombiner]
/// [FMapper], [FMapperDouble], [FMapperCubic], [FMapperMapCubicOffset]
/// [FGenerator], [FGeneratorOffset]
/// [FTranslator]
/// [FReducerNum]
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
part of damath;
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

  static Translator<double, T> lerpOf<T>(
      T begin,
      T end,
      Translator<double, T> transform,
      ) =>
          (value) {
        if (value == 0) return begin;
        if (value == 1) return end;
        return transform(value);
      };
}

extension FMapperDouble on Mapper<double> {
  static double of(double v) => v;

  static double zero(double value) => 0;

  static double keep(double value) => value;

  ///
  /// operate
  ///
  static Mapper<double> plus(double value) => (v) => v + value;

  static Mapper<double> minus(double value) => (v) => v - value;

  static Mapper<double> multiply(double value) => (v) => v * value;

  static Mapper<double> divide(double value) => (v) => v / value;

  static Mapper<double> operate(Operator operator, double value) =>
      operator.doubleCompanion(value);

  ///
  /// [fromTimesFactor], [fromPeriod]
  ///
  static Mapper<double> fromTimesFactor(
      double times,
      double factor, [
        Mapper<double> transform = math.sin,
      ]) {
    assert(times.isFinite && factor.isFinite);
    return (value) => transform(times * value) * factor;
  }

  // sin period: (0 ~ 1 ~ 0 ~ -1 ~ 0)
  // cos period: (1 ~ 0 ~ -1 ~ 0 ~ 1)
  static Mapper<double> fromPeriod(
      double period, [
        Mapper<double> transform = math.sin,
      ]) {
    assert(transform == math.sin || transform == math.cos);
    final times = Radian.angle_360 * period;
    return FMapper.lerpOf(0, 1, (value) => transform(times * value));
  }
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
/// [doubleAdding]
///
/// [intMax], [intMin]
/// [intAdding]
///
extension FReducerNum<N extends num> on Reducer<N> {
  static const Reducer<double> doubleMax = math.max<double>;
  static const Reducer<double> doubleMin = math.min<double>;
  static const Reducer<int> intMax = math.max<int>;
  static const Reducer<int> intMin = math.min<int>;

  static double doubleAdding(double v1, double v2) => v1 + v2;
  static int intAdding(int v1, int v2) => v1 + v2;
}

extension FCompanion on Companion {
  static T keep<T, S>(T origin, S another) => origin;
}

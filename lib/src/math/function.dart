///
///
/// this file contains:
/// [FListener]
/// [FPredicator], [FPredicatorCombiner], [FPredicatorFusionor]
/// [FMapper]
/// [FGenerator]
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

  static Predicator<T> isSameWith<T>(T another) => (value) => value == another;
}

extension FPredicatorCombiner on PredicatorCombiner {
  ///
  /// [isEqual], [isNotEqual]
  /// [alwaysTrue], [alwaysFalse]
  /// [ternaryAlwaysTrue], [ternaryAlwaysFalse], [ternaryAlwaysNull]
  ///
  static bool isEqual<T>(T valueA, T valueB) => valueA == valueB;

  static bool isNotEqual<T>(T valueA, T valueB) => valueA != valueB;

  static bool alwaysTrue<T>(T a, T b) => true;

  static bool alwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysTrue<T>(T a, T b) => true;

  static bool? ternaryAlwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysNull<T>(T a, T b) => null;

  ///
  /// see [Propositioner] for predicating from [bool]
  /// [numIsALess], [numIsALarger]
  /// [intIsALess], [intIsALarger]
  /// [doubleIsALess], [doubleIsALarger]
  ///
  static bool numIsALess(num a, num b) => a < b;

  static bool numIsALarger(num a, num b) => a > b;

  static bool intIsALess(int a, int b) => a < b;

  static bool intIsALarger(int a, int b) => a > b;

  static bool doubleIsALess(double a, double b) => a < b;

  static bool doubleIsALarger(double a, double b) => a > b;

  ///
  /// [entryIsKeyEqual], [entryIsKeyNotEqual]
  /// [entryIsKeyNumEqual], [entryIsKeyNumLess], [entryIsKeyNumLarger]
  ///
  static bool entryIsKeyEqual<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key == b.key;

  static bool entryIsKeyNotEqual<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key != b.key;

  static bool entryIsKeyNumEqual<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key == b.key;

  static bool entryIsKeyNumLess<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key < b.key;

  static bool entryIsKeyNumLarger<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key > b.key;
}

///
///
///
extension FPredicatorFusionor on PredicatorFusionor {

  ///
  /// [mapValueSetUpdateYet]
  /// [mapValueSetUpdateNew]
  /// [mapValueSetUpdateExist]
  /// [mapValueSetUpdateKeep]
  ///
  // return true if not yet contained
  static bool mapValueSetUpdateYet<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.updateSet(k, v, false);

  // return true if not yet contained or absent
  static bool mapValueSetUpdateNew<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.updateSet(k, v, true);

  // return true if exist
  static bool mapValueSetUpdateExist<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.updateSet(k, v, true);

  // return true if exist or absent
  static bool mapValueSetUpdateKeep<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.updateSet(k, v, false);

  ///
  /// [mapValueBoolUpdateYet]
  /// [mapValueBoolUpdateNew]
  /// [mapValueBoolUpdateExist]
  /// [mapValueBoolUpdateKeep]
  ///
  // return true if not yet contained
  static bool mapValueBoolUpdateYet<K>(Map<K, bool> map, K key, bool value) =>
      map.updateBool(key, value, false);

  // return true if not yet contained or absent
  static bool mapValueBoolUpdateNew<K>(Map<K, bool> map, K key, bool value) =>
      map.updateBool(key, value, true);

  // return true if exist
  static bool mapValueBoolUpdateExist<K>(Map<K, bool> map, K key, bool value) =>
      !map.updateBool(key, value, true);

  // return true if exist or absent
  static bool mapValueBoolUpdateKeep<K>(Map<K, bool> map, K key, bool value) =>
      !map.updateBool(key, value, false);
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

  ///
  /// [boolKeep], [boolReverse]
  ///
  static bool boolKeep(bool value) => value;

  static bool boolReverse(bool value) => !value;

  ///
  /// double
  /// [doubleKeep], [doubleZero]
  /// [doubleOnPlus], [doubleOnMinus], [doubleOnMultiply], [doubleOnDivide]
  /// [doubleOnTimesFactor]
  /// [doubleOnPeriod], [doubleOnPeriodSinByTimes], [doubleOnPeriodCosByTimes], [doubleOnPeriodTanByTimes]
  ///
  ///

  ///
  /// [doubleKeep], [doubleZero]
  /// [doubleOnPlus], [doubleOnMinus], [doubleOnMultiply], [doubleOnDivide]
  ///
  static double doubleKeep(double v) => v;

  static double doubleZero(double value) => 0;

  static Mapper<double> doubleOnPlus(double value) => (v) => v + value;

  static Mapper<double> doubleOnMinus(double value) => (v) => v - value;

  static Mapper<double> doubleOnMultiply(double value) => (v) => v * value;

  static Mapper<double> doubleOnDivide(double value) => (v) => v / value;

  static Mapper<double> doubleOnDivideToInt(double value) =>
      (v) => (v ~/ value).toDouble();

  static Mapper<double> doubleOnModule(double value) => (v) => v % value;

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
  /// space
  /// [space3Keep]
  ///
  static Space3 space3Keep(Space3 v) => v;

  ///
  /// lerpOf
  ///
  static OnLerp<T> lerp<T>(T begin, T end, OnLerp<T> transform) => (value) {
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
/// [stringLine]
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

  static double doubleDivideToInt(double v1, double v2) =>
      (v1 ~/ v2).toDouble();

  static double doubleModule(double v1, double v2) => v1 % v2;

  static double doubleAddSquared(double v1, double v2) => v1 * v1 + v2 * v2;

  static int intAdd(int v1, int v2) => v1 + v2;

  static int intSubtract(int v1, int v2) => v1 - v2;

  static int intMultiply(int v1, int v2) => v1 * v2;

  static int intDivide(int v1, int v2) => v1 ~/ v2;

  static int intAddSquared(int v1, int v2) => v1 * v1 + v2 * v2;

  static String stringLine(String v1, String v2) => '$v1\n$v2';

  static String stringTab(String v1, String v2) => '$v1\t$v2';

  static String stringComma(String v1, String v2) => '$v1, $v2';
}

extension FCompanion on Companion {
  static T keep<T, S>(T origin, S another) => origin;
}

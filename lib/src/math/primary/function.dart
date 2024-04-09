///
///
/// this file contains:
///
/// [FPredicator], [FPredicatorCombiner], [FPredicatorFusionor]
/// [FApplier]
/// [FGenerator]
/// [FTranslator]
/// [FReducer]
/// [FCompanion]
/// [FLerper]
///
///
///
part of damath_math;

///
///
/// predicator
///
///
extension FPredicator on Predicator {
  ///
  /// [alwaysTrue]
  /// [alwaysFalse]
  ///
  static bool alwaysTrue<T>(T value) => true;

  static bool alwaysFalse<T>(T value) => false;
  //
  // ///
  // /// [compareIncrease]
  // /// [compareDecrease]
  // ///
  // static bool compareIncrease(int value) => value == -1;
  //
  // static bool compareDecrease(int value) => value == 1;

  ///
  /// [sameWith]
  /// [sameDayWith]
  ///
  static Predicator<T> sameWith<T>(T another) => (value) => value == another;

  static Predicator<DateTime> sameDayWith(DateTime? day) =>
      (currentDay) => DateTimeExtension.isSameDay(currentDay, day);
}

///
/// [isEqual], ...
/// [numIsALess], ...
/// [entryIsKeyEqual], ...
/// [iterableIsLengthEqual], ...
///
/// see [Propositioner] for predication combined from [bool]
///
extension FPredicatorCombiner on PredicatorCombiner {
  ///
  /// [isEqual], [isDifferent]
  /// [alwaysTrue], [alwaysFalse]
  /// [ternaryAlwaysTrue], [ternaryAlwaysFalse], [ternaryAlwaysNull]
  ///
  static bool isEqual<T>(T valueA, T valueB) => valueA == valueB;

  static bool isDifferent<T>(T valueA, T valueB) => valueA != valueB;

  static bool alwaysTrue<T>(T a, T b) => true;

  static bool alwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysTrue<T>(T a, T b) => true;

  static bool? ternaryAlwaysFalse<T>(T a, T b) => false;

  static bool? ternaryAlwaysNull<T>(T a, T b) => null;

  ///
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
  /// [entryIsKeyEqual], [entryIsKeyDifferent]
  /// [entryIsKeyNumEqual], [entryIsKeyNumDifferent], [entryIsKeyNumLess], [entryIsKeyNumLarger]
  ///
  static bool entryIsKeyEqual<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key == b.key;

  static bool entryIsKeyDifferent<K, V>(MapEntry<K, V> a, MapEntry<K, V> b) =>
      a.key != b.key;

  static bool entryIsKeyNumEqual<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key == b.key;

  static bool entryIsKeyNumDifferent<V>(
    MapEntry<num, V> a,
    MapEntry<num, V> b,
  ) =>
      a.key != b.key;

  static bool entryIsKeyNumLess<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key < b.key;

  static bool entryIsKeyNumLarger<V>(MapEntry<num, V> a, MapEntry<num, V> b) =>
      a.key > b.key;

  ///
  /// [iterableIsLengthEqual], [iterableIsLengthDifferent]
  /// [iterableIsEqual], [iterableIsDifferent]
  ///
  static bool iterableIsLengthEqual<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length == b.length;

  static bool iterableIsLengthDifferent<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length != b.length;

  static bool iterableIsEqual<I>(Iterable<I> a, Iterable<I> b) =>
      a.isEqualTo(b);

  static bool iterableIsDifferent<I>(Iterable<I> a, Iterable<I> b) =>
      a.anyElementIsDifferentWith(b);
}

///
///
///
extension FPredicatorFusionor on PredicatorFusionor {
  ///
  /// [mapValueInputYet]
  /// [mapValueInputNew]
  /// [mapValueInputExist]
  /// [mapValueInputKeep]
  ///
  // return true if not yet contained
  static bool mapValueInputYet<K, V>(Map<K, V> map, K key, V value) =>
      map.input(key, value, false);

  // return true if not yet contained or absent
  static bool mapValueInputNew<K>(Map<K, bool> map, K key, bool value) =>
      map.input(key, value, true);

  // return true if exist
  static bool mapValueInputExist<K>(Map<K, bool> map, K key, bool value) =>
      !map.input(key, value, true);

  // return true if exist or absent
  static bool mapValueInputKeep<K>(Map<K, bool> map, K key, bool value) =>
      !map.input(key, value, false);

  ///
  /// [mapValueSetInputYet]
  /// [mapValueSetInputNew]
  /// [mapValueSetInputExist]
  /// [mapValueSetInputKeep]
  ///
  // return true if not yet contained
  static bool mapValueSetInputYet<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.inputSet(k, v, false);

  // return true if not yet contained or absent
  static bool mapValueSetInputNew<K, V>(Map<K, Set<V>> map, K k, V v) =>
      map.inputSet(k, v, true);

  // return true if exist
  static bool mapValueSetInputExist<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.inputSet(k, v, true);

  // return true if exist or absent
  static bool mapValueSetInputKeep<K, V>(Map<K, Set<V>> map, K k, V v) =>
      !map.inputSet(k, v, false);
}

extension FComparator<C> on Comparator<C> {
  ///
  /// entry key
  ///
  static int entryKeyInt<V>(MapEntry<int, V> a, MapEntry<int, V> b) =>
      a.key.compareTo(b.key);

  ///
  /// entry value
  ///
  static int entryValueDuration<K>(
          MapEntry<K, Duration> a, MapEntry<K, Duration> b) =>
      a.value.compareTo(b.value);
}

///
/// [keep]
/// [doubleKeep], ...
///
/// [iterableAppend], ...
/// [listAdd], ...
///
extension FApplier on Applier {
  static T keep<T>(T value) => value;

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

  static Applier<double> doubleOnPlus(double value) => (v) => v + value;

  static Applier<double> doubleOnMinus(double value) => (v) => v - value;

  static Applier<double> doubleOnMultiply(double value) => (v) => v * value;

  static Applier<double> doubleOnDivide(double value) => (v) => v / value;

  static Applier<double> doubleOnModule(double value) => (v) => v % value;

  static Applier<double> doubleOnDivideToInt(double value) =>
      (v) => (v ~/ value).toDouble();

  ///
  /// [doubleOnTimesFactor]
  /// [doubleOnPeriod]
  ///   [doubleOnPeriodSinByTimes]
  ///   [doubleOnPeriodCosByTimes]
  ///   [doubleOnPeriodTanByTimes]
  ///
  static Applier<double> doubleOnTimesFactor(
    double times,
    double factor, [
    Applier<double> transform = math.sin,
  ]) {
    assert(times.isFinite && factor.isFinite);
    return (value) => transform(times * value) * factor;
  }

  // sin period: (0 ~ 1 ~ 0 ~ -1 ~ 0)
  // cos period: (1 ~ 0 ~ -1 ~ 0 ~ 1)
  static Applier<double> doubleOnPeriod(
    double period, [
    Applier<double> transform = math.sin,
  ]) {
    assert(transform == math.sin || transform == math.cos);
    final times = math.pi * 2 * period;
    return FLerper.clamp((value) => transform(times * value), 0.0, 1.0);
  }

  static Applier<double> doubleOnPeriodSinByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.sin);

  static Applier<double> doubleOnPeriodCosByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.cos);

  static Applier<double> doubleOnPeriodTanByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.tan);

  ///
  /// iterable
  /// [iterableAppend]
  ///
  static Applier<Iterable<I>> iterableAppend<I>(I value) =>
      (iterable) => iterable.append(value);

  ///
  /// list
  /// [listAdd]
  ///
  static Applier<List<T>> listAdd<T>(T value) => (list) => list..add(value);
}

///
///
/// generator
///
/// static methods:
/// [filled], ...
/// [ofDouble], ...
///
/// instance methods:
/// [generate], ...
///
/// [foldTill], ...
/// [reduceTill], ...
///
/// [linkTill], ...
///
///
extension FGenerator<T> on Generator<T> {
  static Generator<T> filled<T>(T value) => (i) => value;

  static Generator2D<T> filled2D<T>(T value) => (i, j) => value;

  static double ofDouble(int index) => index.toDouble();

  ///
  /// [generate]
  /// [generateToList]
  ///
  Iterable<T> generate(int length, [int start = 0]) sync* {
    for (var i = start; i < length; i++) {
      yield this(i);
    }
  }

  List<T> generateToList(int length, [int start = 0]) =>
      [for (var i = start; i < length; i++) this(i)];

  ///
  /// [yielding]
  /// [yieldingToList]
  ///
  Iterable<E> yielding<E>(
    int length,
    Mapper<T, E> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; i < length; i++) {
      yield toVal(this(i));
    }
  }

  List<E> yieldingToList<E>(
    int length,
    Mapper<T, E> toVal, [
    int start = 0,
  ]) =>
      [for (var i = start; i < length; i++) toVal(this(i))];

  ///
  /// fold, reduce
  /// [foldTill]
  /// [foldCollectTill]
  ///
  ///
  /// [reduceTill]
  ///
  ///
  ///

  ///
  /// [foldTill]
  ///
  S foldTill<S>(int length, S initialValue, Companion<S, T> companion) {
    var val = initialValue;
    for (var i = 0; i < length; i++) {
      val = companion(val, this(i));
    }
    return val;
  }

  S foldCollectTill<E, S>(
    int length,
    Generator<E> another,
    S initialValue,
    Collector<S, T, E> collect,
  ) {
    var val = initialValue;
    for (var i = 0; i < length; i++) {
      val = collect(val, this(i), another(i));
    }
    return val;
  }

  ///
  /// [reduceTill]
  ///
  T reduceTill(int length, Reducer<T> reducing) {
    var val = this(0);
    for (var i = 1; i < length; i++) {
      val = reducing(val, this(i));
    }
    return val;
  }

  ///
  /// [linkTill]
  /// [linkToListTill]
  ///
  Iterable<S> linkTill<E, S>(
    int length,
    Generator<E> interval,
    Linker<T, E, S> link,
  ) sync* {
    var val = this(0);
    for (var i = 1; i < length; i++) {
      final current = this(i);
      yield link(val, current, interval(i - 1));
      val = current;
    }
  }

  List<S> linkToListTill<E, S>(
    int length,
    Generator<E> interval,
    Linker<T, E, S> link,
  ) {
    var list = <S>[];
    var val = this(0);
    for (var i = 1; i < length; i++) {
      final current = this(i);
      list.add(link(val, current, interval(i - 1)));
      val = current;
    }
    return list;
  }
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
extension FTranslator on Mapper {
  static Mapper<int, bool> oddOrEvenCheckerAs(int value) =>
      value.isOdd ? (v) => v.isOdd : (v) => v.isEven;

  static Mapper<int, bool> oddOrEvenCheckerOpposite(int value) =>
      value.isOdd ? (v) => v.isEven : (v) => v.isOdd;
}

///
///
/// [keepV1], [keepV2]
///
/// [doubleMax], ...
/// [intMax], ...
/// [entryKeyIntMax], ...
///
/// [stringLine], ...
/// [durationAdd], ...
///
/// [iteratorDoubleDistanceMax], ...
/// [recordDouble2DirectionMax], ...
///
///
extension FReducer on Reducer {
  static T keepV1<T>(T v1, T v2) => v1;

  static T keepV2<T>(T v1, T v2) => v2;

  ///
  /// double
  ///
  static double doubleMax(double v1, double v2) => math.max(v1, v2);

  static double doubleMin(double v1, double v2) => math.min(v1, v2);

  static double doubleAdd(double v1, double v2) => v1 + v2;

  static double doubleSubtract(double v1, double v2) => v1 - v2;

  static double doubleMultiply(double v1, double v2) => v1 * v2;

  static double doubleDivide(double v1, double v2) => v1 / v2;

  static double doubleModule(double v1, double v2) => v1 % v2;

  static double doubleDivideToInt(double v1, double v2) =>
      (v1 ~/ v2).toDouble();

  // chained operation
  static double doubleAddSquared(double v1, double v2) => v1 * v1 + v2 * v2;

  static double doubleSubtractThenHalf(double v1, double v2) => (v1 - v2) / 2;

  ///
  /// integer
  ///
  static int intMax(int v1, int v2) => math.max(v1, v2);

  static int intMin(int v1, int v2) => math.min(v1, v2);

  static int intAdd(int v1, int v2) => v1 + v2;

  static int intSubtract(int v1, int v2) => v1 - v2;

  static int intMultiply(int v1, int v2) => v1 * v2;

  static int intDivide(int v1, int v2) => v1 ~/ v2;

  static int intAddSquared(int v1, int v2) => v1 * v1 + v2 * v2;

  ///
  /// entry
  ///

  // key
  static MapEntry<int, K> entryKeyIntMax<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) =>
      v1.key > v2.key ? v1 : v2;

  static MapEntry<int, K> entryKeyIntMin<K>(
    MapEntry<int, K> v1,
    MapEntry<int, K> v2,
  ) =>
      v1.key < v2.key ? v1 : v2;

  static MapEntry<double, K> entryKeyDoubleMax<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) =>
      v1.key > v2.key ? v1 : v2;

  static MapEntry<double, K> entryKeyDoubleMin<K>(
    MapEntry<double, K> v1,
    MapEntry<double, K> v2,
  ) =>
      v1.key < v2.key ? v1 : v2;

  // value
  static MapEntry<K, int> entryValueIntMax<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) =>
      v1.value > v2.value ? v1 : v2;

  static MapEntry<K, int> entryValueIntMin<K>(
    MapEntry<K, int> v1,
    MapEntry<K, int> v2,
  ) =>
      v1.value < v2.value ? v1 : v2;

  static MapEntry<K, double> entryValueDoubleMax<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) =>
      v1.value > v2.value ? v1 : v2;

  static MapEntry<K, double> entryValueDoubleMin<K>(
    MapEntry<K, double> v1,
    MapEntry<K, double> v2,
  ) =>
      v1.value < v2.value ? v1 : v2;

  ///
  /// string
  ///
  static String stringLine(String v1, String v2) => '$v1\n$v2';

  static String stringTab(String v1, String v2) => '$v1\t$v2';

  static String stringComma(String v1, String v2) => '$v1, $v2';

  ///
  /// duration
  ///
  static Duration durationMax(Duration a, Duration b) => a > b ? a : b;

  static Duration durationMin(Duration a, Duration b) => a < b ? a : b;

  static Duration durationAdd(Duration v1, Duration v2) => v1 + v2;

  static Duration durationSubtract(Duration v1, Duration v2) => v1 - v2;

  ///
  /// iterator
  ///
  static Iterator<double> iteratorDoubleDistanceMax(
    Iterator<double> a,
    Iterator<double> b,
  ) =>
      a.distance > b.distance ? a : b;

  static Iterator<double> iteratorDoubleDistanceMin(
    Iterator<double> a,
    Iterator<double> b,
  ) =>
      a.distance < b.distance ? a : b;

  ///
  /// record
  ///
  static (double, double) recordDouble2DirectionMax(
    (double, double) a,
    (double, double) b,
  ) =>
      a.direction > b.direction ? a : b;

  static (double, double) recordDouble2DirectionMin(
    (double, double) a,
    (double, double) b,
  ) =>
      a.direction < b.direction ? a : b;
}

///
///
///
extension FCompanion on Companion {
  static T keep<T, S>(T origin, S another) => origin;
}

///
///
///
extension FMixer on Mixer {
  static MapEntry<K, V> entry<K, V>(K key, V value) => MapEntry(key, value);

  static MapEntry<V, K> entryReverse<K, V>(K k, V v) => MapEntry(v, k);
}

///
///
///
extension FLerper on Lerper {
  static Lerper<T> of<T>(T value) => (_) => value;

  ///
  /// [clamp]
  /// [clamp01], [clampPositive], [clampNegative]
  ///
  static Lerper<T> clamp<T>(
    Lerper<T> transform,
    double lowerLimit,
    double upperLimit,
  ) =>
      (value) => transform(value.clampDouble(lowerLimit, upperLimit));

  static Lerper<T> clamp01<T>(Lerper<T> transform) =>
      (value) => transform(value.clamp01);

  static Lerper<T> clampPositive<T>(Lerper<T> transform) =>
      (value) => transform(value.clampPositive);

  static Lerper<T> clampNegative<T>(Lerper<T> transform) =>
      (value) => transform(value.clampNegative);

  ///
  /// [from]
  ///
  static Mapper<double, T> from<T>(T begin, T end) => switch (begin) {
        _ => throw StateError(KErrorMessage.lerperNoImplementation),
      };
}

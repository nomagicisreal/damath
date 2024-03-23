///
///
/// this file contains:
/// [Consumer], [ConsumerIndexable]
/// [Intersector], [IntersectorIndexable]
/// [Supplier], [Generator]
///
/// [Mapper]
/// [Reducer]
/// [Collapser]
/// [Companion]
/// [Absorber]
/// [Forcer]
/// [Collector]
/// [Linker]
/// [Fusionor]
/// [Translator]
/// [Combiner]
/// [Mixer]
///
/// [Predicator], [PredicatorCombiner], [PredicatorMixer], [PredicatorFusionor], [PredicatorGenerator]
/// [Generator2D], [MapperGenerator], [ReducerGenerator], [CollapserGenerator], [CompanionGenerator], ...
/// [Differentiator]
/// [Lerper]
///
/// extensions:
/// [FSupplier]
/// [FPredicator], [FPredicatorCombiner], [FPredicatorFusionor]
/// [FMapper]
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
typedef Consumer<T> = void Function(T value);
typedef ConsumerIndexable<T> = void Function(T value, int index);
typedef Intersector<A, B> = void Function(A a, B b);
typedef IntersectorIndexable<A, B> = void Function(A a, B b, int index);
typedef Supplier<S> = S Function();
typedef Generator<S> = S Function(int index);

typedef Mapper<T> = T Function(T value);
typedef Reducer<T> = T Function(T v1, T v2);
typedef Collapser<T> = T Function(T v1, T v2, T v3);
typedef Companion<T, E> = T Function(T value, E other);
typedef Absorber<T, E> = T Function(T value, E e1, E e2);
typedef Forcer<T, E> = T Function(T v1, T v2, E other);
typedef Collector<T, A, B> = T Function(T value, A a, B b);

typedef Linker<T, E, S> = S Function(T v1, T v2, E other);
typedef Fusionor<P, Q, R, S> = S Function(P p, Q q, R r);
typedef Translator<T, S> = S Function(T value);
typedef Combiner<T, S> = S Function(T v1, T v2);
typedef Mixer<A, B, S> = S Function(A a, B b);

///
/// predicator
///
typedef Predicator<T> = bool Function(T value);
typedef PredicatorCombiner<T> = bool Function(T v1, T v2);
typedef PredicatorMixer<A, B> = bool Function(A a, B b);
typedef PredicatorFusionor<O, P, Q> = bool Function(O o, P p, Q q);
typedef PredicatorGenerator<T> = bool Function(T value, int index);

///
/// supplier, generator
///
typedef Generator2D<S> = S Function(int i, int j);
typedef MapperGenerator<T> = T Function(T value, int index);
typedef ReducerGenerator<T> = T Function(T v1, T v2, int index);
typedef CollapserGenerator<T> = T Function(T v1, T v2, T v3, int index);
typedef CompanionGenerator<T, E> = T Function(T value, E other, int index);
typedef AbsorberGenerator<T, E> = T Function(T value, E e1, E e2, int index);
typedef ForcerGenerator<T, E> = T Function(T v1, T v2, E other, int index);
typedef CollectorGenerator<T, A, B> = T Function(T value, A a, B b, int index);

typedef LinkerGenerator<T, E, S> = S Function(T v1, T v2, E other, int index);
typedef FusionorGenerator<P, Q, R, S> = S Function(P p, Q q, R r, int index);
typedef TranslatorGenerator<T, S> = S Function(T value, int index);
typedef CombinerGenerator<T, S> = S Function(T v1, T v2, int index);
typedef MixerGenerator<A, B, S> = S Function(A a, B b, int index);

///
/// others
///
typedef Differentiator<A, B> = int Function(A a, B b);
typedef Lerper<T> = T Function(double t);

///
///
///
///
///
/// extensions
///
///
///
///

///
/// supplier
///
extension FSupplier on Supplier {
  ///
  /// [iterableElement]
  ///
  static Supplier<Iterable<I>> iterableElement<I>(I value) => () sync* {
        yield value;
      };
}

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
  ///
  static bool iterableIsLengthEqual<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length == b.length;

  static bool iterableIsLengthDifferent<A, B>(Iterable<A> a, Iterable<B> b) =>
      a.length != b.length;
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
/// [keep]
/// [boolKeep], [boolReverse]
/// [doubleKeep], ...
///
/// [iterableAppend], ...
/// [listAdd], ...
///
/// [lerp]
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
    final times = math.pi * 2 * period;
    return FLerper.clamp((value) => transform(times * value), 0.0, 1.0);
  }

  static Mapper<double> doubleOnPeriodSinByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.sin);

  static Mapper<double> doubleOnPeriodCosByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.cos);

  static Mapper<double> doubleOnPeriodTanByTimes(int times) =>
      doubleOnPeriod(times.toDouble(), math.tan);

  ///
  /// iterable
  /// [iterableAppend]
  ///
  static Mapper<Iterable<I>> iterableAppend<I>(I value) =>
      (iterable) => iterable.append(value);

  ///
  /// list
  /// [listAdd]
  ///
  static Mapper<List<T>> listAdd<T>(T value) => (list) => list..add(value);
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
    Translator<T, E> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; i < length; i++) {
      yield toVal(this(i));
    }
  }

  List<E> yieldingToList<E>(
    int length,
    Translator<T, E> toVal, [
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
extension FTranslator on Translator {
  static Translator<int, bool> oddOrEvenCheckerAs(int value) =>
      value.isOdd ? (v) => v.isOdd : (v) => v.isEven;

  static Translator<int, bool> oddOrEvenCheckerOpposite(int value) =>
      value.isOdd ? (v) => v.isEven : (v) => v.isOdd;
}

///
/// [keepCurrent], [keepValue]
/// [doubleMax], ...
/// [intMax], ...
/// [stringLine], ...
///
extension FReducer on Reducer {
  static T keepCurrent<T>(T current, T value) => current;

  static T keepValue<T>(T current, T value) => value;

  ///
  /// double
  ///
  static const Reducer<double> doubleMax = math.max<double>;
  static const Reducer<double> doubleMin = math.min<double>;

  static double doubleAdd(double v1, double v2) => v1 + v2;

  static double doubleSubtract(double v1, double v2) => v1 - v2;

  static double doubleMultiply(double v1, double v2) => v1 * v2;

  static double doubleDivide(double v1, double v2) => v1 / v2;

  static double doubleDivideToInt(double v1, double v2) =>
      (v1 ~/ v2).toDouble();

  static double doubleModule(double v1, double v2) => v1 % v2;

  static double doubleAddSquared(double v1, double v2) => v1 * v1 + v2 * v2;

  ///
  /// integer
  ///
  static const Reducer<int> intMax = math.max<int>;
  static const Reducer<int> intMin = math.min<int>;

  static int intAdd(int v1, int v2) => v1 + v2;

  static int intSubtract(int v1, int v2) => v1 - v2;

  static int intMultiply(int v1, int v2) => v1 * v2;

  static int intDivide(int v1, int v2) => v1 ~/ v2;

  static int intAddSquared(int v1, int v2) => v1 * v1 + v2 * v2;

  ///
  /// string
  ///
  static String stringLine(String v1, String v2) => '$v1\n$v2';

  static String stringTab(String v1, String v2) => '$v1\t$v2';

  static String stringComma(String v1, String v2) => '$v1, $v2';
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
extension FLerper on Lerper {
  static Lerper<T> of<T>(T value) => (_) => value;

  ///
  /// [clamp]
  /// [clampZeroTo1], [clampPositive], [clampNegative]
  ///
  static Lerper<T> clamp<T>(
    Lerper<T> transform,
    double lowerLimit,
    double upperLimit,
  ) =>
      (value) => transform(value.clampDouble(lowerLimit, upperLimit));

  static Lerper<T> clampZeroTo1<T>(Lerper<T> transform) =>
      (value) => transform(value.clampZeroTo1);

  static Lerper<T> clampPositive<T>(Lerper<T> transform) =>
      (value) => transform(value.clampPositive);

  static Lerper<T> clampNegative<T>(Lerper<T> transform) =>
      (value) => transform(value.clampNegative);
}

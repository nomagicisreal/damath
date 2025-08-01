part of '../custom.dart';

///
///
/// [Callback]...
/// [Applier], ...
/// [Supplier], ...
///
/// [Predicator], ...
/// [ConsumerIndexable], ...
/// [Generator], ..., [LinkerGenerator], ...
/// [Countable], ...
///
/// [DateTimeFormatter], ...
/// [Positioned4Double], ...
///
///
/// [FListener]
/// [FPredicatorFusionor]
/// [FGenerator]
/// [FMapper]
/// [FKeep]
///
///

///
///
///
typedef Callback = void Function();
typedef Consumer<T> = void Function(T value);
typedef Intersector<T> = void Function(T v1, T v2);
typedef Pairitor<A, B> = void Function(A a, B b);

///
///
///
typedef Applier<T> = T Function(T value);
typedef Reducer<T> = T Function(T v1, T v2);
typedef Collapser<T> = T Function(T v1, T v2, T v3);
typedef Companion<T, E> = T Function(T value, E other);
typedef Absorber<T, E> = T Function(T value, E e1, E e2);
typedef Collector<T, E> = T Function(T v1, T v2, E other);
typedef Forcer<T, A, B> = T Function(T value, A a, B b);

///
///
///
typedef Supplier<S> = S Function();
typedef Mapper<T, S> = S Function(T value);
typedef Fusionor<T, S> = S Function(T v1, T v2);
typedef Mixer<T, E, S> = S Function(T value, E element);
typedef Linker<T, E, S> = S Function(T v1, T v2, E other);
typedef Chainer<T, E, S> = S Function(S element, T value, E other);
typedef Synthesizer<A, B, C, S> = S Function(A a, B b, C c);

///
///
///
typedef Predicator<T> = bool Function(T value);
typedef PredicatorReducer<T> = bool Function(T v1, T v2);
typedef PredicatorMixer<T, E> = bool Function(T value, E element);
typedef PredicatorSynthesizer<O, P, Q> = bool Function(O o, P p, Q q);
typedef PredicatorGenerator<T> = bool Function(T value, int index);
typedef Ternarator<T> = bool? Function(T value);
typedef TernaratorReducer<T> = bool? Function(T v1, T v2);

///
///
///
typedef ConsumerIndexable<T> = void Function(T value, int index);
typedef IntersectorIndexable<T> = void Function(T v1, T v2, int index);
typedef PairitorIndexable<A, B> = void Function(A a, B b, int index);

///
///
///
typedef Generator<S> = S Function(int index);
typedef Generator2D<S> = S Function(int i, int j);
typedef ApplierGenerator<T> = T Function(T value, int index);
typedef ReducerGenerator<T> = T Function(T v1, T v2, int index);
typedef CollapserGenerator<T> = T Function(T v1, T v2, T v3, int index);
typedef CompanionGenerator<T, E> = T Function(T value, E other, int index);
typedef AbsorberGenerator<T, E> = T Function(T value, E e1, E e2, int index);
typedef CollectorGenerator<T, E> = T Function(T v1, T v2, E other, int index);
typedef ForcerGenerator<T, A, B> = T Function(T value, A a, B b, int index);

///
///
///
typedef LinkerGenerator<T, E, S> = S Function(T v1, T v2, E other, int index);
typedef FusionorGenerator<T, S> = S Function(T v1, T v2, int index);
typedef MapperGenerator<T, S> = S Function(T value, int index);
typedef MixerGenerator<T, E, S> = S Function(T value, E element, int index);
typedef SynthesizerGenerator<P, Q, R, S> = S Function(P p, Q q, R r, int index);

///
///
///
typedef Iterable2D<T> = Iterable<Iterable<T>>; // future: implement dataframe
typedef List2D<T> = List<List<T>>;

///
///
///
typedef Countable<T> = (int, T);
typedef Combiner<T> = int Function(T value);
// typedef Applicator<T, E> = void Function(T element, Applier<E> apply);
typedef Lerper<T> = T Function(double t);
typedef Differentiator<A, B> = int Function(A a, B b);
typedef Decider<T, S> = Consumer<T> Function(S toggle);
typedef Supporter<T, S> = T Function(Supplier<S> taging);
typedef Sequencer<T, I, S> =
    Mapper<int, S> Function(T previous, T next, I interval);

///
///
///
typedef DateTimeFormatter = String Function(DateTime date, dynamic locale);

///
///
///
// ltrb (left, top, right, bottom) or (start, top, right, bottom)
typedef Positioned4Double = (double?, double?, double?, double?);

///
///
///
extension FListener on Callback {
  static void none() {}

  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

///
///
///
extension FPredicatorFusionor on PredicatorReducer {
  static bool isEqual<T>(T valueA, T valueB) => valueA == valueB;

  static bool isDifferent<T>(T valueA, T valueB) => valueA != valueB;

  static bool alwaysTrue<T>(T a, T b) => true;

  static bool alwaysFalse<T>(T a, T b) => false;
}

///
/// static methods: [of], [of2D]
/// instance methods:
/// [yielding], ...
/// [foldTill], ...
/// [reduceTill], ...
/// [linkTill], ...
///
extension FGenerator<T> on Generator<T> {
  ///
  ///
  ///
  static Generator<T> of<T>(T value) => (i) => value;

  static Generator2D<T> of2D<T>(T value) => (i, j) => value;

  ///
  ///
  ///
  Iterable<T> yielding(int length, [int start = 0]) sync* {
    for (var i = start; i < length; i++) {
      yield this(i);
    }
  }

  List<T> yieldingToList(int length, [int start = 0]) => [
    for (var i = start; i < length; i++) this(i),
  ];

  Iterable<E> yieldingMap<E>(
    int length,
    Mapper<T, E> toVal, [
    int start = 0,
  ]) sync* {
    for (var i = start; i < length; i++) {
      yield toVal(this(i));
    }
  }

  List<E> yieldingMapToList<E>(
    int length,
    Mapper<T, E> toVal, [
    int start = 0,
  ]) => [for (var i = start; i < length; i++) toVal(this(i))];

  ///
  ///
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
    Forcer<S, T, E> collect,
  ) {
    var val = initialValue;
    for (var i = 0; i < length; i++) {
      val = collect(val, this(i), another(i));
    }
    return val;
  }

  ///
  ///
  ///
  T reduceTill(int length, Reducer<T> reducing) {
    var val = this(0);
    for (var i = 1; i < length; i++) {
      val = reducing(val, this(i));
    }
    return val;
  }

  ///
  ///
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
extension FMapper on Mapper {
  static double intToDouble(int value) => value.toDouble();

  static int doubleToInt(double value) => value.toInt();

  static Mapper<int, bool> oddOrEvenCheckerAs(int value) =>
      value.isOdd ? (v) => v.isOdd : (v) => v.isEven;

  static Mapper<int, bool> oddOrEvenCheckerOpposite(int value) =>
      value.isOdd ? (v) => v.isEven : (v) => v.isOdd;
}

///
///
///
extension FKeep on Type {
  static T companion<T, S>(T origin, S another) => origin;

  static T applier<T>(T value) => value;

  static T reduceV1<T>(T v1, T v2) => v1;

  static T reduceV2<T>(T v1, T v2) => v2;

  static double generateDouble(int index) => index.toDouble();

  static int generate(int index) => index;
}

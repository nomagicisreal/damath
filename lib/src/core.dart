///
///
/// [Supplier]
/// [Consumer]
/// [Mapper]
/// [Reducer]
/// [Companion]
/// [Translator]
/// [Combiner]
/// [Mixer]
/// [Supporter]
/// [Fusionor]
/// [Decider]
/// [Sequencer]
///
/// [Predicator], [PredicatorTernary]
/// [Generator], [Generator2D], ...
/// [Differentiator]
///
///
/// [DamathException]
///
///
///

typedef Listener = void Function();
typedef Supplier<T> = T Function();
typedef Consumer<T> = void Function(T value);
typedef Intersector<T> = void Function(T v1, T v2);
typedef Absorber<A, B> = void Function(A a, B b);
typedef Mapper<T> = T Function(T value);
typedef Reducer<T> = T Function(T v1, T v2);
typedef Companion<T, S> = T Function(T origin, S another);
typedef Companion2<T, S> = T Function(T origin, S v1, S v2);
typedef Translator<T, S> = S Function(T value);
typedef Combiner<T, S> = S Function(T v1, T v2);
typedef Mixer<P, Q, S> = S Function(P p, Q q);
typedef Fusionor<O, P, Q, S> = S Function(O o, P p, Q q);
typedef Supporter<T> = T Function(Supplier<int> indexing);
typedef Decider<T, S> = Consumer<T> Function(S toggle);
typedef Sequencer<R, S, I> = Translator<int, R> Function(
    S previous,
    S next,
    I interval,
    );
// typedef Conductor<T> = void Function(T a, T b);

///
///
/// return bool
///
///

typedef Predicator<T> = bool Function(T a);
typedef PredicateCombiner<T> = bool Function(T v1, T v2);
typedef Checker<T> = bool Function(int index, T value);

///
/// indexable
///
typedef IntersectorIndexable<T> = void Function(T v1, T v2, int index);
typedef ConsumerIndexable<T> = void Function(T value, int index);

///
/// generator
///
typedef Generator<T> = T Function(int index);
typedef Generator2D<T> = T Function(int i, int j);
typedef CompanionGenerator<T, S> = T Function(T value, S element, int index);
typedef Companion2Generator<T, S> = T Function(T value, S e1, S e2, int index);
typedef TranslatorGenerator<T, S> = S Function(T value, int index);
typedef ReducerGenerator<T> = T Function(T v1, T v2, int index);

///
/// differentiator
///
typedef Differentiator<P, Q> = int Function(P p, Q q);

///
/// on
///
typedef OnLerp<T> = T Function(double t);
typedef OnAnimate<T, S> = S Function(double t, T value);

class DamathException implements Exception {
  final String message;
  DamathException(this.message);

  @override
  String toString() => 'DamathException: $message';
}
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
typedef Absorber<T> = void Function(T v1, T v2);
typedef Intersector<A, B> = void Function(A a, B b);
typedef Mapper<T> = T Function(T value);
typedef Reducer<T> = T Function(T current, T value);
typedef Reducer2<T> = T Function(T current, T v1, T v2);
typedef Companion<T, E> = T Function(T origin, E another);
typedef Companion2<T, A, B> = T Function(T origin, A a, B b);
typedef CompanionReducer<T, E> = T Function(T current, E v1, E v2);
typedef ReducerCompanion<T, E> = T Function(T v1, T v2, E another);
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

typedef Predicator<T> = bool Function(T value);
typedef PredicatorCombiner<T> = bool Function(T v1, T v2);
typedef PredicatorMixer<A, B> = bool Function(A a, B b);
typedef PredicatorFusionor<O, P, Q> = bool Function(O o, P p, Q q);
typedef Checker<T> = bool Function(int index, T value);

///
/// indexable
///
typedef IntersectorIndexable<A, B> = void Function(A a, B b, int index);
typedef ConsumerIndexable<T> = void Function(T value, int index);

///
/// generator
///
typedef Generator<T> = T Function(int index);
typedef Generator2D<T> = T Function(int i, int j);
typedef CompanionGenerator<T, S> = T Function(T value, S element, int index);
typedef Companion2Generator<T, A, B> = T Function(T value, A a, B b, int index);
typedef TranslatorGenerator<T, S> = S Function(T value, int index);
typedef ReducerGenerator<T> = T Function(T current, T value, int index);
typedef Reducer2Generator<T> = T Function(T current, T v1, T v2, int index);
typedef CombinerGenerator<T, S> = S Function(T v1, T v2, int index);
typedef MixerGenerator<P, Q, S> = S Function(P p, Q q, int index);

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
///
///
/// this file contains:
/// [Consumer], [ConsumerIndexable]
/// [Intersector], [IntersectorIndexable]
/// [Supplier], [Generator]
///
/// [Applier]
/// [Reducer]
/// [Collapser]
/// [Companion]
/// [Absorber]
/// [Forcer]
/// [Collector]
/// [Linker]
/// [Fusionor]
/// [Mapper]
/// [Combiner]
/// [Mixer]
///
/// [Predicator], [PredicatorCombiner], [PredicatorMixer], [PredicatorFusionor], [PredicatorGenerator]
/// [Generator2D], [ApplierGenerator], [ReducerGenerator], [CollapserGenerator], [CompanionGenerator], ...
/// [Differentiator]
/// [Lerper]
///
///
///
part of damath_core;

///
///
typedef Consumer<T> = void Function(T value);
typedef ConsumerIndexable<T> = void Function(T value, int index);
typedef Intersector<A, B> = void Function(A a, B b);
typedef IntersectorIndexable<A, B> = void Function(A a, B b, int index);
typedef Supplier<S> = S Function();
typedef Generator<S> = S Function(int index);

typedef Applier<T> = T Function(T value);
typedef Reducer<T> = T Function(T v1, T v2);
typedef Collapser<T> = T Function(T v1, T v2, T v3);
typedef Companion<T, E> = T Function(T value, E other);
typedef Absorber<T, E> = T Function(T value, E e1, E e2);
typedef Forcer<T, E> = T Function(T v1, T v2, E other);
typedef Collector<T, A, B> = T Function(T value, A a, B b);

typedef Linker<T, E, S> = S Function(T v1, T v2, E other);
typedef Fusionor<P, Q, R, S> = S Function(P p, Q q, R r);
typedef Mapper<T, S> = S Function(T value);
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
typedef ApplierGenerator<T> = T Function(T value, int index);
typedef ReducerGenerator<T> = T Function(T v1, T v2, int index);
typedef CollapserGenerator<T> = T Function(T v1, T v2, T v3, int index);
typedef CompanionGenerator<T, E> = T Function(T value, E other, int index);
typedef AbsorberGenerator<T, E> = T Function(T value, E e1, E e2, int index);
typedef ForcerGenerator<T, E> = T Function(T v1, T v2, E other, int index);
typedef CollectorGenerator<T, A, B> = T Function(T value, A a, B b, int index);

typedef LinkerGenerator<T, E, S> = S Function(T v1, T v2, E other, int index);
typedef FusionorGenerator<P, Q, R, S> = S Function(P p, Q q, R r, int index);
typedef MapperGenerator<T, S> = S Function(T value, int index);
typedef CombinerGenerator<T, S> = S Function(T v1, T v2, int index);
typedef MixerGenerator<A, B, S> = S Function(A a, B b, int index);

///
/// others
///
typedef Differentiator<A, B> = int Function(A a, B b);
typedef Lerper<T> = T Function(double t);

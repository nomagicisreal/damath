///
///
/// this file contains:
/// [Listener]
/// [Decider]
/// [Supporter]
/// [Sequencer]
///
///
/// extensions:
/// [FListener]
///
///
///
///
///
///
///
part of damath_async;

typedef Listener = void Function();
typedef Decider<T, S> = Consumer<T> Function(S toggle);
typedef Supporter<T> = T Function(Supplier<int> indexing);
typedef Sequencer<T, I, S> = Mapper<int, S> Function(
  T previous,
  T next,
  I interval,
);

///
///
/// listener
///
///
extension FListener on Listener {
  static void none() {}

  Future<void> delayed(Duration duration) => Future.delayed(duration, this);

  static final delayedZero = Future.delayed(Duration.zero);
}

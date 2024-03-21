
///
///
/// this file contains:
/// [Listener]
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


///
///
/// listener
///
///
extension FListener on Listener {
  static void none() {}

  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

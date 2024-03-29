///
///
/// this file contains:
/// [StreamExtension]
/// [StreamIterableExtension]
/// [IterableStreamSubscriptionsExtension]
/// [FStream]
///
///
///
/// [FTimer]
/// [FTimerConsumer]
/// [IterableTimerExtension]
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
part of damath_async;

///
/// stream
///
extension StreamExtension<M> on Stream<M> {
  Stream<M> get whereDiff {
    M? previousValue;
    return where((event) {
      if (previousValue == event) {
        return false;
      } else {
        previousValue = event;
        return true;
      }
    });
  }
}

///
/// stream iterable
///
extension StreamIterableExtension<T, I extends Iterable<T>> on Stream<I> {
  Stream<int> get mapLength => map((items) => items.length);

  Stream<Iterable<T>> mapWhere(bool Function(T item) checker) =>
      map((Iterable<T> items) => items.where(checker));
}

///
/// iterable stream subscription
///
extension IterableStreamSubscriptionsExtension on Iterable<StreamSubscription> {
  void pauseAll() => fold<void>(null, (_, stream) => stream.pause());

  void resumeAll() => fold<void>(null, (_, stream) => stream.resume());

  void cancelAll() => fold<void>(null, (_, stream) => stream.cancel());
}

//
extension FStream<T> on Stream<T> {
  ///
  /// of
  ///
  static Stream<int> ofInts({
    int start = 0,
    int end = 10,
    Duration delay = KCore.durationSecond1,
  }) async* {
    assert(end >= start);
    for (var i = start; i <= end; i++) {
      yield i;
      await Future.delayed(delay);
    }
  }

  ///
  ///
  ///
  static Stream<T> generateFromIterable<T>(
    int count, {
    Generator<T>? generator,
  }) =>
      Stream.fromIterable(Iterable.generate(count, generator));

  static Stream<int> intOf({
    int start = 1,
    int end = 10,
    Duration interval = KCore.durationSecond1,
    bool startWithDelay = true,
  }) async* {
    Future<int> yielding(int value) async =>
        Future.delayed(interval).then((_) => value);

    Future<void> delay() async =>
        startWithDelay ? Future.delayed(interval) : null;

    if (end >= start) {
      await delay();
      for (var value = start; value <= end; value++) {
        yield await yielding(value);
      }
    } else {
      await delay();
      for (var value = start; value >= end; value--) {
        yield await yielding(value);
      }
    }
  }
}

///
///
///
///
/// timer
///
///
///

//
extension FTimer on Timer {
  static final Timer zero = Timer(Duration.zero, FListener.none);

  static Timer _nest(
    Duration duration,
    Listener listener,
    Iterable<MapEntry<Duration, Listener>> children,
  ) =>
      Timer(duration, () {
        if (children.isNotEmpty) _sequence(children);
        listener();
      });

  static Timer _sequence(Iterable<MapEntry<Duration, Listener>> elements) {
    final first = elements.first;
    return _nest(first.key, first.value, elements.skip(1));
  }

  static Timer sequencing(
    Iterable<Duration> steps,
    Iterable<Listener> listeners,
  ) =>
      _sequence(steps.iterator.interYieldingToEntry(listeners.iterator));
}

extension FTimerConsumer on Consumer<Timer> {
  static Consumer<Timer> periodicProcessUntil(int n, Listener listener) {
    int count = 0;
    return (timer) {
      listener();
      if (++count == n) {
        timer.cancel();
      }
    };
  }

  static Consumer<Timer> periodicProcessAfter(int n, Listener listener) {
    int count = 0;
    return (timer) => count < n ? count++ : listener();
  }

  static Consumer<Timer> periodicProcessPeriod(
    int period,
    Listener listener,
  ) {
    int count = 0;
    void listenIf(bool value) => value ? listener() : null;
    bool shouldListen() => count % period == 0;

    return (timer) {
      listenIf(shouldListen());
      count++;
    };
  }
}

extension IterableTimerExtension on Iterable<Timer> {
  void cancelAll() {
    for (var t in this) {
      t.cancel();
    }
  }
}

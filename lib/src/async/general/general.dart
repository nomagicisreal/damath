///
///
/// this file contains:
/// classes:
/// [DurationFR]
///
/// extensions:
/// [FutureExtension]
/// [StreamExtension], [StreamIterableExtension]
/// [IterableStreamSubscriptionsExtension]
/// [IterableTimer]
///
/// [FStream]
/// [FTimer], [FConsumerTimer]
///
///
///
///
///
part of '../async.dart';

///
///
///
base class DurationFR {
  final Duration forward;
  final Duration reverse;

  const DurationFR(this.forward, this.reverse);

  const DurationFR.constant(Duration duration)
      : forward = duration,
        reverse = duration;

  ///
  /// constants
  ///
  static const DurationFR zero = DurationFR.constant(Duration.zero);
  static const DurationFR milli100 =
      DurationFR.constant(KCore.durationMilli100);
  static const DurationFR second1 = DurationFR.constant(KCore.durationSecond1);
  static const DurationFR min1 = DurationFR.constant(KCore.durationMin1);

  ///
  /// implementation for [Object]
  ///
  @override
  int get hashCode => Object.hash(forward, reverse);

  @override
  bool operator ==(covariant DurationFR other) => hashCode == other.hashCode;

  @override
  String toString() => 'DurationFR(f: $forward, r:$reverse)';

  ///
  ///
  ///
  DurationFR operator +(DurationFR other) =>
      DurationFR(forward + other.forward, reverse + other.reverse);

  DurationFR operator -(DurationFR other) =>
      DurationFR(forward - other.forward, reverse - other.reverse);

  DurationFR operator &(Duration value) =>
      DurationFR(forward + value, reverse + value);

  DurationFR operator ^(Duration value) =>
      DurationFR(forward - value, reverse - value);

  DurationFR operator ~/(int value) =>
      DurationFR(forward ~/ value, reverse ~/ value);
}

///
///
///
extension FutureExtension<T> on Future<T> {
  static final delayedZero = Future.delayed(Duration.zero);
}

///
/// stream
///
extension StreamExtension<M> on Stream<M> {
  ///
  /// [fromFutures]
  ///
  static Stream<P> fromFutures<P>(Iterable<Future<P>> futures) async* {
    for (var future in futures) {
      yield await future;
    }
  }

  ///
  /// [whereDiff]
  ///
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

///
///
///
extension IterableTimer on Iterable<Timer> {
  void cancelAll() {
    for (var t in this) {
      t.cancel();
    }
  }
}

///
///
///
/// takeaway
///
///
///

///
///
///
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
extension FTimer on Timer {
  static final Timer zero = Timer(Duration.zero, FListener.none);

  static Timer _nest(
    Duration duration,
    Listener listener,
    Iterable<(Duration, Listener)> children,
  ) =>
      Timer(duration, () {
        if (children.isNotEmpty) _sequence(children);
        listener();
      });

  static Timer _sequence(Iterable<(Duration, Listener)> elements) {
    final first = elements.first;
    return _nest(first.$1, first.$2, elements.skip(1));
  }

  static Timer sequencing(
    Iterable<Duration> steps,
    Iterable<Listener> listeners,
  ) =>
      _sequence(steps.iterator.pairMap(listeners.iterator, Record2.mix));
}

///
///
///
extension FConsumerTimer on Consumer<Timer> {
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

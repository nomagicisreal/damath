///
///
/// this file contains:
///
///
/// [Beats]
/// [BeatsOfInstrument]
///
///
/// [StreamExtension]
/// [StreamIterableExtension]
/// [IterableStreamSubscriptionsExtension]
///
///
/// [FTimer]
/// [FTimerConsumer]
/// [FStream]
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
part of damath;

///
///
///
///
/// audio
///
///
///
///
///

class Beats {
  final Duration segment;

  const Beats(this.segment);

  static Consumer<Timer> _limitedListener({
    required Consumer<Timer> listener,
    required int maxTick,
    required Listener onCancel,
  }) {
    final Consumer<Timer> canceler = onCancel == FListener.none
        ? (timer) => timer.cancel()
        : (timer) {
      onCancel();
      timer.cancel();
    };
    return (timer) => timer.tick > maxTick ? canceler(timer) : listener(timer);
  }

  static Consumer<Timer> _checkIfListenOnSequences({
    required Iterable<int> sequences,
    required int totalInterval,
    required Consumer<Timer> listener,
  }) =>
      sequences.length == totalInterval
          ? listener
          : (timer) {
        try {
          // the last sequences in beats is 0
          if (sequences.contains(timer.tick % totalInterval)) {
            listener(timer);
          }
        } finally {}
      };

  ///
  /// duration -> listener -> duration -> listener ...
  ///

  Timer timerOf({
    Consumer<Timer>? listener,
    Listener onCancel = FListener.none,
    required BeatsStyle style,
  }) =>
      Timer.periodic(
        segment ~/ style.interval,
        _limitedListener(
          listener: _checkIfListenOnSequences(
            sequences: style.sequences,
            totalInterval: style.modulus,
            listener: listener ?? (timer) {},
          ),
          maxTick: style.maxTick,
          onCancel: onCancel,
        ),
      );
}

class BeatsStyle {
  final int interval;
  final int frequency;
  final int maxTick;
  final Iterable<int> sequences;

  int get modulus => interval * frequency;

  const BeatsStyle({
    this.frequency = 1, // tick on every segment
    required this.interval,
    required this.maxTick,
    required this.sequences,
  });

  const BeatsStyle.of8({
    this.frequency = 1,
    this.sequences = sequence1To8,
    required this.maxTick,
  }) : interval = 8;

  const BeatsStyle.of16({
    this.frequency = 1,
    this.sequences = sequence1To16,
    required this.maxTick,
  }) : interval = 16;

  static const List<int> sequence1 = [1];
  static const List<int> sequence1To8 = [1, 2, 3, 4, 5, 6, 7, 8];
  static const List<int> sequence1To16 = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16
  ];
}

class BeatsOfInstrument extends Beats {
  final int interval;
  final Iterable<int> sequences;

  const BeatsOfInstrument(
      super.segment, {
        required this.interval,
        required this.sequences,
      });

  Timer timerUntilMaxTick({
    int frequency = 1,
    Listener onCancel = FListener.none,
    required Consumer<Timer> listener,
    required int maxTick,
  }) =>
      timerOf(
        listener: listener,
        style: BeatsStyle(
          interval: interval,
          frequency: frequency,
          maxTick: maxTick,
          sequences: sequences,
        ),
        onCancel: onCancel,
      );

  Timer timerUntilMaxSection({
    int frequency = 1,
    Listener onCancel = FListener.none,
    required Consumer<Timer> listener,
    required int maxSection,
  }) =>
      timerUntilMaxTick(
        frequency: frequency,
        listener: listener,
        maxTick: interval * maxSection,
      );
}



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




///
///
///
/// timer
///
///
///
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

  static Timer sequencing(List<Duration> steps, List<Listener> listeners) =>
      _sequence(steps.combine(listeners));
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

///
///
/// stream
///
///
extension FStream<T> on Stream<T> {
  ///
  /// of
  ///
  static Stream<int> ofInts({
    int start = 0,
    int end = 10,
    Duration delay = KDuration.second1,
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
    Duration interval = KDuration.second1,
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



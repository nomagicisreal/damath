///
///
/// this file contains:
///
///
/// [Beats]
/// [BeatsOfInstrument]
///
///
///
///
part of damath_async;


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

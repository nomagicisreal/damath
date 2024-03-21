///
///
/// this file contains:
/// [Decider]
/// [Supporter]
/// [Sequencer]
///
///
/// extension:
/// [FSequencer]
///
///
///
part of damath_experiment;

///
///
///
typedef Sequencer<R, S, I> = Translator<int, R> Function(
  S previous,
  S next,
  I interval,
);


///
///
///
extension FSequencer on Sequencer {
  ///
  /// [linking]
  ///
  /// sequence by generator
  ///
  static List<S> linking<S, T, I>({
    required int totalStep,
    required Generator<T> step,
    required Generator<I> interval,
    required Sequencer<S, T, I> sequencer,
  }) {
    final lengthIntervals = totalStep - 1;

    final result = <S>[];

    var current = step(0);
    for (var i = 0; i < lengthIntervals; i++) {
      final next = step(i + 1);
      result.add(sequencer(current, next, interval(i))(i));
      current = next;
    }
    return result;
  }
}

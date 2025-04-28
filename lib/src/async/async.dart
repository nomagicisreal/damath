import 'dart:async';

import 'package:damath/src/collection/collection.dart';
import 'package:damath/src/custom/custom.dart';
import 'package:damath/src/primary/primary.dart';

///
///
/// [StreamExtension]
/// [TimerExtension]
///
///

///
/// [fromFutures], ...
/// [whereDiff], ...
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

  static Stream<int> ofInts({
    int start = 0,
    int end = 10,
    Duration delay = DurationExtension.second1,
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
///
///
/// takeaway
///
///
///
extension TimerExtension on Timer {
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

  ///
  ///
  ///
  static Consumer<Timer> consumer_after(int n, Listener listener) {
    int count = 0;
    return (timer) => count < n ? count++ : listener();
  }

  static Consumer<Timer> consumer_until(int n, Listener listener) {
    int count = 0;
    return (timer) {
      listener();
      if (++count == n) {
        timer.cancel();
      }
    };
  }

  static Consumer<Timer> consumer_period(
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

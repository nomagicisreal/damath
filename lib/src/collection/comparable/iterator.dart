part of '../collection.dart';

///
///
/// [IteratorComparable]
/// [IteratorDouble]
///
///
///

///
/// static methods:
/// [comparator], [compareReverse]
/// [isEqual], ...
///
/// instance methods:
/// [isSorted], ...
/// [consecutiveCounted], ...
///
///
extension IteratorComparable<C extends Comparable> on Iterator<C> {
  ///
  /// [comparator], [compareReverse]
  ///
  static Comparator<C> comparator<C extends Comparable>(bool increase) =>
      increase ? Comparable.compare : IteratorComparable.compareReverse;

  /// it is the reverse version of [Comparable.compare]
  static int compareReverse<C extends Comparable>(C a, C b) => b.compareTo(a);

  ///
  /// [isEqual], [notEqual]
  /// [isIncrease], [isDecrease]
  /// [notIncrease], [notDecrease]
  ///
  // require a == b
  static bool isEqual<C extends Comparable>(C a, C b) => a.compareTo(b) == 0;

  // require a != b
  static bool notEqual<C extends Comparable>(C a, C b) => a.compareTo(b) != 0;

  // require a < b
  static bool isIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) == -1;

  // require a > b
  static bool isDecrease<C extends Comparable>(C a, C b) => a.compareTo(b) == 1;

  // require a >= b
  static bool notIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != -1;

  // require a <= b
  static bool notDecrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != 1;

  ///
  /// [predicateLower]
  /// [predicateUpper]
  ///
  static Predicator<C> predicateLower<C extends Comparable>(
      C min, [
        bool orSame = false,
      ]) =>
      orSame
          ? (C value) => IteratorComparable.notIncrease(min, value)
          : (C value) => IteratorComparable.isDecrease(min, value);

  static Predicator<C> predicateUpper<C extends Comparable>(
      C max, [
        bool orSame = false,
      ]) =>
      orSame
          ? (C value) => IteratorComparable.notDecrease(max, value)
          : (C value) => IteratorComparable.isIncrease(max, value);

  ///
  /// [_invalidFor]
  /// [_ternarateFor]
  /// in convention, the validation for [PredicatorReducer] should pass in order of (lower, upper)
  ///
  static PredicatorReducer<C> _validFor<C extends Comparable>(
      bool increase, [
        bool strictly = false,
      ]) =>
      strictly
          ? increase
          ? isIncrease
          : isDecrease
          : increase
          ? notDecrease
          : notIncrease;

// static PredicatorReducer<C> _invalidFor<C extends Comparable>(
//   bool increase, [
//   bool strictly = false,
// ]) =>
//     strictly
//         ? increase
//             ? notDecrease
//             : notIncrease
//         : increase
//         ? isDecrease
//         : isIncrease;
//
// ///
// /// [isSorted]
// ///
// bool isSorted(bool increase, [bool identical = false]) =>
//     !exist(_invalidFor(increase, identical));
//
// ///
// /// [checkSorted]
// /// [checkSortedForSupply]
// /// [checkSortedForListen]
// ///
// void checkSorted([bool increase = true]) {
//   if (!isSorted(increase)) {
//     throw StateError(Erroring.comparableDisordered);
//   }
// }
//
// void checkSortedForListen(Listener listen, [bool increase = true]) =>
//     isSorted(increase)
//         ? listen()
//         : throw StateError(Erroring.comparableDisordered);
//
// S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
//     isSorted(increase)
//         ? supply()
//         : throw StateError(Erroring.comparableDisordered);
}

///
///
/// static methods:
/// [reduceMaxDistance], ...
///
/// instance methods:
/// [min], ...
/// [sum], ...
/// [distance], ...
///
/// [abs], ...
/// [interDistanceTo], ...
///
///
///
extension IteratorDouble on Iterator<double> {
  ///
  ///
  ///
  /// static methods
  ///
  ///
  ///
  static Iterator<double> reduceMaxDistance(
      Iterator<double> a,
      Iterator<double> b,
      ) => a.distance > b.distance ? a : b;

  static Iterator<double> reduceMinDistance(
      Iterator<double> a,
      Iterator<double> b,
      ) => a.distance < b.distance ? a : b;

  ///
  /// [min], [max], [mode]
  /// [range], [boundary]
  ///
  double get min => reduce(DoubleExtension.reduceMin);

  double get max => reduce(DoubleExtension.reduceMax);

  double get mode => toMapCounted.reduce(MapEntryExtension.reduceMaxValueInt).key;

  double get range => applyMoveNext((value) {
    var min = value;
    var max = value;
    while (moveNext()) {
      if (current < min) min = current;
      if (current > max) max = current;
    }
    return max - min;
  });

  (double, double) get boundary => supplyMoveNext(() {
    var min = current;
    var max = current;
    while (moveNext()) {
      if (current < min) min = current;
      if (current > max) max = current;
    }
    return (min, max);
  });

  ///
  /// [sumSquared]
  /// [meanArithmetic], [meanGeometric]
  ///
  double get sumSquared => reduce(DoubleExtension.reducePlusSquared);

  double get meanArithmetic => applyMoveNext((total) {
    var length = 1;
    while (moveNext()) {
      total += current;
      length++;
    }
    return total / length;
  });

  double get meanGeometric => applyMoveNext((total) {
    var length = 1;
    while (moveNext()) {
      total *= current;
      length++;
    }
    return math.pow(total, 1 / length).toDouble();
  });

  ///
  /// [distance], [volume]
  ///
  double get distance => math.sqrt(reduce(DoubleExtension.reducePlusSquared));

  double get volume => reduce(DoubleExtension.reduceMultiply);

  ///
  /// [abs], [rounded], [roundUpTo]
  ///
  Iterable<double> get abs => takeAllApply((v) => v.abs());

  Iterable<double> get rounded => takeAllApply((v) => v.roundToDouble());

  ///
  ///
  /// intersection
  ///
  ///

  ///
  /// [interDistanceTo], [interDistanceFrom]
  /// [interDistanceHalfTo], [interDistanceHalfFrom]
  /// [interDistanceCumulate]
  ///
  Iterable<double> interDistanceTo(Iterator<double> destination) =>
      destination.pairTake(this, DoubleExtension.reduceMinus);

  Iterable<double> interDistanceFrom(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinus);

  Iterable<double> interDistanceHalfTo(Iterator<double> destination) =>
      destination.pairTake(this, DoubleExtension.reduceMinusThenHalf);

  Iterable<double> interDistanceHalfFrom(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinusThenHalf);

  double interDistanceCumulate(Iterator<double> another) => interReduce(
    another,
    DoubleExtension.reduceMinus,
    DoubleExtension.reducePlus,
  );
}


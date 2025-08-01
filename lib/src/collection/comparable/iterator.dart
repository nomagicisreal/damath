part of '../collection.dart';

///
///
/// [IteratorComparable]
/// [IteratorDouble]
///
///
///

///
/// [comparator], ...
/// [isEqual], ...
/// [predicateLower], ...
/// [predicateValid], ...
///
extension IteratorComparable<C extends Comparable> on Iterable<C> {
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
  /// [predicateLower], [predicateUpper]
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
  /// [predicateInvalid], [predicateInvalid]
  ///
  static PredicatorReducer<C> predicateValid<C extends Comparable>(
    OrderLinear order, [
    bool strictly = false,
  ]) => switch (order) {
    OrderLinear.increase => strictly ? isIncrease : notDecrease,
    OrderLinear.decrease => strictly ? isDecrease : notIncrease,
  };

  static PredicatorReducer<C> predicateInvalid<C extends Comparable>(
    OrderLinear order, [
    bool strictly = false,
  ]) => switch (order) {
    OrderLinear.increase => strictly ? notIncrease : isDecrease,
    OrderLinear.decrease => strictly ? notDecrease : isIncrease,
  };
}

///
///
/// [min], ...
/// [distance], ...
/// [sumSquared], ...
///
/// [abs], ...
/// [interDistanceTo], ...
///
///
///
extension IteratorDouble on Iterator<double> {
  ///
  /// [min], [max], [mode]
  ///
  double get min => reduce(DoubleExtension.reduceMin);

  double get max => reduce(DoubleExtension.reduceMax);

  double get mode =>
      toMapCounted.entries.reduce(MapEntryExtension.reduceMaxValueInt).key;

  ///
  /// [range], [boundary]
  ///
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
  /// [sumSquared], [meanArithmetic], [meanGeometric]
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
  /// [abs], [rounded]
  ///
  double get distance => math.sqrt(reduce(DoubleExtension.reducePlusSquared));

  double get volume => reduce(DoubleExtension.reduceMultiply);

  Iterable<double> get abs => takeAllApply((v) => v.abs());

  Iterable<double> get rounded => takeAllApply((v) => v.roundToDouble());

  ///
  /// [interDistanceTo], [interDistanceFrom], [interDistanceHalfTo], [interDistanceHalfFrom]
  /// [interDistanceCumulate]
  ///
  Iterable<double> interDistanceTo(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinus);

  Iterable<double> interDistanceFrom(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinus);

  Iterable<double> interDistanceHalfTo(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinusThenHalf);

  Iterable<double> interDistanceHalfFrom(Iterator<double> source) =>
      pairTake(source, DoubleExtension.reduceMinusThenHalf);

  double interDistanceCumulate(Iterator<double> b) =>
      interReduce(b, DoubleExtension.reduceMinus, DoubleExtension.reducePlus);
}

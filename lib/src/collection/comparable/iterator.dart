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
  /// [invalidFor]
  /// [_ternarateFor]
  /// in convention, the validation for [PredicatorReducer] should pass in order of (lower, upper)
  ///
  static PredicatorReducer<C> validFor<C extends Comparable>(
    OrderLinear order, [
    bool strictly = false,
  ]) => switch (order) {
    OrderLinear.increase => strictly ? isIncrease : notDecrease,
    OrderLinear.decrease => strictly ? isDecrease : notIncrease,
  };

  static PredicatorReducer<C> invalidFor<C extends Comparable>(
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
///
/// [abs], ...
/// [interDistanceTo], ...
///
///
///
extension IteratorDouble on Iterator<double> {
  ///
  /// [min], [max], [mode]
  /// [range], [boundary]
  ///
  static double min(Iterator<double> vector) =>
      IteratorExtension.reduce(vector, DoubleExtension.reduceMin);

  static double max(Iterator<double> vector) =>
      IteratorExtension.reduce(vector, DoubleExtension.reduceMax);

  static double mode(Iterator<double> vector) =>
      IteratorTo.toMapCounted(
        vector,
      ).reduce(MapEntryExtension.reduceMaxValueInt).key;

  static double range(Iterator<double> vector) =>
      IteratorExtension.applyMoveNext(vector, (value) {
        var min = value;
        var max = value;
        while (vector.moveNext()) {
          if (vector.current < min) min = vector.current;
          if (vector.current > max) max = vector.current;
        }
        return max - min;
      });

  static (double, double) boundary(Iterator<double> vector) =>
      IteratorTo.supplyMoveNext(vector, () {
        var min = vector.current;
        var max = vector.current;
        while (vector.moveNext()) {
          if (vector.current < min) min = vector.current;
          if (vector.current > max) max = vector.current;
        }
        return (min, max);
      });

  static double sumSquared(Iterator<double> vector) =>
      IteratorExtension.reduce(vector, DoubleExtension.reducePlusSquared);

  static double meanArithmetic(Iterator<double> vector) =>
      IteratorExtension.applyMoveNext(vector, (total) {
        var length = 1;
        while (vector.moveNext()) {
          total += vector.current;
          length++;
        }
        return total / length;
      });

  static double meanGeometric(Iterator<double> vector) =>
      IteratorExtension.applyMoveNext(vector, (total) {
        var length = 1;
        while (vector.moveNext()) {
          total *= vector.current;
          length++;
        }
        return math.pow(total, 1 / length).toDouble();
      });

  static double distance(Iterator<double> vector) => math.sqrt(
    IteratorExtension.reduce(vector, DoubleExtension.reducePlusSquared<double>),
  );

  static double volume(Iterator<double> vector) =>
      IteratorExtension.reduce(vector, DoubleExtension.reduceMultiply);

  static Iterable<double> abs(Iterator<double> vector) =>
      IteratorExtension.takeAllApply(vector, (v) => v.abs());

  static Iterable<double> rounded(Iterator<double> vector) =>
      IteratorExtension.takeAllApply(vector, (v) => v.roundToDouble());

  static Iterable<double> interDistanceTo(
    Iterator<double> destination,
    Iterator<double> source,
  ) => IteratorTogether.pairTake(
    destination,
    source,
    DoubleExtension.reduceMinus,
  );

  static Iterable<double> interDistanceFrom(
    Iterator<double> source,
    Iterator<double> destination,
  ) => IteratorTogether.pairTake(
    source,
    destination,
    DoubleExtension.reduceMinus,
  );

  static Iterable<double> interDistanceHalfTo(
    Iterator<double> destination,
    Iterator<double> source,
  ) => IteratorTogether.pairTake(
    destination,
    source,
    DoubleExtension.reduceMinusThenHalf,
  );

  static Iterable<double> interDistanceHalfFrom(
    Iterator<double> source,
    Iterator<double> destination,
  ) => IteratorTogether.pairTake(
    source,
    destination,
    DoubleExtension.reduceMinusThenHalf,
  );

  static double interDistanceCumulate(Iterator<double> a, Iterator<double> b) =>
      IteratorTogether.interReduce(
        a,
        b,
        DoubleExtension.reduceMinus,
        DoubleExtension.reducePlus,
      );
}

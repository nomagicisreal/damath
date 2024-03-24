///
///
/// this file contains:
///
/// [ComparableData]
///
/// [DurationFR]
///
/// [Operator]
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
part of damath_experiment;

///
///
///
mixin ComparableData<C extends Comparable, D extends ComparableData<C, D>>
    implements Comparable<D> {
  bool operator >(D other) => Comparable.compare(this, other) == 1;

  bool operator <(D other) => Comparable.compare(this, other) == -1;
}

///
///
class DurationFR {
  final Duration forward;
  final Duration reverse;

  const DurationFR(this.forward, this.reverse);

  const DurationFR.constant(Duration duration)
      : forward = duration,
        reverse = duration;

  ///
  ///
  /// constants
  ///
  ///
  static const DurationFR zero = DurationFR.constant(Duration.zero);
  static const milli100 = DurationFR.constant(KMath.durationMilli100);
  static const milli300 = DurationFR.constant(KMath.durationMilli300);
  static const milli500 = DurationFR.constant(KMath.durationMilli500);
  static const milli800 = DurationFR.constant(KMath.durationMilli800);
  static const second1 = DurationFR.constant(KMath.durationSecond1);
  static const second2 = DurationFR.constant(KMath.durationSecond2);
  static const second3 = DurationFR.constant(KMath.durationSecond3);
  static const second4 = DurationFR.constant(KMath.durationSecond4);
  static const second5 = DurationFR.constant(KMath.durationSecond5);
  static const second6 = DurationFR.constant(KMath.durationSecond6);
  static const second7 = DurationFR.constant(KMath.durationSecond7);
  static const second8 = DurationFR.constant(KMath.durationSecond8);
  static const second9 = DurationFR.constant(KMath.durationSecond9);
  static const second10 = DurationFR.constant(KMath.durationSecond10);
  static const min1 = DurationFR.constant(KMath.durationMin1);

  ///
  ///
  /// implementation for [Object]
  ///
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
///
enum Operator {
  plus,
  minus,
  multiply,
  divide,
  modulus;

  @override
  String toString() => switch (this) {
        Operator.plus => '+',
        Operator.minus => '-',
        Operator.multiply => '*',
        Operator.divide => '/',
        Operator.modulus => '%',
      };

  String get latex => switch (this) {
        Operator.plus => r'+',
        Operator.minus => r'-',
        Operator.multiply => r'\times',
        Operator.divide => r'\div',
        Operator.modulus => throw UnimplementedError(),
      };

  ///
  /// latex operation
  ///
  String latexOperationOf(String a, String b) => "$a $latex $b";

  String latexOperationOfDouble(double a, double b, {int fix = 0}) =>
      "${a.toStringAsFixed(fix)} "
      "$latex "
      "${b.toStringAsFixed(fix)}";

  ///
  /// operate value
  ///
  double operateDouble(double a, double b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        Operator.multiply => a * b,
        Operator.divide => a / b,
        Operator.modulus => a % b,
      };

  static double operateDoubleAll(
    double value,
    Iterable<MapEntry<Operator, double>> operations,
  ) =>
      operations.fold(
        value,
        (a, operation) => switch (operation.key) {
          Operator.plus => a + operation.value,
          Operator.minus => a - operation.value,
          Operator.multiply => a * operation.value,
          Operator.divide => a / operation.value,
          Operator.modulus => a % operation.value,
        },
      );

  Duration operateDuration(Duration a, Duration b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        _ => throw UnimplementedError(),
      };

  DurationFR operateDurationFR(DurationFR a, DurationFR b) => switch (this) {
        Operator.plus =>
          DurationFR(a.forward + b.forward, a.reverse + b.reverse),
        Operator.minus =>
          DurationFR(a.forward - b.forward, a.reverse - b.reverse),
        _ => throw UnimplementedError(),
      };

  T operationOf<T>(T a, T b) => switch (a) {
        double _ => operateDouble(a, b as double),
        Duration _ => operateDuration(a, b as Duration),
        DurationFR _ => operateDurationFR(a, b as DurationFR),
        _ => throw UnimplementedError(),
      } as T;

  ///
  /// mapper
  ///
  Applier<double> doubleMapperOf(double value) => switch (this) {
        Operator.plus => (a) => a + value,
        Operator.minus => (a) => a - value,
        Operator.multiply => (a) => a * value,
        Operator.divide => (a) => a / value,
        Operator.modulus => (a) => a % value,
      };
}

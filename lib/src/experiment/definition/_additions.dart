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
/// [Vector3D]
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

  static const DurationFR zero = DurationFR.constant(Duration.zero);

  DurationFR operator ~/(int value) =>
      DurationFR(forward ~/ value, reverse ~/ value);

  DurationFR operator +(Duration value) =>
      DurationFR(forward + value, reverse + value);

  DurationFR operator -(Duration value) =>
      DurationFR(forward - value, reverse - value);

  @override
  int get hashCode => Object.hash(forward, reverse);

  @override
  bool operator ==(covariant DurationFR other) => hashCode == other.hashCode;

  @override
  String toString() => 'DurationFR(forward: $forward, reverse:$reverse)';

  ///
  /// constants
  ///

  static const milli100 = DurationFR.constant(KDuration.milli100);
  static const milli300 = DurationFR.constant(KDuration.milli300);
  static const milli500 = DurationFR.constant(KDuration.milli500);
  static const milli800 = DurationFR.constant(KDuration.milli800);
  static const milli1500 = DurationFR.constant(KDuration.milli1500);
  static const milli2500 = DurationFR.constant(KDuration.milli2500);
  static const second1 = DurationFR.constant(KDuration.second1);
  static const second2 = DurationFR.constant(KDuration.second2);
  static const second3 = DurationFR.constant(KDuration.second3);
  static const second4 = DurationFR.constant(KDuration.second4);
  static const second5 = DurationFR.constant(KDuration.second5);
  static const second6 = DurationFR.constant(KDuration.second6);
  static const second7 = DurationFR.constant(KDuration.second7);
  static const second8 = DurationFR.constant(KDuration.second8);
  static const second9 = DurationFR.constant(KDuration.second9);
  static const second10 = DurationFR.constant(KDuration.second10);
  static const second20 = DurationFR.constant(KDuration.second20);
  static const second30 = DurationFR.constant(KDuration.second30);
  static const min1 = DurationFR.constant(KDuration.min1);
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

  Mapper<double> doubleMapperOf(double value) => switch (this) {
        Operator.plus => (a) => a + value,
        Operator.minus => (a) => a - value,
        Operator.multiply => (a) => a * value,
        Operator.divide => (a) => a / value,
        Operator.modulus => (a) => a % value,
      };
}

extension Space3RadianExtension on Space3Radian {
  List<Direction3DIn6> get visibleFaces {
    throw UnimplementedError();
  }
}

///
///
///
/// [Vector3D]
///
///
///

//
class Vector3D {
  final Space3Radian direction;
  final double distance;

  const Vector3D(this.direction, this.distance);

  Space2 get toCoordinate2D => Space2.fromDirection(-direction.dy, distance);

  Space3 get toCoordinate => Space3.fromDirection(
    direction,
    distance,
  );

  Vector3D rotated(Space3Radian d) => Vector3D(direction + d, distance);

  @override
  String toString() => "Vector($direction, $distance)";

  static Vector3D lerp(Vector3D begin, Vector3D end, double t) => Vector3D(
    begin.direction + (end.direction - begin.direction) * t,
    begin.distance + (end.distance - begin.distance) * t,
  );

  static Translator<double, Vector3D> lerpOf(Vector3D begin, Vector3D end) {
    final direction = end.direction - begin.direction;
    final distance = end.distance - begin.distance;
    final directionOf = FMapper.lerp<Space3Radian>(
      begin.direction,
      end.direction,
          (t) => direction * t,
    );
    final distanceOf = FMapper.lerp<double>(
      begin.distance,
      end.distance,
          (t) => distance * t,
    );
    return (t) => Vector3D(directionOf(t), distanceOf(t));
  }
}


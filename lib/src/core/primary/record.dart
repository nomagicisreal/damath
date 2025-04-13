///
///
/// this file contains:
///
/// [Record2]
/// [RecordDouble2]
/// [RecordDouble3]
///
///
///
///
///
///
part of '../core.dart';

///
///
/// static methods:
/// [mix], ...
/// [compareNumOn1], ...
///
/// instance methods:
/// [join]
/// [isRelationBetween], ...
///
///
extension Record2<A, B> on (A, B) {
  ///
  /// [mix], [mixReverse]
  ///
  static (A, B) mix<A, B>(A a, B b) => (a, b);

  static (B, A) mixReverse<A, B>(A a, B b) => (b, a);

  ///
  /// [compareNumOn1]
  /// [compareNumOn2]
  /// [compareDurationOn2]
  /// [compareDurationOn1]
  ///
  static int compareNumOn1<N extends num, T>((N, T) a, (N, T) b) =>
      a.$1.compareTo(b.$1);

  static int compareNumOn2<T, N extends num>((T, N) a, (T, N) b) =>
      a.$2.compareTo(b.$2);

  static int compareDurationOn2<K>((K, Duration) a, (K, Duration) b) =>
      a.$2.compareTo(b.$2);

  static int compareDurationOn1<V>((Duration, V) a, (Duration, V) b) =>
      a.$1.compareTo(b.$1);

  ///
  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  ///

  ///
  ///
  ///
  String join([String separator = '']) => '${$1}$separator${$2}';

  ///
  /// [isRelationBetween]
  ///
  bool isRelationBetween(Iterable<A> a, Iterable<B> b) =>
      a.contains($1) && b.contains($2);
}

///
///
/// static methods
/// [maxDirection], ...
///
/// instance methods:
/// [toStringAsFixed], ...
/// [direction], ...
///
///
///
extension RecordDouble2 on (double, double) {
  ///
  /// static methods
  ///
  static (double, double) maxDirection(
    (double, double) a,
    (double, double) b,
  ) =>
      a.direction > b.direction ? a : b;

  static (double, double) minDirection(
    (double, double) a,
    (double, double) b,
  ) =>
      a.direction < b.direction ? a : b;

  ///
  /// [toStringAsFixed]
  /// [distance]
  /// [direction], [directionTo], [rotate]
  ///
  String toStringAsFixed(int digit) =>
      '(${$1.toStringAsFixed(digit)}, ${$2.toStringAsFixed(digit)})';

  double get distance => math.sqrt($1 * $1 + $2 * $2);

  double get direction => math.atan2($2, $1);

  double directionTo((double, double) p) => p.direction - direction;

  (double, double) rotate(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c - $2 * s, $1 * s + $2 * c);
  }
}

///
///
/// static methods
/// [maxAzimuthal], ...
///
/// instance methods:
/// [toStringAsFixed], ...
/// [direction], ...
///
///
extension RecordDouble3 on (double, double, double) {
  ///
  ///
  ///
  ///
  /// static methods
  ///
  ///
  ///
  ///
  ///

  ///
  /// [maxAzimuthal], [minAzimuthal]
  /// [maxPolar], [minPolar]
  ///
  static (double, double, double) maxAzimuthal(
    (double, double, double) a,
    (double, double, double) b,
  ) =>
      a.directionAzimuthal > b.directionAzimuthal ? a : b;

  static (double, double, double) minAzimuthal(
    (double, double, double) a,
    (double, double, double) b,
  ) =>
      a.directionAzimuthal < b.directionAzimuthal ? a : b;

  static (double, double, double) maxPolar(
    (double, double, double) a,
    (double, double, double) b,
  ) =>
      a.directionPolar > b.directionPolar ? a : b;

  static (double, double, double) minPolar(
    (double, double, double) a,
    (double, double, double) b,
  ) =>
      a.directionPolar < b.directionPolar ? a : b;

  ///
  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  ///

  ///
  /// [toStringAsFixed]
  ///
  String toStringAsFixed(int digit) => '(${$1.toStringAsFixed(digit)}, '
      '${$2.toStringAsFixed(digit)}, ${$3.toStringAsFixed(digit)})';

  ///
  /// [distance]
  /// [direction], [directionAzimuthal], [directionPolar]
  ///
  double get distance => math.sqrt($1 * $1 + $2 * $2 + $3 * $3);

  (double, double) get direction => (directionAzimuthal, directionPolar);

  double get directionAzimuthal => math.atan2($2, $1);

  double get directionPolar => math.acos($3 / distance);

  ///
  /// [rotate]
  /// [rotateX], [rotateY], [rotateZ]
  ///
  (double, double, double) rotate(double azimuthal, double polar) {
    final distance = this.distance;
    final rA = math.atan2($2, $1) + azimuthal;
    final rP = math.acos($3 / distance) + polar;

    final distanceXY = distance * math.sin(rP);
    return (
      distanceXY * math.cos(rA),
      distanceXY * math.sin(rA),
      distance * math.cos(rP),
    );
  }

  (double, double, double) rotateX(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1, $2 * c - $3 * s, $2 * s + $3 * c);
  }

  (double, double, double) rotateY(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c + $3 * s, $2, $3 * c * c - $1 * s);
  }

  (double, double, double) rotateZ(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c + $2 * s, $1 * s + $2 * c, $3);
  }
}

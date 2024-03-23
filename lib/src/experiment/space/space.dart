///
///
/// this file contains:
///
/// [Space]
///   [SpaceRadian]
///     [Radian2]
///     [Radian3]
///
///   [SpacePoint]
///     [Points2]
///     [Points3]
///
///
///
/// [Spherical]
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
// ignore_for_file: constant_identifier_names

///
///
/// [Space] is similar to [Tensor]
///
///
abstract interface class Space {
  const Space();

  @override
  int get hashCode;

  @override
  bool operator ==(covariant Space other);

  @override
  String toString() => toStringAsFixed(1);

  String toStringAsFixed(int digit);

  bool get isFinite;

  bool get isInfinite;

  bool get isPositive;

  bool get isNegative;

  Space operator -();

  Space operator +(Space other);

  Space operator -(Space other);

  Space operator *(double operand);

  Space operator /(double operand);

  Space operator %(double operand);

  Space operator ~/(double operand);

  bool operator <(Space other);

  bool operator >(Space other);

  bool operator <=(Space other);

  bool operator >=(Space other);
}

///
/// normally, 'positive radian' means counterclockwise in mathematical discussion,
///
/// [angle_1], ... (constants)
/// [isFinite], ... (implementation for [Space])
///
/// [cos], ... (getters)
/// [azimuthalIn], ... (methods)
///
abstract interface class SpaceRadian<R> implements Space {
  final double rAzimuthal;

  const SpaceRadian(this.rAzimuthal);

  ///
  ///
  /// constants
  ///
  ///
  static const angle_1 = math.pi / 180;
  static const angle_5 = math.pi / 36;
  static const angle_10 = math.pi / 18;
  static const angle_15 = math.pi / 12;
  static const angle_20 = math.pi / 9;
  static const angle_30 = math.pi / 6;
  static const angle_40 = math.pi * 2 / 9;
  static const angle_45 = math.pi / 4;
  static const angle_50 = math.pi * 5 / 18;
  static const angle_60 = math.pi / 3;
  static const angle_70 = math.pi * 7 / 18;
  static const angle_75 = math.pi * 5 / 12;
  static const angle_80 = math.pi * 4 / 9;
  static const angle_85 = math.pi * 17 / 36;
  static const angle_90 = math.pi / 2;
  static const angle_120 = math.pi * 2 / 3;
  static const angle_135 = math.pi * 3 / 4;
  static const angle_150 = math.pi * 5 / 6;
  static const angle_180 = math.pi;
  static const angle_225 = math.pi * 5 / 4;
  static const angle_240 = math.pi * 4 / 3;
  static const angle_270 = math.pi * 3 / 2;
  static const angle_315 = math.pi * 7 / 4;
  static const angle_360 = math.pi * 2;
  static const angle_390 = math.pi * 13 / 6;
  static const angle_420 = math.pi * 7 / 3;
  static const angle_450 = math.pi * 5 / 2;

  ///
  ///
  /// implementation for [Space]
  ///
  ///
  @override
  bool operator <(covariant SpaceRadian other) => rAzimuthal < other.rAzimuthal;

  @override
  bool operator <=(covariant SpaceRadian other) =>
      rAzimuthal <= other.rAzimuthal;

  @override
  bool operator >(covariant SpaceRadian other) => rAzimuthal > other.rAzimuthal;

  @override
  bool operator >=(covariant SpaceRadian other) =>
      rAzimuthal >= other.rAzimuthal;

  @override
  bool get isFinite => rAzimuthal.isFinite;

  @override
  bool get isInfinite => rAzimuthal.isInfinite;

  @override
  bool get isNegative => rAzimuthal.isNegative;

  @override
  bool get isPositive => rAzimuthal.isPositive;

  ///
  ///
  /// getters
  ///
  ///

  ///
  /// [cos], [sin], [tan], [sec], [csc], [cot]
  /// [azimuthalOnRight], [azimuthalOnLeft], [azimuthalOnTop], [azimuthalOnBottom]
  ///
  double get cos => math.cos(rAzimuthal);

  double get sin => math.sin(rAzimuthal);

  double get tan => math.tan(rAzimuthal);

  double get sec => 1 / cos;

  double get csc => 1 / sin;

  double get cot => 1 / tan;

  bool get azimuthalOnRight => RotationUnit.radianIfWithinAngle90_90N(
      RotationUnit.radianModulus360Angle(rAzimuthal));

  bool get azimuthalOnLeft => RotationUnit.radianIfOverAngle90_90N(
      RotationUnit.radianModulus360Angle(rAzimuthal));

  bool get azimuthalOnTop => RotationUnit.radianIfWithinAngle0_180(
      RotationUnit.radianModulus360Angle(rAzimuthal));

  bool get azimuthalOnBottom => RotationUnit.radianIfWithinAngle0_180N(
      RotationUnit.radianModulus360Angle(rAzimuthal));

  ///
  ///
  /// methods
  ///
  ///

  ///
  /// [azimuthalIn]
  /// [azimuthalInQuadrant]
  ///
  bool azimuthalIn(double lower, double upper) =>
      rAzimuthal.rangeIn(lower, upper);

  bool azimuthalInQuadrant(int quadrant) {
    final r = RotationUnit.radianModulus360Angle(rAzimuthal);
    return switch (quadrant) {
      1 => r.within(0, SpaceRadian.angle_90) ||
          r.within(-SpaceRadian.angle_360, -SpaceRadian.angle_270),
      2 => r.within(SpaceRadian.angle_90, SpaceRadian.angle_180) ||
          r.within(-SpaceRadian.angle_270, -SpaceRadian.angle_180),
      3 => r.within(SpaceRadian.angle_180, SpaceRadian.angle_270) ||
          r.within(-SpaceRadian.angle_180, -SpaceRadian.angle_90),
      4 => r.within(SpaceRadian.angle_270, SpaceRadian.angle_360) ||
          r.within(-SpaceRadian.angle_90, 0),
      _ => throw DamathException('un defined quadrant: $quadrant for $this'),
    };
  }
}

///
///
/// [toStringAsFixed], ... (implementation for [Space])
///
/// [azimuthalOnRight], ... (getters)
/// [azimuthalInQuadrant], ... (methods)
///
///
class Radian2 extends SpaceRadian<double> {
  const Radian2(super.rAzimuthal);

  ///
  ///
  /// implementation for [Space]
  ///
  ///
  @override
  String toStringAsFixed(int digit) =>
      'Radian2(${rAzimuthal.toStringAsFixed(digit)})';

  @override
  Radian2 operator -() => Radian2(-rAzimuthal);

  @override
  Radian2 operator +(covariant Radian2 other) =>
      Radian2(rAzimuthal + other.rAzimuthal);

  @override
  Radian2 operator -(covariant Radian2 other) =>
      Radian2(rAzimuthal - other.rAzimuthal);

  @override
  Radian2 operator *(double operand) => Radian2(rAzimuthal * operand);

  @override
  Radian2 operator /(double operand) => Radian2(rAzimuthal / operand);

  @override
  Radian2 operator %(double operand) => Radian2(rAzimuthal % operand);

  @override
  Radian2 operator ~/(double operand) =>
      Radian2((rAzimuthal ~/ operand).toDouble());
}

///
///
/// [Radian3.polar1], ... (constructors)
/// [zero], ... (constants)
///
/// [toStringAsFixed], ...(implementations for [Space])
///
///
class Radian3 extends SpaceRadian<Radian3> {
  ///
  /// the rotation of [rPolar] ranges in 0 ~ π, start from [Direction3DIn6.top] to [Direction3DIn6.bottom]
  ///
  final double rPolar;

  ///
  ///
  /// constructor
  ///
  ///
  const Radian3(super.rAzimuthal, this.rPolar)
      : assert(rPolar >= 0 && rPolar <= SpaceRadian.angle_180);

  const Radian3.polar1(super.rAzimuthal) : rPolar = SpaceRadian.angle_1;

  const Radian3.polar10(super.rAzimuthal) : rPolar = SpaceRadian.angle_10;

  const Radian3.polar15(super.rAzimuthal) : rPolar = SpaceRadian.angle_15;

  const Radian3.polar30(super.rAzimuthal) : rPolar = SpaceRadian.angle_30;

  const Radian3.polar90(super.rAzimuthal) : rPolar = SpaceRadian.angle_90;

  const Radian3.polar180(super.rAzimuthal) : rPolar = SpaceRadian.angle_180;

  const Radian3.azimuthal1(double rPolar) : this(SpaceRadian.angle_1, rPolar);

  const Radian3.azimuthal10(double rPolar) : this(SpaceRadian.angle_10, rPolar);

  const Radian3.azimuthal15(double rPolar) : this(SpaceRadian.angle_15, rPolar);

  const Radian3.azimuthal30(double rPolar) : this(SpaceRadian.angle_30, rPolar);

  const Radian3.azimuthal90(double rPolar) : this(SpaceRadian.angle_90, rPolar);

  const Radian3.azimuthal180(double rPolar)
      : this(SpaceRadian.angle_180, rPolar);

  ///
  ///
  /// constants
  ///
  ///
  static const zero = Radian3(0, 0);

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  String toStringAsFixed(int digit) => 'Radian3('
      '${rAzimuthal.toStringAsFixed(digit)}, '
      '${rPolar.toStringAsFixed(digit)})';

  @override
  Radian3 operator -() => Radian3(-rAzimuthal, -rPolar);

  @override
  Radian3 operator +(covariant Radian3 other) =>
      Radian3(rAzimuthal + other.rAzimuthal, rPolar + other.rPolar);

  @override
  Radian3 operator -(covariant Radian3 other) =>
      Radian3(rAzimuthal - other.rAzimuthal, rPolar - other.rPolar);

  @override
  Radian3 operator *(double operand) => Radian3(rAzimuthal * operand, rPolar);

  @override
  Radian3 operator /(double operand) => Radian3(rAzimuthal / operand, rPolar);

  @override
  Radian3 operator %(double operand) => Radian3(rAzimuthal % operand, rPolar);

  @override
  Radian3 operator ~/(double operand) =>
      Radian3((rAzimuthal ~/ operand).toDouble(), rPolar);

  @override
  bool get isFinite => super.isFinite && rPolar.isFinite;

  @override
  bool get isInfinite => super.isInfinite && rPolar.isInfinite;

  @override
  bool get isNegative => super.isNegative && rPolar.isNegative;

  @override
  bool get isPositive => super.isPositive && rPolar.isPositive;

  ///
  ///
  ///
  Radian3 operator ^(double rPolar) =>
      Radian3(rAzimuthal, this.rPolar + rPolar);

  double get cosPhi => math.cos(rPolar);

  double get sinPhi => math.sin(rPolar);

}

///
/// [dx], [dy]
///
/// [SpacePoint.square], ...(constructors)
/// [maxDistance], ...(static methods)
///
/// [hasFinite], ...(getters)
/// [scale], ...(methods)
///
abstract class SpacePoint<R extends SpaceRadian> implements Space {
  final double dx;
  final double dy;

  ///
  ///
  /// constructors
  ///
  ///
  const SpacePoint(this.dx, this.dy);

  const SpacePoint.square(double value) : this(value, value);

  const SpacePoint.ofX(double dx) : this(dx, 0);

  const SpacePoint.ofY(double dy) : this(0, dy);

  ///
  ///
  /// static methods
  ///
  ///
  static S maxDistance<S extends SpacePoint>(S a, S b) =>
      a.distance > b.distance ? a : b;

  static S maxDirection<S extends SpacePoint>(S a, S b) =>
      a.direction > b.direction ? a : b;

  static S minDistance<S extends SpacePoint>(S a, S b) =>
      a.distance < b.distance ? a : b;

  static S minDirection<S extends SpacePoint>(S a, S b) =>
      a.direction < b.direction ? a : b;

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  bool operator <(covariant SpacePoint other) => dx < other.dx && dy < other.dy;

  @override
  bool operator <=(covariant SpacePoint other) =>
      dx <= other.dx && dy <= other.dy;

  @override
  bool operator >(covariant SpacePoint other) => dx > other.dx && dy > other.dy;

  @override
  bool operator >=(covariant SpacePoint other) =>
      dx >= other.dx && dy >= other.dy;

  @override
  bool operator ==(covariant SpacePoint other) => hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(dx, dy);

  @override
  bool get isFinite => dx.isFinite && dy.isFinite;

  @override
  bool get isInfinite => dx.isInfinite && dy.isInfinite;

  @override
  bool get isPositive => dx.isPositive && dy.isPositive;

  @override
  bool get isNegative => dx.isNegative && dy.isNegative;

  ///
  ///
  /// getters
  ///
  ///

  ///
  /// [hasFinite], [hasInfinite], [hasNegative], [hasPositive]
  /// [distance], [volume]
  /// [abs], [roundup], [unit]
  ///
  bool get hasFinite => dx.isFinite || dy.isFinite;

  bool get hasInfinite => dx.isInfinite || dy.isInfinite;

  bool get hasNegative => dx.isNegative || dy.isNegative;

  bool get hasPositive => dx.isPositive || dy.isPositive;

  double get volume => dx * dy;

  double get distance => math.sqrt(dx * dx + dy * dy);

  Space get abs;

  Space get roundup;

  Space get unit;

  ///
  ///
  /// methods
  ///
  ///

  ///
  /// [scale], [translate]
  /// [distanceTo], [distanceHalfTo]
  /// [middleTo],
  ///
  Space scale(Space s);

  Space translate(Space t);

  double distanceTo(Space p);

  double distanceHalfTo(Space p);

  Space middleTo(Space p);

  ///
  /// [direction]
  /// [radianTo], [directionTo]
  /// [rotate]
  ///
  R get direction;

  R directionTo(SpacePoint p);

  R radianTo(SpacePoint p);

  SpacePoint rotate(R radian);
}

///
///
/// [Space2.square], ... (constructor)
/// [zero], ... (constants)
///
/// [toStringAsFixed], ...(implementations for [Space])
/// [distanceTo], ...(implementations for [SpacePoint])
/// [direction], ...(implementations for [_SpaceDirectable2])
///
///
class Points2 extends SpacePoint<Radian2> {
  ///
  ///
  /// constructors
  ///
  ///
  const Points2(super.dx, super.dy);

  const Points2.square(super.value) : super.square();

  const Points2.ofX(super.dx) : super.ofX();

  const Points2.ofY(super.dy) : super.ofY();

  Points2.fromDirection(double direction, [double distance = 1])
      : super(
          distance * math.cos(direction),
          distance * math.sin(direction),
        );

  /// see also [Points2.direction]
  ///

  ///
  ///
  /// constants
  ///
  ///
  static const Points2 zero = Points2(0.0, 0.0);
  static const Points2 one = Points2(1.0, 1.0);

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  String toStringAsFixed(int digit) =>
      'Space2(${dx.toStringAsFixed(digit)}, ${dy.toStringAsFixed(digit)})';

  @override
  Points2 operator -() => Points2(-dx, -dy);

  @override
  Points2 operator +(covariant Points2 other) =>
      Points2(dx + other.dx, dy + other.dy);

  @override
  Points2 operator -(covariant Points2 other) =>
      Points2(dx - other.dx, dy - other.dy);

  @override
  Points2 operator *(double operand) => Points2(dx * operand, dy * operand);

  @override
  Points2 operator /(double operand) => Points2(dx / operand, dy / operand);

  @override
  Points2 operator %(double operand) => Points2(dx % operand, dy % operand);

  @override
  Points2 operator ~/(double operand) =>
      Points2((dx ~/ operand).toDouble(), (dy ~/ operand).toDouble());

  @override
  Points2 scale(covariant Points2 s) => Points2(dx * s.dx, dy * s.dy);

  @override
  Points2 translate(covariant Points2 t) => Points2(dx + t.dx, dy + t.dy);

  @override
  Space get abs => Points2(dx.abs(), dy.abs());

  @override
  Points2 get roundup => Points2(dx.roundToDouble(), dy.roundToDouble());

  @override
  Points2 get unit => this / distance;

  ///
  ///
  /// implementation for [SpacePoint]
  ///
  ///
  @override
  double distanceTo(covariant Points2 p) => (p - this).distance;

  @override
  double distanceHalfTo(covariant Points2 p) => (p - this).distance / 2;

  @override
  Points2 middleTo(covariant Points2 p) => (p + this) / 2;

  ///
  ///
  /// implementation for [_SpaceDirectable2]
  ///
  ///

  ///
  /// the rotation of [Space2.fromDirection], [Points2.direction], [Points2.rotate] follows:
  /// the axis [Direction3DIn6.back] -> [Direction3DIn6.front], and its start from [Direction3DIn6.right]; thus,
  /// [direction] = atan2(dy, dx).
  ///
  /// the code belows prove the execution time of '[rotate] by matrix' is less than 'rotate by [direction]'
  /// ```
  /// double angleOf(MapEntry<double, double> entry) =>
  ///     Radian.angleOf(atan2(entry.value, entry.key)).roundToDouble();
  ///
  /// double rotateByDirection(MapEntry<double, double> p) {
  ///   MapEntry<double, double> from(double direction) =>
  ///       MapEntry(cos(direction), sin(direction));
  ///
  ///   for (var i = 0; i < 1e8; i++) {
  ///     p = from(atan2(p.value, p.key) + Radian.angle_10);
  ///   }
  ///   return angleOf(p);
  /// }
  ///
  /// double rotateByMatrix(MapEntry<double, double> p) {
  ///   MapEntry<double, double> from(double dx, double dy, double rotation) {
  ///     final c = cos(rotation);
  ///     final s = sin(rotation);
  ///     return MapEntry(dx * c - dy * s, dx * s + dy * c);
  ///   }
  ///
  ///   for (var i = 0; i < 1e8; i++) {
  ///     p = from(p.key, p.value, Radian.angle_10);
  ///   }
  ///   return angleOf(p);
  /// }
  ///
  /// final watch = Stopwatch();
  /// final entry = MapEntry(sqrt(3), sqrt(4));
  ///
  /// watch.start();
  /// print('by matrix: ${rotateByMatrix(entry)}------${watch.elapsed}'); // -31.0------0:00:00.763498
  /// watch.reset();
  /// watch.start();
  /// print('by direct: ${rotateByDirection(entry)}------${watch.elapsed}'); // -31.0------0:00:04.573989
  /// watch.reset();
  /// ```
  ///
  /// When the rotation begin,
  ///   the vector parallel to x axis projects on both x axis and y axis.      ( cos, sin)
  ///   the vector parallel to y axis projects on both x axis and y axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos, -sin ] [ dx ]
  ///     [ sin,  cos ] [ dy ]
  ///
  /// To rotate a 2d vector, it's necessary to rotate the vector parallel all the axis:
  /// [Points2.rotate] needs to implement full matrix multiplication:
  ///   [Points2.dx] = [dx] * cos(radian) - [dy] * sin(radian);
  ///   [Points2.dy] = [dx] * sin(radian) + [dy] * cos(radian);
  ///
  /// To create a 2d vector, it's sufficient to take (d, 0) as a unit vector:
  /// [Points2.fromDirection] can only implement part of matrix multiplication:
  ///   [Points2.dx] = d * cos(radian); // 0 * sin(radian) = 0
  ///   [Points2.dy] = d * sin(radian); // 0 * cos(radian) = 0
  ///
  @override
  Radian2 get direction => Radian2(math.atan2(dy, dx));

  @override
  Radian2 directionTo(covariant Points2 p) => (p - this).direction;

  @override
  Radian2 radianTo(covariant Points2 p) => p.direction - direction;

  @override
  Points2 rotate(covariant Radian2 radian) {
    final c = radian.cos;
    final s = radian.sin;
    return Points2(dx * c - dy * s, dx * s + dy * c);
  }
}

///
/// notice that the translation of [Points3] follows the axis by [double.infinity] -> [double.negativeInfinity],
/// which means:
///   [Points3.dx] is getting bigger to [Direction3DIn6.back], getting lower to [Direction3DIn6.front]
///   [Points3.dy] is getting bigger to [Direction3DIn6.right], getting lower to [Direction3DIn6.left],
///   [Points3.dz] is getting bigger to [Direction3DIn6.top], getting lower to [Direction3DIn6.bottom]
/// see also [Points3.rotate], [Space3.fromDirection] for direction
///
///
/// [Points3.cube], ... (constructor)
/// [Points3.fromDirection], ... (factories)
/// [zero], ... (constants)
///
/// [toStringAsFixed], ...(implementations for [Space])
/// [distanceTo], ...(implementations for [SpacePoint])
///
/// [withoutXY], ... (getters)
/// [rotateX], ... (methods)
///
///
class Points3 extends SpacePoint<Radian3> {
  final double dz;

  ///
  ///
  /// constructors
  ///
  ///
  const Points3(super.dx, super.dy, this.dz);

  const Points3.ofX(super.dx)
      : dz = 0,
        super.ofX();

  const Points3.ofY(super.dy)
      : dz = 0,
        super.ofY();

  const Points3.ofZ(this.dz) : super.square(0);

  const Points3.cube(super.value)
      : dz = value,
        super.square();

  const Points3.ofXY(super.value)
      : dz = 0,
        super.square();

  const Points3.ofYZ(double value)
      : dz = value,
        super(0, value);

  const Points3.ofXZ(double value)
      : dz = value,
        super(value, 0);

  ///
  ///
  /// factories
  ///
  ///
  factory Points3.fromDirection(Radian3 direction, [double distance = 1]) {
    final s = direction.sinPhi * distance;
    return Points3(
      s * direction.cos,
      s * direction.sin,
      direction.cosPhi * distance,
    );
  }

  ///
  ///
  /// constants
  ///
  ///
  static const Points3 zero = Points3.cube(0);
  static const Points3 one = Points3.cube(1);
  static const Points3 x1 = Points3.ofX(1);
  static const Points3 y1 = Points3.ofY(1);
  static const Points3 z1 = Points3.ofZ(1);

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  String toStringAsFixed(int digit) => 'Space3('
      '${dx.toStringAsFixed(digit)}, '
      '${dy.toStringAsFixed(digit)}, '
      '${dz.toStringAsFixed(digit)})';

  @override
  Points3 operator -() => Points3(-dx, -dy, -dz);

  @override
  Points3 operator +(covariant Points3 other) =>
      Points3(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Points3 operator -(covariant Points3 other) =>
      Points3(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Points3 operator *(double operand) =>
      Points3(dx * operand, dy * operand, dz * operand);

  @override
  Points3 operator /(double operand) =>
      Points3(dx / operand, dy / operand, dz / operand);

  @override
  Points3 operator %(double operand) =>
      Points3(dx % operand, dy % operand, dz % operand);

  ///
  ///
  /// implementations for [SpacePoint]
  ///
  ///
  @override
  bool operator <(covariant Points3 other) => super < other && dz < other.dz;

  @override
  bool operator >(covariant Points3 other) => super > other && dz > other.dz;

  @override
  bool operator <=(covariant Points3 other) => super <= other && dz <= other.dz;

  @override
  bool operator >=(covariant Points3 other) => super >= other && dz >= other.dz;

  @override
  bool operator ==(covariant Points3 other) => super == other && dz == other.dz;

  @override
  int get hashCode => Object.hash(dx, dy, dz);

  @override
  Points3 operator ~/(double operand) => Points3(
        (dx ~/ operand).toDouble(),
        (dy ~/ operand).toDouble(),
        (dz ~/ operand).toDouble(),
      );

  @override
  Points3 scale(covariant Points3 s) =>
      Points3(dx * s.dx, dy * s.dy, dz * s.dz);

  @override
  Points3 translate(covariant Points3 t) =>
      Points3(dx + t.dx, dy + t.dy, dz + t.dz);

  @override
  Points3 get abs => Points3(dx.abs(), dy.abs(), dz.abs());

  @override
  Points3 get roundup =>
      Points3(dx.roundToDouble(), dy.roundToDouble(), dz.roundToDouble());

  @override
  Points3 get unit => this / distance;

  ///
  ///
  /// implementations for [SpacePoint]
  ///
  ///
  @override
  bool get isFinite => super.isFinite && dz.isFinite;

  @override
  bool get isInfinite => super.isInfinite && dz.isInfinite;

  @override
  bool get isPositive => super.isPositive && dz.isPositive;

  @override
  bool get isNegative => super.isNegative && dz.isNegative;

  @override
  bool get hasFinite => super.hasFinite || dz.isFinite;

  @override
  bool get hasInfinite => super.hasInfinite || dz.isInfinite;

  @override
  bool get hasPositive => super.hasPositive || dz.isPositive;

  @override
  bool get hasNegative => super.hasNegative || dz.isNegative;

  @override
  double get distance => math.sqrt(dx.squared + dy.squared + dz.squared);

  @override
  double get volume => super.volume * dz;

  @override
  double distanceTo(covariant Points3 p) => (p - this).distance;

  @override
  double distanceHalfTo(covariant Points3 p) => (p - this).distance / 2;

  @override
  Points3 middleTo(covariant Points3 p) => (p - this) / 2;

  ///
  /// spherical coordinates:
  ///   r^2 = x^2 + 𝑦^2 + 𝑧^2
  ///   θ = atan(dy/dx)
  ///   φ = acos(dz/ r)
  /// that is, [direction] = (θ, φ)
  ///
  @override
  Radian3 get direction =>
      Radian3(math.atan2(dy, dx), math.acos(dz / distance));

  @override
  Radian3 radianTo(covariant Points3 p) => p.direction - direction;

  @override
  Radian3 directionTo(covariant Points3 p) => (p - this).direction;

  ///
  /// let [dx], [dy], [dz] represent the [Points3] properties before [rotate] finished.
  /// let [Points3.dx], [Points3.dy], [Points3.dz] represent the result of [rotate].
  /// let rP, rA represent the origin state of polar and azimuthal.
  /// let rP', rA' represent the [radian] rotation of polar and azimuthal.
  /// which means "rP + rP'", "rA + rA'" are the rotated rotation of polar and azimuthal.
  ///
  /// when rA' grows,
  ///     [ cos(rA'), -sin(rA') ] [ dx ]
  ///     [ sin(rA'),  cos(rA') ] [ dy ]
  ///
  /// when rP' grows from 0 ~ π,
  ///   the vector can be separate into the one that parallel to z axis, and the one that parallel to xy plane.
  ///   the one that parallel to z axis directly effect the result [Points3.dz] without consideration of rA'.
  ///   [Points3.dz] = cos(rP + rP')
  ///
  ///   the one that parallel to xy plane projects a positive distance on xy plane, sin(rP + rP'),
  ///   which is also [Points3.dx] * sec(rA + rA'), [Points3.dy] * csc(rA + rA').
  ///   [Points3.dx] = sin(rP + rP') / sec(rA + rA')
  ///   [Points3.dx] = sin(rP + rP') / csc(rA + rA')
  ///
  /// the direct way to compute is to calculating rP + rP', rA + rA' to get the result,
  /// but it's not the best way to do so;
  /// that's the reason why [Points2.rotate] not invoke [Points2.fromDirection]
  ///
  @override
  Points3 rotate(covariant Radian3 radian) {
    // ?
    return Points3.fromDirection(direction + radian, distance);
  }

  ///
  ///
  /// getters
  ///
  ///

  ///
  /// [withoutXY], [withoutYZ], [withoutXZ]
  /// [retainXY]
  /// [retainYZAsXY], [retainXZAsXY], [retainYZAsYX], [retainXZAsYX]
  ///
  bool get withoutXY => dx == 0 && dy == 0;

  bool get withoutYZ => dy == 0 && dz == 0;

  bool get withoutXZ => dx == 0 && dz == 0;

  Points3 get retainXY => Points3(dx, dy, 0);

  Points3 get retainYZAsXY => Points3(dy, dz, 0);

  Points3 get retainXZAsXY => Points3(dx, dz, 0);

  Points3 get retainYZAsYX => Points3(dz, dy, 0);

  Points3 get retainXZAsYX => Points3(dz, dx, 0);

  ///
  ///
  /// methods
  ///
  ///

  ///
  /// the rotation of [Points3] follows:
  ///   z axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom], radian start from [Direction3DIn6.right]
  ///   y axis is [Direction3DIn6.right] -> [Direction3DIn6.left], radian start from [Direction3DIn6.front]
  ///   x axis is [Direction3DIn6.back] -> [Direction3DIn6.front], radian start from [Direction3DIn6.top], thus,
  ///
  /// When rotate on x axis,
  ///   the vector parallel to y axis will project on both y axis and z axis.      ( cos, sin)
  ///   the vector parallel to z axis will project on both y axis and z axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [  1,   0,   0 ]  [ dx ]
  ///     [  0, cos,-sin ]  [ dy ]
  ///     [  0, sin, cos ]  [ dz ]
  /// When rotate on y axis,
  ///   the vector parallel to x axis will project on both x axis and z axis.      ( cos,-sin)
  ///   the vector parallel to z axis will project on both x axis and z axis, too. ( sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,  0, sin ]  [ dx ]
  ///     [  0,   1,   0 ]  [ dy ]
  ///     [-sin,  0, cos ]  [ dz ]
  /// When rotate on z axis,
  ///   the vector parallel to x axis will project on both x axis and y axis.      ( cos, sin)
  ///   the vector parallel to y axis will project on both x axis and y axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,-sin,  0 ]  [ dx ]
  ///     [ sin, cos,  0 ]  [ dy ]
  ///     [  0,    0,  1 ]  [ dz ]
  /// because the priority of rotations on x axis, y axis, z axis influence each other,
  /// it better not to rotate by them all together at [Points3.rotate].
  ///   [rotateX] do the rotation only for x axis:
  ///     [Points3.dx] = [dx]
  ///     [Points3.dy] = [dy] * cos(rx) - [dz] * sin(rx)
  ///     [Points3.dz] = [dy] * sin(rx) + [dz] * cos(rx)
  ///   [rotateY] do the rotation only for y axis:
  ///     [Points3.dx] = [dx] * cos(ry) + [dz] * sin(ry)
  ///     [Points3.dy] = [dy]
  ///     [Points3.dz] = [dz] * cos(ry) - [dx] * sin(ry)
  ///   [rotateZ] do the rotation only for z axis:
  ///     [Points3.dx] = [dx] * cos(rz) - [dy] * sin(rz)
  ///     [Points3.dy] = [dx] * sin(rz) + [dy] * cos(rz)
  ///     [Points3.dz] = [dz]
  ///
  ///
  Points3 rotateX(Radian2 radian) {
    final c = radian.cos;
    final s = radian.sin;
    return Points3(dx, dy * c - dz * s, dy * s + dz * c);
  }

  Points3 rotateY(Radian2 radian) {
    final c = radian.cos;
    final s = radian.sin;
    return Points3(dx * c + dz * s, dy, dz * c * c - dx * s);
  }

  Points3 rotateZ(Radian2 radian) {
    final c = radian.cos;
    final s = radian.sin;
    return Points3(dx * c + dy * s, dx * s + dy * c, dz);
  }
}


///
///
///
///
class Spherical {
  final Radian3 direction;
  final double distance;

  const Spherical(this.direction, this.distance);

  Points2 get toSpace2 => Points2.fromDirection(direction.rAzimuthal, distance);

  Points3 get toSpace3 => Points3.fromDirection(direction, distance);

  Spherical rotated(Radian3 d) => Spherical(direction + d, distance);

  @override
  String toString() =>
      "Spherical(${direction.rAzimuthal}, ${direction.rPolar}, $distance)";

  static Spherical lerp(Spherical begin, Spherical end, double t) => Spherical(
    begin.direction + (end.direction - begin.direction) * t,
    begin.distance + (end.distance - begin.distance) * t,
  );

  static Translator<double, Spherical> lerpOf(Spherical begin, Spherical end) {
    final direction = end.direction - begin.direction;
    final distance = end.distance - begin.distance;
    return (t) => Spherical(direction * t, distance * t);
  }
}

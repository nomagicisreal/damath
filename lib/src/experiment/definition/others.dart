///
///
/// this file contains:
///
///
/// [Radian]
///
/// [Space2]
/// [Space3]
/// [Space3Radian]
///
/// [Direction]
///   [Direction2D]
///     [Direction2DIn4]
///     [Direction2DIn8]
///   [Direction3D]
///     [Direction3DIn6]
///     [Direction3DIn14]
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
/// normally, 'positive radian' means counterclockwise in mathematical discussion,
/// but means clockwise for flutter [Transform] widget and [Offset.direction], [Matrix4] class...
/// See also [Direction], and the comment above [Coordinate.fromDirection]
///
/// [angle_001], [angle_01], ...
/// [radianFromAngle], [radianFromRound], ...
/// [complementaryOf], [supplementaryOf], ...
///
/// [ifWithinAngle90_90N], [ifOverAngle90_90N], ...
/// [ifInQuadrant1], [ifInQuadrant2], [ifInQuadrant3], [ifInQuadrant4]
/// [ifOnRight], [ifOnLeft], [ifOnTop], [ifOnBottom]
///
class Radian {
  final double value;

  const Radian(this.value);

  Radian.fromAngle(double angle) : value = radianFromAngle(angle);

  Radian.fromRound(double round) : value = radianFromAngle(round);

  static const angle_001 = angle_1 * 0.01;
  static const angle_01 = angle_1 * 0.1;
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

  static double radianFromAngle(double angle) => angle * Radian.angle_1;

  static double radianFromRound(double round) => round * Radian.angle_360;

  static double angleOf(double radian) => radian / Radian.angle_1;

  static double roundOf(double radian) => radian / Radian.angle_360;

  static double modulus90AngleOf(double radian) => radian % Radian.angle_90;

  static double modulus180AngleOf(double radian) => radian % Radian.angle_180;

  static double modulus360AngleOf(double radian) => radian % Radian.angle_360;

  ///
  /// [complementaryOf], [supplementaryOf], [restrict180AbsForAngle]
  ///
  static double complementaryOf(double radian) {
    assert(radian.rangeIn(0, Radian.angle_90));
    return radianFromAngle(90 - angleOf(radian));
  }

  static double supplementaryOf(double radian) {
    assert(radian.rangeIn(0, Radian.angle_180));
    return radianFromAngle(180 - angleOf(radian));
  }

  static double restrict180AbsForAngle(double angle) {
    final r = angle % 360;
    return r >= Radian.angle_180 ? r - Radian.angle_360 : r;
  }

  ///
  /// [ifWithinAngle90_90N], [ifOverAngle90_90N], [ifWithinAngle0_180], [ifWithinAngle0_180N]
  ///
  static bool ifWithinAngle90_90N(double radian) =>
      radian.abs() < Radian.angle_90;

  static bool ifOverAngle90_90N(double radian) =>
      radian.abs() > Radian.angle_90;

  static bool ifWithinAngle0_180(double radian) =>
      radian > 0 && radian < Radian.angle_180;

  static bool ifWithinAngle0_180N(double radian) =>
      radian > -Radian.angle_180 && radian < 0;

  ///
  /// [ifInQuadrant1], [ifInQuadrant2], [ifInQuadrant3], [ifInQuadrant4]
  ///
  static bool ifInQuadrant1(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(0, Radian.angle_90) ||
        r.within(-Radian.angle_360, -Radian.angle_270)
        : r.within(Radian.angle_270, Radian.angle_360) ||
        r.within(-Radian.angle_90, 0);
  }

  static bool ifInQuadrant2(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_90, Radian.angle_180) ||
        r.within(-Radian.angle_270, -Radian.angle_180)
        : r.within(Radian.angle_180, Radian.angle_270) ||
        r.within(-Radian.angle_180, -Radian.angle_90);
  }

  static bool ifInQuadrant3(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_180, Radian.angle_270) ||
        r.within(-Radian.angle_180, -Radian.angle_90)
        : r.within(Radian.angle_90, Radian.angle_180) ||
        r.within(-Radian.angle_270, -Radian.angle_180);
  }

  static bool ifInQuadrant4(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_270, Radian.angle_360) ||
        r.within(-Radian.angle_90, 0)
        : r.within(0, Radian.angle_90) ||
        r.within(-Radian.angle_360, -Radian.angle_270);
  }

  ///
  /// [ifOnRight], [ifOnLeft], [ifOnTop], [ifOnBottom]
  /// 'right' and 'left' are the same no matter in dart or in math
  ///
  static bool ifOnRight(double radian) =>
      ifWithinAngle90_90N(modulus360AngleOf(radian));

  static bool ifOnLeft(double radian) =>
      ifOverAngle90_90N(modulus360AngleOf(radian));

  static bool ifOnTop(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion ? ifWithinAngle0_180(r) : ifWithinAngle0_180N(r);
  }

  static bool ifOnBottom(
      double radian, {
        bool isInMathDiscussion = false,
      }) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion ? ifWithinAngle0_180N(r) : ifWithinAngle0_180(r);
  }
}

///
///
///
/// [Space2]
/// [Space3]
/// [Space3Radian]
///
///

///
///
/// [dx], [dy]
///
///
class Space2 {
  final double dx;
  final double dy;

  const Space2(this.dx, this.dy);

  Space2.fromDirection(double direction, [double distance = 1])
      : dx = distance * math.cos(direction),
        dy = distance * math.sin(direction);

  static const zero = Space2(0.0, 0.0);
  static const one = Space2(1.0, 1.0);

  Space2 operator -() => Space2(-dx, -dy);

  Space2 operator +(Space2 other) => Space2(dx + other.dx, dy + other.dy);

  Space2 operator -(Space2 other) => Space2(dx - other.dx, dy - other.dy);

  Space2 operator %(double operand) => Space2(dx % operand, dy % operand);

  Space2 operator *(double operand) => Space2(dx * operand, dy * operand);

  Space2 operator /(double operand) => Space2(dx / operand, dy / operand);

  Space2 operator ~/(double operand) =>
      Space2((dx ~/ operand).toDouble(), (dy ~/ operand).toDouble());

  Space2 scale(double scaleX, double scaleY) =>
      Space2(dx * scaleX, dy * scaleY);

  Space2 translate(double translateX, double translateY) =>
      Space2(dx + translateX, dy + translateY);

  bool operator <(Space2 other) => dx < other.dx && dy < other.dy;

  bool operator <=(Space2 other) => dx <= other.dx && dy <= other.dy;

  bool operator >(Space2 other) => dx > other.dx && dy > other.dy;

  bool operator >=(Space2 other) => dx >= other.dx && dy >= other.dy;

  double get direction => math.atan2(dy, dx);

  double get directionInAngle => Radian.angleOf(direction).roundToDouble();

  double get distance => math.sqrt(distanceSquared);

  double get distanceSquared => dx * dx + dy * dy;

  bool get isFinite => dx.isFinite && dy.isFinite;

  bool get isInfinite => dx.isInfinite && dy.isInfinite;

  double radianTo(Space2 other) => other.direction - direction;

  double angleTo(Space2 other) =>
      Radian.angleOf(other.direction - direction).roundToDouble();
}
///
/// [dz]
/// [isNot3D], [isNegative]
/// [hasNegative], [withoutXY]
/// [retainXY], [retainYZAsYX], [retainYZAsXY], [retainXZAsXY], [retainXZAsYX]
/// [roundup], [abs]
/// [distanceSquared], [distance], [volume], [isFinite], [isInfinite], [direction], [direction3D]
/// operators...
/// [scale], [scaleCoordinate], [translate], [rotate], [toString]
/// [Coordinate.cube], [Coordinate.ofX], [Coordinate.ofY], [Coordinate.ofZ]; [Coordinate.ofXY], [Coordinate.ofYZ], [Coordinate.ofXZ]
/// [Coordinate.fromDirection]
///
/// [Space3.zero], [Space3.one]
/// [maxDistance], [transferToTransformOf],
///
///
class Space3 extends Space2 {
  final double dz;

  bool get isNot3D => (dz == 0 || dx == 0 || dy == 0);

  bool get isNegative => (dz < 0 && dx < 0 && dy < 0);

  bool get hasNegative => (dz < 0 || dx < 0 || dy < 0);

  bool get withoutXY => (dx == 0 && dy == 0);

  Space3 get retainXY => Space3(dx, dy, 0);

  Space3 get retainYZAsYX => Space3(dz, dy, 0);

  Space3 get retainYZAsXY => Space3(dy, dz, 0);

  Space3 get retainXZAsXY => Space3(dx, dz, 0);

  Space3 get retainXZAsYX => Space3(dz, dx, 0);

  Space3 get roundup => Space3(
    dx.roundToDouble(),
    dy.roundToDouble(),
    dz.roundToDouble(),
  );

  Space3 get abs => Space3(dx.abs(), dy.abs(), dz.abs());

  @override
  double get distanceSquared => dx * dx + dy * dy + dz * dz;

  @override
  double get distance => math.sqrt(distanceSquared);

  double get volume => dx * dy * dz;

  @override
  bool get isFinite => super.isFinite && dz.isFinite;

  @override
  bool get isInfinite => super.isInfinite && dz.isInfinite;

  @override
  double get direction => throw UnimplementedError();

  Space3Radian get direction3D => throw UnimplementedError();

  @override
  Space3 operator +(covariant Space3 other) =>
      Space3(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Space3 operator -(covariant Space3 other) =>
      Space3(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Space3 operator -() => Space3(-dx, -dy, -dz);

  @override
  Space3 operator *(double operand) => Space3(
    dx * operand,
    dy * operand,
    dz * operand,
  );

  @override
  Space3 operator /(double operand) => Space3(
    dx / operand,
    dy / operand,
    dz / operand,
  );

  @override
  Space3 operator ~/(double operand) => Space3(
    (dx ~/ operand).toDouble(),
    (dy ~/ operand).toDouble(),
    (dz ~/ operand).toDouble(),
  );

  @override
  Space3 operator %(double operand) => Space3(
    dx % operand,
    dy % operand,
    dz % operand,
  );

  @override
  bool operator <(covariant Space3 other) => dz < other.dz && (super < other);

  @override
  bool operator <=(covariant Space3 other) =>
      dz <= other.dz && (super <= other);

  @override
  bool operator >(covariant Space3 other) => dz > other.dz && (super > other);

  @override
  bool operator >=(covariant Space3 other) =>
      dz >= other.dz && (super >= other);

  @override
  bool operator ==(covariant Space3 other) =>
      dz == other.dz && (super == other);

  @override
  int get hashCode => Object.hash(super.hashCode, dz);

  @override
  Space3 scale(
      double scaleX,
      double scaleY, {
        double scaleZ = 0,
      }) =>
      Space3(dx * scaleX, dy * scaleY, dz * scaleZ);

  Space3 scaleCoordinate(Space3 scale) =>
      this.scale(scale.dx, scale.dy, scaleZ: scale.dz);

  @override
  Space3 translate(
      double translateX,
      double translateY, {
        double translateZ = 0,
      }) =>
      Space3(dx + translateX, dy + translateY, dz + translateZ);

  Space3 rotate(Space3Radian direction) =>
      Space3.fromDirection(direction3D + direction, distance);

  @override
  String toString() => 'Coordinate('
      '${dx.toStringAsFixed(1)}, '
      '${dy.toStringAsFixed(1)}, '
      '${dz.toStringAsFixed(1)})';

  const Space3(super.dx, super.dy, this.dz);

  const Space3.cube(double dimension)
      : dz = dimension,
        super(dimension, dimension);

  const Space3.ofX(double x)
      : dz = 0,
        super(x, 0);

  const Space3.ofY(double y)
      : dz = 0,
        super(0, y);

  const Space3.ofZ(double z)
      : dz = z,
        super(0, 0);

  const Space3.ofXY(double value)
      : dz = 0,
        super(value, value);

  const Space3.ofYZ(double value)
      : dz = value,
        super(0, value);

  const Space3.ofXZ(double value)
      : dz = value,
        super(value, 0);

  //
  Space3.fromCoordinate2D(Space2 space2)
      : dz = 0,
        super(space2.dx, space2.dy);

  static const Space3 zero = Space3.cube(0);
  static const Space3 one = Space3.cube(1);
  static const Space3 cube_01 = Space3.cube(0.1);
  static const Space3 cube_02 = Space3.cube(0.2);
  static const Space3 cube_03 = Space3.cube(0.3);
  static const Space3 cube_04 = Space3.cube(0.4);
  static const Space3 cube_05 = Space3.cube(0.5);
  static const Space3 cube_06 = Space3.cube(0.6);
  static const Space3 cube_07 = Space3.cube(0.7);
  static const Space3 cube_08 = Space3.cube(0.8);
  static const Space3 cube_09 = Space3.cube(0.9);
  static const Space3 cube_1 = Space3.cube(1);
  static const Space3 cube_2 = Space3.cube(2);
  static const Space3 cube_3 = Space3.cube(3);
  static const Space3 cube_4 = Space3.cube(4);
  static const Space3 cube_5 = Space3.cube(5);
  static const Space3 cube_6 = Space3.cube(6);
  static const Space3 cube_7 = Space3.cube(7);
  static const Space3 cube_8 = Space3.cube(8);
  static const Space3 cube_9 = Space3.cube(9);
  static const Space3 cube_10 = Space3.cube(10);
  static const Space3 cube_100 = Space3.cube(100);
  static const Space3 x100 = Space3(100, 0, 0);
  static const Space3 y100 = Space3(0, 100, 0);
  static const Space3 z100 = Space3(0, 0, 100);

  ///
  /// it implement in 'my coordinate system', not 'dart coordinate system' ([Transform], [Matrix4], [Space2]], ...)
  /// see also [TransformExtension]
  ///
  factory Space3.fromDirection(Space3Radian direction, [double distance = 1]) {
    final rX = direction.dx;
    final rY = direction.dy;
    final rZ = direction.dz;
    final d = distance * DoubleExtension.sqrt1_3;
    return Space3(
      d * (math.cos(rZ) * math.cos(rY)),
      d * (math.sin(rZ) * math.cos(rX)),
      d * (math.sin(rX) * math.sin(rY)),
    );
  }

  static Space3 maxDistance(Space3 a, Space3 b) =>
      a.distance > b.distance ? a : b;
}


///
///
/// [Space3Radian.circle], ...
/// [modulus90Angle], ...
/// [zero], ...
///
class Space3Radian extends Space3 {
  const Space3Radian(super.dx, super.dy, super.dz);

  const Space3Radian.circle(super.dimension) : super.cube();

  const Space3Radian.ofX(super.dx) : super.ofX();

  const Space3Radian.ofY(super.dy) : super.ofY();

  const Space3Radian.ofZ(super.dz) : super.ofZ();

  const Space3Radian.ofXY(super.value) : super.ofXY();

  const Space3Radian.ofYZ(super.value) : super.ofYZ();

  const Space3Radian.ofXZ(super.value) : super.ofXZ();

  @override
  Space3Radian operator +(covariant Space3Radian other) =>
      Space3Radian(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Space3Radian operator -(covariant Space3Radian other) =>
      Space3Radian(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Space3Radian operator *(double operand) =>
      Space3Radian(dx * operand, dy * operand, dz * operand);

  @override
  Space3Radian operator /(double operand) =>
      Space3Radian(dx / operand, dy / operand, dz / operand);

  ///
  /// getters
  ///
  Space3Radian get modulus90Angle => Space3Radian(
    Radian.modulus90AngleOf(dx),
    Radian.modulus90AngleOf(dy),
    Radian.modulus90AngleOf(dz),
  );

  Space3Radian get modulus180Angle => Space3Radian(
    Radian.modulus180AngleOf(dx),
    Radian.modulus180AngleOf(dy),
    Radian.modulus180AngleOf(dz),
  );

  Space3Radian get modulus360Angle => Space3Radian(
    Radian.modulus360AngleOf(dx),
    Radian.modulus360AngleOf(dy),
    Radian.modulus360AngleOf(dz),
  );

  Space3Radian get restrict180AbsAngle => Space3Radian(
    Radian.restrict180AbsForAngle(dx),
    Radian.restrict180AbsForAngle(dy),
    Radian.restrict180AbsForAngle(dz),
  );

  ///
  /// [complementary], [supplementary]
  ///
  Space3Radian get complementary => Space3Radian(
    Radian.complementaryOf(dx),
    Radian.complementaryOf(dy),
    Radian.complementaryOf(dz),
  );

  Space3Radian get supplementary => Space3Radian(
    Radian.supplementaryOf(dx),
    Radian.supplementaryOf(dy),
    Radian.supplementaryOf(dz),
  );

  Space3 get toAngle =>
      Space3(Radian.angleOf(dx), Radian.angleOf(dy), Radian.angleOf(dz));

  Space3 get toRound =>
      Space3(Radian.roundOf(dx), Radian.roundOf(dy), Radian.roundOf(dz));

  ///
  /// constants
  ///
  static const zero = Space3Radian.circle(0);
  static const angleX_360 = Space3Radian.ofX(Radian.angle_360);
  static const angleY_360 = Space3Radian.ofY(Radian.angle_360);
  static const angleZ_360 = Space3Radian.ofZ(Radian.angle_360);
  static const angleXYZ_360 = Space3Radian.circle(Radian.angle_360);
  static const angleXY_360 = Space3Radian.ofXY(Radian.angle_360);
  static const angleX_270 = Space3Radian.ofX(Radian.angle_270);
  static const angleY_270 = Space3Radian.ofY(Radian.angle_270);
  static const angleZ_270 = Space3Radian.ofZ(Radian.angle_270);
  static const angleXYZ_270 = Space3Radian.circle(Radian.angle_270);
  static const angleXY_270 = Space3Radian.ofXY(Radian.angle_270);
  static const angleX_180 = Space3Radian.ofX(Radian.angle_180);
  static const angleY_180 = Space3Radian.ofY(Radian.angle_180);
  static const angleZ_180 = Space3Radian.ofZ(Radian.angle_180);
  static const angleXYZ_180 = Space3Radian.circle(Radian.angle_180);
  static const angleXY_180 = Space3Radian.ofXY(Radian.angle_180);
  static const angleX_120 = Space3Radian.ofX(Radian.angle_120);
  static const angleY_120 = Space3Radian.ofY(Radian.angle_120);
  static const angleZ_120 = Space3Radian.ofZ(Radian.angle_120);
  static const angleZ_150 = Space3Radian.ofZ(Radian.angle_150);
  static const angleXYZ_120 = Space3Radian.circle(Radian.angle_120);
  static const angleXY_120 = Space3Radian.ofXY(Radian.angle_120);
  static const angleX_90 = Space3Radian.ofX(Radian.angle_90);
  static const angleY_90 = Space3Radian.ofY(Radian.angle_90);
  static const angleZ_90 = Space3Radian.ofZ(Radian.angle_90);
  static const angleXYZ_90 = Space3Radian.circle(Radian.angle_90);
  static const angleXY_90 = Space3Radian.ofXY(Radian.angle_90);
  static const angleYZ_90 = Space3Radian.ofYZ(Radian.angle_90);
  static const angleXZ_90 = Space3Radian.ofXZ(Radian.angle_90);
  static const angleX_60 = Space3Radian.ofX(Radian.angle_60);
  static const angleY_60 = Space3Radian.ofY(Radian.angle_60);
  static const angleZ_60 = Space3Radian.ofZ(Radian.angle_60);
  static const angleXYZ_60 = Space3Radian.circle(Radian.angle_60);
  static const angleXY_60 = Space3Radian.ofXY(Radian.angle_60);
  static const angleX_45 = Space3Radian.ofX(Radian.angle_45);
  static const angleY_45 = Space3Radian.ofY(Radian.angle_45);
  static const angleZ_45 = Space3Radian.ofZ(Radian.angle_45);
  static const angleXYZ_45 = Space3Radian.circle(Radian.angle_45);
  static const angleXY_45 = Space3Radian.ofXY(Radian.angle_45);
  static const angleX_30 = Space3Radian.ofX(Radian.angle_30);
  static const angleY_30 = Space3Radian.ofY(Radian.angle_30);
  static const angleZ_30 = Space3Radian.ofZ(Radian.angle_30);
  static const angleXYZ_30 = Space3Radian.circle(Radian.angle_30);
  static const angleXY_30 = Space3Radian.ofXY(Radian.angle_30);
  static const angleX_15 = Space3Radian.ofX(Radian.angle_15);
  static const angleY_15 = Space3Radian.ofY(Radian.angle_15);
  static const angleZ_15 = Space3Radian.ofZ(Radian.angle_15);
  static const angleXYZ_15 = Space3Radian.circle(Radian.angle_15);
  static const angleXY_15 = Space3Radian.ofXY(Radian.angle_15);
  static const angleX_10 = Space3Radian.ofX(Radian.angle_10);
  static const angleY_10 = Space3Radian.ofY(Radian.angle_10);
  static const angleZ_10 = Space3Radian.ofZ(Radian.angle_10);
  static const angleXYZ_10 = Space3Radian.circle(Radian.angle_10);
  static const angleXY_10 = Space3Radian.ofXY(Radian.angle_10);
  static const angleX_1 = Space3Radian.ofX(Radian.angle_1);
  static const angleY_1 = Space3Radian.ofY(Radian.angle_1);
  static const angleZ_1 = Space3Radian.ofZ(Radian.angle_1);
  static const angleXYZ_1 = Space3Radian.circle(Radian.angle_1);
  static const angleXY_1 = Space3Radian.ofXY(Radian.angle_1);
  static const angleX_01 = Space3Radian.ofX(Radian.angle_01);
  static const angleY_01 = Space3Radian.ofY(Radian.angle_01);
  static const angleZ_01 = Space3Radian.ofZ(Radian.angle_01);
  static const angleXYZ_01 = Space3Radian.circle(Radian.angle_01);
  static const angleXY_01 = Space3Radian.ofXY(Radian.angle_01);
}


///
///
/// [Direction]
///   [Direction2D]
///     [Direction2DIn4]
///     [Direction2DIn8]
///   [Direction3D]
///     [Direction3DIn6]
///     [Direction3DIn14]
///
///

///
///
///
/// [Direction3DIn6] and "dart direction" ([Transform], [Matrix4], [Space2] direction) are different.
/// The radian discussion here, follows these rules:
/// - "positive radian" is counterclockwise, going through 0 ~ 2π.
/// - [Direction3DIn6] is user perspective. ([Direction3DIn6.back] is user side, [Direction3DIn6.front] is screen side)
///
/// For example, [Coordinate2D.fromDirection] radian 0 ~ 2π going through:
/// [Direction3DIn6.right], [Direction3DIn6.bottom], [Direction3DIn6.left], [Direction3DIn6.top], [Direction3DIn6.right] in sequence;
/// the axis of [Coordinate2D.fromDirection] is [Direction3DIn6.front] -> [Direction3DIn6.back],
/// which is not counterclockwise in user perspective ([Direction3DIn6.back] -> [Direction3DIn6.front]).
///
/// See Also:
///   * [KRadian]
///
///
///
sealed class Direction<D> {
  D get flipped;

  Space2 get toSpace2;

  Space3 get toSpace3;
}

sealed class Direction2D<D extends Direction2D<D>> implements Direction<D> {
  static const radian_right = 0;
  static const radian_bottomRight = Radian.angle_45;
  static const radian_bottom = Radian.angle_90;
  static const radian_bottomLeft = Radian.angle_135;
  static const radian_left = Radian.angle_180;
  static const radian_topLeft = Radian.angle_225;
  static const radian_top = Radian.angle_270;
  static const radian_topRight = Radian.angle_315;

  static const space_top = Space2(0, -1);
  static const space_left = Space2(-1, 0);
  static const space_right = Space2(1, 0);
  static const space_bottom = Space2(0, 1);
  static const space_center = Space2.zero;
  static const space_topLeft = Space2(-math.sqrt1_2, -math.sqrt1_2);
  static const space_topRight = Space2(math.sqrt1_2, -math.sqrt1_2);
  static const space_bottomLeft = Space2(-math.sqrt1_2, math.sqrt1_2);
  static const space_bottomRight = Space2(math.sqrt1_2, math.sqrt1_2);
}

///
///
/// direction 2D in 4
///
///
enum Direction2DIn4 implements Direction2D<Direction2DIn4> {
  left,
  right,
  top,
  bottom;

  @override
  Direction2DIn4 get flipped => switch (this) {
    Direction2DIn4.left => Direction2DIn4.right,
    Direction2DIn4.right => Direction2DIn4.left,
    Direction2DIn4.top => Direction2DIn4.top,
    Direction2DIn4.bottom => Direction2DIn4.bottom,
  };

  @override
  Space2 get toSpace2 => toDirection8.toSpace2;

  @override
  Space3 get toSpace3 => toDirection8.toSpace3;

  Direction2DIn8 get toDirection8 => switch (this) {
    Direction2DIn4.left => Direction2DIn8.left,
    Direction2DIn4.top => Direction2DIn8.top,
    Direction2DIn4.right => Direction2DIn8.right,
    Direction2DIn4.bottom => Direction2DIn8.bottom,
  };
}

///
///
/// direction 2D in 8
///
///
enum Direction2DIn8 implements Direction2D<Direction2DIn8> {
  top,
  left,
  right,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  @override
  Direction2DIn8 get flipped => switch (this) {
    top => Direction2DIn8.bottom,
    left => Direction2DIn8.right,
    right => Direction2DIn8.left,
    bottom => Direction2DIn8.top,
    topLeft => Direction2DIn8.bottomRight,
    topRight => Direction2DIn8.bottomLeft,
    bottomLeft => Direction2DIn8.topRight,
    bottomRight => Direction2DIn8.topLeft,
  };

  @override
  Space2 get toSpace2 => switch (this) {
    top => Direction2D.space_top,
    left => Direction2D.space_left,
    right => Direction2D.space_right,
    bottom => Direction2D.space_bottom,
    topLeft => Direction2D.space_topLeft,
    topRight => Direction2D.space_topRight,
    bottomLeft => Direction2D.space_bottomLeft,
    bottomRight => Direction2D.space_bottomRight,
  };

  @override
  Space3 get toSpace3 => switch (this) {
    top => Direction3D.space_top,
    left => Direction3D.space_left,
    right => Direction3D.space_right,
    bottom => Direction3D.space_bottom,
    topLeft => Direction3D.space_topLeft,
    topRight => Direction3D.space_topRight,
    bottomLeft => Direction3D.space_bottomLeft,
    bottomRight => Direction3D.space_bottomRight,
  };

  bool get isDiagonal => switch (this) {
    Direction2DIn8.left ||
    Direction2DIn8.top ||
    Direction2DIn8.right ||
    Direction2DIn8.bottom =>
    false,
    Direction2DIn8.topLeft ||
    Direction2DIn8.topRight ||
    Direction2DIn8.bottomLeft ||
    Direction2DIn8.bottomRight =>
    true,
  };

  double get scaleOnGrid => isDiagonal ? DoubleExtension.sqrt2 : 1;
}

///
///
///
///
/// [Direction3D]
/// [Direction3DIn6], [Direction3DIn14], ...
///
///
///
///

sealed class Direction3D<D extends Direction3D<D>> implements Direction<D> {
  static const space_center = Space3.zero;
  static const space_left = Space3.ofX(-1);
  static const space_top = Space3.ofY(-1);
  static const space_right = Space3.ofX(1);
  static const space_bottom = Space3.ofY(1);
  static const space_front = Space3.ofZ(1);
  static const space_back = Space3.ofZ(-1);

  static const space_topLeft = Space3.ofXY(-math.sqrt1_2);
  static const space_bottomRight = Space3.ofXY(math.sqrt1_2);
  static const space_frontRight = Space3.ofXZ(math.sqrt1_2);
  static const space_frontBottom = Space3.ofYZ(math.sqrt1_2);
  static const space_backLeft = Space3.ofXZ(-math.sqrt1_2);
  static const space_backTop = Space3.ofYZ(-math.sqrt1_2);
  static const space_topRight = Space3(math.sqrt1_2, -math.sqrt1_2, 0);
  static const space_frontTop = Space3(0, -math.sqrt1_2, math.sqrt1_2);
  static const space_bottomLeft = Space3(-math.sqrt1_2, math.sqrt1_2, 0);
  static const space_frontLeft = Space3(-math.sqrt1_2, 0, math.sqrt1_2);
  static const space_backRight = Space3(math.sqrt1_2, 0, -math.sqrt1_2);
  static const space_backBottom = Space3(0, math.sqrt1_2, -math.sqrt1_2);

  static const space_frontTopLeft = Space3(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontTopRight = Space3(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontBottomLeft = Space3(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontBottomRight = Space3(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_backTopLeft = Space3(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const space_backTopRight = Space3(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const space_backBottomLeft = Space3(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const space_backBottomRight = Space3(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
}

///
///
enum Direction3DIn6 implements Direction3D<Direction3DIn6> {
  left,
  top,
  right,
  bottom,
  front,
  back;

  @override
  Direction3DIn6 get flipped => switch (this) {
    Direction3DIn6.left => Direction3DIn6.right,
    Direction3DIn6.top => Direction3DIn6.bottom,
    Direction3DIn6.right => Direction3DIn6.left,
    Direction3DIn6.bottom => Direction3DIn6.top,
    Direction3DIn6.front => Direction3DIn6.back,
    Direction3DIn6.back => Direction3DIn6.front,
  };

  @override
  Space2 get toSpace2 => switch (this) {
    Direction3DIn6.left => Direction2D.space_left,
    Direction3DIn6.top => Direction2D.space_top,
    Direction3DIn6.right => Direction2D.space_right,
    Direction3DIn6.bottom => Direction2D.space_bottom,
    _ => throw UnimplementedError(),
  };

  @override
  Space3 get toSpace3 => switch (this) {
    Direction3DIn6.left => Direction3D.space_left,
    Direction3DIn6.top => Direction3D.space_top,
    Direction3DIn6.right => Direction3D.space_right,
    Direction3DIn6.bottom => Direction3D.space_bottom,
    Direction3DIn6.front => Direction3D.space_front,
    Direction3DIn6.back => Direction3D.space_back,
  };
}

enum Direction3DIn14 implements Direction3D<Direction3DIn14> {
  left,
  top,
  right,
  bottom,
  front,
  frontLeft,
  frontTop,
  frontRight,
  frontBottom,
  back,
  backLeft,
  backTop,
  backRight,
  backBottom;

  @override
  Direction3DIn14 get flipped => switch (this) {
    Direction3DIn14.left => Direction3DIn14.right,
    Direction3DIn14.top => Direction3DIn14.bottom,
    Direction3DIn14.right => Direction3DIn14.left,
    Direction3DIn14.bottom => Direction3DIn14.top,
    Direction3DIn14.front => Direction3DIn14.front,
    Direction3DIn14.frontLeft => Direction3DIn14.frontLeft,
    Direction3DIn14.frontTop => Direction3DIn14.frontTop,
    Direction3DIn14.frontRight => Direction3DIn14.frontRight,
    Direction3DIn14.frontBottom => Direction3DIn14.frontBottom,
    Direction3DIn14.back => Direction3DIn14.back,
    Direction3DIn14.backLeft => Direction3DIn14.backLeft,
    Direction3DIn14.backTop => Direction3DIn14.backTop,
    Direction3DIn14.backRight => Direction3DIn14.backRight,
    Direction3DIn14.backBottom => Direction3DIn14.backBottom,
  };

  @override
  Space2 get toSpace2 => switch (this) {
    Direction3DIn14.left => Direction2D.space_left,
    Direction3DIn14.top => Direction2D.space_top,
    Direction3DIn14.right => Direction2D.space_right,
    Direction3DIn14.bottom => Direction2D.space_bottom,
    _ => throw UnimplementedError(),
  };

  @override
  Space3 get toSpace3 => switch (this) {
    Direction3DIn14.left => Direction3D.space_left,
    Direction3DIn14.top => Direction3D.space_top,
    Direction3DIn14.right => Direction3D.space_right,
    Direction3DIn14.bottom => Direction3D.space_bottom,
    Direction3DIn14.front => Direction3D.space_front,
    Direction3DIn14.frontLeft => Direction3D.space_frontLeft,
    Direction3DIn14.frontTop => Direction3D.space_frontTop,
    Direction3DIn14.frontRight => Direction3D.space_frontRight,
    Direction3DIn14.frontBottom => Direction3D.space_frontBottom,
    Direction3DIn14.back => Direction3D.space_back,
    Direction3DIn14.backLeft => Direction3D.space_backLeft,
    Direction3DIn14.backTop => Direction3D.space_backTop,
    Direction3DIn14.backRight => Direction3D.space_backRight,
    Direction3DIn14.backBottom => Direction3D.space_backBottom,
  };

  double get distance => switch (this) {
    Direction3DIn14.left ||
    Direction3DIn14.top ||
    Direction3DIn14.right ||
    Direction3DIn14.bottom ||
    Direction3DIn14.front ||
    Direction3DIn14.back =>
    1,
    Direction3DIn14.frontLeft ||
    Direction3DIn14.frontTop ||
    Direction3DIn14.frontRight ||
    Direction3DIn14.frontBottom ||
    Direction3DIn14.backLeft ||
    Direction3DIn14.backTop ||
    Direction3DIn14.backRight ||
    Direction3DIn14.backBottom =>
    DoubleExtension.sqrt2,
  };
}

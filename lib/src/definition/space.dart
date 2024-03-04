///
///
/// this file contains:
///
/// [Coordinate2D]
/// [Coordinate]
/// [CoordinateRadian]
///
/// [Vector3D]
///
/// [Direction]
///   [Direction2D]
///     [Direction2DIn4]
///     [Direction2DIn8]
///   [Direction3D]
///     [Direction3DIn6]
///     [Direction3DIn14]
///     [Direction3DIn22]
///
///
/// [CubicOffset]
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
// ignore_for_file: constant_identifier_names
part of damath;

///
///
///
/// [Coordinate2D]
///
///
///

//
class Coordinate2D {
  final double dx;
  final double dy;

  const Coordinate2D(this.dx, this.dy);

  Coordinate2D.fromDirection(double direction, [double distance = 1])
      : dx = distance * math.cos(direction),
        dy = distance * math.sin(direction);

  static const Coordinate2D zero = Coordinate2D(0.0, 0.0);
  static const Coordinate2D one = Coordinate2D(1.0, 1.0);

  Coordinate2D operator -() => Coordinate2D(-dx, -dy);

  Coordinate2D operator +(Coordinate2D other) =>
      Coordinate2D(dx + other.dx, dy + other.dy);

  Coordinate2D operator -(Coordinate2D other) =>
      Coordinate2D(dx - other.dx, dy - other.dy);

  Coordinate2D operator %(double operand) =>
      Coordinate2D(dx % operand, dy % operand);

  Coordinate2D operator *(double operand) =>
      Coordinate2D(dx * operand, dy * operand);

  Coordinate2D operator /(double operand) =>
      Coordinate2D(dx / operand, dy / operand);

  Coordinate2D operator ~/(double operand) =>
      Coordinate2D((dx ~/ operand).toDouble(), (dy ~/ operand).toDouble());

  Coordinate2D scale(double scaleX, double scaleY) =>
      Coordinate2D(dx * scaleX, dy * scaleY);

  Coordinate2D translate(double translateX, double translateY) =>
      Coordinate2D(dx + translateX, dy + translateY);

  bool operator <(Coordinate2D other) => dx < other.dx && dy < other.dy;

  bool operator <=(Coordinate2D other) => dx <= other.dx && dy <= other.dy;

  bool operator >(Coordinate2D other) => dx > other.dx && dy > other.dy;

  bool operator >=(Coordinate2D other) => dx >= other.dx && dy >= other.dy;

  double get direction => math.atan2(dy, dx);

  double get distance => math.sqrt(distanceSquared);

  double get distanceSquared => dx * dx + dy * dy;

  bool get isFinite => dx.isFinite && dy.isFinite;

  bool get isInfinite => dx.isInfinite && dy.isInfinite;
}

///
///
///
/// [Coordinate]
///
///
///

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
/// [Coordinate.zero], [Coordinate.one]
/// [maxDistance], [transferToTransformOf],
///
///
class Coordinate extends Coordinate2D {
  final double dz;

  bool get isNot3D => (dz == 0 || dx == 0 || dy == 0);

  bool get isNegative => (dz < 0 && dx < 0 && dy < 0);

  bool get hasNegative => (dz < 0 || dx < 0 || dy < 0);

  bool get withoutXY => (dx == 0 && dy == 0);

  Coordinate get retainXY => Coordinate(dx, dy, 0);

  Coordinate get retainYZAsYX => Coordinate(dz, dy, 0);

  Coordinate get retainYZAsXY => Coordinate(dy, dz, 0);

  Coordinate get retainXZAsXY => Coordinate(dx, dz, 0);

  Coordinate get retainXZAsYX => Coordinate(dz, dx, 0);

  Coordinate get roundup => Coordinate(
        dx.roundToDouble(),
        dy.roundToDouble(),
        dz.roundToDouble(),
      );

  Coordinate get abs => Coordinate(dx.abs(), dy.abs(), dz.abs());

  double get distanceSquared => dx * dx + dy * dy + dz * dz;

  double get distance => math.sqrt(distanceSquared);

  double get volume => dx * dy * dz;

  @override
  bool get isFinite => super.isFinite && dz.isFinite;

  @override
  bool get isInfinite => super.isInfinite && dz.isInfinite;

  @override
  double get direction => throw UnimplementedError();

  CoordinateRadian get direction3D => throw UnimplementedError();

  @override
  Coordinate operator +(covariant Coordinate other) =>
      Coordinate(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Coordinate operator -(covariant Coordinate other) =>
      Coordinate(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Coordinate operator -() => Coordinate(-dx, -dy, -dz);

  @override
  Coordinate operator *(double operand) => Coordinate(
        dx * operand,
        dy * operand,
        dz * operand,
      );

  @override
  Coordinate operator /(double operand) => Coordinate(
        dx / operand,
        dy / operand,
        dz / operand,
      );

  @override
  Coordinate operator ~/(double operand) => Coordinate(
        (dx ~/ operand).toDouble(),
        (dy ~/ operand).toDouble(),
        (dz ~/ operand).toDouble(),
      );

  @override
  Coordinate operator %(double operand) => Coordinate(
        dx % operand,
        dy % operand,
        dz % operand,
      );

  @override
  bool operator <(covariant Coordinate other) =>
      dz < other.dz && (super < other);

  @override
  bool operator <=(covariant Coordinate other) =>
      dz <= other.dz && (super <= other);

  @override
  bool operator >(covariant Coordinate other) =>
      dz > other.dz && (super > other);

  @override
  bool operator >=(covariant Coordinate other) =>
      dz >= other.dz && (super >= other);

  @override
  bool operator ==(covariant Coordinate other) =>
      dz == other.dz && (super == other);

  @override
  int get hashCode => Object.hash(super.hashCode, dz);

  @override
  Coordinate scale(
    double scaleX,
    double scaleY, {
    double scaleZ = 0,
  }) =>
      Coordinate(dx * scaleX, dy * scaleY, dz * scaleZ);

  Coordinate scaleCoordinate(Coordinate scale) =>
      this.scale(scale.dx, scale.dy, scaleZ: scale.dz);

  @override
  Coordinate translate(
    double translateX,
    double translateY, {
    double translateZ = 0,
  }) =>
      Coordinate(dx + translateX, dy + translateY, dz + translateZ);

  Coordinate rotate(CoordinateRadian direction) =>
      Coordinate.fromDirection(direction3D + direction, distance);

  @override
  String toString() => 'Coordinate('
      '${dx.toStringAsFixed(1)}, '
      '${dy.toStringAsFixed(1)}, '
      '${dz.toStringAsFixed(1)})';

  const Coordinate(super.dx, super.dy, this.dz);

  const Coordinate.cube(double dimension)
      : dz = dimension,
        super(dimension, dimension);

  const Coordinate.ofX(double x)
      : dz = 0,
        super(x, 0);

  const Coordinate.ofY(double y)
      : dz = 0,
        super(0, y);

  const Coordinate.ofZ(double z)
      : dz = z,
        super(0, 0);

  const Coordinate.ofXY(double value)
      : dz = 0,
        super(value, value);

  const Coordinate.ofYZ(double value)
      : dz = value,
        super(0, value);

  const Coordinate.ofXZ(double value)
      : dz = value,
        super(value, 0);

  //
  Coordinate.fromCoordinate2D(Coordinate2D Coordinate2D)
      : dz = 0,
        super(Coordinate2D.dx, Coordinate2D.dy);

  static const Coordinate zero = Coordinate.cube(0);
  static const Coordinate one = Coordinate.cube(1);
  static const Coordinate cube_01 = Coordinate.cube(0.1);
  static const Coordinate cube_02 = Coordinate.cube(0.2);
  static const Coordinate cube_03 = Coordinate.cube(0.3);
  static const Coordinate cube_04 = Coordinate.cube(0.4);
  static const Coordinate cube_05 = Coordinate.cube(0.5);
  static const Coordinate cube_06 = Coordinate.cube(0.6);
  static const Coordinate cube_07 = Coordinate.cube(0.7);
  static const Coordinate cube_08 = Coordinate.cube(0.8);
  static const Coordinate cube_09 = Coordinate.cube(0.9);
  static const Coordinate cube_1 = Coordinate.cube(1);
  static const Coordinate cube_2 = Coordinate.cube(2);
  static const Coordinate cube_3 = Coordinate.cube(3);
  static const Coordinate cube_4 = Coordinate.cube(4);
  static const Coordinate cube_5 = Coordinate.cube(5);
  static const Coordinate cube_6 = Coordinate.cube(6);
  static const Coordinate cube_7 = Coordinate.cube(7);
  static const Coordinate cube_8 = Coordinate.cube(8);
  static const Coordinate cube_9 = Coordinate.cube(9);
  static const Coordinate cube_10 = Coordinate.cube(10);
  static const Coordinate cube_100 = Coordinate.cube(100);
  static const Coordinate x100 = Coordinate(100, 0, 0);
  static const Coordinate y100 = Coordinate(0, 100, 0);
  static const Coordinate z100 = Coordinate(0, 0, 100);

  ///
  /// it implement in 'my coordinate system', not 'dart coordinate system' ([Transform], [Matrix4], [Coordinate2D]], ...)
  /// see the comment above [transferToTransformOf] to understand more.
  ///
  factory Coordinate.fromDirection(
    CoordinateRadian direction, [
    double distance = 1,
  ]) {
    final rX = direction.dx;
    final rY = direction.dy;
    final rZ = direction.dz;
    final d = distance * DoubleExtension.sqrt1_3;
    return Coordinate(
      d * (math.cos(rZ) * math.cos(rY)),
      d * (math.sin(rZ) * math.cos(rX)),
      d * (math.sin(rX) * math.sin(rY)),
    );
  }

  static Coordinate maxDistance(Coordinate a, Coordinate b) =>
      a.distance > b.distance ? a : b;

  ///
  ///
  /// [Coordinate.transferToTransformOf] transfer from my coordinate system:
  /// x axis is [Direction3DIn6.left] -> [Direction3DIn6.right], radian start from [Direction3DIn6.back]
  /// y axis is [Direction3DIn6.front] -> [Direction3DIn6.back], radian start from [Direction3DIn6.left]
  /// z axis is [Direction3DIn6.bottom] -> [Direction3DIn6.top], radian start from [Direction3DIn6.right]
  ///
  /// to "dart coordinate system" ([Transform], [Matrix4], [Coordinate2D]], ...):
  /// x axis is [Direction3DIn6.left] -> [Direction3DIn6.right], radian start from [Direction3DIn6.back] ?
  /// y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom], radian start from [Direction3DIn6.left] ?
  /// z axis is [Direction3DIn6.front] -> [Direction3DIn6.back], radian start from [Direction3DIn6.right]
  ///
  ///
  /// See Also:
  ///   * [Coordinate2D.fromDirection], [Coordinate.fromDirection]
  ///   * [Direction], [Direction3DIn6]
  ///
  static Coordinate transferToTransformOf(Coordinate p) =>
      Coordinate(p.dx, -p.dz, -p.dy);
}

///
///
///
/// [CoordinateRadian]
///
///
///

///
///
/// [CoordinateRadian.circle], [CoordinateRadian.ofX], [CoordinateRadian.ofY], [CoordinateRadian.ofZ]; [CoordinateRadian.ofXY], [CoordinateRadian.ofYZ], [CoordinateRadian.ofXZ]
/// [modulus90Angle], [modulus180Angle], [modulus360Angle]
/// [zero], [angleX_1], [angleY_1], [angleZ_1]...
///
class CoordinateRadian extends Coordinate {
  const CoordinateRadian(super.dx, super.dy, super.dz);

  const CoordinateRadian.circle(super.dimension) : super.cube();

  const CoordinateRadian.ofX(super.dx) : super.ofX();

  const CoordinateRadian.ofY(super.dy) : super.ofY();

  const CoordinateRadian.ofZ(super.dz) : super.ofZ();

  const CoordinateRadian.ofXY(super.value) : super.ofXY();

  const CoordinateRadian.ofYZ(super.value) : super.ofYZ();

  const CoordinateRadian.ofXZ(super.value) : super.ofXZ();

  @override
  CoordinateRadian operator +(covariant CoordinateRadian other) =>
      CoordinateRadian(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  CoordinateRadian operator -(covariant CoordinateRadian other) =>
      CoordinateRadian(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  CoordinateRadian operator *(double operand) =>
      CoordinateRadian(dx * operand, dy * operand, dz * operand);

  @override
  CoordinateRadian operator /(double operand) =>
      CoordinateRadian(dx / operand, dy / operand, dz / operand);

  ///
  /// getters
  ///
  CoordinateRadian get modulus90Angle => CoordinateRadian(
        Radian.modulus90AngleOf(dx),
        Radian.modulus90AngleOf(dy),
        Radian.modulus90AngleOf(dz),
      );

  CoordinateRadian get modulus180Angle => CoordinateRadian(
        Radian.modulus180AngleOf(dx),
        Radian.modulus180AngleOf(dy),
        Radian.modulus180AngleOf(dz),
      );

  CoordinateRadian get modulus360Angle => CoordinateRadian(
        Radian.modulus360AngleOf(dx),
        Radian.modulus360AngleOf(dy),
        Radian.modulus360AngleOf(dz),
      );

  CoordinateRadian get restrict180AbsAngle => CoordinateRadian(
        Radian.restrict180AbsForAngle(dx),
        Radian.restrict180AbsForAngle(dy),
        Radian.restrict180AbsForAngle(dz),
      );

  ///
  /// [complementary], [supplementary]
  ///
  CoordinateRadian get complementary => CoordinateRadian(
        Radian.complementaryOf(dx),
        Radian.complementaryOf(dy),
        Radian.complementaryOf(dz),
      );

  CoordinateRadian get supplementary => CoordinateRadian(
        Radian.supplementaryOf(dx),
        Radian.supplementaryOf(dy),
        Radian.supplementaryOf(dz),
      );

  Coordinate get toAngle =>
      Coordinate(Radian.angleOf(dx), Radian.angleOf(dy), Radian.angleOf(dz));

  Coordinate get toRound =>
      Coordinate(Radian.roundOf(dx), Radian.roundOf(dy), Radian.roundOf(dz));

  ///
  /// constants
  ///
  static const zero = CoordinateRadian.circle(0);
  static const angleX_360 = CoordinateRadian.ofX(Radian.angle_360);
  static const angleY_360 = CoordinateRadian.ofY(Radian.angle_360);
  static const angleZ_360 = CoordinateRadian.ofZ(Radian.angle_360);
  static const angleXYZ_360 = CoordinateRadian.circle(Radian.angle_360);
  static const angleXY_360 = CoordinateRadian.ofXY(Radian.angle_360);
  static const angleX_270 = CoordinateRadian.ofX(Radian.angle_270);
  static const angleY_270 = CoordinateRadian.ofY(Radian.angle_270);
  static const angleZ_270 = CoordinateRadian.ofZ(Radian.angle_270);
  static const angleXYZ_270 = CoordinateRadian.circle(Radian.angle_270);
  static const angleXY_270 = CoordinateRadian.ofXY(Radian.angle_270);
  static const angleX_180 = CoordinateRadian.ofX(Radian.angle_180);
  static const angleY_180 = CoordinateRadian.ofY(Radian.angle_180);
  static const angleZ_180 = CoordinateRadian.ofZ(Radian.angle_180);
  static const angleXYZ_180 = CoordinateRadian.circle(Radian.angle_180);
  static const angleXY_180 = CoordinateRadian.ofXY(Radian.angle_180);
  static const angleX_120 = CoordinateRadian.ofX(Radian.angle_120);
  static const angleY_120 = CoordinateRadian.ofY(Radian.angle_120);
  static const angleZ_120 = CoordinateRadian.ofZ(Radian.angle_120);
  static const angleZ_150 = CoordinateRadian.ofZ(Radian.angle_150);
  static const angleXYZ_120 = CoordinateRadian.circle(Radian.angle_120);
  static const angleXY_120 = CoordinateRadian.ofXY(Radian.angle_120);
  static const angleX_90 = CoordinateRadian.ofX(Radian.angle_90);
  static const angleY_90 = CoordinateRadian.ofY(Radian.angle_90);
  static const angleZ_90 = CoordinateRadian.ofZ(Radian.angle_90);
  static const angleXYZ_90 = CoordinateRadian.circle(Radian.angle_90);
  static const angleXY_90 = CoordinateRadian.ofXY(Radian.angle_90);
  static const angleYZ_90 = CoordinateRadian.ofYZ(Radian.angle_90);
  static const angleXZ_90 = CoordinateRadian.ofXZ(Radian.angle_90);
  static const angleX_60 = CoordinateRadian.ofX(Radian.angle_60);
  static const angleY_60 = CoordinateRadian.ofY(Radian.angle_60);
  static const angleZ_60 = CoordinateRadian.ofZ(Radian.angle_60);
  static const angleXYZ_60 = CoordinateRadian.circle(Radian.angle_60);
  static const angleXY_60 = CoordinateRadian.ofXY(Radian.angle_60);
  static const angleX_45 = CoordinateRadian.ofX(Radian.angle_45);
  static const angleY_45 = CoordinateRadian.ofY(Radian.angle_45);
  static const angleZ_45 = CoordinateRadian.ofZ(Radian.angle_45);
  static const angleXYZ_45 = CoordinateRadian.circle(Radian.angle_45);
  static const angleXY_45 = CoordinateRadian.ofXY(Radian.angle_45);
  static const angleX_30 = CoordinateRadian.ofX(Radian.angle_30);
  static const angleY_30 = CoordinateRadian.ofY(Radian.angle_30);
  static const angleZ_30 = CoordinateRadian.ofZ(Radian.angle_30);
  static const angleXYZ_30 = CoordinateRadian.circle(Radian.angle_30);
  static const angleXY_30 = CoordinateRadian.ofXY(Radian.angle_30);
  static const angleX_15 = CoordinateRadian.ofX(Radian.angle_15);
  static const angleY_15 = CoordinateRadian.ofY(Radian.angle_15);
  static const angleZ_15 = CoordinateRadian.ofZ(Radian.angle_15);
  static const angleXYZ_15 = CoordinateRadian.circle(Radian.angle_15);
  static const angleXY_15 = CoordinateRadian.ofXY(Radian.angle_15);
  static const angleX_10 = CoordinateRadian.ofX(Radian.angle_10);
  static const angleY_10 = CoordinateRadian.ofY(Radian.angle_10);
  static const angleZ_10 = CoordinateRadian.ofZ(Radian.angle_10);
  static const angleXYZ_10 = CoordinateRadian.circle(Radian.angle_10);
  static const angleXY_10 = CoordinateRadian.ofXY(Radian.angle_10);
  static const angleX_1 = CoordinateRadian.ofX(Radian.angle_1);
  static const angleY_1 = CoordinateRadian.ofY(Radian.angle_1);
  static const angleZ_1 = CoordinateRadian.ofZ(Radian.angle_1);
  static const angleXYZ_1 = CoordinateRadian.circle(Radian.angle_1);
  static const angleXY_1 = CoordinateRadian.ofXY(Radian.angle_1);
  static const angleX_01 = CoordinateRadian.ofX(Radian.angle_01);
  static const angleY_01 = CoordinateRadian.ofY(Radian.angle_01);
  static const angleZ_01 = CoordinateRadian.ofZ(Radian.angle_01);
  static const angleXYZ_01 = CoordinateRadian.circle(Radian.angle_01);
  static const angleXY_01 = CoordinateRadian.ofXY(Radian.angle_01);
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
  final CoordinateRadian direction;
  final double distance;

  const Vector3D(this.direction, this.distance);

  Coordinate2D get toCoordinate2D =>
      Coordinate2D.fromDirection(-direction.dy, distance);

  Coordinate get toCoordinate => Coordinate.fromDirection(
        direction,
        distance,
      );

  Vector3D rotated(CoordinateRadian d) => Vector3D(direction + d, distance);

  @override
  String toString() => "Vector($direction, $distance)";

  static Vector3D lerp(Vector3D begin, Vector3D end, double t) => Vector3D(
        begin.direction + (end.direction - begin.direction) * t,
        begin.distance + (end.distance - begin.distance) * t,
      );

  static Translator<double, Vector3D> lerpOf(Vector3D begin, Vector3D end) {
    final direction = end.direction - begin.direction;
    final distance = end.distance - begin.distance;
    final directionOf = FMapper.lerpOf<CoordinateRadian>(
      begin.direction,
      end.direction,
      (t) => direction * t,
    );
    final distanceOf = FMapper.lerpOf<double>(
      begin.distance,
      end.distance,
      (t) => distance * t,
    );
    return (t) => Vector3D(directionOf(t), distanceOf(t));
  }
}

///
///
///
/// [Direction], ...
///
/// [Direction3DIn6] and "dart direction" ([Transform], [Matrix4], [Coordinate2D] direction) are different.
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
///   * [Coordinate.transferToTransformOf], [Coordinate.fromDirection]
///
///
///

///
///
sealed class Direction<D> {
  D get flipped;

  Coordinate2D get toCoordinate2D;

  Coordinate get toCoordinate;

  static const radian2D_right = 0;
  static const radian2D_bottomRight = Radian.angle_45;
  static const radian2D_bottom = Radian.angle_90;
  static const radian2D_bottomLeft = Radian.angle_135;
  static const radian2D_left = Radian.angle_180;
  static const radian2D_topLeft = Radian.angle_225;
  static const radian2D_top = Radian.angle_270;
  static const radian2D_topRight = Radian.angle_315;

  static const Coordinate2D_top = Coordinate2D(0, -1);
  static const Coordinate2D_left = Coordinate2D(-1, 0);
  static const Coordinate2D_right = Coordinate2D(1, 0);
  static const Coordinate2D_bottom = Coordinate2D(0, 1);
  static const Coordinate2D_center = Coordinate2D.zero;
  static const Coordinate2D_topLeft =
      Coordinate2D(-math.sqrt1_2, -math.sqrt1_2);
  static const Coordinate2D_topRight =
      Coordinate2D(math.sqrt1_2, -math.sqrt1_2);
  static const Coordinate2D_bottomLeft =
      Coordinate2D(-math.sqrt1_2, math.sqrt1_2);
  static const Coordinate2D_bottomRight =
      Coordinate2D(math.sqrt1_2, math.sqrt1_2);

  static const coordinate_center = Coordinate.zero;
  static const coordinate_left = Coordinate.ofX(-1);
  static const coordinate_top = Coordinate.ofY(-1);
  static const coordinate_right = Coordinate.ofX(1);
  static const coordinate_bottom = Coordinate.ofY(1);
  static const coordinate_front = Coordinate.ofZ(1);
  static const coordinate_back = Coordinate.ofZ(-1);

  static const coordinate_topLeft = Coordinate.ofXY(-math.sqrt1_2);
  static const coordinate_bottomRight = Coordinate.ofXY(math.sqrt1_2);
  static const coordinate_frontRight = Coordinate.ofXZ(math.sqrt1_2);
  static const coordinate_frontBottom = Coordinate.ofYZ(math.sqrt1_2);
  static const coordinate_backLeft = Coordinate.ofXZ(-math.sqrt1_2);
  static const coordinate_backTop = Coordinate.ofYZ(-math.sqrt1_2);
  static const coordinate_topRight = Coordinate(math.sqrt1_2, -math.sqrt1_2, 0);
  static const coordinate_frontTop = Coordinate(0, -math.sqrt1_2, math.sqrt1_2);
  static const coordinate_bottomLeft =
      Coordinate(-math.sqrt1_2, math.sqrt1_2, 0);
  static const coordinate_frontLeft =
      Coordinate(-math.sqrt1_2, 0, math.sqrt1_2);
  static const coordinate_backRight =
      Coordinate(math.sqrt1_2, 0, -math.sqrt1_2);
  static const coordinate_backBottom =
      Coordinate(0, math.sqrt1_2, -math.sqrt1_2);

  static const coordinate_frontTopLeft = Coordinate(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontTopRight = Coordinate(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomLeft = Coordinate(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomRight = Coordinate(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_backTopLeft = Coordinate(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backTopRight = Coordinate(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomLeft = Coordinate(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomRight = Coordinate(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
}

sealed class Direction2D<D extends Direction2D<D>> implements Direction<D> {
}

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

  Direction2DIn8 get toDirection8 => switch (this) {
        Direction2DIn4.left => Direction2DIn8.left,
        Direction2DIn4.top => Direction2DIn8.top,
        Direction2DIn4.right => Direction2DIn8.right,
        Direction2DIn4.bottom => Direction2DIn8.bottom,
      };

  @override
  Coordinate2D get toCoordinate2D => toDirection8.toCoordinate2D;

  @override
  Coordinate get toCoordinate => toDirection8.toCoordinate;

}

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
  Coordinate2D get toCoordinate2D => switch (this) {
        top => Direction.Coordinate2D_top,
        left => Direction.Coordinate2D_left,
        right => Direction.Coordinate2D_right,
        bottom => Direction.Coordinate2D_bottom,
        topLeft => Direction.Coordinate2D_topLeft,
        topRight => Direction.Coordinate2D_topRight,
        bottomLeft => Direction.Coordinate2D_bottomLeft,
        bottomRight => Direction.Coordinate2D_bottomRight,
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        top => Direction.coordinate_top,
        left => Direction.coordinate_left,
        right => Direction.coordinate_right,
        bottom => Direction.coordinate_bottom,
        topLeft => Direction.coordinate_topLeft,
        topRight => Direction.coordinate_topRight,
        bottomLeft => Direction.coordinate_bottomLeft,
        bottomRight => Direction.coordinate_bottomRight,
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
/// [Direction3DIn6], [Direction3DIn14], [Direction3DIn22]
///
///
///
///

sealed class Direction3D<D extends Direction3D<D>> implements Direction<D> {}

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
  Coordinate2D get toCoordinate2D => switch (this) {
        Direction3DIn6.left => Direction.Coordinate2D_left,
        Direction3DIn6.top => Direction.Coordinate2D_top,
        Direction3DIn6.right => Direction.Coordinate2D_right,
        Direction3DIn6.bottom => Direction.Coordinate2D_bottom,
        _ => throw UnimplementedError(),
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        Direction3DIn6.left => Direction.coordinate_left,
        Direction3DIn6.top => Direction.coordinate_top,
        Direction3DIn6.right => Direction.coordinate_right,
        Direction3DIn6.bottom => Direction.coordinate_bottom,
        Direction3DIn6.front => Direction.coordinate_front,
        Direction3DIn6.back => Direction.coordinate_back,
      };

  ///
  /// The angle value belows are "[Matrix4] radian". see [Coordinate.fromDirection] for my "math radian".
  ///
  /// [front] can be seen within {angleY(-90 ~ 90), angleX(-90 ~ 90)}
  /// [left] can be seen within {angleY(0 ~ -180), angleZ(-90 ~ 90)}
  /// [top] can be seen within {angleX(0 ~ 180), angleZ(-90 ~ 90)}
  /// [back] can be seen while [front] not be seen.
  /// [right] can be seen while [left] not be seen.
  /// [bottom] can be seen while [top] not be seen.
  ///
  ///
  static List<Direction3DIn6> parseRotation(CoordinateRadian radian) {
    // ?
    final r = radian.restrict180AbsAngle;

    final rX = r.dx;
    final rY = r.dy;
    final rZ = r.dz;

    return <Direction3DIn6>[
      Radian.ifWithinAngle90_90N(rY) && Radian.ifWithinAngle90_90N(rX)
          ? Direction3DIn6.front
          : Direction3DIn6.back,
      Radian.ifWithinAngle0_180N(rY) && Radian.ifWithinAngle90_90N(rZ)
          ? Direction3DIn6.left
          : Direction3DIn6.right,
      Radian.ifWithinAngle0_180(rX) && Radian.ifWithinAngle90_90N(rZ)
          ? Direction3DIn6.top
          : Direction3DIn6.bottom,
    ];
  }
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
  Coordinate2D get toCoordinate2D => switch (this) {
        Direction3DIn14.left => Direction.Coordinate2D_left,
        Direction3DIn14.top => Direction.Coordinate2D_top,
        Direction3DIn14.right => Direction.Coordinate2D_right,
        Direction3DIn14.bottom => Direction.Coordinate2D_bottom,
        _ => throw UnimplementedError(),
      };

  @override
  Coordinate get toCoordinate => switch (this) {
        Direction3DIn14.left => Direction.coordinate_left,
        Direction3DIn14.top => Direction.coordinate_top,
        Direction3DIn14.right => Direction.coordinate_right,
        Direction3DIn14.bottom => Direction.coordinate_bottom,
        Direction3DIn14.front => Direction.coordinate_front,
        Direction3DIn14.frontLeft => Direction.coordinate_frontLeft,
        Direction3DIn14.frontTop => Direction.coordinate_frontTop,
        Direction3DIn14.frontRight => Direction.coordinate_frontRight,
        Direction3DIn14.frontBottom => Direction.coordinate_frontBottom,
        Direction3DIn14.back => Direction.coordinate_back,
        Direction3DIn14.backLeft => Direction.coordinate_backLeft,
        Direction3DIn14.backTop => Direction.coordinate_backTop,
        Direction3DIn14.backRight => Direction.coordinate_backRight,
        Direction3DIn14.backBottom => Direction.coordinate_backBottom,
      };

  double get scaleOnGrid => switch (this) {
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

// enum Direction3DIn22 implements Direction3D<Direction3DIn22>{
//   top;
// }

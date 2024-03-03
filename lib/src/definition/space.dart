///
///
/// this file contains:
///
/// [Coordinate2D]
/// [Coordinate3D]
/// [Radian3D]
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
/// [Coordinate3D]
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
/// [Coordinate3D.zero], [Coordinate3D.one]
/// [maxDistance], [transferToTransformOf],
///
///
class Coordinate3D extends Coordinate2D {
  final double dz;

  bool get isNot3D => (dz == 0 || dx == 0 || dy == 0);

  bool get isNegative => (dz < 0 && dx < 0 && dy < 0);

  bool get hasNegative => (dz < 0 || dx < 0 || dy < 0);

  bool get withoutXY => (dx == 0 && dy == 0);

  Coordinate3D get retainXY => Coordinate3D(dx, dy, 0);

  Coordinate3D get retainYZAsYX => Coordinate3D(dz, dy, 0);

  Coordinate3D get retainYZAsXY => Coordinate3D(dy, dz, 0);

  Coordinate3D get retainXZAsXY => Coordinate3D(dx, dz, 0);

  Coordinate3D get retainXZAsYX => Coordinate3D(dz, dx, 0);

  Coordinate3D get roundToDouble => Coordinate3D(
        dx.roundToDouble(),
        dy.roundToDouble(),
        dz.roundToDouble(),
      );

  Coordinate3D get abs => Coordinate3D(dx.abs(), dy.abs(), dz.abs());

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

  Radian3D get direction3D => throw UnimplementedError();

  @override
  Coordinate3D operator +(covariant Coordinate3D other) =>
      Coordinate3D(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Coordinate3D operator -(covariant Coordinate3D other) =>
      Coordinate3D(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Coordinate3D operator -() => Coordinate3D(-dx, -dy, -dz);

  @override
  Coordinate3D operator *(double operand) => Coordinate3D(
        dx * operand,
        dy * operand,
        dz * operand,
      );

  @override
  Coordinate3D operator /(double operand) => Coordinate3D(
        dx / operand,
        dy / operand,
        dz / operand,
      );

  @override
  Coordinate3D operator ~/(double operand) => Coordinate3D(
        (dx ~/ operand).toDouble(),
        (dy ~/ operand).toDouble(),
        (dz ~/ operand).toDouble(),
      );

  @override
  Coordinate3D operator %(double operand) => Coordinate3D(
        dx % operand,
        dy % operand,
        dz % operand,
      );

  @override
  bool operator <(covariant Coordinate3D other) =>
      dz < other.dz && (super < other);

  @override
  bool operator <=(covariant Coordinate3D other) =>
      dz <= other.dz && (super <= other);

  @override
  bool operator >(covariant Coordinate3D other) =>
      dz > other.dz && (super > other);

  @override
  bool operator >=(covariant Coordinate3D other) =>
      dz >= other.dz && (super >= other);

  @override
  bool operator ==(covariant Coordinate3D other) =>
      dz == other.dz && (super == other);

  @override
  int get hashCode => Object.hash(super.hashCode, dz);

  @override
  Coordinate3D scale(
    double scaleX,
    double scaleY, {
    double scaleZ = 0,
  }) =>
      Coordinate3D(dx * scaleX, dy * scaleY, dz * scaleZ);

  Coordinate3D scaleCoordinate(Coordinate3D scale) =>
      this.scale(scale.dx, scale.dy, scaleZ: scale.dz);

  @override
  Coordinate3D translate(
    double translateX,
    double translateY, {
    double translateZ = 0,
  }) =>
      Coordinate3D(dx + translateX, dy + translateY, dz + translateZ);

  Coordinate3D rotate(Radian3D direction) =>
      Coordinate3D.fromDirection(direction3D + direction, distance);

  @override
  String toString() => 'Coordinate('
      '${dx.toStringAsFixed(1)}, '
      '${dy.toStringAsFixed(1)}, '
      '${dz.toStringAsFixed(1)})';

  const Coordinate3D(super.dx, super.dy, this.dz);

  const Coordinate3D.cube(double dimension)
      : dz = dimension,
        super(dimension, dimension);

  const Coordinate3D.ofX(double x)
      : dz = 0,
        super(x, 0);

  const Coordinate3D.ofY(double y)
      : dz = 0,
        super(0, y);

  const Coordinate3D.ofZ(double z)
      : dz = z,
        super(0, 0);

  const Coordinate3D.ofXY(double value)
      : dz = 0,
        super(value, value);

  const Coordinate3D.ofYZ(double value)
      : dz = value,
        super(0, value);

  const Coordinate3D.ofXZ(double value)
      : dz = value,
        super(value, 0);

  //
  Coordinate3D.fromCoordinate2D(Coordinate2D Coordinate2D)
      : dz = 0,
        super(Coordinate2D.dx, Coordinate2D.dy);

  static const Coordinate3D zero = Coordinate3D.cube(0);
  static const Coordinate3D one = Coordinate3D.cube(1);
  static const Coordinate3D cube_01 = Coordinate3D.cube(0.1);
  static const Coordinate3D cube_02 = Coordinate3D.cube(0.2);
  static const Coordinate3D cube_03 = Coordinate3D.cube(0.3);
  static const Coordinate3D cube_04 = Coordinate3D.cube(0.4);
  static const Coordinate3D cube_05 = Coordinate3D.cube(0.5);
  static const Coordinate3D cube_06 = Coordinate3D.cube(0.6);
  static const Coordinate3D cube_07 = Coordinate3D.cube(0.7);
  static const Coordinate3D cube_08 = Coordinate3D.cube(0.8);
  static const Coordinate3D cube_09 = Coordinate3D.cube(0.9);
  static const Coordinate3D cube_1 = Coordinate3D.cube(1);
  static const Coordinate3D cube_2 = Coordinate3D.cube(2);
  static const Coordinate3D cube_3 = Coordinate3D.cube(3);
  static const Coordinate3D cube_4 = Coordinate3D.cube(4);
  static const Coordinate3D cube_5 = Coordinate3D.cube(5);
  static const Coordinate3D cube_6 = Coordinate3D.cube(6);
  static const Coordinate3D cube_7 = Coordinate3D.cube(7);
  static const Coordinate3D cube_8 = Coordinate3D.cube(8);
  static const Coordinate3D cube_9 = Coordinate3D.cube(9);
  static const Coordinate3D cube_10 = Coordinate3D.cube(10);
  static const Coordinate3D cube_100 = Coordinate3D.cube(100);
  static const Coordinate3D x100 = Coordinate3D(100, 0, 0);
  static const Coordinate3D y100 = Coordinate3D(0, 100, 0);
  static const Coordinate3D z100 = Coordinate3D(0, 0, 100);

  ///
  /// it implement in 'my coordinate system', not 'dart coordinate system' ([Transform], [Matrix4], [Coordinate2D]], ...)
  /// see the comment above [transferToTransformOf] to understand more.
  ///
  factory Coordinate3D.fromDirection(
    Radian3D direction, [
    double distance = 1,
  ]) {
    final rX = direction.dx;
    final rY = direction.dy;
    final rZ = direction.dz;
    final d = distance * DoubleExtension.sqrt1_3;
    return Coordinate3D(
      d * (math.cos(rZ) * math.cos(rY)),
      d * (math.sin(rZ) * math.cos(rX)),
      d * (math.sin(rX) * math.sin(rY)),
    );
  }

  static Coordinate3D maxDistance(Coordinate3D a, Coordinate3D b) =>
      a.distance > b.distance ? a : b;

  ///
  ///
  /// [Coordinate3D.transferToTransformOf] transfer from my coordinate system:
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
  static Coordinate3D transferToTransformOf(Coordinate3D p) =>
      Coordinate3D(p.dx, -p.dz, -p.dy);
}

///
///
///
/// [Radian3D]
///
///
///

///
///
/// [Radian3D.circle], [Radian3D.ofX], [Radian3D.ofY], [Radian3D.ofZ]; [Radian3D.ofXY], [Radian3D.ofYZ], [Radian3D.ofXZ]
/// [modulus90Angle], [modulus180Angle], [modulus360Angle]
/// [zero], [angleX_1], [angleY_1], [angleZ_1]...
///
class Radian3D extends Coordinate3D {
  const Radian3D(super.dx, super.dy, super.dz);

  const Radian3D.circle(super.dimension) : super.cube();

  const Radian3D.ofX(super.dx) : super.ofX();

  const Radian3D.ofY(super.dy) : super.ofY();

  const Radian3D.ofZ(super.dz) : super.ofZ();

  const Radian3D.ofXY(super.value) : super.ofXY();

  const Radian3D.ofYZ(super.value) : super.ofYZ();

  const Radian3D.ofXZ(super.value) : super.ofXZ();

  @override
  Radian3D operator +(covariant Radian3D other) =>
      Radian3D(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Radian3D operator -(covariant Radian3D other) =>
      Radian3D(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Radian3D operator *(double operand) =>
      Radian3D(dx * operand, dy * operand, dz * operand);

  @override
  Radian3D operator /(double operand) =>
      Radian3D(dx / operand, dy / operand, dz / operand);

  ///
  /// getters
  ///
  Radian3D get modulus90Angle => Radian3D(
        Radian.modulus90AngleOf(dx),
        Radian.modulus90AngleOf(dy),
        Radian.modulus90AngleOf(dz),
      );

  Radian3D get modulus180Angle => Radian3D(
        Radian.modulus180AngleOf(dx),
        Radian.modulus180AngleOf(dy),
        Radian.modulus180AngleOf(dz),
      );

  Radian3D get modulus360Angle => Radian3D(
        Radian.modulus360AngleOf(dx),
        Radian.modulus360AngleOf(dy),
        Radian.modulus360AngleOf(dz),
      );

  Radian3D get restrict180AbsAngle => Radian3D(
        Radian.restrict180AbsForAngle(dx),
        Radian.restrict180AbsForAngle(dy),
        Radian.restrict180AbsForAngle(dz),
      );

  ///
  /// [complementary], [supplementary]
  ///
  Radian3D get complementary => Radian3D(
        Radian.complementaryOf(dx),
        Radian.complementaryOf(dy),
        Radian.complementaryOf(dz),
      );

  Radian3D get supplementary => Radian3D(
        Radian.supplementaryOf(dx),
        Radian.supplementaryOf(dy),
        Radian.supplementaryOf(dz),
      );

  Coordinate3D get toAngle =>
      Coordinate3D(Radian.angleOf(dx), Radian.angleOf(dy), Radian.angleOf(dz));

  Coordinate3D get toRound =>
      Coordinate3D(Radian.roundOf(dx), Radian.roundOf(dy), Radian.roundOf(dz));

  ///
  /// constants
  ///
  static const zero = Radian3D.circle(0);
  static const angleX_360 = Radian3D.ofX(Radian.angle_360);
  static const angleY_360 = Radian3D.ofY(Radian.angle_360);
  static const angleZ_360 = Radian3D.ofZ(Radian.angle_360);
  static const angleXYZ_360 = Radian3D.circle(Radian.angle_360);
  static const angleXY_360 = Radian3D.ofXY(Radian.angle_360);
  static const angleX_270 = Radian3D.ofX(Radian.angle_270);
  static const angleY_270 = Radian3D.ofY(Radian.angle_270);
  static const angleZ_270 = Radian3D.ofZ(Radian.angle_270);
  static const angleXYZ_270 = Radian3D.circle(Radian.angle_270);
  static const angleXY_270 = Radian3D.ofXY(Radian.angle_270);
  static const angleX_180 = Radian3D.ofX(Radian.angle_180);
  static const angleY_180 = Radian3D.ofY(Radian.angle_180);
  static const angleZ_180 = Radian3D.ofZ(Radian.angle_180);
  static const angleXYZ_180 = Radian3D.circle(Radian.angle_180);
  static const angleXY_180 = Radian3D.ofXY(Radian.angle_180);
  static const angleX_120 = Radian3D.ofX(Radian.angle_120);
  static const angleY_120 = Radian3D.ofY(Radian.angle_120);
  static const angleZ_120 = Radian3D.ofZ(Radian.angle_120);
  static const angleZ_150 = Radian3D.ofZ(Radian.angle_150);
  static const angleXYZ_120 = Radian3D.circle(Radian.angle_120);
  static const angleXY_120 = Radian3D.ofXY(Radian.angle_120);
  static const angleX_90 = Radian3D.ofX(Radian.angle_90);
  static const angleY_90 = Radian3D.ofY(Radian.angle_90);
  static const angleZ_90 = Radian3D.ofZ(Radian.angle_90);
  static const angleXYZ_90 = Radian3D.circle(Radian.angle_90);
  static const angleXY_90 = Radian3D.ofXY(Radian.angle_90);
  static const angleYZ_90 = Radian3D.ofYZ(Radian.angle_90);
  static const angleXZ_90 = Radian3D.ofXZ(Radian.angle_90);
  static const angleX_60 = Radian3D.ofX(Radian.angle_60);
  static const angleY_60 = Radian3D.ofY(Radian.angle_60);
  static const angleZ_60 = Radian3D.ofZ(Radian.angle_60);
  static const angleXYZ_60 = Radian3D.circle(Radian.angle_60);
  static const angleXY_60 = Radian3D.ofXY(Radian.angle_60);
  static const angleX_45 = Radian3D.ofX(Radian.angle_45);
  static const angleY_45 = Radian3D.ofY(Radian.angle_45);
  static const angleZ_45 = Radian3D.ofZ(Radian.angle_45);
  static const angleXYZ_45 = Radian3D.circle(Radian.angle_45);
  static const angleXY_45 = Radian3D.ofXY(Radian.angle_45);
  static const angleX_30 = Radian3D.ofX(Radian.angle_30);
  static const angleY_30 = Radian3D.ofY(Radian.angle_30);
  static const angleZ_30 = Radian3D.ofZ(Radian.angle_30);
  static const angleXYZ_30 = Radian3D.circle(Radian.angle_30);
  static const angleXY_30 = Radian3D.ofXY(Radian.angle_30);
  static const angleX_15 = Radian3D.ofX(Radian.angle_15);
  static const angleY_15 = Radian3D.ofY(Radian.angle_15);
  static const angleZ_15 = Radian3D.ofZ(Radian.angle_15);
  static const angleXYZ_15 = Radian3D.circle(Radian.angle_15);
  static const angleXY_15 = Radian3D.ofXY(Radian.angle_15);
  static const angleX_10 = Radian3D.ofX(Radian.angle_10);
  static const angleY_10 = Radian3D.ofY(Radian.angle_10);
  static const angleZ_10 = Radian3D.ofZ(Radian.angle_10);
  static const angleXYZ_10 = Radian3D.circle(Radian.angle_10);
  static const angleXY_10 = Radian3D.ofXY(Radian.angle_10);
  static const angleX_1 = Radian3D.ofX(Radian.angle_1);
  static const angleY_1 = Radian3D.ofY(Radian.angle_1);
  static const angleZ_1 = Radian3D.ofZ(Radian.angle_1);
  static const angleXYZ_1 = Radian3D.circle(Radian.angle_1);
  static const angleXY_1 = Radian3D.ofXY(Radian.angle_1);
  static const angleX_01 = Radian3D.ofX(Radian.angle_01);
  static const angleY_01 = Radian3D.ofY(Radian.angle_01);
  static const angleZ_01 = Radian3D.ofZ(Radian.angle_01);
  static const angleXYZ_01 = Radian3D.circle(Radian.angle_01);
  static const angleXY_01 = Radian3D.ofXY(Radian.angle_01);
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
  final Radian3D direction;
  final double distance;

  const Vector3D(this.direction, this.distance);

  Coordinate2D get toCoordinate2D =>
      Coordinate2D.fromDirection(-direction.dy, distance);

  Coordinate3D get toCoordinate => Coordinate3D.fromDirection(
        direction,
        distance,
      );

  Vector3D rotated(Radian3D d) => Vector3D(direction + d, distance);

  @override
  String toString() => "Vector($direction, $distance)";

  static Vector3D lerp(Vector3D begin, Vector3D end, double t) => Vector3D(
        begin.direction + (end.direction - begin.direction) * t,
        begin.distance + (end.distance - begin.distance) * t,
      );

  static Translator<double, Vector3D> lerpOf(Vector3D begin, Vector3D end) {
    final direction = end.direction - begin.direction;
    final distance = end.distance - begin.distance;
    final directionOf = FMapper.lerpOf<Radian3D>(
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
///   * [Coordinate3D.transferToTransformOf], [Coordinate.fromDirection]
///
///
///

///
///
sealed class Direction<D> {
  D get flipped;

  Coordinate2D get toCoordinate2D;

  Coordinate3D get toCoordinate;

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

  static const coordinate_center = Coordinate3D.zero;
  static const coordinate_left = Coordinate3D.ofX(-1);
  static const coordinate_top = Coordinate3D.ofY(-1);
  static const coordinate_right = Coordinate3D.ofX(1);
  static const coordinate_bottom = Coordinate3D.ofY(1);
  static const coordinate_front = Coordinate3D.ofZ(1);
  static const coordinate_back = Coordinate3D.ofZ(-1);

  static const coordinate_topLeft = Coordinate3D.ofXY(-math.sqrt1_2);
  static const coordinate_bottomRight = Coordinate3D.ofXY(math.sqrt1_2);
  static const coordinate_frontRight = Coordinate3D.ofXZ(math.sqrt1_2);
  static const coordinate_frontBottom = Coordinate3D.ofYZ(math.sqrt1_2);
  static const coordinate_backLeft = Coordinate3D.ofXZ(-math.sqrt1_2);
  static const coordinate_backTop = Coordinate3D.ofYZ(-math.sqrt1_2);
  static const coordinate_topRight = Coordinate3D(math.sqrt1_2, -math.sqrt1_2, 0);
  static const coordinate_frontTop = Coordinate3D(0, -math.sqrt1_2, math.sqrt1_2);
  static const coordinate_bottomLeft =
      Coordinate3D(-math.sqrt1_2, math.sqrt1_2, 0);
  static const coordinate_frontLeft =
      Coordinate3D(-math.sqrt1_2, 0, math.sqrt1_2);
  static const coordinate_backRight =
      Coordinate3D(math.sqrt1_2, 0, -math.sqrt1_2);
  static const coordinate_backBottom =
      Coordinate3D(0, math.sqrt1_2, -math.sqrt1_2);

  static const coordinate_frontTopLeft = Coordinate3D(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontTopRight = Coordinate3D(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomLeft = Coordinate3D(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_frontBottomRight = Coordinate3D(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const coordinate_backTopLeft = Coordinate3D(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backTopRight = Coordinate3D(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomLeft = Coordinate3D(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const coordinate_backBottomRight = Coordinate3D(DoubleExtension.sqrt1_3,
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
  Coordinate3D get toCoordinate => toDirection8.toCoordinate;

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
  Coordinate3D get toCoordinate => switch (this) {
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
  Coordinate3D get toCoordinate => switch (this) {
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
  static List<Direction3DIn6> parseRotation(Radian3D radian) {
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
  Coordinate3D get toCoordinate => switch (this) {
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

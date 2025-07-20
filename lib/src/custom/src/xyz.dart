part of '../custom.dart';

///
///
/// [RotationUnit]
/// [DirectionFrontOrBack]
/// [DirectionIn4]
/// [DirectionIn8]
/// [Quadrant2D]
///
/// [Point2], [Point3]
/// [Vector2], [Vector3]
///
///

///
///
///
enum RotationUnit { radian, angle, round }

enum DirectionFrontOrBack { front, back }

enum DirectionIn4 {
  left,
  top,
  right,
  bottom;

  DirectionIn4 get flipped => switch (this) {
    DirectionIn4.left => DirectionIn4.right,
    DirectionIn4.top => DirectionIn4.top,
    DirectionIn4.right => DirectionIn4.left,
    DirectionIn4.bottom => DirectionIn4.bottom,
  };

  DirectionIn8 get toDirection8 => switch (this) {
    DirectionIn4.left => DirectionIn8.left,
    DirectionIn4.top => DirectionIn8.top,
    DirectionIn4.right => DirectionIn8.right,
    DirectionIn4.bottom => DirectionIn8.bottom,
  };

  static DirectionIn4 verticalForward(double d) =>
      d > 0 ? DirectionIn4.bottom : DirectionIn4.top;

  static DirectionIn4 horizontalForward(double d) =>
      d > 0 ? DirectionIn4.right : DirectionIn4.left;
}

enum DirectionIn8 {
  top,
  left,
  right,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  DirectionIn8 get flipped => switch (this) {
    top => DirectionIn8.bottom,
    left => DirectionIn8.right,
    right => DirectionIn8.left,
    bottom => DirectionIn8.top,
    topLeft => DirectionIn8.bottomRight,
    topRight => DirectionIn8.bottomLeft,
    bottomLeft => DirectionIn8.topRight,
    bottomRight => DirectionIn8.topLeft,
  };

  double get distance => switch (this) {
    DirectionIn8.left ||
    DirectionIn8.top ||
    DirectionIn8.right ||
    DirectionIn8.bottom => 1,
    DirectionIn8.topLeft ||
    DirectionIn8.topRight ||
    DirectionIn8.bottomLeft ||
    DirectionIn8.bottomRight => DoubleExtension.sqrt2,
  };
}

///
///
///
enum Quadrant2D {
  topRight,
  topLeft,
  bottomLeft,
  bottomRight;

  factory Quadrant2D.fromPoint(Point2 point, [bool inFlutter = true]) {
    if (point.x == 0 || point.y == 0) throw StateError('$point on axis');
    if (inFlutter) {
      if (point.x > 0 && point.y > 0) return Quadrant2D.bottomRight;
      if (point.x < 0 && point.y > 0) return Quadrant2D.bottomLeft;
      if (point.x < 0 && point.y < 0) return Quadrant2D.topLeft;
      return Quadrant2D.topRight;
    }
    if (point.x > 0 && point.y > 0) return Quadrant2D.topRight;
    if (point.x < 0 && point.y > 0) return Quadrant2D.topLeft;
    if (point.x < 0 && point.y < 0) return Quadrant2D.bottomLeft;
    return Quadrant2D.bottomRight;
  }

  factory Quadrant2D.fromRadian(double radian, [bool inFlutter = true]) {
    // notice that -5 % 4 = 3 in dart
    final r = radian % DoubleExtension.radian_angle360;
    if (inFlutter) {
      if (r < DoubleExtension.radian_angle90) return Quadrant2D.bottomRight;
      if (r < DoubleExtension.radian_angle180) return Quadrant2D.bottomLeft;
      if (r < DoubleExtension.radian_angle270) return Quadrant2D.topLeft;
      return Quadrant2D.topRight;
    }
    if (r < DoubleExtension.radian_angle90) return Quadrant2D.topRight;
    if (r < DoubleExtension.radian_angle180) return Quadrant2D.topLeft;
    if (r < DoubleExtension.radian_angle270) return Quadrant2D.bottomLeft;
    return Quadrant2D.bottomRight;
  }

  int order([bool inFlutter = true]) =>
      inFlutter
          ? switch (this) {
            Quadrant2D.topRight => 4,
            Quadrant2D.topLeft => 3,
            Quadrant2D.bottomLeft => 2,
            Quadrant2D.bottomRight => 1,
          }
          : switch (this) {
            Quadrant2D.topRight => 1,
            Quadrant2D.topLeft => 2,
            Quadrant2D.bottomLeft => 3,
            Quadrant2D.bottomRight => 4,
          };
}

///
/// [Point2.square], ...
/// [Point2.zero], ...
/// [Point2.lerp], ...
///
final class Point2 extends _Point2<Point2> {
  const Point2(super.x, super.y);

  @override
  Point2 _instance(double x, double y) => Point2(x, y);

  @override
  int compareTo(covariant Point2 other) =>
      Point2.distance(this) < Point2.distance(other)
          ? -1
          : Point2.distance(this) > Point2.distance(other)
          ? 1
          : 0;

  const Point2.square(super.dimension) : super.square();

  const Point2.ofX(super.x) : super.ofX();

  const Point2.ofY(double y) : super.ofY(0);

  Point2.fromDirection(super.direction, [super.distance])
    : super.fromDirection();

  ///
  ///
  ///
  ///
  static const Point2 zero = Point2(0.0, 0.0);
  static const Point2 one = Point2(1.0, 1.0);
  static const Point2 top = Point2(0, -1);
  static const Point2 left = Point2(-1, 0);
  static const Point2 right = Point2(1, 0);
  static const Point2 bottom = Point2(0, 1);
  static const Point2 center = Point2.zero;
  static const Point2 topLeft = Point2.square(-math.sqrt1_2);
  static const Point2 topRight = Point2(math.sqrt1_2, -math.sqrt1_2);
  static const Point2 bottomLeft = Point2(-math.sqrt1_2, math.sqrt1_2);
  static const Point2 bottomRight = Point2.square(math.sqrt1_2);

  factory Point2.unitOfDirection(DirectionIn8 direction) => switch (direction) {
    DirectionIn8.top => Point2.top,
    DirectionIn8.left => Point2.left,
    DirectionIn8.right => Point2.right,
    DirectionIn8.bottom => Point2.bottom,
    DirectionIn8.topLeft => Point2.topLeft,
    DirectionIn8.topRight => Point2.topRight,
    DirectionIn8.bottomLeft => Point2.bottomLeft,
    DirectionIn8.bottomRight => Point2.bottomRight,
  };

  ///
  ///
  ///
  static Lerper<Point2> lerp(Point2 begin, Point2 end) =>
      (t) => Point2(
        begin.x * (1.0 - t) + end.x * t,
        begin.y * (1.0 - t) + end.y * t,
      );

  static double distance(Point2 xy) => math.sqrt(xy.x * xy.x + xy.y * xy.y);

  // radians between positive x axis to (x, y), -π ~ π
  static double directionAzimuthal(Point2 xy) => math.atan2(xy.y, xy.x);

  static Point2 maxX(Point2 a, Point2 b) => a.x < b.x ? a : b;

  static Point2 maxY(Point2 a, Point2 b) => a.y < b.y ? a : b;

  static Point2 maxAzimuthal(Point2 a, Point2 b) =>
      Point2.directionAzimuthal(a) > Point2.directionAzimuthal(b) ? a : b;
}

///
/// [Point3.ofX], ...
/// [Point3.zero], ...
/// [_instance], ...
///
final class Point3 extends _Point2<Point3> with _Mxyz<Point3>, _MxyzO<Point3> {
  @override
  final double z;

  const Point3(super.x, super.y, this.z);

  const Point3.ofX(super.x) : z = 0, super.ofX();

  const Point3.ofY(double y) : z = 0, super.ofY(0);

  const Point3.ofZ(this.z) : super.square(0);

  const Point3.ofXY(super.value) : z = 0, super.square();

  const Point3.ofYZ(super.value) : z = value, super.ofY();

  const Point3.ofXZ(super.value) : z = value, super.ofX();

  const Point3.cube(super.dimension) : z = dimension, super.square();

  factory Point3.fromDirection(
    double azimuthal,
    double polar, [
    double distance = 0,
  ]) {
    final s = math.sin(polar) * distance;
    return Point3(
      s * math.cos(azimuthal),
      s * math.sin(azimuthal),
      math.cos(polar) * distance,
    );
  }

  ///
  ///
  ///
  static const Point3 zero = Point3.cube(0);
  static const Point3 one = Point3.cube(1);
  static const Point3 center = Point3.zero;
  static const Point3 left = Point3.ofX(-1);
  static const Point3 top = Point3.ofY(-1);
  static const Point3 right = Point3.ofX(1);
  static const Point3 bottom = Point3.ofY(1);
  static const Point3 front = Point3.ofZ(1);
  static const Point3 back = Point3.ofZ(-1);

  static const Point3 topLeft = Point3.ofXY(-math.sqrt1_2);
  static const Point3 bottomRight = Point3.ofXY(math.sqrt1_2);
  static const Point3 frontRight = Point3.ofXZ(math.sqrt1_2);
  static const Point3 frontBottom = Point3.ofYZ(math.sqrt1_2);
  static const Point3 backLeft = Point3.ofXZ(-math.sqrt1_2);
  static const Point3 backTop = Point3.ofYZ(-math.sqrt1_2);
  static const Point3 topRight = Point3(math.sqrt1_2, -math.sqrt1_2, 0);
  static const Point3 frontTop = Point3(0, -math.sqrt1_2, math.sqrt1_2);
  static const Point3 bottomLeft = Point3(-math.sqrt1_2, math.sqrt1_2, 0);
  static const Point3 frontLeft = Point3(-math.sqrt1_2, 0, math.sqrt1_2);
  static const Point3 backRight = Point3(math.sqrt1_2, 0, -math.sqrt1_2);
  static const Point3 backBottom = Point3(0, math.sqrt1_2, -math.sqrt1_2);

  static const Point3 frontTopLeft = Point3(
    -DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const Point3 frontTopRight = Point3(
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const Point3 frontBottomLeft = Point3(
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const Point3 backTopRight = Point3(
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const Point3 backBottomLeft = Point3(
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const Point3 backBottomRight = Point3(
    DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const Point3 frontBottomRight = Point3.cube(DoubleExtension.sqrt1_3);
  static const Point3 backTopLeft = Point3.cube(-DoubleExtension.sqrt1_3);

  factory Point3.unitOfDirection(
    DirectionIn8 direction, [
    DirectionFrontOrBack? frontOrBack,
  ]) => switch (direction) {
    DirectionIn8.left => switch (frontOrBack) {
      null => Point3.left,
      DirectionFrontOrBack.front => Point3.frontLeft,
      DirectionFrontOrBack.back => Point3.bottomLeft,
    },
    DirectionIn8.top => switch (frontOrBack) {
      null => Point3.top,
      DirectionFrontOrBack.front => Point3.frontTop,
      DirectionFrontOrBack.back => Point3.backTop,
    },
    DirectionIn8.right => switch (frontOrBack) {
      null => Point3.right,
      DirectionFrontOrBack.front => Point3.frontRight,
      DirectionFrontOrBack.back => Point3.backRight,
    },
    DirectionIn8.bottom => switch (frontOrBack) {
      null => Point3.bottom,
      DirectionFrontOrBack.front => Point3.frontBottom,
      DirectionFrontOrBack.back => backBottom,
    },
    DirectionIn8.topLeft => switch (frontOrBack) {
      null => Point3.topLeft,
      DirectionFrontOrBack.front => Point3.frontTopLeft,
      DirectionFrontOrBack.back => Point3.backTopLeft,
    },
    DirectionIn8.bottomRight => switch (frontOrBack) {
      null => Point3.bottomRight,
      DirectionFrontOrBack.front => Point3.frontBottomRight,
      DirectionFrontOrBack.back => Point3.backBottomRight,
    },
    DirectionIn8.topRight => switch (frontOrBack) {
      null => Point3.topRight,
      DirectionFrontOrBack.front => Point3.frontTopRight,
      DirectionFrontOrBack.back => Point3.backTopRight,
    },
    DirectionIn8.bottomLeft => switch (frontOrBack) {
      null => Point3.bottomLeft,
      DirectionFrontOrBack.front => frontBottomLeft,
      DirectionFrontOrBack.back => Point3.backBottomLeft,
    },
  };

  ///
  ///
  ///
  static Lerper<Point3> lerp(Point3 begin, Point3 end) =>
      (t) => Point3(
        begin.x * (1.0 - t) + end.x * t,
        begin.y * (1.0 - t) + end.y * t,
        begin.z * (1.0 - t) + end.z * t,
      );

  static double distance(Point3 xyz) =>
      math.sqrt(xyz.x * xyz.x + xyz.y + xyz.y + xyz.z * xyz.z);

  // radians between positive z axis to (x, y, z), 0 ~ π
  static double directionPolar(Point3 xyz) =>
      math.acos(xyz.z / Point3.distance(xyz));

  static Point3 maxZ(Point3 a, Point3 b) => a.z < b.z ? a : b;

  static Point3 maxPolar(Point3 a, Point3 b) =>
      Point3.directionPolar(a) > Point3.directionPolar(b) ? a : b;

  ///
  ///
  ///
  @override
  Point3 _instance(double x, double y, [double z = double.nan]) =>
      Point3(x, y, z);

  @override
  int compareTo(covariant Point3 other) =>
      Point3.distance(this) < Point3.distance(other)
          ? -1
          : Point3.distance(this) > Point3.distance(other)
          ? 1
          : 0;
}

///
///
///
final class Vector2 extends _Vector2<Vector2> {
  Vector2(super.x, super.y);

  @override
  Vector2 get clone => Vector2(x, y);

  ///
  ///
  ///
  static Lerper<Vector2> lerp(Vector2 begin, Vector2 end, [Vector2? host]) {
    final vector = host ?? begin.clone;
    return (t) =>
        vector
          ..x = begin.x * (1.0 - t) + end.x * t
          ..y = begin.y * (1.0 - t) + end.y * t;
  }
}

final class Vector3 extends _Vector2<Vector3>
    with _Mxyz<Vector3>, _MxyzT<Vector3> {
  @override
  double z;

  Vector3(super.x, super.y, this.z);

  @override
  Vector3 get clone => Vector3(x, y, z);

  static Lerper<Vector3> lerp(Vector3 begin, Vector3 end, [Vector3? host]) {
    final vector = host ?? begin.clone;
    return (t) =>
        vector
          ..x = begin.x * (1.0 - t) + end.x * t
          ..y = begin.y * (1.0 - t) + end.y * t
          ..z = begin.z * (1.0 - t) + end.z * t;
  }
}

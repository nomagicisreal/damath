///
///
/// this file contains:
///
/// [RotationUnit]
///
/// [Radian]
///   [Radian2]
///   [Radian3]
///
/// [Point]
///   [Point2]
///   [Point3]
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
/// [radianFromAngle], ...
/// [radianComplementary], ...
/// [radianIfWithinAngle90_90N], ...
///
enum RotationUnit {
  radian,
  angle,
  round;

  ///
  ///
  /// static methods
  ///
  ///
  static double radianFromAngle(double angle) => angle * Radian.angle_1;

  static double radianFromRound(double round) => round * Radian.angle_360;

  static double angleFromRadian(double radian) => radian / Radian.angle_1;

  static double roundFromRadian(double radian) => radian / Radian.angle_360;

  static double radianModulus90Angle(double radian) => radian % Radian.angle_90;

  static double radianModulus180Angle(double radian) =>
      radian % Radian.angle_180;

  static double radianModulus360Angle(double radian) =>
      radian % Radian.angle_360;

  ///
  /// [radianComplementary], [radianSupplementary], [radianRestrict180Angle]
  ///
  static double radianComplementary(double radian) {
    assert(radian.rangeIn(0, Radian.angle_90));
    return radianFromAngle(90 - angleFromRadian(radian));
  }

  static double radianSupplementary(double radian) {
    assert(radian.rangeIn(0, Radian.angle_180));
    return radianFromAngle(180 - angleFromRadian(radian));
  }

  static double radianRestrict180Angle(double angle) {
    final r = angle % 360;
    return r >= Radian.angle_180 ? r - Radian.angle_360 : r;
  }

  ///
  /// [radianIfWithinAngle90_90N], [radianIfOverAngle90_90N], [radianIfWithinAngle0_180], [radianIfWithinAngle0_180N]
  ///
  static bool radianIfWithinAngle90_90N(double radian) =>
      radian.abs() < Radian.angle_90;

  static bool radianIfOverAngle90_90N(double radian) =>
      radian.abs() > Radian.angle_90;

  static bool radianIfWithinAngle0_180(double radian) =>
      radian > 0 && radian < Radian.angle_180;

  static bool radianIfWithinAngle0_180N(double radian) =>
      radian > -Radian.angle_180 && radian < 0;
}

///
/// normally, 'positive radian' means counterclockwise in mathematical discussion,
///
/// [angle_1], ... (constants)
/// [compareTo], ...(implementation for [Operatable])
///
/// [cos], ... (getters)
/// [azimuthalIn], ... (methods)
///
abstract interface class Radian extends Operatable
    with
        OperatableDirectable,
        OperatableComparable<Radian>,
        OperatableScalable {
  final double rAzimuthal;

  const Radian(this.rAzimuthal);

  ///
  ///
  /// constants
  ///
  ///
  static const zero = 0.0;
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

  static const right = 0;
  static const bottomRight = Radian.angle_45;
  static const bottom = Radian.angle_90;
  static const bottomLeft = Radian.angle_135;
  static const left = Radian.angle_180;
  static const topLeft = Radian.angle_225;
  static const top = Radian.angle_270;
  static const topRight = Radian.angle_315;

  ///
  ///
  /// implementation for [Operatable]
  ///
  ///
  @override
  int compareTo(Radian other) => rAzimuthal.compareTo(other.rAzimuthal);

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
      1 => r.within(0, Radian.angle_90) ||
          r.within(-Radian.angle_360, -Radian.angle_270),
      2 => r.within(Radian.angle_90, Radian.angle_180) ||
          r.within(-Radian.angle_270, -Radian.angle_180),
      3 => r.within(Radian.angle_180, Radian.angle_270) ||
          r.within(-Radian.angle_180, -Radian.angle_90),
      4 => r.within(Radian.angle_270, Radian.angle_360) ||
          r.within(-Radian.angle_90, 0),
      _ => throw DamathException('un defined quadrant: $quadrant for $this'),
    };
  }
}

///
///
/// [toString], ... (implementation for [Object])
/// [-], ... (implementation for [Space])
///
/// [azimuthalOnRight], ... (getters)
/// [azimuthalInQuadrant], ... (methods)
///
///
class Radian2 extends Radian {
  const Radian2(super.rAzimuthal);

  ///
  ///
  /// implementation for [Object]
  ///
  ///
  @override
  String toString() => 'Radian2(${rAzimuthal.toStringAsFixed(1)})';

  @override
  int get hashCode => rAzimuthal.hashCode;

  @override
  bool operator ==(covariant Radian2 other) => hashCode == other.hashCode;

  ///
  ///
  /// implementation for [Space]
  ///
  ///
  @override
  Radian2 operator -() => Radian2(-rAzimuthal);

  @override
  Radian2 operator +(covariant Radian2 other) =>
      Radian2(rAzimuthal + other.rAzimuthal);

  @override
  Radian2 operator -(covariant Radian2 other) =>
      Radian2(rAzimuthal - other.rAzimuthal);

  @override
  Radian2 operator *(covariant Radian2 other) =>
      Radian2(rAzimuthal * other.rAzimuthal);

  @override
  Radian2 operator /(covariant Radian2 other) =>
      Radian2(rAzimuthal / other.rAzimuthal);

  @override
  Radian2 operator %(covariant Radian2 other) =>
      Radian2(rAzimuthal % other.rAzimuthal);
}

///
///
/// [Radian3.polar1], ... (constructors)
/// [zero], ... (constants)
///
/// [toString], ...(implementations for [Object])
/// [-], ...(implementations for [Space])
/// [&], ...(operation)
///
/// [toRecord], ...(getters)
///
///
class Radian3 extends Radian {
  ///
  /// the rotation of [rPolar] ranges in 0 ~ π, start from [Direction3DIn6.top] to [Direction3DIn6.bottom]
  ///
  final double rPolar;

  static bool validate(double rPolar) =>
      rPolar < 0 || rPolar > Radian.angle_180;

  ///
  ///
  /// constructor
  ///
  ///
  const Radian3(super.rAzimuthal, this.rPolar)
      : assert(
          rPolar >= 0 && rPolar <= Radian.angle_180,
        );

  const Radian3.polar1(double rAzimuthal) : this(rAzimuthal, Radian.angle_1);

  const Radian3.polar10(double rAzimuthal) : this(rAzimuthal, Radian.angle_10);

  const Radian3.polar15(double rAzimuthal) : this(rAzimuthal, Radian.angle_15);

  const Radian3.polar30(double rAzimuthal) : this(rAzimuthal, Radian.angle_30);

  const Radian3.polar90(double rAzimuthal) : this(rAzimuthal, Radian.angle_90);

  const Radian3.azimuthal1(double rPolar) : this(Radian.angle_1, rPolar);

  const Radian3.azimuthal10(double rPolar) : this(Radian.angle_10, rPolar);

  const Radian3.azimuthal15(double rPolar) : this(Radian.angle_15, rPolar);

  const Radian3.azimuthal30(double rPolar) : this(Radian.angle_30, rPolar);

  const Radian3.azimuthal90(double rPolar) : this(Radian.angle_90, rPolar);

  const Radian3.azimuthal180(double rPolar) : this(Radian.angle_180, rPolar);

  ///
  ///
  /// constants
  ///
  ///
  static const zero = Radian3(0, 0);

  ///
  ///
  /// implementations for [Object]
  ///
  ///
  @override
  String toString() => 'Radian3${(rAzimuthal, rPolar).toStringAsFixed(1)}';

  @override
  int get hashCode => rAzimuthal.hashCode;

  @override
  bool operator ==(covariant Radian2 other) => hashCode == other.hashCode;

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  Radian3 operator -() => Radian3(-rAzimuthal, -rPolar);

  @override
  Radian3 operator +(covariant Radian3 other) =>
      Radian3(rAzimuthal + other.rAzimuthal, rPolar + other.rPolar);

  @override
  Radian3 operator -(covariant Radian3 other) =>
      Radian3(rAzimuthal - other.rAzimuthal, rPolar - other.rPolar);

  @override
  Radian3 operator *(covariant Radian3 other) =>
      Radian3(rAzimuthal * other.rAzimuthal, rPolar * other.rPolar);

  @override
  Radian3 operator /(covariant Radian3 other) =>
      Radian3(rAzimuthal / other.rAzimuthal, rPolar / other.rPolar);

  @override
  Radian3 operator %(covariant Radian3 other) =>
      Radian3(rAzimuthal % other.rAzimuthal, rPolar % other.rPolar);

  ///
  ///
  /// operation
  ///
  ///
  Radian3 operator &(double rAzimuthal) =>
      Radian3(this.rAzimuthal + rAzimuthal, rPolar);

  Radian3 operator ^(double rPolar) =>
      Radian3(rAzimuthal, this.rPolar + rPolar);

  ///
  ///
  /// getters
  ///
  ///

  ///
  /// [toRecord]
  /// [cosPhi], [sinPhi]
  ///
  (double, double) get toRecord => (rAzimuthal, rPolar);

  double get cosPhi => math.cos(rPolar);

  double get sinPhi => math.sin(rPolar);

  ///
  /// [Direction3DIn6.front] can be seen within {angleY(-90 ~ 90), angleX(-90 ~ 90)}
  /// [Direction3DIn6.left] can be seen within {angleY(0 ~ -180), angleZ(-90 ~ 90)}
  /// [Direction3DIn6.top] can be seen within {angleX(0 ~ 180), angleZ(-90 ~ 90)}
  /// [Direction3DIn6.back] can be seen while [Direction3DIn6.front] not be seen.
  /// [Direction3DIn6.right] can be seen while [Direction3DIn6.left] not be seen.
  /// [Direction3DIn6.bottom] can be seen while [Direction3DIn6.top] not be seen.
  ///
  List<Direction3DIn6> get visibleFaces {
    throw UnimplementedError();
    // final r = radian.restrict180AbsAngle;
    // final rX = r.dx;
    // final rY = r.dy;
    // final rZ = r.dz;

    // return <Direction3DIn6>[
    //   Radian.ifWithinAngle90_90N(rY) && Radian.ifWithinAngle90_90N(rX)
    //       ? Direction3DIn6.front
    //       : Direction3DIn6.back,
    //   Radian.ifWithinAngle0_180N(rY) && Radian.ifWithinAngle90_90N(rZ)
    //       ? Direction3DIn6.left
    //       : Direction3DIn6.right,
    //   Radian.ifWithinAngle0_180(rX) && Radian.ifWithinAngle90_90N(rZ)
    //       ? Direction3DIn6.top
    //       : Direction3DIn6.bottom,
    // ];
  }
}

///
///
/// [dx], [dy]
/// [Point.square], ...(constructors)
/// [toRecord], ...(getters)
/// [middleTo], ...(methods)
///
///
sealed class Point extends Operatable
    with
        OperatableDirectable,
        OperatableComparable<Point>,
        OperatableScalable,
        OperatableStepable {
  final double dx;
  final double dy;

  ///
  ///
  /// constructors
  ///
  ///
  const Point(this.dx, this.dy);

  const Point.square(double value) : this(value, value);

  const Point.ofX(double dx) : this(dx, 0);

  const Point.ofY(double dy) : this(0, dy);

  ///
  ///
  /// implementations for [Operatable]
  ///
  ///
  @override
  int compareTo(Point other) => throw OperatableComparable.error();

  @override
  bool operator <(covariant Point other) => dx < other.dx && dy < other.dy;

  @override
  bool operator <=(covariant Point other) => dx <= other.dx && dy <= other.dy;

  @override
  bool operator >(covariant Point other) => dx > other.dx && dy > other.dy;

  @override
  bool operator >=(covariant Point other) => dx >= other.dx && dy >= other.dy;

  ///
  /// [toRecord]
  ///
  Record get toRecord;

  ///
  /// [middleTo]
  ///
  Point middleTo(Point p);
}

///
///
/// [Point2.square], ... (constructor)
/// [zero], ... (constants)
///
/// [toString], ...(implementations for [Object])
/// [-], ...(implementations for [Space])
/// [toRecord], ...(implementations for [Point])
///
/// [...nothing...], ...()
///
class Point2 extends Point {
  ///
  ///
  /// constructors
  ///
  ///
  const Point2(super.dx, super.dy);

  const Point2.square(super.value) : super.square();

  const Point2.ofX(super.dx) : super.ofX();

  const Point2.ofY(super.dy) : super.ofY();

  Point2.fromDirection(double direction, [double distance = 1])
      : super(
          distance * math.cos(direction),
          distance * math.sin(direction),
        );

  ///
  ///
  /// constructors
  ///
  ///
  factory Point2.unitFromDirection(Direction2D direction) {
    final d8 = switch (direction) {
      Direction2DIn4() => direction.toDirection8,
      Direction2DIn8() => direction,
    };
    return switch (d8) {
      Direction2DIn8.top => Point2.top,
      Direction2DIn8.left => Point2.left,
      Direction2DIn8.right => Point2.right,
      Direction2DIn8.bottom => Point2.bottom,
      Direction2DIn8.topLeft => Point2.topLeft,
      Direction2DIn8.topRight => Point2.topRight,
      Direction2DIn8.bottomLeft => Point2.bottomLeft,
      Direction2DIn8.bottomRight => Point2.bottomRight,
    };
  }

  ///
  /// the rotation of
  ///   1. [RecordDouble2Extension.direction], [RecordDouble2Extension.rotate]
  ///   2. [Point2.fromDirection]
  /// follows the axis [Direction3DIn6.back] -> [Direction3DIn6.front],
  /// and the rotation on axis starts from [Direction3DIn6.right].
  ///
  /// the implementation of [Point2.fromDirection] is let (d, 0) be the unit vector,
  /// then [RecordDouble2Extension.rotate] the unit vector as follows:
  ///   [Point2.dx] = d * cos(radian); // 0 * sin(radian) = 0
  ///   [Point2.dy] = d * sin(radian); // 0 * cos(radian) = 0
  ///
  ///

  ///
  ///
  /// constants
  ///
  ///
  static const Point2 zero = Point2(0.0, 0.0);
  static const Point2 one = Point2(1.0, 1.0);

  static const top = Point2(0, -1);
  static const left = Point2(-1, 0);
  static const right = Point2(1, 0);
  static const bottom = Point2(0, 1);
  static const center = Point2.zero;
  static const topLeft = Point2.square(-math.sqrt1_2);
  static const topRight = Point2(math.sqrt1_2, -math.sqrt1_2);
  static const bottomLeft = Point2(-math.sqrt1_2, math.sqrt1_2);
  static const bottomRight = Point2.square(math.sqrt1_2);

  ///
  ///
  /// implementations for [Object]
  ///
  ///
  @override
  String toString() => 'Point2${(dx, dy).toStringAsFixed(1)}';

  @override
  int get hashCode => Object.hash(dx, dy);

  @override
  bool operator ==(covariant Point2 other) => hashCode == other.hashCode;

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  Point2 operator -() => Point2(-dx, -dy);

  @override
  Point2 operator +(covariant Point2 other) =>
      Point2(dx + other.dx, dy + other.dy);

  @override
  Point2 operator -(covariant Point2 other) =>
      Point2(dx - other.dx, dy - other.dy);

  @override
  Point2 operator *(covariant Point2 other) =>
      Point2(dx * other.dx, dy * other.dy);

  @override
  Point2 operator /(covariant Point2 other) =>
      Point2(dx / other.dx, dy / other.dy);

  @override
  Point2 operator %(covariant Point2 other) =>
      Point2(dx % other.dx, dy % other.dy);

  @override
  Point2 operator ~/(covariant Point2 other) =>
      Point2((dx ~/ other.dx).toDouble(), (dy ~/ other.dy).toDouble());

  ///
  ///
  /// implementation for [Point]
  ///
  ///

  ///
  /// ([dx], [dy]) can be treated as [Record] to use the getters, functions in [RecordDouble2Extension]
  ///
  @override
  (double, double) get toRecord => (dx, dy);

  @override
  Point2 middleTo(covariant Point2 p) => (p + this) / Point2.square(2);
}

///
/// notice that the translation of [Point3] follows the axis by [double.infinity] -> [double.negativeInfinity],
/// which means:
///   [Point3.dx] is getting bigger to [Direction3DIn6.back], getting lower to [Direction3DIn6.front]
///   [Point3.dy] is getting bigger to [Direction3DIn6.right], getting lower to [Direction3DIn6.left],
///   [Point3.dz] is getting bigger to [Direction3DIn6.top], getting lower to [Direction3DIn6.bottom]
/// see also [Point3.rotate], [Space3.fromDirection] for direction
///
///
/// [Point3.cube], ... (constructor)
/// [Point3.fromDirection], ... (factories)
/// [zero], ... (constants)
///
/// [toString], ...(implementations for [Object])
/// [-], ...(implementations for [Space])
/// [distanceTo], ...(implementations for [Point])
///
/// [...nothing...], ...(static methods)
/// [withoutXY], ... (getters)
/// [rotateX], ... (methods)
///
/// to compute efficiently without creating a class, see [RecordDouble3Extension]
///
class Point3 extends Point {
  final double dz;

  ///
  ///
  /// constructors
  ///
  ///
  const Point3(super.dx, super.dy, this.dz);

  const Point3.ofX(super.dx)
      : dz = 0,
        super.ofX();

  const Point3.ofY(super.dy)
      : dz = 0,
        super.ofY();

  const Point3.ofZ(this.dz) : super.square(0);

  const Point3.cube(super.value)
      : dz = value,
        super.square();

  const Point3.ofXY(super.value)
      : dz = 0,
        super.square();

  const Point3.ofYZ(double value)
      : dz = value,
        super(0, value);

  const Point3.ofXZ(double value)
      : dz = value,
        super(value, 0);

  ///
  ///
  /// factories
  ///
  ///
  factory Point3.fromDirection(Radian3 direction, [double distance = 1]) {
    final s = direction.sinPhi * distance;
    return Point3(
      s * direction.cos,
      s * direction.sin,
      direction.cosPhi * distance,
    );
  }

  factory Point3.unitFromDirection(Direction3D direction) {
    final d27 = switch (direction) {
      Direction3DIn6() => direction.to3DIn27,
      Direction3DIn14() => direction.to3DIn27,
      Direction3DIn27() => direction,
    };
    return switch (d27) {
      Direction3DIn27.center => Point3.center,
      Direction3DIn27.left => Point3.left,
      Direction3DIn27.top => Point3.top,
      Direction3DIn27.right => Point3.right,
      Direction3DIn27.bottom => Point3.bottom,
      Direction3DIn27.front => Point3.front,
      Direction3DIn27.back => Point3.back,
      Direction3DIn27.topLeft => Point3.topLeft,
      Direction3DIn27.bottomRight => Point3.bottomRight,
      Direction3DIn27.frontRight => Point3.frontRight,
      Direction3DIn27.frontBottom => Point3.frontBottom,
      Direction3DIn27.backLeft => Point3.backLeft,
      Direction3DIn27.backTop => Point3.backTop,
      Direction3DIn27.topRight => Point3.topRight,
      Direction3DIn27.frontTop => Point3.frontTop,
      Direction3DIn27.bottomLeft => Point3.bottomLeft,
      Direction3DIn27.frontLeft => Point3.frontLeft,
      Direction3DIn27.backRight => Point3.backRight,
      Direction3DIn27.backBottom => Point3.backBottom,
      Direction3DIn27.frontTopLeft => Point3.frontTopLeft,
      Direction3DIn27.frontTopRight => Point3.frontTopRight,
      Direction3DIn27.frontBottomLeft => Point3.frontBottomLeft,
      Direction3DIn27.backTopRight => Point3.backTopRight,
      Direction3DIn27.backBottomLeft => Point3.backBottomLeft,
      Direction3DIn27.backBottomRight => Point3.backBottomRight,
      Direction3DIn27.frontBottomRight => Point3.frontBottomRight,
      Direction3DIn27.backTopLeft => Point3.backTopLeft,
    };
  }

  ///
  ///
  /// constants
  ///
  ///
  static const Point3 zero = Point3.cube(0);
  static const Point3 one = Point3.cube(1);

  static const center = Point3.zero;
  static const left = Point3.ofX(-1);
  static const top = Point3.ofY(-1);
  static const right = Point3.ofX(1);
  static const bottom = Point3.ofY(1);
  static const front = Point3.ofZ(1);
  static const back = Point3.ofZ(-1);

  static const topLeft = Point3.ofXY(-math.sqrt1_2);
  static const bottomRight = Point3.ofXY(math.sqrt1_2);
  static const frontRight = Point3.ofXZ(math.sqrt1_2);
  static const frontBottom = Point3.ofYZ(math.sqrt1_2);
  static const backLeft = Point3.ofXZ(-math.sqrt1_2);
  static const backTop = Point3.ofYZ(-math.sqrt1_2);
  static const topRight = Point3(math.sqrt1_2, -math.sqrt1_2, 0);
  static const frontTop = Point3(0, -math.sqrt1_2, math.sqrt1_2);
  static const bottomLeft = Point3(-math.sqrt1_2, math.sqrt1_2, 0);
  static const frontLeft = Point3(-math.sqrt1_2, 0, math.sqrt1_2);
  static const backRight = Point3(math.sqrt1_2, 0, -math.sqrt1_2);
  static const backBottom = Point3(0, math.sqrt1_2, -math.sqrt1_2);

  static const frontTopLeft = Point3(
    -DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const frontTopRight = Point3(
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const frontBottomLeft = Point3(
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
  );
  static const backTopRight = Point3(
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const backBottomLeft = Point3(
    -DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const backBottomRight = Point3(
    DoubleExtension.sqrt1_3,
    DoubleExtension.sqrt1_3,
    -DoubleExtension.sqrt1_3,
  );
  static const frontBottomRight = Point3.cube(DoubleExtension.sqrt1_3);
  static const backTopLeft = Point3.cube(-DoubleExtension.sqrt1_3);

  ///
  ///
  /// implementations for [Object]
  ///
  ///
  @override
  String toString() => 'Point3${(dx, dy, dz).toStringAsFixed(1)}';

  @override
  bool operator ==(covariant Point3 other) => super == other && dz == other.dz;

  @override
  int get hashCode => Object.hash(dx, dy, dz);

  ///
  ///
  /// implementations for [Space]
  ///
  ///
  @override
  Point3 operator -() => Point3(-dx, -dy, -dz);

  @override
  Point3 operator +(covariant Point3 other) =>
      Point3(dx + other.dx, dy + other.dy, dz + other.dz);

  @override
  Point3 operator -(covariant Point3 other) =>
      Point3(dx - other.dx, dy - other.dy, dz - other.dz);

  @override
  Point3 operator *(covariant Point3 other) =>
      Point3(dx * other.dx, dy * other.dy, dz * other.dz);

  @override
  Point3 operator /(covariant Point3 other) =>
      Point3(dx / other.dx, dy / other.dy, dz / other.dz);

  @override
  Point3 operator %(covariant Point3 other) =>
      Point3(dx % other.dx, dy % other.dy, dz % other.dz);

  ///
  ///
  /// implementations for [Point]
  ///
  ///
  @override
  bool operator <(covariant Point3 other) => super < other && dz < other.dz;

  @override
  bool operator >(covariant Point3 other) => super > other && dz > other.dz;

  @override
  bool operator <=(covariant Point3 other) => super <= other && dz <= other.dz;

  @override
  bool operator >=(covariant Point3 other) => super >= other && dz >= other.dz;

  @override
  Point3 operator ~/(covariant Point3 other) => Point3(
        (dx ~/ other.dx).toDouble(),
        (dy ~/ other.dy).toDouble(),
        (dz ~/ other.dz).toDouble(),
      );

  ///
  ///
  /// implementations for [Point]
  ///
  ///

  ///
  /// ([dx], [dy], [dz]) can be treated as [Record] to use the getters, functions in [RecordDouble3Extension]
  ///
  @override
  (double, double, double) get toRecord => (dx, dy, dz);

  @override
  Point3 middleTo(covariant Point3 p) => (p - this) / Point3.cube(2);

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

  Point3 get retainXY => Point3(dx, dy, 0);

  Point3 get retainYZAsXY => Point3(dy, dz, 0);

  Point3 get retainXZAsXY => Point3(dx, dz, 0);

  Point3 get retainYZAsYX => Point3(dz, dy, 0);

  Point3 get retainXZAsYX => Point3(dz, dx, 0);
}

///
///
/// this file contains:
///
/// [Direction]
///   [Direction2D]
///     [Direction2DIn4]
///     [Direction2DIn8]
///   [Direction3D]
///     [Direction3DIn6]
///     [Direction3DIn14]
///
/// [RotationUnit]
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
// ignore_for_file: constant_identifier_names


///
///
sealed class Direction<D> {
  D get flipped;

  Points2 get toSpace2;

  Points3 get toSpace3;
}

sealed class Direction2D<D extends Direction2D<D>> implements Direction<D> {
  static const radian_right = 0;
  static const radian_bottomRight = SpaceRadian.angle_45;
  static const radian_bottom = SpaceRadian.angle_90;
  static const radian_bottomLeft = SpaceRadian.angle_135;
  static const radian_left = SpaceRadian.angle_180;
  static const radian_topLeft = SpaceRadian.angle_225;
  static const radian_top = SpaceRadian.angle_270;
  static const radian_topRight = SpaceRadian.angle_315;

  static const space_top = Points2(0, -1);
  static const space_left = Points2(-1, 0);
  static const space_right = Points2(1, 0);
  static const space_bottom = Points2(0, 1);
  static const space_center = Points2.zero;
  static const space_topLeft = Points2.square(-math.sqrt1_2);
  static const space_topRight = Points2(math.sqrt1_2, -math.sqrt1_2);
  static const space_bottomLeft = Points2(-math.sqrt1_2, math.sqrt1_2);
  static const space_bottomRight = Points2.square(math.sqrt1_2);
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
  Points2 get toSpace2 => toDirection8.toSpace2;

  @override
  Points3 get toSpace3 => toDirection8.toSpace3;

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
  Points2 get toSpace2 => switch (this) {
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
  Points3 get toSpace3 => switch (this) {
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
  static const space_center = Points3.zero;
  static const space_left = Points3.ofX(-1);
  static const space_top = Points3.ofY(-1);
  static const space_right = Points3.ofX(1);
  static const space_bottom = Points3.ofY(1);
  static const space_front = Points3.ofZ(1);
  static const space_back = Points3.ofZ(-1);

  static const space_topLeft = Points3.ofXY(-math.sqrt1_2);
  static const space_bottomRight = Points3.ofXY(math.sqrt1_2);
  static const space_frontRight = Points3.ofXZ(math.sqrt1_2);
  static const space_frontBottom = Points3.ofYZ(math.sqrt1_2);
  static const space_backLeft = Points3.ofXZ(-math.sqrt1_2);
  static const space_backTop = Points3.ofYZ(-math.sqrt1_2);
  static const space_topRight = Points3(math.sqrt1_2, -math.sqrt1_2, 0);
  static const space_frontTop = Points3(0, -math.sqrt1_2, math.sqrt1_2);
  static const space_bottomLeft = Points3(-math.sqrt1_2, math.sqrt1_2, 0);
  static const space_frontLeft = Points3(-math.sqrt1_2, 0, math.sqrt1_2);
  static const space_backRight = Points3(math.sqrt1_2, 0, -math.sqrt1_2);
  static const space_backBottom = Points3(0, math.sqrt1_2, -math.sqrt1_2);

  static const space_frontTopLeft = Points3(-DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontTopRight = Points3(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontBottomLeft = Points3(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, DoubleExtension.sqrt1_3);
  static const space_frontBottomRight = Points3.cube(DoubleExtension.sqrt1_3);
  static const space_backTopLeft = Points3.cube(-DoubleExtension.sqrt1_3);
  static const space_backTopRight = Points3(DoubleExtension.sqrt1_3,
      -DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const space_backBottomLeft = Points3(-DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
  static const space_backBottomRight = Points3(DoubleExtension.sqrt1_3,
      DoubleExtension.sqrt1_3, -DoubleExtension.sqrt1_3);
}

///
///
/// these are two significant definition for [Direction3DIn6],
///   1. [Direction3DIn6.back] means user side, [Direction3DIn6.front] means screen side.
///   2. "[Direction3DIn6.back] -> [Direction3DIn6.front]" means the perspective from user to screen.
/// which helps constructing the space in the imagination.
///
/// See Also
///   * [Points2.rotate], [Space2.fromDirection]
///   * [Points3.rotate], [Space3.fromDirection]
///   * [Radian3.direct]
///
enum Direction3DIn6 implements Direction3D<Direction3DIn6> {
  left,
  top,
  right,
  bottom,
  front,
  back;

  ///
  /// [front] can be seen within {angleY(-90 ~ 90), angleX(-90 ~ 90)}
  /// [left] can be seen within {angleY(0 ~ -180), angleZ(-90 ~ 90)}
  /// [top] can be seen within {angleX(0 ~ 180), angleZ(-90 ~ 90)}
  /// [back] can be seen while [front] not be seen.
  /// [right] can be seen while [left] not be seen.
  /// [bottom] can be seen while [top] not be seen.
  ///
  static List<Direction3DIn6> visibleFacesOf(Radian3 radian) {
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
  Points2 get toSpace2 => switch (this) {
    Direction3DIn6.left => Direction2D.space_left,
    Direction3DIn6.top => Direction2D.space_top,
    Direction3DIn6.right => Direction2D.space_right,
    Direction3DIn6.bottom => Direction2D.space_bottom,
    _ => throw UnimplementedError(),
  };

  @override
  Points3 get toSpace3 => switch (this) {
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
  Points2 get toSpace2 => switch (this) {
    Direction3DIn14.left => Direction2D.space_left,
    Direction3DIn14.top => Direction2D.space_top,
    Direction3DIn14.right => Direction2D.space_right,
    Direction3DIn14.bottom => Direction2D.space_bottom,
    _ => throw UnimplementedError(),
  };

  @override
  Points3 get toSpace3 => switch (this) {
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
  static double radianFromAngle(double angle) => angle * SpaceRadian.angle_1;

  static double radianFromRound(double round) => round * SpaceRadian.angle_360;

  static double angleFromRadian(double radian) => radian / SpaceRadian.angle_1;

  static double roundFromRadian(double radian) =>
      radian / SpaceRadian.angle_360;

  static double radianModulus90Angle(double radian) =>
      radian % SpaceRadian.angle_90;

  static double radianModulus180Angle(double radian) =>
      radian % SpaceRadian.angle_180;

  static double radianModulus360Angle(double radian) =>
      radian % SpaceRadian.angle_360;

  ///
  /// [radianComplementary], [radianSupplementary], [radianRestrict180Angle]
  ///
  static double radianComplementary(double radian) {
    assert(radian.rangeIn(0, SpaceRadian.angle_90));
    return radianFromAngle(90 - angleFromRadian(radian));
  }

  static double radianSupplementary(double radian) {
    assert(radian.rangeIn(0, SpaceRadian.angle_180));
    return radianFromAngle(180 - angleFromRadian(radian));
  }

  static double radianRestrict180Angle(double angle) {
    final r = angle % 360;
    return r >= SpaceRadian.angle_180 ? r - SpaceRadian.angle_360 : r;
  }

  ///
  /// [radianIfWithinAngle90_90N], [radianIfOverAngle90_90N], [radianIfWithinAngle0_180], [radianIfWithinAngle0_180N]
  ///
  static bool radianIfWithinAngle90_90N(double radian) =>
      radian.abs() < SpaceRadian.angle_90;

  static bool radianIfOverAngle90_90N(double radian) =>
      radian.abs() > SpaceRadian.angle_90;

  static bool radianIfWithinAngle0_180(double radian) =>
      radian > 0 && radian < SpaceRadian.angle_180;

  static bool radianIfWithinAngle0_180N(double radian) =>
      radian > -SpaceRadian.angle_180 && radian < 0;
}

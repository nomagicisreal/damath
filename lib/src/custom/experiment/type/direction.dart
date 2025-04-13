part of '../../custom.dart';

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
///
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
sealed class Direction<D> {
  D get flipped;
}

sealed class Direction2D<D extends Direction2D<D>> implements Direction<D> {}

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

sealed class Direction3D<D extends Direction3D<D>> implements Direction<D> {}

///
///
/// these are two significant definition for [Direction3DIn6],
///   1. [Direction3DIn6.back] means user side, [Direction3DIn6.front] means screen side.
///   2. "[Direction3DIn6.back] -> [Direction3DIn6.front]" means the perspective from user to screen.
/// which helps constructing the operatable in the imagination.
///
/// See Also
///   * [Point2.rotate], [Space2.fromDirection]
///   * [Point3.rotate], [Space3.fromDirection]
///   * [Radian3.direct]
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

  Direction2DIn4 get to2DIn4 => switch (this) {
        Direction3DIn6.left => Direction2DIn4.left,
        Direction3DIn6.top => Direction2DIn4.top,
        Direction3DIn6.right => Direction2DIn4.right,
        Direction3DIn6.bottom => Direction2DIn4.bottom,
        _ => throw UnimplementedError(),
      };

  Direction3DIn27 get to3DIn27 => switch (this) {
        Direction3DIn6.left => Direction3DIn27.right,
        Direction3DIn6.top => Direction3DIn27.bottom,
        Direction3DIn6.right => Direction3DIn27.left,
        Direction3DIn6.bottom => Direction3DIn27.top,
        Direction3DIn6.front => Direction3DIn27.back,
        Direction3DIn6.back => Direction3DIn27.front,
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
        Direction3DIn14.front => Direction3DIn14.back,
        Direction3DIn14.frontLeft => Direction3DIn14.backLeft,
        Direction3DIn14.frontTop => Direction3DIn14.backTop,
        Direction3DIn14.frontRight => Direction3DIn14.backRight,
        Direction3DIn14.frontBottom => Direction3DIn14.backBottom,
        Direction3DIn14.back => Direction3DIn14.front,
        Direction3DIn14.backLeft => Direction3DIn14.frontLeft,
        Direction3DIn14.backTop => Direction3DIn14.frontTop,
        Direction3DIn14.backRight => Direction3DIn14.frontRight,
        Direction3DIn14.backBottom => Direction3DIn14.frontBottom,
      };

  Direction2DIn8 get to2DIn8 => switch (this) {
        Direction3DIn14.left => Direction2DIn8.left,
        Direction3DIn14.top => Direction2DIn8.top,
        Direction3DIn14.right => Direction2DIn8.right,
        Direction3DIn14.bottom => Direction2DIn8.bottom,
        _ => throw UnimplementedError(),
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

  Direction3DIn27 get to3DIn27 => switch (this) {
        Direction3DIn14.left => Direction3DIn27.right,
        Direction3DIn14.top => Direction3DIn27.bottom,
        Direction3DIn14.right => Direction3DIn27.left,
        Direction3DIn14.bottom => Direction3DIn27.top,
        Direction3DIn14.front => Direction3DIn27.back,
        Direction3DIn14.frontLeft => Direction3DIn27.backLeft,
        Direction3DIn14.frontTop => Direction3DIn27.backTop,
        Direction3DIn14.frontRight => Direction3DIn27.backRight,
        Direction3DIn14.frontBottom => Direction3DIn27.backBottom,
        Direction3DIn14.back => Direction3DIn27.front,
        Direction3DIn14.backLeft => Direction3DIn27.frontLeft,
        Direction3DIn14.backTop => Direction3DIn27.frontTop,
        Direction3DIn14.backRight => Direction3DIn27.frontRight,
        Direction3DIn14.backBottom => Direction3DIn27.frontBottom,
      };
}

enum Direction3DIn27 implements Direction3D<Direction3DIn27> {
  center,
  left,
  top,
  right,
  bottom,
  front,
  back,
  topLeft,
  bottomRight,
  frontRight,
  frontBottom,
  backLeft,
  backTop,
  topRight,
  frontTop,
  bottomLeft,
  frontLeft,
  backRight,
  backBottom,
  frontTopLeft,
  frontTopRight,
  frontBottomLeft,
  backTopRight,
  backBottomLeft,
  backBottomRight,
  frontBottomRight,
  backTopLeft;

  @override
  Direction3DIn27 get flipped => switch (this) {
        Direction3DIn27.center => throw UnimplementedError(),
        Direction3DIn27.left => throw UnimplementedError(),
        Direction3DIn27.top => throw UnimplementedError(),
        Direction3DIn27.right => throw UnimplementedError(),
        Direction3DIn27.bottom => throw UnimplementedError(),
        Direction3DIn27.front => throw UnimplementedError(),
        Direction3DIn27.back => throw UnimplementedError(),
        Direction3DIn27.topLeft => throw UnimplementedError(),
        Direction3DIn27.bottomRight => throw UnimplementedError(),
        Direction3DIn27.frontRight => throw UnimplementedError(),
        Direction3DIn27.frontBottom => throw UnimplementedError(),
        Direction3DIn27.backLeft => throw UnimplementedError(),
        Direction3DIn27.backTop => throw UnimplementedError(),
        Direction3DIn27.topRight => throw UnimplementedError(),
        Direction3DIn27.frontTop => throw UnimplementedError(),
        Direction3DIn27.bottomLeft => throw UnimplementedError(),
        Direction3DIn27.frontLeft => throw UnimplementedError(),
        Direction3DIn27.backRight => throw UnimplementedError(),
        Direction3DIn27.backBottom => throw UnimplementedError(),
        Direction3DIn27.frontTopLeft => throw UnimplementedError(),
        Direction3DIn27.frontTopRight => throw UnimplementedError(),
        Direction3DIn27.frontBottomLeft => throw UnimplementedError(),
        Direction3DIn27.backTopRight => throw UnimplementedError(),
        Direction3DIn27.backBottomLeft => throw UnimplementedError(),
        Direction3DIn27.backBottomRight => throw UnimplementedError(),
        Direction3DIn27.frontBottomRight => throw UnimplementedError(),
        Direction3DIn27.backTopLeft => throw UnimplementedError(),
      };
}


///
///
///
///
enum RotationUnit {
  radian,
  angle,
  round;
}

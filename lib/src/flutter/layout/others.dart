///
///
/// this file contains:
///
/// [lerperFrom]
///
/// [SizeExtension]
/// [OffsetExtension]
/// [RectExtension]
/// [AlignmentExtension]
/// [BoxConstraintsExtension]
///
///
/// [PathExtension]
/// [RenderBoxExtension]
/// [PositionedExtension]
/// [TransformExtension]
///
///
/// [CurveExtension]
/// [CubicExtension]
///
///
///
///
///
///
///
///
part of damath_flutter;



///
/// [lerperFrom]
///
Lerper<T> lerperFrom<T>(T begin, T end) {
  try {
    return DoubleExtension.lerperFrom(begin, end);
  } on StateError catch (e) {
    if (e.message == KErrorMessage.lerperNoImplementation) {
      return switch (begin) {
        Size _ => (t) => Size.lerp(begin, end as Size, t)!,
        Rect _ => (t) => Rect.lerp(begin, end as Rect, t)!,
        Color _ => (t) => Color.lerp(begin, end as Color, t)!,
        EdgeInsets _ => (t) => EdgeInsets.lerp(begin, end as EdgeInsets?, t)!,
        RelativeRect _ => (t) =>
        RelativeRect.lerp(begin, end as RelativeRect?, t)!,
        AlignmentGeometry _ => (t) =>
        AlignmentGeometry.lerp(begin, end as AlignmentGeometry?, t)!,
        SizingPath _ => throw ArgumentError(
          'Use BetweenPath instead of Between<SizingPath>',
        ),
        Decoration _ => switch (begin) {
          BoxDecoration _ => end is BoxDecoration && begin.shape == end.shape
              ? (t) => BoxDecoration.lerp(begin, end, t)!
              : throw UnimplementedError(
              'BoxShape should not be interpolated'),
          ShapeDecoration _ => switch (end) {
            ShapeDecoration _ => begin.shape == end.shape
                ? (t) => ShapeDecoration.lerp(begin, end, t)!
                : switch (begin.shape) {
              CircleBorder _ || RoundedRectangleBorder _ => switch (
              end.shape) {
                CircleBorder _ || RoundedRectangleBorder _ => (t) =>
                Decoration.lerp(begin, end, t)!,
                _ => throw UnimplementedError(
                  "'$begin shouldn't be interpolated to $end'",
                ),
              },
              _ => throw UnimplementedError(
                "'$begin shouldn't be interpolated to $end'",
              ),
            },
            _ => throw UnimplementedError(),
          },
          _ => throw UnimplementedError(),
        },
        ShapeBorder _ => switch (begin) {
          BoxBorder _ => switch (end) {
            BoxBorder _ => (t) => BoxBorder.lerp(begin, end, t)!,
            _ => throw UnimplementedError(),
          },
          InputBorder _ => switch (end) {
            InputBorder _ => (t) => ShapeBorder.lerp(begin, end, t)!,
            _ => throw UnimplementedError(),
          },
          OutlinedBorder _ => switch (end) {
            OutlinedBorder _ => (t) => OutlinedBorder.lerp(begin, end, t)!,
            _ => throw UnimplementedError(),
          },
          _ => throw UnimplementedError(),
        },
        _ => Tween<T>(begin: begin, end: end).transform,
      } as Lerper<T>;
    }
    rethrow;
  }
}




///
///
///
/// size, offset, rect
///
///

///
/// static methods:
/// [keep], ...
///
/// instance methods:
/// [diagonal], ...
///
///
extension SizeExtension on Size {
  ///
  /// [keep]
  ///
  static Size keep(Size v) => v;

  ///
  ///
  ///
  double get diagonal => (width.squared + height.squared).squareRoot;

  ///
  /// [weightingWidth], [weightingHeight]
  /// [extrudingWidth], [extrudingHeight]
  ///
  Size weightingWidth(double scale) => Size(width * scale, height);

  Size weightingHeight(double scale) => Size(width, height * scale);

  Size extrudingWidth(double value) => Size(width + value, height);

  Size extrudingHeight(double value) => Size(width, height + value);
}

///
/// static methods:
/// [keep]
///
/// instance methods:
/// [fromPoint], ...
/// [parallelUnitOf], ...
/// ...
///
extension OffsetExtension on Offset {
  ///
  /// [keep]
  ///
  static Offset keep(Offset v) => v;

  ///
  /// [fromPoint]
  /// [unitFromDirection]
  ///
  static Offset fromPoint(Point point) => switch (point) {
        Point2() => Offset(point.x, point.y),
        Point3() => throw UnimplementedError(),
      };

  static Offset unitFromDirection(Direction direction) => switch (direction) {
        Direction2D() => fromPoint(Point2.unitFromDirection(direction)),
        Direction3D() => throw UnimplementedError(),
      };

  ///
  ///
  /// static methods:
  ///
  ///

  ///
  /// [parallelUnitOf]
  /// [parallelVectorOf]
  /// [parallelOffsetOf]
  /// [parallelOffsetUnitOf]
  /// [parallelOffsetUnitOnCenterOf]
  ///
  static Offset parallelUnitOf(Offset a, Offset b) {
    final offset = b - a;
    return offset / offset.distance;
  }

  static Offset parallelVectorOf(Offset a, Offset b, double t) => (b - a) * t;

  static Offset parallelOffsetOf(Offset a, Offset b, double t) =>
      a + parallelVectorOf(a, b, t);

  static Offset parallelOffsetUnitOf(Offset a, Offset b, double t) =>
      a + parallelUnitOf(a, b) * t;

  static Offset parallelOffsetUnitOnCenterOf(Offset a, Offset b, double t) =>
      a.middleTo(b) + parallelUnitOf(a, b) * t;

  ///
  /// [perpendicularUnitOf]
  /// [perpendicularVectorOf]
  /// [perpendicularOffsetOf]
  /// [perpendicularOffsetUnitOf]
  /// [perpendicularOffsetUnitFromCenterOf]
  ///
  static Offset perpendicularUnitOf(Offset a, Offset b) =>
      (b - a).toPerpendicularUnit;

  static Offset perpendicularVectorOf(Offset a, Offset b, double t) =>
      (b - a).toPerpendicular * t;

  static Offset perpendicularOffsetOf(Offset a, Offset b, double t) =>
      a + perpendicularVectorOf(a, b, t);

  static Offset perpendicularOffsetUnitOf(Offset a, Offset b, double t) =>
      a + perpendicularUnitOf(a, b) * t;

  static Offset perpendicularOffsetUnitFromCenterOf(
    Offset a,
    Offset b,
    double t,
  ) =>
      a.middleTo(b) + perpendicularUnitOf(a, b) * t;

  ///
  ///
  /// instance methods
  ///
  ///
  ///

  ///
  /// [direct], [directionPerpendicular]
  /// [middleTo], [distanceHalfTo]
  ///
  Offset direct(double direction, [double distance = 1]) =>
      this + Offset.fromDirection(direction, distance);

  Offset middleTo(Offset p) => (p + this) / 2;

  double distanceHalfTo(Offset p) => (p - this).distance / 2;

  double directionPerpendicular({bool counterclockwise = true}) =>
      direction + Radian.angle_90 * (counterclockwise ? 1 : -1);

  ///
  /// [isAtBottomRightOf], [isAtTopLeftOf]
  /// [isAtBottomLeftOf], [isAtTopRightOf]
  ///
  bool isAtBottomRightOf(Offset offset) => this > offset;

  bool isAtTopLeftOf(Offset offset) => this < offset;

  bool isAtBottomLeftOf(Offset offset) => dx < offset.dx && dy > offset.dy;

  bool isAtTopRightOf(Offset offset) => dx > offset.dx && dy < offset.dy;

  ///
  /// [toSize], [toReciprocal]
  /// [toPerpendicularUnit], [toPerpendicular]
  ///
  Size get toSize => Size(dx, dy);

  Offset get toReciprocal => Offset(1 / dx, 1 / dy);

  Offset get toPerpendicularUnit =>
      Offset.fromDirection(directionPerpendicular());

  Offset get toPerpendicular =>
      Offset.fromDirection(directionPerpendicular(), distance);
}

///
/// static methods:
/// [fromZeroTo], ...
///
extension RectExtension on Rect {
  static Rect fromZeroTo(Size size) => Offset.zero & size;

  static Rect fromLTSize(double left, double top, Size size) =>
      Rect.fromLTWH(left, top, size.width, size.height);

  static Rect fromOffsetSize(Offset zero, Size size) =>
      Rect.fromLTWH(zero.dx, zero.dy, size.width, size.height);

  static Rect fromCenterSize(Offset center, Size size) =>
      Rect.fromCenter(center: center, width: size.width, height: size.height);

  static Rect fromCircle(Offset center, double radius) =>
      Rect.fromCircle(center: center, radius: radius);

  ///
  ///
  /// instance methods
  ///
  ///
  double get distanceDiagonal => size.diagonal;

  Offset offsetFromDirection(Direction direction) => switch (direction) {
        Direction2D() => () {
            final direction2DIn8 = switch (direction) {
              Direction2DIn4() => direction.toDirection8,
              Direction2DIn8() => direction,
            };
            return switch (direction2DIn8) {
              Direction2DIn8.top => topCenter,
              Direction2DIn8.left => centerLeft,
              Direction2DIn8.right => centerRight,
              Direction2DIn8.bottom => bottomCenter,
              Direction2DIn8.topLeft => topLeft,
              Direction2DIn8.topRight => topRight,
              Direction2DIn8.bottomLeft => bottomLeft,
              Direction2DIn8.bottomRight => bottomRight,
            };
          }(),
        Direction3D() => throw UnimplementedError(),
      };
}

///
///
///
/// alignment
///
///
///

///
/// [flipped]
/// [radianRangeForSide], [radianBoundaryForSide]
/// [radianRangeForSideStepOf]
/// [directionOfSideSpace]
///
/// [parseRect]
///
///
extension AlignmentExtension on Alignment {
  Alignment get flipped => Alignment(-x, -y);

  static Alignment fromDirection(Direction2D direction) => switch (direction) {
        Direction2DIn4() => fromDirection(direction.toDirection8),
        Direction2DIn8() => switch (direction) {
            Direction2DIn8.top => Alignment.topCenter,
            Direction2DIn8.left => Alignment.centerLeft,
            Direction2DIn8.right => Alignment.centerRight,
            Direction2DIn8.bottom => Alignment.bottomCenter,
            Direction2DIn8.topLeft => Alignment.topLeft,
            Direction2DIn8.topRight => Alignment.topRight,
            Direction2DIn8.bottomLeft => Alignment.bottomLeft,
            Direction2DIn8.bottomRight => Alignment.bottomRight,
          }
      };

  double get radianRangeForSide {
    final boundary = radianBoundaryForSide;
    return boundary.$2 - boundary.$1;
  }

  (double, double) get radianBoundaryForSide => switch (this) {
        Alignment.center => (0, Radian.angle_360),
        Alignment.centerLeft => (-Radian.angle_90, Radian.angle_90),
        Alignment.centerRight => (Radian.angle_90, Radian.angle_270),
        Alignment.topCenter => (0, Radian.angle_180),
        Alignment.topLeft => (0, Radian.angle_90),
        Alignment.topRight => (Radian.angle_90, Radian.angle_180),
        Alignment.bottomCenter => (Radian.angle_180, Radian.angle_360),
        Alignment.bottomLeft => (Radian.angle_270, Radian.angle_360),
        Alignment.bottomRight => (Radian.angle_180, Radian.angle_270),
        _ => throw UnimplementedError(),
      };

  double radianRangeForSideStepOf(int count) =>
      radianRangeForSide / (this == Alignment.center ? count : count - 1);

  Generator<double> directionOfSideSpace(bool isClockwise, int count) {
    final boundary = radianBoundaryForSide;
    final origin = isClockwise ? boundary.$1 : boundary.$2;
    final step = radianRangeForSideStepOf(count);

    return isClockwise
        ? (index) => origin + step * index
        : (index) => origin - step * index;
  }

  Offset parseRect(Rect rect) => switch (this) {
        Alignment.topLeft => rect.topLeft,
        Alignment.topCenter => rect.topCenter,
        Alignment.topRight => rect.topRight,
        Alignment.centerLeft => rect.centerLeft,
        Alignment.center => rect.center,
        Alignment.centerRight => rect.centerRight,
        Alignment.bottomLeft => rect.bottomLeft,
        Alignment.bottomCenter => rect.bottomCenter,
        Alignment.bottomRight => rect.bottomRight,
        _ => throw UnimplementedError(),
      };
}

///
///
/// static methods:
/// [keep], ...
///
/// instance methods:
///
///
extension BoxConstraintsExtension on BoxConstraints {
  ///
  /// [keep], [keepLoosen]
  ///
  static BoxConstraints keep(BoxConstraints v) => v;

  static BoxConstraints keepLoosen(BoxConstraints constraints) =>
      constraints.loosen();
}




///
///
///
/// [PathExtension]
///
///

///
///
///
/// [moveToPoint], [lineToPoint], [moveOrLineToPoint]
/// [lineFromAToB], [lineFromAToAll]
/// [arcFromStartToEnd]
///
/// [quadraticBezierToPoint]
/// [quadraticBezierToRelativePoint]
/// [cubicToPoint]
/// [cubicToRelativePoint]
/// [cubicOffset]
///
/// [addOvalFromCircle]
/// [addRectFromPoints]
/// [addRectFromCenter]
/// [addRectFromLTWH]
///
///
extension PathExtension on Path {
  ///
  /// move, line, arc
  ///
  void moveToPoint(Offset point) => moveTo(point.dx, point.dy);

  void lineToPoint(Offset point) => lineTo(point.dx, point.dy);

  void moveOrLineToPoint(Offset point, bool shouldMove) =>
      shouldMove ? moveToPoint(point) : lineTo(point.dx, point.dy);

  void lineFromAToB(Offset a, Offset b) => this
    ..moveToPoint(a)
    ..lineToPoint(b);

  void lineFromAToAll(Offset a, Iterable<Offset> points) => points.fold<Path>(
        this..moveToPoint(a),
        (path, point) => path..lineToPoint(point),
      );

  void arcFromStartToEnd(
    Offset arcStart,
    Offset arcEnd, {
    Radius radius = Radius.zero,
    bool clockwise = true,
    double rotation = 0.0,
    bool largeArc = false,
  }) =>
      this
        ..moveToPoint(arcStart)
        ..arcToPoint(
          arcEnd,
          radius: radius,
          clockwise: clockwise,
          rotation: rotation,
          largeArc: largeArc,
        );

  ///
  /// quadratic, cubic
  ///

  // see https://www.youtube.com/watch?v=aVwxzDHniEw for explanation of cubic bezier
  void quadraticBezierToPoint(Offset controlPoint, Offset endPoint) =>
      quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void quadraticBezierToRelativePoint(Offset controlPoint, Offset endPoint) =>
      relativeQuadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToPoint(
    Offset controlPoint1,
    Offset controlPoint2,
    Offset endPoint,
  ) =>
      cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicToRelativePoint(
    Offset controlPoint1,
    Offset controlPoint2,
    Offset endPoint,
  ) =>
      relativeCubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

  void cubicOffset(CubicOffset offsets) => this
    ..moveToPoint(offsets.a)
    ..cubicToPoint(offsets.b, offsets.c, offsets.d);

  ///
  ///
  ///
  /// shape
  ///
  ///
  ///
  void addOvalFromCircle(Offset center, double radius) =>
      addOval(Rect.fromCircle(center: center, radius: radius));

  void addRectFromPoints(Offset a, Offset b) => addRect(Rect.fromPoints(a, b));

  void addRectFromCenter(Offset center, double width, double height) =>
      addRect(Rect.fromCenter(center: center, width: width, height: height));

  void addRectFromLTWH(double left, double top, double width, double height) =>
      addRect(Rect.fromLTWH(left, top, width, height));
}

extension RenderBoxExtension on RenderBox {
  Rect get fromLocalToGlobalRect =>
      RectExtension.fromOffsetSize(localToGlobal(Offset.zero), size);
}

extension PositionedExtension on Positioned {
  Rect? get rect =>
      (left == null || top == null || width == null || height == null)
          ? null
          : Rect.fromLTWH(left!, top!, width!, height!);
}

///
///
/// [TransformExtension] is an extension for translating from "my coordinate system" to "dart coordinate system".
/// the discussion here follows the definitions in the comment above [Radian3.direct].
/// To distinguish the coordinate system between "my coordinate system" to "dart coordinate system",
/// it's necessary to read the comment above [Radian3.direct], which shows what "my coordinate system" is.
///
/// [Direction3DIn6] is a link between "dart coordinate system" and "my coordinate system",
/// the comment belows shows the way how "dart coordinate system" can be described by [Direction3DIn6].
/// take [Offset.fromDirection] for example, its radian 0 ~ 2π going through:
///   1. [Direction3DIn6.right]
///   2. [Direction3DIn6.bottom]
///   3. [Direction3DIn6.left]
///   4. [Direction3DIn6.top]
///   5. [Direction3DIn6.right], ...
/// its evidence that [Offset.fromDirection] start from [Direction3DIn6.right],
/// and the axis of [Offset.fromDirection] can be presented as "[Direction3DIn6.front] -> [Direction3DIn6.back]".
/// because only when the perspective comes from [Direction3DIn6.front] to [Direction3DIn6.back],
/// the order from 1 to 6 is counterclockwise;
/// it's won't be counterclockwise if "[Direction3DIn6.back] -> [Direction3DIn6.front]".
///
/// Not only [Offset], [Transform] and [Matrix4] can also be described by [Direction3DIn6], their:
///   z axis is [Direction3DIn6.front] -> [Direction3DIn6.back], radian start from [Direction3DIn6.right]
///   x axis is [Direction3DIn6.left] -> [Direction3DIn6.right], radian start from [Direction3DIn6.back]
///   y axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom], radian start from [Direction3DIn6.left]
///
///
/// [translateSpace2], ...
/// [visibleFacesOf], ...
/// [ifInQuadrant], ...
///
///
extension TransformExtension on Transform {
  ///
  /// [translateSpace2], [translateSpace3], ...
  ///
  static Point2 translateSpace2(Point2 p) => Point2(p.x, -p.y);

  static Point3 translateSpace3(Point3 p) => Point3(p.x, -p.dz, -p.y);

  ///
  ///
  ///
  static List<Direction3DIn6> visibleFacesOf(Radian3 radian) {
    // final faces = Direction3DIn6.visibleFacesOf(radian);
    throw UnimplementedError();
  }

  ///
  /// [ifInQuadrant]
  /// [ifOnRight], [ifOnLeft], [ifOnTop], [ifOnBottom]
  /// 'right' and 'left' are the same no matter in dart or in math
  ///
  static bool ifInQuadrant(double radian, int quadrant) {
    final r = Radian.moduleBy360Angle(radian);
    return switch (quadrant) {
      1 => r.rangeOpen(Radian.angle_270, Radian.angle_360) ||
          r.rangeOpen(-Radian.angle_90, 0),
      2 => r.rangeOpen(Radian.angle_180, Radian.angle_270) ||
          r.rangeOpen(-Radian.angle_180, -Radian.angle_90),
      3 => r.rangeOpen(Radian.angle_90, Radian.angle_180) ||
          r.rangeOpen(-Radian.angle_270, -Radian.angle_180),
      4 => r.rangeOpen(0, Radian.angle_90) ||
          r.rangeOpen(-Radian.angle_360, -Radian.angle_270),
      _ => throw UnimplementedError(),
    };
  }

  static bool ifOnRight(double radian) => Radian2(radian).azimuthalOnRight;

  static bool ifOnLeft(double radian) => Radian2(radian).azimuthalOnLeft;

  static bool ifOnTop(double radian) =>
      Radian.ifWithinAngle0_180N(Radian.moduleBy360Angle(radian));

  static bool ifOnBottom(double radian) =>
      Radian.ifWithinAngle0_180(Radian.moduleBy360Angle(radian));
}


///
///
/// static methods:
/// [keep], ...
///
/// instance methods:
/// [flippedWhen], ...
///
///
extension CurveExtension on Curve {
  ///
  /// [keep], [keepFlipped]
  ///
  static Curve keep(Curve v) => v;

  static Curve keepFlipped(Curve v) => v.flipped;

  ///
  ///
  /// [flippedWhen]
  /// [interval]
  ///
  ///
  Curve flippedWhen(bool shouldFlip) => shouldFlip ? flipped : this;

  Interval interval(double begin, double end, [bool shouldFlip = false]) =>
      Interval(begin, end, curve: flippedWhen(shouldFlip));
}

///
/// [keep_0231], ...
///
extension CubicExtension on Cubic {
  ///
  /// cubic
  ///
  static Cubic keep_0231(Cubic cubic) =>
      Cubic(cubic.a, cubic.c, cubic.d, cubic.b);

  static Cubic keep_1230(Cubic cubic) =>
      Cubic(cubic.b, cubic.c, cubic.d, cubic.a);
}
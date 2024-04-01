///
///
/// this file contains:
///
/// [SizeExtension]
/// [OffsetExtension]
/// [RectExtension]
/// [AlignmentExtension]
///
/// [IterableOffsetExtension]
/// [ListOffsetExtension]
///
///
///
/// [PathExtension]
/// [RenderBoxExtension]
/// [PositionedExtension]
/// [TransformExtension]
///
///
/// [FSizingPath], [FSizingRect], [FSizingOffset], ...
/// [FPaintFrom], [FPaintingPath], [FPainter]
/// [FRectBuilder]
/// [FExtruding2D]
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
part of damath_flutter;

///
///
///
/// size, offset, rect
///
///

//
extension SizeExtension on Size {
  double get diagonal => (width.squared + height.squared).squareRoot;

  Size weightingWidth(double scale) => Size(width * scale, height);

  Size weightingHeight(double scale) => Size(width, height * scale);

  Size extrudingWidth(double value) => Size(width + value, height);

  Size extrudingHeight(double value) => Size(width, height + value);
}

///
/// instance methods:
/// [fromPoint], ...
/// [parallelUnitOf], ...
/// ...
///
extension OffsetExtension on Offset {
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
/// [deviateBuilder]
///
/// [parseRect]
/// [transformFromDirection]
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
///
/// [IterableOffsetExtension]
///
///
///

///
/// instance methods:
/// [scaling]
/// [adjustCenterFor]
///
/// static methods:
/// [mapperScaling]
/// [companionAdjustCenter]
/// [fillRadiusCircular]
/// [generatorWithValue], [generatorLeftRightLeftRight], [generatorGrouping2], [generatorTopBottomStyle1]
///
///
extension IterableOffsetExtension on Iterable<Offset> {
  Iterable<Offset> scaling(double value) => map((o) => o * value);

  Iterable<Offset> adjustCenterFor(Size size, {Offset origin = Offset.zero}) {
    final center = size.center(origin);
    return map((p) => p + center);
  }

  static Applier<Iterable<Offset>> mapperScaling(double scale) => scale == 1
      ? FMapperMaterial.keepOffsetIterable
      : (points) => points.scaling(scale);

  ///
  /// companion
  ///
  static Iterable<Offset> companionAdjustCenter(
    Iterable<Offset> points,
    Size size,
  ) =>
      points.adjustCenterFor(size);

  ///
  /// fill
  ///
  static Generator<Radius> fillRadiusCircular(double radius) =>
      (_) => Radius.circular(radius);

  ///
  /// generator
  ///
  static Generator<Offset> generatorWithValue(
    double value,
    MapperGenerator<double, Offset> generator,
  ) =>
      (i) => generator(value, i);

  static Generator<Offset> generatorLeftRightLeftRight(
    double dX,
    double dY, {
    required Offset topLeft,
    required Offset Function(int line, double dX, double dY) left,
    required Offset Function(int line, double dX, double dY) right,
  }) =>
      (i) {
        final indexLine = i ~/ 2;
        return topLeft +
            (i % 2 == 0 ? left(indexLine, dX, dY) : right(indexLine, dX, dY));
      };

  static Generator<Offset> generatorGrouping2({
    required double dX,
    required double dY,
    required int modulusX,
    required int modulusY,
    required double constantX,
    required double constantY,
    required double group2ConstantX,
    required double group2ConstantY,
    required int group2ThresholdX,
    required int group2ThresholdY,
  }) =>
      (index) => Offset(
            constantX +
                (index % modulusX) * dX +
                (index > group2ThresholdX ? group2ConstantX : 0),
            constantY +
                (index % modulusY) * dY +
                (index > group2ThresholdY ? group2ConstantY : 0),
          );

  static Generator<Offset> generatorTopBottomStyle1(double group2ConstantY) =>
      generatorGrouping2(
        dX: 78,
        dY: 12,
        modulusX: 6,
        modulusY: 24,
        constantX: -25,
        constantY: -60,
        group2ConstantX: 0,
        group2ConstantY: group2ConstantY,
        group2ThresholdX: 0,
        group2ThresholdY: 11,
      );
}

///
///
///
/// [ListOffsetExtension]
///
///
///

extension ListOffsetExtension on List<Offset> {
  List<Offset> symmetryInsert(
    double dPerpendicular,
    double dParallel,
  ) {
    final length = this.length;
    assert(length % 2 == 0);
    final insertionIndex = length ~/ 2;

    final begin = this[insertionIndex - 1];
    final end = this[insertionIndex];

    final unitParallel = OffsetExtension.parallelUnitOf(begin, end);
    final point =
        begin.middleTo(end) + unitParallel.toPerpendicular * dPerpendicular;

    return this
      ..insertAll(insertionIndex, [
        point - unitParallel * dParallel,
        point + unitParallel * dParallel,
      ]);
  }
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
    final r = RotationUnit.radianModulus360Angle(radian);
    return switch (quadrant) {
      1 => r.within(Radian.angle_270, Radian.angle_360) ||
          r.within(-Radian.angle_90, 0),
      2 => r.within(Radian.angle_180, Radian.angle_270) ||
          r.within(-Radian.angle_180, -Radian.angle_90),
      3 => r.within(Radian.angle_90, Radian.angle_180) ||
          r.within(-Radian.angle_270, -Radian.angle_180),
      4 => r.within(0, Radian.angle_90) ||
          r.within(-Radian.angle_360, -Radian.angle_270),
      _ => throw UnimplementedError(),
    };
  }

  static bool ifOnRight(double radian) => Radian2(radian).azimuthalOnRight;

  static bool ifOnLeft(double radian) => Radian2(radian).azimuthalOnLeft;

  static bool ifOnTop(double radian) => RotationUnit.radianIfWithinAngle0_180N(
      RotationUnit.radianModulus360Angle(radian));

  static bool ifOnBottom(double radian) =>
      RotationUnit.radianIfWithinAngle0_180(
          RotationUnit.radianModulus360Angle(radian));
}

///
/// instance methods
/// [combine]
///
/// static methods:
/// [of], [combineAll]
/// [lineTo], ..., [bezierQuadratic], [bezierCubic], ...
///
/// [rect], ...
/// [rRect], ...
/// [oval], ..., [circle]
/// [polygon], ...
/// [shapeBorder]
///
/// [pie], [pieOfLeftRight], ...
/// [finger], [crayon], [trapeziumSymmetry]
///
extension FSizingPath on SizingPath {
  SizingPath combine(
    SizingPath another, {
    PathOperation operation = PathOperation.union,
  }) =>
      (size) => Path.combine(operation, this(size), another(size));

  static SizingPath of(Path value) => (_) => value;

  static SizingPath combineAll(
    Iterable<SizingPath> iterable, {
    PathOperation operation = PathOperation.union,
  }) =>
      iterable.reduce((a, b) => a.combine(b, operation: operation));

  ///
  /// line
  ///
  static SizingPath lineTo(Offset point) => (_) => Path()..lineToPoint(point);

  static SizingPath connect(Offset a, Offset b) =>
      (size) => Path()..lineFromAToB(a, b);

  static SizingPath connectAll({
    Offset begin = Offset.zero,
    required Iterable<Offset> points,
    PathFillType pathFillType = PathFillType.nonZero,
  }) =>
      (size) => Path()
        ..lineFromAToAll(begin, points)
        ..fillType = pathFillType;

  static SizingPath lineToFromSize(SizingOffset point) =>
      (size) => Path()..lineToPoint(point(size));

  static SizingPath connectFromSize(
    SizingOffset a,
    SizingOffset b,
  ) =>
      (size) => Path()..lineFromAToB(a(size), b(size));

  static SizingPath connectAllFromSize({
    SizingOffset begin = FSizingOffset.zero,
    required SizingOffsetIterable points,
    PathFillType pathFillType = PathFillType.nonZero,
  }) =>
      (size) => Path()
        ..lineFromAToAll(begin(size), points(size))
        ..fillType = pathFillType;

  static SizingPath bezierQuadratic(
    Offset controlPoint,
    Offset end, {
    Offset begin = Offset.zero,
  }) =>
      begin == Offset.zero
          ? (size) => Path()..quadraticBezierToPoint(controlPoint, end)
          : (size) => Path()
            ..moveToPoint(begin)
            ..quadraticBezierToPoint(controlPoint, end);

  static SizingPath bezierCubic(
    Offset c1,
    Offset c2,
    Offset end, {
    Offset begin = Offset.zero,
  }) =>
      begin == Offset.zero
          ? (size) => Path()..cubicToPoint(c1, c2, end)
          : (size) => Path()
            ..moveToPoint(begin)
            ..cubicToPoint(c1, c2, end);

  ///
  /// rect
  ///
  static SizingPath get rectFullSize =>
      (size) => Path()..addRect(Offset.zero & size);

  static SizingPath rect(Rect rect) => (size) => Path()..addRect(rect);

  static SizingPath rectFromZeroToSize(Size size) =>
      (_) => Path()..addRect(Offset.zero & size);

  static SizingPath rectFromZeroToOffset(Offset offset) =>
      (size) => Path()..addRect(Rect.fromPoints(Offset.zero, offset));

  ///
  /// rRect
  ///
  static SizingPath rRect(RRect rRect) => (size) => Path()..addRRect(rRect);

  ///
  /// oval
  ///
  static SizingPath oval(Rect rect) => (size) => Path()..addOval(rect);

  static SizingPath ovalFromCenterSize(Offset center, Size size) =>
      oval(RectExtension.fromCenterSize(center, size));

  static SizingPath circle(Offset center, double radius) =>
      oval(RectExtension.fromCircle(center, radius));

  ///
  /// polygon
  ///
  /// [polygon], [polygonFromSize]
  /// [polygonCubic], [polygonCubicFromSize]
  ///
  /// 1. see [RegularPolygon.cornersOf] to create corners of regular polygon
  /// 2. [polygonCubic.cornersCubic] should be the cubic points related to polygon corners in clockwise or counterclockwise sequence
  /// every element list of [cornersCubic] will be treated as [beginPoint, controlPointA, controlPointB, endPoint]
  /// see [RRegularPolygon.cubicPoints] and its subclasses for creating [cornersCubic]
  ///
  ///
  static SizingPath polygon(List<Offset> corners) =>
      (size) => Path()..addPolygon(corners, false);

  static SizingPath polygonFromSize(SizingOffsetList corners) =>
      (size) => Path()..addPolygon(corners(size), false);

  static SizingPath _polygonCubic(
    SizingCubicOffsetIterable points,
    double scale, {
    Companion<CubicOffset, Size>? adjust,
  }) {
    final Applier<Iterable<CubicOffset>> scaled = scale == 1
        ? FApplier.keep
        : (corners) => corners.map((cubics) => cubics * scale);

    Path from(Iterable<CubicOffset> offsets) =>
        scaled(offsets).iterator.foldByIndex(
              Path(),
              (path, points, index) => path
                ..moveOrLineToPoint(points.a, index == 0)
                ..cubicToPoint(points.b, points.c, points.d),
            )..close();

    return adjust == null
        ? (size) => from(points(size))
        : (size) => from(points(size).map((points) => adjust(points, size)));
  }

  static SizingPath polygonCubic(
    Iterable<CubicOffset> cornersCubic, {
    double scale = 1,
    Companion<CubicOffset, Size>? adjust,
  }) =>
      _polygonCubic((_) => cornersCubic, scale, adjust: adjust);

  static SizingPath polygonCubicFromSize(
    SizingCubicOffsetIterable cornersCubic, {
    double scale = 1,
    Companion<CubicOffset, Size>? adjust,
  }) =>
      _polygonCubic(cornersCubic, scale, adjust: adjust);

  ///
  /// [shapeBorderOuter]
  /// [shapeBorderInner]
  /// [shapeBorder]
  ///
  static SizingPath shapeBorderOuter(
    ShapeBorder shape,
    SizingRect sizingRect,
    TextDirection? textDirection,
  ) =>
      (size) => shape.getOuterPath(
            sizingRect(size),
            textDirection: textDirection,
          );

  static SizingPath shapeBorderInner(
    ShapeBorder shape,
    SizingRect sizingRect,
    TextDirection? textDirection,
  ) =>
      (size) => shape.getInnerPath(
            sizingRect(size),
            textDirection: textDirection,
          );

  static SizingPath shapeBorder(
    ShapeBorder shape, {
    TextDirection? textDirection,
    bool outerPath = true,
    SizingRect sizingRect = FSizingRect.full,
  }) =>
      outerPath
          ? shapeBorderOuter(shape, sizingRect, textDirection)
          : shapeBorderInner(shape, sizingRect, textDirection);

  ///
  /// [pie]
  /// [pieFromCenterDirectionRadius]
  /// [pieFromSize]
  /// [pieOfLeftRight]
  ///
  static SizingPath pie(
    Offset arcStart,
    Offset arcEnd, {
    bool clockwise = true,
  }) {
    final radius = Radius.circular(arcEnd.distanceHalfTo(arcStart));
    return (size) => Path()
      ..arcFromStartToEnd(arcStart, arcEnd,
          radius: radius, clockwise: clockwise)
      ..close();
  }

  static SizingPath pieFromSize({
    required SizingOffset arcStart,
    required SizingOffset arcEnd,
    bool clockwise = true,
  }) =>
      (size) {
        final start = arcStart(size);
        final end = arcEnd(size);
        return Path()
          ..moveToPoint(start)
          ..arcToPoint(
            end,
            radius: Radius.circular(end.distanceHalfTo(start)),
            clockwise: clockwise,
          )
          ..close();
      };

  static SizingPath pieOfLeftRight(bool isRight) => isRight
      ? FSizingPath.pieFromSize(
          arcStart: (size) => Offset.zero,
          arcEnd: (size) => size.bottomLeft(Offset.zero),
          clockwise: true,
        )
      : FSizingPath.pieFromSize(
          arcStart: (size) => size.topRight(Offset.zero),
          arcEnd: (size) => size.bottomRight(Offset.zero),
          clockwise: false,
        );

  static SizingPath pieFromCenterDirectionRadius(
    Offset arcCenter,
    double dStart,
    double dEnd,
    double r, {
    bool clockwise = true,
  }) {
    final arcStart = arcCenter.direct(dStart, r);
    final arcEnd = arcCenter.direct(dEnd, r);
    return (size) => Path()
      ..moveToPoint(arcStart)
      ..arcToPoint(arcEnd, radius: Radius.circular(r), clockwise: clockwise)
      ..close();
  }

  ///
  /// finger
  ///
  ///  ( )
  /// (   )  <---- [tip]
  /// |   |
  /// |   |
  /// |   |
  /// -----  <----[root]
  ///
  static SizingPath finger({
    required Offset rootA,
    required double width,
    required double length,
    required double direction,
    bool clockwise = true,
  }) {
    final tipA = rootA.direct(direction, length);
    final rootB = rootA.direct(
      direction + Radian.angle_90 * (clockwise ? 1 : -1),
      width,
    );
    final tipB = rootB.direct(direction, length);
    final radius = Radius.circular((width / 2));
    return (size) => Path()
      ..moveToPoint(rootA)
      ..lineToPoint(tipA)
      ..arcToPoint(tipB, radius: radius, clockwise: clockwise)
      ..lineToPoint(rootB)
      ..close();
  }

  /// crayon
  ///
  /// -----
  /// |   |
  /// |   |   <----[bodyLength]
  /// |   |
  /// \   /
  ///  ---   <---- [tipWidth]
  ///
  static SizingPath crayon({
    required SizingDouble tipWidth,
    required SizingDouble bodyLength,
  }) =>
      (size) {
        final width = size.width;
        final height = size.height;
        final flatLength = tipWidth(size);
        final penBody = bodyLength(size);

        return Path()
          ..lineTo(width, 0.0)
          ..lineTo(width, penBody)
          ..lineTo((width + flatLength) / 2, height)
          ..lineTo((width - flatLength) / 2, height)
          ..lineTo(0.0, penBody)
          ..lineTo(0.0, 0.0)
          ..close();
      };

  static SizingPath trapeziumSymmetry({
    required SizingOffset topLeftMargin,
    required Applier<Size> body,
    required SizingDouble bodyShortest,
    Direction2DIn4 shortestSide = Direction2DIn4.top,
  }) =>
      (size) {
        // final origin = topLeftMargin(size);
        // final bodySize = body(size);
        throw UnimplementedError();
      };
}

extension FSizingRect on SizingRect {
  static Rect full(Size size) => Offset.zero & size;

  static SizingRect fullFrom(Offset origin) => (size) => origin & size;
}

extension FSizingOffset on SizingOffset {
  static SizingOffset of(Offset value) => (_) => value;

  static Offset zero(Size size) => Offset.zero;

  static Offset topLeft(Size size) => size.topLeft(Offset.zero);

  static Offset topCenter(Size size) => size.topCenter(Offset.zero);

  static Offset topRight(Size size) => size.topRight(Offset.zero);

  static Offset centerLeft(Size size) => size.centerLeft(Offset.zero);

  static Offset center(Size size) => size.center(Offset.zero);

  static Offset centerRight(Size size) => size.centerRight(Offset.zero);

  static Offset bottomLeft(Size size) => size.bottomLeft(Offset.zero);

  static Offset bottomCenter(Size size) => size.bottomCenter(Offset.zero);

  static Offset bottomRight(Size size) => size.bottomRight(Offset.zero);
}

///
///
///
///
/// painting
///
///
///
///
///

// paint from
extension FPaintFrom on PaintFrom {
  static PaintFrom of(Paint paint) => (_, __) => paint;
}

// painting path
extension FPaintingPath on PaintingPath {
  static void draw(Canvas canvas, Paint paint, Path path) =>
      canvas.drawPath(path, paint);
}

// painter
extension FPainter on Painter {
  static Painter of(
    PaintFrom paintFrom, {
    PaintingPath paintingPath = FPaintingPath.draw,
  }) =>
      (sizingPath) => Painting.rePaintWhenUpdate(
            paintingPath: paintingPath,
            sizingPath: sizingPath,
            paintFrom: paintFrom,
          );
}

///
///
/// function extensions
///
///
///

///
/// rect builder
///
extension FRectBuilder on RectBuilder {
  static RectBuilder get zero => (context) => Rect.zero;

  ///
  /// rect
  ///
  static RectBuilder get rectZeroToFull =>
      (context) => Offset.zero & context.sizeMedia;

  static RectBuilder rectZeroToSize(Sizing sizing) =>
      (context) => Offset.zero & sizing(context.sizeMedia);

  static RectBuilder rectOffsetToSize(
    SizingOffset positioning,
    Sizing sizing,
  ) =>
      (context) {
        final size = context.sizeMedia;
        return positioning(size) & sizing(size);
      };

  ///
  /// circle
  ///
  static RectBuilder get circleZeroToFull => (context) =>
      RectExtension.fromCircle(Offset.zero, context.sizeMedia.diagonal);

  static RectBuilder circleZeroToRadius(SizingDouble sizing) =>
      (context) => RectExtension.fromCircle(
            Offset.zero,
            sizing(context.sizeMedia),
          );

  static RectBuilder circleOffsetToSize(
    SizingOffset positioning,
    SizingDouble sizing,
  ) =>
      (context) {
        final size = context.sizeMedia;
        return RectExtension.fromCircle(positioning(size), sizing(size));
      };

  ///
  /// oval
  ///
  static RectBuilder get ovalZeroToFull =>
      (context) => RectExtension.fromCenterSize(Offset.zero, context.sizeMedia);

  static RectBuilder ovalZeroToSize(Sizing sizing) =>
      (context) => RectExtension.fromCenterSize(
            Offset.zero,
            sizing(context.sizeMedia),
          );

  static RectBuilder ovalOffsetToSize(
    SizingOffset positioning,
    Sizing sizing,
  ) =>
      (context) {
        final size = context.sizeMedia;
        return RectExtension.fromCenterSize(positioning(size), sizing(size));
      };
}

///
///
/// [FExtruding2D]
///
///

///
/// static methods:
/// [directOnSize], [directOnWidth], [directByDimension]
/// [fromRectDirection]
///
/// instance methods:
/// [translateOnSize], [translateOnWidth], [translateOfDimension]
///
///
extension FExtruding2D on Extruding2D {
  static Mapper<double, Rect> directOnSize({
    required Rect rect,
    required Direction2D direction,
    required double width,
    required double height,
    bool timesOrPlus = true,
  }) =>
      fromRectDirection(rect, direction).translateOnSize(
        width,
        height,
        timesOrPlus: timesOrPlus,
      );

  static Mapper<double, Rect> directOnWidth({
    required Rect rect,
    required Direction2D direction,
    required double width,
  }) =>
      fromRectDirection(rect, direction).translateOnWidth(width);

  static Mapper<double, Rect> directByDimension({
    required Rect rect,
    required Direction2D direction,
    required double dimension,
    bool timesOrPlus = true,
  }) =>
      fromRectDirection(rect, direction).translateOfDimension(
        dimension,
        timesOrPlus: timesOrPlus,
      );

  static Extruding2D fromRectDirection(Rect rect, Direction2D direction) =>
      switch (direction) {
        Direction2DIn4.top || Direction2DIn8.top => () {
            final origin = rect.topCenter;
            return (width, length) => Rect.fromPoints(
                  origin + Offset(width / 2, 0),
                  origin + Offset(-width / 2, -length),
                );
          }(),
        Direction2DIn4.left || Direction2DIn8.left => () {
            final origin = rect.centerLeft;
            return (width, length) => Rect.fromPoints(
                  origin + Offset(0, width / 2),
                  origin + Offset(-length, -width / 2),
                );
          }(),
        Direction2DIn4.right || Direction2DIn8.right => () {
            final origin = rect.centerRight;
            return (width, length) => Rect.fromPoints(
                  origin + Offset(0, width / 2),
                  origin + Offset(length, -width / 2),
                );
          }(),
        Direction2DIn4.bottom || Direction2DIn8.bottom => () {
            final origin = rect.bottomCenter;
            return (width, length) => Rect.fromPoints(
                  origin + Offset(width / 2, 0),
                  origin + Offset(-width / 2, length),
                );
          }(),
        Direction2DIn8.topLeft => () {
            final origin = rect.topLeft;
            return (width, length) => Rect.fromPoints(
                  origin,
                  origin + Offset(-length, -length) * DoubleExtension.sqrt1_2,
                );
          }(),
        Direction2DIn8.topRight => () {
            final origin = rect.topRight;
            return (width, length) => Rect.fromPoints(
                  origin,
                  origin + Offset(length, -length) * DoubleExtension.sqrt1_2,
                );
          }(),
        Direction2DIn8.bottomLeft => () {
            final origin = rect.bottomLeft;
            return (width, length) => Rect.fromPoints(
                  origin,
                  origin + Offset(-length, length) * DoubleExtension.sqrt1_2,
                );
          }(),
        Direction2DIn8.bottomRight => () {
            final origin = rect.bottomRight;
            return (width, length) => Rect.fromPoints(
                  origin,
                  origin + Offset(length, length) * DoubleExtension.sqrt1_2,
                );
          }(),
      };

  ///
  /// when [timesOrPlus] == true, its means that extruding value will be multiplied on [height]
  /// when [timesOrPlus] == false, its means that extruding value will be added on [height]
  ///
  Mapper<double, Rect> translateOnSize(
    double width,
    double height, {
    bool timesOrPlus = true,
  }) {
    final calculating = timesOrPlus ? (v) => height * v : (v) => height + v;
    return (value) => this(width, calculating(value));
  }

  Mapper<double, Rect> translateOnWidth(double width) =>
      translateOnSize(width, 0, timesOrPlus: false);

  Mapper<double, Rect> translateOfDimension(
    double dimension, {
    bool timesOrPlus = true,
  }) =>
      translateOnSize(dimension, dimension, timesOrPlus: timesOrPlus);
}

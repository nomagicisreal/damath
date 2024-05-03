///
///
/// this file contains:
///
/// [FSizingPath], [FSizingRect], [FSizingOffset], ...
/// [FPaintFrom], [FPaintingPath], [FPainter]
/// [FRectBuilder]
/// [FExtruding2D]
///
/// [FOnAnimateMatrix4]
///
///
///
///
///
part of damath_flutter;

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
  /// 1. see [FlutterRegularPolygon.cornersOf] to create corners of regular polygon
  /// 2. [polygonCubic.cornersCubic] should be the cubic points related to polygon corners in clockwise or counterclockwise sequence
  /// every element list of [cornersCubic] will be treated as [beginPoint, controlPointA, controlPointB, endPoint]
  /// see [FlutterRRegularPolygon.cubicPoints] and its subclasses for creating [cornersCubic]
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
        ? FKeep.applier
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


///
/// instance methods for [Matrix4]
/// [getPerspective]
/// [setPerspective], [setDistance]
/// [copyPerspective], [identityPerspective]
///
/// [translateOf], [rotateOf], [scaledOf]
/// [rotateOn]
///
/// static methods:
/// [translating], [rotating], [scaling]
/// [mapTranslating], [mapRotating], [mapScaling]
/// [fixedTranslating], [fixedRotating], [fixedScaling]
///
///
extension FOnAnimateMatrix4 on Matrix4 {
  double getPerspective() => entry(3, 2);

  void setPerspective(double perspective) => setEntry(3, 2, perspective);

  void setDistance(double? distance) =>
      setPerspective(distance == null ? 0 : 1 / distance);

  void copyPerspective(Matrix4 matrix4) =>
      setPerspective(matrix4.getPerspective());

  Matrix4 get identityPerspective => Matrix4.identity()..copyPerspective(this);

  ///
  /// [translateOf], [rotateOf], [scaledOf]
  ///
  void translateOf(Point3 space3) =>
      translate(v64.Vector3(space3.x, space3.y, space3.z));

  void rotateOf(Point3 space3) => this
    ..rotateX(space3.x)
    ..rotateY(space3.y)
    ..rotateZ(space3.z);

  Matrix4 scaledOf(Point3 space3) => scaled(space3.x, space3.y, space3.z);

  ///
  /// [rotateOn]
  ///
  void rotateOn(Point3 space3, double radian) =>
      rotate(v64.Vector3(space3.x, space3.y, space3.z), radian);

  ///
  ///
  /// statics
  ///
  ///
  static Matrix4 translating(Matrix4 matrix4, Point3 value) =>
      matrix4.identityPerspective..translateOf(value);

  static Matrix4 rotating(Matrix4 matrix4, Point3 value) =>
      matrix4..setRotation((Matrix4.identity()..rotateOf(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Point3 value) =>
      matrix4.scaledOf(value);

// with mapping
  static OnAnimateMatrix4 mapTranslating(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateOf(mapping(value));

  static OnAnimateMatrix4 mapRotating(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(mapping(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Applier<Point3> mapping) =>
          (matrix4, value) => matrix4.scaledOf(mapping(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Point3 fixed) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateOf(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Point3 fixed) =>
          (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Point3 fixed) =>
          (matrix4, value) => matrix4.scaledOf(value + fixed);
}

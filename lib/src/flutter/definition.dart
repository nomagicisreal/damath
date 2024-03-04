///
///
/// this file contains:
///
///
/// typedefs:
/// [Extruding2D]
/// [TextFormFieldValidator]
///
/// [SizingPath], [SizingOffset], ...
/// [PaintFrom], [PaintingPath], [Painter]
/// [RectBuilder]
///
///
///
///
/// classes:
/// [Painting], [Clipping]
///
/// [Curving], [CurveFR]
///
/// [CubicOffset]
///
/// [RegularPolygon]
///   [RRegularPolygon]
///     [RRegularPolygonCubicOnEdge]
///       [RsRegularPolygon]
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
typedef Extruding2D = Rect Function(double width, double height);

typedef TextFormFieldValidator = FormFieldValidator<String> Function(
  String failedMessage,
);

///
///
/// sizing
///
///
typedef Sizing = Size Function(Size size);
typedef SizingDouble = double Function(Size size);
typedef SizingOffset = Offset Function(Size size);
typedef SizingRect = Rect Function(Size size);
typedef SizingPath = Path Function(Size size);
typedef SizingPathFrom<T> = SizingPath Function(T value);
typedef SizingOffsetIterable = Iterable<Offset> Function(Size size);
typedef SizingOffsetList = List<Offset> Function(Size size);
typedef SizingCubicOffsetIterable = Iterable<CubicOffset> Function(Size size);

///
/// painting
///
typedef PaintFrom = Paint Function(Canvas canvas, Size size);
typedef PaintingPath = void Function(Canvas canvas, Paint paint, Path path);
typedef Painter = Painting Function(SizingPath sizingPath);

///
/// rect
///
typedef RectBuilder = Rect Function(BuildContext context);

///
///
/// [Painting], [Clipping],
///
///

///
/// [_shouldRePaint]
/// [paintFrom]
/// [sizingPath]
/// [paintingPath]
///
/// [Painting.rePaintWhenUpdate]
/// [Painting.rePaintNever]
///
///
class Painting extends CustomPainter {
  final Combiner<Painting, bool> _shouldRePaint;
  final SizingPath sizingPath;
  final PaintFrom paintFrom;
  final PaintingPath paintingPath;

  @override
  void paint(Canvas canvas, Size size) {
    final path = sizingPath(size);
    final paint = paintFrom(canvas, size);
    paintingPath(canvas, paint, path);
  }

  @override
  bool shouldRepaint(Painting oldDelegate) => _shouldRePaint(oldDelegate, this);

  static bool _rePaintWhenUpdate(Painting oldP, Painting p) => true;

  static bool _rePaintNever(Painting oldP, Painting p) => false;

  const Painting.rePaintWhenUpdate({
    this.paintingPath = FPaintingPath.draw,
    required this.sizingPath,
    required this.paintFrom,
  }) : _shouldRePaint = _rePaintWhenUpdate;

  const Painting.rePaintNever({
    this.paintingPath = FPaintingPath.draw,
    required this.paintFrom,
    required this.sizingPath,
  }) : _shouldRePaint = _rePaintNever;

  ///
  /// factories
  ///
  factory Painting.rRegularPolygon(
    PaintFrom paintFrom,
    RRegularPolygon polygon,
  ) =>
      Painting.rePaintNever(
        paintFrom: paintFrom,
        sizingPath: FSizingPath.polygonCubic(polygon.cubicPoints),
      );
}

///
///
/// [_shouldReClip]
/// [sizingPath]
///
/// [Clipping.reclipWhenUpdate]
/// [Clipping.reclipNever]
///
/// [Clipping.rectOf]
/// [Clipping.rectFromZeroTo]
/// [Clipping.rectFromZeroToOffset]
/// [Clipping.rRegularPolygon]
///
///
class Clipping extends CustomClipper<Path> {
  final SizingPath sizingPath;
  final Combiner<Clipping, bool> _shouldReClip;

  @override
  Path getClip(Size size) => sizingPath(size);

  @override
  bool shouldReclip(Clipping oldClipper) => _shouldReClip(oldClipper, this);

  static bool _reclipWhenUpdate(Clipping oldC, Clipping c) => true;

  static bool _reclipNever(Clipping oldC, Clipping c) => false;

  const Clipping.reclipWhenUpdate(this.sizingPath)
      : _shouldReClip = _reclipWhenUpdate;

  const Clipping.reclipNever(this.sizingPath) : _shouldReClip = _reclipNever;

  ///
  /// factories
  ///
  factory Clipping.rectOf(Rect rect) =>
      Clipping.reclipNever(FSizingPath.rect(rect));

  factory Clipping.rectFromZeroTo(Size size) =>
      Clipping.rectOf(Offset.zero & size);

  factory Clipping.rectFromZeroToOffset(Offset corner) =>
      Clipping.rectOf(Rect.fromPoints(Offset.zero, corner));

  factory Clipping.rRegularPolygon(
    RRegularPolygon polygon, {
    Companion<CubicOffset, Size> adjust = CubicOffset.companionSizeAdjustCenter,
  }) =>
      Clipping.reclipNever(
        FSizingPath.polygonCubic(polygon.cubicPoints, adjust: adjust),
      );
}

///
///
///
/// [Curving], [CurveFR]
///
///
///

///
/// [mapper]
///
/// [Curving.sinPeriodOf]
/// [Curving.cosPeriodOf]
/// [Curving.tanPeriodOf]
///
class Curving extends Curve {
  final Mapper<double> mapper;

  const Curving(this.mapper);

  Curving.sinPeriodOf(int times)
      : mapper = FMapperDouble.fromPeriodSinByTimes(times);

  Curving.cosPeriodOf(int times)
      : mapper = FMapperDouble.fromPeriodCosByTimes(times);

  Curving.tanPeriodOf(int times)
      : mapper = FMapperDouble.fromPeriodTanByTimes(times);

  @override
  double transformInternal(double t) => mapper(t);
}

///
/// [forward], [reverse]
///
/// [CurveFR.of], [CurveFR.intervalOf], [CurveFR.intervalForwardOf], [CurveFR.intervalReverseOf], ...
/// [CurveFR.flip], [CurveFR.flipIntervalOf], [CurveFR.flipIntervalForwardOf], [CurveFR.flipIntervalReverseOf], ...
///
/// static methods, constants:
/// [fusionIntervalFlipIn]
/// [fusionIntervalFlipForSymmetryPeriodSinIn]
/// [all]
///
/// instance methods:
/// [interval], [flipped]
///
///
class CurveFR {
  final Curve forward;
  final Curve reverse;

  const CurveFR(this.forward, this.reverse);

  ///
  /// of
  ///
  const CurveFR.of(Curve curve)
      : forward = curve,
        reverse = curve;

  CurveFR.intervalOf(Curve curve, double begin, double end)
      : forward = Interval(begin, end, curve: curve),
        reverse = Interval(begin, end, curve: curve);

  CurveFR.intervalForwardOf(Curve curve, double begin, double end)
      : forward = Interval(begin, end, curve: curve),
        reverse = curve;

  CurveFR.intervalReverseOf(Curve curve, double begin, double end)
      : forward = curve,
        reverse = Interval(begin, end, curve: curve);

  ///
  /// flip
  ///
  CurveFR.flip(Curve curve)
      : forward = curve,
        reverse = curve.flipped;

  CurveFR.flipIntervalOf(Curve curve, double begin, double end)
      : forward = Interval(begin, end, curve: curve),
        reverse = Interval(begin, end, curve: curve.flipped);

  CurveFR.flipIntervalForwardOf(Curve curve, double begin, double end)
      : forward = Interval(begin, end, curve: curve),
        reverse = curve.flipped;

  CurveFR.flipIntervalReverseOf(Curve curve, double begin, double end)
      : forward = curve,
        reverse = Interval(begin, end, curve: curve.flipped);

  ///
  /// [fusionIntervalFlipIn]
  /// [fusionIntervalFlipForSymmetryPeriodSinIn]
  ///
  static Fusionor<CurveFR, double, double, CurveFR> fusionIntervalFlipIn(
    int steps,
  ) =>
      (curve, begin, end) => curve.interval(begin / steps, end / steps);

  static Fusionor<int, double, double, CurveFR>
      fusionIntervalFlipForSymmetryPeriodSinIn(
    int steps,
  ) =>
          (times, begin, end) =>
              CurveFR.of(Curving.sinPeriodOf(times)).interval(
                begin / steps,
                end / steps,
              );

  ///
  /// [all].length == 43, see https://api.flutter.dev/flutter/animation/Curves-class.html?gclid=CjwKCAiA-bmsBhAGEiwAoaQNmg9ZfimSGJRAty3QNZ0AA32ztq51qPlJfFPBsFc5Iv1n-EgFQtULyxoC8q0QAvD_BwE&gclsrc=aw.ds
  ///
  static const List<CurveFR> all = [
    linear,
    decelerate,
    fastLinearToSlowEaseIn,
    fastEaseInToSlowEaseOut,
    ease,
    easeInToLinear,
    linearToEaseOut,
    easeIn,
    easeInSine,
    easeInQuad,
    easeInCubic,
    easeInQuart,
    easeInQuint,
    easeInExpo,
    easeInCirc,
    easeInBack,
    easeOut,
    easeOutSine,
    easeOutQuad,
    easeOutCubic,
    easeOutQuart,
    easeOutQuint,
    easeOutExpo,
    easeOutCirc,
    easeOutBack,
    easeInOut,
    easeInOutSine,
    easeInOutQuad,
    easeInOutCubic,
    easeInOutCubicEmphasized,
    easeInOutQuart,
    easeInOutQuint,
    easeInOutExpo,
    easeInOutCirc,
    easeInOutBack,
    fastOutSlowIn,
    slowMiddle,
    bounceIn,
    bounceOut,
    bounceInOut,
    elasticIn,
    elasticOut,
    elasticInOut,
  ];

  static const linear = CurveFR.of(Curves.linear);
  static const decelerate = CurveFR.of(Curves.decelerate);
  static const fastLinearToSlowEaseIn =
      CurveFR.of(Curves.fastLinearToSlowEaseIn);
  static const fastEaseInToSlowEaseOut =
      CurveFR.of(Curves.fastEaseInToSlowEaseOut);
  static const ease = CurveFR.of(Curves.ease);
  static const easeInToLinear = CurveFR.of(Curves.easeInToLinear);
  static const linearToEaseOut = CurveFR.of(Curves.linearToEaseOut);
  static const easeIn = CurveFR.of(Curves.easeIn);
  static const easeInSine = CurveFR.of(Curves.easeInSine);
  static const easeInQuad = CurveFR.of(Curves.easeInQuad);
  static const easeInCubic = CurveFR.of(Curves.easeInCubic);
  static const easeInQuart = CurveFR.of(Curves.easeInQuart);
  static const easeInQuint = CurveFR.of(Curves.easeInQuint);
  static const easeInExpo = CurveFR.of(Curves.easeInExpo);
  static const easeInCirc = CurveFR.of(Curves.easeInCirc);
  static const easeInBack = CurveFR.of(Curves.easeInBack);
  static const easeOut = CurveFR.of(Curves.easeOut);
  static const easeOutSine = CurveFR.of(Curves.easeOutSine);
  static const easeOutQuad = CurveFR.of(Curves.easeOutQuad);
  static const easeOutCubic = CurveFR.of(Curves.easeOutCubic);
  static const easeOutQuart = CurveFR.of(Curves.easeOutQuart);
  static const easeOutQuint = CurveFR.of(Curves.easeOutQuint);
  static const easeOutExpo = CurveFR.of(Curves.easeOutExpo);
  static const easeOutCirc = CurveFR.of(Curves.easeOutCirc);
  static const easeOutBack = CurveFR.of(Curves.easeOutBack);
  static const easeInOut = CurveFR.of(Curves.easeInOut);
  static const easeInOutSine = CurveFR.of(Curves.easeInOutSine);
  static const easeInOutQuad = CurveFR.of(Curves.easeInOutQuad);
  static const easeInOutCubic = CurveFR.of(Curves.easeInOutCubic);
  static const easeInOutCubicEmphasized =
      CurveFR.of(Curves.easeInOutCubicEmphasized);
  static const easeInOutQuart = CurveFR.of(Curves.easeInOutQuart);
  static const easeInOutQuint = CurveFR.of(Curves.easeInOutQuint);
  static const easeInOutExpo = CurveFR.of(Curves.easeInOutExpo);
  static const easeInOutCirc = CurveFR.of(Curves.easeInOutCirc);
  static const easeInOutBack = CurveFR.of(Curves.easeInOutBack);
  static const fastOutSlowIn = CurveFR.of(Curves.fastOutSlowIn);
  static const slowMiddle = CurveFR.of(Curves.slowMiddle);
  static const bounceIn = CurveFR.of(Curves.bounceIn);
  static const bounceOut = CurveFR.of(Curves.bounceOut);
  static const bounceInOut = CurveFR.of(Curves.bounceInOut);
  static const elasticIn = CurveFR.of(Curves.elasticIn);
  static const elasticOut = CurveFR.of(Curves.elasticOut);
  static const elasticInOut = CurveFR.of(Curves.elasticInOut);

  ///
  /// instance methods
  ///

  CurveFR interval(double begin, double end) => CurveFR(
        Interval(begin, end, curve: forward),
        Interval(begin, end, curve: reverse),
      );

  CurveFR get flipped => CurveFR(reverse, forward);
}

///
///
///
/// [CubicOffset]
///
///
///

class CubicOffset {
  final Cubic x;
  final Cubic y;

  const CubicOffset(this.x, this.y);

  Offset get a => Offset(x.a, y.a);

  Offset get b => Offset(x.b, y.b);

  Offset get c => Offset(x.c, y.c);

  Offset get d => Offset(x.d, y.d);

  CubicOffset.fromPoints(List<Offset> offsets)
      : assert(offsets.length == 4),
        x = Cubic(offsets[0].dx, offsets[1].dx, offsets[2].dx, offsets[3].dx),
        y = Cubic(offsets[0].dy, offsets[1].dy, offsets[2].dy, offsets[3].dy);

  List<Offset> get points =>
      [Offset(x.a, y.a), Offset(x.b, y.b), Offset(x.c, y.c), Offset(x.d, y.d)];

  Offset operator [](int index) => switch (index) {
        0 => Offset(x.a, y.a),
        1 => Offset(x.b, y.b),
        2 => Offset(x.c, y.c),
        3 => Offset(x.d, y.d),
        _ => throw UnimplementedError(index.toString()),
      };

  CubicOffset operator *(double scale) => CubicOffset(
        Cubic(x.a * scale, x.b * scale, x.c * scale, x.d * scale),
        Cubic(y.a * scale, y.b * scale, y.c * scale, y.d * scale),
      );

  CubicOffset mapXY(Mapper<Cubic> mapper) => CubicOffset(mapper(x), mapper(y));

  CubicOffset mapX(Mapper<Cubic> mapper) => CubicOffset(mapper(x), y);

  CubicOffset mapY(Mapper<Cubic> mapper) => CubicOffset(x, mapper(y));

  static CubicOffset companionSizeAdjustCenter(
    CubicOffset cubicOffset,
    Size size,
  ) =>
      CubicOffset.fromPoints(
        cubicOffset.points.adjustCenterFor(size).toList(),
      );
}

///
///
///
///
/// regular polygon
///
///
///
///

//
abstract class RegularPolygon {
  static double radianCornerOf(int n) => (n - 2) * Radian.angle_180 / n;

  static double lengthSideOf(
    int n,
    double radiusCircumscribed, [
    int roundUp = 0,
  ]) =>
      radiusCircumscribed *
      math.sin(Radian.angle_180 / n).roundUpTo(roundUp) *
      2;

  static List<Offset> cornersOf(
    int n,
    double radiusCircumscribedCircle, {
    Size? size,
  }) {
    final step = Radian.angle_360 / n;
    final center = size?.center(Offset.zero) ?? Offset.zero;
    return List.generate(
      n,
      (i) => center + Offset.fromDirection(step * i, radiusCircumscribedCircle),
      growable: false,
    );
  }

  static double inscribedCircleRadiusOf(
    int n,
    num radiusCircumscribedCircle,
    double radianCorner,
  ) =>
      switch (n) {
        3 => radiusCircumscribedCircle / 2,
        4 => radiusCircumscribedCircle * DoubleExtension.sqrt1_2,
        6 => radiusCircumscribedCircle * DoubleExtension.sqrt3 / 2,
        _ => radiusCircumscribedCircle *
            math.sin(Radian.radianFromAngle(Radian.angleOf(radianCorner) / 2)),
      };

  /// properties

  final int n;
  final double radiusCircumscribedCircle;

  List<Offset> get corners => cornersOf(n, radiusCircumscribedCircle);

  double get lengthSide => lengthSideOf(n, radiusCircumscribedCircle);

  double get radianSideSide => radianCornerOf(n);

  double get radianCornerSideCenter => Radian.angle_90;
  double get radianCornerCenterSide => Radian.angle_180 / n;
  double get radianSideCornerCenter => Radian.angle_90 - radianCornerCenterSide;

  double get radiusInscribedCircle => inscribedCircleRadiusOf(
        n,
        radiusCircumscribedCircle,
        radianSideSide,
      );

  const RegularPolygon(
    this.n, {
    required this.radiusCircumscribedCircle,
  });
}

sealed class RRegularPolygon extends RegularPolygon {
  final double cornerRadius;
  final Mapper<Map<Offset, CubicOffset>> cubicPointsMapper;
  final Companion<CubicOffset, Size> cornerAdjust;

  Map<Offset, CubicOffset> get cubicPointsForEachCorners;

  Iterable<CubicOffset> get cubicPoints =>
      cubicPointsMapper(cubicPointsForEachCorners).values;

  const RRegularPolygon(
    super.n, {
    required this.cornerRadius,
    required this.cornerAdjust,
    required this.cubicPointsMapper,
    required super.radiusCircumscribedCircle,
  });
}

///
///
/// [RRegularPolygonCubicOnEdge.cubicPointsForEachCorners]
/// [RRegularPolygonCubicOnEdge.timesForEdgeUnitOf]
/// [RRegularPolygonCubicOnEdge.cubicPointsForEachCornersOf]
///
/// each list of [cubicPointsForEachCorners] is based on the constant properties of [RRegularPolygonCubicOnEdge].
///
/// See Also:
///   * [KMapperCubicPointsPermutation]
///   * [FSizingPath.polygonCubic], [FSizingPath.polygonCubicFromSize]
///   * [BetweenPathPolygon.regularCubicOnEdge]
///
///
class RRegularPolygonCubicOnEdge extends RRegularPolygon {
  final double timesForEdge;

  const RRegularPolygonCubicOnEdge(
    super.n, {
    this.timesForEdge = 0,
    super.cornerRadius = 0,
    super.cubicPointsMapper = _cubicPointsMapper,
    super.cornerAdjust = CubicOffset.companionSizeAdjustCenter,
    required super.radiusCircumscribedCircle,
  });

  // [cornerPrevious, controlPointA, controlPointB, cornerNext]
  static Map<Offset, CubicOffset> _cubicPointsMapper(
    Map<Offset, CubicOffset> points,
  ) =>
      points.mapValues((value) => value.mapXY(FMapperMaterial.cubic_0231));

  RRegularPolygonCubicOnEdge.from(
    RRegularPolygonCubicOnEdge polygon, {
    double timesForEdge = 0,
    Translator<RRegularPolygonCubicOnEdge, double>? cornerRadius,
    Mapper<Map<Offset, CubicOffset>> cubicPointsMapper = _cubicPointsMapper,
    Companion<CubicOffset, Size> cornerAdjust =
        CubicOffset.companionSizeAdjustCenter,
  }) : this(
          polygon.n,
          timesForEdge: timesForEdge,
          cornerRadius: cornerRadius?.call(polygon) ?? 0,
          cubicPointsMapper: cubicPointsMapper,
          cornerAdjust: cornerAdjust,
          radiusCircumscribedCircle: polygon.radiusCircumscribedCircle,
        );

  @override
  Map<Offset, CubicOffset> get cubicPointsForEachCorners =>
      cubicPointsForEachCornersOf(
        timesForEdgeUnitOf(cornerRadius),
        timesForEdge,
      );

  Iterable<CubicOffset> cubicPointsOf(
    double cornerRadius,
    double timesForEdge,
  ) =>
      cubicPointsMapper(cubicPointsForEachCornersOf(
        timesForEdgeUnitOf(cornerRadius),
        timesForEdge,
      )).values;

  Map<Offset, CubicOffset> cubicPointsForEachCornersOf(
    double timesForEdgeUnit,
    double timesForEdge,
  ) =>
      corners.asMap().map((index, current) {
        // offset from current corner to previous corner
        final previous = OffsetExtension.parallelOffsetUnitOf(
          current,
          index == 0 ? corners.last : corners[index - 1],
          timesForEdgeUnit,
        );

        // offset from current corner to next corner
        final next = OffsetExtension.parallelOffsetUnitOf(
          current,
          index == n - 1 ? corners.first : corners[index + 1],
          timesForEdgeUnit,
        );
        return MapEntry(
          current,
          CubicOffset.fromPoints([
            previous,
            next,
            OffsetExtension.parallelOffsetOf(previous, current, timesForEdge),
            OffsetExtension.parallelOffsetOf(current, next, timesForEdge),
          ]),
        );
      });

  double timesForEdgeUnitOf(double cornerRadius) =>
      cornerRadius * math.tan(Radian.angle_180 / n);

  ///
  ///
  /// the "steps" below [stepsOfCornerRadius], [stepsOfEdgeTimes] are some values that can help to create [cornerRadius]
  ///
  ///
  List<double> get stepsOfCornerRadius => [
        double.negativeInfinity,
        0, // no radius (cause a normal regular polygon)
        stepCornerRadiusInscribedCircle,
        stepCornerRadiusFragmentFitCorner(),
        stepCornerRadiusArcCrossCenter(),
        double.infinity,
      ];

  static List<double> get stepsOfEdgeTimes => [
        double.negativeInfinity,
        0,
        1,
        double.infinity,
      ];

  ///
  /// the 'Pa' in below discussion, treats as every corner in [corners], and also,
  /// a = [radianSideSide],
  /// c = [radianCornerCenterSide],
  /// Rc = [radiusCircumscribedCircle],
  /// Ri = [radiusInscribedCircle]
  ///
  /// Pa----------------Pb----------(La)
  ///  --            -------
  ///    --       --    -    --
  ///      --    -      -      -
  ///        -- -      Pc       - (the circle with radius R (PbPc = PcPd = R))
  ///          ---   --        -
  ///            -Pd         --
  ///              ---------
  ///                --
  ///                  (Lb)
  ///

  ///
  /// [stepCornerRadiusInscribedCircle] is the step that
  /// 1. PaPc = Rc
  /// 2. R = Ri
  /// 3. cos(c) = Ri / Rc
  ///
  double get stepCornerRadiusInscribedCircle => radiusInscribedCircle;

  ///
  /// when [inset] = 0 in [stepCornerRadiusFragmentFitCorner], it means that each corner's Pb and Pd are overlap on the nearest two [corners],
  /// which implies: [lengthSide] = PaPb = PaPd = |[timesForEdgeUnit] * borderVectorUnit|
  ///
  ///   [lengthSide] = |[timesForEdgeUnit] * borderVectorUnit| = R * tan(c)
  ///   R = [lengthSide] / tan(c)
  ///
  double stepCornerRadiusFragmentFitCorner([double inset = 0]) =>
      (lengthSide - inset) / math.tan(radianCornerCenterSide);

  ///
  /// when [inset] = 0 in [stepCornerRadiusArcCrossCenter], it means that all [corners]' PbPd arc crossing on the polygon center,
  /// which implies: PaPc = Rc + R
  ///
  ///   cos(c) = R / PaPc = R / (Rc + R)
  ///   Rc * cos(c) = R - R * cos(c)
  ///   R = (Rc * cos(c)) / (1 - cos(c))
  ///
  /// also implies the inequality: Rc + R > (P(0.5) - cornerOffset).distance.
  ///                       (see [PathExtension.cubicToPoint] for detail)
  /// it seems that triangle, square are not satisfy the inequality above,
  /// and P(0.5 - cornerOffset) is too complex to compute. there is two approximate value for triangle and square.
  ///
  double stepCornerRadiusArcCrossCenter([double inset = 0]) => switch (n) {
        3 => radiusCircumscribedCircle * 1.2 - inset,
        4 => radiusCircumscribedCircle * 2.6 - inset,
        _ => ((radiusCircumscribedCircle - inset) *
                math.cos(radianCornerCenterSide)) /
            (1 - math.cos(radianCornerCenterSide)),
      };
}

abstract class RsRegularPolygon extends RRegularPolygon {
  final List<Radius> cornerRadiusList;

  const RsRegularPolygon(
    super.n, {
    required this.cornerRadiusList,
    required super.cornerAdjust,
    required super.cubicPointsMapper,
    required super.radiusCircumscribedCircle,
  }) : super(cornerRadius: 0);
}

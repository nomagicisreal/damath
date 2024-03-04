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
/// [OnLerp], [OnAnimate], [OnAnimatePath], [OnAnimateMatrix4]
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
/// on
///
typedef OnAnimatePath<T> = SizingPath Function(double t, T value);
typedef OnAnimateMatrix4 = Companion<Matrix4, Space3>;

///
///
///
///
///
///
///
/// classes
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
      : mapper = FMapper.doubleOnPeriodSinByTimes(times);

  Curving.cosPeriodOf(int times)
      : mapper = FMapper.doubleOnPeriodCosByTimes(times);

  Curving.tanPeriodOf(int times)
      : mapper = FMapper.doubleOnPeriodTanByTimes(times);

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
/// [invert]
/// [interval], [intervalForward], [intervalReverse]
/// [invertInterval], [invertIntervalForward]. [invertIntervalReverse]
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
      : forward = curve.interval(begin, end),
        reverse = curve.interval(begin, end);

  CurveFR.intervalForwardOf(Curve curve, double begin, double end)
      : forward = curve.interval(begin, end),
        reverse = curve;

  CurveFR.intervalReverseOf(Curve curve, double begin, double end)
      : forward = curve,
        reverse = curve.interval(begin, end);

  ///
  /// flip
  ///
  CurveFR.flip(Curve curve)
      : forward = curve,
        reverse = curve.flipped;

  CurveFR.flipIntervalOf(Curve curve, double begin, double end)
      : forward = curve.interval(begin, end),
        reverse = curve.interval(begin, end, true);

  CurveFR.flipIntervalForwardOf(Curve curve, double begin, double end)
      : forward = curve.interval(begin, end),
        reverse = curve.flipped;

  CurveFR.flipIntervalReverseOf(Curve curve, double begin, double end)
      : forward = curve,
        reverse = curve.interval(begin, end, true);

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
  /// instance getters, methods
  ///

  CurveFR get invert => CurveFR(reverse, forward);

  ///
  /// [interval], [intervalForward], [intervalReverse]
  ///
  CurveFR interval(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        forward.interval(begin, end, flipForward),
        reverse.interval(begin, end, flipForward),
      );

  CurveFR intervalForward(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        forward.interval(begin, end, flipForward),
        reverse.flippedOrThis(flipReverse),
      );

  CurveFR intervalReverse(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        forward.flippedOrThis(flipForward),
        reverse.interval(begin, end, flipReverse),
      );

  ///
  /// [invertInterval], [invertIntervalForward]. [invertIntervalReverse]
  ///
  CurveFR invertInterval(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        reverse.interval(begin, end, flipForward),
        forward.interval(begin, end, flipForward),
      );

  CurveFR invertIntervalForward(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        reverse.interval(begin, end, flipForward),
        forward.flippedOrThis(flipReverse),
      );

  CurveFR invertIntervalReverse(
    double begin,
    double end, [
    bool flipForward = false,
    bool flipReverse = false,
  ]) =>
      CurveFR(
        reverse.flippedOrThis(flipForward),
        forward.interval(begin, end, flipReverse),
      );
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
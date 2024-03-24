///
///
/// this file contains:
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
///
///
part of damath_flutter;

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
            math.sin(RotationUnit.radianFromAngle(
              RotationUnit.angleFromRadian(radianCorner) / 2,
            )),
      };

  /// properties

  final int n;
  final double radiusCircumscribedCircle;

  List<Offset> get corners => cornersOf(n, radiusCircumscribedCircle);

  double get lengthSide => lengthSideOf(n, radiusCircumscribedCircle);

  double get radianSideSide => radianCornerOf(n);

  double get radianCornerSideCenter => Radian.angle_90;

  double get radianCornerCenterSide => Radian.angle_180 / n;

  double get radianSideCornerCenter =>
      Radian.angle_90 - radianCornerCenterSide;

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
  final Applier<Map<Offset, CubicOffset>> cubicPointsMapper;
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
    Mapper<RRegularPolygonCubicOnEdge, double>? cornerRadius,
    Applier<Map<Offset, CubicOffset>> cubicPointsMapper = _cubicPointsMapper,
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

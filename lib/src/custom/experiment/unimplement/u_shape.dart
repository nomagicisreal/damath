part of '../../custom.dart';

///
///
/// this file contains:
///
/// [RegularPolygon]
///   [RegularPolygonRadiusSingle]
///   [RegularPolygonRadius]
///
///
///


///
///
///
/// [radianCornerOf], ... (static methods)
/// [n], ... (getters)
///
///
abstract class RegularPolygon {
  const RegularPolygon();

  ///
  /// [radianCornerOf]
  /// [lengthSideOf]
  /// [radiusInscribedCircleOf]
  ///
  static double radianCornerOf(int n) => (n - 2) * Radian.angle_180 / n;

  static double lengthSideOf(
    int n,
    double radiusCircumscribed, [
    int roundUp = 0,
  ]) =>
      radiusCircumscribed *
      math.sin(Radian.angle_180 / n).roundUpTo(roundUp) *
      2;

  static double radiusInscribedCircleOf(
    int n,
    double radiusCircumscribedCircle,
    double radianCorner,
  ) =>
      switch (n) {
        3 => radiusCircumscribedCircle / 2,
        4 => radiusCircumscribedCircle * DoubleExtension.sqrt1_2,
        6 => radiusCircumscribedCircle * DoubleExtension.sqrt3 / 2,
        _ => radiusCircumscribedCircle *
            math.sin(Radian.fromAngle(
              Radian.angleFromRadian(radianCorner) / 2,
            )),
      };

  ///
  /// [n]
  /// [radiusCircumscribedCircle]
  /// [corners]
  ///
  int get n;

  double get radiusCircumscribedCircle;

  List<Object> get corners;

  ///
  /// [lengthSide]
  ///
  double get lengthSide => lengthSideOf(n, radiusCircumscribedCircle);

  ///
  /// [radianSideSide]
  /// [radianCornerSideCenter]
  /// [radianCornerCenterSide]
  /// [radianSideCornerCenter]
  /// [radiusInscribedCircle]
  ///
  double get radianSideSide => radianCornerOf(n);

  double get radianCornerSideCenter => Radian.angle_90;

  double get radianCornerCenterSide => Radian.angle_180 / n;

  double get radianSideCornerCenter => Radian.angle_90 - radianCornerCenterSide;

  double get radiusInscribedCircle =>
      radiusInscribedCircleOf(n, radiusCircumscribedCircle, radianSideSide);
}

///
///
/// [tangentFrom], ... (static methods)
/// [cornerRadiusSteps], ... (getters)
///
///
mixin RegularPolygonRadiusSingle on RegularPolygon {
  ///
  /// [tangentFrom]
  ///
  static double tangentFrom(double cornerRadius, int n) =>
      cornerRadius * math.tan(Radian.angle_180 / n);

  ///
  /// [cornerRadius]
  /// [cornerRadiusSteps]
  ///
  double get cornerRadius;

  List<double> get cornerRadiusSteps => [
        double.negativeInfinity,
        0, // no radius, normal regular polygon.
        stepCornerRadiusInscribedCircle,
        stepCornerRadiusFragmentFitCorner(),
        stepCornerRadiusArcCrossCenter(),
        double.infinity,
      ];

  ///
  ///
  /// [stepCornerRadiusInscribedCircle]
  /// [stepCornerRadiusFragmentFitCorner]
  /// [stepCornerRadiusArcCrossCenter]
  ///
  ///

  ///
  /// 'Pa' represents every corner from [RegularPolygon] in the discussion below, and
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

///
///
///
///
///
mixin RegularPolygonRadius on RegularPolygon {
  ///
  /// [cornerRadiusList]
  ///
  List<double> get cornerRadiusList;
}

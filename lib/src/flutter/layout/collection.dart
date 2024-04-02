///
///
/// this file contains:
///
///
/// [IterableOffsetExtension]
/// [ListOffsetExtension]
///
///
///
part of damath_flutter;

///
/// static methods:
/// [keep], ...
/// [applyScaling], ...
/// [generatorWithValue], ...
///
/// instance methods:
/// [scaling], ...
/// [adjustCenterFor], ...
///
///
extension IterableOffsetExtension on Iterable<Offset> {
  ///
  /// [keep]
  ///
  static Iterable<Offset> keep(Iterable<Offset> v) => v;

  ///
  /// apply
  ///
  static Applier<Iterable<Offset>> applyScaling(double scale) => scale == 1
      ? keep
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

  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  Iterable<Offset> scaling(double value) => map((o) => o * value);

  Iterable<Offset> adjustCenterFor(Size size, {Offset origin = Offset.zero}) {
    final center = size.center(origin);
    return map((p) => p + center);
  }
}

///
///
///
/// [ListOffsetExtension]
///
///
///

extension ListOffsetExtension on List<Offset> {
  ///
  /// [symmetryInsert]
  ///
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

  ///
  /// [cubicPoints]
  ///
  Map<Offset, CubicOffset> cubicPoints(double timesEdgeUnit, double timesEdge) {
    final n = length;
    return asMap().map((i, current) {
      // offset from current corner to previous corner
      final previous = OffsetExtension.parallelOffsetUnitOf(
        current,
        i == 0 ? last : this[i - 1],
        timesEdgeUnit,
      );

      // offset from current corner to next corner
      final next = OffsetExtension.parallelOffsetUnitOf(
        current,
        i == n - 1 ? first : this[i + 1],
        timesEdgeUnit,
      );
      return MapEntry(
        current,
        CubicOffset.fromPoints([
          previous,
          next,
          OffsetExtension.parallelOffsetOf(previous, current, timesEdge),
          OffsetExtension.parallelOffsetOf(current, next, timesEdge),
        ]),
      );
    });
  }
}

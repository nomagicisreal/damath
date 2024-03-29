///
///
/// this file contains:
///
/// [lerperFrom]
///
/// [CurveExtension]
///
/// [FMapperMaterial]
/// [FTextFormFieldValidator]
/// [FOnAnimateMatrix4]
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
/// [lerperFrom]
///
Lerper<T> lerperFrom<T>(T begin, T end) {
  try {
    return FLerper.from(begin, end);
  } on DamathException catch (e) {
    if (e.message == DamathException.pass) {
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
/// curve
///
///

//
extension CurveExtension on Curve {
  Curve flippedWhen(bool shouldFlip) => shouldFlip ? flipped : this;

  Interval interval(double begin, double end, [bool shouldFlip = false]) =>
      Interval(begin, end, curve: flippedWhen(shouldFlip));
}

///
/// [keepOffset], ...
///
extension FMapperMaterial on Applier {
  ///
  /// keep
  ///
  static Offset keepOffset(Offset v) => v;

  static Iterable<Offset> keepOffsetIterable(Iterable<Offset> v) => v;

  static Size keepSize(Size v) => v;

  static Curve keepCurve(Curve v) => v;

  static Curve keepCurveFlipped(Curve v) => v.flipped;

  static BoxConstraints keepBoxConstraints(BoxConstraints v) => v;

  ///
  /// box constraint
  ///
  static BoxConstraints boxConstraintsLoosen(BoxConstraints constraints) =>
      constraints.loosen();

  ///
  /// cubic
  ///
  static Cubic cubic_0231(Cubic cubic) =>
      Cubic(cubic.a, cubic.c, cubic.d, cubic.b);

  static Cubic cubic_1230(Cubic cubic) =>
      Cubic(cubic.b, cubic.c, cubic.d, cubic.a);
}

///
///
///
extension FTextFormFieldValidator on TextFormFieldValidator {
  static FormFieldValidator<String> validateNullOrEmpty(
    String validationFailedMessage,
  ) =>
      (value) =>
          value == null || value.isEmpty ? validationFailedMessage : null;
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
      translate(v64.Vector3(space3.x, space3.y, space3.dz));

  void rotateOf(Point3 space3) => this
    ..rotateX(space3.x)
    ..rotateY(space3.y)
    ..rotateZ(space3.dz);

  Matrix4 scaledOf(Point3 space3) => scaled(space3.x, space3.y, space3.dz);

  ///
  /// [rotateOn]
  ///
  void rotateOn(Point3 space3, double radian) =>
      rotate(v64.Vector3(space3.x, space3.y, space3.dz), radian);

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

// with mapper
  static OnAnimateMatrix4 mapTranslating(Applier<Point3> mapper) =>
      (matrix4, value) => matrix4
        ..identityPerspective
        ..translateOf(mapper(value));

  static OnAnimateMatrix4 mapRotating(Applier<Point3> mapper) =>
      (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(mapper(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Applier<Point3> mapper) =>
      (matrix4, value) => matrix4.scaledOf(mapper(value));

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

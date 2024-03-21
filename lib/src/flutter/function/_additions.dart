///
///
/// this file contains:
///
/// for usecase:
/// [FMapperMaterial]
/// [FTextFormFieldValidator]
///
///
/// for animation:
/// [FOnLerp]
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
/// [keepOffset], ...
///
extension FMapperMaterial on Mapper {
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

extension FTextFormFieldValidator on TextFormFieldValidator {
  static FormFieldValidator<String> validateNullOrEmpty(
      String validationFailedMessage,
      ) =>
          (value) =>
      value == null || value.isEmpty ? validationFailedMessage : null;
}


///
///
///
///
/// for animation
///
///
///
///

///
///
/// [of]
/// [from]
///
///
extension FOnLerp<T> on Lerper<T> {
  static Lerper<T> of<T>(T value) => (_) => value;

  ///
  ///
  /// See Also
  ///   * [Decoration]
  ///   * [FSizingPath.shapeBorder]
  ///   ...
  ///
  ///
  static Lerper<T> from<T>(T a, T b) => switch (a) {
    Size _ => (t) => Size.lerp(a, b as Size, t)!,
    Rect _ => (t) => Rect.lerp(a, b as Rect, t)!,
    Color _ => (t) => Color.lerp(a, b as Color, t)!,
    Vector3D _ => (t) => Vector3D.lerp(a, b as Vector3D, t),
    EdgeInsets _ => (t) => EdgeInsets.lerp(a, b as EdgeInsets?, t)!,
    RelativeRect _ => (t) => RelativeRect.lerp(a, b as RelativeRect?, t)!,
    AlignmentGeometry _ => (t) =>
    AlignmentGeometry.lerp(a, b as AlignmentGeometry?, t)!,
    SizingPath _ => throw ArgumentError(
      'Use BetweenPath instead of Between<SizingPath>',
    ),
    Decoration _ => switch (a) {
      BoxDecoration _ => b is BoxDecoration && a.shape == b.shape
          ? (t) => BoxDecoration.lerp(a, b, t)!
          : throw UnimplementedError(
          'BoxShape should not be interpolated'),
      ShapeDecoration _ => switch (b) {
        ShapeDecoration _ => a.shape == b.shape
            ? (t) => ShapeDecoration.lerp(a, b, t)!
            : switch (a.shape) {
          CircleBorder _ || RoundedRectangleBorder _ => switch (
          b.shape) {
            CircleBorder _ || RoundedRectangleBorder _ => (t) =>
            Decoration.lerp(a, b, t)!,
            _ => throw UnimplementedError(
              "'$a shouldn't be interpolated to $b'",
            ),
          },
          _ => throw UnimplementedError(
            "'$a shouldn't be interpolated to $b'",
          ),
        },
        _ => throw UnimplementedError(),
      },
      _ => throw UnimplementedError(),
    },
    ShapeBorder _ => switch (a) {
      BoxBorder _ => switch (b) {
        BoxBorder _ => (t) => BoxBorder.lerp(a, b, t)!,
        _ => throw UnimplementedError(),
      },
      InputBorder _ => switch (b) {
        InputBorder _ => (t) => ShapeBorder.lerp(a, b, t)!,
        _ => throw UnimplementedError(),
      },
      OutlinedBorder _ => switch (b) {
        OutlinedBorder _ => (t) => OutlinedBorder.lerp(a, b, t)!,
        _ => throw UnimplementedError(),
      },
      _ => throw UnimplementedError(),
    },
    _ => Tween<T>(begin: a, end: b).transform,
  } as Lerper<T>;
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
  void translateOf(Space3 space3) =>
      translate(Vector3(space3.dx, space3.dy, space3.dz));

  void rotateOf(Space3 space3) => this
    ..rotateX(space3.dx)
    ..rotateY(space3.dy)
    ..rotateZ(space3.dz);

  Matrix4 scaledOf(Space3 space3) => scaled(space3.dx, space3.dy, space3.dz);

  ///
  /// [rotateOn]
  ///
  void rotateOn(Space3 space3, double radian) =>
      rotate(Vector3(space3.dx, space3.dy, space3.dz), radian);

  ///
  ///
  /// statics
  ///
  ///
  static Matrix4 translating(Matrix4 matrix4, Space3 value) =>
      matrix4.identityPerspective..translateOf(value);

  static Matrix4 rotating(Matrix4 matrix4, Space3 value) => matrix4
    ..setRotation((Matrix4.identity()..rotateOf(value)).getRotation());

  static Matrix4 scaling(Matrix4 matrix4, Space3 value) =>
      matrix4.scaledOf(value);

// with mapper
  static OnAnimateMatrix4 mapTranslating(Mapper<Space3> mapper) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateOf(mapper(value));

  static OnAnimateMatrix4 mapRotating(Mapper<Space3> mapper) =>
          (matrix4, value) => matrix4
        ..setRotation(
            (Matrix4.identity()..rotateOf(mapper(value))).getRotation());

  static OnAnimateMatrix4 mapScaling(Mapper<Space3> mapper) =>
          (matrix4, value) => matrix4.scaledOf(mapper(value));

  // with fixed value
  static OnAnimateMatrix4 fixedTranslating(Space3 fixed) =>
          (matrix4, value) => matrix4
        ..identityPerspective
        ..translateOf(value + fixed);

  static OnAnimateMatrix4 fixedRotating(Space3 fixed) => (matrix4, value) =>
  matrix4
    ..setRotation(
        (Matrix4.identity()..rotateOf(fixed + value)).getRotation());

  static OnAnimateMatrix4 fixedScaling(Space3 fixed) =>
          (matrix4, value) => matrix4.scaledOf(value + fixed);
}

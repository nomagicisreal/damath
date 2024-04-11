///
///
/// this file contains:
///
/// [_VectorFloat]
///   |
///   |#[_MixinVectorFloat2]
///   |-[VectorFloat2]
///   |   |-[_VectorFloat2Float32]
///   |   |-[_VectorFloat2Float64]
///   |
///   |#[_MixinVectorFloat3]
///   |-[VectorFloat3]
///   |   |-[_VectorFloat3Float32]
///   |   |-[_VectorFloat3Float64]
///   |
///   |#[_MixinVectorFloat4]
///   |-[VectorFloat4]
///       |-[_VectorFloat4Float32]
///       |-[_VectorFloat4Float64]
///
///
///
part of damath_typed_data;

///
///
/// see also: (package:VectorFloat_math/VectorFloat_math.dart, package:VectorFloat_math/VectorFloat_math_64.dart)
///   [v32.Vector2], [v64.Vector2], ...
///   [v32.Vector3], [v64.Vector3], ...
///   [v32.Vector4], [v64.Vector4], ...
///   ...
///
/// some implementations are similar to:
///   - [IteratorExtension], [IterableExtension], [ListExtension], ...
///   - [IteratorDouble], [IterableDouble], [ListDouble], ...
///   - [RecordDouble2], [RecordDouble3] ...
///
///
///
/// some fact:
/// 1.
///   Create [Record] instance is lightly efficient than creating [List] or [MapEntry] instance,
///   but assign values in the same instance for list or entry is lightly efficient than create many [Record]
/// 2.
///   ```
///   final list32 = Float32List(2);
///   final list64 = Float64List(2);
///   list32[0] + list64[0]; // there is no error
///   ```
///
///

///
/// [_storage], ...(getters)
///
abstract class _VectorFloat<V extends _VectorFloat<V>>
    implements
        IOperatableDirectable<V, V>,
        IOperatableModuleable<V, V>,
        IOperatableScalable<V, V> {
  ///
  /// overrides
  ///
  @override
  V operator -() => clone.._storage.apply(DoubleExtension.applyNegate);

  @override
  V operator %(covariant V another) =>
      _applied(another._storage, FReducer.doubleModule);

  @override
  V operator *(covariant V another) =>
      _applied(another._storage, FReducer.doubleMultiply);

  @override
  V operator +(covariant V another) =>
      _applied(another._storage, FReducer.doubleAdd);

  @override
  V operator -(covariant V another) =>
      _applied(another._storage, FReducer.doubleSubtract);

  @override
  V operator /(covariant V another) =>
      _applied(another._storage, FReducer.doubleDivide);

  ///
  /// getters
  ///
  List<double> get _storage;

  V get clone;

  ///
  /// methods
  ///

  V _applied(List<double> another, Reducer<double> reducing) {
    final clone = this.clone;
    final storage = clone._storage;
    for (var i = 0; i < storage.length; i++) {
      _storage[i] = reducing(_storage[i], another[i]);
    }
    return clone;
  }

  ///
  /// constructor
  ///
  const _VectorFloat();
}

///
///
///
///
///
/// VectorFloat2
///
///
///
///
///
///

///
/// [toStringAsFixed], ...(functions)
///
mixin _MixinVectorFloat2<V extends _VectorFloat<V>> on _VectorFloat<V> {
  ///
  /// setters, getters
  ///
  set x(double value) => _storage[0] = value;

  set y(double value) => _storage[1] = value;

  double get x => _storage[0];

  double get y => _storage[1];

  ///
  /// methods
  ///
  void _setValues([double x_ = 0, double y_ = 0]) {
    _storage[0] = x_;
    _storage[1] = y_;
  }

  ///
  /// functions
  ///

  ///
  /// [toStringAsFixed]
  ///
  String toStringAsFixed(int digit) =>
      '(${x.toStringAsFixed(digit)}, ${y.toStringAsFixed(digit)})';

  ///
  /// [directionAzimuthal], [directionTo]
  /// [rotate]
  ///
  double get directionAzimuthal => math.atan2(y, x); // atan(dy, dx)

  double directionTo(VectorFloat2 p) =>
      p.directionAzimuthal - directionAzimuthal;

  ///
  /// When the rotation begin,
  ///   the vector parallel to x axis projects on both x axis and y axis.      ( cos, sin)
  ///   the vector parallel to y axis projects on both x axis and y axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos, -sin ] [ x ]
  ///     [ sin,  cos ] [ y ]
  ///   dx' = [x] * cos(radian) - [y] * sin(radian);
  ///   dy' = [x] * sin(radian) + [y] * cos(radian);
  ///
  void rotate(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    x = x * c - y * s;
    y = x * s + y * c;
  }

  ///
  /// the code belows shows that the execution time of '[rotate] by matrix' is less than 'rotate by [direction]'
  /// ```
  /// double angleOf(MapEntry<double, double> entry) =>
  ///     Radian.angleOf(atan2(entry.value, entry.key)).roundToDouble();
  ///
  /// double rotateByDirection(MapEntry<double, double> p) {
  ///   MapEntry<double, double> from(double direction) =>
  ///       MapEntry(cos(direction), sin(direction));
  ///
  ///   for (var i = 0; i < 1e8; i++) {
  ///     p = from(atan2(p.value, p.key) + Radian.angle_10);
  ///   }
  ///   return angleOf(p);
  /// }
  ///
  /// double rotateByMatrix(MapEntry<double, double> p) {
  ///   MapEntry<double, double> from(double dx, double dy, double rotation) {
  ///     final c = cos(rotation);
  ///     final s = sin(rotation);
  ///     return MapEntry(dx * c - dy * s, dx * s + dy * c);
  ///   }
  ///
  ///   for (var i = 0; i < 1e8; i++) {
  ///     p = from(p.key, p.value, Radian.angle_10);
  ///   }
  ///   return angleOf(p);
  /// }
  ///
  /// final watch = Stopwatch();
  /// final entry = MapEntry(sqrt(3), sqrt(4));
  ///
  /// watch.start();
  /// print('by matrix: ${rotateByMatrix(entry)}------${watch.elapsed}'); // -31.0------0:00:00.763498
  /// watch.reset();
  /// watch.start();
  /// print('by direct: ${rotateByDirection(entry)}------${watch.elapsed}'); // -31.0------0:00:04.573989
  /// watch.reset();
  /// ```
}

///
///
/// [VectorFloat2.zero32], ...(factories)
///
///
abstract class VectorFloat2 extends _VectorFloat<VectorFloat2>
    with _MixinVectorFloat2<VectorFloat2> {
  ///
  /// constructor
  ///
  const VectorFloat2();

  ///
  /// factories
  ///
  factory VectorFloat2.zero32() = _VectorFloat2Float32.zero;

  factory VectorFloat2.zero64() = _VectorFloat2Float64.zero;

  ///
  /// static methods
  ///
  static VectorFloat2 maxDirection(VectorFloat2 a, VectorFloat2 b) =>
      a.directionAzimuthal > b.directionAzimuthal ? a : b;

  static VectorFloat2 minDirection(VectorFloat2 a, VectorFloat2 b) =>
      a.directionAzimuthal < b.directionAzimuthal ? a : b;
}

//
class _VectorFloat2Float32 extends VectorFloat2 {
  @override
  final Float32List _storage;

  _VectorFloat2Float32.zero() : _storage = Float32List(2);

  @override
  VectorFloat2 get clone =>
      _VectorFloat2Float32.zero().._setValues(_storage[0], _storage[1]);
}

//
class _VectorFloat2Float64 extends VectorFloat2 {
  @override
  final Float64List _storage;

  _VectorFloat2Float64.zero() : _storage = Float64List(2);

  @override
  VectorFloat2 get clone =>
      _VectorFloat2Float64.zero().._setValues(_storage[0], _storage[1]);
}

///
///
///
///
///
/// VectorFloat3
///
///
///
///
///
///

//
mixin _MixinVectorFloat3<V extends _VectorFloat<V>> on _MixinVectorFloat2<V> {
  ///
  /// overrides
  ///
  @override
  void _setValues([double x_ = 0, double y_ = 0, double z_ = 0]) {
    super._setValues(x_, y_);
    _storage[2] = z_;
  }

  ///
  /// setter, getter
  ///
  set z(double value) => _storage[2] = value;

  double get z => _storage[2];
}

///
///
///
abstract class VectorFloat3 extends _VectorFloat<VectorFloat3>
    with _MixinVectorFloat2<VectorFloat3>, _MixinVectorFloat3<VectorFloat3> {
  ///
  /// functions
  ///

  ///
  /// [toStringAsFixed]
  ///
  @override
  String toStringAsFixed(int digit) => '(${x.toStringAsFixed(digit)}, '
      '${y.toStringAsFixed(digit)}, ${z.toStringAsFixed(digit)})';

  ///
  /// [distance]
  ///
  double get distance => math.sqrt(x * x + y * y + z * z);

  ///
  /// spherical coordinates:
  ///   r^2 = x^2 + 𝑦^2 + 𝑧^2
  ///   θ = atan(dy/dx)
  ///   φ = acos(dz/ r)
  ///

  ///
  /// [directionAzimuthal], [directionPolar]
  ///
  @override
  double get directionAzimuthal => math.atan2(y, x);

  double get directionPolar => math.acos(z / distance);

  ///
  /// the [rotate] is implementation of Cartesian coordinate system rotation in the way of Spherical coordinate system.
  ///
  @override
  void rotate(double azimuthal, [double polar = 0]) {
    final distance = this.distance;
    final rA = math.atan2(y, x) + azimuthal;
    final rP = math.acos(z / distance) + polar;
    final distanceXY = distance * math.sin(rP);
    x = distanceXY * math.cos(rA);
    y = distanceXY * math.sin(rA);
    z = distance * math.cos(rP);
  }

  ///
  /// the discussion block belows is not the comment to describe how [rotate] function works.
  /// it's just the record of my intention that i want to improve the performance of [rotate] function.
  /// ----------------------------------------------------------------
  ///
  /// let ([x], [y], [z]) represent the record before [rotate] finished.
  /// let ([Point3.x], [Point3.y], [Point3.dz]) represent the result of [rotate].
  /// let rP, rA represent the origin state of polar and azimuthal.
  /// let rP', rA' represent the [radian] rotation of polar and azimuthal.
  /// which means "rP + rP'", "rA + rA'" are the rotated rotation of polar and azimuthal.
  ///
  /// when rA' grows,
  ///     [ cos(rA'), -sin(rA') ] [ x ]
  ///     [ sin(rA'),  cos(rA') ] [ y ]
  ///
  /// when rP' grows from 0 ~ π,
  ///   the vector can be separate into the general that parallel to z axis, and the general that parallel to xy plane.
  ///   the general that parallel to z axis directly effect the result [Point3.dz] without consideration of rA'.
  ///   [Point3.dz] = cos(rP + rP')
  ///
  ///   the general that parallel to xy plane projects a positive distance on xy plane, sin(rP + rP'),
  ///   which is also [Point3.x] * sec(rA + rA'), [Point3.y] * csc(rA + rA').
  ///   [Point3.x] = sin(rP + rP') / sec(rA + rA')
  ///   [Point3.x] = sin(rP + rP') / csc(rA + rA')
  ///
  /// ----------------------------------------------------------------
  ///

  ///
  /// the rotation of [rotateX], [rotateY], [rotateZ] follows:
  ///   z axis is [Direction3DIn6.top] -> [Direction3DIn6.bottom], radian start from [Direction3DIn6.right]
  ///   y axis is [Direction3DIn6.right] -> [Direction3DIn6.left], radian start from [Direction3DIn6.front]
  ///   x axis is [Direction3DIn6.back] -> [Direction3DIn6.front], radian start from [Direction3DIn6.top], thus,
  ///
  /// When rotate on x axis,
  ///   the vector parallel to y axis will project on both y axis and z axis.      ( cos, sin)
  ///   the vector parallel to z axis will project on both y axis and z axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [  1,   0,   0 ]  [ x ]
  ///     [  0, cos,-sin ]  [ y ]
  ///     [  0, sin, cos ]  [ z ]
  /// When rotate on y axis,
  ///   the vector parallel to x axis will project on both x axis and z axis.      ( cos,-sin)
  ///   the vector parallel to z axis will project on both x axis and z axis, too. ( sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,  0, sin ]  [ x ]
  ///     [  0,   1,   0 ]  [ y ]
  ///     [-sin,  0, cos ]  [ z ]
  /// When rotate on z axis,
  ///   the vector parallel to x axis will project on both x axis and y axis.      ( cos, sin)
  ///   the vector parallel to y axis will project on both x axis and y axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,-sin,  0 ]  [ x ]
  ///     [ sin, cos,  0 ]  [ y ]
  ///     [  0,    0,  1 ]  [ z ]
  /// because the priority of rotations on x axis, y axis, z axis influence each other,
  /// it better not to rotate by them all together at [Point3.rotate].
  ///   [rotateX] do the rotation only for x axis:
  ///     [x]' = [x]
  ///     [y]' = [y] * cos(rx) - [z] * sin(rx)
  ///     [z]' = [y] * sin(rx) + [z] * cos(rx)
  ///   [rotateY] do the rotation only for y axis:
  ///     [x]' = [x] * cos(ry) + [z] * sin(ry)
  ///     [y]' = [y]
  ///     [z]' = [z] * cos(ry) - [x] * sin(ry)
  ///   [rotateZ] do the rotation only for z axis:
  ///     [x]' = [x] * cos(rz) - [y] * sin(rz)
  ///     [y]' = [x] * sin(rz) + [y] * cos(rz)
  ///     [z]' = [z]
  ///
  ///
  void rotateX(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    y = y * c - z * s;
    z = y * s + z * c;
  }

  void rotateY(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    x = x * c + z * s;
    z = z * c * c - x * s;
  }

  void rotateZ(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    x = x * c + y * s;
    x = x * s + y * c;
  }

  ///
  /// constructor
  ///
  const VectorFloat3();

  ///
  /// factories
  ///
  factory VectorFloat3.zero32() = _VectorFloat3Float32.zero;

  factory VectorFloat3.zero64() = _VectorFloat3Float64.zero;
}

//
class _VectorFloat3Float32 extends VectorFloat3 {
  @override
  final Float64List _storage;

  _VectorFloat3Float32.zero() : _storage = Float64List(3);

  @override
  VectorFloat3 get clone => _VectorFloat3Float32.zero()
    .._setValues(_storage[0], _storage[1], _storage[2]);
}

//
class _VectorFloat3Float64 extends VectorFloat3 {
  @override
  final Float64List _storage;

  _VectorFloat3Float64.zero() : _storage = Float64List(3);

  @override
  VectorFloat3 get clone => _VectorFloat3Float64.zero()
    .._setValues(_storage[0], _storage[1], _storage[2]);
}

///
///
///
///
///
/// VectorFloat4
///
///
///
///
///
///

//
mixin _MixinVectorFloat4<V extends _VectorFloat<V>>
    on _MixinVectorFloat2<V>, _MixinVectorFloat3<V> {
  ///
  /// overrides
  ///
  @override
  void _setValues([
    double x_ = 0,
    double y_ = 0,
    double z_ = 0,
    double w_ = 0,
  ]) {
    super._setValues(x_, y_);
    _storage[3] = w_;
  }

  ///
  /// setter, getter
  ///
  set w(double value) => _storage[3] = value;

  double get w => _storage[3];
}

///
///
///
abstract class VectorFloat4 extends _VectorFloat<VectorFloat4>
    with
        _MixinVectorFloat2<VectorFloat4>,
        _MixinVectorFloat3<VectorFloat4>,
        _MixinVectorFloat4<VectorFloat4> {
  ///
  /// constructor
  ///
  const VectorFloat4();

  ///
  /// factories
  ///
  factory VectorFloat4.zero32() = _VectorFloat4Float32.zero;

  factory VectorFloat4.zero64() = _VectorFloat4Float64.zero;

  ///
  /// getters
  ///
  // ...

  ///
  /// function
  ///
  void setIdentity() {
    _storage[0] = 0;
    _storage[1] = 0;
    _storage[2] = 0;
    _storage[3] = 1;
  }
}

//
class _VectorFloat4Float32 extends VectorFloat4 {
  @override
  final Float32List _storage;

  _VectorFloat4Float32.zero() : _storage = Float32List(3);

  @override
  VectorFloat4 get clone => _VectorFloat4Float32.zero()
    .._setValues(_storage[0], _storage[1], _storage[2], _storage[3]);
}

class _VectorFloat4Float64 extends VectorFloat4 {
  @override
  final Float64List _storage;

  _VectorFloat4Float64.zero() : _storage = Float64List(3);

  @override
  VectorFloat4 get clone => _VectorFloat4Float64.zero()
    .._setValues(_storage[0], _storage[1], _storage[2], _storage[3]);
}

// implements Float32x4List, Float64x4List, Int64x4List ... ?

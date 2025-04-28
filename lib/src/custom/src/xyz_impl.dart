part of '../custom.dart';

///
///
/// My IDE has problem formating lines for 'mixin on multiple class',
/// so i have reduced some class name to prevent from error after formating
///
/// [_Mxy], [_Mxyz]
///   --[_MxyOperatable], [_MxyzO]
///   |   --[Point2], [Point3]
///   |
///   --[_MxyTransformable], [_MxyzT]
///       --[Vector2], [Vector3]
///
///

///
///
///
mixin _Mxy {
  double get x;

  double get y;

  @override
  String toString() => (x, y).toStringAsFixed(1);

  @override
  int get hashCode => Object.hash(x.hashCode, y.hashCode);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

///
///
///
mixin _Mxyz implements _Mxy {
  double get z;

  @override
  String toString() => (x, y, z).toStringAsFixed(1);

  @override
  int get hashCode => Object.hash(x.hashCode, y.hashCode, z.hashCode);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

///
///
///
mixin _MxyOperatable on _Mxy
    implements
        Comparable<_MxyOperatable>,
        IOperatableDirectable<_MxyOperatable, _MxyOperatable>,
        IOperatableScalable<_MxyOperatable, _MxyOperatable>,
        IOperatableStepable<_MxyOperatable, _MxyOperatable> {
  _MxyOperatable _instance(double x, double y);

  @override
  _MxyOperatable operator -() => _instance(-x, -y);

  @override
  _MxyOperatable operator +(covariant _MxyOperatable other) => _instance(x + other.x, y + other.y);

  @override
  _MxyOperatable operator -(covariant _MxyOperatable other) => _instance(x - other.x, y - other.y);

  @override
  _MxyOperatable operator *(covariant _MxyOperatable other) => _instance(x * other.x, y * other.y);

  @override
  _MxyOperatable operator /(covariant _MxyOperatable other) => _instance(x / other.x, y / other.y);

  @override
  _MxyOperatable operator %(covariant _MxyOperatable other) => _instance(x % other.x, y % other.y);

  @override
  _MxyOperatable operator ~/(covariant _MxyOperatable other) =>
      _instance((x ~/ other.x).toDouble(), (y ~/ other.y).toDouble());
}

mixin _MxyzO on _Mxyz, Point2 {
  @override
  _MxyzO _instance(double x, double y, [double z = double.nan]);

  @override
  _MxyzO operator -() => _instance(-x, -y, -z);

  @override
  _MxyzO operator +(covariant _MxyzO other) =>
      _instance(x + other.x, y + other.y, z + other.z);

  @override
  _MxyzO operator -(covariant _MxyzO other) =>
      _instance(x - other.x, y - other.y, z - other.z);

  @override
  _MxyzO operator *(covariant _MxyzO other) =>
      _instance(x * other.x, y * other.y, z - other.z);

  @override
  _MxyzO operator /(covariant _MxyzO other) =>
      _instance(x / other.x, y / other.y, z / other.z);

  @override
  _MxyzO operator %(covariant _MxyzO other) =>
      _instance(x % other.x, y % other.y, z % other.z);

  @override
  _MxyzO operator ~/(covariant _MxyzO other) => _instance(
    (x ~/ other.x).toDouble(),
    (y ~/ other.y).toDouble(),
    (z ~/ other.z).toDouble(),
  );
}

///
///
///
mixin _MxyTransformable on _Mxy
    implements
        IOperatableDirectable<_MxyTransformable, void>,
        IOperatableScalable<_MxyTransformable, void>,
        IOperatableStepable<_MxyTransformable, void> {
  set x(double value);

  set y(double value);

  @override
  void operator -() {
    x = -x;
    y = -y;
  }

  @override
  void operator +(covariant _MxyTransformable another) {
    x += another.x;
    y += another.y;
  }

  @override
  void operator -(covariant _MxyTransformable another) {
    x -= another.x;
    y -= another.y;
  }

  @override
  void operator *(covariant _MxyTransformable another) {
    x *= another.x;
    y *= another.y;
  }

  @override
  void operator /(covariant _MxyTransformable another) {
    x /= another.x;
    y /= another.y;
  }

  @override
  void operator %(covariant _MxyTransformable another) {
    x %= another.x;
    y %= another.y;
  }

  @override
  void operator ~/(covariant _MxyTransformable another) {
    x = (x ~/ another.x).toDouble();
    y = (y ~/ another.y).toDouble();
  }

  _MxyTransformable get clone;
}

mixin _MxyzT on _Mxyz, _MxyTransformable {
  set z(double value);

  @override
  void operator -() {
    x = -x;
    y = -y;
    z = -z;
  }

  @override
  void operator +(covariant _MxyzT another) {
    x += another.x;
    y += another.y;
    z += another.z;
  }

  @override
  void operator -(covariant _MxyzT another) {
    x -= another.x;
    y -= another.y;
    z -= another.z;
  }

  @override
  void operator *(covariant _MxyzT another) {
    x *= another.x;
    y *= another.y;
    z *= another.z;
  }

  @override
  void operator /(covariant _MxyzT another) {
    x /= another.x;
    y /= another.y;
    z /= another.z;
  }

  @override
  void operator %(covariant _MxyzT another) {
    x %= another.x;
    y %= another.y;
    z %= another.z;
  }

  @override
  void operator ~/(covariant _MxyzT another) {
    x = (x ~/ another.x).toDouble();
    y = (y ~/ another.y).toDouble();
    z = (z ~/ another.z).toDouble();
  }

  ///
  /// Every vector on a 2D plane, V, can be composed by two vector:
  ///   Vx: a vector parallel to x axis, or [x]
  ///   Vy: a vector parallel to y axis, or [y]
  /// Every θ rotation on V can be composed by the θ rotation on Vx and θ rotation on Vy.
  ///   With θ rotation, Vx projects on both x axis and y axis.      (  cosθ * |Vx|, sinθ * |Vx| )
  ///   With θ rotation, Vy projects on both x axis and y axis, too. ( -sinθ * |Vy|, cosθ * |Vy| )
  /// Or be as matrix multiplication:
  ///     [ cosθ, -sinθ ] [ x ]
  ///     [ sinθ,  cosθ ] [ y ]
  /// Therefore, the result, x' and y', is computable:
  /// x' = [x] * cos([radian]) - [y] * sin([radian]);
  /// y' = [x] * sin([radian]) + [y] * cos([radian]);
  ///
  void operator ^(double azimuthal) {
    final cos = math.cos(azimuthal);
    final sin = math.sin(azimuthal);
    x = x * cos - y * sin;
    y = x * sin + y * cos;
  }

  ///
  /// In the way of Spherical coordinate system.
  ///
  /// let ([x], [y], [z]) be the vector before [rotate].
  /// let ( x',  y',  z') be the vector after [rotate].
  /// let θP, θA be the rotation of polar radian (0 ~ π) and azimuthal radian (0 ~ 2π).
  ///   With θA rotation, [x] projects on both x axis and y axis.      (  cosθA * [x],  sinθA * [x],            0 )
  ///   With θA rotation, [y] projects on both x axis and y axis.      ( -sinθA * [y],  cosθA * [y],            0 )
  ///   With θP rotation, [x] projects on both x axis and z axis.      (  cosθP * [x],            0, -sinθP * [x] )
  ///   With θP rotation, [y] projects on both y axis and z axis.      (            0,  cosθP * [y], -sinθP * [y] )
  ///   With θP rotation, [z] projects on both xy plane and z axis.    (           Zx,           Zy,  cosθP * [z] )
  /// We know that |Zx + Zy| = |sinθP * [z]|, and (Zx, Zy) is a vector rotated θA on x-y plane.
  ///   Zx = cosθA * sinθP * [z]
  ///   Zy = sinθA * sinθP * [z]
  ///   [  cosθA + cosθP,         -sinθA,  cosθA * sinθP ]  [ x ]
  ///   [          sinθA,  cosθA + cosθP,  sinθA * sinθP ]  [ y ]
  ///   [         -sinθP,         -sinθP,          cosθP ]  [ z ]
  ///
  void rotate(double azimuthal, double polar) {
    assert(polar.isRangeClose(0, DoubleExtension.radian_angle180));
    if (polar == 0) this ^ azimuthal;

    final cosA = math.cos(azimuthal);
    final sinA = math.sin(azimuthal);
    final cosP = math.cos(polar);
    final sinP = math.sin(polar);
    x = x * (cosA + cosP) - y * sinA + z * cosA * sinP;
    y = x * sinA + y * (cosA + cosP) + z * sinA * sinP;
    z = x * -sinP + y * -sinP + z * cosP;
  }

  ///
  /// When there is a rotation θ on x axis,
  ///   [y] projects on both y axis and z axis.      (  cosθ * [y],  sinθ * [y] )
  ///   [z] projects on both y axis and z axis, too. ( -sinθ * [z],  cosθ * [z] )
  ///   [   1,    0,    0 ]  [ x ]
  ///   [   0,  cos, -sin ]  [ y ]
  ///   [   0,  sin,  cos ]  [ z ]
  /// When there is a rotation θ on y axis,
  ///   [x] projects on both x axis and z axis.      (  cosθ * [x], -sinθ * [x] )
  ///   [z] projects on both x axis and z axis, too. (  sinθ * [z],  cosθ * [z] )
  ///   [  cos,   0,  sin ]  [ x ]
  ///   [    0,   1,    0 ]  [ y ]
  ///   [ -sin,   0,  cos ]  [ z ]
  /// When there is a rotation θ on z axis,
  ///   [x] projects on both x axis and y axis.      (  cosθ * [x],  sinθ * [x] )
  ///   [y] projects on both x axis and y axis, too. ( -sinθ * [y],  cosθ * [y] )
  ///   [  cos, -sin,   0 ]  [ x ]
  ///   [  sin,  cos,   0 ]  [ y ]
  ///   [    0,    0,   1 ]  [ z ]
  /// Notice that using [rotateX], [rotateY], [rotateZ] together may cause unexpected rotation on one of x, y, z axis.
  ///
  void rotateX(double radian) {
    final cos = math.cos(radian);
    final sin = math.sin(radian);
    y = y * cos + z * -sin;
    z = y * sin + z * cos;
  }

  void rotateY(double radian) {
    final cos = math.cos(radian);
    final sin = math.sin(radian);
    x = x * cos + z * sin;
    z = x * -sin + z * cos;
  }

  void rotateZ(double radian) {
    final cos = math.cos(radian);
    final sin = math.sin(radian);
    x = x * cos + y * -sin;
    y = x * sin + y * cos;
  }
}

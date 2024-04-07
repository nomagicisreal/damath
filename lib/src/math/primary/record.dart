///
///
/// this file contains:
///
/// [RecordDouble2]
/// [RecordDouble3]
///
///
///
///
///
///
part of damath_math;

///
///
/// [direction], ...
/// [toStringAsFixed], ...
///
///
extension RecordDouble2 on (double, double) {
  ///
  /// [direction], [directionTo]
  /// [rotate]
  ///

  double get direction => math.atan2($2, $1); // atan(dy, dx)

  double directionTo((double, double) p) => p.direction - direction;

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
  (double, double) rotate(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c - $2 * s, $1 * s + $2 * c);
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

  ///
  /// [toStringAsFixed]
  /// [iterator]
  ///
  String toStringAsFixed(int digit) =>
      '(${$1.toStringAsFixed(digit)}, ${$2.toStringAsFixed(digit)})';

  Iterator<double> get iterator => [$1, $2].iterator;
}

///
///
/// [direction], ...
/// [toStringAsFixed], ...
///
///
extension RecordDouble3 on (double, double, double) {
  ///
  /// [direction]
  /// [rotate]
  ///

  ///
  /// spherical coordinates:
  ///   r^2 = x^2 + 𝑦^2 + 𝑧^2
  ///   θ = atan(dy/dx)
  ///   φ = acos(dz/ r)
  /// that is, [direction] = (θ, φ)
  ///
  (double, double) get direction =>
      (math.atan2($2, $1), math.acos($3 / iterator.distance));

  ///
  /// the [rotate] is implementation of Cartesian coordinate system rotation in the way of Spherical coordinate system.
  ///
  (double, double, double) rotate(double azimuthal, double polar) {
    final distance = iterator.distance;
    final rA = math.atan2($2, $1) + azimuthal;
    final rP = math.acos($3 / distance) + polar;

    final distanceXY = distance * math.sin(rP);
    return (
      distanceXY * math.cos(rA),
      distanceXY * math.sin(rA),
      distance * math.cos(rP),
    );
  }

  ///
  /// the discussion block belows is not the comment to describe how [rotate] function works.
  /// it's just the record of my intention that i want to improve the performance of [rotate] function.
  /// ----------------------------------------------------------------
  ///
  /// let ([x], [y], [dz]) represent the record before [rotate] finished.
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
  ///   the vector can be separate into the one that parallel to z axis, and the one that parallel to xy plane.
  ///   the one that parallel to z axis directly effect the result [Point3.dz] without consideration of rA'.
  ///   [Point3.dz] = cos(rP + rP')
  ///
  ///   the one that parallel to xy plane projects a positive distance on xy plane, sin(rP + rP'),
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
  ///     [  0, sin, cos ]  [ dz ]
  /// When rotate on y axis,
  ///   the vector parallel to x axis will project on both x axis and z axis.      ( cos,-sin)
  ///   the vector parallel to z axis will project on both x axis and z axis, too. ( sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,  0, sin ]  [ x ]
  ///     [  0,   1,   0 ]  [ y ]
  ///     [-sin,  0, cos ]  [ dz ]
  /// When rotate on z axis,
  ///   the vector parallel to x axis will project on both x axis and y axis.      ( cos, sin)
  ///   the vector parallel to y axis will project on both x axis and y axis, too. (-sin, cos)
  ///   therefore, the matrix multiplication be like:
  ///     [ cos,-sin,  0 ]  [ x ]
  ///     [ sin, cos,  0 ]  [ y ]
  ///     [  0,    0,  1 ]  [ dz ]
  /// because the priority of rotations on x axis, y axis, z axis influence each other,
  /// it better not to rotate by them all together at [Point3.rotate].
  ///   [rotateX] do the rotation only for x axis:
  ///     [x]' = [x]
  ///     [y]' = [y] * cos(rx) - [dz] * sin(rx)
  ///     [dz]' = [y] * sin(rx) + [dz] * cos(rx)
  ///   [rotateY] do the rotation only for y axis:
  ///     [x]' = [x] * cos(ry) + [dz] * sin(ry)
  ///     [y]' = [y]
  ///     [dz]' = [dz] * cos(ry) - [x] * sin(ry)
  ///   [rotateZ] do the rotation only for z axis:
  ///     [x]' = [x] * cos(rz) - [y] * sin(rz)
  ///     [y]' = [x] * sin(rz) + [y] * cos(rz)
  ///     [dz]' = [dz]
  ///
  ///
  (double, double, double) rotateX(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1, $2 * c - $3 * s, $2 * s + $3 * c);
  }

  (double, double, double) rotateY(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c + $3 * s, $2, $3 * c * c - $1 * s);
  }

  (double, double, double) rotateZ(double radian) {
    final c = math.cos(radian);
    final s = math.sin(radian);
    return ($1 * c + $2 * s, $1 * s + $2 * c, $3);
  }

  ///
  /// [toStringAsFixed]
  /// [iterator]
  ///
  String toStringAsFixed(int digit) => '(${$1.toStringAsFixed(digit)}, '
      '${$2.toStringAsFixed(digit)}, ${$3.toStringAsFixed(digit)})';

  Iterator<double> get iterator => [$1, $2, $3].iterator;
}

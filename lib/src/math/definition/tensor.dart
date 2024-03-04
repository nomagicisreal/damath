///
///
/// this file contains:
///
/// [Tensor]
///   [TensorScalar]
///   [TensorVector]
///     [TensorVector2D]
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
part of damath_math;

///
///
/// tensor
///
///

//
sealed class Tensor<V> {
  final V value;

  Tensor(this.value);

  bool isSpaceEqualWith(Tensor other);

  ///
  /// operators, getters
  ///
  Tensor operator -();

  Tensor operator +(Tensor other);

  Tensor operator -(Tensor other);

  Tensor operator &(Tensor other); // multiply accordingly

  Tensor operator *(double scale);

  Tensor operator /(double factor);

  Tensor operator ~/(double factor);

  Tensor operator %(double operand);

  Tensor get round;

  Object dotProductWith(Tensor other);
}

///
/// scalar
///

//
class TensorScalar extends Tensor<double> {
  TensorScalar(super.value);

  @override
  String toString() => 'TensorScalar($value)';

  @override
  bool isSpaceEqualWith(covariant TensorScalar other) => true;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant TensorScalar other) =>
      value.hashCode == other.hashCode;

  @override
  TensorScalar operator -() => TensorScalar(-value);

  @override
  TensorScalar operator +(covariant TensorScalar other) =>
      TensorScalar(value + other.value);

  @override
  TensorScalar operator -(covariant TensorScalar other) =>
      TensorScalar(value - other.value);

  @override
  TensorScalar operator &(covariant TensorScalar other) =>
      TensorScalar(value * other.value);

  @override
  TensorScalar operator %(double operand) => TensorScalar(value % operand);

  @override
  TensorScalar operator *(double scale) => TensorScalar(value * scale);

  @override
  TensorScalar operator /(double factor) => TensorScalar(value / factor);

  @override
  TensorScalar operator ~/(double factor) =>
      TensorScalar((value ~/ factor).toDouble());

  @override
  TensorScalar get round => TensorScalar(value.roundToDouble());

  @override
  double dotProductWith(covariant TensorScalar other) => value * other.value;
}

///
/// tensor vector
///
/// [length]
/// [_computeAll], [_computeAllWith],
///
/// [distanceSquared], [distance]
///
class TensorVector extends Tensor<List<double>> {
  TensorVector(super.value) : assert(value.isFixed);

  int get length => value.length;

  TensorVector _computeAll(Mapper<double> toValue) =>
      TensorVector(value.mapToList(toValue, growable: false));

  TensorVector _computeAllWith(TensorVector other, Reducer<double> toValue) =>
      TensorVector(
        value.accordinglyAccompany(other.value, toValue, growable: false),
      );

  @override
  String toString() => 'TensorVector($value)';

  @override
  bool isSpaceEqualWith(covariant TensorVector other) => length == other.length;

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant TensorVector other) =>
      value.everyElementsAreEqualWith(other.value);

  @override
  TensorVector operator +(covariant TensorVector other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleAdd);
  }

  @override
  TensorVector operator -(covariant TensorVector other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleSubtract);
  }

  @override
  TensorVector operator &(covariant TensorVector other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleMultiply);
  }

  @override
  TensorVector operator -() => _computeAll((value) => -value);

  @override
  TensorVector operator *(double scale) =>
      _computeAll((value) => value * scale);

  @override
  TensorVector operator /(double factor) =>
      _computeAll((value) => value / factor);

  @override
  TensorVector operator %(double operand) =>
      _computeAll((value) => value % operand);

  @override
  TensorVector operator ~/(double factor) =>
      _computeAll((value) => (value ~/ factor).toDouble());

  @override
  TensorVector get round => _computeAll((value) => value.roundToDouble());

  @override
  double dotProductWith(covariant TensorVector other) =>
      (this & other).value.sum;

  ///
  /// others
  ///

  double operator [](int index) => value[index];

  double get distanceSquared => value.reduce(FReducer.doubleAddSquared);

  double get distance => math.sqrt(distanceSquared);
}

///
/// tensor vector 2d
///
/// [direction], [directionInAngle]
/// [radianTo], [angleTo]
///
class TensorVector2D extends TensorVector {
  TensorVector2D(double x, double y) : super([x, y]);

  double get direction => math.atan2(value[1], value[0]);

  double get directionInAngle => Radian.angleOf(direction).roundToDouble();

  double radianTo(TensorVector2D other) {
    final r = math.acos(dotProductWith(other) / (distance * other.distance));
    return direction > other.direction ? -r : r;
  }

  double angleTo(TensorVector2D other) =>
      Radian.angleOf(radianTo(other)).roundToDouble();
}


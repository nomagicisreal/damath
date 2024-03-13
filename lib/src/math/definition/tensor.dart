///
///
/// this file contains:
///
/// [Tensor]
///   [TensorScalar]
///   [TensorVector]
///     [TensorVectorDouble]
///       [TensorVectorDouble2D]
///     [TensorVectorString]
///   [TensorMatrix]
///   [TensorDataFrame]
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
///
abstract class TensorVector<T> extends Tensor<List<T>> {
  TensorVector(super.value);
}

///
/// tensor vector
///
/// [length]
/// [_computeAll], [_computeAllWith],
///
/// [sumSquared], [distance]
///
class TensorVectorDouble extends TensorVector<double> {
  TensorVectorDouble(super.value);

  int get length => value.length;

  TensorVectorDouble _computeAll(Mapper<double> toValue) =>
      TensorVectorDouble(List.of(value.mapToList(toValue)));

  TensorVectorDouble _computeAllWith(TensorVectorDouble other, Reducer<double> toValue) =>
      TensorVectorDouble(List.of(
        value.accordinglyReduce(other.value, toValue),
      ));

  @override
  String toString() => 'TensorVector($value)';

  @override
  bool isSpaceEqualWith(covariant TensorVectorDouble other) => length == other.length;

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant TensorVectorDouble other) =>
      value.everyElementsAreEqualWith(other.value);

  @override
  TensorVectorDouble operator +(covariant TensorVectorDouble other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleAdd);
  }

  @override
  TensorVectorDouble operator -(covariant TensorVectorDouble other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleSubtract);
  }

  @override
  TensorVectorDouble operator &(covariant TensorVectorDouble other) {
    assert(isSpaceEqualWith(other));
    return _computeAllWith(other, FReducer.doubleMultiply);
  }

  @override
  TensorVectorDouble operator -() => _computeAll((value) => -value);

  @override
  TensorVectorDouble operator *(double scale) =>
      _computeAll((value) => value * scale);

  @override
  TensorVectorDouble operator /(double factor) =>
      _computeAll((value) => value / factor);

  @override
  TensorVectorDouble operator %(double operand) =>
      _computeAll((value) => value % operand);

  @override
  TensorVectorDouble operator ~/(double factor) =>
      _computeAll((value) => (value ~/ factor).toDouble());

  @override
  TensorVectorDouble get round => _computeAll((value) => value.roundToDouble());

  @override
  double dotProductWith(covariant TensorVectorDouble other) =>
      (this & other).value.sum;

  ///
  /// others
  ///

  double operator [](int index) => value[index];

  double get sumSquared => value.reduce(FReducer.doubleAddSquared);
}

///
/// tensor vector 2d
///
/// [direction], [directionInAngle]
/// [radianTo], [angleTo]
///
class TensorVectorDouble2D extends TensorVectorDouble {
  TensorVectorDouble2D(double x, double y) : super([x, y]);

  double get distance => math.sqrt(sumSquared);
  double get direction => math.atan2(value[1], value[0]);

  double get directionInAngle => Radian.angleOf(direction).roundToDouble();

  double radianTo(TensorVectorDouble2D other) {
    final r = math.acos(dotProductWith(other) / (distance * other.distance));
    return direction > other.direction ? -r : r;
  }

  double angleTo(TensorVectorDouble2D other) =>
      Radian.angleOf(radianTo(other)).roundToDouble();
}

// ///
// /// tensor vector string
// ///
// class TensorVectorString extends TensorVector<String> {
//   TensorVectorString(super.value);
// }
//
// ///
// /// tensor matrix string
// ///
// class TensorMatrix<V> extends Tensor<List<List<V>>> {
//   TensorMatrix(super.value);
//
//   // diagonal
// }
//
// ///
// /// tensor data frame
// ///
// class TensorDataFrame extends Tensor<List<TensorVector>> {
//   TensorDataFrame(super.value);
// }
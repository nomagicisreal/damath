///
///
/// this file contains:
///
/// [Tensor]
///   [TensorScalar]
///   [TensorVector]
///     [TensorVectorDouble]
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
part of damath_experiment;

///
///
/// tensor
///
///

//
sealed class Tensor<T> {
  final T value;

  Tensor(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(covariant TensorScalar other) =>
      value.hashCode == other.hashCode;

  @override
  String toString() => 'Tensor($value)';

  ///
  /// operators, getters
  ///
  Tensor<T> operator -();

  Tensor<T> operator +(Tensor<T> other);

  Tensor<T> operator -(Tensor<T> other);

  Tensor<T> operator *(Tensor<T> other);

  Tensor<T> operator /(Tensor<T> other);

  Tensor<T> operator ~/(Tensor<T> other);

  Tensor<T> operator %(Tensor<T> other);

  Tensor<T> operator &(Object operand);
}

///
/// scalar
///

//
abstract class TensorScalar<T> extends Tensor<T> {
  TensorScalar(super.value);
}

///
/// tensor vector
///
///
abstract class TensorVector<T> extends Tensor<List<T>> {
  TensorVector(super.value);

  int get length => value.length;
}

///
/// tensor vector
///
/// [_computeAll], ...
/// [computeAll], ...
/// [sumSquared], ...
///
class TensorVectorDouble extends TensorVector<double> {
  TensorVectorDouble(super.value);

  ///
  /// [_computeAll]
  /// [_computeAllWith]
  ///
  List<double> _computeAll(Applier<double> toValue) => value.mapToList(toValue);

  List<double> _computeAllWith(List<double> other, Reducer<double> toValue) =>
      value.accordinglyReduce(other, toValue);

  ///
  /// [computeAll]
  ///
  /// [computeAll]
  /// [add], [subtract]
  /// [multiply], [divide], [divideToInt], [module]
  ///
  static TensorVectorDouble computeAll(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
    Reducer<double> toVal,
  ) {
    assert(v1.length == v2.length);
    return TensorVectorDouble(v1._computeAllWith(v2.value, toVal));
  }

  static TensorVectorDouble add(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleAdd);

  static TensorVectorDouble subtract(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleSubtract);

  static TensorVectorDouble multiply(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleMultiply);

  static TensorVectorDouble divide(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleDivide);

  static TensorVectorDouble divideToInt(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleDivideToInt);

  static TensorVectorDouble module(
    TensorVectorDouble v1,
    TensorVectorDouble v2,
  ) =>
      computeAll(v1, v2, FReducer.doubleModule);

  ///
  ///
  /// operation
  ///
  ///

  @override
  TensorVectorDouble operator -() =>
      TensorVectorDouble(_computeAll((value) => -value));

  @override
  TensorVectorDouble operator +(covariant TensorVectorDouble other) =>
      add(this, other);

  @override
  TensorVectorDouble operator -(covariant TensorVectorDouble other) =>
      subtract(this, other);

  @override
  TensorVectorDouble operator *(covariant TensorVectorDouble other) =>
      multiply(this, other);

  @override
  TensorVectorDouble operator /(covariant TensorVectorDouble other) =>
      divide(this, other);

  @override
  TensorVectorDouble operator %(covariant TensorVectorDouble other) =>
      module(this, other);

  @override
  TensorVectorDouble operator ~/(covariant TensorVectorDouble other) =>
      divideToInt(this, other);

  @override
  TensorVectorDouble operator &(covariant double operand) {
    throw UnimplementedError();
  }

  double operator [](int index) => value[index];

  ///
  /// others
  ///
  double get sumSquared => value.reduce(FReducer.doubleAddSquared);
}

///
/// tensor vector string
///
abstract class TensorVectorString extends TensorVector<String> {
  TensorVectorString(super.value);
}

///
/// tensor matrix
///
/// static methods:
/// [_assertionMessage]
///
abstract class TensorMatrix<T, V extends TensorVector<T>>
    extends Tensor<List<V>> {
  static String _assertionMessage(List<int> invalidValue) =>
      'expect every vector.length equal: $invalidValue';

  ///
  /// constructors
  ///
  TensorMatrix(super.value)
      : assert(
          !value.iterator.anyDifferentBy((list) => list.length),
          _assertionMessage(value.mapToList((value) => value.length)),
        );

  TensorMatrix.diagonal(int size, T value)
      : assert(false, 'unImplement'),
        super([]);

  ///
  /// [_computeAll], [_computeAllWith]
  ///
  List<V> _computeAll(Applier<V> toValue) => value.mapToList(toValue);

  List<V> _computeAllWith(TensorMatrix<T, V> other, Reducer<V> toValue) =>
      value.accordinglyReduce(other.value, toValue);

  ///
  /// [nRow], [nCol], [size]
  ///
  int get nRow => value.length;

  int get nCol => value.first.length;

  (int, int) get size => (nRow, nCol);

  V operator [](int index) => value[index];

  ///
  /// [isInvertible], [isInvertible]
  /// [transposed]
  /// [inverted]
  ///
  bool get isInvertible;

  bool get isSingular => !isInvertible;

  TensorMatrix<T, V> get transposed;

  TensorMatrix<T, V> get inverted;
}

///
/// tensor matrix double
///

///
/// instance properties:
/// [_computeAll], [_computeAllWith]
/// [nRow], [nCol]
///
///
class TensorMatrixDouble extends TensorMatrix<double, TensorVectorDouble> {
  TensorMatrixDouble(super.value);

  factory TensorMatrixDouble.from(
    int nRow,
    int nCol,
    Generator2D<double> generator,
  ) =>
      TensorMatrixDouble(
        List.generate(
          nRow,
          (i) => TensorVectorDouble(List.generate(
            nCol,
            (j) => generator(i, j),
          )),
        ),
      );

  ///
  /// [computeAll]
  /// [add], [subtract]
  /// [multiply], [divide], [divideToInt], [module]
  ///
  static TensorMatrixDouble computeAll(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
    Reducer<TensorVectorDouble> toVal,
  ) {
    assert(m1.size == m2.size);
    return TensorMatrixDouble(m1._computeAllWith(m2, toVal));
  }

  static TensorMatrixDouble add(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.add);

  static TensorMatrixDouble subtract(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.subtract);

  static TensorMatrixDouble multiply(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.multiply);

  static TensorMatrixDouble divide(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.divide);

  static TensorMatrixDouble divideToInt(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.divideToInt);

  static TensorMatrixDouble module(
    TensorMatrixDouble m1,
    TensorMatrixDouble m2,
  ) =>
      computeAll(m1, m2, TensorVectorDouble.module);

  ///
  /// [mMultiply]
  ///

  ///
  ///
  /// operation
  ///
  ///

  @override
  TensorMatrixDouble operator -() =>
      TensorMatrixDouble(_computeAll((value) => -value));

  @override
  TensorMatrixDouble operator +(covariant TensorMatrixDouble other) =>
      add(this, other);

  @override
  TensorMatrixDouble operator -(covariant TensorMatrixDouble other) =>
      subtract(this, other);

  @override
  TensorMatrixDouble operator *(covariant TensorMatrixDouble other) =>
      multiply(this, other);

  @override
  TensorMatrixDouble operator /(covariant TensorMatrixDouble other) =>
      divide(this, other);

  @override
  TensorMatrixDouble operator %(covariant TensorMatrixDouble other) =>
      module(this, other);

  @override
  TensorMatrixDouble operator ~/(covariant TensorMatrixDouble other) =>
      divideToInt(this, other);

  // matrix multiplication
  @override
  TensorMatrixDouble operator &(covariant TensorMatrixDouble operand) {
    // final nColumn = this.nColumn;
    // final nRowOther = other.nRow;
    // assert(nColumn == nRowOther);
    // return TensorMatrixDouble.fromSpace(
    //   nRow,
    //   other.nColumn,
    //       (i, j) {
    //     double sum = 0;
    //     for (var k = 0; k < nColumn; k++) {
    //       sum += this[i][k] * other[k][j];
    //     }
    //     return sum;
    //   },
    // );
    throw UnimplementedError();
  }

  @override
  TensorVectorDouble operator [](int index) => value[index];

  ///
  ///
  ///
  @override
  TensorMatrixDouble get transposed =>
      TensorMatrixDouble.from(nCol, nRow, (i, j) => value[j][i]);

  @override
  bool get isInvertible => throw UnimplementedError();

  @override
  TensorMatrixDouble get inverted {
    assert(isInvertible);
    throw UnimplementedError();
  }
}

///
/// tensor data frame
///
abstract class TensorDataFrame extends Tensor<List<TensorVector>> {
  TensorDataFrame(super.value);
}

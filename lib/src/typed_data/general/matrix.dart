///
///
/// this file contains:
///
///
///
///
part of damath_typed_data;

//
// ///
// /// tensor matrix
// ///
// /// static methods:
// /// [_assertionMessage]
// ///
// assumption class TensorMatrix<T>
//     extends Tensor<List<double>> {
//   ///
//   /// constructors
//   ///
//   TensorMatrix(super.value)
//       : assert(
//           !value.iterator.existDifferentBy((list) => list.length),
//           _assertionMessage(value.mapToList((value) => value.length)),
//         );
//
//   TensorMatrix.diagonal(int size, T value)
//       : assert(false, 'unImplement'),
//         super([]);
//
//   ///
//   /// [_computeAll], [_computeAllWith]
//   ///
//   List<V> _computeAll(Applier<V> toValue) => value.mapToList(toValue);
//
//   List<V> _computeAllWith(TensorMatrix<T, V> other, Reducer<V> toValue) =>
//       value.accordinglyReduce(other.value, toValue);
//
//   ///
//   /// [nRow], [nCol], [size]
//   ///
//   int get nRow => value.length;
//
//   int get nCol => value.first.length;
//
//   (int, int) get size => (nRow, nCol);
//
//   V operator [](int index) => value[index];
//
//   ///
//   /// [isInvertible], [isInvertible]
//   /// [transposed]
//   /// [inverted]
//   ///
//   bool get isInvertible;
//
//   bool get isSingular => !isInvertible;
//
//   TensorMatrix<T, V> get transposed;
//
//   TensorMatrix<T, V> get inverted;
// }
//
// ///
// /// tensor matrix double
// ///
//
// ///
// /// instance properties:
// /// [_computeAll], [_computeAllWith]
// /// [nRow], [nCol]
// ///
// ///
// class TensorMatrixDouble extends TensorMatrix<double, TensorVectorDouble> {
//   TensorMatrixDouble(super.value);
//
//   factory TensorMatrixDouble.from(
//     int nRow,
//     int nCol,
//     Generator2D<double> generator,
//   ) =>
//       TensorMatrixDouble(
//         List.generate(
//           nRow,
//           (i) => TensorVectorDouble(List.generate(
//             nCol,
//             (j) => generator(i, j),
//           )),
//         ),
//       );
//
//   ///
//   /// [computeAll]
//   /// [add], [subtract]
//   /// [multiply], [divided], [dividedToInt], [module]
//   ///
//   static TensorMatrixDouble computeAll(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//     Reducer<TensorVectorDouble> toVal,
//   ) {
//     assert(m1.size == m2.size);
//     return TensorMatrixDouble(m1._computeAllWith(m2, toVal));
//   }
//
//   static TensorMatrixDouble add(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.add);
//
//   static TensorMatrixDouble subtract(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.subtract);
//
//   static TensorMatrixDouble multiply(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.multiply);
//
//   static TensorMatrixDouble divided(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.divided);
//
//   static TensorMatrixDouble dividedToInt(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.dividedToInt);
//
//   static TensorMatrixDouble module(
//     TensorMatrixDouble m1,
//     TensorMatrixDouble m2,
//   ) =>
//       computeAll(m1, m2, TensorVectorDouble.module);
//
//   ///
//   /// [mMultiply]
//   ///
//
//   ///
//   ///
//   /// operation
//   ///
//   ///
//
//   @override
//   TensorMatrixDouble operator -() =>
//       TensorMatrixDouble(_computeAll((value) => -value));
//
//   @override
//   TensorMatrixDouble operator +(covariant TensorMatrixDouble other) =>
//       add(this, other);
//
//   @override
//   TensorMatrixDouble operator -(covariant TensorMatrixDouble other) =>
//       subtract(this, other);
//
//   @override
//   TensorMatrixDouble operator *(covariant TensorMatrixDouble other) =>
//       multiply(this, other);
//
//   @override
//   TensorMatrixDouble operator /(covariant TensorMatrixDouble other) =>
//       divided(this, other);
//
//   @override
//   TensorMatrixDouble operator %(covariant TensorMatrixDouble other) =>
//       module(this, other);
//
//   @override
//   TensorMatrixDouble operator ~/(covariant TensorMatrixDouble other) =>
//       dividedToInt(this, other);
//
//   // matrix multiplication
//   @override
//   TensorMatrixDouble operator &(covariant TensorMatrixDouble operand) {
//     // final nColumn = this.nColumn;
//     // final nRowOther = other.nRow;
//     // assert(nColumn == nRowOther);
//     // return TensorMatrixDouble.fromSpace(
//     //   nRow,
//     //   other.nColumn,
//     //       (i, j) {
//     //     double sum = 0;
//     //     for (var k = 0; k < nColumn; k++) {
//     //       sum += this[i][k] * other[k][j];
//     //     }
//     //     return sum;
//     //   },
//     // );
//     throw UnimplementedError();
//   }
//
//   @override
//   TensorVectorDouble operator [](int index) => value[index];
//
//   ///
//   ///
//   ///
//   @override
//   TensorMatrixDouble get transposed =>
//       TensorMatrixDouble.from(nCol, nRow, (i, j) => value[j][i]);
//
//   @override
//   bool get isInvertible => throw UnimplementedError();
//
//   @override
//   TensorMatrixDouble get inverted {
//     assert(isInvertible);
//     throw UnimplementedError();
//   }
// }

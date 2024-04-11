///
///
/// this file contains:
///
///
///
part of damath_typed_data;


///
/// [toString], ...(overrides)
/// [_list], ...(getter)
///
///
abstract class _VectorOperatable<T, O>
    implements
        IOperatableIndexableAssignable<T>,
        IOperatableDirectable<O, O>,
        IOperatableScalable<O, O>,
        IOperatableComplex<O, O> {
  ///
  /// overrides
  ///
  
  String toString() => 'Vector$_list';

  ///
  /// implementation for operatable
  ///
  
  T operator [](int i) => _list[i];

  
  void operator []=(int i, T value) => _list[i] = value;

  ///
  /// getter
  ///
  List<T> get _list;

  ///
  /// constructor
  ///
  const _VectorOperatable();
}

///
///
///
abstract class Vector<T> extends _VectorOperatable<T, Vector<T>> {

}


///
/// enable operation for vector bool, matrix bool, list bool, nullable like r language
///
abstract class Bector<T> extends _VectorOperatable<T, Vector<bool>> {

}




// use indices, index vector, iterable bool into getter for rows or cols

//
// Lagrange's four-square theorem
// every natural number can be represented as a sum of four non-negative integer squares.
//
// class Vector4 {}
//

// factor, factor(X, level), unique


///
///
/// this file contains:
///
///
///
///
part of damath_structure;

//
mixin _MixinNodeBidirect<T, N extends NodeBidirect<T, N>> on Node<T, N>
    implements _INodeOneDimension<T, N> {
  ///
  /// overrides
  ///
  @override
  T operator [](int index) => throw UnimplementedError();

  @override
  StringBuffer _string([bool next = true]) => _INodeOneDimension.string<T, N>(
        this as N,
        next ? _INodeOneDimension.mapToNext : _INodeOneDimension.mapToPrevious,
      );

  @override
  int get length => throw UnimplementedError();

  ///
  /// setter, getter
  ///
  set previous(N? node);

  N? get previous;
}

///
///
///
///
abstract class NodeBidirect<T, N extends NodeBidirect<T, N>> extends Node<T, N>
    with _MixinNodeBidirect<T, N> {
  ///
  /// overrides
  ///
  @override
  String toString() => 'Node:\n\t${_string(true)}\n\t${_string(false)}';

  ///
  /// constructor
  ///
  const NodeBidirect();
}

// queterator is bidirect version of qurator

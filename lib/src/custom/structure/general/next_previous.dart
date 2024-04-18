///
///
/// this file contains:
///
/// [_MixinNodeBidirect]
/// [_NodeBidirect]
///   |-
///   |
///   |
///   |
///
///
///
///
///
part of damath_structure;

//
mixin _MixinNodeBidirect<T, N extends _NodeBidirect<T, N>> on Node<T, N>
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
abstract class _NodeBidirect<T, N extends _NodeBidirect<T, N>> extends Node<T, N>
    with _MixinNodeBidirect<T, N> {
  ///
  /// overrides
  ///
  @override
  String toString() => 'Node:\n\t${_string(true)}\n\t${_string(false)}';

  ///
  /// constructor
  ///
  const _NodeBidirect();
}

//
mixin _MixinNodeConstructPrevious<T, N extends _NodeBidirect<T, N>>
    on _NodeBidirect<T, N>, _MixinNodeNew<T, N> {
  // N _constructPrevious(T data, Applier<N> applyNotNull) =>
  //     previous == null ? _new(data) : applyNotNull(previous!);
  //
  // N _constructPreviousIterable(
  //   Iterable<T> iterable,
  //   Companion<N, T> companionNull,
  //   Applier<N> applyNotNull,
  // ) =>
  //     previous == null
  //         ? _newIterable(iterable, companionNull)
  //         : applyNotNull(previous!);
}

///
///
///
///

//
mixin _MixinNodeBidirectInsertable<T, N extends _NodeBidirectInsertable<T, N>>
    on
        _MixinVertexHidden<T>,
        _MixinNodeHiddenNext<T, N>,
        _MixinNodeConstructNext<T, N>,
        _MixinNodeConstructPrevious<T, N> {}

///
///
///
abstract class _NodeBidirectInsertable<T,
        N extends _NodeBidirectInsertable<T, N>> extends _NodeBidirect<T, N>
    with
        _MixinVertexHidden<T>,
        _MixinNodeHiddenNext<T, N>,
        _MixinNodeNew<T, N>,
        _MixinNodeConstructNext<T, N>,
        _MixinNodeConstructPrevious<T, N>,
        _MixinNodeBidirectInsertable<T, N> {
  ///
  /// constructor
  ///
  const _NodeBidirectInsertable();
}

// queterator is bidirect version of qurator

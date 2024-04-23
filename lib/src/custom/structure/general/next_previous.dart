///
///
/// this file contains:
///
/// [_MixinNodeBidirect]
/// [_NodeBidirect]
///   |##[_MixinNodeHiddenPrevious], ##[_MixinNodeConstructPrevious]
///   |##[_MixinNodeInsertCurrentPrevious]
///   |
///   |-[_NodeBidirectInsertable]
///   |   |##[_MixinNodeBidirectInsertableByInvalid], ##[_MixinNodeBidirectInsertableByInvalidComparator]
///   |   |
///   |   |##[_MixinNodeBidirectInsertableIterator]
///   |   |-[_NodeBidirectInsertableIterator]
///   |   |   |-[_NodeQueueComparedBidirect]
///   |   |   |-[_NodeQueueBidirect]
///   |   ...
///
///
///
///
///
part of damath_structure;

// ///
// ///
// ///
// /// bidirect
// ///
// ///
// ///
// mixin _MixinNodeBidirect<T, N extends _NodeBidirect<T, N>> on Node<T, N>
//     implements _INodeOneDimension<T, N> {
//   ///
//   /// overrides
//   ///
//   @override
//   T operator [](int index) => throw UnimplementedError();
//
//   @override
//   void operator []=(int i, data) => throw UnimplementedError();
//
//   @override
//   StringBuffer _string([bool next = true]) => _INodeOneDimension.string<T, N>(
//         this as N,
//         next ? _INodeOneDimension.mapToNext : _INodeOneDimension.mapToPrevious,
//       );
//
//   @override
//   (int, int) get length => throw UnimplementedError();
//
//   ///
//   /// setter, getter
//   ///
//   set previous(N? node);
//
//   N? get previous;
// }
//
// ///
// ///
// ///
// ///
// ///
// ///
// abstract class _NodeBidirect<T, N extends _NodeBidirect<T, N>>
//     extends Node<T, N> with _MixinNodeBidirect<T, N> {
//   ///
//   /// overrides
//   ///
//   @override
//   String toString() => 'Node:\n\t${_string(true)}\n\t${_string(false)}';
//
//   ///
//   /// constructor
//   ///
//   const _NodeBidirect();
// }
//
// //
// mixin _MixinNodeHiddenPrevious<T, N extends _NodeBidirect<T, N>>
//     on _NodeBidirect<T, N> {
//   @override
//   set previous(covariant N? node) =>
//       throw StateError(FErrorMessage.nodeCannotAssignDirectly);
//
//   @override
//   N? get previous => _previous;
//
//   set _previous(covariant N? node) =>
//       throw StateError(FErrorMessage.modifyImmutable);
//
//   N? get _previous;
// }
//
// //
// mixin _MixinNodeConstructPrevious<T, N extends _NodeBidirect<T, N>>
//     on _NodeBidirect<T, N>, _MixinNodeNew<T, N> {
//   N _constructPrevious(T data, Applier<N> applyNotNull) =>
//       previous == null ? _new(data) : applyNotNull(previous!);
//
//   N _constructPreviousIterable(
//     Iterable<T> iterable,
//     Companion<N, T> companionNull,
//     Applier<N> applyNotNull,
//   ) =>
//       previous == null
//           ? _newIterable(iterable, companionNull)
//           : applyNotNull(previous!);
// }
//
// //
// mixin _MixinNodeInsertCurrentPrevious<T, N extends _NodeBidirect<T, N>>
//     on
//         _MixinNodeInsertCurrent<T, N>,
//         _MixinNodeHiddenPrevious<T, N>,
//         _MixinNodeConstructPrevious<T, N> {
//   @override
//   void _insertCurrent(T data, [bool onPrevious = false]) {
//     if (onPrevious) {
//       _previous = _construct(this.data, _previous);
//       _data = data;
//       return;
//     }
//     super._insertCurrent(data);
//   }
//
//   void _insertPrevious(T element, Applier<N> applyNotNull) =>
//       _previous = _constructPrevious(element, applyNotNull);
// }
//
// ///
// ///
// ///
// abstract class _NodeBidirectInsertable<T,
//         N extends _NodeBidirectInsertable<T, N>> extends _NodeBidirect<T, N>
//     with
//         _MixinVertexHidden<T>,
//         _MixinNodeNew<T, N>,
//         _MixinNodeHiddenNext<T, N>,
//         _MixinNodeHiddenPrevious<T, N>,
//         _MixinNodeConstructNext<T, N>,
//         _MixinNodeConstructPrevious<T, N>,
//         _MixinNodeInsertCurrent<T, N>,
//         _MixinNodeInsertCurrentPrevious<T, N> {
//   ///
//   /// constructor
//   ///
//   const _NodeBidirectInsertable();
// }
//
// //
// mixin _MixinNodeBidirectInsertableByInvalid<C extends Comparable,
//         N extends _MixinNodeBidirectInsertableByInvalid<C, N>>
//     on _NodeBidirectInsertable<C, N> {
//   @override
//   void insert(
//     C element, [
//     bool? movePrevious,
//     Applicator<C, N>? onLess,
//     Applicator<C, N>? onMore,
//   ]) =>
//       switch (data.compareTo(element)) {
//         0 => _insertCurrent(element, movePrevious!),
//         // -1 => _insertPrevious(element, _applyNotNull(element, onLess)),
//         // 1 => _insertNext(element, _applyNotNull(element, onLess)),
//         -1 => onLess!(
//             element,
//             (n) => n..insert(element, movePrevious, onLess, onMore),
//           ),
//         1 => onMore!(
//             element,
//             (n) => n..insert(element, movePrevious, onLess, onMore),
//           ),
//         _ => throw UnimplementedError(),
//       };
//
//   @override
//   void insertAll(
//     Iterable<C> iterable, [
//     bool? currentToPrevious,
//     Applicator<C, N>? onLess,
//     Applicator<C, N>? onMore,
//   ]) =>
//       iterable.iterator.consumeAll(
//         (element) => insert(element, currentToPrevious, onLess, onMore),
//       );
// }
//
// //
// mixin _MixinNodeBidirectInsertableByInvalidComparator<T,
//         N extends _MixinNodeBidirectInsertableByInvalidComparator<T, N>>
//     on _NodeBidirectInsertable<T, N> {
//   @override
//   void insert(
//     T element, [
//     bool? movePrevious,
//     Comparator<T>? comparator,
//     Applicator<T, N>? onLess,
//     Applicator<T, N>? onMore,
//   ]) =>
//       switch (comparator!(data, element)) {
//         0 => _insertCurrent(element, movePrevious!),
//         -1 => onLess!(
//             element,
//             (n) => n..insert(element, movePrevious, comparator, onLess, onMore),
//           ),
//         1 => _insertNext(
//             element,
//             (n) => n..insert(element, movePrevious, comparator, onLess, onMore),
//           ),
//         _ => throw UnimplementedError(),
//       };
//
//   @override
//   void insertAll(
//     Iterable<T> iterable, [
//     bool? movePrevious,
//     Comparator<T>? comparator,
//     Applicator<T, N>? onLess,
//     Applicator<T, N>? onMore,
//   ]) =>
//       iterable.iterator.consumeAll(
//         (element) => insert(element, movePrevious, comparator, onLess, onMore),
//       );
// }
//
// ///
// ///
// ///
// ///
// mixin _MixinNodeBidirectInsertableIterator<I,
//         N extends _NodeBidirectInsertableIterator<I, N>>
//     on _NodeBidirectInsertable<I, N> implements IIteratorPrevious<I> {
//   ///
//   /// overrides
//   ///
//   @override
//   bool movePrevious() {
//     final node = _previous;
//     if (node == null) {
//       _data = null;
//       return false;
//     }
//     _data = node.data;
//     _previous = node._previous;
//     return true;
//   }
// }
//
// //
// abstract class _NodeBidirectInsertableIterator<I,
//         N extends _NodeBidirectInsertableIterator<I, N>>
//     extends _NodeBidirectInsertable<I, N>
//     with
//         _MixinNodeBidirectInsertableIterator<I, N>,
//         _MixinNodeNextIterator<I, N> {
//   ///
//   /// overrides
//   ///
//   @override
//   I? _data;
//
//   @override
//   N? _next;
//
//   @override
//   N? _previous;
//
//   ///
//   /// constructor
//   ///
//   _NodeBidirectInsertableIterator(this._data, [this._next, this._previous]);
//
//   _NodeBidirectInsertableIterator._fromIterable(
//     Iterable<I> iterable,
//     Mapper<I, N> initialize,
//     Companion<N, I> reducing,
//   ) : _next = iterable.iterator.inductInited<N>(initialize, reducing);
// }

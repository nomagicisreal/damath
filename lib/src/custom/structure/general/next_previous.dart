///
///
/// this file contains:
///
///
part of '../structure.dart';

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
//       switch (element.compareTo(data)) {
//         0 => _insertCurrent(element, movePrevious!),
//         -1 => onLess!(
//             element,
//             (n) => n..insert(element, movePrevious, onLess, onMore),
//           ),
//         1 => onMore!(
//             element,
//             (n) => n..insert(element, movePrevious, onLess, onMore),
//           ),
//         _ => throw UnsupportedError(FErrorMessage.comparableValueNotProvided),
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
//       switch (comparator!(element, data)) {
//         0 => _insertCurrent(element, movePrevious!),
//         -1 => onLess!(
//             element,
//             (n) => n..insert(element, movePrevious, comparator, onLess, onMore),
//           ),
//         1 => _insertNext(
//             element,
//             (n) => n..insert(element, movePrevious, comparator, onLess, onMore),
//           ),
//         _ => throw UnsupportedError(FErrorMessage.comparableValueNotProvided),
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
//     Companion<N, I> companion,
//   ) : _next = iterable.iterator.inductInited<N>(initialize, companion);
// }
//
// ///
// ///
// /// [_construct], ...(overrides)
// /// (constructors)
// /// [_NodeQueueComparedBidirect.suffixFromIterableIncrease]
// /// [_NodeQueueComparedBidirect.suffixFromIterableDecrease]
// /// [_NodeQueueComparedBidirect.prefixFromIterableIncrease]
// /// [_NodeQueueComparedBidirect.prefixFromIterableDecrease]
// ///
// ///
// class _NodeQueueComparedBidirect<C extends Comparable>
//     extends _NodeBidirectInsertableIterator<C, _NodeQueueComparedBidirect<C>>
//     with
//         _MixinNodeBidirectInsertableByInvalid<C,
//             _NodeQueueComparedBidirect<C>> {
//   ///
//   /// overrides
//   ///
//   @override
//   NodeConstructor<C, _NodeQueueComparedBidirect<C>> get _construct =>
//       (data, next) => _NodeQueueComparedBidirect(data, next);
//
//   ///
//   /// constructors
//   ///
//   _NodeQueueComparedBidirect([super.data, super._next]);
//
//   _NodeQueueComparedBidirect._init(C super._data);
//
//   _NodeQueueComparedBidirect.suffixFromIterableIncrease(Iterable<C> iterable)
//       : super._fromIterable(
//           iterable,
//           _NodeQueueComparedBidirect<C>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               false,
//               _QuratorBinary._applicatePrevious(n),
//               _QuratorBinary._applicateNext(n),
//             ),
//         );
//
//   _NodeQueueComparedBidirect.suffixFromIterableDecrease(Iterable<C> iterable)
//       : super._fromIterable(
//           iterable,
//           _NodeQueueComparedBidirect<C>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               false,
//               _QuratorBinary._applicateNext(n),
//               _QuratorBinary._applicatePrevious(n),
//             ),
//         );
//
//   _NodeQueueComparedBidirect.prefixFromIterableIncrease(Iterable<C> iterable)
//       : super._fromIterable(
//           iterable,
//           _NodeQueueComparedBidirect<C>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               true,
//               _QuratorBinary._applicatePrevious(n),
//               _QuratorBinary._applicateNext(n),
//             ),
//         );
//
//   _NodeQueueComparedBidirect.prefixFromIterableDecrease(Iterable<C> iterable)
//       : super._fromIterable(
//           iterable,
//           _NodeQueueComparedBidirect<C>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               true,
//               _QuratorBinary._applicateNext(n),
//               _QuratorBinary._applicatePrevious(n),
//             ),
//         );
// }
//
// ///
// ///
// /// [_construct], ...(overrides)
// /// (constructors)
// /// [_NodeQueueBidirect.suffixFromIterableIncrease]
// /// [_NodeQueueBidirect.suffixFromIterableDecrease]
// /// [_NodeQueueBidirect.prefixFromIterableIncrease]
// /// [_NodeQueueBidirect.prefixFromIterableDecrease]
// ///
// ///
// class _NodeQueueBidirect<I>
//     extends _NodeBidirectInsertableIterator<I, _NodeQueueBidirect<I>>
//     with
//         _MixinNodeBidirectInsertableByInvalidComparator<I,
//             _NodeQueueBidirect<I>> {
//   ///
//   /// overrides
//   ///
//   @override
//   NodeConstructor<I, _NodeQueueBidirect<I>> get _construct =>
//       (data, next) => _NodeQueueBidirect(data, next);
//
//   ///
//   /// constructors
//   ///
//   _NodeQueueBidirect([super._data, super._next]);
//
//   _NodeQueueBidirect._init(I super._data);
//
//   _NodeQueueBidirect.suffixFromIterableIncrease(
//     Iterable<I> iterable,
//     Comparator<I> comparator,
//   ) : super._fromIterable(
//           iterable,
//           _NodeQueueBidirect<I>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               false,
//               comparator,
//               _QuratorBinary._applicatePrevious(n),
//               _QuratorBinary._applicateNext(n),
//             ),
//         );
//
//   _NodeQueueBidirect.suffixFromIterableDecrease(
//     Iterable<I> iterable,
//     Comparator<I> comparator,
//   ) : super._fromIterable(
//           iterable,
//           _NodeQueueBidirect<I>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               false,
//               comparator,
//               _QuratorBinary._applicateNext(n),
//               _QuratorBinary._applicatePrevious(n),
//             ),
//         );
//
//   _NodeQueueBidirect.prefixFromIterableIncrease(
//     Iterable<I> iterable,
//     Comparator<I> comparator,
//   ) : super._fromIterable(
//           iterable,
//           _NodeQueueBidirect<I>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               true,
//               comparator,
//               _QuratorBinary._applicatePrevious(n),
//               _QuratorBinary._applicateNext(n),
//             ),
//         );
//
//   _NodeQueueBidirect.prefixFromIterableDecrease(
//     Iterable<I> iterable,
//     Comparator<I> comparator,
//   ) : super._fromIterable(
//           iterable,
//           _NodeQueueBidirect<I>._init,
//           (n, element) => n
//             ..insert(
//               element,
//               true,
//               comparator,
//               _QuratorBinary._applicateNext(n),
//               _QuratorBinary._applicatePrevious(n),
//             ),
//         );
// }
//
// ///
// ///
// /// see also [_Qurator]
// /// [_QuratorBinary] contains subclass of [_NodeDirectInsertableIterator] to instruct how to prioritize data.
// /// it holds necessary comparison data once, instead of duplicate comparators or predicators for each general.
// ///
// ///
// abstract class _QuratorBinary<I,
//         N extends _NodeBidirectInsertableIterator<I, N>>
//     extends _NodeQueueIterator<I, N>
//     implements IIteratorPrevious<I>, IInsertable<I> {
//   ///
//   /// overrides
//   ///
//   @override
//   I get current =>
//       _node._data ?? (throw StateError(FErrorMessage.iteratorNoElement));
//
//   @override
//   bool moveNext() => _node.moveNext();
//
//   @override
//   bool movePrevious() => _node.movePrevious();
//
//   ///
//   /// properties
//   ///
//   bool get isNotEmpty => _node._next != null;
//
//   bool get isEmpty => _node._next == null;
//
//   bool get isCleared => _node._data == null && _node._next == null;
//
//   bool get isNotCleared => _node._data != null || _node._next != null;
//
//   final bool _prefix;
//   final Mapper<N, Applicator<I, N>> _onLess;
//   final Mapper<N, Applicator<I, N>> _onMore;
//
//   ///
//   /// constructors
//   ///
//   // const _QuratorBinary.expired(
//   //   super._node,
//   //   this._prefix,
//   //   this._onLess,
//   //   this._onMore,
//   // ) : super.expired();
//
//   _QuratorBinary.suffixIncreaseExpired(super._node)
//       : _prefix = false,
//         _onLess = _applicatePrevious<I, N>,
//         _onMore = _applicateNext<I, N>,
//         super.expired();
//
//   _QuratorBinary.suffixDecreaseExpired(super._node)
//       : _prefix = false,
//         _onLess = _applicateNext<I, N>,
//         _onMore = _applicatePrevious<I, N>,
//         super.expired();
//
//   _QuratorBinary.prefixIncreaseExpired(super._node)
//       : _prefix = true,
//         _onLess = _applicatePrevious<I, N>,
//         _onMore = _applicateNext<I, N>,
//         super.expired();
//
//   _QuratorBinary.prefixDecreaseExpired(super._node)
//       : _prefix = true,
//         _onLess = _applicateNext<I, N>,
//         _onMore = _applicatePrevious<I, N>,
//         super.expired();
//
//   _QuratorBinary.ofExpired(
//     super._node, [
//     bool increase = true,
//     bool prefix = false,
//   ])  : _prefix = prefix,
//         _onLess = increase
//             ? _QuratorBinary._applicatePrevious
//             : _QuratorBinary._applicateNext,
//         _onMore = increase
//             ? _QuratorBinary._applicateNext
//             : _QuratorBinary._applicatePrevious,
//         super.expired();
//
//   ///
//   /// static methods
//   ///
//   static Applicator<I, N>
//       _applicatePrevious<I, N extends _NodeBidirectInsertableIterator<I, N>>(
//               N node) =>
//           node._insertPrevious;
//
//   static Applicator<I, N>
//       _applicateNext<I, N extends _NodeBidirectInsertableIterator<I, N>>(
//               N node) =>
//           node._insertNext;
// }
//
// ///
// /// [_insertNotNull]
// /// [_insertIterableNotNull]
// ///
// /// [QuratorComparedBinary.suffixIncreaseExpired], ...
// /// [QuratorComparedBinary.emptyExpired], ...
// ///
// ///
// class QuratorComparedBinary<C extends Comparable>
//     extends _QuratorBinary<C, _NodeQueueComparedBidirect<C>> {
//   ///
//   /// overrides
//   ///
//   @override
//   String toString() => 'NodeQueueBinary: $_node';
//
//   @override
//   void insert(C element, [bool toPrevious = false]) => toPrevious
//       ? _node._previous = _node._constructPrevious(
//           element,
//           _insertNotNull(element),
//         )
//       : _node._next = _node._constructNext(
//           element,
//           _insertNotNull(element),
//         );
//
//   @override
//   void insertAll(Iterable<C> iterable, [bool toPrevious = false]) => toPrevious
//       ? _node._previous = _node._constructPreviousIterable(
//           iterable,
//           (node, element) => _insertNotNull(element)(node),
//           _insertIterableNotNull(iterable),
//         )
//       : _node._next = _node._constructNextIterable(
//           iterable,
//           (node, element) => _insertNotNull(element)(node),
//           _insertIterableNotNull(iterable),
//         );
//
//   ///
//   /// functions
//   ///
//   Applier<_NodeQueueComparedBidirect<C>> _insertNotNull(C e) =>
//       (n) => n..insert(e, _prefix, _onLess(n), _onMore(n));
//
//   Applier<_NodeQueueComparedBidirect<C>> _insertIterableNotNull(
//     Iterable<C> iterable,
//   ) =>
//       (child) =>
//           child..insertAll(iterable, _prefix, _onLess(_node), _onMore(_node));
//
//   ///
//   /// constructor
//   ///
//   QuratorComparedBinary.emptyExpired([
//     bool increase = true,
//     bool prefix = false,
//   ]) : super.ofExpired(_NodeQueueComparedBidirect(), prefix, increase);
//
//   QuratorComparedBinary.ofExpired(
//     C value, [
//     bool increase = true,
//     bool prefix = false,
//   ]) : super.ofExpired(
//           _NodeQueueComparedBidirect(null, _NodeQueueComparedBidirect(value)),
//           prefix,
//           increase,
//         );
//
//   QuratorComparedBinary.suffixIncreaseExpired(Iterable<C> iterable)
//       : super.suffixIncreaseExpired(
//           _NodeQueueComparedBidirect.suffixFromIterableIncrease(iterable),
//         );
//
//   QuratorComparedBinary.suffixDecreaseExpired(Iterable<C> iterable)
//       : super.suffixDecreaseExpired(
//           _NodeQueueComparedBidirect.suffixFromIterableDecrease(iterable),
//         );
//
//   QuratorComparedBinary.prefixIncreaseExpired(Iterable<C> iterable)
//       : super.prefixIncreaseExpired(
//           _NodeQueueComparedBidirect.prefixFromIterableIncrease(iterable),
//         );
//
//   QuratorComparedBinary.prefixDecreaseExpired(Iterable<C> iterable)
//       : super.prefixDecreaseExpired(
//           _NodeQueueComparedBidirect.prefixFromIterableDecrease(iterable),
//         );
// }
//
// ///
// ///
// /// [QuratorBinary.suffixIncreaseExpired], ...
// /// [QuratorBinary.emptyExpired], ...
// ///
// ///
// class QuratorBinary<I> extends _QuratorBinary<I, _NodeQueueBidirect<I>> {
//   ///
//   /// overrides
//   ///
//   @override
//   void insert(I element, [bool toPrevious = false]) => toPrevious
//       ? _node._previous =
//           _node._constructPrevious(element, _insertNotNull(element))
//       : _node._next = _node._constructNext(element, _insertNotNull(element));
//
//   @override
//   void insertAll(Iterable<I> iterable, [bool toPrevious = false]) => toPrevious
//       ? _node._previous = _node._constructPreviousIterable(
//           iterable,
//           (node, element) => _insertNotNull(element)(node),
//           _insertIterableNotNull(iterable))
//       : _node._next = _node._constructNextIterable(
//           iterable,
//           (node, element) => _insertNotNull(element)(node),
//           _insertIterableNotNull(iterable),
//         );
//
//   ///
//   /// functions
//   ///
//   Applier<_NodeQueueBidirect<I>> _insertNotNull(I e) =>
//       (n) => n..insert(e, _prefix, _comparator, _onLess(n), _onMore(n));
//
//   Applier<_NodeQueueBidirect<I>> _insertIterableNotNull(
//     Iterable<I> iterable,
//   ) =>
//       (child) => child
//         ..insertAll(
//             iterable, _prefix, _comparator, _onLess(_node), _onMore(_node));
//
//   ///
//   /// properties
//   ///
//   final Comparator<I> _comparator;
//
//   ///
//   /// constructors
//   ///
//   QuratorBinary.emptyExpired(
//     Comparator<I> comparator, [
//     bool increase = true,
//     bool prefix = false,
//   ])  : _comparator = comparator,
//         super.ofExpired(_NodeQueueBidirect(), prefix, increase);
//
//   QuratorBinary.ofExpired(
//     I value,
//     Comparator<I> comparator, [
//     bool increase = true,
//     bool prefix = false,
//   ])  : _comparator = comparator,
//         super.ofExpired(
//           _NodeQueueBidirect(null, _NodeQueueBidirect(value)),
//           prefix,
//           increase,
//         );
//
//   QuratorBinary.suffixIncreaseExpired(
//       Iterable<I> iterable, Comparator<I> comparator)
//       : _comparator = comparator,
//         super.suffixIncreaseExpired(
//           _NodeQueueBidirect.suffixFromIterableIncrease(iterable, comparator),
//         );
//
//   QuratorBinary.suffixDecreaseExpired(
//       Iterable<I> iterable, Comparator<I> comparator)
//       : _comparator = comparator,
//         super.suffixDecreaseExpired(
//           _NodeQueueBidirect.suffixFromIterableDecrease(iterable, comparator),
//         );
//
//   QuratorBinary.prefixIncreaseExpired(
//       Iterable<I> iterable, Comparator<I> comparator)
//       : _comparator = comparator,
//         super.prefixIncreaseExpired(
//           _NodeQueueBidirect.prefixFromIterableIncrease(iterable, comparator),
//         );
//
//   QuratorBinary.prefixDecreaseExpired(
//       Iterable<I> iterable, Comparator<I> comparator)
//       : _comparator = comparator,
//         super.prefixDecreaseExpired(
//           _NodeQueueBidirect.prefixFromIterableDecrease(iterable, comparator),
//         );
// }

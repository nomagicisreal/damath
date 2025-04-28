part of '../../custom.dart';

///
/// * [NodeConstructor]
///
/// * [Vertex]
///     --[_VertexImmutable], [_VertexMutable]
///     --[_MVertexNullable]
///     |   --[_VertexImmutableNullable], [_VertexMutableNullable]
///     |
///     --[Node1]
///         --[_MNodeNullableNext], [_MNodeNew], [_MNodeNext]
///         --[_MNodeInsert], [_MNodePull], [_MNodePush]
///         |
///         --[NodeAppendable]
///         |   --[_NodeAppendableUnmodifiable], [_NodeAppendableFixed]
///         |   --[_NodeAppendableImmutable], [_NodeAppendableMutable]
///         |
///         --[_Node1Insertable]
///         |  --[_MNode1InsertableByInvalid], [_MNode1InsertableByInvalidComparator]
///         |  |-[_Node1InsertableIterator]
///         |  |   |-[_NodeQueueCompared]           >>     [QuratorCompared]--
///         |  |   |-[_NodeQueue]                   >>             [Qurator]--
///         |                                                             [_Qurator]--
///         --[Node2]                                                             |[_NodeQueueIterator]---------
///             --[_MNodeNullablePrevious], [_MNodePrevious]                                                 |
///             --[_MNodeInsertCurrentPrevious]                                                                |
///             |                                                                                              |
///             --[_NodeBidirectInsertable]                                                                    |
///                 --[_MNodeBidirectInsertableByInvalid], [_MNodeBidirectInsertableByInvalidComparator]       |
///                 |                                                                                          |
///                 --[_NodeBidirectInsertableIterator]                                        |[_QuratorBinary]
///                 |   --[_NodeQueueComparedBidirect]      >>              [QuratorComparedBinary]--
///                 |   --[_NodeQueueBidirect]              >>                      [QuratorBinary]--
///
///
///
///

///
///
///
class _VertexImmutable<T> extends Vertex<T> {
  @override
  final T data;

  const _VertexImmutable(this.data);
}

class _VertexMutable<T> extends Vertex<T> {
  @override
  T data;

  _VertexMutable(this.data);
}

///
///
///
mixin _MVertexNullable<T> on Vertex<T> {
  T? get _data;

  set _data(T? value) => throw StateError(ErrorMessages.modifyImmutable);

  @override
  set data(T value) => _data = value;

  @override
  T get data => _data ?? (throw StateError(ErrorMessages.receiveNull));
}

class _VertexImmutableNullable<T> extends Vertex<T> with _MVertexNullable<T> {
  @override
  final T? _data;

  const _VertexImmutableNullable([this._data]);
}

class _VertexMutableNullable<T> extends Vertex<T> with _MVertexNullable<T> {
  @override
  T? _data;

  _VertexMutableNullable([this._data]);
}

///
///
///
sealed class Node1<T> extends Vertex<T> {
  Node1<T>? get next;

  set next(covariant Node1<T>? node) =>
      throw StateError(ErrorMessages.modifyImmutable);

  const Node1();

  static Node1<T>? mapNext<T>(Node1<T> node) => node.next;

  @override
  String toString() =>
      'Node(${NodeExtension.lengthing(this, mapNext)}): '
      '${NodeExtension._buildString(this, mapNext)}';
}

///
/// whether [Node1] implementation should mixin [_VertexMutableNullable] ?
/// there are some reasons that we have to hold a null variable.
///   1. waiting for assignment in the future
///   2. signals no data
///   3. enable conditions or logic
///   4. to proof the valued has been used ...
/// in most of the cases, nullable [next] is sufficient to indicate the absent of [data].
/// It seems that nullable [data] is redundant for now in [Node1].
///
mixin _MNodeNullableNext<T, N extends Node1<T>> on Node1<T> {
  @override
  N? get next => _next;

  set _next(covariant N? node) =>
      throw StateError(ErrorMessages.modifyImmutable);

  N? get _next;
}

///
///
///
mixin _MNodeNew<T, N extends Node1<T>> on Node1<T> {
  NodeConstructor<T, N> get _construct;
}

///
///
///
mixin _MNodeNext<T, N extends Node1<T>> on Node1<T>, _MNodeNew<T, N> {
  @override
  N? get next;

  N _constructNext(T data, Applier<N> nodingNotNull) =>
      next == null ? _construct(data, null) : nodingNotNull(next!);

  N _constructNextIterable(
    Iterable<T> iterable,
    Companion<N, T> nodingOnNull,
    Applier<N> nodingNotNull,
  ) =>
      next == null
          ? iterable.iterator.inductInited(
            (data) => _construct(data, null),
            nodingOnNull,
          )
          : nodingNotNull(next!);
}

///
///
///
mixin _MNodeInsert<T, N extends Node1<T>>
    on _MVertexNullable<T>, _MNodeNullableNext<T, N>, _MNodeNext<T, N>
    implements IInsertable<T> {
  void _insertCurrent(T data) {
    _next = _construct(this.data, _next);
    _data = data;
  }

  void _insertNext(T data, Applier<N> nodingNotNull) =>
      _next = _constructNext(data, nodingNotNull);

  // void _insertNextIterable(
  //   Iterable<T> iterable,
  //   Companion<N, T> nodingOnNull,
  //   Applier<N> nodingNotNull,
  // ) => _next = _constructNextIterable(iterable, nodingOnNull, nodingNotNull);
}

///
///
///
mixin _MNodePull<I, N extends _MNodeNullableNext<I, N>>
    on _MVertexNullable<I>, _MNodeNullableNext<I, N>
    implements Iterator<I> {
  @override
  I get current => _data ?? (throw StateError(ErrorMessages.iteratorNoElement));

  @override
  bool moveNext() {
    final next = _next;
    if (next == null) {
      _data = null;
      return false;
    }
    _data = next.data;
    _next = next._next;
    return true;
  }
}

///
///
///
mixin _MNodePush<I, N extends _Node1InsertableIterator<I, N>>
    on _Node1Insertable<I, N>
    implements IIteratorPrevious<I> {
  @override
  bool movePrevious() {
    final data = _data;
    if (data == null) return false;
    _data = null;
    _next = _construct(data, _next);
    return true;
  }
}

//
class _NodeAppendableImmutable<T> extends NodeAppendable<T> {
  @override
  final T data;
  @override
  final NodeAppendable<T>? next;

  const _NodeAppendableImmutable(this.data, [this.next])
    : super(NodeAppendable.immutable);
}

//
class _NodeAppendableUnmodifiable<T> extends NodeAppendable<T> {
  @override
  final T data;
  @override
  NodeAppendable<T>? next;

  _NodeAppendableUnmodifiable(this.data, [this.next])
    : super(NodeAppendable.unmodifiable);
}

//
class _NodeAppendableFixed<T> extends NodeAppendable<T> {
  @override
  T data;
  @override
  final NodeAppendable<T>? next;

  _NodeAppendableFixed(this.data, [this.next]) : super(NodeAppendable.fixed);
}

//
class _NodeAppendableMutable<T> extends NodeAppendable<T> {
  @override
  T data;
  @override
  NodeAppendable<T>? next;

  _NodeAppendableMutable(this.data, [this.next])
    : super(NodeAppendable.mutable);
}

///
///
///
///
/// [_Node1Insertable]
///   --[_MNode1InsertableByInvalid]
///   --[_MNode1InsertableByInvalidComparator]
///   |
///   --[_MNodePush]
///   --[_Node1InsertableIterator]                               |-[_Qurator]
///   |   --[_NodeQueueCompared]     >>     [QuratorCompared]-|
///   |   --[_NodeQueue]             >>             [Qurator]-|
///
///
///
///

///
///
///
abstract class _Node1Insertable<T, N extends _Node1Insertable<T, N>>
    extends Node1<T>
    with
        _MVertexNullable<T>,
        _MNodeNullableNext<T, N>,
        _MNodeNew<T, N>,
        _MNodeNext<T, N>,
        _MNodeInsert<T, N> {
  const _Node1Insertable();
}

//
mixin _MNode1InsertableByInvalid<
  C extends Comparable,
  N extends _MNode1InsertableByInvalid<C, N>
>
    on _Node1Insertable<C, N> {
  @override
  void insert(C element, [int? invalid]) =>
      element.compareTo(data) == invalid
          ? _insertNext(element, (node) => node..insert(element, invalid!))
          : _insertCurrent(element);

  @override
  void insertAll(Iterable<C> iterable, [int? invalid]) =>
      iterable.iterator.consumeAll((element) => insert(element, invalid));
}

//
mixin _MNode1InsertableByInvalidComparator<
  T,
  N extends _MNode1InsertableByInvalidComparator<T, N>
>
    on _Node1Insertable<T, N> {
  @override
  void insert(T element, [int? invalid, Comparator<T>? comparator]) =>
      comparator!(element, data) == invalid
          ? _insertNext(
            element,
            (node) => node..insert(element, invalid!, comparator),
          )
          : _insertCurrent(element);

  @override
  void insertAll(
    Iterable<T> iterable, [
    int? invalid,
    Comparator<T>? comparator,
  ]) => iterable.iterator.consumeAll(
    (element) => insert(element, invalid, comparator),
  );
}

///
///
///
/// [_Node1InsertableIterator]
///     |-[_NodeQueueCompared]
///     |-[_NodeQueue]
///
///
///
abstract class _Node1InsertableIterator<
  I,
  N extends _Node1InsertableIterator<I, N>
>
    extends _Node1Insertable<I, N>
    with _MNodePush<I, N>, _MNodePull<I, N> {
  @override
  I? _data;

  @override
  N? _next;

  _Node1InsertableIterator(this._data, [this._next]);

  _Node1InsertableIterator._fromIterable(
    Iterable<I> iterable,
    Mapper<I, N> initialize,
    Companion<N, I> reducing,
  ) : _next = iterable.iterator.inductInited<N>(initialize, reducing);

  static _Node1InsertableIterator<I, N>? mapNext<
    I,
    N extends _Node1InsertableIterator<I, N>
  >(_Node1InsertableIterator<I, N> node) => node.next;
}

///
///
/// [_construct], ...(overrides)
/// [_NodeQueueCompared.fromIterable], ...(constructors)
///
///
class _NodeQueueCompared<C extends Comparable>
    extends _Node1InsertableIterator<C, _NodeQueueCompared<C>>
    with _MNode1InsertableByInvalid<C, _NodeQueueCompared<C>> {
  @override
  NodeConstructor<C, _NodeQueueCompared<C>> get _construct =>
      (data, next) => _NodeQueueCompared(data, next);

  ///
  /// constructors
  ///
  _NodeQueueCompared([super.data, super._next]);

  _NodeQueueCompared._init(C super._data);

  _NodeQueueCompared.fromIterable(Iterable<C> iterable, int invalid)
    : super._fromIterable(
        iterable,
        _NodeQueueCompared<C>._init,
        (node, element) => node..insert(element, invalid),
      );
}

///
///
/// [_construct], ...(overrides)
/// [_NodeQueue.fromIterable], ...(constructors)
///
///
class _NodeQueue<I> extends _Node1InsertableIterator<I, _NodeQueue<I>>
    with _MNode1InsertableByInvalidComparator<I, _NodeQueue<I>> {
  @override
  NodeConstructor<I, _NodeQueue<I>> get _construct =>
      (data, next) => _NodeQueue(data, next);

  _NodeQueue([super._data, super._next]);

  _NodeQueue._init(I super._data);

  _NodeQueue.fromIterable(
    Iterable<I> iterable,
    int invalid,
    Comparator<I> comparator,
  ) : super._fromIterable(
        iterable,
        _NodeQueue<I>._init,
        (node, element) => node..insert(element, invalid, comparator),
      );
}

///
///
/// [_Qurator]
///     |-[QuratorCompared]
///     |-[Qurator]
///
///

///
///
///
abstract class _NodeQueueIterator<I, N extends _MNodeNullableNext<I, N>>
    implements IIteratorPrevious<I>, IInsertable<I> {
  final N _node;

  // final N? _nodeExpired;
  final Mapper<IIteratorPrevious, bool> _moveNext;
  final Mapper<IIteratorPrevious, bool> _movePrevious;

  const _NodeQueueIterator.expired(this._node)
    // : _nodeExpired = null,
    : _moveNext = movingNext,
      _movePrevious = movingPrevious;

  const _NodeQueueIterator(
    this._node,
    this._moveNext,
    this._movePrevious,
    // ) : _nodeExpired = null;
  );

  ///
  ///
  ///
  static bool movingNext<I>(IIteratorPrevious node) => node.moveNext();

  static bool movingPrevious<I>(IIteratorPrevious node) => node.movePrevious();

  @override
  String toString() =>
      'NodeQueue: ${_node._next.nullOrMap((node) => NodeExtension._buildString(node, (n) => n.next))}';
}

///
///
/// [_Qurator] contains subclass of [_Node1InsertableIterator] to instruct how to prioritize data.
/// it holds necessary comparison data once, instead of duplicate comparators or predicators for each general.
///
/// [length], ...
/// [_Qurator.increase], ...
///
///
abstract class _Qurator<I, N extends _Node1InsertableIterator<I, N>>
    extends _NodeQueueIterator<I, N>
    implements IIteratorPrevious<I>, IInsertable<I> {
  @override
  I get current =>
      _node._data ?? (throw StateError(ErrorMessages.iteratorNoElement));

  @override
  bool moveNext() => _moveNext(_node);

  @override
  bool movePrevious() => _movePrevious(_node);

  ///
  /// properties
  ///
  int get length =>
      NodeExtension.lengthing(_node, _Node1InsertableIterator.mapNext<I, N>);

  bool get isNotEmpty => _node._next != null;

  bool get isEmpty => _node._next == null;

  bool get isCleared => _node._data == null && _node._next == null;

  bool get isNotCleared => _node._data != null || _node._next != null;

  final int _invalidChecker;

  ///
  /// constructors
  ///
  _Qurator(
    super._node,
    super._moveNext,
    super._movePrevious,
    this._invalidChecker,
  ) : super();

  // _Qurator.increase(super._node, super._moveNext, super._movePrevious)
  //     : _invalidChecker = 1,
  //       super();
  //
  // _Qurator.decrease(super._node, super._moveNext, super._movePrevious)
  //     : _invalidChecker = -1,
  //       super();

  _Qurator.expired(super._node, this._invalidChecker) : super.expired();

  _Qurator.increaseExpired(super._node) : _invalidChecker = 1, super.expired();

  _Qurator.decreaseExpired(super._node) : _invalidChecker = -1, super.expired();
}

///
///
/// [QuratorCompared.ofExpired], ...
///
///
class QuratorCompared<C extends Comparable>
    extends _Qurator<C, _NodeQueueCompared<C>> {
  ///
  /// overrides
  ///
  @override
  void insert(C element) =>
      _node._next = _node._constructNext(
        element,
        (node) => node..insert(element, _invalidChecker),
      );

  @override
  void insertAll(Iterable<C> iterable) =>
      _node._next = _node._constructNextIterable(
        iterable,
        (node, element) => node..insert(element, _invalidChecker),
        (child) => child..insertAll(iterable, _invalidChecker),
      );

  ///
  /// constructor
  ///
  QuratorCompared.ofExpired(C value, [bool increase = true])
    : super.expired(
        _NodeQueueCompared(null, _NodeQueueCompared(value)),
        increase ? 1 : -1,
      );

  QuratorCompared.emptyExpired([bool increase = true])
    : super.expired(_NodeQueueCompared(), increase ? 1 : -1);

  QuratorCompared.increaseExpired(Iterable<C> iterable)
    : super.increaseExpired(_NodeQueueCompared.fromIterable(iterable, 1));

  QuratorCompared.decreaseExpired(Iterable<C> iterable)
    : super.decreaseExpired(_NodeQueueCompared.fromIterable(iterable, -1));
}

///
///
///
///
class Qurator<I> extends _Qurator<I, _NodeQueue<I>> {
  ///
  /// overrides
  ///
  @override
  void insert(I element) =>
      _node._next = _node._constructNext(
        element,
        (child) => child..insert(element, _invalidChecker, _comparator),
      );

  @override
  void insertAll(Iterable<I> iterable) =>
      _node._next = _node._constructNextIterable(
        iterable,
        (node, element) => node..insert(element, _invalidChecker, _comparator),
        (child) => child..insertAll(iterable),
      );

  ///
  /// properties
  ///
  final Comparator<I> _comparator;

  ///
  /// constructors
  ///
  Qurator.emptyExpired(Comparator<I> comparator, [bool increase = true])
    : _comparator = comparator,
      super.expired(_NodeQueue(), increase ? 1 : -1);

  Qurator.ofExpired(I value, Comparator<I> comparator, [bool increase = true])
    : _comparator = comparator,
      super.expired(_NodeQueue(null, _NodeQueue(value)), increase ? 1 : -1);

  Qurator.increaseExpired(Iterable<I> iterable, Comparator<I> comparator)
    : _comparator = comparator,
      super.increaseExpired(_NodeQueue.fromIterable(iterable, 1, comparator));

  Qurator.decreaseExpired(Iterable<I> iterable, Comparator<I> comparator)
    : _comparator = comparator,
      super.decreaseExpired(_NodeQueue.fromIterable(iterable, -1, comparator));
}

// class Queterable<I> with Iterable<I> {
//   final Iterable<I> _iterable;
//   final Comparator<I> _comparator;
//   final bool isIncrease;
//
//   const Queterable.increase(this._iterable, this._comparator)
//       : isIncrease = true;
//
//   const Queterable.decrease(this._iterable, this._comparator)
//       : isIncrease = false;
//
//   @override
//   Iterator<I> get iterator => isIncrease
//       ? Queterator.increase(_iterable, _comparator)
//       : Queterator.decrease(_iterable, _comparator);
// }

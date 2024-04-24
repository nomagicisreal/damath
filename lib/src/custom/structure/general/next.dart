///
///
/// [Node]
///   |##[_INodeOneDimension]
///   |##[_MixinNodeNew], ##[_MixinNodeHiddenNext], ##[_MixinNodeConstructNext]
///   |##[_MixinNodeNextIterator], ##[_MixinNodeNextIteratorPrevious]
///   |##[_MixinNodeInsertCurrent]
///   |
///   |##[_MixinNodeDirect]
///   |-[_NodeDirect]
///   |   |##[_MixinNodeDirectAppendable]
///   |   |-[NodeDirectAppendable]
///   |   |   |-[_ImplNodeDirectAppendableImmutable], [_ImplNodeDirectAppendableImmutableNullable]
///   |   |   |-[_ImplNodeDirectAppendableUnmodifiable], [_ImplNodeDirectAppendableUnmodifiableNullable]
///   |   |   |-[_ImplNodeDirectAppendableFixed], [_ImplNodeDirectAppendableFixedNullable]
///   |   |   |-[_ImplNodeDirectAppendableMutable], [_ImplNodeDirectAppendableMutableNullable]
///   |   |
///   |   |-[_NodeDirectInsertable]
///   |      |##[_MixinNodeDirectInsertableByInvalid], [_MixinNodeDirectInsertableByInvalidComparator]
///   |      |-[_NodeDirectInsertableIterator]                             |-[_Qurator]---[_NodeQueueIterator]--|
///   |      |   |-[_NodeQueueCompared]           >>     [QuratorCompared]-|                                    |
///   |      |   |-[_NodeQueue]                   >>             [Qurator]-|                                    |
///   |                                                                                                         |
///   |##[_MixinNodeBidirect]                                                                                   |
///   |-[_NodeBidirect]                                                                                         |
///       |##[_MixinNodeHiddenPrevious], ##[_MixinNodeConstructPrevious]                                        |
///       |##[_MixinNodeInsertCurrentPrevious]                                                                  |
///       |                                                                                                     |
///       |-[_NodeBidirectInsertable]                                                                           |
///           |##[_MixinNodeBidirectInsertableByInvalid], ##[_MixinNodeBidirectInsertableByInvalidComparator]   |
///           |                                                                                                 |
///           |##[_MixinNodeBidirectInsertableIterator]                                                         |
///           |-[_NodeBidirectInsertableIterator]                                              |-[_QuratorBinary]
///           |   |-[_NodeQueueComparedBidirect]      >>               [QuratorComparedBinary]-|
///           |   |-[_NodeQueueBidirect]              >>                       [QuratorBinary]-|
///
///
///
///
///
///
part of damath_structure;

///
///
/// [NodeConstructor]
///
///
typedef NodeConstructor<T, N extends Node<T, N>> = N Function(T data, N? next);

///
/// [next], ...(setter, getter)
/// [_string], ...(function)
///
abstract class Node<T, N extends Node<T, N>> extends Vertex<T> {
  ///
  /// setter, getter
  ///
  set next(N? node) => throw StateError(FErrorMessage.modifyImmutable);

  N? get next;

  ///
  /// function
  ///
  StringBuffer _string() => _INodeOneDimension.string<T, N>(
        this as N,
        _INodeOneDimension.mapToNext,
      );

  ///
  /// constructor
  ///
  const Node();

  ///
  /// static methods
  ///
}

///
/// [string], ...(static methods)
///
abstract class _INodeOneDimension<T, N extends Node<T, N>>
    implements Node<T, N>, IOperatableIndexableAssignable<T> {
  const _INodeOneDimension();

  ///
  /// static methods
  ///
  static StringBuffer string<T, N extends Node<T, N>>(
    N node,
    Mapper<N, N?> next, [
    String prefix = '',
  ]) {
    final buffer = StringBuffer();
    try {
      buffer.write('$prefix${node.data}');
    } on StateError catch (e) {
      if (e.message != FErrorMessage.vertexDataRequiredNotNull) rethrow;
      buffer.write('$prefix${null}');
    }
    return buffer
      ..writeIfNotNull(
        next(node).nullOrMap((n) => string(n, next, '--')),
      );
  }

  static N? mapToNext<T, N extends Node<T, N>>(N n) => n.next;

  // static N? mapToPrevious<T, N extends _NodeBidirect<T, N>>(N n) => n.next;

  ///
  /// getter
  ///
  Object get length;
}

//
mixin _MixinNodeNew<T, N extends Node<T, N>> on Node<T, N> {
  N _new(T data) => _construct(data, null);

  N _newIterable(
    Iterable<T> iterable,
    Companion<N, T> companion,
  ) =>
      iterable.iterator.inductInited(
        (data) => _construct(data, null),
        companion,
      );

  NodeConstructor<T, N> get _construct;
}

// hidden next
mixin _MixinNodeHiddenNext<T, N extends Node<T, N>> on Node<T, N> {
  @override
  set next(covariant N? node) =>
      throw StateError(FErrorMessage.nodeCannotAssignDirectly);

  @override
  N? get next => _next;

  set _next(covariant N? node) =>
      throw StateError(FErrorMessage.modifyImmutable);

  N? get _next;
}

// construct next
mixin _MixinNodeConstructNext<T, N extends Node<T, N>>
    on Node<T, N>, _MixinNodeNew<T, N> {
  N _constructNext(T data, Applier<N> applyNotNull) =>
      next == null ? _new(data) : applyNotNull(next!);

  N _constructNextIterable(
    Iterable<T> iterable,
    Companion<N, T> companionNull,
    Applier<N> applyNotNull,
  ) =>
      next == null
          ? _newIterable(iterable, companionNull)
          : applyNotNull(next!);
}

// insert current
mixin _MixinNodeInsertCurrent<T, N extends Node<T, N>>
    on
        _MixinVertexHidden<T>,
        _MixinNodeHiddenNext<T, N>,
        _MixinNodeNew<T, N>,
        _MixinNodeConstructNext<T, N>
    implements IInsertable<T> {
  void _insertCurrent(T data) {
    _next = _construct(this.data, _next);
    _data = data;
  }

  void _insertNext(T data, Applier<N> applyNotNull) =>
      _next = _constructNext(data, applyNotNull);
}

//
mixin _MixinNodeNextIterator<I, N extends _MixinNodeHiddenNext<I, N>>
    on _MixinVertexHidden<I>, _MixinNodeHiddenNext<I, N>, Iterator<I> {
  @override
  I get current => _data ?? (throw StateError(FErrorMessage.iteratorNoElement));

  @override
  bool moveNext() {
    final node = _next;
    if (node == null) {
      _data = null;
      return false;
    }
    _data = node.data;
    _next = node._next;
    return true;
  }
}

//
mixin _MixinNodeNextIteratorPrevious<I,
        N extends _NodeDirectInsertableIterator<I, N>>
    on _NodeDirectInsertable<I, N> implements IIteratorPrevious<I> {
  ///
  /// see also [_MixinNodeBidirectInsertableIterator.movePrevious]
  ///
  @override
  bool movePrevious() {
    final data = _data;
    if (data == null) return false;
    _data = null;
    _next = _construct(data, _next);
    return true;
  }

  @override
  int get length => _length(false);
}

///
///
///
///
/// direct
///
///
///
///

//
mixin _MixinNodeDirect<T, N extends _NodeDirect<T, N>> on Node<T, N>
    implements _INodeOneDimension<T, N> {
  ///
  ///
  /// overrides
  ///
  ///
  @override
  T operator [](int i) => _nodeOf(i).data;

  @override
  void operator []=(int i, T data) => _nodeOf(i).data = data;

  @override
  int get length => _length();

  ///
  /// function, getter
  ///
  int _length([bool includeCurrent = true]) {
    var i = includeCurrent ? 1 : 0;
    var n = next;
    if (n != null) {
      i++;
      try {
        for (; true; i++) {
          n = n?.next ?? (throw RangeError(FErrorMessage.indexOutOfBoundary));
        }
      } on RangeError catch (e) {
        if (e.message != FErrorMessage.indexOutOfBoundary) rethrow;
      }
    }
    return i;
  }

  Node<T, N> _nodeOf(int i) {
    Node<T, N> node = this;
    for (var j = 0; j < i; j++) {
      node = node.next ?? (throw RangeError(FErrorMessage.indexOutOfBoundary));
    }
    return node;
  }
}

///
///
/// [toString], ...(overrides)
///
///
sealed class _NodeDirect<T, N extends _NodeDirect<T, N>> extends Node<T, N>
    with _MixinNodeDirect<T, N> {
  ///
  /// overrides
  ///
  @override
  String toString() => 'Node: ${_string()}';

  ///
  /// constructor
  ///
  const _NodeDirect();

// generate
// factory _NodeDirect.generate(
//   int length,
//   Generator<T> generator,
//   NodeConstructor<T, N> construct,
// ) {
//   if (length.isNegative) throw RangeError(FErrorMessage.generateByNegative);
//   N? current;
//   for (var i = length - 1; i > -1; i--) {
//     current = construct(generator(i), current);
//   }
//   return current!;
// }
}

///
///
///
/// [_MixinNodeDirectAppendable]
/// [NodeDirectAppendable]
///   |-[_ImplNodeDirectAppendableImmutable], [_ImplNodeDirectAppendableImmutableNullable]
///   |-[_ImplNodeDirectAppendableUnmodifiable], [_ImplNodeDirectAppendableUnmodifiableNullable]
///   |-[_ImplNodeDirectAppendableFixed], [_ImplNodeDirectAppendableFixedNullable]
///   |-[_ImplNodeDirectAppendableMutable], [_ImplNodeDirectAppendableMutableNullable]
///
///
///
///

///
/// [append]
/// [appendAll]
/// [appendNode]
/// [replaceBy]
///
mixin _MixinNodeDirectAppendable<T>
    on _MixinNodeConstructNext<T, NodeDirectAppendable<T>> {
  ///
  /// functions
  ///
  void append(T data) {
    var child = next;
    if (child == null) {
      this.data = data;
      return;
    }
    while (child != null) {
      final next = child.next;
      if (next == null) break;
      child = next;
    }
    child!.data = data;
  }

  void appendAll(Iterable<T> iterable) => next = _constructNextIterable(
        iterable,
        (node, data) => node..append(data),
        (child) => child..appendAll(iterable),
      );

  void appendNode(NodeDirectAppendable<T> node) {
    NodeDirectAppendable<T>? child = next;
    while (child != null) {
      child = child.next;
    }
    child = node;
  }

  ///
  /// replace by
  ///
  void replaceBy(T data) => next = _construct(data, next);
}

///
///
/// [_construct], ...(overrides)
/// [append], ...(function)
/// [NodeDirectAppendable.immutable], ...(factories)
///
abstract class NodeDirectAppendable<T>
    extends _NodeDirect<T, NodeDirectAppendable<T>>
    with
        _MixinNodeNew<T, NodeDirectAppendable<T>>,
        _MixinNodeConstructNext<T, NodeDirectAppendable<T>>,
        _MixinNodeDirectAppendable<T> {
  ///
  /// overrides
  ///
  @override
  final NodeConstructor<T, NodeDirectAppendable<T>> _construct;

  ///
  /// constructor
  ///
  const NodeDirectAppendable(this._construct);

  ///
  /// factories
  ///
  factory NodeDirectAppendable.immutable(T data,
      [NodeDirectAppendable<T>? next]) = _ImplNodeDirectAppendableImmutable<T>;

  factory NodeDirectAppendable.unmodifiable(T data,
          [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableUnmodifiable<T>;

  factory NodeDirectAppendable.fixed(T data, [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableFixed<T>;

  factory NodeDirectAppendable.mutable(T data,
      [NodeDirectAppendable<T>? next]) = _ImplNodeDirectAppendableMutable<T>;

  // nullable
  factory NodeDirectAppendable.immutableNullable(T? data,
          [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableImmutableNullable<T>;

  factory NodeDirectAppendable.unmodifiableNullable(T? data,
          [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableUnmodifiableNullable<T>;

  factory NodeDirectAppendable.fixedNullable(T? data,
          [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableFixedNullable<T>;

  factory NodeDirectAppendable.mutableNullable(T? data,
          [NodeDirectAppendable<T>? next]) =
      _ImplNodeDirectAppendableMutableNullable<T>;

  factory NodeDirectAppendable.generate(
    int length,
    Generator<T> generator,
    NodeConstructor<T, NodeDirectAppendable<T>> construct,
  ) {
    NodeDirectAppendable<T>? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
  }
}

//
class _ImplNodeDirectAppendableImmutable<T> extends NodeDirectAppendable<T> {
  @override
  final T data;
  @override
  final NodeDirectAppendable<T>? next;

  const _ImplNodeDirectAppendableImmutable(this.data, [this.next])
      : super(NodeDirectAppendable.immutable);
}

//
class _ImplNodeDirectAppendableImmutableNullable<T>
    extends NodeDirectAppendable<T> with _MixinVertexHidden<T> {
  @override
  final T? _data;
  @override
  final NodeDirectAppendable<T>? next;

  const _ImplNodeDirectAppendableImmutableNullable(this._data, [this.next])
      : super(NodeDirectAppendable.immutableNullable);
}

//
class _ImplNodeDirectAppendableUnmodifiable<T> extends NodeDirectAppendable<T> {
  @override
  final T data;
  @override
  NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableUnmodifiable(this.data, [this.next])
      : super(NodeDirectAppendable.unmodifiable);
}

//
class _ImplNodeDirectAppendableUnmodifiableNullable<T>
    extends NodeDirectAppendable<T> with _MixinVertexHidden<T> {
  @override
  final T? _data;
  @override
  NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableUnmodifiableNullable(this._data, [this.next])
      : super(NodeDirectAppendable.unmodifiableNullable);
}

//
class _ImplNodeDirectAppendableFixed<T> extends NodeDirectAppendable<T> {
  @override
  T data;
  @override
  final NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableFixed(this.data, [this.next])
      : super(NodeDirectAppendable.fixed);
}

//
class _ImplNodeDirectAppendableFixedNullable<T> extends NodeDirectAppendable<T>
    with _MixinVertexHidden<T> {
  @override
  T? _data;
  @override
  final NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableFixedNullable(this._data, [this.next])
      : super(NodeDirectAppendable.fixedNullable);
}

//
class _ImplNodeDirectAppendableMutable<T> extends NodeDirectAppendable<T> {
  @override
  T data;
  @override
  NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableMutable(this.data, [this.next])
      : super(NodeDirectAppendable.mutable);
}

//
class _ImplNodeDirectAppendableMutableNullable<T>
    extends NodeDirectAppendable<T> with _MixinVertexHidden<T> {
  @override
  T? _data;

  @override
  NodeDirectAppendable<T>? next;

  _ImplNodeDirectAppendableMutableNullable(this._data, [this.next])
      : super(NodeDirectAppendable.mutableNullable);
}

///
///
///
///
/// [_NodeDirectInsertable]
///   |##[_MixinNodeDirectInsertableByInvalid]
///   |##[_MixinNodeDirectInsertableByInvalidComparator]
///   |
///   |##[_MixinNodeNextIteratorPrevious]
///   |-[_NodeDirectInsertableIterator]                               |-[_Qurator]
///   |   |-[_NodeQueueCompared]     >>     [QuratorCompared]-|
///   |   |-[_NodeQueue]             >>             [Qurator]-|
///
///
///
///

///
///
///
abstract class _NodeDirectInsertable<T, N extends _NodeDirectInsertable<T, N>>
    extends _NodeDirect<T, N>
    with
        _MixinVertexHidden<T>,
        _MixinNodeHiddenNext<T, N>,
        _MixinNodeNew<T, N>,
        _MixinNodeConstructNext<T, N>,
        _MixinNodeInsertCurrent<T, N> {
  ///
  /// constructor
  ///
  const _NodeDirectInsertable();
}

//
mixin _MixinNodeDirectInsertableByInvalid<C extends Comparable,
        N extends _MixinNodeDirectInsertableByInvalid<C, N>>
    on _NodeDirectInsertable<C, N> {
  @override
  void insert(C element, [int? invalid]) => element.compareTo(data) == invalid
      ? _insertNext(element, (node) => node..insert(element, invalid!))
      : _insertCurrent(element);

  @override
  void insertAll(Iterable<C> iterable, [int? invalid]) =>
      iterable.iterator.consumeAll((element) => insert(element, invalid));
}

//
mixin _MixinNodeDirectInsertableByInvalidComparator<T,
        N extends _MixinNodeDirectInsertableByInvalidComparator<T, N>>
    on _NodeDirectInsertable<T, N> {
  @override
  void insert(T element, [int? invalid, Comparator<T>? comparator]) =>
      comparator!(element, data) == invalid
          ? _insertNext(
              element,
              (node) => node..insert(element, invalid!, comparator),
            )
          : _insertCurrent(element);

  @override
  void insertAll(Iterable<T> iterable,
          [int? invalid, Comparator<T>? comparator]) =>
      iterable.iterator
          .consumeAll((element) => insert(element, invalid, comparator));
}

///
///
///
///
///
/// [_NodeDirectInsertableIterator]
///     |-[_NodeQueueCompared]
///     |-[_NodeQueue]
///
///
///
///
///
abstract class _NodeDirectInsertableIterator<I,
        N extends _NodeDirectInsertableIterator<I, N>>
    extends _NodeDirectInsertable<I, N>
    with _MixinNodeNextIteratorPrevious<I, N>, _MixinNodeNextIterator<I, N> {
  ///
  /// overrides
  ///
  @override
  I? _data;

  @override
  N? _next;

  ///
  /// constructor
  ///
  _NodeDirectInsertableIterator(this._data, [this._next]);

  _NodeDirectInsertableIterator._fromIterable(
    Iterable<I> iterable,
    Mapper<I, N> initialize,
    Companion<N, I> reducing,
  ) : _next = iterable.iterator.inductInited<N>(initialize, reducing);
}

///
///
/// [_construct], ...(overrides)
/// [_NodeQueueCompared.fromIterable], ...(constructors)
///
///
class _NodeQueueCompared<C extends Comparable>
    extends _NodeDirectInsertableIterator<C, _NodeQueueCompared<C>>
    with _MixinNodeDirectInsertableByInvalid<C, _NodeQueueCompared<C>> {
  ///
  /// overrides
  ///
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
class _NodeQueue<I> extends _NodeDirectInsertableIterator<I, _NodeQueue<I>>
    with _MixinNodeDirectInsertableByInvalidComparator<I, _NodeQueue<I>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructor<I, _NodeQueue<I>> get _construct =>
      (data, next) => _NodeQueue(data, next);

  ///
  /// constructors
  ///
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
///
///
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
///
///

///
///
///
abstract class _NodeQueueIterator<I, N extends _MixinNodeHiddenNext<I, N>>
    implements IIteratorPrevious<I>, IInsertable<I> {
  @override
  String toString() => 'NodeQueue: ${_node._next?._string()}';

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
  /// static methods
  ///
  static bool movingNext<I>(IIteratorPrevious node) => node.moveNext();

  static bool movingPrevious<I>(IIteratorPrevious node) => node.movePrevious();
}

///
///
/// [_Qurator] contains subclass of [_NodeDirectInsertableIterator] to instruct how to prioritize data.
/// it holds necessary comparison data once, instead of duplicate comparators or predicators for each general.
///
/// [length], ...
/// [_Qurator.increase], ...
///
///
abstract class _Qurator<I, N extends _NodeDirectInsertableIterator<I, N>>
    extends _NodeQueueIterator<I, N>
    implements IIteratorPrevious<I>, IInsertable<I> {
  ///
  /// overrides
  ///
  @override
  I get current =>
      _node._data ?? (throw StateError(FErrorMessage.iteratorNoElement));

  @override
  bool moveNext() => _moveNext(_node);

  @override
  bool movePrevious() => _movePrevious(_node);

  ///
  /// properties
  ///
  int get length => _node.length;

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

  _Qurator.increaseExpired(super._node)
      : _invalidChecker = 1,
        super.expired();

  _Qurator.decreaseExpired(super._node)
      : _invalidChecker = -1,
        super.expired();
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
  void insert(C element) => _node._next = _node._constructNext(
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
  void insert(I element) => _node._next = _node._constructNext(
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
        super.decreaseExpired(
            _NodeQueue.fromIterable(iterable, -1, comparator));
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

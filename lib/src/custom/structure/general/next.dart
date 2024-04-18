///
///
/// this file contains:
/// [Node]
///   |##[_INodeOneDimension]
///   |##[_MixinNodeHiddenNext], ##[_MixinNodeNew], ##[_MixinNodeConstructNext]
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
///   |   |##[_MixinNodeDirectInsertable]
///   |   |-[_NodeDirectInsertable]
///   |      |##[_MixinNodeDirectInsertableByInvalid], [_MixinNodeDirectInsertableByInvalidComparator]
///   |      |
///   |      |##[_MixinNodeDirectInsertableIterator]
///   |      |-[_NodeDirectInsertableIterator]                                    |-[_QueueIterator]
///   |      |   |-[_NodeQueueIteratorCompared]     >>     [QueteratorCompared]-|
///   |      |   |-[_NodeQueueIterator]             >>             [Qurator]-|
///   |      ...
///   |
///   |##[_MixinNodeBidirect]
///   |-[_NodeBidirect] ...
///   |
///   |
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
///
///
///
///
///

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

  static N? mapToPrevious<T, N extends _NodeBidirect<T, N>>(N n) => n.next;

  ///
  /// getter
  ///
  int get length;
}

//
mixin _MixinNodeHiddenNext<T, N extends Node<T, N>> on Node<T, N> {
  @override
  set next(covariant N? node) =>
      throw StateError(FErrorMessage.nodeCannotAssignDirectly);

  @override
  N? get next => _child;

  set _child(covariant N? node) =>
      throw StateError(FErrorMessage.modifyImmutable);

  N? get _child;
}

//
mixin _MixinNodeNew<T, N extends Node<T, N>> on Node<T, N> {
  N _new(T data) => _construct(data, null);

  N _newIterable(
    Iterable<T> iterable,
    Companion<N, T> companion,
  ) =>
      iterable.iterator.reduceToInitialized(
        (data) => _construct(data, null),
        companion,
      );

  NodeConstructor<T, N> get _construct;
}

//
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
  factory _NodeDirect.generate(
    int length,
    Generator<T> generator,
    NodeConstructor<T, N> construct,
  ) {
    if (length.isNegative) throw RangeError(FErrorMessage.generateByNegative);
    N? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
  }
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
///
/// insertable
///
///
///
///
///
///

//
mixin _MixinNodeDirectInsertable<T, N extends _NodeDirectInsertable<T, N>>
    on
        _MixinVertexHidden<T>,
        _MixinNodeHiddenNext<T, N>,
        _MixinNodeConstructNext<T, N>
    implements IInsertable<T> {
  ///
  /// overrides
  ///
  @override
  void insert(T element);

  @override
  void insertAll(Iterable<T> iterable) => iterable.iterator.consumeAll(insert);

  ///
  /// functions
  ///
  void _insertCurrent(T data) {
    _child = _construct(this.data, _child);
    _data = data;
  }

// void _insertNext(T element) => _child = _constructChild(
//       data,
//       (general) => general..insert(element),
//     );
}

///
///
///
///
/// [_NodeDirectInsertable]
///   |##[_MixinNodeDirectInsertableByInvalid]
///   |##[_MixinNodeDirectInsertableByInvalidComparator]
///   |
///   |##[_MixinNodeDirectInsertableIterator]
///   |-[_NodeDirectInsertableIterator]                               |-[_QueueIterator]
///   |   |-[_NodeQueueIteratorCompared]     >>     [QueteratorCompared]-|
///   |   |-[_NodeQueueIterator]             >>             [Qurator]-|
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
        _MixinNodeDirectInsertable<T, N> {
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
  void insert(C element, [int? invalid]) => data.compareTo(element) == invalid
      ? _insertCurrent(element)
      : _insertNext(element, invalid);

  @override
  void insertAll(Iterable<C> iterable, [int? invalid]) =>
      iterable.iterator.consumeAll((element) => insert(element, invalid));

  void _insertNext(C element, [int? invalid]) => _child = _constructNext(
        element,
        (node) => node..insert(element, invalid!),
      );
}

//
mixin _MixinNodeDirectInsertableByInvalidComparator<T,
        N extends _MixinNodeDirectInsertableByInvalidComparator<T, N>>
    on _NodeDirectInsertable<T, N> {
  @override
  void insert(T element, [int? invalid, Comparator<T>? comparator]) =>
      comparator!(data, element) == invalid
          ? _insertCurrent(element)
          : _insertNext(element, invalid, comparator);

  @override
  void insertAll(Iterable<T> iterable,
          [int? invalid, Comparator<T>? comparator]) =>
      iterable.iterator
          .consumeAll((element) => insert(element, invalid, comparator));

  void _insertNext(T element, [int? invalid, Comparator<T>? comparator]) =>
      _child = _constructNext(
        element,
        (node) => node..insert(element, invalid!, comparator!),
      );
}

//
mixin _MixinNodeDirectInsertableIterator<I,
        N extends _NodeDirectInsertableIterator<I, N>>
    on _NodeDirectInsertable<I, N> implements IIteratorPrevious<I> {
  ///
  /// overrides
  ///
  @override
  I get current => _data ?? (throw StateError(FErrorMessage.iteratorNoElement));

  @override
  bool moveNext() {
    final node = _child;
    if (node == null) {
      _data = null;
      return false;
    }
    _data = node.data;
    _child = node._child;
    return true;
  }

  @override
  bool movePrevious() {
    final data = _data;
    if (data == null) return false;
    _data = null;
    _child = _construct(data, _child);
    return true;
  }

  @override
  int get length => _length(false);
}

///
///
///
///
///
/// [_NodeDirectInsertableIterator]
///     |-[_NodeQueueIteratorCompared]
///     |-[_NodeQueueIterator]
///
///
///
///
///

///
///
///
abstract class _NodeDirectInsertableIterator<I,
        N extends _NodeDirectInsertableIterator<I, N>>
    extends _NodeDirectInsertable<I, N>
    with _MixinNodeDirectInsertableIterator<I, N> {
  ///
  /// overrides
  ///
  @override
  I? _data;

  @override
  N? _child;

  ///
  /// constructor
  ///
  _NodeDirectInsertableIterator(this._data, [this._child]);

  _NodeDirectInsertableIterator._fromIterable(
    Iterable<I> iterable,
    Mapper<I, N> initialize,
    Companion<N, I> reducing,
  ) : _child = iterable.iterator.reduceToInitialized<N>(initialize, reducing);
}

///
///
/// [_construct], ...(overrides)
/// [_NodeIteratorComparable.fromIterable], ...(constructors)
///
///
class _NodeQueueIteratorCompared<C extends Comparable>
    extends _NodeDirectInsertableIterator<C, _NodeQueueIteratorCompared<C>>
    with _MixinNodeDirectInsertableByInvalid<C, _NodeQueueIteratorCompared<C>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructor<C, _NodeQueueIteratorCompared<C>> get _construct =>
      (data, next) => _NodeQueueIteratorCompared(data, next);

  ///
  /// constructors
  ///
  _NodeQueueIteratorCompared([super.data, super._next]);

  _NodeQueueIteratorCompared._init(C super._data);

  _NodeQueueIteratorCompared.fromIterable(Iterable<C> iterable, int invalid)
      : super._fromIterable(
          iterable,
          _NodeQueueIteratorCompared<C>._init,
          (node, element) => node..insert(element, invalid),
        );
}

///
///
/// [_construct], ...(overrides)
/// [_NodeQueueIterator.fromIterable], ...(constructors)
///
///
class _NodeQueueIterator<I>
    extends _NodeDirectInsertableIterator<I, _NodeQueueIterator<I>>
    with
        _MixinNodeDirectInsertableByInvalidComparator<I,
            _NodeQueueIterator<I>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructor<I, _NodeQueueIterator<I>> get _construct =>
      (data, next) => _NodeQueueIterator(data, next);

  ///
  /// constructors
  ///
  _NodeQueueIterator([super._data, super._next]);

  _NodeQueueIterator._init(I super._data);

  _NodeQueueIterator.fromIterable(
    Iterable<I> iterable,
    int invalid,
    Comparator<I> comparator,
  ) : super._fromIterable(
          iterable,
          _NodeQueueIterator<I>._init,
          (node, element) => node..insert(element, invalid, comparator),
        );
}

///
///
///
///
///
///
/// [_QueueIterator]
///     |-[QueteratorCompared]
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
/// [_QueueIterator] contains subclass of [_NodeDirectInsertableIterator] to instruct how to prioritize data.
/// it holds necessary comparison data once, instead of duplicate comparators or predicators for each general.
///
/// to assign predicator for each general, see [_NodeOrdable], [NodeCompared], [NodeLined]
/// to assign comparator for each general, see [NodeTreeChained]
/// to iterate though nodes on each general, see [NodeQueterator]
///
///
abstract class _QueueIterator<I, N extends _NodeDirectInsertableIterator<I, N>>
    implements IIteratorPrevious<I>, IInsertable<I> {
  ///
  /// overrides
  ///
  @override
  String toString() => 'Queue: ${_node._child?._string()}';

  @override
  I get current =>
      _node._data ?? (throw StateError(FErrorMessage.iteratorNoElement));

  @override
  bool moveNext() => _node.moveNext();

  @override
  bool movePrevious() => _node.movePrevious();

  ///
  /// properties
  ///
  int get length => _node.length;

  bool get isNotEmpty => _node._child != null;

  bool get isEmpty => _node._child == null;

  bool get isCleared => _node._data == null && _node._child == null;

  bool get isNotCleared => _node._data != null || _node._child != null;

  final int _invalidChecker;
  final N _node;

  ///
  /// constructors
  ///
  const _QueueIterator(this._node, this._invalidChecker);

  const _QueueIterator.increase(this._node) : _invalidChecker = 1;

  const _QueueIterator.decrease(this._node) : _invalidChecker = -1;
}

///
///
///
///
class QueteratorCompared<C extends Comparable>
    extends _QueueIterator<C, _NodeQueueIteratorCompared<C>> {
  ///
  /// overrides
  ///
  @override
  void insert(C element) => _node._child = _node._constructNext(
        element,
        (node) => node..insert(element, _invalidChecker),
      );

  @override
  void insertAll(Iterable<C> iterable) =>
      _node._child = _node._constructNextIterable(
        iterable,
        (node, element) => node..insert(element, _invalidChecker),
        (child) => child..insertAll(iterable, _invalidChecker),
      );

  ///
  /// constructor
  ///
  QueteratorCompared.increase(Iterable<C> iterable)
      : super(_NodeQueueIteratorCompared.fromIterable(iterable, 1), 1);

  QueteratorCompared.decrease(Iterable<C> iterable)
      : super(_NodeQueueIteratorCompared.fromIterable(iterable, -1), -1);

  QueteratorCompared.empty([bool increase = true])
      : super(_NodeQueueIteratorCompared(), increase ? 1 : -1);

  QueteratorCompared.of(C value, [bool increase = true])
      : super(
          _NodeQueueIteratorCompared(null, _NodeQueueIteratorCompared(value)),
          increase ? 1 : -1,
        );
}

///
///
///
///
class Qurator<I> extends _QueueIterator<I, _NodeQueueIterator<I>> {
  ///
  /// overrides
  ///
  @override
  void insert(I element) => _node._child = _node._constructNext(
        element,
        (child) => child..insert(element, _invalidChecker, _comparator),
      );

  @override
  void insertAll(Iterable<I> iterable) =>
      _node._child = _node._constructNextIterable(
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
  Qurator.increase(Iterable<I> iterable, Comparator<I> comparator)
      : _comparator = comparator,
        super.increase(
            _NodeQueueIterator.fromIterable(iterable, 1, comparator));

  Qurator.decrease(Iterable<I> iterable, Comparator<I> comparator)
      : _comparator = comparator,
        super.decrease(
            _NodeQueueIterator.fromIterable(iterable, -1, comparator));

  Qurator.empty(Comparator<I> comparator, [bool increase = true])
      : _comparator = comparator,
        super(_NodeQueueIterator(), increase ? 1 : -1);

  Qurator.of(I value, Comparator<I> comparator, [bool increase = true])
      : _comparator = comparator,
        super(_NodeQueueIterator(null, _NodeQueueIterator(value)),
            increase ? 1 : -1);
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

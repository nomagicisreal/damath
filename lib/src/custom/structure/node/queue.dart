///
///
/// this file contains:
/// [Node]
///   |
///   |##[_MixinNodeNext]
///   |-[NodeNext]
///       |##[_MixinNodeNextHidden]
///       |##[_MixinNodeNextConstruct]
///       |
///       |-[_ImplNodeImmutable], [_ImplNodeImmutableNullable]
///       |-[_ImplNodeUnmodifiable], [_ImplNodeUnmodifiableNullable]
///       |-[_ImplNodeFixed], [_ImplNodeFixedNullable]
///       |-[_ImplNodeMutable], [_ImplNodeMutableNullable]
///       |
///       |##[_MixinNodeAppendable]
///       |-[NodeAppendable]
///       |   |-[_ImplNodeAppendableImmutable], [_ImplNodeAppendableImmutableNullable]
///       |   |-[_ImplNodeAppendableUnmodifiable], [_ImplNodeAppendableUnmodifiableNullable]
///       |   |-[_ImplNodeAppendableFixed], [_ImplNodeAppendableFixedNullable]
///       |   |-[_ImplNodeAppendableMutable], [_ImplNodeAppendableMutableNullable]
///       |
///       |##[_MixinNodeNextInsertable]
///       |-[_NodeNextInsertable]
///          |##[_MixinNodeNextInsertableByInvalid]
///          |##[_MixinNodeNextInsertableByInvalidComparator]
///          |##[_MixinNodeNextInsertableByInvalidForIterator]
///          |##[_MixinNodeNextInsertableByInvalidComparatorForIterator]
///          |
///          |##[_MixinNodeNextInsertableIterator]
///          |-[_NodeNextInsertableIterator]                                    |-[_QueueIterator]
///          |   |-[_NodeQueueIteratorCompared]     >>     [QueteratorCompared]-|
///          |   |-[_NodeQueueIterator]             >>             [Queterator]-|
///          |
///          ...
///
///
part of damath_structure;

///
///
/// [NodeConstructorNext]
///
///
typedef NodeConstructorNext<T, N extends NodeNext<T>> = N Function(
    T data, N? next);

///
///
///
///
///
///

///
/// [child], ...(setter, getter)
/// [_toStringLinked], ...(function)
///
abstract class Node<T, N extends Node<T, N>> extends Vertex<T> {
  ///
  /// setter, getter
  ///
  set child(N? node) => throw StateError(KErrorMessage.modifyImmutable);

  N? get child;

  ///
  /// function
  ///
  StringBuffer _toStringLinked([String prefix = '']) {
    final buffer = StringBuffer();
    try {
      buffer.write('$prefix$data');
    } on StateError catch (e) {
      if (e.message != KErrorMessage.vertexDataRequiredNotNull) rethrow;
      buffer.write('$prefix${null}');
    }
    return buffer..writeIfNotNull(child?._toStringLinked('--'));
  }

  ///
  /// constructor
  ///
  const Node();
}

//
mixin _MixinNodeNext<T> on Node<T, NodeNext<T>>
    implements IOperatableIndexable<T> {
  ///
  ///
  /// overrides
  ///
  ///
  @override
  String toString() => 'Node: ${_toStringLinked()}';

  @override
  T operator [](int index) {
    Node<T, NodeNext<T>> node = this;
    for (var i = 0; i < index; i++) {
      node = node.child ?? (throw RangeError(KErrorMessage.indexOutOfBoundary));
    }
    return node.data;
  }

  ///
  /// function, getter
  ///
  int _length([bool includeCurrent = true]) {
    var i = includeCurrent ? 1 : 0;
    var n = child;
    if (n != null) {
      i++;
      try {
        for (; true; i++) {
          n = n?.child ?? (throw RangeError(KErrorMessage.indexOutOfBoundary));
        }
      } on RangeError catch (e) {
        if (e.message != KErrorMessage.indexOutOfBoundary) rethrow;
      }
    }
    return i;
  }

  int get length => _length();
}

///
///
/// [toString], ...(overrides)
/// [_length], ...(function, getter)
/// [NodeNext.immutable], ...(factories)
///
///
sealed class NodeNext<T> extends Node<T, NodeNext<T>> with _MixinNodeNext<T> {
  ///
  /// constructor, factories
  ///
  const NodeNext();

  //
  const factory NodeNext.immutable(T data, [NodeNext<T>? next]) =
      _ImplNodeImmutable<T>;

  factory NodeNext.unmodifiable(T data, [NodeNext<T>? next]) =
      _ImplNodeUnmodifiable<T>;

  factory NodeNext.mutable(T data, [NodeNext<T>? next]) = _ImplNodeMutable<T>;

  factory NodeNext.fixed(T data, [NodeNext<T>? next]) = _ImplNodeFixed<T>;

  // nullable
  const factory NodeNext.immutableNullable(T? data, [NodeNext<T>? next]) =
      _ImplNodeImmutableNullable<T>;

  factory NodeNext.unmodifiableNullable(T? data, [NodeNext<T>? next]) =
      _ImplNodeUnmodifiableNullable<T>;

  factory NodeNext.mutableNullable(T? data, [NodeNext<T>? next]) =
      _ImplNodeMutableNullable<T>;

  factory NodeNext.fixedNullable(T? data, [NodeNext<T>? next]) =
      _ImplNodeFixedNullable<T>;

  // generate
  factory NodeNext.generate(
    int length,
    Generator<T> generator,
    NodeConstructorNext<T, NodeNext<T>> construct,
  ) {
    if (length.isNegative) throw RangeError(KErrorMessage.generateByNegative);
    NodeNext<T>? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
  }
}

//
mixin _MixinNodeNextHidden<T, N extends NodeNext<T>> on NodeNext<T> {
  @override
  set child(covariant N? node) =>
      throw StateError(KErrorMessage.nodeNextCannotAssignDirectly);

  @override
  N? get child => _child;

  set _child(covariant N? node) =>
      throw StateError(KErrorMessage.modifyImmutable);

  N? get _child;
}

//
mixin _MixinNodeNextConstruct<T, N extends NodeNext<T>> on NodeNext<T> {
  @override
  set child(covariant N? node);

  @override
  N? get child;

  N _constructChild(T data, Applier<N> applyNotNull) =>
      child == null ? _construct(data, null) : applyNotNull(child!);

  N _constructIterable(Iterable<T> iterable, Companion<N, T> companionNull) =>
      iterable.iterator.reduceToInitialized(
        (data) => _construct(data, null),
        companionNull,
      );

  N _constructChildren(
    Iterable<T> iterable,
    Companion<N, T> companionNull,
    Applier<N> applyNotNull,
  ) =>
      child == null
          ? _constructIterable(iterable, companionNull)
          : applyNotNull(child!);

  NodeConstructorNext<T, N> get _construct;
}

//
class _ImplNodeImmutable<T> extends NodeNext<T> {
  @override
  final T data;

  @override
  final NodeNext<T>? child;

  const _ImplNodeImmutable(this.data, [this.child]);
}

//
class _ImplNodeImmutableNullable<T> extends NodeNext<T>
    with _MixinVertexHidden<T> {
  @override
  final T? _data;

  @override
  final NodeNext<T>? child;

  const _ImplNodeImmutableNullable([this._data, this.child]);
}

//
class _ImplNodeUnmodifiable<T> extends NodeNext<T> {
  @override
  final T data;
  @override
  NodeNext<T>? child;

  _ImplNodeUnmodifiable(this.data, [this.child]);
}

//
class _ImplNodeUnmodifiableNullable<T> extends NodeNext<T>
    with _MixinVertexHidden<T> {
  @override
  final T? _data;

  @override
  NodeNext<T>? child;

  _ImplNodeUnmodifiableNullable([this._data, this.child]);
}

//
class _ImplNodeFixed<T> extends NodeNext<T> {
  @override
  T data;
  @override
  final NodeNext<T>? child;

  _ImplNodeFixed(this.data, [this.child]);
}

//
class _ImplNodeFixedNullable<T> extends NodeNext<T> with _MixinVertexHidden<T> {
  @override
  T? _data;

  @override
  final NodeNext<T>? child;

  _ImplNodeFixedNullable([this._data, this.child]);
}

//
class _ImplNodeMutable<T> extends NodeNext<T> {
  @override
  T data;

  @override
  NodeNext<T>? child;

  _ImplNodeMutable(this.data, [this.child]);
}

//
class _ImplNodeMutableNullable<T> extends NodeNext<T>
    with _MixinVertexHidden<T> {
  @override
  T? _data;

  @override
  NodeNext<T>? child;

  _ImplNodeMutableNullable([this._data, this.child]);
}

///
///
///
/// [NodeAppendable]
///   |-[_ImplNodeAppendableImmutable], [_ImplNodeAppendableImmutableNullable]
///   |-[_ImplNodeAppendableUnmodifiable], [_ImplNodeAppendableUnmodifiableNullable]
///   |-[_ImplNodeAppendableFixed], [_ImplNodeAppendableFixedNullable]
///   |-[_ImplNodeAppendableMutable], [_ImplNodeAppendableMutableNullable]
///
///
///
///

mixin _MixinNodeAppendable<T> on _MixinNodeNextConstruct<T, NodeAppendable<T>> {
  void append(T data) {
    var child = this.child;
    if (child == null) {
      this.data = data;
      return;
    }
    while (child != null) {
      final next = child.child;
      if (next == null) break;
      child = next;
    }
    child!.data = data;
  }

  void appendAll(Iterable<T> iterable) => child = _constructChildren(
        iterable,
        (node, data) => node..append(data),
        (child) => child..appendAll(iterable),
      );

  ///
  /// append node
  ///
  void appendNode(NodeAppendable<T> node) {
    NodeAppendable<T>? child = this.child;
    while (child != null) {
      child = child.child;
    }
    child = node;
  }

  ///
  /// replace by
  ///
  void replaceBy(T data) => child = _construct(data, child);
}

///
///
/// [_construct], ...(overrides)
/// [append], ...(function)
/// [NodeAppendable.immutable], ...(factories)
///
abstract class NodeAppendable<T> extends NodeNext<T>
    with
        _MixinNodeNextConstruct<T, NodeAppendable<T>>,
        _MixinNodeAppendable<T> {
  ///
  /// overrides
  ///
  @override
  final NodeConstructorNext<T, NodeAppendable<T>> _construct;

  ///
  /// constructor
  ///
  const NodeAppendable(this._construct);

  ///
  /// factories
  ///
  factory NodeAppendable.immutable(T data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableImmutable<T>;

  factory NodeAppendable.unmodifiable(T data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableUnmodifiable<T>;

  factory NodeAppendable.fixed(T data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableFixed<T>;

  factory NodeAppendable.mutable(T data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableMutable<T>;

  // nullable
  factory NodeAppendable.immutableNullable(T? data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableImmutableNullable<T>;

  factory NodeAppendable.unmodifiableNullable(T? data,
      [NodeAppendable<T>? next]) = _ImplNodeAppendableUnmodifiableNullable<T>;

  factory NodeAppendable.fixedNullable(T? data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableFixedNullable<T>;

  factory NodeAppendable.mutableNullable(T? data, [NodeAppendable<T>? next]) =
      _ImplNodeAppendableMutableNullable<T>;

  factory NodeAppendable.generate(
    int length,
    Generator<T> generator,
    NodeConstructorNext<T, NodeAppendable<T>> construct,
  ) {
    NodeAppendable<T>? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
  }
}

//
class _ImplNodeAppendableImmutable<T> extends NodeAppendable<T> {
  @override
  final T data;
  @override
  final NodeAppendable<T>? child;

  const _ImplNodeAppendableImmutable(this.data, [this.child])
      : super(NodeAppendable.immutable);
}

//
class _ImplNodeAppendableImmutableNullable<T> extends NodeAppendable<T>
    with _MixinVertexHidden<T> {
  @override
  final T? _data;
  @override
  final NodeAppendable<T>? child;

  const _ImplNodeAppendableImmutableNullable(this._data, [this.child])
      : super(NodeAppendable.immutableNullable);
}

//
class _ImplNodeAppendableUnmodifiable<T> extends NodeAppendable<T> {
  @override
  final T data;
  @override
  NodeAppendable<T>? child;

  _ImplNodeAppendableUnmodifiable(this.data, [this.child])
      : super(NodeAppendable.unmodifiable);
}

//
class _ImplNodeAppendableUnmodifiableNullable<T> extends NodeAppendable<T>
    with _MixinVertexHidden<T> {
  @override
  final T? _data;
  @override
  NodeAppendable<T>? child;

  _ImplNodeAppendableUnmodifiableNullable(this._data, [this.child])
      : super(NodeAppendable.unmodifiableNullable);
}

//
class _ImplNodeAppendableFixed<T> extends NodeAppendable<T> {
  @override
  T data;
  @override
  final NodeAppendable<T>? child;

  _ImplNodeAppendableFixed(this.data, [this.child])
      : super(NodeAppendable.fixed);
}

//
class _ImplNodeAppendableFixedNullable<T> extends NodeAppendable<T>
    with _MixinVertexHidden<T> {
  @override
  T? _data;
  @override
  final NodeAppendable<T>? child;

  _ImplNodeAppendableFixedNullable(this._data, [this.child])
      : super(NodeAppendable.fixedNullable);
}

//
class _ImplNodeAppendableMutable<T> extends NodeAppendable<T> {
  @override
  T data;
  @override
  NodeAppendable<T>? child;

  _ImplNodeAppendableMutable(this.data, [this.child])
      : super(NodeAppendable.mutable);
}

//
class _ImplNodeAppendableMutableNullable<T> extends NodeAppendable<T>
    with _MixinVertexHidden<T> {
  @override
  T? _data;

  @override
  NodeAppendable<T>? child;

  _ImplNodeAppendableMutableNullable(this._data, [this.child])
      : super(NodeAppendable.mutableNullable);
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
mixin _MixinNodeNextInsertable<T, N extends _NodeNextInsertable<T, N>>
    on
        _MixinVertexHidden<T>,
        _MixinNodeNextHidden<T, N>,
        _MixinNodeNextConstruct<T, N>
    implements IInsertable<T> {
  ///
  /// overrides
  ///
  @override
  void insert(T data);

  @override
  void insertAll(Iterable<T> iterable) => iterable.iterator.consumeAll(insert);

  ///
  /// functions
  ///
  void _insertCurrent(T data) {
    _child = _construct(this.data, _child);
    _data = data;
  }

// void _insertNext(T data) => _child = _constructChild(
//       data,
//       (node) => node..insert(data),
//     );
}

///
///
///
///
/// [_NodeNextInsertable]
///   |##[_MixinNodeNextInsertableByInvalid]
///   |##[_MixinNodeNextInsertableByInvalidComparator]
///   |##[_MixinNodeNextInsertableByInvalidForIterator]
///   |##[_MixinNodeNextInsertableByInvalidComparatorForIterator]
///   |
///   |##[_MixinNodeNextInsertableIterator]
///   |-[_NodeNextInsertableIterator]                               |-[_QueueIterator]
///   |   |-[_NodeQueueIteratorCompared]     >>     [QueteratorCompared]-|
///   |   |-[_NodeQueueIterator]             >>             [Queterator]-|
///
///
///
///

///
///
///
abstract class _NodeNextInsertable<T, N extends _NodeNextInsertable<T, N>>
    extends NodeNext<T>
    with
        _MixinVertexHidden<T>,
        _MixinNodeNextHidden<T, N>,
        _MixinNodeNextConstruct<T, N>,
        _MixinNodeNextInsertable<T, N> {
  ///
  /// constructor
  ///
  const _NodeNextInsertable();
}

//
mixin _MixinNodeNextInsertableByInvalid<C extends Comparable,
        N extends _MixinNodeNextInsertableByInvalid<C, N>>
    on _NodeNextInsertable<C, N> {
  @override
  void insert(C data, [int? invalid]) => _insert(data, invalid!);

  @override
  void insertAll(Iterable<C> iterable, [int? invalid]) =>
      _insertAll(iterable, invalid!);

  void _insertNext(C data, [int? invalid]) => _child = _constructChild(
        data,
        (node) => node.._insert(data, invalid!),
      );

  void _insert(C data, int invalid) => this.data.compareTo(data) == invalid
      ? _insertCurrent(data)
      : _insertNext(data, invalid);

  void _insertAll(Iterable<C> iterable, int invalid) =>
      iterable.iterator.consumeAll((data) => insert(data, invalid));
}

//
mixin _MixinNodeNextInsertableByInvalidComparator<T,
        N extends _MixinNodeNextInsertableByInvalidComparator<T, N>>
    on _NodeNextInsertable<T, N> {
  @override
  void insert(T data, [int? invalid, Comparator<T>? comparator]) =>
      _insert(data, invalid!, comparator!);

  @override
  void insertAll(Iterable<T> iterable,
          [int? invalid, Comparator<T>? comparator]) =>
      _insertAll(iterable, invalid!, comparator!);

  void _insertNext(T data, [int? invalid, Comparator<T>? comparator]) =>
      _child = _constructChild(
        data,
        (node) => node.._insert(data, invalid!, comparator!),
      );

  void _insert(T data, int invalid, Comparator<T> comparator) =>
      comparator(this.data, data) == invalid
          ? _insertCurrent(data)
          : _insertNext(data, invalid, comparator);

  void _insertAll(
    Iterable<T> iterable,
    int invalid,
    Comparator<T> comparator,
  ) =>
      iterable.iterator
          .consumeAll((data) => _insert(data, invalid, comparator));
}

///
/// to get inserted data by [_MixinNodeNextInsertableByInvalidForIterator] or [_MixinNodeNextInsertableByInvalidComparatorForIterator],
/// the instance must invoke something like [_NodeNextInsertableIterator.moveNext] before taking data.
///

//
mixin _MixinNodeNextInsertableByInvalidForIterator<C extends Comparable,
        N extends _MixinNodeNextInsertableByInvalidForIterator<C, N>>
    on _MixinNodeNextInsertableByInvalid<C, N> {
  @override
  void insert(C data, [int? invalid]) =>
      _child = _constructChild(data, (child) => child.._insert(data, invalid!));

  @override
  void insertAll(Iterable<C> iterable, [int? invalid]) =>
      _child = _constructChildren(
        iterable,
        (node, data) => node.._insert(data, invalid!),
        (child) => child.._insertAll(iterable, invalid!),
      );
}

//
mixin _MixinNodeNextInsertableByInvalidComparatorForIterator<T,
        N extends _MixinNodeNextInsertableByInvalidComparatorForIterator<T, N>>
    on _MixinNodeNextInsertableByInvalidComparator<T, N> {
  @override
  void insert(T data, [int? invalid, Comparator<T>? comparator]) =>
      _child = _constructChild(
        data,
        (child) => child.._insert(data, invalid!, comparator!),
      );

  @override
  void insertAll(
    Iterable<T> iterable, [
    int? invalid,
    Comparator<T>? comparator,
  ]) =>
      _child = _constructChildren(
        iterable,
        (node, data) => node.._insert(data, invalid!, comparator!),
        (child) => child.._insertAll(iterable, invalid!, comparator!),
      );
}

//
mixin _MixinNodeNextInsertableIterator<I,
        N extends _NodeNextInsertableIterator<I, N>>
    on _NodeNextInsertable<I, N> implements IIteratorRedo<I> {
  ///
  /// overrides
  ///
  @override
  I get current => _data ?? (throw StateError(KErrorMessage.iteratorNoElement));

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
  bool moveNextRedo() {
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
/// [_NodeNextInsertableIterator]
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
abstract class _NodeNextInsertableIterator<I,
        N extends _NodeNextInsertableIterator<I, N>>
    extends _NodeNextInsertable<I, N>
    with _MixinNodeNextInsertableIterator<I, N> {
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
  _NodeNextInsertableIterator(this._data, [this._child]);

  _NodeNextInsertableIterator._fromIterable(
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
    extends _NodeNextInsertableIterator<C, _NodeQueueIteratorCompared<C>>
    with
        _MixinNodeNextInsertableByInvalid<C, _NodeQueueIteratorCompared<C>>,
        _MixinNodeNextInsertableByInvalidForIterator<C,
            _NodeQueueIteratorCompared<C>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructorNext<C, _NodeQueueIteratorCompared<C>> get _construct =>
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
          (node, data) => node.._insert(data, invalid),
        );
}

///
///
/// [_construct], ...(overrides)
/// [_NodeIterator.fromIterable], ...(constructors)
///
///
class _NodeQueueIterator<I>
    extends _NodeNextInsertableIterator<I, _NodeQueueIterator<I>>
    with
        _MixinNodeNextInsertableByInvalidComparator<I, _NodeQueueIterator<I>>,
        _MixinNodeNextInsertableByInvalidComparatorForIterator<I,
            _NodeQueueIterator<I>>,
        _MixinNodeNextInsertableIterator<I, _NodeQueueIterator<I>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructorNext<I, _NodeQueueIterator<I>> get _construct =>
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
          (node, data) => node.._insert(data, invalid, comparator),
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
///     |-[Queterator]
///
///
///
///
///
///
///

///
///
/// [_QueueIterator] contains subclass of [_NodeNextInsertableIterator] to instruct how to prioritize data.
/// it holds necessary comparison data once, instead of duplicate comparators or predicators for each node.
///
/// to assign predicator for each node, see [_NodeOrdable], [NodeCompared], [NodeLined]
/// to assign comparator for each node, see [NodeTreeChained]
/// to iterate though nodes on each node, see [NodeQueterator]
///
///
abstract class _QueueIterator<I, N extends _NodeNextInsertableIterator<I, N>>
    implements IIteratorRedo<I>, IInsertable<I> {
  ///
  /// overrides
  ///
  @override
  String toString() => 'Queue: ${_node._child?._toStringLinked()}';

  @override
  I get current =>
      _node._data ?? (throw StateError(KErrorMessage.iteratorNoElement));

  @override
  bool moveNext() => _node.moveNext();

  @override
  bool moveNextRedo() => _node.moveNextRedo();

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
  void insert(C element) => _node.insert(element, _invalidChecker);

  @override
  void insertAll(Iterable<C> iterable) =>
      _node.insertAll(iterable, _invalidChecker);

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
class Queterator<I> extends _QueueIterator<I, _NodeQueueIterator<I>> {
  ///
  /// overrides
  ///
  @override
  void insert(I element) => _node.insert(element, _invalidChecker, _comparator);

  @override
  void insertAll(Iterable<I> iterable) =>
      _node.insertAll(iterable, _invalidChecker, _comparator);

  ///
  /// properties
  ///
  final Comparator<I> _comparator;

  ///
  /// constructors
  ///
  Queterator.increase(Iterable<I> iterable, Comparator<I> comparator)
      : _comparator = comparator,
        super.increase(
            _NodeQueueIterator.fromIterable(iterable, 1, comparator));

  Queterator.decrease(Iterable<I> iterable, Comparator<I> comparator)
      : _comparator = comparator,
        super.decrease(
            _NodeQueueIterator.fromIterable(iterable, -1, comparator));

  Queterator.empty(Comparator<I> comparator, [bool increase = true])
      : _comparator = comparator,
        super(_NodeQueueIterator(), increase ? 1 : -1);

  Queterator.of(I value, Comparator<I> comparator, [bool increase = true])
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

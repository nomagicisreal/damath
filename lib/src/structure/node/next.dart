///
///
/// this file contains:
/// [Node]
///   |##[_MixinNodeConstructable], ##[_MixinNodeHidden]
///   |
///   |-[_NodeImmutable], [_NodeImmutableNullable]
///   |-[_NodeUnmodifiable], [_NodeUnmodifiableNullable]
///   |-[_NodeFixed], [_NodeFixedNullable]
///   |-[_NodeMutable], [_NodeMutableNullable]
///   |
///   |-[NodeAppendable]
///   |   |-[_NodeAppendableImmutable], [_NodeAppendableImmutableNullable]
///   |   |-[_NodeAppendableUnmodifiable], [_NodeAppendableUnmodifiableNullable]
///   |   |-[_NodeAppendableFixed], [_NodeAppendableFixedNullable]
///   |   |-[_NodeAppendableMutable], [_NodeAppendableMutableNullable]
///   |
///   |-[_NodeOrdable]
///       |-[NodeHead], ##[_MixinNodeHeadNullable]
///       |   |-[_NodeHeadImmutable], [_NodeHeadImmutableNullable]
///       |   |-[_NodeHeadUnmodifiable], [_NodeHeadUnmodifiableNullable]
///       |   |-[_NodeHeadFixed], [_NodeHeadFixedNullable]
///       |   |-[_NodeHeadMutable], [_NodeHeadMutableNullable]
///       |
///       |-[_NodeChainable], ##[_MixinNodeChainableNullable]
///           |-[NodeComparable]
///           |   |-[_NodeComparableImmutable], [_NodeComparableImmutableNullable]
///           |   |-[_NodeComparableUnmodifiable], [_NodeComparableUnmodifiableNullable]
///           |   |-[_NodeComparableFixed], [_NodeComparableFixedNullable]
///           |   |-[_NodeComparableMutable], [_NodeComparableMutableNullable]
///           |
///           |-[NodeConnectable]
///               |-[_NodeConnectableImmutable], [_NodeConnectableImmutableNullable]
///               |-[_NodeConnectableUnmodifiable], [_NodeConnectableUnmodifiableNullable]
///               |-[_NodeConnectableFixed], [_NodeConnectableFixedNullable]
///               |-[_NodeConnectableMutable], [_NodeConnectableMutableNullable]
///
///
///
part of damath_structure;

///
///
/// [NodeConstructor]
/// [_NodeConstructorConnectable]
///
///
typedef NodeConstructor<T, N extends Node<T>> = N Function(T data, N? next);
typedef _NodeConstructorConnectable<T> = NodeConnectable<T> Function(
  Comparator<T> comparator,
  T data,
  NodeConnectable<T>? next,
);

///
///
///
///
///
///
/// [Node], ##[_MixinNodeConstructable], ##[_MixinNodeHidden]
///   |-[_NodeImmutable], [_NodeImmutableNullable]
///   |-[_NodeUnmodifiable], [_NodeUnmodifiableNullable]
///   |-[_NodeFixed], [_NodeFixedNullable]
///   |-[_NodeMutable], [_NodeMutableNullable]
///   |
///   |-[NodeAppendable]
///   |   |-[_NodeAppendableImmutable], [_NodeAppendableImmutableNullable]
///   |   |-[_NodeAppendableUnmodifiable], [_NodeAppendableUnmodifiableNullable]
///   |   |-[_NodeAppendableFixed], [_NodeAppendableFixedNullable]
///   |   |-[_NodeAppendableMutable], [_NodeAppendableMutableNullable]
///   |
///   |-[_NodeOrdable], ...
///
///
///
///
///
///

///
///
/// [toString], ...(overrides)
/// [next], ...(properties)
/// [Node.immutable], ...(factories)
/// [nodeIndexOutOfBoundary], ...(constants)
///
///
abstract class Node<T> extends Vertex<T> with OperatableIndexable<Node<T>> {
  ///
  ///
  /// overrides
  ///
  ///
  @override
  String toString() => 'Node: ${_toStringLinked()}';

  @override
  Node<T> operator [](int index) {
    Node<T> n = this;
    for (var i = 0; i < index; i++) {
      n = n.next ?? (throw RangeError(KErrorMessage.nodeIndexOutOfBoundary));
    }
    return n;
  }

  ///
  /// constructor
  ///
  const Node();

  ///
  /// factories
  ///
  const factory Node.immutable(T data, [Node<T>? next]) = _NodeImmutable<T>;

  factory Node.unmodifiable(T data, [Node<T>? next]) = _NodeUnmodifiable<T>;

  factory Node.mutable(T data, [Node<T>? next]) = _NodeMutable<T>;

  factory Node.fixed(T data, [Node<T>? next]) = _NodeFixed<T>;

  const factory Node.immutableNullable(T? data, [Node<T>? next]) =
      _NodeImmutableNullable<T>;

  factory Node.unmodifiableNullable(T? data, [Node<T>? next]) =
      _NodeUnmodifiableNullable<T>;

  factory Node.mutableNullable(T? data, [Node<T>? next]) =
      _NodeMutableNullable<T>;

  factory Node.fixedNullable(T? data, [Node<T>? next]) = _NodeFixedNullable<T>;

  factory Node.generate(
    int length,
    Generator<T> generator,
    NodeConstructor<T, Node<T>> construct,
  ) {
    assert(!length.isNegative);
    Node<T>? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
  }

  ///
  ///
  /// setter, getter, function
  ///
  ///
  set next(Node<T>? node) =>
      throw StateError(KErrorMessage.nodeNextIsImmutable);

  Node<T>? get next;

  String _toStringLinked([String prefix = '']) => (StringBuffer()
        ..write('$prefix$data')
        ..write(next.mapNotNullOr(
          (node) => node._toStringLinked('--'),
          () => '',
        )))
      .toString();
}

//
mixin _MixinNodeConstructable<T, N extends Node<T>> on Node<T> {
  @override
  N? get next;

  @override
  set next(covariant N? node);

  ///
  /// functions, getter
  ///
  N _constructNext(T data) => next.applyNotNullOr(
        _applierOf(data),
        () => _construct(data, null),
      );

  Applier<N> _applierOf(T data);

  NodeConstructor<T, N> get _construct;
}

//
mixin _MixinNodeHidden<T, N extends Node<T>> on Node<T> {
  @override
  set next(Node<T>? node) =>
      throw StateError(KErrorMessage.nodeNextCannotAssignDirectly);

  @override
  N? get next => _next;

  set _next(N? node) => throw StateError(KErrorMessage.nodeNextIsImmutable);

  N? get _next;
}

//
class _NodeImmutable<T> extends Node<T> {
  @override
  final T data;

  @override
  final Node<T>? next;

  const _NodeImmutable(this.data, [this.next]);
}

//
class _NodeImmutableNullable<T> extends Node<T> with _MixinVertexNullable<T> {
  @override
  final T? _dataNullable;

  @override
  final Node<T>? next;

  const _NodeImmutableNullable([this._dataNullable, this.next]);
}

//
class _NodeUnmodifiable<T> extends Node<T> {
  @override
  final T data;
  @override
  Node<T>? next;

  _NodeUnmodifiable(this.data, [this.next]);
}

//
class _NodeUnmodifiableNullable<T> extends Node<T> with _MixinVertexNullable<T> {
  @override
  final T? _dataNullable;

  @override
  Node<T>? next;

  _NodeUnmodifiableNullable([this._dataNullable, this.next]);
}

//
class _NodeFixed<T> extends Node<T> {
  @override
  T data;
  @override
  final Node<T>? next;

  _NodeFixed(this.data, [this.next]);
}

//
class _NodeFixedNullable<T> extends Node<T> with _MixinVertexNullable<T> {
  @override
  T? _dataNullable;

  @override
  final Node<T>? next;

  _NodeFixedNullable([this._dataNullable, this.next]);
}

//
class _NodeMutable<T> extends Node<T> {
  @override
  T data;

  @override
  Node<T>? next;

  _NodeMutable(this.data, [this.next]);
}

//
class _NodeMutableNullable<T> extends Node<T> with _MixinVertexNullable<T> {
  @override
  T? _dataNullable;

  @override
  Node<T>? next;

  _NodeMutableNullable([this._dataNullable, this.next]);
}

///
/// [NodeAppendable]
///   |-[_NodeAppendableImmutable], [_NodeAppendableImmutableNullable]
///   |-[_NodeAppendableUnmodifiable], [_NodeAppendableUnmodifiableNullable]
///   |-[_NodeAppendableFixed], [_NodeAppendableFixedNullable]
///   |-[_NodeAppendableMutable], [_NodeAppendableMutableNullable]
///
///

///
///
/// [_construct], ...(overrides)
/// [append], ...(function)
/// [NodeAppendable.immutable], ...(factories)
///
abstract class NodeAppendable<T> extends Node<T>
    with _MixinNodeConstructable<T, NodeAppendable<T>> {
  ///
  /// overrides
  ///
  @override
  final NodeConstructor<T, NodeAppendable<T>> _construct;

  @override
  Applier<NodeAppendable<T>> _applierOf(T data) => (node) => node..append(data);

  ///
  /// function
  ///
  void append(T data, [bool updateNext = false]) =>
      next = updateNext ? _construct(data, next) : _constructNext(data);

  ///
  /// constructor
  ///
  const NodeAppendable(this._construct);

  ///
  /// factories
  ///
  factory NodeAppendable.immutable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableImmutable<T>;

  factory NodeAppendable.unmodifiable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableUnmodifiable<T>;

  factory NodeAppendable.fixed(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableFixed<T>;

  factory NodeAppendable.mutable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableMutable<T>;

  // nullable
  factory NodeAppendable.immutableNullable(T? data, [NodeAppendable<T>? next]) =
      _NodeAppendableImmutableNullable<T>;

  factory NodeAppendable.unmodifiableNullable(T? data,
      [NodeAppendable<T>? next]) = _NodeAppendableUnmodifiableNullable<T>;

  factory NodeAppendable.fixedNullable(T? data, [NodeAppendable<T>? next]) =
      _NodeAppendableFixedNullable<T>;

  factory NodeAppendable.mutableNullable(T? data, [NodeAppendable<T>? next]) =
      _NodeAppendableMutableNullable<T>;

  factory NodeAppendable.generate(
    int length,
    Generator<T> generator,
    NodeConstructor<T, NodeAppendable<T>> construct,
  ) {
    NodeAppendable<T>? current;
    for (var i = length - 1; i > -1; i--) {
      current = construct(generator(i), current);
    }
    return current!;
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
class _NodeAppendableImmutableNullable<T> extends NodeAppendable<T>
    with _MixinVertexNullable<T> {
  @override
  final T? _dataNullable;
  @override
  final NodeAppendable<T>? next;

  const _NodeAppendableImmutableNullable(this._dataNullable, [this.next])
      : super(NodeAppendable.immutableNullable);
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
class _NodeAppendableUnmodifiableNullable<T> extends NodeAppendable<T>
    with _MixinVertexNullable<T> {
  @override
  final T? _dataNullable;
  @override
  NodeAppendable<T>? next;

  _NodeAppendableUnmodifiableNullable(this._dataNullable, [this.next])
      : super(NodeAppendable.unmodifiableNullable);
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
class _NodeAppendableFixedNullable<T> extends NodeAppendable<T>
    with _MixinVertexNullable<T> {
  @override
  T? _dataNullable;
  @override
  final NodeAppendable<T>? next;

  _NodeAppendableFixedNullable(this._dataNullable, [this.next])
      : super(NodeAppendable.fixedNullable);
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

//
class _NodeAppendableMutableNullable<T> extends NodeAppendable<T>
    with _MixinVertexNullable<T> {
  @override
  T? _dataNullable;

  @override
  NodeAppendable<T>? next;

  _NodeAppendableMutableNullable(this._dataNullable, [this.next])
      : super(NodeAppendable.mutableNullable);
}

///
///
///
///
///
///
///
///
/// [_NodeOrdable]
///   |-[NodeHead], ##[_MixinNodeHeadNullable]
///   |   |-[_NodeHeadImmutable], [_NodeHeadImmutableNullable]
///   |   |-[_NodeHeadUnmodifiable], [_NodeHeadUnmodifiableNullable]
///   |   |-[_NodeHeadFixed], [_NodeHeadFixedNullable]
///   |   |-[_NodeHeadMutable], [_NodeHeadMutableNullable]
///   |
///   |-[_NodeChainable] ...
///
///
///
///
///
///
///

///
/// [_applierOf], ...(overrides)
/// [_predicator], ...(property)
/// [_NodeOrdable.increase], ...(constructors)
/// [_increase], ...(static methods)
/// [input], ...(functions, getters)
///
abstract class _NodeOrdable<T, N extends _NodeOrdable<T, N>> extends Node<T>
    with
        _MixinVertexHidden<T>,
        _MixinNodeHidden<T, N>,
        _MixinNodeConstructable<T, N> {
  ///
  /// overrides
  ///
  @override
  Applier<N> _applierOf(T data) => (node) => node..input(data);

  ///
  /// property
  ///
  final Predicator<int> _predicator;

  ///
  /// constructor
  ///
  const _NodeOrdable.increase() : _predicator = _increase;

  const _NodeOrdable.decrease() : _predicator = _decrease;

  ///
  /// static methods
  ///
  static bool _increase(int compareValue) => compareValue == 1;

  static bool _decrease(int compareValue) => compareValue == -1;

  ///
  /// functions, getters
  ///
  void input(T data) => _predicator(_comparator(_data, data))
      ? _inputCurrent(data)
      : _inputNext(data);

  Comparator<T> get _comparator =>
      throw StateError(KErrorMessage.nodeNotHoldComparator);

  void _inputCurrent(T data) {
    _next = _construct(_data, _next);
    _data = data;
  }

  void _inputNext(T data) => _next = _constructNext(data);
}

///
///
///
///
///
///
/// [NodeHead]
///   |-[_NodeHeadImmutable], [_NodeHeadImmutableNullable]
///   |-[_NodeHeadUnmodifiable], [_NodeHeadUnmodifiableNullable]
///   |-[_NodeHeadFixed], [_NodeHeadFixedNullable]
///   |-[_NodeHeadMutable], [_NodeHeadMutableNullable]
///
///
///
///
///
///

///
///
/// [_constructNext], ...(overrides)
/// [NodeHead.increase], ...(constructors)
///
///
abstract class NodeHead<T> extends _NodeOrdable<T, NodeHead<T>> {
  ///
  /// overrides
  ///
  @override
  NodeHead<T> _constructNext(T data, [Comparator<T>? comparator]) =>
      next.applyNotNullOr(
        _applierOf(data, comparator),
        () => _construct(data, null),
      );

  @override
  Applier<NodeHead<T>> _applierOf(T data, [Comparator<T>? comparator]) =>
      (node) => node..input(data, comparator);

  @override
  void input(T data, [Comparator<T>? comparator]) =>
      _predicator(comparator!(_data, data))
          ? _inputCurrent(data)
          : _inputNext(data, comparator);

  @override
  void _inputNext(T data, [Comparator<T>? comparator]) =>
      _next = _constructNext(data, comparator);

  @override
  NodeConstructor<T, NodeHead<T>> get _construct =>
      (data, next) => _constructHead(data);

  final Mapper<T, NodeHead<T>> _constructHead;

  ///
  /// constructors
  ///
  const NodeHead.increase(this._constructHead) : super.increase();

  const NodeHead.decrease(this._constructHead) : super.decrease();

  ///
  /// factories
  ///
  const factory NodeHead.increaseImmutable(T data) =
      _NodeHeadImmutable<T>.increase;

  const factory NodeHead.decreaseImmutable(T data) =
      _NodeHeadImmutable<T>.decrease;

  factory NodeHead.increaseUnmodifiable(T data) =
      _NodeHeadUnmodifiable<T>.increase;

  factory NodeHead.decreaseUnmodifiable(T data) =
      _NodeHeadUnmodifiable<T>.decrease;

  factory NodeHead.increaseFixed(T data) = _NodeHeadFixed<T>.increase;

  factory NodeHead.decreaseFixed(T data) = _NodeHeadFixed<T>.decrease;

  factory NodeHead.increaseMutable(T data) = _NodeHeadMutable<T>.increase;

  factory NodeHead.decreaseMutable(T data) = _NodeHeadMutable<T>.decrease;

// nullable
  const factory NodeHead.increaseImmutableNullable([T? data]) =
      _NodeHeadImmutableNullable<T>.increase;

  const factory NodeHead.decreaseImmutableNullable([T? data]) =
      _NodeHeadImmutableNullable<T>.decrease;

  factory NodeHead.increaseUnmodifiableNullable([T? data]) =
      _NodeHeadUnmodifiableNullable<T>.increase;

  factory NodeHead.decreaseUnmodifiableNullable([T? data]) =
      _NodeHeadUnmodifiableNullable<T>.decrease;

  factory NodeHead.increaseFixedNullable([T? data]) =
      _NodeHeadFixedNullable<T>.increase;

  factory NodeHead.decreaseFixedNullable([T? data]) =
      _NodeHeadFixedNullable<T>.decrease;

  factory NodeHead.increaseMutableNullable([T? data]) =
      _NodeHeadMutableNullable<T>.increase;

  factory NodeHead.decreaseMutableNullable([T? data]) =
      _NodeHeadMutableNullable<T>.decrease;
}

//
mixin _MixinNodeHeadNullable<T, N extends NodeHead<T>>
    on NodeHead<T>, _MixinVertexNullableAssign<T> {
  @override
  void input(T data, [Comparator<T>? comparator]) {
    if (!_nullAssign(data)) super.input(data, comparator);
  }
}

//
class _NodeHeadImmutable<T> extends NodeHead<T> {
  @override
  final T _data;

  @override
  final NodeHead<T>? _next;

  const _NodeHeadImmutable.increase(this._data, [this._next])
      : super.increase(_NodeHeadImmutable.increase);

  const _NodeHeadImmutable.decrease(this._data, [this._next])
      : super.decrease(_NodeHeadImmutable.decrease);
}

//
class _NodeHeadImmutableNullable<T> extends NodeHead<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeHeadNullable<T, NodeHead<T>> {
  @override
  final T? _dataNullable;

  @override
  final NodeHead<T>? _next;

  const _NodeHeadImmutableNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeHeadImmutableNullable.increase);

  const _NodeHeadImmutableNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeHeadImmutableNullable.decrease);
}

//
class _NodeHeadUnmodifiable<T> extends NodeHead<T> {
  @override
  final T _data;

  @override
  NodeHead<T>? _next;

  _NodeHeadUnmodifiable.increase(this._data, [this._next])
      : super.increase(_NodeHeadUnmodifiable.increase);

  _NodeHeadUnmodifiable.decrease(this._data, [this._next])
      : super.decrease(_NodeHeadUnmodifiable.decrease);
}

//
class _NodeHeadUnmodifiableNullable<T> extends NodeHead<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeHeadNullable<T, NodeHead<T>> {
  @override
  final T? _dataNullable;

  @override
  NodeHead<T>? _next;

  _NodeHeadUnmodifiableNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeHeadUnmodifiableNullable.increase);

  _NodeHeadUnmodifiableNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeHeadUnmodifiableNullable.decrease);
}

//
class _NodeHeadFixed<T> extends NodeHead<T> {
  @override
  T _data;

  @override
  final NodeHead<T>? _next;

  _NodeHeadFixed.increase(this._data, [this._next])
      : super.increase(_NodeHeadFixed.increase);

  _NodeHeadFixed.decrease(this._data, [this._next])
      : super.decrease(_NodeHeadFixed.decrease);
}

//
class _NodeHeadFixedNullable<T> extends NodeHead<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeHeadNullable<T, NodeHead<T>> {
  @override
  T? _dataNullable;

  @override
  final NodeHead<T>? _next;

  _NodeHeadFixedNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeHeadFixedNullable.increase);

  _NodeHeadFixedNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeHeadFixedNullable.decrease);
}

//
class _NodeHeadMutable<T> extends NodeHead<T> {
  @override
  T _data;

  @override
  NodeHead<T>? _next;

  _NodeHeadMutable.increase(this._data, [this._next])
      : super.increase(_NodeHeadMutable.increase);

  _NodeHeadMutable.decrease(this._data, [this._next])
      : super.decrease(_NodeHeadMutable.decrease);
}

//
class _NodeHeadMutableNullable<T> extends NodeHead<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeHeadNullable<T, NodeHead<T>> {
  @override
  T? _dataNullable;

  @override
  NodeHead<T>? _next;

  _NodeHeadMutableNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeHeadMutableNullable.increase);

  _NodeHeadMutableNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeHeadMutableNullable.decrease);
}

///
///
///
///
///
///
///
/// [_NodeChainable], ##[_MixinNodeChainableNullable]
///   |-[NodeComparable]
///   |   |-[_NodeComparableImmutable], [_NodeComparableImmutableNullable]
///   |   |-[_NodeComparableUnmodifiable], [_NodeComparableUnmodifiableNullable]
///   |   |-[_NodeComparableFixed], [_NodeComparableFixedNullable]
///   |   |-[_NodeComparableMutable], [_NodeComparableMutableNullable]
///   |
///   |-[NodeConnectable]
///       |-[_NodeConnectableImmutable], [_NodeConnectableImmutableNullable]
///       |-[_NodeConnectableUnmodifiable], [_NodeConnectableUnmodifiableNullable]
///       |-[_NodeConnectableFixed], [_NodeConnectableFixedNullable]
///       |-[_NodeConnectableMutable], [_NodeConnectableMutableNullable]
///
///
///
///
///
///
///
///

///
/// [_comparator], ...(overrides)
/// [_NodeChainable.increase], ...(constructors)
///
abstract class _NodeChainable<T, N extends _NodeChainable<T, N>>
    extends _NodeOrdable<T, N> {
  ///
  /// overrides
  ///
  @override
  Comparator<T> get _comparator;

  ///
  /// constructors
  ///
  const _NodeChainable.increase() : super.increase();

  const _NodeChainable.decrease() : super.decrease();
}

//
mixin _MixinNodeChainableNullable<T, N extends _NodeOrdable<T, N>>
    on
        _NodeOrdable<T, N>,
        _MixinVertexNullableHidden<T>,
        _MixinVertexNullableAssign<T> {
  @override
  void input(T data) {
    if (!_nullAssign(data)) super.input(data);
  }
}

///
///
///
///
///
///
/// [NodeComparable]
///   |-[_NodeComparableImmutable], [_NodeComparableImmutableNullable]
///   |-[_NodeComparableUnmodifiable], [_NodeComparableUnmodifiableNullable]
///   |-[_NodeComparableFixed], [_NodeComparableFixedNullable]
///   |-[_NodeComparableMutable], [_NodeComparableMutableNullable]
///
///
///
///
///
///

///
///
/// [_construct], ...(overrides)
/// [NodeComparable.increase], ...(constructors)
/// [NodeComparable.increaseImmutable], ...(factories)
///
///
abstract class NodeComparable<C extends Comparable>
    extends _NodeChainable<C, NodeComparable<C>> {
  ///
  /// overrides
  ///
  @override
  final NodeConstructor<C, NodeComparable<C>> _construct;

  @override
  Comparator<C> get _comparator => Comparable.compare;

  ///
  /// constructors
  ///
  const NodeComparable.increase(this._construct) : super.increase();

  const NodeComparable.decrease(this._construct) : super.decrease();

  ///
  /// factories
  ///
  const factory NodeComparable.increaseImmutable(C data,
      [NodeComparable<C>? next]) = _NodeComparableImmutable<C>.increase;

  const factory NodeComparable.decreaseImmutable(C data,
      [NodeComparable<C>? next]) = _NodeComparableImmutable<C>.decrease;

  factory NodeComparable.increaseUnmodifiable(C data,
      [NodeComparable<C>? next]) = _NodeComparableUnmodifiable<C>.increase;

  factory NodeComparable.decreaseUnmodifiable(C data,
      [NodeComparable<C>? next]) = _NodeComparableUnmodifiable<C>.decrease;

  factory NodeComparable.increaseFixed(C data, [NodeComparable<C>? next]) =
      _NodeComparableFixed<C>.increase;

  factory NodeComparable.decreaseFixed(C data, [NodeComparable<C>? next]) =
      _NodeComparableFixed<C>.decrease;

  factory NodeComparable.increaseMutable(C data, [NodeComparable<C>? next]) =
      _NodeComparableMutable<C>.increase;

  factory NodeComparable.decreaseMutable(C data, [NodeComparable<C>? next]) =
      _NodeComparableMutable<C>.decrease;

  // nullable
  const factory NodeComparable.increaseImmutableNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableImmutableNullable<C>.increase;

  const factory NodeComparable.decreaseImmutableNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableImmutableNullable<C>.decrease;

  factory NodeComparable.increaseUnmodifiableNullable(C? data,
          [NodeComparable<C>? next]) =
      _NodeComparableUnmodifiableNullable<C>.increase;

  factory NodeComparable.decreaseUnmodifiableNullable(C? data,
          [NodeComparable<C>? next]) =
      _NodeComparableUnmodifiableNullable<C>.decrease;

  factory NodeComparable.increaseFixedNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableFixedNullable<C>.increase;

  factory NodeComparable.decreaseFixedNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableFixedNullable<C>.decrease;

  factory NodeComparable.increaseMutableNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableMutableNullable<C>.increase;

  factory NodeComparable.decreaseMutableNullable(C? data,
      [NodeComparable<C>? next]) = _NodeComparableMutableNullable<C>.decrease;
}

//
class _NodeComparableImmutable<C extends Comparable> extends NodeComparable<C> {
  @override
  final C _data;

  @override
  final NodeComparable<C>? _next;

  const _NodeComparableImmutable.increase(this._data, [this._next])
      : super.increase(_NodeComparableImmutable.increase);

  const _NodeComparableImmutable.decrease(this._data, [this._next])
      : super.decrease(_NodeComparableImmutable.decrease);
}

//
class _NodeComparableImmutableNullable<C extends Comparable>
    extends NodeComparable<C>
    with
        _MixinVertexNullable<C>,
        _MixinVertexNullableHidden<C>,
        _MixinVertexNullableAssign<C>,
        _MixinVertexNullableHidden<C>,
        _MixinVertexNullableAssign<C>,
        _MixinNodeChainableNullable<C, NodeComparable<C>> {
  @override
  final C? _dataNullable;

  @override
  final NodeComparable<C>? _next;

  const _NodeComparableImmutableNullable.increase(this._dataNullable,
      [this._next])
      : super.increase(_NodeComparableImmutableNullable.increase);

  const _NodeComparableImmutableNullable.decrease(this._dataNullable,
      [this._next])
      : super.decrease(_NodeComparableImmutableNullable.decrease);
}

//
class _NodeComparableUnmodifiable<C extends Comparable>
    extends NodeComparable<C> {
  @override
  final C _data;

  @override
  NodeComparable<C>? _next;

  _NodeComparableUnmodifiable.increase(this._data, [this._next])
      : super.increase(_NodeComparableUnmodifiable.increase);

  _NodeComparableUnmodifiable.decrease(this._data, [this._next])
      : super.decrease(_NodeComparableUnmodifiable.decrease);
}

//
class _NodeComparableUnmodifiableNullable<C extends Comparable>
    extends NodeComparable<C>
    with
        _MixinVertexNullable<C>,
        _MixinVertexNullableHidden<C>,
        _MixinVertexNullableAssign<C>,
        _MixinNodeChainableNullable<C, NodeComparable<C>> {
  @override
  final C? _dataNullable;

  @override
  NodeComparable<C>? _next;

  _NodeComparableUnmodifiableNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeComparableUnmodifiableNullable.increase);

  _NodeComparableUnmodifiableNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeComparableUnmodifiableNullable.decrease);
}

//
class _NodeComparableFixed<C extends Comparable> extends NodeComparable<C> {
  @override
  C _data;

  @override
  final NodeComparable<C>? _next;

  _NodeComparableFixed.increase(this._data, [this._next])
      : super.increase(_NodeComparableFixed.increase);

  _NodeComparableFixed.decrease(this._data, [this._next])
      : super.decrease(_NodeComparableFixed.decrease);
}

//
class _NodeComparableFixedNullable<C extends Comparable>
    extends NodeComparable<C>
    with
        _MixinVertexNullable<C>,
        _MixinVertexNullableHidden<C>,
        _MixinVertexNullableAssign<C>,
        _MixinNodeChainableNullable<C, NodeComparable<C>> {
  @override
  C? _dataNullable;

  @override
  final NodeComparable<C>? _next;

  _NodeComparableFixedNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeComparableFixedNullable.increase);

  _NodeComparableFixedNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeComparableFixedNullable.decrease);
}

//
class _NodeComparableMutable<C extends Comparable> extends NodeComparable<C> {
  @override
  C _data;

  @override
  NodeComparable<C>? _next;

  _NodeComparableMutable.increase(this._data, [this._next])
      : super.increase(_NodeComparableMutable.increase);

  _NodeComparableMutable.decrease(this._data, [this._next])
      : super.decrease(_NodeComparableMutable.decrease);
}

//
class _NodeComparableMutableNullable<C extends Comparable>
    extends NodeComparable<C>
    with
        _MixinVertexNullable<C>,
        _MixinVertexNullableHidden<C>,
        _MixinVertexNullableAssign<C>,
        _MixinNodeChainableNullable<C, NodeComparable<C>> {
  @override
  C? _dataNullable;

  @override
  NodeComparable<C>? _next;

  _NodeComparableMutableNullable.increase([this._dataNullable, this._next])
      : super.increase(_NodeComparableMutableNullable.increase);

  _NodeComparableMutableNullable.decrease([this._dataNullable, this._next])
      : super.decrease(_NodeComparableMutableNullable.decrease);
}

///
///
///
///
///
///
/// [NodeConnectable]
///   |-[_NodeConnectableImmutable], [_NodeConnectableImmutableNullable]
///   |-[_NodeConnectableUnmodifiable], [_NodeConnectableUnmodifiableNullable]
///   |-[_NodeConnectableFixed], [_NodeConnectableFixedNullable]
///   |-[_NodeConnectableMutable], [_NodeConnectableMutableNullable]
///
///
///
///
///
///

///
/// [_comparator], ...(overrides)
/// [_constructConnectable], ...(properties)
/// [NodeChained.increase], ...(constructors)
/// [NodeChained.increaseImmutable], ...(factories)
///
///
abstract class NodeConnectable<T>
    extends _NodeChainable<T, NodeConnectable<T>> {
  ///
  /// overrides
  ///
  @override
  NodeConstructor<T, NodeConnectable<T>> get _construct =>
      (data, next) => _constructConnectable(_comparator, data, next);

  @override
  final Comparator<T> _comparator;

  ///
  /// properties
  ///
  final _NodeConstructorConnectable<T> _constructConnectable;

  ///
  /// constructors
  ///
  const NodeConnectable.increase(this._comparator, this._constructConnectable)
      : super.increase();

  const NodeConnectable.decrease(this._comparator, this._constructConnectable)
      : super.decrease();

  ///
  /// factories
  ///
  const factory NodeConnectable.increaseImmutable(
          Comparator<T> comparator, T data, [NodeConnectable<T>? next]) =
      _NodeConnectableImmutable<T>.increase;

  const factory NodeConnectable.decreaseImmutable(
          Comparator<T> comparator, T data, [NodeConnectable<T>? next]) =
      _NodeConnectableImmutable<T>.decrease;

  factory NodeConnectable.increaseUnmodifiable(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableUnmodifiable<T>.increase;

  factory NodeConnectable.decreaseUnmodifiable(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableUnmodifiable<T>.decrease;

  factory NodeConnectable.increaseFixed(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableFixed<T>.increase;

  factory NodeConnectable.decreaseFixed(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableFixed<T>.decrease;

  factory NodeConnectable.increaseMutable(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableMutable<T>.increase;

  factory NodeConnectable.decreaseMutable(Comparator<T> comparator, T data,
      [NodeConnectable<T>? next]) = _NodeConnectableMutable<T>.decrease;

  // nullable
  const factory NodeConnectable.increaseImmutableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableImmutableNullable<T>.increase;

  const factory NodeConnectable.decreaseImmutableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableImmutableNullable<T>.decrease;

  factory NodeConnectable.increaseUnmodifiableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableUnmodifiableNullable<T>.increase;

  factory NodeConnectable.decreaseUnmodifiableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableUnmodifiableNullable<T>.decrease;

  factory NodeConnectable.increaseFixedNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableFixedNullable<T>.increase;

  factory NodeConnectable.decreaseFixedNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableFixedNullable<T>.decrease;

  factory NodeConnectable.increaseMutableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableMutableNullable<T>.increase;

  factory NodeConnectable.decreaseMutableNullable(
          Comparator<T> comparator, T? data, [NodeConnectable<T>? next]) =
      _NodeConnectableMutableNullable<T>.decrease;
}

//
class _NodeConnectableImmutable<T> extends NodeConnectable<T> {
  @override
  final T _data;

  @override
  final NodeConnectable<T>? _next;

  const _NodeConnectableImmutable.increase(Comparator<T> comparator, this._data,
      [this._next])
      : super.increase(comparator, _NodeConnectableImmutable.increase);

  const _NodeConnectableImmutable.decrease(Comparator<T> comparator, this._data,
      [this._next])
      : super.decrease(comparator, _NodeConnectableImmutable.decrease);
}

//
class _NodeConnectableImmutableNullable<T> extends NodeConnectable<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeChainableNullable<T, NodeConnectable<T>> {
  @override
  final T? _dataNullable;

  @override
  final NodeConnectable<T>? _next;

  const _NodeConnectableImmutableNullable.increase(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.increase(comparator, _NodeConnectableImmutableNullable.increase);

  const _NodeConnectableImmutableNullable.decrease(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.decrease(comparator, _NodeConnectableImmutableNullable.decrease);
}

//
class _NodeConnectableUnmodifiable<T> extends NodeConnectable<T> {
  @override
  final T _data;

  @override
  NodeConnectable<T>? _next;

  _NodeConnectableUnmodifiable.increase(Comparator<T> comparator, this._data,
      [this._next])
      : super.increase(comparator, _NodeConnectableUnmodifiable.increase);

  _NodeConnectableUnmodifiable.decrease(Comparator<T> comparator, this._data,
      [this._next])
      : super.decrease(comparator, _NodeConnectableUnmodifiable.decrease);
}

//
class _NodeConnectableUnmodifiableNullable<T> extends NodeConnectable<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeChainableNullable<T, NodeConnectable<T>> {
  @override
  final T? _dataNullable;

  @override
  NodeConnectable<T>? _next;

  _NodeConnectableUnmodifiableNullable.increase(Comparator<T> comparator,
      [this._dataNullable, this._next])
      : super.increase(
            comparator, _NodeConnectableUnmodifiableNullable.increase);

  _NodeConnectableUnmodifiableNullable.decrease(Comparator<T> comparator,
      [this._dataNullable, this._next])
      : super.decrease(
            comparator, _NodeConnectableUnmodifiableNullable.decrease);
}

//
class _NodeConnectableFixed<T> extends NodeConnectable<T> {
  @override
  T _data;

  @override
  final NodeConnectable<T>? _next;

  _NodeConnectableFixed.increase(Comparator<T> comparator, this._data,
      [this._next])
      : super.increase(comparator, _NodeConnectableFixed.increase);

  _NodeConnectableFixed.decrease(Comparator<T> comparator, this._data,
      [this._next])
      : super.decrease(comparator, _NodeConnectableFixed.decrease);
}

//
class _NodeConnectableFixedNullable<T> extends NodeConnectable<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeChainableNullable<T, NodeConnectable<T>> {
  @override
  T? _dataNullable;

  @override
  final NodeConnectable<T>? _next;

  _NodeConnectableFixedNullable.increase(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.increase(comparator, _NodeConnectableFixedNullable.increase);

  _NodeConnectableFixedNullable.decrease(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.decrease(comparator, _NodeConnectableFixedNullable.decrease);
}

//
class _NodeConnectableMutable<T> extends NodeConnectable<T> {
  @override
  T _data;

  @override
  NodeConnectable<T>? _next;

  _NodeConnectableMutable.increase(Comparator<T> comparator, this._data,
      [this._next])
      : super.increase(comparator, _NodeConnectableMutable.increase);

  _NodeConnectableMutable.decrease(Comparator<T> comparator, this._data,
      [this._next])
      : super.decrease(comparator, _NodeConnectableMutable.decrease);
}

//
class _NodeConnectableMutableNullable<T> extends NodeConnectable<T>
    with
        _MixinVertexNullable<T>,
        _MixinVertexNullableAssign<T>,
        _MixinVertexNullableHidden<T>,
        _MixinNodeChainableNullable<T, NodeConnectable<T>> {
  @override
  T? _dataNullable;

  @override
  NodeConnectable<T>? _next;

  _NodeConnectableMutableNullable.increase(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.increase(comparator, _NodeConnectableMutableNullable.increase);

  _NodeConnectableMutableNullable.decrease(
      Comparator<T> comparator, this._dataNullable,
      [this._next])
      : super.decrease(comparator, _NodeConnectableMutableNullable.decrease);
}

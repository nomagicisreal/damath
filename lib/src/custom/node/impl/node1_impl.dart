part of '../../custom.dart';

///
/// * [NodeConstructor]
///
/// * [Vertex]
///     --[_VertexUnmodifiable], [_VertexMutable]
///     --[_MVertexNullable]
///     |   --[_VertexImmutableNullable], [_VertexMutableNullable]
///     |
///     --[Node1]
///         --[_MNodeConstruct], [MNodeInstance]
///             --[Node1Appendable]
///             |   --[_Node1AppendableUnmodifiable], [_Node1AppendableFixed],
///             |   --[_Node1AppendableImmutable], [_Node1AppendableMutable]
///             |
///             --[Node1Insertable]
///             |   --[_Node1InsertableUnmodifiable], [_Node1InsertableFixed],
///             |   --[_Node1InsertableImmutable], [_Node1InsertableMutable]
///             |
///             --[_MNodeNext], [_INodeNullableData], [_MQterator]
///             |   --[_Node1Enqueueable] >> [Qterator]
///             |
///             --[Node2] ...
///
///
///
///

///
///
///
class _VertexUnmodifiable<T> extends Vertex<T> {
  @override
  final T data;

  const _VertexUnmodifiable(this.data);
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

  set _data(T? value) => throw UnsupportedError(Erroring.modifyImmutable);

  @override
  set data(T value) => _data = value;

  @override
  T get data => _data ?? (throw UnsupportedError(Erroring.receiveNull));
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
      throw UnsupportedError(Erroring.modifyImmutable);

  const Node1();

  static Node1<T>? mapNext<T>(Node1<T> node) => node.next;

  @override
  String toString() =>
      'Node(${NodeExtension._lengthing(this, mapNext)}): '
      '${NodeExtension._buildString(this, mapNext)}';
}

///
///
///
mixin _MNodeConstruct<T, N extends Node1<T>> on Node1<T> {
  NodeConstructor<T, N> get _construct;
}

///
///
///
mixin MNodeInstance<T, N extends Node1<T>> on Node1<T> {
  @override
  N? get next;

  // return null if already unmodifiable, return instance if change to unmodifiable
  N? get toUnmodifiable;

  // return null if already fixed, return instance if change to fixed
  N? get toFixed;

  ///
  ///
  ///
  static bool isModifiable<N extends Node1>(N node) {
    try {
      node.data = node.data;
      return true;
    } on StateError catch (e) {
      if (e.message == Erroring.modifyImmutable) return false;
      rethrow;
    }
  }

  static bool isGrowable<N extends Node1>(N node) {
    try {
      node.next = node.next;
      return true;
    } on StateError catch (e) {
      if (e.message == Erroring.modifyImmutable) return false;
      rethrow;
    }
  }

  static N? firstDynamic<T, N extends MNodeInstance<T, N>>(N from) {
    for (N? node = from; node != null; node = node.next) {
      if (isModifiable(node)) return node;
      if (isGrowable(node)) return node;
    }
    return null;
  }
}

///
///
///
class _Node1AppendableImmutable<T> extends Node1Appendable<T> {
  @override
  final T data;
  @override
  final Node1Appendable<T>? next;

  const _Node1AppendableImmutable(this.data, [this.next])
    : super(Node1Appendable.immutable);

  @override
  Node1Appendable<T>? get toUnmodifiable => null;

  @override
  Node1Appendable<T>? get toFixed => null;
}

//
class _Node1AppendableUnmodifiable<T> extends Node1Appendable<T> {
  @override
  final T data;
  @override
  Node1Appendable<T>? next;

  _Node1AppendableUnmodifiable(this.data, [this.next])
    : super(Node1Appendable.unmodifiable);

  @override
  Node1Appendable<T>? get toUnmodifiable => null;

  @override
  Node1Appendable<T>? get toFixed => _Node1AppendableImmutable(data, next);
}

//
class _Node1AppendableFixed<T> extends Node1Appendable<T> {
  @override
  T data;
  @override
  final Node1Appendable<T>? next;

  _Node1AppendableFixed(this.data, [this.next]) : super(Node1Appendable.fixed);

  @override
  Node1Appendable<T>? get toUnmodifiable =>
      _Node1AppendableImmutable(data, next);

  @override
  Node1Appendable<T>? get toFixed => null;
}

//
class _Node1AppendableMutable<T> extends Node1Appendable<T> {
  @override
  T data;
  @override
  Node1Appendable<T>? next;

  _Node1AppendableMutable(this.data, [this.next])
    : super(Node1Appendable.mutable);

  @override
  Node1Appendable<T>? get toUnmodifiable =>
      _Node1AppendableUnmodifiable(data, next);

  @override
  Node1Appendable<T>? get toFixed => _Node1AppendableFixed(data, next);
}

///
///
///
class _Node1InsertableImmutable<T> extends Node1Insertable<T> {
  @override
  final T data;
  @override
  final Node1Insertable<T>? next;

  const _Node1InsertableImmutable(this.data, [this.next])
    : super(Node1Insertable.immutable);

  @override
  Node1Insertable<T>? get toUnmodifiable => null;

  @override
  Node1Insertable<T>? get toFixed => null;
}

//
class _Node1InsertableUnmodifiable<T> extends Node1Insertable<T> {
  @override
  final T data;
  @override
  Node1Insertable<T>? next;

  _Node1InsertableUnmodifiable(this.data, [this.next])
    : super(Node1Insertable.unmodifiable);

  @override
  Node1Insertable<T>? get toUnmodifiable => null;

  @override
  Node1Insertable<T>? get toFixed => _Node1InsertableImmutable(data, next);
}

//
class _Node1InsertableFixed<T> extends Node1Insertable<T> {
  @override
  T data;
  @override
  final Node1Insertable<T>? next;

  _Node1InsertableFixed(this.data, [this.next]) : super(Node1Insertable.fixed);

  @override
  Node1Insertable<T>? get toUnmodifiable =>
      _Node1InsertableImmutable(data, next);

  @override
  Node1Insertable<T>? get toFixed => null;
}

//
class _Node1InsertableMutable<T> extends Node1Insertable<T> {
  @override
  T data;
  @override
  Node1Insertable<T>? next;

  _Node1InsertableMutable(this.data, [this.next])
    : super(Node1Insertable.mutable);

  @override
  Node1Insertable<T>? get toUnmodifiable =>
      _Node1InsertableUnmodifiable(data, next);

  @override
  Node1Insertable<T>? get toFixed => _Node1InsertableFixed(data, next);
}

///
///
///
///
mixin _MNodeNext<T, N extends Node1<T>> on Node1<T>, _MNodeConstruct<T, N> {
  @override
  N? get next;

  N _constructNext(T data, Applier<N> nodingNotNull) =>
      next == null ? _construct(data, null) : nodingNotNull(next!);

  void _pushNext(T data, Applier<N> nodingNotNull) =>
      next = _constructNext(data, nodingNotNull);

  void _pushToNext(T data) {
    next = _construct(this.data, next);
    this.data = data;
  }
}

///
///
///
abstract interface class _INodeNullableData<I>
    implements Node1<I>, _MVertexNullable<I> {}

///
///
///
class _Node1Enqueueable<I> extends Node1<I>
    with
        _MVertexNullable<I>,
        _MNodeConstruct<I, _Node1Enqueueable<I>>,
        _MNodeNext<I, _Node1Enqueueable<I>>
    implements _IEnqueueable<I, void>, _INodeNullableData<I> {
  @override
  I? _data;

  @override
  _Node1Enqueueable<I>? next;

  _Node1Enqueueable([this._data, this.next]);

  _Node1Enqueueable.fromIterable(
    Iterable<I> iterable,
    ComparableState state,
    Comparator<I> comparator,
  ) : next = iterable.iterator.inductInited<_Node1Enqueueable<I>>(
        (data) => _Node1Enqueueable(data),
        (node, element) => node..enqueue(element, comparator, state),
      );

  ///
  ///
  ///
  @override
  NodeConstructor<I, _Node1Enqueueable<I>> get _construct =>
      (data, next) => _Node1Enqueueable(data, next);

  @override
  void enqueue(
    I element, [
    Comparator<I>? comparator,
    ComparableState? state,
  ]) =>
      comparator!(element, data) == state!.value
          ? _pushNext(
            element,
            (node) => node..enqueue(element, comparator, state),
          )
          : _pushToNext(element);

  static _Node1Enqueueable<I>? mapNext<I>(_Node1Enqueueable<I> node) =>
      node.next;
}

///
///
///
mixin _MQterator<T, N extends _INodeNullableData<T>>
    implements Iterator<T>, _ILayby<bool>, _IEnqueueable<T, void> {
  N get _node;

  @override
  T get current =>
      _node._data ?? (throw StateError(Erroring.iteratorNoElement));

  ///
  ///
  ///
  Comparator<T>? get _comparator;

  Comparator<T> get comparator => _comparator ?? _comparing;

  static int _comparing<I>(I a, I b) => (a as Comparable).compareTo(b);

  ComparableState get state;

  ///
  ///
  ///
  @override
  bool moveNext() {
    final next = _node.next;
    if (next == null) {
      _node._data = null;
      return false;
    }
    _node._data = next.data;
    _node.next = next.next;
    return true;
  }

  void enqueueAll(Iterable<T> iterable);

  bool get isCleared;
}

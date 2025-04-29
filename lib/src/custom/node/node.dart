part of '../custom.dart';

///
///
/// * [Vertex]
/// * [Node1Appendable]
/// * [Node1Insertable]
/// * [Qterator]
///
///
///
///
///

///
///
///
abstract class Vertex<T> {
  T get data;

  set data(T value) => throw StateError(Erroring.modifyImmutable);

  const Vertex();

  @override
  String toString() => 'Vertex($data)';

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<T> other) => hashCode == other.hashCode;

  const factory Vertex.unmodifiable(T data) = _VertexUnmodifiable<T>;

  factory Vertex.modifiable(T data) = _VertexMutable<T>;

  const factory Vertex.unmodifiableNullable([T? data]) =
      _VertexImmutableNullable<T>;

  factory Vertex.modifiableNullable([T? data]) = _VertexMutableNullable<T>;
}

///
/// with [Node1Appendable], instead of using [List],
/// we can define the state for each element:
///   - whether it is 'unmodifiable'. (the element data is modifiable or not)
///   - whether it is 'fixed'.        (the element can be linked to another element or not, or 'leaf of node' in term)
/// the node that is unmodifiable and fixed called 'immutable',
/// the node that is modifiable and growable (not fixed) called 'mutable'.
///
/// Notice that it's possible for a [Node1Appendable] linking with multiple <[T]> type,
/// because [N] instance called by [_MNodeConstruct.next] is [Node1Appendable] without <[T]>.
///
/// [Node1Appendable.immutable], ...
/// [Node1Appendable._mapNext], ...
/// [Node1Appendable.appendNode], ...
///
///
abstract class Node1Appendable<T> extends Node1<T>
    with
        _MNodeConstruct<T, Node1Appendable<T>>,
        MNodeInstance<T, Node1Appendable<T>>
    implements _IAppendable<T, void> {
  @override
  final NodeConstructor<T, Node1Appendable<T>> _construct;

  const Node1Appendable(this._construct);

  @override
  void append(T tail) {
    final result = _construct(tail, null);
    NodeExtension.last(this, Node1Appendable._mapNext).next = result;
  }

  ///
  ///
  ///
  const factory Node1Appendable.immutable(T data, [Node1Appendable<T>? next]) =
      _Node1AppendableImmutable<T>;

  factory Node1Appendable.unmodifiable(T data, [Node1Appendable<T>? next]) =
      _Node1AppendableUnmodifiable<T>;

  factory Node1Appendable.fixed(T data, [Node1Appendable<T>? next]) =
      _Node1AppendableFixed<T>;

  factory Node1Appendable.mutable(T data, [Node1Appendable<T>? next]) =
      _Node1AppendableMutable<T>;

  ///
  ///
  ///
  static Node1Appendable<T>? _mapNext<T>(Node1Appendable<T> node) => node.next;

  static void appendNode<T>(Node1Appendable<T> head, Node1Appendable<T> tail) =>
      NodeExtension.last(head, Node1Appendable._mapNext).next = tail;

  static Node1Appendable<T> appendIterable<T>(
    Node1Appendable<T> head,
    Iterable<T> tail, [
    bool invert = false,
  ]) {
    final last = NodeExtension.last<T, Node1Appendable<T>>(
      head,
      Node1Appendable._mapNext,
    );
    if (invert) {
      late final Node1Appendable<T> result;
      last.next = tail.iterator.inductInited<Node1Appendable<T>>((data) {
        result = head._construct(data, null);
        return result;
      }, (node, current) => node._construct(current, node));
      return result;
    }
    return tail.iterator.inductInited<Node1Appendable<T>>(
      (data) {
        last.next = head._construct(data, null);
        return last.next!;
      },
      (node, current) {
        node.next = node._construct(current, null);
        return node.next!;
      },
    );
  }
}

///
///
///
abstract class Node1Insertable<T> extends Node1<T>
    with
        _MNodeConstruct<T, Node1Insertable<T>>,
        MNodeInstance<T, Node1Insertable<T>>
    implements _IInsertable<T, void> {
  @override
  final NodeConstructor<T, Node1Insertable<T>> _construct;

  const Node1Insertable(this._construct);

  // return null if insertion failed
  @override
  void insert(T element, int index) {
    if (index.isNegative) throw Erroring.invalidIndex(index);
    var target = this;
    for (var i = 0; i < index; i++) {
      target = _mapNext(target) ?? (throw Erroring.invalidIntOver(i));
    }

    final preserved = target.next;
    try {
      target.next = target._construct(target.data, preserved);
      target.data = element;
    } on StateError catch (e) {
      if (e.message == Erroring.modifyImmutable) target.next = preserved;
      rethrow;
    }
  }

  ///
  ///
  ///
  const factory Node1Insertable.immutable(T data, [Node1Insertable<T>? next]) =
      _Node1InsertableImmutable<T>;

  factory Node1Insertable.unmodifiable(T data, [Node1Insertable<T>? next]) =
      _Node1InsertableUnmodifiable<T>;

  factory Node1Insertable.fixed(T data, [Node1Insertable<T>? next]) =
      _Node1InsertableFixed<T>;

  factory Node1Insertable.mutable(T data, [Node1Insertable<T>? next]) =
      _Node1InsertableMutable<T>;

  ///
  ///
  ///
  static Node1Insertable<T>? _mapNext<T>(Node1Insertable<T> node) => node.next;
}

///
///
/// [Qterator.empty], ...
/// [toString], ...
/// [lengthRemain], ...
///
///
class Qterator<T> with _MQterator<T, _Node1Enqueueable<T>> {
  @override
  final _Node1Enqueueable<T> _node;
  @override
  final Comparator<T>? _comparator;
  @override
  final ComparableState state;

  ///
  ///
  ///
  Qterator._(this._node, this._comparator, this.state)
    : assert(_comparator != null || <T>[] is List<Comparable>);

  factory Qterator.empty({
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
  }) => Qterator._(_Node1Enqueueable(), comparator, state);

  factory Qterator.of(
    T value, {
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
  }) => Qterator._(
    _Node1Enqueueable(null, _Node1Enqueueable(value)),
    comparator,
    state,
  );

  factory Qterator.ofIterable(
    Iterable<T> iterable, {
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
  }) => Qterator._(
    _Node1Enqueueable.fromIterable(iterable, state, comparator ?? _comparing),
    comparator,
    state,
  );

  ///
  ///
  ///
  @override
  String toString() =>
      'Qterator('
      '\n\tcurrent: ${_node._data},'
      '\n\tremain: ${_node.next.toString()}'
      '\n)';

  @override
  bool layby() {
    final data = _node._data;
    if (data == null) return false;
    _node._data = null;
    _node.next = _node._construct(data, _node.next);
    return true;
  }

  ///
  /// Notice that [enqueue] omits [current] data, which has better performance than considering [current] data.
  /// To take [current] into account, you can manually call [layby] before [enqueue].
  ///
  @override
  void enqueue(T element) =>
      _node.next = _node._constructNext(
        element,
        (child) => child..enqueue(element, comparator, state),
      );

  @override
  void enqueueAll(Iterable<T> iterable) =>
      _node.next = iterable.iterator.inductInited<_Node1Enqueueable<T>>(
        (data) => _node._construct(data, null),
        (node, element) => node..enqueue(element, comparator, state),
      );

  @override
  bool get isCleared => _node._data == null && _node.next == null;

  int get lengthRemain =>
      NodeExtension._lengthing(_node, _Node1Enqueueable.mapNext<T>);

  Iterable<T> get toIterable sync* {
    while (moveNext()) yield current;
  }
}

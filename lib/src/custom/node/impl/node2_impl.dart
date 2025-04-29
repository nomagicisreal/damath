part of '../../custom.dart';

///
///
/// * [Node2]
///     --[_MNodeNullablePrevious], [_MNodePrevious]
///     --[_MNodeNextPrevious]
///     |
///     --[_Node2Enqueueable]
///         --[_MNodeBidirectInsertableByInvalid], [_MNode2Enqueueable]
///         |   --[_NodeQueueComparedBidirect]      >>              [QteratorComparedBinary]--
///         |   --[_NodeQueueBidirect]              >>                      [QteratorBinary]--
///                                                                                         [_QteratorBinary]
///
///
///

///
///
///
abstract class Node2<T> extends Node1<T> {
  set previous(covariant Node2<T>? node) =>
      throw UnsupportedError(Erroring.modifyImmutable);

  Node2<T>? get previous;

  const Node2();

  static Node2<T>? mapPrevious<T>(Node2<T> node) => node.previous;

  @override
  String toString() =>
      'Node:'
      '\n\t${NodeExtension._buildString(this, (node) => node.previous)}'
      '\n\t${NodeExtension._buildString<Node1>(this, (node) => node.next)}';
}

//
mixin _MNodePrevious<T, N extends Node2<T>> on Node2<T>, _MNodeConstruct<T, N> {
  @override
  N? get previous;

  N _constructPrevious(T data, Applier<N> applyNotNull) =>
      previous == null ? _construct(data, null) : applyNotNull(previous!);

  void _pushPrevious(T data, Applier<N> nodingNotNull) =>
      previous = _constructPrevious(data, nodingNotNull);

  void _pushToPrevious(T data) {
    previous = _construct(this.data, previous);
    this.data = data;
  }
}

///
///
///
class _Node2Enqueueable<T> extends Node2<T>
    with
        _MVertexNullable<T>,
        _MNodeConstruct<T, _Node2Enqueueable<T>>,
        _MNodePrevious<T, _Node2Enqueueable<T>>,
        _MNodeNext<T, _Node2Enqueueable<T>>
    implements _INodeNullableData<T>, _IEnqueueable<T, void> {
  @override
  T? _data;
  @override
  _Node2Enqueueable<T>? next;
  @override
  _Node2Enqueueable<T>? previous;

  _Node2Enqueueable([this._data, this.next, this.previous]);

  _Node2Enqueueable._fromIterable(
    Iterable<T> iterable,
    Comparator<T> comparator,
    ComparableState state,
  ) : next = iterable.iterator.inductInited<_Node2Enqueueable<T>>(
        (data) => _Node2Enqueueable(data),
        (n, element) => n..enqueue(element, comparator, state),
      );

  ///
  ///
  ///
  @override
  NodeConstructor<T, _Node2Enqueueable<T>> get _construct =>
      (data, next) => _Node2Enqueueable(data, next);


  /// TODO: integrate with [_Node1Enqueueable.enqueue] !!
  @override
  void enqueue(
    T element, [
    Comparator<T>? comparator,
    ComparableState? state,
    _Enqueuer<T>? push,
    Consumer<T>? pushTo,
  ]) =>
      comparator!(element, data) == state!.value
          ? push!(element, comparator, state)
          : pushTo!(element);

  void _enqueueFirstNext(
    T element,
    Comparator<T> comparator,
    ComparableState state,
  ) {
    final next = this.next;
    final previous = this.previous;

    // push next no matter 'previous is null' or 'previous is valid to push'
    if (next == null ? true : comparator(element, next.data) == state.value) {
      return _pushNext(
        element,
        (next) =>
            next..enqueue(
              element,
              comparator,
              state,
              next._enqueueFirstNext,
              next._pushToNext,
            ),
      );
    }
    if (previous == null
        ? true
        : comparator(element, previous.data) == state.value) {
      return _pushPrevious(
        element,
        (previous) =>
            previous..enqueue(
              element,
              comparator,
              state,
              previous._enqueueFirstNext,
              previous._pushToNext,
            ),
      );
    }
    return _pushToNext(element);
  }
}

typedef _Enqueuer<T> =
    void Function(T element, Comparator<T> comparator, ComparableState state);

///
///
///
/// [QteratorBinary.suffixIncrease], ...
/// [QteratorBinary.empty], ...
///
///
class QteratorBinary<T> with _MQterator<T, _Node2Enqueueable<T>> {
  @override
  final _Node2Enqueueable<T> _node;
  @override
  final Comparator<T>? _comparator;
  @override
  final ComparableState state;

  ///
  ///
  ///
  final bool _firstNext;

  //
  // static _Node2Enqueueable<T>? _mapNext<T>(_Node2Enqueueable<T> node) =>
  //     node.next;
  //
  // static _Node2Enqueueable<T>? _mapPrevious<T>(_Node2Enqueueable<T> node) =>
  //     node.previous;

  ///
  ///
  ///
  QteratorBinary._(this._node, this._comparator, this.state, this._firstNext)
    : assert(_comparator != null || <T>[] is List<Comparable>);

  factory QteratorBinary.empty({
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
    bool firstNext = true,
  }) => QteratorBinary._(_Node2Enqueueable(), comparator, state, firstNext);

  factory QteratorBinary.of(
    T value, {
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
    bool firstNext = true,
  }) => QteratorBinary._(
    _Node2Enqueueable(null, _Node2Enqueueable(value)),
    comparator,
    state,
    firstNext,
  );

  factory QteratorBinary.ofIterable(
    Iterable<T> iterable, {
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
    bool firstNext = true,
  }) => QteratorBinary._(
    _Node2Enqueueable._fromIterable(
      iterable,
      comparator ?? _MQterator._comparing,
      state,
    ),
    comparator,
    state,
    firstNext,
  );

  ///
  ///
  ///
  @override
  String toString() =>
      'NodeQueue: ${_node.next.nullOrMap((node) => NodeExtension._buildString(node, (n) => n.next))}';

  @override
  bool layby([bool? toPrevious]) {
    final data = _node._data;
    if (data == null) return false;
    _node._data = null;
    if (ArgumentError.checkNotNull(toPrevious)) {
      _node.previous = _node._construct(data, _node.previous);
    } else {
      _node.next = _node._construct(data, _node.next);
    }
    return true;
  }

  ///
  /// To be consistent with [Qterator.enqueue], [enqueue] here also not considering [current].
  /// Manually call [layby] to take [current] into account.
  /// Notice that [enqueue]
  ///
  @override
  void enqueue(T element) {
    // final nodeNext = _node.next;
    // final nodePrevious = _node.previous;
    // final requiredNext =
    // nodeNext == null
    //     ? true
    //     : comparator(element, nodeNext.data) == state.value;
    // final requiredPrevious =
    // nodePrevious == null
    //     ? true
    //     : comparator(element, nodePrevious.data) == state.value;
    //
    // // firstNext enqueue
    // if (_firstNext) {
    //   _node.enqueue(element)
    // }
    //
    // // TODO: first previous enqueue
    //
    // comparator(element, _target) == state.value
    //     ? _node.previous = _node._constructPrevious(
    //   element,
    //   _insertNotNull(element),
    // )
    //     : _node.next = _node._constructNext(element, _insertNotNull(element));
  }

  @override
  void enqueueAll(Iterable<T> iterable) => throw UnimplementedError();

  // toPrevious
  //     ? _node.previous =
  // _node.previous == null
  //     ? iterable.iterator.inductInited<_Node2Enqueueable<T>>(
  //       (data) => _node._construct(data, null),
  //       (node, element) => _insertNotNull(element)(node),
  // )
  //     : _insertIterableNotNull(iterable)(_node.previous!)
  //     : _node.next =
  // _node.next == null
  //     ? iterable.iterator.inductInited<_Node2Enqueueable<T>>(
  //       (data) => _node._construct(data, null),
  //       (node, element) => _insertNotNull(element)(node),
  // )
  //     : _insertIterableNotNull(iterable)(_node.next!);

  @override
  bool get isCleared =>
      _node._data == null && _node.next == null && _node.previous == null;

  ///
  ///
  ///
  Applier<_Node2Enqueueable<T>> _insertNotNull(T e) =>
      (n) => n..enqueue(e, comparator);

  Applier<_Node2Enqueueable<T>> _insertIterableNotNull(Iterable<T> iterable) =>
      (child) => iterable.fold(
        child,
        (node, element) => node..enqueue(element, comparator),
      );
}

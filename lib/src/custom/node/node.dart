part of '../custom.dart';

///
///
/// * [Vertex]
///     --[NodeNext]
///         --[NodeNextInstance]
///         --[NodeNextContainer]
///         |
///         --[NodeNextOperatable]
///         --[NodeNextPushable]
///         --[NodeNextEnqueueable]
///         --[NodeNextSorted]
///         |
///         --[NodeBinary]
///             --[NodeBinaryInstance]
///             --[NodeBinaryContainer]
///             |
///             --[NodeBinaryEnqueueable]
///             --[NodeBinaryOrdered]
///             |
///
/// * [Nterator]
///
///
///

///
///
///
abstract final class Vertex<T> {
  @override
  String toString() => 'Vertex($data)';

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<T> other) => hashCode == other.hashCode;

  T get data;

  set data(T value) => throw UnsupportedError(Vertex.tryToModifyFinal);

  static const String tryToModifyFinal = 'vertex data is final';

  const factory Vertex.unmodifiable(T data) = _Vu;

  const factory Vertex.unmodifiableNullable([T? data]) = _VnU;

  factory Vertex.modifiable(T data) = _Vm;

  factory Vertex.modifiableNullable([T? data]) = _VnM;

  static Iterable<Vertex<T>> generate<T>(
    int length,
    Generator<T> generator,
    Mapper<T, Vertex<T>> construct,
  ) sync* {
    for (var i = 0; i < length; i++) yield construct(generator(i));
  }

  const Vertex();
}

///
/// with [NodeNext], instead of using [List],
/// we can define the state for each element:
///   - whether it is 'unmodifiable'. (the element data is modifiable or not)
///   - whether it is 'fixed'.        (the element can be linked to another element or not, or 'leaf of node' in term)
/// the node that is unmodifiable and fixed called 'immutable',
/// the node that is modifiable and growable (not fixed) called 'mutable'.
///
/// It's possible for a [NodeNext] linking with multiple <[T]> type,
/// because [N] instance called by [NodeNext.next] is [NodeNext] without <[T]>.
///
/// 'sealed' exhaustive doesn't works for generic. for example, [List]<[T]>  is not a valid covariance for [List].
///
abstract final class NodeNext<T, N extends NodeNext<T, N>> extends Vertex<T> {
  @override
  String toString() =>
      'Node(${NodeReader._lengthing<N>(this as N, NodeReader._mapNext)}): '
      '${NodeReader._buildString<N>(this as N, NodeReader._mapNext)}';

  N? get next;

  set next(covariant NodeNext<T, N>? node) =>
      throw UnsupportedError(NodeNext.tryToModifyFinal);

  static const String tryToModifyFinal = 'try to modify final node';

  ///
  /// [_construct] helps for hidden-chained operation for every useful node.
  ///
  /// Once upon a time, there is a field with type [NodeConstructor],
  /// the sad fact is that the generic function is not covariant to supertype function;
  /// for example, [Consumer]<[int]> cannot cast as [Consumer]<[Object]>. or it would be an exception at compile time:
  ///     ```
  ///     type '(int) => void' is not a subtype of type '(Object) => void' in type cast
  ///     ```
  /// Be as a function is much more flexible than be as a field.
  ///
  /// instead of typing [N] for [next] and return type, typing [NodeNext] enable subclass to cast into different subclass,
  /// which means we can change or disable the functionality of subclass. take [NodeNextAppendable.toFixed] for example,
  /// it's a getter from [NodeNextAppendable] to [NodeNextContainer],
  /// which disable the function [NodeNextAppendable.append] by cast into [NodeNextContainer].
  ///
  NodeNext _construct(T data, NodeNext? next);

  ///
  /// [generate] between 0 ~ [length]-1.
  ///
  /// for example,
  ///   [inOrder] = true
  ///   [length] = 5
  ///   [value] = (i) => i
  ///   [construct] = (i) => [NodeNextInsertable.immutable]
  /// returns Node(10): [0]--[1]--[2]--[3]--[4]
  ///
  static N generate<T, N extends NodeNext<T, N>>({
    bool inOrder = true,
    required int length,
    required Generator<T> value,
    required Generator<N Function(T data, N? next)> construct,
  }) {
    if (length < 1) throw Erroring.invalidInt(length);

    var i = inOrder ? length - 1 : 0;
    final limit = inOrder ? () => i > -1 : () => i < length;
    final next = inOrder ? () => i-- : () => i++;
    N node = construct(i)(value(i), null);
    for (next(); limit(); next()) {
      node = construct(i)(value(i), node);
    }
    return node;
  }

  const NodeNext();
}

///
/// it's a general node type that can be used together with [NodeReader] static functions.
/// some [NodeWriter] functions are allowed together if [NodeNextInstance] is not immutable.
///
abstract final class NodeNextInstance<T>
    extends NodeNext<T, NodeNextInstance<T>> {
  const NodeNextInstance();

  const factory NodeNextInstance.immutable(
    T data, [
    NodeNextInstance<T>? next,
  ]) = _NnIi;

  factory NodeNextInstance.unmodifiable(T data, [NodeNextInstance<T>? next]) =
      _NnIu;

  factory NodeNextInstance.fixed(T data, [NodeNextInstance<T>? next]) = _NnIf;

  factory NodeNextInstance.mutable(T data, [NodeNextInstance<T>? next]) = _NnIm;
}

///
/// it's a node type containing other node type, indicating its usecase is finished.
///
abstract final class NodeNextContainer<T, N extends NodeNext<T, N>>
    extends NodeNext<T, N> {
  const NodeNextContainer();
}

///
/// Notice that it's possible to have immutable operatable node,
/// - index assignment may not modify current node [data] and [next] by [NodeReader.index].
/// - appendage may not assign to current [data] or [next] by [NodeReader.last]
///
abstract final class NodeNextOperatable<T>
    extends NodeNext<T, NodeNextOperatable<T>>
    implements
        _I_NodeFinal<T, NodeNextOperatable<T>>,
        _I_NodeNextContainer<T, NodeNextOperatable<T>>,
        I_OperatableAppendable<T, NodeNextOperatable<T>>,
        I_OperatableIndexable<T>,
        I_OperatableIndexableAssignable<T> {
  //
  @override
  T operator [](int index) =>
      NodeReader.index<NodeNextOperatable<T>>(
        this,
        NodeReader._mapNext,
        index,
      ).data;

  @override
  NodeNextOperatable<T> operator +(covariant T tail) =>
      NodeReader.last<T, NodeNextOperatable<T>>(this, NodeReader._mapNext)
          .next = _construct(tail, null) as NodeNextOperatable<T>;

  @override
  void operator []=(int index, T element) =>
      NodeWriter.safePushCurrentToNext<T, NodeNextOperatable<T>>(
        NodeReader.index(this, NodeReader._mapNext, index),
        element,
      );

  ///
  ///
  ///
  const factory NodeNextOperatable.immutable(
    T data, [
    NodeNextOperatable<T>? next,
  ]) = _NnOi;

  factory NodeNextOperatable.unmodifiable(
    T data, [
    NodeNextOperatable<T>? next,
  ]) = _NnOu;

  factory NodeNextOperatable.fixed(T data, [NodeNextOperatable<T>? next]) =
      _NnOf;

  factory NodeNextOperatable.mutable(T data, [NodeNextOperatable<T>? next]) =
      _NnOm;

  const NodeNextOperatable();
}

///
/// Notice that it's not possible to have immutable or fixed [NodeNextPushable],
/// but it's possible to have unmodifiable node.
/// - [NodeWriter.safePushCurrentToNext] modify [data] and [next]
/// - [NodeWriter.newNextOrApply] modify [next]
///
abstract final class NodeNextPushable<T>
    extends NodeNext<T, NodeNextPushable<T>>
    implements
        _I_NodeFinal<T, NodeNextContainer<T, NodeNextPushable<T>>>,
        _I_NodeNextContainer<T, NodeNextPushable<T>>,
        I_Pushable<T, void> {
  //
  @override
  void push(T element, [bool onCurrent = true]) =>
      onCurrent
          ? NodeWriter.safePushCurrentToNext(this, element)
          : NodeWriter.newNextOrApply(this, element, _apply(element));

  static Applier<NodeNextPushable<T>> _apply<T>(T element) =>
      (node) => NodeWriter.safePushCurrentToNext(node, element);

  factory NodeNextPushable.unmodifiable(T data, [NodeNextPushable<T>? next]) =
      _NnPu;

  factory NodeNextPushable.mutable(T data, [NodeNextPushable<T>? next]) = _NnPm;

  const NodeNextPushable();
}

///
/// Notice that [NodeNextEnqueueable] is not always sorted.
/// It will only be sorted if provided [ComparableMethod] is always the same.
/// Considering performance, it's a class prevent replicating comparison as field or as method.
///
/// Notice that it's possible to have immutable enqueueable node,
/// it's possible for core function [enqueue] to invoke [NodeWriter.newNextOrApply],
/// which maybe not modify current node [data] and [next].
///
abstract final class NodeNextEnqueueable<T>
    extends NodeNext<T, NodeNextEnqueueable<T>>
    implements
        _I_NodeFinal<T, NodeNextEnqueueable<T>>,
        _I_NodeNextContainer<T, NodeNextEnqueueable<T>>,
        I_Enqueueable<T, void> {
  //
  @override
  void enqueue(T element, ComparableMethod<T> method) =>
      method.predicate(element, data)
          ? NodeWriter.newNextOrApply(this, element, _apply(element, method))
          : NodeWriter.safePushCurrentToNext(this, element);

  static Applier<NodeNextEnqueueable<T>> _apply<T>(
    T element,
    ComparableMethod<T> method,
  ) => (node) => node..enqueue(element, method);

  const factory NodeNextEnqueueable.immutable(
    T data, [
    NodeNextEnqueueable<T>? next,
  ]) = _NnEi;

  factory NodeNextEnqueueable.unmodifiable(
    T data, [
    NodeNextEnqueueable<T>? next,
  ]) = _NnEu;

  factory NodeNextEnqueueable.fixed(T data, [NodeNextEnqueueable<T>? next]) =
      _NnEf;

  factory NodeNextEnqueueable.mutable(T data, [NodeNextEnqueueable<T>? next]) =
      _NnEm;

  const NodeNextEnqueueable();
}

///
/// [NodeNextSorted] is the concise version of [NodeNextEnqueueable] for [Comparable]
///
abstract final class NodeNextSorted<C extends Comparable>
    extends NodeNext<C, NodeNextSorted<C>>
    implements
        _I_NodeFinal<C, NodeNextSorted<C>>,
        _I_NodeNextContainer<C, NodeNextSorted<C>>,
        I_Pushable<C, void> {
  //
  @override
  void push(C element) =>
      element.orderAfter(data)
          ? NodeWriter.newNextOrApply(this, element, _apply(element))
          : NodeWriter.safePushCurrentToNext(this, element);

  static Applier<NodeNextSorted<C>> _apply<C extends Comparable>(C element) =>
      (node) => node..push(element);

  const factory NodeNextSorted.immutable(C data, [NodeNextSorted<C>? next]) =
      _NnSi;

  factory NodeNextSorted.unmodifiable(C data, [NodeNextSorted<C>? next]) =
      _NnSu;

  factory NodeNextSorted.fixed(C data, [NodeNextSorted<C>? next]) = _NnSf;

  factory NodeNextSorted.mutable(C data, [NodeNextSorted<C>? next]) = _NnSm;

  const NodeNextSorted();
}

///
///
/// [Nterator.empty], ...
///
///
class Nterator<T, N extends NodeNext<T, N>> with _M_Nterator<T, N> {
  @override
  String toString() =>
      'Nterator( ${_node == null ? 'is empty' : '\n\tcurrent: ${_node?.data},'
              '\n\tnext: ${_node?.next.toString()}'
              '\n)'}';

  @override
  N? _node;

  Nterator._(this._node);

  factory Nterator.empty({
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
  }) => Nterator._(null);

  factory Nterator.of(
    N node, {
    Comparator<T>? comparator,
    ComparableState state = ComparableState.requireIncrease,
  }) => Nterator._(node);
}


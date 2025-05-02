part of '../custom.dart';

///
/// For [NodeBinary], there is no similar implementation be like [NodeNextOperatable]
/// Both of 'append data to farthest node' and 'insert data by index' are not a good ideas for [NodeBinary].
///   - it's unclear to append on [previous] or [next], even the most [previous] or the most [next].
///   - not only 'the most', there are also interval depths, e.g. [previous]'s [next], [next]'s [previous]'s [next]...
///   - insertion by positive index for [next], negative index for [previous] are bad to represent interval depths.
/// therefore, [NodeBinary] should implement something more useful other then [NodeNextOperatable].
///

///
/// property:
/// [previous], ...
///
/// static methods:
/// [_mapPrevious], ...
///
abstract final class NodeBinary<T, N extends NodeBinary<T, N>>
    extends NodeNext<T, N> {
  N? get previous;

  set previous(covariant NodeBinary<T, N>? node) =>
      throw UnsupportedError(NodeNext.tryToModifyFixed);

  @override
  NodeBinary _construct(
    T data,
    covariant NodeBinary? next, [
    // ignore: unused_element_parameter
    NodeBinary? previous,
  ]);

  @override
  String toString() =>
      'NodeBinary(${NodeBinary.size<N>(this as N, NodeBinary._mapPrevious, NodeNext._mapNext)}): '
      '\n${NodeBinary._string<T, N>(this as N, StringBuffer(), '  ')}';

  ///
  ///
  ///
  static N? _mapPrevious<T, N extends NodeBinary<T, N>>(N node) =>
      node.previous;

  static StringBuffer _string<T, N extends NodeBinary<T, N>>(
    N node,
    StringBuffer buffer, [
    String padding = '',
    String prefix = '+[',
    String suffix = ']',
    bool isTail = true,
  ]) {
    final previous = NodeBinary._mapPrevious<T, N>(node);
    final next = NodeNext._mapNext<T, N>(node);

    if (previous != null) {
      _string(
        previous,
        buffer,
        isTail ? '$padding│  ' : '$padding   ',
        prefix,
        suffix,
        false,
      );
    }
    buffer
      ..write(padding + (isTail ? "└──" : "┌──"))
      ..write(prefix)
      ..write(node.data)
      ..writeln(suffix);

    if (next != null) {
      _string(
        next,
        buffer,
        isTail ? '$padding   ' : '$padding│   ',
        prefix,
        suffix,
        true,
      );
    }
    return buffer;
  }

  const NodeBinary();

  ///
  ///
  ///
  static int size<N extends NodeNext<dynamic, N>>(
    N? node,
    Mapper<N, N?> mapNext,
    Mapper<N, N?> mapPrevious,
  ) {
    if (node == null) return 0;
    var i = 1;
    i += size(mapNext(node), mapNext, mapPrevious);
    i += size(mapPrevious(node), mapNext, mapPrevious);
    return i;
  }
}

///
/// [NodeBinaryInstance.immutable]
/// [NodeBinaryInstance.unmodifiable], ... 'Fp' stand for 'fixed previous'. 'Fn' stand for 'fixed next'
/// [NodeBinaryInstance.fixedPrevious], ...
/// [NodeBinaryInstance.mutable]
///
abstract final class NodeBinaryInstance<T>
    extends NodeBinary<T, NodeBinaryInstance<T>>
    implements _I_NodeBinaryFinal<NodeBinaryInstance<T>> {
  const factory NodeBinaryInstance.immutable(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIi;

  factory NodeBinaryInstance.unmodifiable(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIu;

  factory NodeBinaryInstance.unmodifiableFp(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIuFp;

  factory NodeBinaryInstance.unmodifiableFn(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIuFn;

  factory NodeBinaryInstance.fixedPrevious(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIfP;

  factory NodeBinaryInstance.fixedNext(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIfN;

  factory NodeBinaryInstance.fixed(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIf;

  factory NodeBinaryInstance.mutable(
    T data, [
    NodeBinaryInstance<T>? next,
    NodeBinaryInstance<T>? previous,
  ]) = _NbIm;

  const NodeBinaryInstance();
}

///
/// it's a node type containing other node type, indicating its usecase is finished.
///
abstract final class NodeBinaryContainer<T, N extends NodeBinary<T, N>>
    extends NodeBinary<T, N> {
  const NodeBinaryContainer();
}

///
/// [NodeBinaryEnqueueable]'s concept is derived from 'binary tree'. https://en.wikipedia.org/wiki/Binary_tree
///
/// For large data, [NodeBinaryEnqueueable] is efficient than [NodeBinaryEnqueueable].
/// Notice that 'large data' here is different from the term 'big data' in computer science.
/// for example 1,000 is large enough to be called as 'large data', but 'big data' goes far beyond that.
///
abstract final class NodeBinaryEnqueueable<T>
    extends NodeBinary<T, NodeBinaryEnqueueable<T>>
    implements
        _I_NodeBinaryFinal<NodeBinaryEnqueueable<T>>,
        _I_NodeBinaryContainer<T, NodeBinaryEnqueueable<T>>,
        I_Enqueueable<T, void> {
  @override
  void enqueue(T element, ComparableMethod<T> method) => NodeWriter.binary_push(
    this,
    element,
    method.predicate(element, data),
    method.predicate,
  );

  const factory NodeBinaryEnqueueable.immutable(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEi;

  factory NodeBinaryEnqueueable.unmodifiable(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEu;

  factory NodeBinaryEnqueueable.unmodifiableFp(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEuFp;

  factory NodeBinaryEnqueueable.unmodifiableFn(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEuFn;

  factory NodeBinaryEnqueueable.fixedPrevious(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEfP;

  factory NodeBinaryEnqueueable.fixedNext(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEfN;

  factory NodeBinaryEnqueueable.fixed(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEf;

  factory NodeBinaryEnqueueable.mutable(
    T data, [
    NodeBinaryEnqueueable<T>? next,
    NodeBinaryEnqueueable<T>? previous,
  ]) = _NbEm;

  const NodeBinaryEnqueueable();
}

///
///
///
abstract final class NodeBinarySorted<C extends Comparable>
    extends NodeBinary<C, NodeBinarySorted<C>>
    implements
        _I_NodeBinaryFinal<NodeBinarySorted<C>>,
        _I_NodeBinaryContainer<C, NodeBinarySorted<C>>,
        I_Pushable<C, void> {
  @override
  void push(C element) => NodeWriter.binary_push(
    this,
    element,
    element.orderAfter(data),
    DamathComparableExtension.comparator_orderAfter<C>,
  );

  const factory NodeBinarySorted.immutable(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSi;

  factory NodeBinarySorted.unmodifiable(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSu;

  factory NodeBinarySorted.unmodifiableFp(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSuFp;

  factory NodeBinarySorted.unmodifiableFn(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSuFn;

  factory NodeBinarySorted.fixedPrevious(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSfP;

  factory NodeBinarySorted.fixedNext(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSfN;

  factory NodeBinarySorted.fixed(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSf;

  factory NodeBinarySorted.mutable(
    C data, [
    NodeBinarySorted<C>? next,
    NodeBinarySorted<C>? previous,
  ]) = _NbSm;

  const NodeBinarySorted();
}

// future:
// 1. identical enqueueable,
// 2. n-ary node

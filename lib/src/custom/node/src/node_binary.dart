part of '../node.dart';

///
///
/// * [NodeBinary]
///     --[NodeBinaryInstance]
///     --[NodeBinaryContainer]
///     |
///     --[NodeBinaryEnqueueable]
///     --[NodeBinarySorted]
///     --[NodeBinaryAvl]
///     |
///
///

///
///
///
typedef NodeBinaryConstructor<T, N extends NodeBinary<T, N>> =
    N Function(T data, [N? next, N? previous]);

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
/// [binarySize], ...
///
/// static methods:
/// [toString], ...
/// [iterableFrom], ...
/// [any], ...
///
abstract final class NodeBinary<T, N extends NodeBinary<T, N>>
    extends NodeNext<T, N> {
  N? get previous;

  set previous(covariant NodeBinary<T, N>? node) =>
      throw UnsupportedError(NodeNext.tryToModifyFixed);

  int get binarySize {
    var i = 1;
    i += previous?.binarySize ?? 0;
    i += next?.binarySize ?? 0;
    return i;
  }

  @override
  NodeBinary _construct(
    T data,
    covariant NodeBinary? next, [
    // ignore: unused_element_parameter
    NodeBinary? previous,
  ]);

  const NodeBinary();

  @override
  String toString() =>
      'NodeBinary($binarySize): '
      '\n${NodeBinary._string<T, N>(this as N, StringBuffer(), '  ')}';

  ///
  ///
  ///
  static StringBuffer _string<T, N extends NodeBinary<T, N>>(
    N node,
    StringBuffer buffer, [
    String padding = '',
    String prefix = '+[',
    String suffix = ']',
    bool isTail = true,
  ]) {
    final previous = node.previous;
    final next = node.next;

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

  ///
  ///
  ///
  static Iterable<T> iterableFrom<T, N extends NodeBinary<T, N>>(
    N? node,
  ) sync* {
    if (node == null) return;
    yield* iterableFrom(node.previous);
    yield node.data;
    yield* iterableFrom(node.next);
  }

  // previous current next
  static void traversal_pcn<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    traversal_pcn(node.previous, consume);
    consume(node.data);
    traversal_pcn(node.next, consume);
  }

  // previous next current
  static void traversal_pnc<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    traversal_pnc(node.previous, consume);
    traversal_pnc(node.next, consume);
    consume(node.data);
  }

  // current previous next
  static void traversal_cpn<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    consume(node.data);
    traversal_cpn(node.previous, consume);
    traversal_cpn(node.next, consume);
  }

  // current next previous
  static void traversal_cnp<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    consume(node.data);
    traversal_cnp(node.next, consume);
    traversal_cnp(node.previous, consume);
  }

  // next current previous
  static void traversal_ncp<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    traversal_ncp(node.next, consume);
    consume(node.data);
    traversal_ncp(node.previous, consume);
  }

  // next previous current
  static void traversal_npc<T, N extends NodeBinary<T, N>>(
    N? node,
    Consumer<T> consume,
  ) {
    if (node == null) return;
    traversal_npc(node.next, consume);
    traversal_npc(node.previous, consume);
    consume(node.data);
  }

  ///
  ///
  ///
  static bool any<T, N extends NodeBinary<T, N>>(N node, Predicator<T> test) {
    try {
      traversal_cnp<T, N>(node, (data) {
        if (test(data)) throw ErrorMessage.pass;
      });
      return false;
    } on String catch (message) {
      return message == ErrorMessage.pass;
    }
  }

  static bool contains<T, N extends NodeBinary<T, N>>(N node, T element) =>
      NodeBinary.any<T, N>(node, (data) => data == element);

  ///
  ///
  ///
  static N leadOf<T, N extends NodeBinary<T, N>>(N node) =>
      node.previous.nullOrMap(leadOf<T, N>) ?? node;

  static int depthNextOf<T, N extends NodeBinary<T, N>>(N node) {
    final next = node.next;
    return next == null ? 0 : 1 + NodeBinary.depthOf(next);
  }

  static int depthPreviousOf<T, N extends NodeBinary<T, N>>(N node) {
    final previous = node.previous;
    return previous == null ? 0 : 1 + NodeBinary.depthOf(previous);
  }

  static int depthOf<T, N extends NodeBinary<T, N>>(N node) =>
      math.max(NodeBinary.depthNextOf(node), NodeBinary.depthPreviousOf(node));

  static int heightOf<T, N extends NodeBinary<T, N>>(N node) =>
      NodeBinary.depthOf(node) + 1;
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
    extends NodeBinary<T, N>
    implements _I_NodeBinaryFinal<NodeBinaryContainer<T, N>> {
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
    with _M_VertexComparable<C>
    implements
        _I_NodeBinaryFinal<NodeBinarySorted<C>>,
        _I_NodeBinaryContainer<C, NodeBinarySorted<C>>,
        I_Pushable<C, void> {
  @override
  void push(C element) => NodeWriter.binary_push(
    this,
    element,
    element.orderAfter(data),
    ComparableExtension.orderingAfter<C>,
  );

  const factory NodeBinarySorted.immutable(C data) = _NbSi;

  factory NodeBinarySorted.unmodifiable(C data) = _NbSu;

  factory NodeBinarySorted.unmodifiableFp(C data) = _NbSuFp;

  factory NodeBinarySorted.unmodifiableFn(C data) = _NbSuFn;

  factory NodeBinarySorted.fixedPrevious(C data) = _NbSfP;

  factory NodeBinarySorted.fixedNext(C data) = _NbSfN;

  factory NodeBinarySorted.fixed(C data) = _NbSf;

  factory NodeBinarySorted.mutable(C data) = _NbSm;

  ///
  ///
  ///
  factory NodeBinarySorted.fromSorted(
    List<C> list, {
    bool increase = true,
    NodeBinaryConstructor<C, NodeBinarySorted<C>>? constructor,
  }) => list.checkSortedForSupply(() {
    final construct = constructor ?? NodeBinarySorted<C>.mutable;
    if (list.isEmpty) throw StateError(ErrorMessage.iterableNoElement);

    // with full size 'previous' node
    NodeBinarySorted<C> child(int from, int count) {
      if (count == 1) return construct(list[from]);
      final mid = IntExtension.maxPow2In(count); // 'count ≥ 2' -> 'mid ≥ 2'
      final node = construct(list[from + mid - 1]);
      node.previous = child(from, mid - 1); // 'mid - 1' always ≥ 1
      if (count > mid) {
        node.next = child(from + mid, count - mid); // 'count - mid' always ≥ 1
      }
      return node;
    }

    return child(0, list.length);
  }, increase);

  const NodeBinarySorted();
}

///
/// Notice that [NodeBinaryAvl.fromSorted] is the balanced version of [NodeBinarySorted.fromSorted].
/// [_balance], ...
///
abstract final class NodeBinaryAvl<C extends Comparable>
    extends NodeBinarySorted<C> {
  NodeBinarySorted<C> get root;

  factory NodeBinaryAvl(C data) = _NbAvl;

  factory NodeBinaryAvl.fromSorted(List<C> list, {bool increase = true}) =>
      list.checkSortedForSupply(() {
        if (list.isEmpty) throw StateError(ErrorMessage.iterableNoElement);

        NodeBinaryAvl<C>? build(int previous, int next) {
          if (previous > next) return null;
          final mid = (previous + next) ~/ 2;
          return NodeBinaryAvl(list[mid])
            ..previous = build(previous, mid - 1)
            ..next = build(mid + 1, next);
        }

        return build(0, list.length - 1)!;
      }, increase);

  ///
  /// implementation for avl tree https://en.wikipedia.org/wiki/AVL_tree
  /// in short, with [_balance] function each time insert. we can have lower average time complexity.
  ///
  /// [_balanceFactor] = 2 implies [depthPreviousOf] ≥ 2 implies [previous] != null
  /// [_balanceFactor] = -2 implies [depthNextOf] ≥ 2 implies [next] != null
  ///
  static N _balance<T, N extends NodeBinary<T, N>>(N node) =>
      switch (NodeBinaryAvl._balanceFactor(node)) {
        2 =>
          NodeBinaryAvl._balanceFactor<T, N>(node.previous!) < 0
              // depthNext > depthPrevious
              ? NodeBinaryAvl._rotateCBeforeCC(node)
              : NodeBinaryAvl._rotateCounterClockwise(node),
        -2 =>
          NodeBinaryAvl._balanceFactor<T, N>(node.next!) > 0
              // depthPrevious > depthNext
              ? NodeBinaryAvl._rotateCCBeforeC(node)
              : NodeBinaryAvl._rotateClockwise(node),
        _ => node,
      };

  static int _balanceFactor<T, N extends NodeBinary<T, N>>(N node) =>
      NodeBinary.depthPreviousOf(node) - NodeBinary.depthNextOf(node);

  ///
  /// it's easier to understand when imaging rotation with [NodeBinary.toString],
  /// - the previous node is on the top
  /// - the next node is on the bottom
  ///
  static N _rotateCounterClockwise<T, N extends NodeBinary<T, N>>(N node) {
    final pivot = node.previous!;
    node.previous = pivot.next;
    pivot.next = node;
    return pivot;
  }

  static N _rotateClockwise<T, N extends NodeBinary<T, N>>(N node) {
    final pivot = node.next!;
    node.next = pivot.previous;
    pivot.previous = node;
    return pivot;
  }

  static N _rotateCBeforeCC<T, N extends NodeBinary<T, N>>(N node) {
    node.previous = NodeBinaryAvl._rotateClockwise<T, N>(node.previous!);
    NodeBinaryAvl._rotateCounterClockwise<T, N>(node);
    return node;
  }

  static N _rotateCCBeforeC<T, N extends NodeBinary<T, N>>(N node) {
    node.next = NodeBinaryAvl._rotateCounterClockwise<T, N>(node.next!);
    NodeBinaryAvl._rotateClockwise<T, N>(node);
    return node;
  }

  const NodeBinaryAvl._();
}

// future:
// 1. identical enqueueable,
// 2. n-ary node, NodeTrie

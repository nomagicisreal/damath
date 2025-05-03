part of '../node.dart';

///
///
/// * [NodeWriter]
///
///

// enum NodeInstanceState {
//   mutable,
//   fixed,
//   unmodifiable,
//   immutable;
// }

///
/// [NodeWriter.next_append], ...
/// [NodeWriter.binary_push], ...
///
abstract final class NodeWriter {
  const NodeWriter();

  ///
  ///
  /// there is no [NodeWriter.appendIterable] or [NodeWriter.insertIterable],
  /// using [NodeNext.generate] then append or insert instead.
  /// but there is [I_Enqueueable.enqueueIterable]
  ///
  ///

  ///
  /// [NodeWriter.next_append] for example,
  ///   [head] = [1]--[2]              [head] = [1]--[2]--[a]--[b]--[c]
  ///   [tail] = [a]--[b]--[c]    =>   returns [head]
  ///
  /// Notice that the [NodeNext.next] must [NodeNext.beGrowable] on the last node of [head]
  ///
  static N next_append<T, N extends NodeNext<T, N>>(N head, N? tail) =>
      NodeNext.lastOf<T, N>(head)..next = tail;

  ///
  /// [NodeWriter.next_pushInsert] for example,
  ///   [source] = [1]--[2]--[3]--[4]           [source] = [1]--[a]--[b]--[c]
  ///   [position] = 1                   =>       returns [2]--[3]--[4]
  ///   [insertion] = [a]--[b]--[c]             [insertion] = [a]--[b]--[c]
  ///
  /// Notice that the [NodeNext.next] must [NodeNext.beGrowable] on [position] node of [source]
  ///
  static N? next_pushInsert<T, N extends NodeNext<T, N>>(
    N source,
    int position,
    N insertion,
  ) {
    final target = NodeNext.indexOf(source, position - 1);
    final tempt = target.next;
    target.next = insertion;
    return tempt;
  }

  ///
  ///
  ///
  static N next_pushCurrentToNext<T, N extends NodeNext<T, N>>(
    N node,
    T element,
  ) {
    final preserved = node.next;
    try {
      return node
        ..next = node._construct(node.data, preserved) as N
        ..data = element;
    } on StateError catch (e) {
      if (e.message == Vertex.tryToModifyUnmodifiable) node.next = preserved;
      rethrow;
    }
  }

  static N next_pushNext<T, N extends NodeNext<T, N>>(
    N node,
    T element,
    Applier<N> apply,
  ) =>
      node
        ..next =
            node.next == null
                ? node._construct(element, null) as N
                : apply(node.next!);

  ///
  /// assert [NodeBinary.next] data >= [NodeBinary.data] >= [NodeBinary.previous] data always true
  ///
  static void binary_push<T, N extends NodeBinary<T, N>>(
    N node,
    T data,
    bool elementOrderAfterCurrent,
    PredicatorReducer<T> compare,
  ) {
    // construct next || continue order element on next
    if (elementOrderAfterCurrent) {
      final n = node.next;
      if (n == null) {
        node.next = node._construct(data, null) as N;
        return;
      }
      NodeWriter.binary_push(n, data, compare(data, n.data), compare);
      return;
    }

    // construct previous || continue order element on previous
    final p = node.previous;
    if (p == null) {
      node.previous = node._construct(data, null) as N;
      return;
    }
    NodeWriter.binary_push(p, data, compare(data, p.data), compare);
  }
}

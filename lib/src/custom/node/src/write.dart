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
      NodeNext.last<T, N>(head)..next = tail;

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
    final target = NodeNext.index(source, position - 1);
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
  static N binary_push<T, N extends NodeBinary<T, N>>(
    N node,
    T element,
    bool elementOrderAfterCurrent,
    PredicatorReducer<T> comparing,
  ) {
    // 1. construct next
    // 2. continue order element on next
    // 3. push element back to previous, construct previous
    // 4. push element back to previous, continue order data on previous
    if (elementOrderAfterCurrent) {
      final next = node.next;
      if (next == null) {
        return node..next = node._construct(element, null) as N;
      }
      if (comparing(element, next.data)) {
        NodeWriter.binary_push(next, element, true, comparing);
        return node;
      }
      final previous = node.previous;
      if (previous == null) {
        return node
          ..previous = node._construct(node.data, null) as N
          ..data = element;
      }
      NodeWriter.binary_push(
        previous,
        node.data,
        comparing(node.data, previous.data),
        comparing,
      );
      return node..data = element;
    }

    // 1. construct previous
    // 2. continue order element on previous
    // 3. push element forward to next, construct next
    // 4. push element forward to next, continue order data on next
    final previous = node.previous;
    if (previous == null) {
      return node..previous = node._construct(element, null) as N;
    }
    if (comparing(previous.data, element)) {
      NodeWriter.binary_push(previous, element, false, comparing);
      return node;
    }
    final next = node.next;
    if (next == null) {
      return node
        ..next = node._construct(node.data, null) as N
        ..data = element;
    }
    NodeWriter.binary_push(
      next,
      node.data,
      comparing(node.data, next.data),
      comparing,
    );
    return node..data = element;
  }
}

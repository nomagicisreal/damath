part of '../custom.dart';

///
///
/// * [NodeReader]
/// * [NodeWriter]
///
///

///
///
///
// enum NodeInstanceState {
//   mutable,
//   fixed,
//   unmodifiable,
//   immutable;
// }

///
///
/// [beModifiable], ...
/// [iterableFrom], ...
/// [_mapNext], ...
/// [_lengthing], ...
/// [_buildString], ...
///
///
abstract final class NodeReader<T> {
  const NodeReader();

  ///
  ///
  ///
  static bool beModifiable<N extends NodeNext<dynamic, N>>(N node) {
    try {
      node.data = node.data;
      return true;
    } on StateError catch (e) {
      if (e.message == Vertex.tryToModifyFinal) return false;
      rethrow;
    }
  }

  static bool beGrowable<N extends NodeNext<dynamic, N>>(N node) {
    try {
      node.next = node.next;
      return true;
    } on StateError catch (e) {
      if (e.message == NodeNext.tryToModifyFinal) return false;
      rethrow;
    }
  }

  ///
  /// prevent redundant functionality in [DamathIterator], ...
  ///
  static Iterable<T> iterableFrom<T, N extends NodeNext<T, N>>(
    N? node,
    Mapper<N, N?> mapNext,
  ) sync* {
    for (; node != null; node = mapNext(node)) yield node.data;
  }

  static void mapAllData<T, N extends NodeNext<T, N>>(
    N? node,
    Mapper<N, N?> mapNext,
    Mapper<T, T> map,
  ) {
    for (; node != null; node = mapNext(node)) node.data = map(node.data);
  }

  ///
  ///
  ///
  static N? _mapNext<T, N extends NodeNext<T, N>>(N node) => node.next;

  static N? _mapPrevious<T, N extends NodeBinary<T, N>>(N node) =>
      node.previous;

  ///
  ///
  ///
  static int _lengthing<N extends NodeNext<dynamic, N>>(
    N? node,
    Mapper<N, N?> mapNext,
  ) {
    var i = 0;
    for (; node != null; i++, node = mapNext(node)) {}
    return i;
  }

  static N last<T, N extends NodeNext<T, N>>(N node, Mapper<N, N?> mapNext) {
    while (true) {
      final next = mapNext(node);
      if (next == null) return node;
      node = next;
    }
  }

  static N index<N extends NodeNext<dynamic, N>>(
    N node,
    Mapper<N, N?> mapNext,
    int index,
  ) {
    if (index.isNegative) throw Erroring.invalidIndex(index);
    for (var i = 0; i < index; i++) {
      node = mapNext(node) ?? (throw Erroring.invalidIntOver(i));
    }
    return node;
  }

  ///
  ///
  ///
  static String _buildString<N extends NodeNext<dynamic, N>>(
    N node,
    Mapper<N, N?> map, {
    String prefix = '[',
    String between = ']--[',
    String suffix = ']',
  }) {
    final buffer = StringBuffer(prefix);

    N? n = node;
    buffer.write(_M_VertexNullable.dataOrNull<dynamic, N>(n));
    for (n = map(n); n != null; n = map(n)) {
      buffer.write('$between${_M_VertexNullable.dataOrNull<dynamic, N>(n)}');
    }
    buffer.write(suffix);

    return buffer.toString();
  }
}

///
/// [NodeWriter.append], [NodeWriter.insert],
/// [NodeWriter.safePushCurrentToNext], ...
/// [NodeWriter.safePushCurrentToPrevious], ...
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
  /// [NodeWriter.append] for example,
  ///   [head] = [1]--[2]              [head] = [1]--[2]--[a]--[b]--[c]
  ///   [tail] = [a]--[b]--[c]    =>   returns [head]
  ///
  /// Notice that the [NodeNext.next] must [NodeReader.beGrowable] on the last node of [head]
  ///
  static N append<T, N extends NodeNext<T, N>>(N head, N? tail) =>
      NodeReader.last<T, N>(head, NodeReader._mapNext)..next = tail;

  ///
  /// [NodeWriter.insert] for example,
  ///   [source] = [1]--[2]--[3]--[4]           [source] = [1]--[a]--[b]--[c]
  ///   [position] = 1                   =>       returns [2]--[3]--[4]
  ///   [insertion] = [a]--[b]--[c]             [insertion] = [a]--[b]--[c]
  ///
  /// Notice that the [NodeNext.next] must [NodeReader.beGrowable] on [position] node of [source]
  ///
  static N? insert<T, N extends NodeNext<T, N>>(
    N source,
    int position,
    N insertion,
  ) {
    final target = NodeReader.index(
      source,
      NodeReader._mapNext<T, N>,
      position - 1,
    );
    final tempt = target.next;
    target.next = insertion;
    return tempt;
  }

  ///
  ///
  ///
  static N safePushCurrentToNext<T, N extends NodeNext<T, N>>(
    N node,
    T element,
  ) {
    final preserved = node.next;
    try {
      return node
        ..next = node._construct(node.data, preserved) as N
        ..data = element;
    } on StateError catch (e) {
      if (e.message == Vertex.tryToModifyFinal) node.next = preserved;
      rethrow;
    }
  }

  static N safePushCurrentToPrevious<T, N extends NodeBinary<T, N>>(
    N node,
    T element,
  ) {
    final preserved = node.previous;
    try {
      return node
        ..previous = node._construct(node.data, preserved) as N
        ..data = element;
    } on StateError catch (e) {
      if (e.message == Vertex.tryToModifyFinal) node.previous = preserved;
      rethrow;
    }
  }

  ///
  ///
  ///
  static N newNextOrApply<T, N extends NodeNext<T, N>>(
    N node,
    T element,
    Applier<N> apply,
  ) =>
      node
        ..next =
            node.next == null
                ? node._construct(element, null) as N
                : apply(node.next!);

  static N newPreviousOrApply<T, N extends NodeBinary<T, N>>(
    N node,
    T element,
    Applier<N> apply,
  ) =>
      node
        ..previous =
            node.previous == null
                ? node._construct(element, node.previous) as N
                : apply(node.previous!);

  ///
  /// assert [NodeBinary.next] data >= [NodeBinary.data] >= [NodeBinary.previous] data always true
  ///
  static N push_binary<T, N extends NodeBinary<T, N>>(
    N node,
    T element,
    bool elementOrderAfterCurrent,
    PredicatorReducer<T> comparing,
  ) {
    final next = node.next;
    final previous = node.previous;

    // on next first || push current to next
    if (next == null) {
      return elementOrderAfterCurrent
          ? (node..next = node._construct(element, null) as N)
          : (node
            ..next = node._construct(node.data, null) as N
            ..data = element);
    }

    // push current to previous || on previous
    if (previous == null) {
      return elementOrderAfterCurrent
          ? (node
            ..previous = node._construct(node.data, null) as N
            ..data = element)
          : (node..previous = node._construct(element, null) as N);
    }

    // assert next.data ≥ node.data ≥ previous.data
    assert(
      comparing(next.data, node.data) &&
          comparing(node.data, previous.data),
    );

    // continue order on next node || push current to previous
    if (elementOrderAfterCurrent) {
      if (comparing(element, next.data)) {
        NodeWriter.push_binary(next, element, true, comparing);
        return node;
      }
      return NodeWriter.safePushCurrentToPrevious(node, element);
    }

    // push previous to its next || continue order on previous node
    if (comparing(element, previous.data)) {
      NodeWriter.safePushCurrentToNext(previous, element);
      return node;
    }
    return NodeWriter.push_binary(previous, element, false, comparing);
  }
}

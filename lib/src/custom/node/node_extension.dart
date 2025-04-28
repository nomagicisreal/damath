part of '../custom.dart';

///
///
/// * [NodeConstructor]
/// * [NodeExtension]
///
///

///
///
///
typedef NodeConstructor<T, N extends Node1<T>> = N Function(T data, N? next);

///
///
/// [generating], ...
/// [lengthing]
/// [_buildString], ...
///
///
extension NodeExtension<T> on Node1<T> {
  ///
  ///
  ///
  static N generating<T, N extends Node1<T>>(
    int length,
    Generator<T> generator,
    NodeConstructor<T, N> construct,
  ) {
    if (length < 1) throw RangeError.range(length, 0, null);
    N current = construct(generator(0), null);
    for (var i = length; i > 0; i--) {
      current = construct(generator(i), current);
    }
    return current;
  }

  static void consumeAll<T, N extends Node1<T>>({
    required N? node,
    required Mapper<N, N?> map,
    required Consumer<N> consume,
  }) {
    for (; node != null; node = map(node)) consume(node);
  }

  static bool any<T, N extends Node1<T>>(
    N? node,
    Mapper<N, N?> map, {
    required Predicator<N> condition,
  }) {
    for (; node != null; node = map(node)) if (condition(node)) return true;
    return false;
  }

  static Iterable<T> toIterable<T>(Node1<T>? node) sync* {
    for (; node != null; node = node.next) yield node.data;
  }

  ///
  ///
  ///
  static int lengthing<N extends Node1>(
    N node,
    Mapper<N, N?> map, [
    bool includeCurrent = true,
  ]) {
    var next = map(node);
    var i = includeCurrent ? 1 : 0;
    for (; next != null; i++, next = map(next)) {}
    return i;
  }

  static N indexing<N extends Node1>(N node, Mapper<N, N?> map, int index) {
    if (index < -1) throw RangeError.range(index, 0, null);
    for (var j = 0; j < index; j++) {
      node = map(node) ?? (throw RangeError.range(j, 0, j - 1));
    }
    return node;
  }

  static N last<T, N extends Node1<T>>(N node, Mapper<N, N?> map) {
    while (true) {
      final next = map(node);
      if (next == null) return node;
      node = next;
    }
  }

  static void appendNode<T>(
    NodeAppendable<T> node,
    NodeAppendable<T> appended,
  ) => NodeExtension.last(node, NodeAppendable.mapNext).next = appended;

  static NodeAppendable<T> appendIterable<T>(
    NodeAppendable<T> node,
    Iterable<T> iterable, [
    bool invert = false,
  ]) {
    final last = NodeExtension.last<T, NodeAppendable<T>>(
      node,
      NodeAppendable.mapNext,
    );
    if (invert) {
      late final NodeAppendable<T> result;
      last.next = iterable.iterator.inductInited<NodeAppendable<T>>((data) {
        result = node._construct(data, null);
        return result;
      }, (node, current) => node._construct(current, node));
      return result;
    }
    return iterable.iterator.inductInited<NodeAppendable<T>>(
      (data) {
        last.next = node._construct(data, null);
        return last.next!;
      },
      (node, current) {
        node.next = node._construct(current, null);
        return node.next!;
      },
    );
  }

  ///
  /// it's possible that [Node1.data] getter get an error message [ErrorMessages.receiveNull],
  /// See Also: [_VertexMutableNullable.data]
  ///
  static String _buildString<N extends Node1>(
    N node,
    Mapper<N, N?> map, [
    String prefix = '--',
  ]) {
    final buffer = StringBuffer();
    try {
      buffer.write('${node.data}');
      for (var n = map(node); n != null; n = map(n)) {
        buffer.write('$prefix${n.data}');
      }
    } on StateError catch (e) {
      if (e.message != ErrorMessages.receiveNull) rethrow;
      buffer.write('${prefix}null');
    }
    return buffer.toString();
  }
}

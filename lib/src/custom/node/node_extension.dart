part of '../custom.dart';

///
///
/// * [NodeConstructor]
/// * [NodeExtension]
///
/// * [_IAppendable]
/// * [_IInsertable]
/// * [_IEnqueueable]
/// * [_ILayby]
///
///

///
///
///
typedef NodeConstructor<T, N extends Node1<T>> = N Function(T data, N? next);

///
///
/// [generatingVertex], ...
/// [_lengthing]
/// [_buildString], ...
///
///
extension NodeExtension<T> on Node1<T> {
  ///
  ///
  ///
  static Iterable<Vertex<T>> generatingVertex<T>(
    int length,
    Generator<T> generator,
    Mapper<T, Vertex<T>> construct,
  ) sync* {
    for (var i = 0; i < length; i++) {
      yield construct(generator(i));
    }
  }

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
  static int _lengthing<N extends Node1>(
    N node,
    Mapper<N, N?> map, [
    bool includeCurrent = true,
  ]) {
    var next = map(node);
    var i = includeCurrent ? 1 : 0;
    for (; next != null; i++, next = map(next)) {}
    return i;
  }

  static N indexing<N extends Node1>(
    N node,
    Mapper<N, N?> map,
    int index, {
    Predicator<int> validate = IntExtension.predicate_negative,
    Mapper<int, Error> errorIndex = Erroring.invalidIndex,
  }) {
    if (validate(index)) throw errorIndex(index);
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

  ///
  /// it's possible that [Node1.data] getter get an error message [Erroring.receiveNull],
  /// See Also: [_VertexMutableNullable.data]
  ///
  static String? _buildStringDataOrNull<N extends Node1>(N node) {
    try {
      return node.data;
    } on StateError catch (e) {
      if (e.message == Erroring.receiveNull) return null;
      rethrow;
    }
  }

  static String _buildString<N extends Node1>(
    N node,
    Mapper<N, N?> map, {
    String prefix = '[',
    String between = ']--[',
    String suffix = ']',
  }) {
    final buffer = StringBuffer(prefix);

    N? current = node;
    buffer.write(_buildStringDataOrNull(current));
    for (; current != null; current = map(current)) {
      buffer.write('$between${_buildStringDataOrNull(current)}');
    }
    buffer.write(suffix);

    return buffer.toString();
  }
}

///
/// To improve performance of concrete instance, the methods should be as less as possible.
/// 'all' operation is better defined as static methods. (append all, insert all, enqueue all)
///
abstract interface class _IAppendable<T, S> {
  S append(T tail);
}

abstract interface class _IInsertable<T, S> {
  S insert(T element, int index);
}

abstract interface class _IEnqueueable<T, S> {
  S enqueue(T element);
}

abstract interface class _ILayby<S> {
  S layby();
}

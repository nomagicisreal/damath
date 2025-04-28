part of '../custom.dart';

///
///
/// * [Vertex]
/// * [NodeAppendable]
///
///
///
///
///

///
/// [generate], ...
/// [toString], ...
///
abstract class Vertex<T> {
  T get data;

  set data(T value) => throw StateError(ErrorMessages.modifyImmutable);

  const Vertex();

  const factory Vertex.immutable(T data) = _VertexImmutable<T>;

  factory Vertex.mutable(T data) = _VertexMutable<T>;

  const factory Vertex.immutableNullable([T? data]) =
      _VertexImmutableNullable<T>;

  factory Vertex.mutableNullable([T? data]) = _VertexMutableNullable<T>;

  ///
  ///
  ///
  static Iterable<Vertex<T>> generate<T>(
    int length,
    Generator<T> generator,
    Mapper<T, Vertex<T>> construct,
  ) sync* {
    for (var i = 0; i < length; i++) {
      yield construct(generator(i));
    }
  }

  ///
  ///
  ///
  @override
  String toString() => 'Vertex($data)';

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<T> other) => hashCode == other.hashCode;
}

///
///
/// [NodeAppendable._predicateModifiable], ...
/// [NodeAppendable.unmodifiable], ...
/// [append], ...
///
///
abstract class NodeAppendable<T> extends Node1<T>
    with _MNodeNew<T, NodeAppendable<T>>, _MNodeNext<T, NodeAppendable<T>> {
  @override
  final NodeConstructor<T, NodeAppendable<T>> _construct;

  const NodeAppendable(this._construct);

  static NodeAppendable<T>? mapNext<T>(NodeAppendable<T> node) => node.next;

  ///
  ///
  ///
  static bool _predicateModifiable(NodeAppendable node) {
    try {
      node.data = node.data;
    } on StateError catch (e) {
      if (e.message == ErrorMessages.modifyImmutable) return false;
      rethrow;
    }
    return true;
  }

  static bool _predicateGrowable(NodeAppendable node) {
    try {
      node.next = node.next;
    } on StateError catch (e) {
      if (e.message == ErrorMessages.modifyImmutable) return false;
      rethrow;
    }
    return true;
  }

  static bool predicateUnmodifiable(NodeAppendable node, [bool all = true]) =>
      all
          ? !NodeExtension.any(node, mapNext, condition: _predicateModifiable)
          : !_predicateModifiable(node);

  static bool predicateFixed(NodeAppendable node, [bool all = true]) =>
      all
          ? !NodeExtension.any(node, mapNext, condition: _predicateGrowable)
          : !_predicateGrowable(node);

  static bool predicateImmutable(NodeAppendable node) =>
      predicateUnmodifiable(node) && predicateFixed(node);

  static bool predicateMutable(NodeAppendable node) =>
      !predicateUnmodifiable(node) && !predicateFixed(node);

  ///
  ///
  ///
  factory NodeAppendable.unmodifiable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableUnmodifiable<T>;

  factory NodeAppendable.fixed(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableFixed<T>;

  factory NodeAppendable.immutable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableImmutable<T>;

  factory NodeAppendable.mutable(T data, [NodeAppendable<T>? next]) =
      _NodeAppendableMutable<T>;

  ///
  /// see also [NodeExtension.appendNode], [NodeExtension.appendIterable]
  ///
  NodeAppendable<T> append(T data) {
    final result = _construct(data, null);
    NodeExtension.last(this, NodeAppendable.mapNext).next = result;
    return result;
  }
}

part of '../custom.dart';

///
///
/// this file contains:
/// [Vertex]
///   |##[_MixinVertexHidden]
///   |
///   |-[_VertexImmutable], [_VertexImmutableNullable]
///   |-[_VertexMutable], [_VertexMutableNullable]
///   |
///   |
///   |
///   |
///   |
///   |-[Node], ...
///
///
///
///
///
///
///
///


///
/// [hashCode], ...(overrides)
/// [data], ...(properties)
/// [Vertex.immutable], ...(factories)
/// [generate], ...(static methods)
///
abstract class Vertex<T> {
  ///
  /// overrides
  ///
  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<T> other) => hashCode == other.hashCode;

  @override
  String toString() => 'Vertex($data)';

  /// constructor
  ///
  const Vertex();

  ///
  /// factories
  ///
  const factory Vertex.immutable(T data) = _VertexImmutable<T>;

  factory Vertex.mutable(T data) = _VertexMutable<T>;

  const factory Vertex.immutableNullable([T? data]) =
      _VertexImmutableNullable<T>;

  factory Vertex.mutableNullable([T? data]) = _VertexMutableNullable<T>;

  ///
  /// static methods
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
  /// getter, setter
  ///
  set data(T value) => throw StateError(FErrorMessage.modifyImmutable);

  T get data;
}

//
mixin _MixinVertexHidden<T> on Vertex<T> {
  @override
  set data(T value) => _data = value;

  @override
  T get data =>
      _data ??
          (throw StateError(FErrorMessage.vertexDataRequiredNotNull));

  set _data(T? value) =>
      throw StateError(FErrorMessage.modifyImmutable);

  T? get _data;
}

//
class _VertexImmutable<T> extends Vertex<T> {
  @override
  final T data;

  const _VertexImmutable(this.data);
}

//
class _VertexImmutableNullable<T> extends Vertex<T>
    with _MixinVertexHidden<T> {
  @override
  final T? _data;

  const _VertexImmutableNullable([this._data]);
}

//
class _VertexMutable<T> extends Vertex<T> {
  @override
  T data;

  _VertexMutable(this.data);
}

//
class _VertexMutableNullable<T> extends Vertex<T> with _MixinVertexHidden<T> {
  @override
  T? _data;

  _VertexMutableNullable([this._data]);
}

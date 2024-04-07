///
///
/// this file contains:
/// [Vertex]
///   |##[_MixinVertexHidden]
///   |##[_MixinVertexNullable]
///   |   ##[_MixinVertexNullableAssign]
///   |   ##[_MixinVertexNullableHidden]
///   |
///   |-[_VertexImmutable], [_VertexImmutableNullable]
///   |-[_VertexMutable], [_VertexMutableNullable]
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
part of damath_structure;

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

  /// constructor
  ///
  const Vertex();

  ///
  /// factories
  ///
  const factory Vertex.immutable(T data) = _VertexImmutable<T>;

  factory Vertex.mutable(T data) = _VertexMutable<T>;

  const factory Vertex.immutableNullable([T? data]) = _VertexImmutableNullable<T>;

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
  set data(T value) => throw StateError(KErrorMessage.vertexDataIsImmutable);

  T get data;
}

//
mixin _MixinVertexHidden<T> on Vertex<T> {
  set _data(T value) => throw StateError(KErrorMessage.vertexDataIsImmutable);

  T get _data;

  @override
  T get data => _data;

  @override
  set data(T value) =>
      throw StateError(KErrorMessage.vertexDataCannotAssignDirectly);
}

//
mixin _MixinVertexNullable<T> on Vertex<T> {
  set _dataNullable(T? value) =>
      throw StateError(KErrorMessage.vertexDataIsImmutable);

  T? get _dataNullable;

  @override
  T get data =>
      _dataNullable ??
      (throw StateError(KErrorMessage.vertexDataRequiredNotNull));

  @override
  set data(T value) => _dataNullable = value;
}

//
mixin _MixinVertexNullableAssign<T> on _MixinVertexNullable<T> {
  bool _nullAssign(T data) {
    if (_dataNullable == null) {
      _dataNullable = data;
      return true;
    }
    return false;
  }
}

//
mixin _MixinVertexNullableHidden<T>
    on _MixinVertexNullable<T>, _MixinVertexHidden<T> {
  @override
  T get _data =>
      _dataNullable ??
      (throw StateError(KErrorMessage.vertexDataRequiredNotNull));

  @override
  set _data(T value) => _dataNullable = value;
}

//
class _VertexImmutable<T> extends Vertex<T> {
  @override
  final T data;

  const _VertexImmutable(this.data);
}

//
class _VertexImmutableNullable<T> extends Vertex<T>
    with _MixinVertexNullable<T> {
  @override
  final T? _dataNullable;

  const _VertexImmutableNullable([this._dataNullable]);
}

//
class _VertexMutable<T> extends Vertex<T> {
  @override
  T data;

  _VertexMutable(this.data);
}

//
class _VertexMutableNullable<T> extends Vertex<T> with _MixinVertexNullable<T> {
  @override
  T? _dataNullable;

  _VertexMutableNullable([this._dataNullable]);
}

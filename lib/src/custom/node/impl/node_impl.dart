// ignore_for_file: camel_case_types
part of '../../custom.dart';

///
/// * [Vertex]      * [_M_VertexNullable]
///     --[_Vu], [_Vm], --[_VnU], [_VnM]
///     |
///     --[NodeNext]
///         --[NodeNextInstance]
///         |   --[_NnIi], [_NnIu], [_NnIf], [_NnIm]
///         |
///         --[NodeNextContainer]                          * [_I_NodeNextContainer]
///         |   --[_NnCi], [_NnCu], [_NnCf], [_NnCm]       --[_M_NnCi]
///         |                                              --[_M_NnCu]
///         --[NodeNextOperatable]                         --[_M_NnCf]
///         |   --[_NnOi], [_NnOu], [_NnOf], [_NnOm]       --[_M_NnCm]
///         |
///         --[NodeNextPushable]
///         |   --   x   , [_NnPu],    x   , [_NnPm]
///         |
///         --[NodeNextEnqueueable]
///         |   --[_NnEi], [_NnEu], [_NnEf], [_NnEm]
///         |
///         --[NodeBinary] ...
///
///

///
/// stand for [Vertex] + ['unmodifiable', 'mutable']
///
final class _Vu<T> extends Vertex<T> {
  @override
  final T data;

  const _Vu(this.data);
}

final class _Vm<T> extends Vertex<T> {
  @override
  T data;

  _Vm(this.data);
}

///
///
base mixin _M_VertexNullable<T> on Vertex<T> {
  T? get _data;

  set _data(T? value) => throw UnsupportedError(Erroring.modifyImmutable);

  @override
  set data(T value) => _data = value;

  @override
  T get data => _data ?? (throw UnsupportedError(Erroring.receiveNull));

  static T? dataOrNull<T, N extends NodeNext<T, N>>(N node) {
    try {
      return node.data;
    } on StateError catch (e) {
      if (e.message == Erroring.receiveNull) return null;
      rethrow;
    }
  }
}

///
/// stand for [Vertex] nullable + ['unmodifiable', 'mutable']
/// 
final class _VnU<T> extends Vertex<T> with _M_VertexNullable<T> {
  @override
  final T? _data;

  const _VnU([this._data]);
}

final class _VnM<T> extends Vertex<T> with _M_VertexNullable<T> {
  @override
  T? _data;

  _VnM([this._data]);
}

///
/// stand for [NodeNextInstance] + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
final class _NnIi<T> extends NodeNextInstance<T> {
  @override
  final T data;
  @override
  final NodeNextInstance<T>? next;

  const _NnIi(this.data, [this.next]);

  @override
  NodeNextInstance<T> _construct(T data, covariant NodeNextInstance<T>? next) =>
      _NnIi(data, next);
}

final class _NnIu<T> extends NodeNextInstance<T> {
  @override
  final T data;
  @override
  NodeNextInstance<T>? next;

  _NnIu(this.data, [this.next]);

  @override
  NodeNextInstance<T> _construct(T data, covariant NodeNextInstance<T>? next) =>
      _NnIu(data, next);
}

final class _NnIf<T> extends NodeNextInstance<T> {
  @override
  T data;
  @override
  final NodeNextInstance<T>? next;

  _NnIf(this.data, [this.next]);

  @override
  NodeNextInstance<T> _construct(T data, covariant NodeNextInstance<T>? next) =>
      _NnIf(data, next);
}

final class _NnIm<T> extends NodeNextInstance<T> {
  @override
  T data;
  @override
  NodeNextInstance<T>? next;

  _NnIm(this.data, [this.next]);

  @override
  NodeNextInstance<T> _construct(T data, covariant NodeNextInstance<T>? next) =>
      _NnIm(data, next);
}

///
/// prevent "[N] extends [NodeNext]<[T], [N]>",
/// because when [N] = [NodeNextContainer]<[T], customNodeType>,
/// which is not [N] is not the subtype of [NodeNext]<[T], [NodeNextContainer]<[T], customNodeType>>.
///
abstract interface class _I_NodeFinal<T, N>
    implements I_ToUnmodifiable<N>, I_ToFixed<N> {}

///
///
///
abstract interface class _I_NodeNextContainer<T, N extends NodeNext<T, N>> {
  NodeNextContainer<T, N> get finished;
}

///
/// stand for [NodeNextContainer] + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
final class _NnCi<T, N extends NodeNext<T, N>> extends NodeNextContainer<T, N> {
  @override
  final T data;
  @override
  final N? next;

  const _NnCi(this.data, this.next);

  @override
  NodeNextContainer<T, N> _construct(T data, covariant N? next) =>
      _NnCi<T, N>(data, next);
}

final class _NnCu<T, N extends NodeNext<T, N>> extends NodeNextContainer<T, N> {
  @override
  T data;
  @override
  final N? next;

  _NnCu(this.data, this.next);

  @override
  NodeNextContainer<T, N> _construct(T data, covariant N? next) =>
      _NnCu<T, N>(data, next);
}

final class _NnCf<T, N extends NodeNext<T, N>> extends NodeNextContainer<T, N> {
  @override
  T data;
  @override
  final N? next;

  _NnCf(this.data, this.next);

  @override
  NodeNextContainer<T, N> _construct(T data, covariant N? next) =>
      _NnCf<T, N>(data, next);
}

final class _NnCm<T, N extends NodeNext<T, N>> extends NodeNextContainer<T, N> {
  @override
  T data;
  @override
  N? next;

  _NnCm(this.data, this.next);

  @override
  NodeNextContainer<T, N> _construct(T data, covariant N? next) =>
      _NnCm<T, N>(data, next);
}

///
/// stand for 'mixin for [NodeNextContainer]' + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
base mixin _M_NnCi<T, N extends NodeNext<T, N>>
    on NodeNext<T, N>, _I_NodeNextContainer<T, N> {
  @override
  NodeNextContainer<T, N> get finished => _NnCi(data, next);
}

base mixin _M_NnCu<T, N extends NodeNext<T, N>>
    on _I_NodeNextContainer<T, N>, NodeNext<T, N> {
  @override
  NodeNextContainer<T, N> get finished => _NnCu(data, next);
}

base mixin _M_NnCf<T, N extends NodeNext<T, N>>
    on _I_NodeNextContainer<T, N>, NodeNext<T, N> {
  @override
  NodeNextContainer<T, N> get finished => _NnCf(data, next);
}

base mixin _M_NnCm<T, N extends NodeNext<T, N>>
    on _I_NodeNextContainer<T, N>, NodeNext<T, N> {
  @override
  NodeNextContainer<T, N> get finished => _NnCm(data, next);
}

///
/// stand for [NodeNextOperatable] + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
final class _NnOi<T> extends NodeNextOperatable<T>
    with _M_NnCi<T, NodeNextOperatable<T>> {
  @override
  final T data;
  @override
  final NodeNextOperatable<T>? next;

  const _NnOi(this.data, [this.next]);

  @override
  NodeNextOperatable<T>? get toUnmodifiable => null;

  @override
  NodeNextOperatable<T>? get toFixed => null;

  @override
  NodeNextOperatable<T> _construct(
    T data,
    covariant NodeNextOperatable<T>? next,
  ) => NodeNextOperatable.immutable(data, next);
}

//
final class _NnOu<T> extends NodeNextOperatable<T>
    with _M_NnCu<T, NodeNextOperatable<T>> {
  @override
  final T data;
  @override
  NodeNextOperatable<T>? next;

  _NnOu(this.data, [this.next]);

  @override
  NodeNextOperatable<T> _construct(
    T data,
    covariant NodeNextOperatable<T>? next,
  ) => NodeNextOperatable.unmodifiable(data, next);

  @override
  NodeNextOperatable<T>? get toUnmodifiable => null;

  @override
  NodeNextOperatable<T>? get toFixed => _NnOi(data, next);
}

//
final class _NnOf<T> extends NodeNextOperatable<T>
    with _M_NnCf<T, NodeNextOperatable<T>> {
  @override
  T data;
  @override
  final NodeNextOperatable<T>? next;

  _NnOf(this.data, [this.next]);

  @override
  NodeNextOperatable<T> _construct(
    T data,
    covariant NodeNextOperatable<T>? next,
  ) => NodeNextOperatable.fixed(data, next);

  @override
  NodeNextOperatable<T>? get toUnmodifiable => _NnOi(data, next);

  @override
  NodeNextOperatable<T>? get toFixed => null;
}

//
final class _NnOm<T> extends NodeNextOperatable<T>
    with _M_NnCm<T, NodeNextOperatable<T>> {
  @override
  T data;
  @override
  NodeNextOperatable<T>? next;

  _NnOm(this.data, [this.next]);

  @override
  NodeNextOperatable<T> _construct(
    T data,
    covariant NodeNextOperatable<T>? next,
  ) => NodeNextOperatable.mutable(data, next);

  @override
  NodeNextOperatable<T>? get toUnmodifiable => _NnOu(data, next);

  @override
  NodeNextOperatable<T>? get toFixed => _NnOf(data, next);
}

///
/// stand for [NodeNextPushable] + ['unmodifiable', 'mutable']
///
final class _NnPu<T> extends NodeNextPushable<T> with _M_NnCu<T, NodeNextPushable<T>>{
  @override
  final T data;

  @override
  NodeNextPushable<T>? next;

  _NnPu(this.data, [this.next]);

  @override
  NodeNextPushable<T> _construct(T data, covariant NodeNextPushable<T>? next) =>
      _NnPu(data, next);

  @override
  NodeNextContainer<T, NodeNextPushable<T>>? get toUnmodifiable =>
      _NnCu(data, next);

  @override
  NodeNextContainer<T, NodeNextPushable<T>>? get toFixed => _NnCf(data, next);
}

final class _NnPm<T> extends NodeNextPushable<T> with _M_NnCm<T, NodeNextPushable<T>>{
  @override
  T data;

  @override
  NodeNextPushable<T>? next;

  _NnPm(this.data, [this.next]);

  @override
  NodeNextPushable<T> _construct(T data, covariant NodeNextPushable<T>? next) =>
      _NnPm(data, next);

  @override
  NodeNextContainer<T, NodeNextPushable<T>>? get toUnmodifiable =>
      _NnCu(data, next);

  @override
  NodeNextContainer<T, NodeNextPushable<T>>? get toFixed => _NnCf(data, next);
}

///
/// stand for 'node next enqueueable' + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
final class _NnEi<T> extends NodeNextEnqueueable<T>
    with _M_NnCi<T, NodeNextEnqueueable<T>> {
  @override
  final T data;
  @override
  final NodeNextEnqueueable<T>? next;

  const _NnEi(this.data, [this.next]);

  @override
  NodeNextEnqueueable<T> _construct(
    T data,
    covariant NodeNextEnqueueable<T>? next,
  ) => NodeNextEnqueueable.immutable(data, next);

  @override
  NodeNextEnqueueable<T>? get toUnmodifiable => null;

  @override
  NodeNextEnqueueable<T>? get toFixed => null;
}

//
final class _NnEu<T> extends NodeNextEnqueueable<T>
    with _M_NnCu<T, NodeNextEnqueueable<T>> {
  @override
  final T data;
  @override
  NodeNextEnqueueable<T>? next;

  _NnEu(this.data, [this.next]);

  @override
  NodeNextEnqueueable<T> _construct(
    T data,
    covariant NodeNextEnqueueable<T>? next,
  ) => NodeNextEnqueueable.unmodifiable(data, next);

  @override
  NodeNextEnqueueable<T>? get toUnmodifiable => null;

  @override
  NodeNextEnqueueable<T>? get toFixed => _NnEi(data, next);
}

//
final class _NnEf<T> extends NodeNextEnqueueable<T>
    with _M_NnCf<T, NodeNextEnqueueable<T>> {
  @override
  T data;
  @override
  final NodeNextEnqueueable<T>? next;

  _NnEf(this.data, [this.next]);

  @override
  NodeNextEnqueueable<T> _construct(
    T data,
    covariant NodeNextEnqueueable<T>? next,
  ) => NodeNextEnqueueable.fixed(data, next);

  @override
  NodeNextEnqueueable<T>? get toUnmodifiable => _NnEi(data, next);

  @override
  NodeNextEnqueueable<T>? get toFixed => null;
}

//
final class _NnEm<T> extends NodeNextEnqueueable<T>
    with _M_NnCm<T, NodeNextEnqueueable<T>> {
  @override
  T data;
  @override
  NodeNextEnqueueable<T>? next;

  _NnEm(this.data, [this.next]);

  @override
  NodeNextEnqueueable<T> _construct(
    T data,
    covariant NodeNextEnqueueable<T>? next,
  ) => NodeNextEnqueueable.mutable(data, next);

  @override
  NodeNextEnqueueable<T>? get toUnmodifiable => _NnEu(data, next);

  @override
  NodeNextEnqueueable<T>? get toFixed => _NnEf(data, next);
}

///
/// stand for 'node next sorted' + ['immutable', 'unmodifiable', 'fixed', 'mutable']
///
final class _NnSi<C extends Comparable> extends NodeNextSorted<C>
    with _M_NnCi<C, NodeNextSorted<C>> {
  @override
  final C data;
  @override
  final NodeNextSorted<C>? next;

  const _NnSi(this.data, [this.next]);

  @override
  NodeNextSorted<C> _construct(C data, covariant NodeNextSorted<C>? next) =>
      NodeNextSorted.immutable(data, next);

  @override
  NodeNextSorted<C>? get toUnmodifiable => null;

  @override
  NodeNextSorted<C>? get toFixed => null;
}

//
final class _NnSu<C extends Comparable> extends NodeNextSorted<C>
    with _M_NnCu<C, NodeNextSorted<C>> {
  @override
  final C data;
  @override
  NodeNextSorted<C>? next;

  _NnSu(this.data, [this.next]);

  @override
  NodeNextSorted<C> _construct(C data, covariant NodeNextSorted<C>? next) =>
      NodeNextSorted.unmodifiable(data, next);

  @override
  NodeNextSorted<C>? get toUnmodifiable => null;

  @override
  NodeNextSorted<C>? get toFixed => _NnSi(data, next);
}

//
final class _NnSf<C extends Comparable> extends NodeNextSorted<C>
    with _M_NnCf<C, NodeNextSorted<C>> {
  @override
  C data;
  @override
  final NodeNextSorted<C>? next;

  _NnSf(this.data, [this.next]);

  @override
  NodeNextSorted<C> _construct(C data, covariant NodeNextSorted<C>? next) =>
      NodeNextSorted.fixed(data, next);

  @override
  NodeNextSorted<C>? get toUnmodifiable => _NnSi(data, next);

  @override
  NodeNextSorted<C>? get toFixed => null;
}

//
final class _NnSm<C extends Comparable> extends NodeNextSorted<C>
    with _M_NnCm<C, NodeNextSorted<C>> {
  @override
  C data;
  @override
  NodeNextSorted<C>? next;

  _NnSm(this.data, [this.next]);

  @override
  NodeNextSorted<C> _construct(C data, covariant NodeNextSorted<C>? next) =>
      NodeNextSorted.mutable(data, next);

  @override
  NodeNextSorted<C>? get toUnmodifiable => _NnSu(data, next);

  @override
  NodeNextSorted<C>? get toFixed => _NnSf(data, next);
}

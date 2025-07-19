// ignore_for_file: camel_case_types
part of '../node.dart';

///
///
/// * [NodeBinary]                                * [_M_un]  * [_I_NodeBinaryFinal]
///     --[NodeBinaryInstance]                                   --[_M_fnNext]
///     |   --[_NbIi], [_NbIu], [_NbIf], [_NbIm]                 --[_M_fnPrevious]
///     |            [_NbIuFp], [_NbIfP]
///     |            [_NbIuFn], [_NbIfN]
///     |
///     --[NodeBinaryContainer]                    * [_I_NodeBinaryContainer]
///     |   --[_NbCi], [_NbCu], [_NbCf], [_NbCm]       --[_M_NbCi]
///     |            [_NbCuFp], [_NbCfP]               --[_M_NbCu], [_M_NbCuFp], [_M_NbCuFn]
///     |            [_NbCuFn], [_NbCfN]               --[_M_NbCf], [_M_NbCfP], [_M_NbCfN]
///     |                                              --[_M_NBCm]
///     --[NodeBinaryEnqueueable]
///     |   --[_NbEi], [_NbEu], [_NbEf], [_NbEm]
///     |            [_NbEuFp], [_NbEfP]
///     |            [_NbEuFn], [_NbEfN]
///     |
///     --[NodeBinarySorted]
///     |   --[_NbSi], [_NbSu], [_NbSf], [_NbSm]
///     |            [_NbSuFp], [_NbSfP]
///     |            [_NbSuFn], [_NbSfN]
///     |
///     --[NodeBinaryAVL]
///         --[_NbAvl]
///
///

///
/// prevent "[N] extends [NodeBinary]<[T], [N]>",
/// because when [N] = [NodeBinaryContainer]<[T], customNodeType>,
/// which is not [N] is not the subtype of [NodeBinary]<[T], [NodeBinaryContainer]<[T], customNodeType>>.
///
abstract interface class _I_NodeBinaryFinal<N> implements I_ToUnmodifiable<N> {
  N? get toFixedNext;

  N? get toFixedPrevious;
}

base mixin _M_fnNext<N> implements _I_NodeBinaryFinal<N> {
  @override
  N? get toFixedNext => null;
}

base mixin _M_fnPrevious<N> implements _I_NodeBinaryFinal<N> {
  @override
  N? get toFixedPrevious => null;
}

///
/// stand for [NodeBinaryInstance] + [
///   'immutable',
///   'unmodifiable', 'unmodifiable fixed previous', 'unmodifiable fixed next',
///   'fixed previous', 'fixed next', 'fixed',
///   'mutable'
/// ]
///
final class _NbIi<T> extends NodeBinaryInstance<T>
    with
        _M_un<NodeBinaryInstance<T>>,
        _M_fnNext<NodeBinaryInstance<T>>,
        _M_fnPrevious<NodeBinaryInstance<T>> {
  @override
  final T data;
  @override
  final NodeBinaryInstance<T>? next;

  @override
  final NodeBinaryInstance<T>? previous;

  const _NbIi(this.data, [this.next, this.previous]);

  @override
  _NbIi<T> _construct(
    T data,
    covariant _NbIi<T>? next, [
    covariant _NbIi<T>? previous,
  ]) => _NbIi(data, next, previous);
}

final class _NbIu<T> extends NodeBinaryInstance<T>
    with _M_un<NodeBinaryInstance<T>> {
  @override
  final T data;
  @override
  NodeBinaryInstance<T>? next;

  @override
  NodeBinaryInstance<T>? previous;

  _NbIu(this.data, [this.next, this.previous]);

  @override
  _NbIu<T> _construct(
    T data,
    covariant _NbIu<T>? next, [
    covariant _NbIu<T>? previous,
  ]) => _NbIu(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedNext => _NbIuFn(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedPrevious => _NbIuFp(data, next, previous);
}

final class _NbIuFp<T> extends NodeBinaryInstance<T>
    with _M_un<NodeBinaryInstance<T>>, _M_fnPrevious<NodeBinaryInstance<T>> {
  @override
  final T data;
  @override
  NodeBinaryInstance<T>? next;

  @override
  final NodeBinaryInstance<T>? previous;

  _NbIuFp(this.data, [this.next, this.previous]);

  @override
  _NbIuFp<T> _construct(
    T data,
    covariant _NbIuFp<T>? next, [
    covariant _NbIuFp<T>? previous,
  ]) => _NbIuFp(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedNext => _NbIi(data, next, previous);
}

final class _NbIuFn<T> extends NodeBinaryInstance<T>
    with _M_un<NodeBinaryInstance<T>>, _M_fnNext<NodeBinaryInstance<T>> {
  @override
  final T data;
  @override
  final NodeBinaryInstance<T>? next;

  @override
  NodeBinaryInstance<T>? previous;

  _NbIuFn(this.data, [this.next, this.previous]);

  @override
  _NbIuFn<T> _construct(
    T data,
    covariant _NbIuFn<T>? next, [
    covariant _NbIuFn<T>? previous,
  ]) => _NbIuFn(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedPrevious => _NbIi(data, next, previous);
}

final class _NbIfP<T> extends NodeBinaryInstance<T>
    with _M_fnPrevious<NodeBinaryInstance<T>> {
  @override
  T data;
  @override
  NodeBinaryInstance<T>? next;

  @override
  final NodeBinaryInstance<T>? previous;

  _NbIfP(this.data, [this.next, this.previous]);

  @override
  _NbIfP<T> _construct(
    T data,
    covariant _NbIfP<T>? next, [
    covariant _NbIfP<T>? previous,
  ]) => _NbIfP(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedNext => _NbIf(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toUnmodifiable => _NbIuFp(data, next, previous);
}

final class _NbIfN<T> extends NodeBinaryInstance<T>
    with _M_fnNext<NodeBinaryInstance<T>> {
  @override
  T data;
  @override
  final NodeBinaryInstance<T>? next;

  @override
  NodeBinaryInstance<T>? previous;

  _NbIfN(this.data, [this.next, this.previous]);

  @override
  _NbIfN<T> _construct(
    T data,
    covariant _NbIfN<T>? next, [
    covariant _NbIfN<T>? previous,
  ]) => _NbIfN(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedPrevious => _NbIf(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toUnmodifiable => _NbIuFn(data, next, previous);
}

final class _NbIf<T> extends NodeBinaryInstance<T>
    with
        _M_fnNext<NodeBinaryInstance<T>>,
        _M_fnPrevious<NodeBinaryInstance<T>> {
  @override
  T data;
  @override
  final NodeBinaryInstance<T>? next;

  @override
  final NodeBinaryInstance<T>? previous;

  _NbIf(this.data, [this.next, this.previous]);

  @override
  _NbIf<T> _construct(
    T data,
    covariant _NbIf<T>? next, [
    covariant _NbIf<T>? previous,
  ]) => _NbIf(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toUnmodifiable => _NbIi(data, next, previous);
}

final class _NbIm<T> extends NodeBinaryInstance<T> {
  @override
  T data;
  @override
  NodeBinaryInstance<T>? next;

  @override
  NodeBinaryInstance<T>? previous;

  _NbIm(this.data, [this.next, this.previous]);

  @override
  _NbIm<T> _construct(
    T data,
    covariant _NbIm<T>? next, [
    covariant _NbIm<T>? previous,
  ]) => _NbIm(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedNext => _NbIuFn(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toFixedPrevious => _NbIfP(data, next, previous);

  @override
  NodeBinaryInstance<T>? get toUnmodifiable => _NbIu(data, next, previous);
}

///
/// stand for [NodeBinaryContainer] + [
///   'immutable',
///   'unmodifiable', 'unmodifiable fixed previous', 'unmodifiable fixed next',
///   'fixed previous', 'fixed next', 'fixed',
///   'mutable'
/// ]
///
final class _NbCi<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with
        _M_un<NodeBinaryContainer<T, N>>,
        _M_fnNext<NodeBinaryContainer<T, N>>,
        _M_fnPrevious<NodeBinaryContainer<T, N>> {
  @override
  final T data;
  @override
  final N? next;
  @override
  final N? previous;

  const _NbCi(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCi<T, N>(data, next, previous);
}

final class _NbCu<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with _M_un<NodeBinaryContainer<T, N>> {
  @override
  final T data;
  @override
  N? next;
  @override
  N? previous;

  _NbCu(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCu<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedNext => _NbCuFn(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedPrevious =>
      _NbCuFp(data, next, previous);
}

final class _NbCuFp<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with
        _M_un<NodeBinaryContainer<T, N>>,
        _M_fnPrevious<NodeBinaryContainer<T, N>> {
  @override
  final T data;
  @override
  N? next;
  @override
  final N? previous;

  _NbCuFp(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCuFp<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedNext => _NbCi(data, next, previous);
}

final class _NbCuFn<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with
        _M_un<NodeBinaryContainer<T, N>>,
        _M_fnNext<NodeBinaryContainer<T, N>> {
  @override
  final T data;
  @override
  final N? next;
  @override
  N? previous;

  _NbCuFn(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCuFn<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedPrevious => _NbCi(data, next, previous);
}

final class _NbCfP<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with _M_fnPrevious<NodeBinaryContainer<T, N>> {
  @override
  T data;
  @override
  N? next;
  @override
  final N? previous;

  _NbCfP(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCfP<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedNext => _NbCf(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toUnmodifiable =>
      _NbCuFp(data, next, previous);
}

final class _NbCfN<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with _M_fnNext<NodeBinaryContainer<T, N>> {
  @override
  T data;
  @override
  final N? next;
  @override
  N? previous;

  _NbCfN(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCfN<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedPrevious => _NbCf(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toUnmodifiable =>
      _NbCuFn(data, next, previous);
}

final class _NbCf<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N>
    with
        _M_fnNext<NodeBinaryContainer<T, N>>,
        _M_fnPrevious<NodeBinaryContainer<T, N>> {
  @override
  T data;
  @override
  final N? next;
  @override
  final N? previous;

  _NbCf(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCf<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toUnmodifiable => _NbCi(data, next, previous);
}

final class _NbCm<T, N extends NodeBinary<T, N>>
    extends NodeBinaryContainer<T, N> {
  @override
  T data;
  @override
  N? next;
  @override
  N? previous;

  _NbCm(this.data, this.next, this.previous);

  @override
  NodeBinaryContainer<T, N> _construct(
    T data,
    covariant N? next, [
    covariant N? previous,
  ]) => _NbCm<T, N>(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedNext => _NbCfN(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toFixedPrevious =>
      _NbCfP(data, next, previous);

  @override
  NodeBinaryContainer<T, N>? get toUnmodifiable => _NbCu(data, next, previous);
}

///
///
///
abstract interface class _I_NodeBinaryContainer<T, N extends NodeBinary<T, N>>
    implements I_Finished<NodeBinaryContainer<T, N>> {}

///
/// stand for 'mixin for [NodeBinaryContainer]' + [
///   'immutable',
///   'unmodifiable', 'unmodifiable fixed previous', 'unmodifiable fixed next',
///   'fixed previous', 'fixed next', 'fixed',
///   'mutable'
/// ]
///
base mixin _M_NbCi<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCi(data, next, previous);
}

base mixin _M_NbCu<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCu(data, next, previous);
}
base mixin _M_NbCuFp<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCuFp(data, next, previous);
}
base mixin _M_NbCuFn<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCuFn(data, next, previous);
}
base mixin _M_NbCfP<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCfP(data, next, previous);
}
base mixin _M_NbCfN<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCfN(data, next, previous);
}
base mixin _M_NbCf<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCf(data, next, previous);
}
base mixin _M_NbCm<T, N extends NodeBinary<T, N>>
    on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
  @override
  NodeBinaryContainer<T, N> get finished => _NbCm(data, next, previous);
}

///
/// stand for [NodeBinaryEnqueueable] + [
///   'immutable',
///   'unmodifiable', 'unmodifiable fixed previous', 'unmodifiable fixed next',
///   'fixed previous', 'fixed next', 'fixed',
///   'mutable'
/// ]
///
final class _NbEi<T> extends NodeBinaryEnqueueable<T>
    with
        _M_un<NodeBinaryEnqueueable<T>>,
        _M_fnNext<NodeBinaryEnqueueable<T>>,
        _M_fnPrevious<NodeBinaryEnqueueable<T>>,
        _M_NbCi<T, NodeBinaryEnqueueable<T>> {
  @override
  final T data;
  @override
  final NodeBinaryEnqueueable<T>? next;

  @override
  final NodeBinaryEnqueueable<T>? previous;

  const _NbEi(this.data, [this.next, this.previous]);

  @override
  _NbEi<T> _construct(
    T data,
    covariant _NbEi<T>? next, [
    covariant _NbEi<T>? previous,
  ]) => _NbEi(data, next, previous);
}

final class _NbEu<T> extends NodeBinaryEnqueueable<T>
    with _M_un<NodeBinaryEnqueueable<T>>, _M_NbCu<T, NodeBinaryEnqueueable<T>> {
  @override
  final T data;
  @override
  NodeBinaryEnqueueable<T>? next;

  @override
  NodeBinaryEnqueueable<T>? previous;

  _NbEu(this.data, [this.next, this.previous]);

  @override
  _NbEu<T> _construct(
    T data,
    covariant _NbEu<T>? next, [
    covariant _NbEu<T>? previous,
  ]) => _NbEu(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedNext => _NbEuFn(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedPrevious =>
      _NbEuFp(data, next, previous);
}

final class _NbEuFp<T> extends NodeBinaryEnqueueable<T>
    with
        _M_un<NodeBinaryEnqueueable<T>>,
        _M_fnPrevious<NodeBinaryEnqueueable<T>>,
        _M_NbCuFp<T, NodeBinaryEnqueueable<T>> {
  @override
  final T data;
  @override
  NodeBinaryEnqueueable<T>? next;

  @override
  final NodeBinaryEnqueueable<T>? previous;

  _NbEuFp(this.data, [this.next, this.previous]);

  @override
  _NbEuFp<T> _construct(
    T data,
    covariant _NbEuFp<T>? next, [
    covariant _NbEuFp<T>? previous,
  ]) => _NbEuFp(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedNext => _NbEi(data, next, previous);
}

final class _NbEuFn<T> extends NodeBinaryEnqueueable<T>
    with
        _M_un<NodeBinaryEnqueueable<T>>,
        _M_fnNext<NodeBinaryEnqueueable<T>>,
        _M_NbCuFn<T, NodeBinaryEnqueueable<T>> {
  @override
  final T data;
  @override
  final NodeBinaryEnqueueable<T>? next;

  @override
  NodeBinaryEnqueueable<T>? previous;

  _NbEuFn(this.data, [this.next, this.previous]);

  @override
  _NbEuFn<T> _construct(
    T data,
    covariant _NbEuFn<T>? next, [
    covariant _NbEuFn<T>? previous,
  ]) => _NbEuFn(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedPrevious => _NbEi(data, next, previous);
}

final class _NbEfP<T> extends NodeBinaryEnqueueable<T>
    with
        _M_fnPrevious<NodeBinaryEnqueueable<T>>,
        _M_NbCfP<T, NodeBinaryEnqueueable<T>> {
  @override
  T data;
  @override
  NodeBinaryEnqueueable<T>? next;

  @override
  final NodeBinaryEnqueueable<T>? previous;

  _NbEfP(this.data, [this.next, this.previous]);

  @override
  _NbEfP<T> _construct(
    T data,
    covariant _NbEfP<T>? next, [
    covariant _NbEfP<T>? previous,
  ]) => _NbEfP(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedNext => _NbEf(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toUnmodifiable => _NbEuFp(data, next, previous);
}

final class _NbEfN<T> extends NodeBinaryEnqueueable<T>
    with
        _M_fnNext<NodeBinaryEnqueueable<T>>,
        _M_NbCfN<T, NodeBinaryEnqueueable<T>> {
  @override
  T data;
  @override
  final NodeBinaryEnqueueable<T>? next;

  @override
  NodeBinaryEnqueueable<T>? previous;

  _NbEfN(this.data, [this.next, this.previous]);

  @override
  _NbEfN<T> _construct(
    T data,
    covariant _NbEfN<T>? next, [
    covariant _NbEfN<T>? previous,
  ]) => _NbEfN(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedPrevious => _NbEf(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toUnmodifiable => _NbEuFn(data, next, previous);
}

final class _NbEf<T> extends NodeBinaryEnqueueable<T>
    with
        _M_fnNext<NodeBinaryEnqueueable<T>>,
        _M_fnPrevious<NodeBinaryEnqueueable<T>>,
        _M_NbCf<T, NodeBinaryEnqueueable<T>> {
  @override
  T data;
  @override
  final NodeBinaryEnqueueable<T>? next;

  @override
  final NodeBinaryEnqueueable<T>? previous;

  _NbEf(this.data, [this.next, this.previous]);

  @override
  _NbEf<T> _construct(
    T data,
    covariant _NbEf<T>? next, [
    covariant _NbEf<T>? previous,
  ]) => _NbEf(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toUnmodifiable => _NbEi(data, next, previous);
}

final class _NbEm<T> extends NodeBinaryEnqueueable<T>
    with _M_NbCm<T, NodeBinaryEnqueueable<T>> {
  @override
  T data;
  @override
  NodeBinaryEnqueueable<T>? next;

  @override
  NodeBinaryEnqueueable<T>? previous;

  _NbEm(this.data, [this.next, this.previous]);

  @override
  _NbEm<T> _construct(
    T data,
    covariant _NbEm<T>? next, [
    covariant _NbEm<T>? previous,
  ]) => _NbEm(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedNext => _NbEuFn(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toFixedPrevious => _NbEfP(data, next, previous);

  @override
  NodeBinaryEnqueueable<T>? get toUnmodifiable => _NbEu(data, next, previous);
}

///
/// stand for [NodeBinarySorted] + [
///   'immutable',
///   'unmodifiable', 'unmodifiable fixed previous', 'unmodifiable fixed next',
///   'fixed previous', 'fixed next', 'fixed',
///   'mutable'
/// ]
///
final class _NbSi<C extends Comparable> extends NodeBinarySorted<C>
    with
        _M_un<NodeBinarySorted<C>>,
        _M_fnNext<NodeBinarySorted<C>>,
        _M_fnPrevious<NodeBinarySorted<C>>,
        _M_NbCi<C, NodeBinarySorted<C>> {
  @override
  final C data;
  @override
  final NodeBinarySorted<C>? next;
  @override
  final NodeBinarySorted<C>? previous;

  const _NbSi(this.data, [this.next, this.previous]);

  @override
  _NbSi<C> _construct(
    C data,
    covariant _NbSi<C>? next, [
    covariant _NbSi<C>? previous,
  ]) => _NbSi(data, next, previous);
}

final class _NbSu<C extends Comparable> extends NodeBinarySorted<C>
    with _M_un<NodeBinarySorted<C>>, _M_NbCu<C, NodeBinarySorted<C>> {
  @override
  final C data;
  @override
  NodeBinarySorted<C>? next;
  @override
  NodeBinarySorted<C>? previous;

  _NbSu(this.data, [this.next, this.previous]);

  @override
  _NbSu<C> _construct(
    C data,
    covariant _NbSu<C>? next, [
    covariant _NbSu<C>? previous,
  ]) => _NbSu(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedNext => _NbSuFn(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedPrevious => _NbSuFp(data, next, previous);
}

final class _NbSuFp<C extends Comparable> extends NodeBinarySorted<C>
    with
        _M_un<NodeBinarySorted<C>>,
        _M_fnPrevious<NodeBinarySorted<C>>,
        _M_NbCuFp<C, NodeBinarySorted<C>> {
  @override
  final C data;
  @override
  NodeBinarySorted<C>? next;
  @override
  final NodeBinarySorted<C>? previous;

  _NbSuFp(this.data, [this.next, this.previous]);

  @override
  _NbSuFp<C> _construct(
    C data,
    covariant _NbSuFp<C>? next, [
    covariant _NbSuFp<C>? previous,
  ]) => _NbSuFp(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedNext => _NbSi(data, next, previous);
}

final class _NbSuFn<C extends Comparable> extends NodeBinarySorted<C>
    with
        _M_un<NodeBinarySorted<C>>,
        _M_fnNext<NodeBinarySorted<C>>,
        _M_NbCuFn<C, NodeBinarySorted<C>> {
  @override
  final C data;
  @override
  final NodeBinarySorted<C>? next;
  @override
  NodeBinarySorted<C>? previous;

  _NbSuFn(this.data, [this.next, this.previous]);

  @override
  _NbSuFn<C> _construct(
    C data,
    covariant _NbSuFn<C>? next, [
    covariant _NbSuFn<C>? previous,
  ]) => _NbSuFn(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedPrevious => _NbSi(data, next, previous);
}

final class _NbSfP<C extends Comparable> extends NodeBinarySorted<C>
    with _M_fnPrevious<NodeBinarySorted<C>>, _M_NbCfP<C, NodeBinarySorted<C>> {
  @override
  C data;
  @override
  NodeBinarySorted<C>? next;
  @override
  final NodeBinarySorted<C>? previous;

  _NbSfP(this.data, [this.next, this.previous]);

  @override
  _NbSfP<C> _construct(
    C data,
    covariant _NbSfP<C>? next, [
    covariant _NbSfP<C>? previous,
  ]) => _NbSfP(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedNext => _NbSf(data, next, previous);

  @override
  NodeBinarySorted<C>? get toUnmodifiable => _NbSuFp(data, next, previous);
}

final class _NbSfN<C extends Comparable> extends NodeBinarySorted<C>
    with _M_fnNext<NodeBinarySorted<C>>, _M_NbCfN<C, NodeBinarySorted<C>> {
  @override
  C data;
  @override
  final NodeBinarySorted<C>? next;
  @override
  NodeBinarySorted<C>? previous;

  _NbSfN(this.data, [this.next, this.previous]);

  @override
  _NbSfN<C> _construct(
    C data,
    covariant _NbSfN<C>? next, [
    covariant _NbSfN<C>? previous,
  ]) => _NbSfN(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedPrevious => _NbSf(data, next, previous);

  @override
  NodeBinarySorted<C>? get toUnmodifiable => _NbSuFn(data, next, previous);
}

final class _NbSf<C extends Comparable> extends NodeBinarySorted<C>
    with
        _M_fnNext<NodeBinarySorted<C>>,
        _M_fnPrevious<NodeBinarySorted<C>>,
        _M_NbCf<C, NodeBinarySorted<C>> {
  @override
  C data;
  @override
  final NodeBinarySorted<C>? next;
  @override
  final NodeBinarySorted<C>? previous;

  _NbSf(this.data, [this.next, this.previous]);

  @override
  _NbSf<C> _construct(
    C data,
    covariant _NbSf<C>? next, [
    covariant _NbSf<C>? previous,
  ]) => _NbSf(data, next, previous);

  @override
  NodeBinarySorted<C>? get toUnmodifiable => _NbSi(data, next, previous);
}

final class _NbSm<C extends Comparable> extends NodeBinarySorted<C>
    with _M_NbCm<C, NodeBinarySorted<C>> {
  @override
  C data;
  @override
  NodeBinarySorted<C>? next;
  @override
  NodeBinarySorted<C>? previous;

  _NbSm(this.data, [this.next, this.previous]);

  @override
  _NbSm<C> _construct(
    C data,
    covariant _NbSm<C>? next, [
    covariant _NbSm<C>? previous,
  ]) => _NbSm(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedNext => _NbSuFn(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedPrevious => _NbSfP(data, next, previous);

  @override
  NodeBinarySorted<C>? get toUnmodifiable => _NbSu(data, next, previous);
}

final class _NbAvl<C extends Comparable> extends NodeBinaryAvl<C>
    with _M_NbCi<C, NodeBinarySorted<C>> {
  @override
  NodeBinarySorted<C> root;

  @override
  C get data => root.data;

  @override
  set data(C value) => root.data = value;

  @override
  NodeBinarySorted<C>? get next => root.next;

  @override
  NodeBinarySorted<C>? get previous => root.previous;

  @override
  set next(covariant NodeBinarySorted<C>? node) => root.next = node;

  @override
  set previous(covariant NodeBinarySorted<C>? node) => root.previous = node;

  @override
  void push(C element) {
    super.push(element);
    root = NodeBinaryAvl._balance(root);
  }

  _NbAvl(C data, [NodeBinarySorted<C>? next, NodeBinarySorted<C>? previous])
    : root = _NbSm(data, next, previous),
      super._();

  @override
  _NbAvl<C> _construct(
    C data,
    covariant _NbAvl<C>? next, [
    covariant _NbAvl<C>? previous,
  ]) => _NbAvl(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedNext => _NbSfN(data, next, previous);

  @override
  NodeBinarySorted<C>? get toFixedPrevious => _NbSfP(data, next, previous);

  @override
  NodeBinarySorted<C>? get toUnmodifiable => _NbSu(data, next, previous);
}

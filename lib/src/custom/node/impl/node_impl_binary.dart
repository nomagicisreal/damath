// ignore_for_file: camel_case_types
part of '../../custom.dart';
//
// ///
// ///
// /// * [NodeBinary]
// ///     --[NodeBinaryInstance]
// ///     |   --[_NbIi], [_NbIu], [_NbIf], [_NbIm]
// ///     |            [_NbIuFp], [_NbIfP]
// ///     |            [_NbIuFn], [_NbIfN]
// ///     |
// ///     --[NodeBinaryContainer]                    * [_I_NodeBinaryContainer]
// ///     |   --[_NbCi], [_NbCu], [_NbCf], [_NbCm]       --[_M_NbCi]
// ///     |            [_NbCuFp], [_NbCfP]               --[_M_NbCu], [_M_NbCuFp], [_M_NbCuFn]
// ///     |            [_NbCuFn], [_NbCfN]               --[_M_NbCf], [_M_NbCfP], [_M_NbCfN]
// ///     |                                              --[_M_NBCm]
// ///     --[NodeBinaryEnqueueable]
// ///     |   --[_NbEi], [_NbEu], [_NbEf], [_NbEm]
// ///     |            [_NbEuFp], [_NbEfP]
// ///     |            [_NbEuFn], [_NbEfN]
// ///     |
// ///     --[NodeBinaryOrdered]
// ///     |   --[_NbOi], [_NbOu], [_NbOf], [_NbOm]
// ///     |            [_NbOuFp], [_NbOfP]
// ///     |            [_NbOuFn], [_NbOfN]
// ///
// ///
//
// ///
// /// stand for [NodeBinaryInstance] + [
// ///   "immutable",
// ///   "unmodifiable", "unmodifiable fixed previous", "unmodifiable fixed next",
// ///   "fixed previous", "fixed next", "fixed",
// ///   "mutable"
// /// ]
// ///
// final class _NbIi<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   const _NbIi(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIi<T> _construct(
//     T data,
//     covariant _NbIi<T>? next, [
//     covariant _NbIi<T>? previous,
//   ]) => _NbIi(data, next, previous);
// }
//
// final class _NbIu<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIu(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIu<T> _construct(
//     T data,
//     covariant _NbIu<T>? next, [
//     covariant _NbIu<T>? previous,
//   ]) => _NbIu(data, next, previous);
// }
//
// final class _NbIuFp<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIuFp(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIuFp<T> _construct(
//     T data,
//     covariant _NbIuFp<T>? next, [
//     covariant _NbIuFp<T>? previous,
//   ]) => _NbIuFp(data, next, previous);
// }
//
// final class _NbIuFn<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIuFn(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIuFn<T> _construct(
//     T data,
//     covariant _NbIuFn<T>? next, [
//     covariant _NbIuFn<T>? previous,
//   ]) => _NbIuFn(data, next, previous);
// }
//
// final class _NbIfP<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIfP(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIfP<T> _construct(
//     T data,
//     covariant _NbIfP<T>? next, [
//     covariant _NbIfP<T>? previous,
//   ]) => _NbIfP(data, next, previous);
// }
//
// final class _NbIfN<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIfN(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIfN<T> _construct(
//     T data,
//     covariant _NbIfN<T>? next, [
//     covariant _NbIfN<T>? previous,
//   ]) => _NbIfN(data, next, previous);
// }
//
// final class _NbIf<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIf(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIf<T> _construct(
//     T data,
//     covariant _NbIf<T>? next, [
//     covariant _NbIf<T>? previous,
//   ]) => _NbIf(data, next, previous);
// }
//
// final class _NbIm<T> extends NodeBinaryInstance<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryInstance<T>? next;
//
//   @override
//   final NodeBinaryInstance<T>? previous;
//
//   _NbIm(this.data, [this.next, this.previous]);
//
//   @override
//   _NbIm<T> _construct(
//     T data,
//     covariant _NbIm<T>? next, [
//     covariant _NbIm<T>? previous,
//   ]) => _NbIm(data, next, previous);
// }
//
// ///
// /// stand for [NodeBinaryContainer] + ['immutable', 'unmodifiable', 'fixed', 'mutable']
// ///
// final class _NbCi<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   final T data;
//   @override
//   final N? next;
//   @override
//   final N? previous;
//
//   const _NbCi(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCi<T, N>(data, next, previous);
// }
//
// final class _NbCu<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   final T data;
//   @override
//   N? next;
//   @override
//   N? previous;
//
//   _NbCu(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCu<T, N>(data, next, previous);
// }
//
// final class _NbCuFp<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   final T data;
//   @override
//   N? next;
//   @override
//   final N? previous;
//
//   _NbCuFp(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCuFp<T, N>(data, next, previous);
// }
//
// final class _NbCuFn<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   final T data;
//   @override
//   final N? next;
//   @override
//   N? previous;
//
//   _NbCuFn(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCuFn<T, N>(data, next, previous);
// }
//
// final class _NbCfP<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   T data;
//   @override
//   N? next;
//   @override
//   final N? previous;
//
//   _NbCfP(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCfP<T, N>(data, next, previous);
// }
//
// final class _NbCfn<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   T data;
//   @override
//   final N? next;
//   @override
//   N? previous;
//
//   _NbCfn(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCfn<T, N>(data, next, previous);
// }
//
// final class _NbCf<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   T data;
//   @override
//   final N? next;
//   @override
//   final N? previous;
//
//   _NbCf(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCf<T, N>(data, next, previous);
// }
//
// final class _NbCm<T, N extends NodeBinary<T, N>>
//     extends NodeBinaryContainer<T, N> {
//   @override
//   T data;
//   @override
//   N? next;
//   @override
//   N? previous;
//
//   _NbCm(this.data, this.next, this.previous);
//
//   @override
//   NodeBinaryContainer<T, N> _construct(
//     T data,
//     covariant N? next, [
//     covariant N? previous,
//   ]) => _NbCm<T, N>(data, next, previous);
// }
//
// ///
// ///
// ///
// abstract interface class _I_NodeBinaryContainer<T, N extends NodeBinary<T, N>> {
//   NodeBinaryContainer<T, N> get finished;
// }
//
// ///
// /// stand for 'mixin for [NodeBinaryContainer]' + ['immutable', 'unmodifiable', 'fixed', 'mutable']
// ///
// base mixin _M_NbCi<T, N extends NodeBinary<T, N>>
//     on NodeBinary<T, N>, _I_NodeBinaryContainer<T, N> {
//   @override
//   NodeBinaryContainer<T, N> get finished => _NbCi(data, next, previous);
// }
// // TODO:
//
//
// ///
// /// stand for [NodeBinaryEnqueueable] + [
// ///   "immutable",
// ///   "unmodifiable", "unmodifiable fixed previous", "unmodifiable fixed next",
// ///   "fixed previous", "fixed next", "fixed",
// ///   "mutable"
// /// ]
// ///
// final class _NbEi<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   const _NbEi(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEi<T> _construct(
//     T data,
//     covariant _NbEi<T>? next, [
//     covariant _NbEi<T>? previous,
//   ]) => _NbEi(data, next, previous);
// }
//
// final class _NbEu<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEu(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEu<T> _construct(
//     T data,
//     covariant _NbEu<T>? next, [
//     covariant _NbEu<T>? previous,
//   ]) => _NbEu(data, next, previous);
// }
//
// final class _NbEuFp<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEuFp(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEuFp<T> _construct(
//     T data,
//     covariant _NbEuFp<T>? next, [
//     covariant _NbEuFp<T>? previous,
//   ]) => _NbEuFp(data, next, previous);
// }
//
// final class _NbEuFn<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEuFn(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEuFn<T> _construct(
//     T data,
//     covariant _NbEuFn<T>? next, [
//     covariant _NbEuFn<T>? previous,
//   ]) => _NbEuFn(data, next, previous);
// }
//
// final class _NbEfP<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEfP(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEfP<T> _construct(
//     T data,
//     covariant _NbEfP<T>? next, [
//     covariant _NbEfP<T>? previous,
//   ]) => _NbEfP(data, next, previous);
// }
//
// final class _NbEfN<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEfN(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEfN<T> _construct(
//     T data,
//     covariant _NbEfN<T>? next, [
//     covariant _NbEfN<T>? previous,
//   ]) => _NbEfN(data, next, previous);
// }
//
// final class _NbEf<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEf(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEf<T> _construct(
//     T data,
//     covariant _NbEf<T>? next, [
//     covariant _NbEf<T>? previous,
//   ]) => _NbEf(data, next, previous);
// }
//
// final class _NbEm<T> extends NodeBinaryEnqueueable<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryEnqueueable<T>? next;
//
//   @override
//   final NodeBinaryEnqueueable<T>? previous;
//
//   _NbEm(this.data, [this.next, this.previous]);
//
//   @override
//   _NbEm<T> _construct(
//     T data,
//     covariant _NbEm<T>? next, [
//     covariant _NbEm<T>? previous,
//   ]) => _NbEm(data, next, previous);
// }
//
// ///
// /// stand for [NodeBinaryOrdered] + [
// ///   "immutable",
// ///   "unmodifiable", "unmodifiable fixed previous", "unmodifiable fixed next",
// ///   "fixed previous", "fixed next", "fixed",
// ///   "mutable"
// /// ]
// ///
// final class _NbOi<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   const _NbOi(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOi<T> _construct(
//     T data,
//     covariant _NbOi<T>? next, [
//     covariant _NbOi<T>? previous,
//   ]) => _NbOi(data, next, previous);
// }
//
// final class _NbOu<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOu(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOu<T> _construct(
//     T data,
//     covariant _NbOu<T>? next, [
//     covariant _NbOu<T>? previous,
//   ]) => _NbOu(data, next, previous);
// }
//
// final class _NbOuFp<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOuFp(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOuFp<T> _construct(
//     T data,
//     covariant _NbOuFp<T>? next, [
//     covariant _NbOuFp<T>? previous,
//   ]) => _NbOuFp(data, next, previous);
// }
//
// final class _NbOuFn<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOuFn(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOuFn<T> _construct(
//     T data,
//     covariant _NbOuFn<T>? next, [
//     covariant _NbOuFn<T>? previous,
//   ]) => _NbOuFn(data, next, previous);
// }
//
// final class _NbOfP<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOfP(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOfP<T> _construct(
//     T data,
//     covariant _NbOfP<T>? next, [
//     covariant _NbOfP<T>? previous,
//   ]) => _NbOfP(data, next, previous);
// }
//
// final class _NbOfN<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOfN(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOfN<T> _construct(
//     T data,
//     covariant _NbOfN<T>? next, [
//     covariant _NbOfN<T>? previous,
//   ]) => _NbOfN(data, next, previous);
// }
//
// final class _NbOf<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOf(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOf<T> _construct(
//     T data,
//     covariant _NbOf<T>? next, [
//     covariant _NbOf<T>? previous,
//   ]) => _NbOf(data, next, previous);
// }
//
// final class _NbOm<T> extends NodeBinaryOrdered<T> {
//   @override
//   final T data;
//   @override
//   final NodeBinaryOrdered<T>? next;
//
//   @override
//   final NodeBinaryOrdered<T>? previous;
//
//   _NbOm(this.data, [this.next, this.previous]);
//
//   @override
//   _NbOm<T> _construct(
//     T data,
//     covariant _NbOm<T>? next, [
//     covariant _NbOm<T>? previous,
//   ]) => _NbOm(data, next, previous);
// }

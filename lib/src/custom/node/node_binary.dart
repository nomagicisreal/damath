part of '../custom.dart';

///
/// For [NodeBinary], there is no similar implementation be like [NodeNextOperatable]
/// Both of 'append data to farthest node' and 'insert data by index' are not a good ideas for [NodeBinary].
///   - it's unclear to append on [previous] or [next], even the most [previous] or the most [next].
///   - not only 'the most', there are also interval depths, e.g. [previous]'s [next], [next]'s [previous]'s [next]...
///   - insertion by positive index for [next], negative index for [previous] are bad to represent interval depths.
/// therefore, [NodeBinary] should implement something more useful other then [NodeNextOperatable].
///
abstract final class NodeBinary<T, N extends NodeBinary<T, N>>
    extends NodeNext<T, N> {
  @override
  String toString() =>
      'Node:'
          '\n\t${NodeReader._buildString<N>(this as N, NodeReader._mapPrevious)}'
          '\n\t${NodeReader._buildString<N>(this as N, NodeReader._mapNext)}';

  N? get previous;

  set previous(covariant NodeBinary<T, N>? node) =>
      throw UnsupportedError(NodeNext.tryToModifyFinal);

  const NodeBinary();

  @override
  NodeBinary _construct(
      T data,
      covariant NodeBinary? next, [
        // ignore: unused_element_parameter
        NodeBinary? previous,
      ]);
}
//
// ///
// /// [NodeBinaryInstance.immutable]
// /// [NodeBinaryInstance.unmodifiable], ... 'Fp' stand for 'fixed previous'. 'Fn' stand for 'fixed next'
// /// [NodeBinaryInstance.fixedPrevious], ...
// /// [NodeBinaryInstance.mutable]
// ///
// abstract final class NodeBinaryInstance<T>
//     extends NodeBinary<T, NodeBinaryInstance<T>> {
//   const NodeBinaryInstance();
//
//   const factory NodeBinaryInstance.immutable(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIi;
//
//   factory NodeBinaryInstance.unmodifiable(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIu;
//
//   factory NodeBinaryInstance.unmodifiableFp(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIuFp;
//
//   factory NodeBinaryInstance.unmodifiableFn(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIuFn;
//
//   factory NodeBinaryInstance.fixedPrevious(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIfP;
//
//   factory NodeBinaryInstance.fixedNext(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIfN;
//
//   factory NodeBinaryInstance.fixed(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIf;
//
//   factory NodeBinaryInstance.mutable(
//       T data, [
//         NodeBinaryInstance<T>? next,
//         NodeBinaryInstance<T>? previous,
//       ]) = _NbIm;
// }
//
// ///
// /// it's a node type containing other node type, indicating its usecase is finished.
// ///
// abstract final class NodeBinaryContainer<T, N extends NodeBinary<T, N>>
//     extends NodeBinary<T, N> {
//   const NodeBinaryContainer();
// }
//
// ///
// /// [NodeBinaryEnqueueable]'s concept is derived from 'binary tree'. https://en.wikipedia.org/wiki/Binary_tree
// ///
// /// For large data, [NodeBinaryEnqueueable] is efficient than [NodeBinaryEnqueueable].
// /// Notice that 'large data' here is different from the term 'big data' in computer science.
// /// for example 1,000 is large enough to be called as 'large data', but 'big data' goes far beyond that.
// ///
// abstract final class NodeBinaryEnqueueable<T>
//     extends NodeBinary<T, NodeBinaryEnqueueable<T>>
//     implements
//         _I_NodeFinal<T, NodeBinaryEnqueueable<T>>,
//         _I_NodeNextContainer<T, NodeBinaryEnqueueable<T>>,
//         I_Enqueueable<T, void> {
//   const NodeBinaryEnqueueable();
//
//   @override
//   void enqueue(T element, ComparableMethod<T> method) => NodeWriter.push_binary(
//     this,
//     element,
//     method.predicate(element, data),
//     method.predicate,
//   );
// }
//
// ///
// ///
// ///
// abstract final class NodeBinaryOrdered<C extends Comparable>
//     extends NodeBinary<C, NodeBinaryOrdered<C>>
//     implements
//         _I_NodeFinal<C, NodeBinaryOrdered<C>>,
//         _I_NodeNextContainer<C, NodeBinaryOrdered<C>>,
//         I_Pushable<C, void> {
//   const NodeBinaryOrdered();
//
//   @override
//   void push(C element) => NodeWriter.push_binary(
//     this,
//     element,
//     element.orderAfter(data),
//     DamathComparableExtension.comparator_orderAfter<C>,
//   );
// }
//
// ///
// /// TODO: identical enqueueable,
// /// TODO: n-ary node
// ///

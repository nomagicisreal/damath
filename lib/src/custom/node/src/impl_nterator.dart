// ignore_for_file: camel_case_types
part of '../node.dart';

///
///
/// * [_M_Nterator]
///     --[Nterator]
///
///

///
///
///
mixin _M_Nterator<T, N extends NodeNext<T, N>> implements Iterator<T> {
  N? get _node;

  set _node(N? node);

  @override
  T get current =>
      _node?.data ?? (throw StateError(ErrorMessage.iterableNoElement));

  ///
  ///
  ///
  @override
  bool moveNext() {
    final node = _node;
    if (node == null) return false;
    final next = node.next;
    if (next == null) {
      _node = null;
      return false;
    }
    _node = node._construct(next.data, next.next) as N;
    return true;
  }

  int get length {
    final node = _node;
    return node == null ? 0 : node.length;
  }

  bool get isEmpty => _node == null;
}

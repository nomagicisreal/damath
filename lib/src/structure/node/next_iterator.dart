///
///
/// this file contains:
///
/// [IteratorNodeHead]
///
part of damath_structure;

///
///
///
class IteratorNodeHead<T> implements Iterator<T> {
  ///
  /// overrides
  ///
  @override
  String toString() => _nodeNext.toString();

  @override
  T get current =>
      _current?.data ?? (throw StateError(KErrorMessage.iteratorNoElement));

  @override
  bool moveNext() {
    final next = _nodeNext;
    if (next == null) return false;
    _current = next;
    _nodeNext = next._next;
    return true;
  }

  ///
  /// properties
  ///
  NodeHead<T>? _current;
  NodeHead<T>? _nodeNext;
  final Comparator<T> _comparator;

  ///
  /// constructor
  ///
  IteratorNodeHead(this._nodeNext, this._comparator);

  ///
  /// factory
  ///
  factory IteratorNodeHead.fromIterable(
    Iterable<T> iterable,
    Comparator<T> comparator,
    Mapper<T, NodeHead<T>> construct,
  ) =>
      iterable.iterator.reduceToInitialized(
        (first) => IteratorNodeHead(construct(first), comparator),
        (node, data) => node..input(data),
      );

  int get lengthRemain {
    final next = _nodeNext;
    if (next == null) return 0;
    var hasNext = true;
    var i = 1;
    for (; hasNext; i++) {
      try {
        next[i];
      } on RangeError catch (e) {
        if (e.message != KErrorMessage.nodeIndexOutOfBoundary) rethrow;
        break;
      }
    }
    return i - 1;
  }

  ///
  /// functions
  ///
  void input(T data) {
    final next = _nodeNext; // shared instance
    if (next == null) {
      _nodeNext = _current!._constructHead(data);
      return;
    }
    next.input(data, _comparator);
  }

  void inputAll(Iterable<T> iterable) {
    final iterator = iterable.iterator..moveNext();
    final next = _nodeNext == null
        ? _nodeNext = _current!._constructHead(iterator.current)
        : (_nodeNext!..input(iterator.current, _comparator));

    while (iterator.moveNext()) {
      next.input(iterator.current, _comparator);
    }
  }
}

part of '../collection.dart';

///
/// [IterableMapEntry]
/// [IteratorSet]
/// [IterableIterable]
///

///
///
///
extension IterableMapEntry<K, V> on Iterable<MapEntry<K, V>> {
  ///
  /// [toMap], [keys], [values]
  ///
  Map<K, V> get toMap => Map.fromEntries(this);

  Iterable<K> get keys => map((e) => e.key);

  Iterable<V> get values => map((e) => e.value);
}

///
/// [everyIdentical], ...
/// [reduceMerged]
///
extension IteratorSet<K> on Iterator<Set<K>> {
  ///
  /// [everyIdentical]
  ///
  bool get everyIdentical => supplyMoveNext(() {
    final set = Set.of(current);
    while (moveNext()) {
      if (current.any(set.add)) return false;
    }
    return true;
  });

  ///
  /// [reduceMerged]
  ///
  Set<K> reduceMerged([bool requireIdentical = false]) =>
      requireIdentical
          ? supplyMoveNext(() {
            final set = Set.of(current);
            while (moveNext()) {
              if (current.any(set.add)) {
                throw StateError('set not identical:\n$current\n$set');
              }
            }
            return set;
          })
          : fold({}, (set, other) => set..addAll(other));
}

///
/// [size]
/// [toStringPadLeft], [toStringMapJoin]
/// [isEqualElementsLengthTo]
/// [foldWith2D]
///
extension IterableIterable<I> on Iterable<Iterable<I>> {
  ///
  /// [predicateChildrenLength]
  ///
  static Predicator<Iterable<I>> predicateChildrenLength<I>(int n) =>
      (element) => element.length == n;

  ///
  /// [size]
  ///
  int get size =>
      iterator.induct(IterableExtension.toLength, IntExtension.reduce_plus);

  ///
  /// [toStringMapJoin]
  /// [toStringPadLeft]
  ///
  String toStringMapJoin([
    Mapper<Iterable<I>, String>? mapping,
    String separator = "\n",
  ]) => map(mapping ?? (e) => e.toString()).join(separator);

  String toStringPadLeft(int space) => toStringMapJoin(
    (row) => row.map((e) => e.toString().padLeft(space)).toString(),
  );

  ///
  /// [isEqualElementsLengthTo]
  ///
  bool isEqualElementsLengthTo<P>(Iterable<Iterable<P>> another) =>
      !anyWith(another, IterableExtension.predicateLengthDifferent);

  bool isEqualToNested(Iterable<Iterable<I>> another) =>
      !anyWith(another, IterableExtension.predicateDifferent);

  ///
  /// [foldWith2D]
  ///
  S foldWith2D<S, P>(
    Iterable<Iterable<P>> another,
    S initialValue,
    Forcer<S, I, P> fusionor,
  ) => foldWith(
    another,
    initialValue,
    (value, e, eAnother) => value = e.foldWith(eAnother, value, fusionor),
  );

  ///
  /// [whereLengthIs]
  ///
  Iterable<Iterable<I>> whereLengthIs(int n) =>
      where(predicateChildrenLength(n));

  ///
  /// [mapToListWhereLengthIs]
  /// [mapToListListWhereLengthIs]
  ///
  List<Iterable<I>> mapToListWhereLengthIs(int n) => [
    ...where(predicateChildrenLength(n)),
  ];

  List<List<I>> mapToListListWhereLengthIs(int n) {
    final result = <List<I>>[];
    for (final element in this) {
      result.addWhen(element.length == n, () => element.toList());
    }
    return result;
  }

  ///
  /// [flatted]
  /// [flattedList]
  ///
  Iterable<I> get flatted sync* {
    for (final element in this) {
      yield* element;
    }
  }

  List<I> get flattedList {
    final result = <I>[];
    for (final element in this) {
      result.addAll(element);
    }
    return result;
  }
}

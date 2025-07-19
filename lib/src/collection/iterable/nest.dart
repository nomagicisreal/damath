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
  /// [keys], [values]
  ///
  static Iterable<K> keys<K, V>(Iterable<MapEntry<K, V>> entries) =>
      entries.map((e) => e.key);

  static Iterable<V> values<K, V>(Iterable<MapEntry<K, V>> entries) =>
      entries.map((e) => e.value);
}

///
/// [everyIdentical], ...
/// [reduceMerged]
///
extension IteratorSet<K> on Iterator<Set<K>> {
  ///
  /// [everyIdentical]
  ///
  static bool everyIdentical<I>(Iterator<Iterable<I>> iterator) =>
      IteratorTo.supplyMoveNext(iterator, () {
        final set = Set.of(iterator.current);
        while (iterator.moveNext()) {
          if (iterator.current.any(set.add)) return false;
        }
        return true;
      });

  ///
  /// [reduceMerged]
  ///
  static Set<K> reduceMerged<K>(
    Iterator<Set<K>> iterator, [
    bool requireIdentical = false,
  ]) =>
      requireIdentical
          ? IteratorTo.supplyMoveNext(iterator, () {
            final set = Set.of(iterator.current);
            while (iterator.moveNext()) {
              if (iterator.current.any(set.add)) {
                throw StateError(
                  'set not identical:\n${iterator.current}\n$set',
                );
              }
            }
            return set;
          })
          : IteratorTo.fold(
            iterator,
            <K>{},
            (set, other) => set..addAll(other),
          );
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
  static int size<I>(Iterable<Iterable<I>> nested) => IteratorTo.induct(
    nested.iterator,
    IterableExtension.lengthOf,
    IntExtension.reduce_plus,
  );

  ///
  /// [toStringMapJoin]
  /// [toStringPadLeft]
  ///
  static String toStringMapJoin<I>(
    Iterable<Iterable<I>> iterable, [
    Mapper<Iterable<I>, String>? mapping,
    String separator = "\n",
  ]) => iterable.map(mapping ?? (e) => e.toString()).join(separator);

  static String toStringPadLeft<I>(Iterable<Iterable<I>> iterable, int space) =>
      toStringMapJoin(
        iterable,
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
      );

  ///
  /// [isEqualElementsLengthTo]
  ///
  static bool isEqualElementsLengthTo<I, P>(
    Iterable<Iterable<I>> iterable,
    Iterable<Iterable<P>> another,
  ) =>
      !IterableExtension.anyWith(
        iterable,
        another,
        IterableExtension.isLengthDifferent,
      );

  static bool isEqualToNested<I>(
    Iterable<Iterable<I>> iterable,
    Iterable<Iterable<I>> another,
  ) =>
      !IterableExtension.anyWith(
        iterable,
        another,
        IterableExtension.anyWithDifferent,
      );

  ///
  /// [foldWith2D]
  ///
  static S foldWith2D<I, P, S>(
    Iterable<Iterable<I>> iterable,
    Iterable<Iterable<P>> another,
    S initialValue,
    Forcer<S, I, P> fusionor,
  ) => IterableExtension.foldWith(
    iterable,
    another,
    initialValue,
    (value, e, eAnother) =>
        value = IterableExtension.foldWith(e, eAnother, value, fusionor),
  );

  ///
  /// [whereLengthIs]
  ///
  static Iterable<Iterable<I>> whereLengthIs<I>(
    Iterable<Iterable<I>> iterable,
    int n,
  ) => iterable.where(predicateChildrenLength(n));

  ///
  /// [mapToListWhereLengthIs]
  /// [mapToListListWhereLengthIs]
  ///
  static List<Iterable<I>> mapToListWhereLengthIs<I>(
    Iterable<Iterable<I>> iterable,
    int n,
  ) => [...iterable.where(predicateChildrenLength(n))];

  static List<List<I>> mapToListListWhereLengthIs<I>(
    Iterable<Iterable<I>> iterable,
    int n,
  ) {
    final result = <List<I>>[];
    for (final element in iterable) {
      result.addWhen(element.length == n, () => element.toList());
    }
    return result;
  }

  ///
  /// [flatted]
  /// [flattedList]
  ///
  static Iterable<I> flatted<I>(Iterable<Iterable<I>> iterable) sync* {
    for (final element in iterable) {
      yield* element;
    }
  }

  static List<I> flattedList<I>(Iterable<Iterable<I>> iterable) {
    final result = <I>[];
    for (final element in iterable) {
      result.addAll(element);
    }
    return result;
  }
}

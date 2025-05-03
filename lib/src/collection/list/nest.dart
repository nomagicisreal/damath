part of '../collection.dart';

///
/// [ListMapEntry]
/// [List2DExtension]
/// [ListSet]

///
///
///
extension ListMapEntry<K, V> on List<MapEntry<K, V?>> {
  void reset({V? fill}) => updateAllApply((entry) => MapEntry(entry.key, fill));
}


///
///
///
extension List2DExtension<T> on List2D<T> {
  ///
  /// [copyIntoIdentity]
  ///
  List2D<T> copyIntoIdentity(Reducer<T> reducing, int length, T fill) {
    final identity = List.filled(length, fill);
    return mapToList((t) => identity..updateReduce(reducing, t));
  }
}



///
/// [mergeToThis], ...
///
extension ListSet<I> on List<Set<I>> {
  ///
  /// [mergeToThis]
  /// [mergeToThat]
  /// [mergeWhereToTrailing]
  ///
  void mergeToThis(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeToThat(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereToTrailing(Predicator<Set<I>> test) =>
      add(removalWhere(test).iterator.reduceMerged());
}

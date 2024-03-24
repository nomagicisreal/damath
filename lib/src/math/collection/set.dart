///
///
/// this file contains:
///
/// [SetExtension]
///
///
part of damath_math;

///
///
///
extension SetExtension<K> on Set<K> {
  Set get copy => Set.of(this);

  ///
  /// [mapToMap]
  ///
  Map<K, V> mapToMap<V>(Mapper<K, V> toValue) =>
      Map.fromIterables(this, map(toValue));
}


///
///
///
extension SetIteratorExtension<K> on Iterator<Set<K>> {
  Set<K> get merged => reduce((a, b) => a..addAll(b));

  bool get everyIdentical => moveNextThen(() {
    var tempt = current.copy;
    while (moveNext()) {
      final lengthTotal = tempt.length + current.length;
      tempt.addAll(current);
      if (lengthTotal != tempt.length) return false;
    }
    return true;
  });
}
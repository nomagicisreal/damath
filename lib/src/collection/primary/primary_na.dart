///
///
/// this file contains:
///
/// [IteratorNullable]
/// [IterableNullable]
///
///
part of '../collection.dart';

///
///
/// [validFrequencies]
///
///
extension IteratorNullable<I> on Iterator<I?> {
  ///
  /// [validFrequencies]
  ///
  Map<I, double> validFrequencies([bool lengthValid = true]) {
    final map = <I, double>{};
    var length = 0;

    final Consumer<I?> consume = lengthValid
        ? (current) => current.consumeNotNull((key) {
      map.plusOn(key);
      length++;
    })
        : (current) {
      current.consumeNotNull(map.plusOn);
      length++;
    };

    while (moveNext()) {
      consume(current);
    }
    return map..updateAll((key, value) => value / length);
  }
}



///
///
/// [validLength]
///
///
extension IterableNullable<I> on Iterable<I?> {
  ///
  /// [validLength]
  ///
  int get validLength =>
      iterator.fold(0, (value, current) => current == null ? value : ++value);
}

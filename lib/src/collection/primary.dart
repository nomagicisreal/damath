part of 'collection.dart';

///
///
/// [MapNullable]
/// [IteratorBool]
/// [IteratorNullable]
/// [IterableNullable]
///
///

///
///
///
extension MapNullable<K, V> on Map<K, V?> {
  void reset({V? fill}) => updateAll((_, __) => fill);
}


///
/// static methods:
/// [_keep], ...
///
/// instance getters, methods:
/// [isSatisfiable], ...
/// [takeFor], ...
///
///
extension IteratorBool on Iterator<bool> {
  static bool _keep(bool value) => value;

  static bool _reverse(bool value) => !value;

  ///
  /// [isSatisfiable], [isTautology], [isContradiction], [isContingency]
  ///
  bool get isSatisfiable => any(_keep);

  bool get isTautology => !any(_reverse);

  bool get isContradiction => !any(_keep);

  bool get isContingency => existDifferent;

  ///
  /// [takeFor]
  /// [takeListFor]
  ///
  Iterable<I> takeFor<I>(Iterator<I> source) => [
    for (; moveNext() && source.moveNext();)
      if (current) source.current,
  ];

  List<I> takeListFor<I>(Iterator<I> source) => [
    for (; moveNext() && source.moveNext();)
      if (current) source.current,
  ];
}

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

    final consume =
        lengthValid
            ? (value) {
              if (value == null) return;
              map.plusOn(value);
              length++;
            }
            : (value) {
              length++;
              if (value == null) return;
              map.plusOn(value);
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

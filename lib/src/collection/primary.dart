part of 'collection.dart';

///
///
/// [MapNullable]
/// [IteratorBool]
/// [IteratorNullable]
/// [IterableNullable]
///
/// [DateExtension]
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
            ? (key) {
              if (key == null) return;
              map.plusOn(key);
              length++;
            }
            : (key) {
              length++;
              if (key == null) return;
              map.plusOn(key);
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

///
///
///
extension DateExtension on (int, int, int) {
  ///
  ///
  ///
  static int comparing((int, int, int) d1, (int, int, int) d2) {
    final cYear = d1.$1.compareTo(d2.$1);
    if (cYear != 0) return cYear;
    final cMonth = d1.$2.compareTo(d2.$2);
    if (cMonth != 0) return cMonth;
    final cDay = d1.$3.compareTo(d2.$3);
    return cDay;
  }

  ///
  /// [isValidDate]
  /// [daysToDates]
  /// [monthsToDates]
  ///
  bool get isValidDate =>
      this.$1 > 0 &&
      DateTimeExtension.isValidMonth(this.$2) &&
      DateTimeExtension.isValidDays(this.$1, this.$2, this.$3);

  int daysToDates((int, int, int) another) {
    final year = another.$1;
    final month = another.$2;
    final day = another.$3;

    final yearCurrent = this.$1;
    assert(yearCurrent <= year);
    final monthCurrent = this.$2;
    final dayCurrent = this.$3;

    // ==
    if (yearCurrent == year) {
      assert(monthCurrent <= month);
      if (monthCurrent == month) {
        assert(dayCurrent <= day);
        return day - dayCurrent;
      }
      var days = 0;
      final daysOf = DateTimeExtension.monthDaysOf;
      for (var m = monthCurrent; m < month; m++) {
        days += daysOf(yearCurrent, m);
      }
      return days + day - dayCurrent;
    }

    // <
    var days = 0;
    final daysOf = DateTimeExtension.monthDaysOf;
    final isLeapYear = DateTimeExtension.isYearLeapYear;
    final mEnd = DateTimeExtension.limitMonthEnd;
    for (var m = monthCurrent; m < mEnd; m++) {
      days += daysOf(yearCurrent, m);
    }
    final daysAYear = DateTimeExtension.daysAYearNormal;
    for (var y = yearCurrent + 1; y < year; y++) {
      days += daysAYear;
      if (isLeapYear(y)) days++;
    }
    for (var m = DateTime.january; m < month; m++) {
      days += daysOf(year, m);
    }
    return days + day - dayCurrent;
  }

  int monthsToDates(int year, int month) {
    final yearCurrent = this.$1;
    assert(yearCurrent <= year);
    final monthCurrent = this.$2;

    // ==
    if (yearCurrent == year) {
      assert(monthCurrent <= month);
      return month - monthCurrent;
    }
    return DateTimeExtension.limitMonthEnd -
        monthCurrent +
        DateTime.december * (year - yearCurrent) +
        month;
  }

  ///
  /// [_comparing], ...
  ///
  bool _comparing(
    (int, int, int) another,
    PredicatorReducer<int> reduceInvalid,
    PredicatorReducer<int> reduce,
    PredicatorReducer<int> reduceFinal,
  ) {
    final one = this.$1;
    final oneAnother = another.$1;
    if (reduceInvalid(one, oneAnother)) return false;
    if (reduce(one, oneAnother)) return true;
    final two = this.$2;
    final twoAnother = another.$2;
    if (reduceInvalid(two, twoAnother)) return false;
    if (reduce(two, twoAnother)) return true;
    final three = this.$3;
    final threeAnother = another.$3;
    if (reduceInvalid(three, threeAnother)) return false;
    return reduceFinal(three, threeAnother);
  }

  bool operator >((int, int, int) another) => _comparing(
    another,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_larger,
  );

  bool operator <((int, int, int) another) => _comparing(
    another,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_less,
  );

  bool operator >=((int, int, int) another) => _comparing(
    another,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_largerOrEqual,
  );

  bool operator <=((int, int, int) another) => _comparing(
    another,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_lessOrEqual,
  );
}

part of 'collection.dart';

///
///
/// [MapNullable]
/// [IteratorBool]
/// [IteratorNullable]
/// [IterableNullable]
///
/// [Record3Int]
///
///

///
///
///
extension MapNullable<K, V> on Map<K, V?> {
  void reset({V? fill}) => updateAll((_, _) => fill);
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
extension Record2Int on (int, int) {
  ///
  ///
  ///
  static int comparing((int, int) r1, (int, int) r2) {
    final c1 = r1.$1.compareTo(r2.$1);
    if (c1 != 0) return c1;
    final c2 = r1.$2.compareTo(r2.$2);
    return c2;
  }

  ///
  ///
  /// [_comparing],
  /// [>], [<], [largerThan3], [lessThan3]
  /// [>=], [<=], [largerOrEqualThan3], [lessOrEqualThan3]
  ///
  ///
  bool _comparing(
    int a,
    int b,
    PredicatorReducer<int> reduceInvalid,
    PredicatorReducer<int> reduce,
    PredicatorReducer<int> reduceFinal,
  ) {
    final one = this.$1;
    if (reduceInvalid(one, a)) return false;
    if (reduce(one, a)) return true;
    final two = this.$2;
    if (reduceInvalid(two, b)) return false;
    return reduceFinal(two, b);
  }

  bool operator >((int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_larger,
  );

  bool operator <((int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_less,
  );

  bool largerThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_larger,
  );

  bool lessThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_less,
  );

  bool operator >=((int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_largerOrEqual,
  );

  bool operator <=((int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_lessOrEqual,
  );

  bool largerOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_largerOrEqual,
  );

  bool lessOrEqualThan3((int, int, int) other) => _comparing(
    other.$1,
    other.$2,
    IntExtension.predicateReduce_larger,
    IntExtension.predicateReduce_less,
    IntExtension.predicateReduce_lessOrEqual,
  );

  ///
  /// [monthsToYearMonth]
  /// [daysToDate]
  /// [daysToDate]
  ///
  int monthsToYearMonth(int year, int month) {
    assert(
      DateTimeExtension.isValidYearMonthScope(this, (year, month)),
      'invalid date: $this, ($year, $month)',
    );
    final y = this.$1;
    return month - this.$2 + y == year
        ? 0
        : DateTimeExtension.limitMonthEnd + DateTime.december * (year - y);
  }

  int daysToDate(int year, int month, [int? day]) {
    assert(
      DateTimeExtension.isValidYearMonthScope(this, (year, month)),
      'invalid date: $this, ($year, $month)',
    );
    assert(
      day == null || DateTimeExtension.isValidDay(year, month, day),
      'invalid day: ($year, $month, $day)',
    );
    final yearCurrent = this.$1;
    final daysOf = DateTimeExtension.monthDaysOf;
    var d = 0;
    var m = this.$2;
    if (yearCurrent < year) {
      for (; m < 13; m++) {
        d += daysOf(yearCurrent, m);
      }
      for (var y = yearCurrent + 1; y < year; y++) {
        d += DateTimeExtension.yearDaysOf(y);
      }
      m = 1;
    }
    for (; m < month; m++) {
      d += daysOf(year, m);
    }
    return d + (day ?? daysOf(year, month));
  }
}

///
///
/// static methods:
/// [comparing], ...
///
/// instance methods:
/// return void:      [consumeTo], ...
/// return bool:      [isValidDate], ...
/// return int:       [daysToDates], ...
///
///
extension Record3Int on (int, int, int) {
  ///
  ///
  ///
  static int comparing((int, int, int) r1, (int, int, int) r2) {
    final c1 = r1.$1.compareTo(r2.$1);
    if (c1 != 0) return c1;
    final c2 = r1.$2.compareTo(r2.$2);
    if (c2 != 0) return c2;
    final c3 = r1.$3.compareTo(r2.$3);
    return c3;
  }

  ///
  ///
  ///
  static BiCallback<(int, int, int)> biCallbackFrom(
    TriCallback<int> consume,
    Applier<int> toKeyKeyBegin,
    Applier<int> toKeyKeyLimit,
    Reducer<int> toValueBegin,
    Reducer<int> toValueLimit,
  ) => (begin, end) {
    final a1 = begin.$1;
    final a2 = begin.$2;
    final a3 = begin.$3;
    final b1 = end.$1;
    assert(a1 <= b1);
    final b2 = end.$2;
    final b3 = end.$3;

    // ==
    if (a1 == b1) {
      assert(a2 <= b2);

      // ==
      if (a2 == b2) {
        assert(a3 <= b3);
        for (var i = a3; i <= b3; i++) {
          consume(a1, a2, i);
        }
        return;
      }

      // <
      var i = a3;
      var limit = toValueLimit(a1, a2);
      for (; i < limit; i++) {
        consume(a1, a2, i);
      }
      for (var j = a2 + 1; j < b2; j++) {
        limit = toValueLimit(a1, j);
        for (i = toValueBegin(a1, j); i < limit; i++) {
          consume(a1, j, i);
        }
      }
      for (i = toValueBegin(a1, b2); i <= b3; i++) {
        consume(a1, b2, i);
      }
      return;
    }

    // <
    var i = a3;
    var limit = toValueLimit(a1, a2);
    for (; i < limit; i++) {
      consume(a1, a2, i);
    }
    var j = a2 + 1;
    var limitKeyKey = toKeyKeyLimit(a1);
    for (; j < limitKeyKey; j++) {
      limit = toValueLimit(a1, j);
      for (i = toValueBegin(a1, j); i < limit; i++) {
        consume(a1, j, i);
      }
    }
    for (var k = a1 + 1; k < b1; k++) {
      limitKeyKey = toKeyKeyLimit(k);
      for (j = toKeyKeyBegin(k); j < limitKeyKey; j++) {
        limit = toValueLimit(k, j);
        for (i = toValueBegin(k, j); i < limit; i++) {
          consume(k, j, i);
        }
      }
    }
    for (j = toKeyKeyBegin(b1); j < b2; j++) {
      limit = toValueLimit(b1, j);
      for (i = toValueBegin(b1, j); i < limit; i++) {
        consume(b1, j, i);
      }
    }
    limit = toValueLimit(b1, b2);
    for (i = toValueBegin(b1, b2); i < limit; i++) {
      consume(b1, b2, i);
    }
  };

  ///
  /// [isValidDate]
  /// [_comparing],
  /// [>], [<], [>=], [<=]
  ///
  bool get isValidDate => DateTimeExtension.isValidDate(this);

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

  ///
  /// [daysToDates]
  ///
  int daysToDates((int, int, int) another) {
    assert(
      DateTimeExtension.isValidDate(this) &&
          DateTimeExtension.isValidDate(another),
      'invalid date: $this, $another',
    );
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
}

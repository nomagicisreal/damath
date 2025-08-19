part of '../primary.dart';

///
///
/// [Developing]
/// [ErrorMessage]
/// [ErrorMessage]
/// ----------------
///
/// [NullableExtension]
/// [BoolExtension]
/// [NumExtension]
/// [BigIntExtension]
/// [RandomExtension]
/// ----------------
///
/// [Weekday]
///
///

extension Developing on dynamic {
  ///
  /// [printThis], [logThis]
  ///
  void printThis([Object? object, Mapper<Object, Object>? mapper]) =>
      print(object ?? mapper?.call(this) ?? this);

  void logThis({
    String? message,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) => log(message ?? toString());
}

///
/// [iterableNoElement], ...
///
extension ErrorMessage on Error {
  ///
  /// general
  ///
  static const String pass = 'pass';
  static const String modifyImmutable = 'cannot modify immutables';
  static const String receiveNull = 'receive null';
  static const String lazyNotYetInit = 'lazy not yet init';

  ///
  /// iterator, iterable
  ///
  static const String iterableNoElement = 'iterable no element';
  static const String iterableElementNotFound = 'iterable element not found';
  static const String iterableElementNotNest = 'iterable element not nested';
  static const String iterableBoundaryInvalid = 'iterable boundary invalid';
  static const String iterableSizeInvalid = 'iterable size invalid';

  ///
  /// comparable
  ///
  static String comparableDisordered = 'comparable disordered';

  ///
  /// others
  ///
  static const String percentileOutOfBoundary = 'percentile out of boundary';
  static const String unsupportedSwitchCase = 'unsupported switch case';
  static const String numberNatural = 'number is natural';
  static const String regexNotMatchAny = 'regex not match any';
}

///
/// [invalidIndex], ...
/// [validateMonth], ...
///
extension Erroring on Error {
  ///
  ///
  ///
  static const String name_invalidYearMonthScope = 'invalid year month scope';
  static const String name_invalidRangeBoundary = 'invalid range boundary';
  static const String name_invalidMonth = 'invalid month';
  static const String name_invalidHour = 'invalid hour';
  static const String name_invalidMinute = 'invalid minute';
  static const String name_invalidInt = 'invalid int';
  static const String name_invalidPartition = 'invalid partition';

  ///
  /// functions
  ///
  static ArgumentError invalidInt(int i) =>
      ArgumentError.value(i, name_invalidInt);

  static ArgumentError invalidPartition(int m, int n) =>
      ArgumentError('$m into $n group', name_invalidPartition);

  static ArgumentError invalidMonth(int month) =>
      ArgumentError.value(month, name_invalidMonth);

  static ArgumentError invalidHour(int hour) =>
      ArgumentError.value(hour, name_invalidHour);

  static ArgumentError invalidMinute(int minute) =>
      ArgumentError.value(minute, name_invalidMinute);

  static ArgumentError invalidYearMonthsScope(
    (int, int) monthBegin,
    (int, int) monthEnd,
  ) => ArgumentError.value(
    '${monthBegin.$1}.${monthBegin.$2} ~ ${monthEnd.$1} ~ ${monthEnd.$2}',
    name_invalidYearMonthScope,
  );

  static ArgumentError invalidRangeBoundary(int begin, int end) =>
      ArgumentError.value('$begin ~ $end', name_invalidRangeBoundary);

  //
  static RangeError invalidIndex(int index, [int? max]) =>
      RangeError.range(index, 0, max);

  static RangeError invalidIntOver(int i, [int min = 0]) =>
      RangeError.range(i, min, i - 1);

  //
  static StateError invalidComparableResult(int value) =>
      StateError('comparable value not provided: $value');
}

extension NullableExtension<T> on T? {
  S? nullOrMap<S>(Mapper<T, S> mapper) {
    if (this == null) return null;
    return mapper(this as T);
  }
}

///
///
///
extension BoolExtension on bool {
  String get toStringTOrF => this ? 'T' : 'F';
}

///
/// static methods:
/// [predicateLarger], ...
///
/// instance methods:
/// [squared], ...
/// [isRangeClose], ...
/// [digit], ...
///
extension NumExtension on num {
  ///
  ///
  ///
  static bool predicate_larger(num a, num b) => a > b;

  static bool predicate_less(num a, num b) => a < b;

  static bool predicate_equal(num a, num b) => a == b;

  ///
  ///
  ///
  bool isRangeClose(num lower, num upper) => this >= lower && this <= upper;

  bool isRangeOpen(num lower, num upper) => this > lower && this < upper;

  bool isRangeOpenLower(num lower, num upper) => this > lower && this <= upper;

  bool isRangeOpenUpper(num lower, num upper) => this >= lower && this < upper;

  ///
  ///
  ///
  bool isOutsideClose(num lower, num upper) => this <= lower || this >= upper;

  bool isOutsideOpen(num lower, num upper) => this < lower || this > upper;

  ///
  ///
  ///
  bool isLowerClose(num a, [num? b, num to = double.infinity]) =>
      b == null ? this <= a && a <= to : this <= a && a <= b && b <= to;

  bool isLowerOpen(num a, [num? b, num to = double.infinity]) =>
      b == null ? this < a && a < to : this < a && a < b && b < to;

  bool isUpperClose(num a, [num? b, num from = double.negativeInfinity]) =>
      b == null ? from <= a && a < this : from <= a && a < b && b <= this;

  bool isUpperOpen(num a, [num? b, num from = double.negativeInfinity]) =>
      b == null ? from <= a && a < this : from < a && a < b && b < this;

  ///
  ///
  ///
  num get squared => this * this;

  num powBy(num x) => math.pow(x, this);

  ///
  ///
  ///
  int get digit {
    if (this == 0) return 0;
    var value = abs();
    var n = 0;
    for (; value >= 1; value /= 10, n++) {}
    return n;
  }
}

///
///
///
extension BigIntExtension on BigInt {
  ///
  ///
  ///
  static Error error_invalidToInt(BigInt value) =>
      StateError('BigInt is not a valid int: $value');

  ///
  ///
  ///
  int get toIntValidated =>
      isValidInt ? toInt() : throw error_invalidToInt(this);

  ///
  ///
  ///
  bool get isPrime {
    if (this < BigInt.two) return false;
    if (this == BigInt.two || this == BigInt.from(3)) return true;
    if (isEven) return false;
    final max = math.sqrt(toIntValidated);
    if (max.isInteger) return false;
    final m = BigInt.from(max);
    for (var i = BigInt.from(3); i < m; i += BigInt.two) {
      if (this % i == BigInt.zero) return false;
    }
    return true;
  }

  bool get isComposite {
    if (this < BigInt.two) return false;
    if (isEven) return true;
    final max = math.sqrt(toIntValidated);
    if (max.isInteger) return true;
    final m = BigInt.from(max);
    for (var i = BigInt.from(3); i < m; i += BigInt.two) {
      if (this % i == BigInt.zero) return true;
    }
    return false;
  }

  ///
  ///
  ///
  bool isCoprime(BigInt other) => gcd(other) == BigInt.one;

  BigInt? modInverseOrNull(BigInt other) =>
      isCoprime(other) ? modInverse(other) : null;

  ///
  /// [isPseudoPrimeTo]
  ///
  // 561 is Carmichael Number (is pseudo prime for all Z)
  bool isPseudoPrimeTo(BigInt base) =>
      isComposite &&
      gcd(base) == BigInt.one &&
      (base.pow((this - BigInt.one).toIntValidated) - BigInt.one) % this ==
          BigInt.zero;
}

///
///
///
extension RandomExtension on math.Random {
  static bool get binary => math.Random().nextBool();

  static double get doubleIn1 => math.Random().nextDouble();

  static int intTo(int max) => math.Random().nextInt(max);

  static double doubleOf(int max, [int digit = 1]) =>
      (math.Random().nextInt(max) * 0.1.powBy(digit)).toDouble();

  static T get1FromList<T>(List<T> list) =>
      list[math.Random().nextInt(list.length)];
}

///
///
///
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory Weekday.from(DateTime dateTime) => switch (dateTime.weekday) {
    DateTime.monday => monday,
    DateTime.tuesday => tuesday,
    DateTime.wednesday => wednesday,
    DateTime.thursday => thursday,
    DateTime.friday => friday,
    DateTime.saturday => saturday,
    DateTime.sunday => sunday,
    _ => throw ArgumentError('date time weekday: ${dateTime.weekday}'),
  };
}

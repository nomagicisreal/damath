part of '../core.dart';

///
///
/// [primesIn100],
/// [accumulatedIn100],
/// [factorialIn20],
/// [partitionsIn20], [partitionsSetIn6]
///
/// [durationMilli1], ...
///
///
///
abstract interface class KCore {
  const KCore();

  ///
  /// ```
  /// final primes = <int>[2, 3];
  /// find:
  /// for (var i = 4; i < 1e2; i++) {
  ///   for (var prime in primes) {
  ///     // if (prime > i) break;
  ///     if (i % prime == 0) continue find;
  ///   }
  ///   primes.add(i);
  /// }
  /// print(primes);
  /// ```
  ///
  static const List<int> primesIn100 = [
    2,
    3,
    5,
    7,
    11,
    13,
    17,
    19,
    23,
    29,
    31,
    37,
    41,
    43,
    47,
    53,
    59,
    61,
    67,
    71,
    73,
    79,
    83,
    89,
    97
  ];

  ///
  ///
  /// ```
  /// var value = 0;
  /// for (var i = 1; i <= this; i++) {
  ///   value += i;
  /// }
  /// print(value);
  /// ```
  ///
  static const List<int> accumulatedIn100 = [
    1,
    3,
    6,
    10,
    15,
    21,
    28,
    36,
    45,
    55,
    66,
    78,
    91,
    105,
    120,
    136,
    153,
    171,
    190,
    210,
    231,
    253,
    276,
    300,
    325,
    351,
    378,
    406,
    435,
    465,
    496,
    528,
    561,
    595,
    630,
    666,
    703,
    741,
    780,
    820,
    861,
    903,
    946,
    990,
    1035,
    1081,
    1128,
    1176,
    1225,
    1275,
    1326,
    1378,
    1431,
    1485,
    1540,
    1596,
    1653,
    1711,
    1770,
    1830,
    1891,
    1953,
    2016,
    2080,
    2145,
    2211,
    2278,
    2346,
    2415,
    2485,
    2556,
    2628,
    2701,
    2775,
    2850,
    2926,
    3003,
    3081,
    3160,
    3240,
    3321,
    3403,
    3486,
    3570,
    3655,
    3741,
    3828,
    3916,
    4005,
    4095,
    4186,
    4278,
    4371,
    4465,
    4560,
    4656,
    4753,
    4851,
    4950,
    5050,
  ];

  ///
  ///
  /// factorial numbers over 20 require [BigInt]
  /// ```
  /// var value = 1;
  /// for (var i = 2; i <= this; i++) {
  ///   value *= i;
  /// }
  /// print(value);
  /// ```
  ///
  ///
  static const List<int> factorialIn20 = [
    1,
    2,
    6,
    24,
    120,
    720,
    5040,
    40320,
    362880,
    3628800,
    39916800,
    479001600,
    6227020800,
    87178291200,
    1307674368000,
    20922789888000,
    355687428096000,
    6402373705728000,
    121645100408832000,
    2432902008176640000,
  ];

  ///
  ///
  /// partition, see also [CountingExtension.partition]
  ///
  /// let m be the index of outer list
  /// when [m] == 2,
  /// "[1, 1]" indicates that there is only 1 way to partition integer 2 into, 1 group or 2 group;
  /// when [m] == 3,
  /// "[1, 1, 1]" indicates that there is only 1 way to partition integer 3 into, 1 group, 2 group, 3 group.
  ///
  ///
  static const List2D<int> partitionsIn20 = [
    [1],
    [1, 1],
    [1, 1, 1],
    [1, 2, 1, 1],
    [1, 2, 2, 1, 1], // 5
    [1, 3, 3, 2, 1, 1],
    [1, 3, 4, 3, 2, 1, 1],
    [1, 4, 5, 5, 3, 2, 1, 1],
    [1, 4, 7, 6, 5, 3, 2, 1, 1],
    [1, 5, 8, 9, 7, 5, 3, 2, 1, 1], // 10
    [1, 5, 10, 11, 10, 7, 5, 3, 2, 1, 1],
    [1, 6, 12, 15, 13, 11, 7, 5, 3, 2, 1, 1],
    [1, 6, 14, 18, 18, 14, 11, 7, 5, 3, 2, 1, 1],
    [1, 7, 16, 23, 23, 20, 15, 11, 7, 5, 3, 2, 1, 1],
    [1, 7, 19, 27, 30, 26, 21, 15, 11, 7, 5, 3, 2, 1, 1], // 15
    [1, 8, 21, 34, 37, 35, 28, 22, 15, 11, 7, 5, 3, 2, 1, 1],
    [1, 8, 24, 39, 47, 44, 38, 29, 22, 15, 11, 7, 5, 3, 2, 1, 1],
    [1, 9, 27, 47, 57, 58, 49, 40, 30, 22, 15, 11, 7, 5, 3, 2, 1, 1],
    [1, 9, 30, 54, 70, 71, 65, 52, 41, 30, 22, 15, 11, 7, 5, 3, 2, 1, 1],
    [1, 10, 33, 64, 84, 90, 82, 70, 54, 42, 30, 22, 15, 11, 7, 5, 3, 2, 1, 1],
  ];

  ///
  ///
  ///
  static const durationMilli1 = Duration(milliseconds: 1);
  static const durationMilli100 = Duration(milliseconds: 100);
  static const durationMilli200 = Duration(milliseconds: 200);
  static const durationMilli300 = Duration(milliseconds: 300);
  static const durationMilli400 = Duration(milliseconds: 400);
  static const durationMilli500 = Duration(milliseconds: 500);
  static const durationMilli600 = Duration(milliseconds: 600);
  static const durationMilli700 = Duration(milliseconds: 700);
  static const durationMilli800 = Duration(milliseconds: 800);
  static const durationMilli900 = Duration(milliseconds: 900);
  static const durationSecond1 = Duration(seconds: 1);
  static const durationMin1 = Duration(minutes: 1);
}

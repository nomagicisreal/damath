part of '../primary.dart';

///
/// constants:
/// [primesIn100]
/// [accumulatedIn100]
/// [factorialIn20]
/// [partitionsIn20]
///
/// static methods:
/// [reducePlus], ...
/// [accumulation]
/// [fibonacci]
/// [collatzConjecture]
/// [stoneTakingFinal]
/// [pascalTriangle], [combination]
/// [partition], ...
///
/// instance getters, methods:
/// [isPrime], ...
/// [accumulated], ...
/// [leadingValue], ...
/// [paritySame], ...
/// [toIterable], ...
///
///
extension IntExtension on int {
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
  /// partition, see also [IntExtension.partition]
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
  /// reduce
  /// [reducePlus], [reduceMinus], [reduceMultiply], [reduceDivided], [reduceMod]
  /// [reducePlusSquared], [reducePlusFactorial]
  ///
  static int reducePlus(int v1, int v2) => v1 + v2;

  static int reduceMinus(int v1, int v2) => v1 - v2;

  static int reduceMultiply(int v1, int v2) => v1 * v2;

  static int reduceDivided(int v1, int v2) => v1 ~/ v2;

  static int reduceMod(int v1, int v2) => v1 % v2;

  // chained operation
  static int reducePlusSquared(int v1, int v2) => v1 * v1 + v2 * v2;

  static int reducePlusFactorial(int v1, int v2) => v1.factorial + v2.factorial;

  static int reduceMultiplyFactorial(int v1, int v2) =>
      v1.factorial * v2.factorial;

  ///
  /// [accumulation] ([1, 3, 6, 10, 15, ...])
  ///
  static Iterable<int> accumulation(int end, {int start = 0}) sync* {
    for (int i = start; i <= end; i++) {
      yield i.accumulated;
    }
  }

  ///
  /// [fibonacci]
  ///   [lucas] == false: [1, 1, 2, 3, 5, 8, 13, ...]
  ///   [lucas] == true:  [1, 3, 4, 7, 11, 18, 29, ...]
  ///
  static Iterable<int> fibonacci(int k, [bool lucas = false]) sync* {
    assert(k > 0);
    yield 1;
    if (k < 2) return;
    yield lucas ? 3 : 1;
    if (k < 3) return;

    var a = 1;
    var b = lucas ? 3 : 1;
    final max = k - 2;
    for (var i = 0; i < max; i++) {
      final current = a + b;
      yield current;
      a = b;
      b = current;
    }
  }

  ///
  /// [collatzConjecture]
  ///
  static Iterable<int> collatzConjecture(int value, [int scale = 3]) sync* {
    assert(value != 0);
    yield value;
    while (value != 1) {
      value = (value.isOdd ? value * scale + 1 : value / 2).toInt();
      yield value;
    }
  }

  ///
  /// [stoneTakingFinal]
  ///
  /// Suppose there is [n] people play a game taking turns removing stones from [limitLower] to [limitUpper],
  /// and there is [total] stones. the person remove tha last stone wins the game. for example,
  /// if [n] = 2, [limitLower] = 1, [limitUpper] = 3, [total] = 15,
  /// it returns (4, 8, 12), which means the remain stones that the winning person should leave.
  ///
  static Iterable<int> stoneTakingFinal(
    int n,
    int total,
    int limitLower,
    int limitUpper,
  ) sync* {
    if (n < 2 ||
        total < n ||
        limitLower.isOutsideClose(0, limitUpper) ||
        limitUpper.isOutsideClose(limitLower, total)) {
      throw ArgumentError(
        ErrorMessages.intStoneTakingFinal(n, total, limitLower, limitUpper),
      );
    }

    final interval = limitLower + limitUpper * (n - 1);
    for (var step = interval; step <= total; step += interval) {
      yield step;
    }
  }

  ///
  /// [pascalTriangle]
  /// [binomialCoefficient]
  /// [combination]
  ///

  ///
  /// [pascalTriangle] calculate the 2D array like
  /// 1,
  /// 1, 1
  /// 1, 2, 1
  /// 1, 3, 3, 1
  /// 1, 4, 6, 4, 1
  /// 1, 5, 10, 10, 5, 1
  /// 1, 6, 15, 20, 15, 6, 1 ...,
  /// and this function do
  /// 1. create temporary [Array2D], for example,
  ///   row0: [1, 2, 1, 0, 0, 0]
  ///   row1: [1, 3, 3, 1, 0, 0]
  ///   row2: [1, 4, 0, 4, 1, 0]
  ///   row3: [1, 5, 0, 0, 5, 1] ...
  /// 2. replace 'middle 0' with the correct value. for example,
  ///   row0: [1, 2, 1, 0, 0, 0]
  ///   row1: [1, 3, 3, 1, 0, 0]
  ///   row2: [1, 4, 6, 4, 1, 0]
  ///   row3: [1, 5, 10, 10, 5, 1] ...
  /// 3. return [Array2D]
  ///
  /// when [rowStart] == 2, return array be like:
  ///   row0: [1, 2, 1, 0, ....]
  ///   row1: [1, 3, 3, 1, ....]
  ///   row2: [1, 4, 6, 4, ....] ...
  /// when [rowStart] == 3, return array be like:
  ///   row0: [1, 3, 3, 1, ....]
  ///   row1: [1, 4, 6, 4, ....]
  ///   row2: [1, 5, 10, 10, ....] ...
  /// ...
  ///
  static List2D<int> pascalTriangle(
    int n,
    int k, {
    int rowStart = 0,
    bool isColumnEndAtK = true,
  }) {
    if (n < 1 || k < 1 || k > n + 1 || rowStart > 3) {
      throw ArgumentError(ErrorMessages.intPascalTriangle(n, k));
    }

    final rowEnd = n + 1 - rowStart;
    final columnEndOf =
        isColumnEndAtK ? (i) => i + rowStart < k ? i + 1 : k : (i) => i + 1;

    final array = DamathListExtension.generate2D<int>(
      rowEnd,
      k,
      (i, j) => j == 0 || j == i + rowStart
          ? 1
          : j == 1 || j == i + rowStart - 1
              ? i + rowStart
              : 0,
    );

    for (int i = 4 - rowStart; i < rowEnd; i++) {
      final bound = columnEndOf(i);
      for (int j = 2; j < bound; j++) {
        array[i][j] = array[i - 1][j - 1] + array[i - 1][j];
      }
    }
    return array;
  }

  ///
  /// [combination]
  ///
  static int combination(int n, int k) {
    if (n < 1 || k.isNegative || k > n) {
      throw ArgumentError(ErrorMessages.intBinomialCoefficient(n, k));
    }
    var value = 1.0;
    while (k > 0) {
      value *= n-- / k--;
    }
    return value.toInt();
  }

  ///
  /// [partition]
  /// [partitionSet]
  /// [partitionPredicate]
  ///
  ///

  ///
  /// [partition] returns the integer representing the possible partition in [n] groups for [m] equal elements.
  ///
  /// for example, when [m] = 7, [n] = 4,
  /// this function return 3 because there are 3 possible partitions in 4 groups for 7:
  ///   1. [4, 1, 1, 1]
  ///   2. [3, 2, 1, 1]
  ///   3. [2, 2, 2, 1]
  /// for another example, when [m] = 5, [n] = null,
  /// this function return 7 because there are 7 possible partitions for 5:
  ///   1. [5]
  ///   2. [4, 1]
  ///   3. [3, 2]
  ///   4. [3, 1, 1]
  ///   5. [2, 2, 1]
  ///   6. [2, 1, 1, 1]
  ///   7. [1, 1, 1, 1, 1]
  ///
  static int partition(int m, [int? n]) {
    if (m.isNegative) throw ArgumentError(ErrorMessages.intPartitionM(m));
    if (n != null) {
      if (n.isRangeClose(1, m)) {
        throw ArgumentError(ErrorMessages.intPartitionN(m, n));
      }
      return _partitionSet(m)
          .map(DamathIterable.toLength)
          .iterator
          .toMapCounted[n]!;
    }
    var sum = 0;
    for (var i = 1; i <= m; i++) {
      sum += _partitionSet(m)
          .map(DamathIterable.toLength)
          .iterator
          .toMapCounted[i]!;
    }
    return sum;
  }

  ///
  /// [partitionSet] returns a list representing the possible partition set in [n] groups for [m] equal elements.
  ///
  /// for example, when [m] = 8, [n] = 4, this function returns a list with elements:
  ///   - [5, 1, 1, 1]
  ///   - [4, 2, 1, 1]
  ///   - [3, 3, 1, 1]
  ///   - [3, 2, 2, 1]
  ///   - [2, 2, 2, 2]
  /// for another example, when [m] = 3, [n] = null, this function returns a list with elements:
  ///   - [3]
  ///   - [2, 1]
  ///   - [1, 1, 1]
  ///
  static Iterable<int> partitionSet(int m, [int? n]) sync* {
    if (m.isNegative) throw ArgumentError(ErrorMessages.intPartitionM(m));
    if (n != null) {
      if (n.isRangeClose(1, m)) {
        throw ArgumentError(ErrorMessages.intPartitionN(m, n));
      }
      yield* _partitionSet(m).where((element) => element.length == n).flatted;
    }
    for (var i = 1; i <= m; i++) {
      yield* _partitionSet(m)
          .where(DamathIterableIterable.predicateChildrenLength(i))
          .flatted;
    }
  }

  ///
  /// [partitionPredicate] predicates if an [Iterable]<[int]> is a valid partition for [m] and [n].
  ///
  /// for example, when [m] = 4, [n] = 2,
  /// this functions returns true only if [integers] is one of [3, 1], [1, 3], [2, 2].
  ///
  static bool partitionPredicate(Iterable<int> integers, int m, int n) {
    if (m < 1) throw ArgumentError(ErrorMessages.intPartitionM(m));
    if (n.isRangeClose(1, m)) {
      throw ArgumentError(ErrorMessages.intPartitionN(m, n));
    }
    return integers.length == n && integers.sum == m;
  }

  //
  static Iterable<Iterable<int>> _partitionSet(int m) sync* {
    final list = List.filled(m, 0);
    list[0] = m;
    yield list.take(1);
    for (var k = 0; list[0] != 1; k++) {
      var val = 0;
      for (; k >= 0 && list[k] == 1; k--) {
        val += list[k];
      }
      list[k]--;
      val++;
      for (; val > list[k]; k++) {
        list[k + 1] = list[k];
        val -= list[k];
      }
      list[k + 1] = val;
      yield list.take(k + 2);
    }
  }

  ///
  /// [isPrime]
  /// [isComposite]
  ///
  bool get isPrime {
    if (this < 2) return false;
    if (this == 2 || this == 3) return true;
    if (isEven) return false;
    final max = math.sqrt(this);
    if (max.isInteger) return false;
    for (var i = 3; i < max; i += 2) {
      if (this % i == 0) return false;
    }
    return true;
  }

  bool get isComposite {
    if (this < 2) return false;
    if (isEven) return true;
    final max = math.sqrt(this);
    if (max.isInteger) return true;
    for (var i = 3; i < max; i += 2) {
      if (this % i == 0) return true;
    }
    return false;
  }

  ///
  /// [accumulated], [factorial]
  ///
  int get accumulated {
    if (this < 0) throw ArgumentError(ErrorMessages.invalidInteger(this));
    if (this < 101) return IntExtension.accumulatedIn100[this - 1];
    var value = IntExtension.accumulatedIn100.last;
    for (var i = 101; i <= this; i++) {
      value += i;
    }
    return value;
  }

  int get factorial {
    if (this < 0) throw ArgumentError(ErrorMessages.invalidInteger(this));
    if (this > 19) throw UnsupportedError(ErrorMessages.intFactorialOverflow);
    return IntExtension.factorialIn20[this - 1];
  }

  // Iterable<int> get factorized sync* {
  //   assert(this > 1, 'invalid factorized integer: $this');
  //   final primes = List.of(IntExtension.primesIn100);
  //   if (this < 100) {
  //
  //   }
  // }

  ///
  /// [leadingValue]
  ///
  int get leadingValue {
    num n = abs();
    for (; n >= 10; n /= 10, n++) {}
    return n.floor();
  }

  ///
  /// [paritySame], [parityOpposite]
  /// [isCoprime], [modInverseOrNull]
  /// see also [BigIntExtension.isCoprime], ...
  ///
  bool paritySame(int other) => isEven && other.isEven || isOdd && other.isOdd;

  bool parityOpposite(int other) =>
      isEven && other.isOdd || isOdd && other.isEven;

  bool isCoprime(int other) => gcd(other) == 1;

  int? modInverseOrNull(int other) =>
      isCoprime(other) ? modInverse(other) : null;

  ///
  /// [toIterable]
  ///
  Iterable<int> toIterable([int from = 0, int inset = 0]) {
    final max = this + 1 - inset;
    return [for (var i = 0; i < max; i++) i];
  }
}

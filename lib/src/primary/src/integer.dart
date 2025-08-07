part of '../primary.dart';

///
/// instance usages:
/// [isPrime], ...
///
/// constants:
/// [primesIn100]
/// [accumulatedIn100]
/// [factorialIn20]
/// [partitionsIn20]
///
/// static methods:
/// [maxExponentOf2In], ...
/// [reduce_plus], ...
/// [leading], ...
/// [factorial], ...
/// [isSameParity], ...
/// [accumulation], ...
/// [fibonacci], ...
/// [stoneTakingFinal]
/// [pascalTriangle], [combination]
/// [partition], ...
/// [combinationCount], ...
///
///
extension IntExtension on int {
  ///
  ///
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
    97,
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
  ///
  ///
  static bool predicate_0(int value) => value == 0;

  static bool predicate_negative(int value) => value.isNegative;

  static bool predicate_positive(int value) => !value.isNegative;

  ///
  ///
  ///
  static bool predicateReduce_larger(int a, int b) => a > b;

  static bool predicateReduce_less(int a, int b) => a < b;

  static bool predicateReduce_equal(int a, int b) => a == b;

  ///
  ///
  ///
  static Predicator<int> predicator_equalTo(int value) => (n) => n == value;

  ///
  ///
  ///
  static int maxExponentOf2In(num value) =>
      (math.log(value) / math.ln2).truncate();

  static int maxPow2In(num value) =>
      math.pow(2, (math.log(value) / math.ln2).truncate()).toInt();

  ///
  ///
  ///
  static int reduce_plus(int v1, int v2) => v1 + v2;

  static int reduce_minus(int v1, int v2) => v1 - v2;

  static int reduce_multiply(int v1, int v2) => v1 * v2;

  static int reduce_divided(int v1, int v2) => v1 ~/ v2;

  static int reduce_mod(int v1, int v2) => v1 % v2;

  // chained operation
  static int reduce_plusSquared(int v1, int v2) => v1 * v1 + v2 * v2;

  static int reduce_plusFactorial(int v1, int v2) =>
      IntExtension.factorial(v1) + IntExtension.factorial(v2);

  ///
  ///
  ///
  static int leading(int n) {
    num m = n.abs();
    for (; m >= 10; m /= 10, m++) {}
    return m.floor();
  }

  static int accumulate(int n) {
    if (n < 0) Erroring.invalidInt(n);
    if (n < 101) return IntExtension.accumulatedIn100[n - 1];
    var value = IntExtension.accumulatedIn100.last;
    for (var i = 101; i <= n; i++) {
      value += i;
    }
    return value;
  }

  ///
  ///
  ///
  static int factorial(int n) {
    if (n < 0) Erroring.invalidInt(n);
    if (n > 19) throw UnsupportedError('require BigInt');
    return IntExtension.factorialIn20[n - 1];
  }

  ///
  ///
  ///
  static bool isSameParity(int a, int b) =>
      a.isEven && b.isEven || a.isOdd && b.isOdd;

  static bool isOppositeParity(int a, int b) =>
      a.isEven && b.isOdd || a.isOdd && b.isEven;

  static bool isCoprime(int a, int b) => a.gcd(b) == 1;

  static int? modInverseOrNull(int n, int modulo) =>
      isCoprime(n, modulo) ? n.modInverse(modulo) : null;

  ///
  ///
  ///
  static Iterable<int> accumulation(int end, {int start = 0}) sync* {
    for (int i = start; i <= end; i++) {
      yield IntExtension.accumulate(i);
    }
  }

  static Iterable<int> factorized(int n) sync* {
    if (n < 2) Erroring.invalidInt(n);
    final primes = List.of(IntExtension.primesIn100);
    if (primes.any(IntExtension.predicator_equalTo(n))) {
      yield n;
      return;
    }
    if (n < 100) {}
    throw UnimplementedError();
  }

  ///
  /// [lucas] == false: [1, 1, 2, 3, 5, 8, 13, ...]
  /// [lucas] == true:  [1, 3, 4, 7, 11, 18, 29, ...]
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

  static Iterable<int> collatzConjecture(int n, [int scale = 3]) sync* {
    if (n == 0) Erroring.invalidInt(n);
    yield n;
    while (n != 1) {
      n = (n.isOdd ? n * scale + 1 : n / 2).toInt();
      yield n;
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
        'invalid stone taking final ('
        'n: $n, '
        'total: $total, '
        'limit lower: $limitLower, '
        'limit upper: $limitUpper)',
      );
    }

    final interval = limitLower + limitUpper * (n - 1);
    for (var step = interval; step <= total; step += interval) {
      yield step;
    }
  }

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
      throw ArgumentError('invalid pascal triangle argument($n, $k)');
    }

    final rowEnd = n + 1 - rowStart;
    final columnEndOf =
        isColumnEndAtK ? (i) => i + rowStart < k ? i + 1 : k : (i) => i + 1;

    final array = ListExtension.generate2D<int>(
      rowEnd,
      k,
      (i, j) =>
          j == 0 || j == i + rowStart
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
    if (n < 1) Erroring.invalidInt(n);
    if (k.isNegative) Erroring.invalidInt(k);
    if (k > n) throw ArgumentError('invalid binomial coefficient ($n, $k)');
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
    if (m.isNegative) Erroring.invalidInt(m);
    if (n != null) {
      if (n.isRangeClose(1, m)) {
        throw ArgumentError(Erroring.invalidPartition(m, n));
      }
      return _partitionSet(
        m,
      ).map(IterableExtension.lengthOf).iterator.toMapCounted[n]!;
    }
    var sum = 0;
    for (var i = 1; i <= m; i++) {
      sum +=
          _partitionSet(
            m,
          ).map(IterableExtension.lengthOf).iterator.toMapCounted[i]!;
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
    if (m.isNegative) Erroring.invalidInt(m);
    if (n != null) {
      if (n.isRangeClose(1, m)) {
        throw ArgumentError(Erroring.invalidPartition(m, n));
      }
      yield* _partitionSet(m).where((element) => element.length == n).flatted;
    }
    for (var i = 1; i <= m; i++) {
      yield* _partitionSet(
        m,
      ).where(IterableIterable.predicateChildrenLength(i)).flatted;
    }
  }

  ///
  /// [partitionPredicate] predicates if an [Iterable]<[int]> is a valid partition for [m] and [n].
  ///
  /// for example, when [m] = 4, [n] = 2,
  /// this functions returns true only if [integers] is one of [3, 1], [1, 3], [2, 2].
  ///
  static bool partitionPredicate(Iterable<int> integers, int m, int n) {
    if (m < 1) Erroring.invalidInt(m);
    if (n.isRangeClose(1, m)) {
      throw Erroring.invalidPartition(m, n);
    }
    return integers.length == n &&
        collection.IterableIntegerExtension(integers).sum == m;
  }

  //
  static Iterable<Iterable<int>> _partitionSet(int m) sync* {
    final list = List.filled(m, 0, growable: false);
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
  /// - example1,
  ///   [source] = {'hello', 'hi', 'apple', 'banana', 'cat'}
  ///   [chunks] = [1, 2, 2]
  ///   - [combinationCount] ([chunks]) = C5_1 * C4_2 * C2_2 / 2! = 5 * 6 * 1 / 2 = 15 #
  ///   - [permutationCountOf] ([chunks]) = 15 * 3! = 90 #
  ///
  /// - example2,
  ///   [source] = [1, 2, 3, 4, 5, 6]
  ///   [chunks] = [2, 2, 2]
  ///   - [combinationCount] ([chunks]) = C6_2 * C4_2 * C2_2 / 3! = 15 * 6 * 1 / 6 = 15 #
  ///   - [permutationCountOf] ([chunks]) = 15 * 3! = 90 #
  ///
  ///
  static int combinationCount<T>(Set<T> source, Iterable<int> chunks) {
    assert(
      chunks.reduce((a, b) => a + b) == source.length,
      'invalid chunks: $chunks not fit the ${source.length}-length-source',
    );
    int amount = 1;

    int base = source.length;
    for (var chunk in chunks) {
      final theOther = base - chunk;
      amount *=
          IntExtension.factorial(base) ~/
          (IntExtension.factorial(amount) *
              IntExtension.factorial((theOther == 0 ? 1 : theOther)));
      base -= chunk;
    }

    final set = chunks.toSet();
    return set.length == chunks.length
        ? amount
        : amount ~/
            set
                .map(
                  (e) => IntExtension.factorial(
                    chunks.fold(0, (value, c) => e == c ? value + 1 : value),
                  ),
                )
                .reduce((value, element) => value * element);
  }

  static int permutationCountOf<T>(Set<T> source, Iterable<int> chunks) {
    int combination = combinationCount(source, chunks);
    combination *= IntExtension.factorial(chunks.length);
    return combination;
  }

  static Map<int, List<T>> combinationSteps<T>(
    Set<T> source,
    Combiner<T> combiner,
  ) => source.fold(<int, List<T>>{}, (steps, data) {
    final index = combiner(data);
    if (index < 0 || index >= source.length) {
      throw Erroring.invalidIndex(index, source.length - 1);
    }
    return steps
      ..putIfAbsent(index, () => [])
      ..update(index, (step) => step..add(data));
  });

  //
  // Iterable<Map<int, Iterable<T>>> stepsOf(Iterable<int> chunks) {
  //   final result = <Map<int, Iterable<T>>>[];
  //   final stepsAmount = chunks.length;
  //
  //   final item = <int, Iterable<T>>{};
  //
  //   ///
  //   /// 1. find all combination by filter source until it's empty
  //   /// 2. find all permutation on each combination
  //   ///
  //
  //   final pAmount = permutationCountOf(chunks);
  //   final cAmount = pAmount ~/ chunks.length.factorial;
  //
  //   final source = this.source;
  //
  //   int skip = 0;
  //
  //   final combinations = <Iterable<T>>[];
  //
  //   ///
  //   ///
  //   /// [source] = [1, 2, 3, 4, 5, 6]
  //   /// [chunks] = [2, 2, 2]
  //   /// combinations1 = [1, 2], [3, 4], [5, 6]
  //   /// combinations2 = [1, 3], [2, 4], [5, 6]
  //   /// combinations3 = [1, 4], [2, 3], [5, 6]
  //   /// combinations4 = [1, 5], [2, 3], [5, 6]
  //   /// combinations5 = [1, 6], [2, 3], [4, 5]
  //   ///
  //   /// c1 = [1, 2], [3, 4], [5, 6]
  //   /// c1' = [1, 2], [3, 5], [4, 6]
  //   /// c1'' = [1, 2], [3, 6], [4, 5]
  //   ///
  //   /// 5 * 3 = 10
  //   ///
  //   findCombination:
  //   for (var chunk in chunks) {
  //     final combination = <T>[];
  //
  //     final sourceLength = source.length;
  //     for (var i = 1; i <= sourceLength; i++) {
  //       if (combination.length != chunk) {
  //         combination.add(source.elementAt(i - 1));
  //       } else {
  //         combinations.add(combination);
  //         source.removeAll(combination);
  //         skip += 1;
  //         continue findCombination;
  //       }
  //     }
  //   }
  //
  //   // item.putIfAbsent(c + 1, () => step);
  //   result.add(item);
  //
  //   assert(result.length == pAmount);
  //   return result;
  // }

  ///
  ///
  /// combination sample discussion for {r: rotate, t: translate}
  ///   1.
  ///     - rA-rB-tA-tB
  ///     - 1 #
  ///   2.
  ///     - rA-rB-tA, tB (2!)
  ///     - rA-rB, tA-tB (2!)
  ///     - (C4_3 + C4_2) * 2! = 10 * 2 = 20 #
  ///   3.
  ///     - rArB, tA, tB (3!)
  ///     - rAtA, rAtB, rBtA, rBtB, tAtB ...
  ///     - C4_2 * 3! = 6 * 6 = 36 #
  ///   4.
  ///     - 4! = 24 #
  ///
  ///
}

part of '../core.dart';

///
/// static methods:
/// [largestInt], ...
/// [predicateALess], ...
/// [reduceMax], ...
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
  /// [largestInt]
  ///
  /// can't be represent in javascript
  ///
  // static const int largestInt = 9223372036854775807; // math.pow(2, 63) - 1

  ///
  /// predicate
  /// [predicateALess], [predicateALarger]
  ///
  static bool predicateALess(int a, int b) => a < b;

  static bool predicateALarger(int a, int b) => a > b;

  ///
  /// reduce
  /// [reducePlus], [reduceMinus], [reduceMultiply], [reduceDivided], [reduceMod]
  /// [reducePlusSquared], [reducePlusFactorial]
  ///
  static int reduceMax(int v1, int v2) => math.max(v1, v2);

  static int reduceMin(int v1, int v2) => math.min(v1, v2);

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
        FErrorMessage.intStoneTakingFinal(n, total, limitLower, limitUpper),
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
      throw ArgumentError(FErrorMessage.intPascalTriangle(n, k));
    }

    final rowEnd = n + 1 - rowStart;
    final columnEndOf =
        isColumnEndAtK ? (i) => i + rowStart < k ? i + 1 : k : (i) => i + 1;

    final array = ListExtension.generate2D<int>(
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
    if (n.isNotPositive || k.isNegative || k > n) {
      throw ArgumentError(FErrorMessage.intBinomialCoefficient(n, k));
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
    if (m.isNegative) throw ArgumentError(FErrorMessage.intPartitionM(m));
    if (n != null) {
      if (n.isNotPositiveClose(m)) {
        throw ArgumentError(FErrorMessage.intPartitionN(m, n));
      }
      return _partitionSet(m)
          .map(IterableExtension.toLength)
          .iterator
          .toMapCounted[n]!;
    }
    var sum = 0;
    for (var i = 1; i <= m; i++) {
      sum += _partitionSet(m)
          .map(IterableExtension.toLength)
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
    if (m.isNegative) throw ArgumentError(FErrorMessage.intPartitionM(m));
    if (n != null) {
      if (n.isNotPositiveClose(m)) {
        throw ArgumentError(FErrorMessage.intPartitionN(m, n));
      }
      yield* _partitionSet(m).where((element) => element.length == n).flatted;
    }
    for (var i = 1; i <= m; i++) {
      yield* _partitionSet(m)
          .where(IterableIterable.predicateChildrenLength(i))
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
    if (m.isNotPositive) throw ArgumentError(FErrorMessage.intPartitionM(m));
    if (n.isNotPositiveClose(m)) {
      throw ArgumentError(FErrorMessage.intPartitionN(m, n));
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
    if (this < 0) throw ArgumentError(FErrorMessage.invalidInteger(this));
    if (this < 101) return KCore.accumulatedIn100[this - 1];
    var value = KCore.accumulatedIn100.last;
    for (var i = 101; i <= this; i++) {
      value += i;
    }
    return value;
  }

  int get factorial {
    if (this < 0) throw ArgumentError(FErrorMessage.invalidInteger(this));
    if (this > 19) throw UnsupportedError(FErrorMessage.intFactorialOverflow);
    return KCore.factorialIn20[this - 1];
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
  /// [toBigInt]
  /// [toIterable]
  ///
  BigInt get toBigInt => BigInt.from(this);

  Iterable<int> toIterable([int from = 0, int inset = 0]) {
    final max = this + 1 - inset;
    return [for (var i = 0; i < max; i++) i];
  }
}

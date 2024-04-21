part of damath_typed_data;

///
/// static methods:
/// [largestInt], ...
/// [predicateALess], ...
/// [reduceMax], ...
/// [accumulation]
/// [fibonacci]
/// [collatzConjecture]
/// [stoneTakingFinal]
/// [pascalTriangle], [combination], [binomialCoefficient]
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
  static const int largestInt = 9223372036854775807; // math.pow(2, 63) - 1

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
  /// [binomialCoefficient]
  ///
  static int combination(int m, int n) => binomialCoefficient(m, n + 1);

  static int binomialCoefficient(int n, int k) {
    if (n.isNotPositive || k.isNotPositive || k > n + 1) {
      throw ArgumentError(FErrorMessage.intBinomialCoefficient(n, k));
    }
    return k == 1 || k == n + 1
        ? 1
        : k == 2 || k == n
            ? n
            : _binomialCoefficient(n, k);
  }

  ///
  /// Let "row( [n] )" be list of binomial coefficient, for example:
  ///   row( 2 ) = [1, 2, 1]
  ///   row( 3 ) = [1, 3, 3, 1]
  ///
  /// Let "floor" represents all the essential values in a "row", for example, when ([n] = 10, [k] = 9),
  ///   row( 8 ) = [... 28,    8,    1]
  ///   row( 9 ) = [...  ?,   36,    9]
  ///   row( 10 ) = [...  ?,    ?,   45]
  /// Because '45' comes from '36+9', '36' comes from '18+8', '9' comes from '8+1',
  /// it's redundant to calculate '?', which are unnecessary values. solution for it required the values below:
  ///   floor( 2 ) = [1, 2, 1]
  ///   floor( 3 ) = [3, 3, 1]
  ///   floor( 4 ) = [6,  4,  1]
  ///   floor( 5 ) = [10,  5,  1]
  ///   floor( 6 ) = [15,  6,  1]
  ///   floor( 7 ) = [21,  7,  1]
  ///   floor( 8 ) = [28,  8,  1]
  ///   floor( 9 ) = [36,  9]
  ///   floor( 10 ) = [45]
  ///
  /// the description below shows what variables been used in this function,
  /// [fEnd] --- the last floor that corresponding row([fEnd])[k] is 1.
  ///   take the sample above ([n] == 10, [k] == 9) for example,
  ///     floor(10) = [45],
  ///     floor(9) = [36,  9],
  ///     floor(8) = [28,  8,  1]
  ///     floor(8) is the last floor that row(8)[9] == 1,
  ///     [fEnd] == 8 #.
  ///   if takes more example, it turns out that [fEnd] = k - 1 #
  ///
  /// [fBegin] --- the first floor that "floor.length" == floor([fEnd]).length,
  ///   take the sample above ([n] = 10, [k] = 9) for example,
  ///     floor([fEnd]) == floor(8)
  ///     3 == floor(8).length == floor(7).length == floor(6).length == ... == floor(2).length
  ///     floor(2) is the first floor that floor.length == floor(8).length
  ///     [fBegin] = 2 #
  ///   if takes more example, it will turn out that [fBegin] = n - [fEnd] #
  ///
  static int _binomialCoefficient(int n, int k) {
    assert(n > 2 && k > 0 && k <= n + 1);

    final fEnd = k - 1;
    final fBegin = n - fEnd;
    final floorCurrent = <int>[1, 2, 1];
    final floorNext = List.filled(fBegin + 1, -1, growable: false);
    void nextFloor(int f) {
      final length = floorCurrent.length;
      var k = 0;
      if (f <= fBegin) floorNext[k++] = 1;
      for (var j = 1; j < length; j++) {
        floorNext[k++] = floorCurrent[j - 1] + floorCurrent[j];
      }
      if (f <= fEnd) floorNext[k] = 1;
    }

    for (var f = 3; f < n; f++) {
      nextFloor(f);
      floorCurrent
        ..clear()
        ..addAll(floorNext);
    }
    nextFloor(n);
    return floorNext[0];
  }

  ///
  /// Generally, partition family is aim to solve the question:
  ///
  ///   if there are m equal elements, how many possibility to partition m into n groups?
  ///
  /// these methods return the possible partition of an integer [m],
  /// [partitionPredicate]
  /// [partition]
  /// [partitionSet]
  ///
  /// see also https://en.wikipedia.org/wiki/Partition_(number_theory) for academic definition
  /// check out the implementation for more detail,
  /// [_partition] implementation is based on the discussion above
  /// [_partitionSpace] for [space] helps to prevent invoking [elementOf] in [_partition] redundantly.
  /// [_partitionElementOf] is the generator to find row element in [_partition]
  /// [_partitionElementDeriving] is a way to find out where a row element comes from for [_partition]
  ///
  ///

  ///
  /// [partitionPredicate] predicates if an [Iterable]<[int]> is a valid partition.
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
      return _partition<int>(_partitionSpace<int>(m, n), m, n);
    }
    return _partitionSpace<int>(m).mapping((space) {
      var sum = 0;
      for (var i = 0; i < m;) {
        sum += _partition<int>(space, m, ++i);
      }
      return sum;
    });
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
  static List2D<int> partitionSet(int m, [int? n]) {
    if (m.isNegative) throw ArgumentError(FErrorMessage.intPartitionM(m));
    if (n != null) {
      if (n.isNotPositiveClose(m)) {
        throw ArgumentError(FErrorMessage.intPartitionN(m, n));
      }
      return _partitionSpace<List2D<int>>(m, n).mapping(
        (space) => _partition<List2D<int>>(space, m, n),
      );
    }
    return _partitionSpace<List2D<int>>(m).mapping((space) {
      var sum = <List<int>>[];
      for (var i = 0; i < m; i++) {
        sum += _partition<List2D<int>>(space, m, i + 1);
      }
      return sum;
    });
  }

  ///
  /// [_partition] currently supports for [partition] and [partitionSet].
  /// the comment above [_partitionByIterative] shows the logics behind algorithm, illustrating how it works.
  /// some conclusion can be checked at [KCore.partitionsIn20] or [KCore.partitionsSetIn8].
  ///
  /// the iterative version has better performance for big integer.
  ///
  static P _partition<P>(
    List2D<P> space,
    int m,
    int n, [
    bool iterative = false,
  ]) =>
      switch (space) {
        List2D<int>() => iterative
            ? _partitionByIterative(space as List2D<int>, m, n)
            : _partitionByRecursive(space as List2D<int>, m, n),
        List2D<List2D<int>>() => iterative
            ? (throw UnimplementedError())
            : _partitionSetByRecursive(space as List2D<List2D<int>>, m, n),
        _ => throw UnimplementedError(),
      } as P;

  ///
  /// [_partitionSpace] specify how much operatable a [_partition] needs.
  /// with predicator, it can prevent calculation for the same value in [_partitionElementDeriving].
  /// the values inside [List]<[List]<[P]>> will update during the loop if:
  ///   [P] == [int] && element is 1
  ///   [P] == [int] && element is empty
  ///
  /// the return operatable row must start from row(4) to row(i), correspond to list[0] to list[i-4]
  /// the return operatable column must start from row(i)(2) to row(i)(j), correspond to list[i][0] to list[i][j-2]
  ///
  static List<List<P>> _partitionSpace<P>(
    int m, [
    int? n,
    bool byIterative = false,
  ]) {
    if (byIterative) {
      final nRow = math.max(0, m - (n ?? 0) - 20);
      final nCol = n ?? m;
      if (P == int) {
        return <List<int>>[
          ...KCore.partitionsIn20,
          if (nRow > 0)
            ...ListExtension.generateFrom(
              nRow,
              (j) => List.generate(nCol, (_) => 1, growable: false),
              start: 21,
              growable: false,
            ),
        ] as List<List<P>>;
      }
      throw UnimplementedError();
    } else {
      final nRow = math.max(0, m - 3 - (n ?? 0));
      final nCol = n == null
          ? (int f) => math.min(f + 1, nRow - f)
          : (int f) => math.min(f + 1, n);
      if (P == int) {
        return List.generate(
          nRow,
          (f) => List.filled(nCol(f), 1),
        ) as List<List<P>>;
      }

      /// instead of [List.filled], using [List.generate] prevents shared instance for element list
      if (P == List2D<int>) {
        return List.generate(
          nRow,
          (f) => List.generate(nCol(f), (_) => <List<int>>[]),
        ) as List<List<P>>;
      }
      throw UnimplementedError();
    }
  }

  ///
  ///
  static Generator2D<T> _partitionElementOf<T>({
    required Generator2D<T> atFirst,
    required Generator2D<T> atLast,
    required Generator2D<T> atLastPrevious,
    required Generator2D<T> instancesOf,
  }) =>
      (i, j) {
        if (j == 1) return atFirst(i, j);
        if (j == i) return atLast(i, j);
        if (j == i - 1) return atLastPrevious(i, j);
        return instancesOf(i - j, j);
      };

  ///
  ///
  static void _partitionElementDeriving<P>(
    int i,
    int j, {
    required List<List<P>> space,
    required Generator2D<P> elementOf,
    required Predicator<P> predicate,
    required Consumer<P> consume,
    required Consumer<int> trailing,
  }) {
    final min = math.min(i, j);
    final bound = min == i
        ? math.max(1, min - 2)
        : min == i - 1
            ? min - 1
            : min;
    for (var k = 2; k <= bound; k++) {
      var p = space[i - 4][k - 2];
      if (predicate(p)) p = space[i - 4][k - 2] = elementOf(i, k);
      consume(p);
    }
    for (var current = bound + 1; current <= min; current++) {
      trailing(current);
    }
  }

  ///
  /// [_partitionByIterative]
  /// [_partitionByRecursive]
  /// [_partitionSetByRecursive]
  ///

  ///
  /// =========================================================================================================
  /// At first, there are some definitions required for the discussion below:
  ///
  /// s, m, n
  ///   | ∀ m ∈ ℤ
  ///   | ∀ n ∈ ℤ, ∀ n ≤ m
  ///   | s = [ x | ∀ x ∈ ℤ ]
  /// ƒ
  ///   | ƒ is assumed to be the correct function for finding partition, aka [partition],
  ///   | ƒ(m, n) is an integer representing the possible partitions in n groups for a positive integer m.
  ///   | ƒ(m, null) is an integer representing the summation of ƒ(m, k), 1 ≤ k ≤ m
  ///
  /// consider the functionality of ƒ, "partition in n groups for m equal elements",
  /// which indicates that we must distribute at least 1 element for each group; thus,
  /// after distribution, we remains m - n elements.
  /// by denoting m - n as r, we can find out the next statement, "partition in n groups for r equal elements".
  /// it's obvious that ƒ exist a recursive way to find out the possible partitions in n group for m.
  ///
  /// let r be the remain elements of m after first distribution.
  ///   ∵ ∀ n, 1 ≤ n ≤ m ∴ m - n = r ≥ 0
  ///   ∵ when r = 0, although ƒ(0, n) is not defined, it's obvious that ƒ(m, n) = 1
  ///     when r = 1, ƒ(1, n) = 1, which means ƒ(m, n) = 1, too.
  ///     when r = 2,
  ///       n = 1 -> ƒ(2, n) = 1
  ///       n ≥ 2 -> ƒ(2, n) = 2, ∵ ƒ(2, 1) + ƒ(2, 2) = 1 + 1 = 2
  ///     when r = 3,
  ///       n = 1 -> ƒ(3, n) = 1
  ///       n = 2 -> ƒ(3, n) = 2 ∵ ƒ(3, 1) + ƒ(3, 2) = 1 + 1 = 2
  ///       n ≥ 3 -> ƒ(3, n) = 3 ∵ ƒ(3, 1) + ƒ(3, 2) + ƒ(3, 3) = 1 + 1 + 1 = 3
  ///     ...
  ///   ∴ when r = 0, ƒ(m, n) = 1,
  ///     when r ≥ 1, ƒ(m, n) = ∑ ƒ(r, k)
  ///       n < r -> 1 ≤ k ≤ n
  ///       n ≥ r -> 1 ≤ k ≤ r
  ///   ∴ when m == n, ƒ(m, n) = 1, or f(m, n) = ∑ ƒ(m - n, min(n, m - n))
  ///
  /// =========================================================================================================
  /// At second, there are also some definitions required for the discussion below:
  ///
  /// p
  ///   | let p be the function that predicates if a multiset is a valid partition set, aka [partitionPredicate].
  ///   |   p(s, m, n) -> | s | = n && ∑ s = m
  /// P
  ///   | P is assumed to be the correct function for finding partition set, aka [partitionSet],
  ///   |   P(m, n) = { s | s ∈ P(m, n) <-> p(s, m, n) }
  ///   |   | P(m, n) | = ƒ(m, n)
  ///   | all the sets in P(m, n) are in decreasing order,
  ///   | which is compared by the set's first element if they're not equal, or by the second element, and so forth.
  ///
  /// let _ be a decorator that is appendable on a variable,
  ///   when appends on a set, it means that set has n elements.
  ///   when appends on a element in set, it means that it is at the position n in set.
  /// let + be a operator between two list, its logics is defined as below:
  ///   providing there is two list A_x and B_y:
  ///   if A + B = C, then C = [ c |
  ///     ∃ a_n && ∃ b_n -> c_n = a_n + b_n,
  ///     ∃ a_n && ¬∃ b_n -> c_n = a_n,
  ///     ∃ b_n && ¬∃ a_n -> c_n = b_n
  ///   ], which means | C | = max(x, y)
  /// let I = [ i | i = 1 ], ∀ P(k, k) -> I_k ∈ P(k, k)
  ///   ∵ when r = 0, P(m, n) has only a element I_m,
  ///     when r = 1, (¬∃ m ≤ 1 ∀ m - n = r = 1) -> ∀ m > 1,
  ///       P(r, 1) = [[ 1 ]]
  ///       P(m, n) = [I_n + [ 1 ]]
  ///     when r = 2, (¬∃ m ≤ 2 ∀ m - n = r = 2) -> ∀ m > 2,
  ///       P(r, 1) = [[ 2 ]]
  ///       P(r, 2) = [[ 1, 1 ]]
  ///       when n = 1, P(m, n) = [I_n + [ 2 ]]
  ///       when n ≥ 2, P(m, n) = [I_n + [ 2 ], I_n + [ 1, 1 ]]
  ///     when r = 4, (¬∃ m ≤ 4 ∀ m - n = r = 4) -> ∀ m > 4
  ///         P(r, 1) = [[ 4 ]]
  ///         P(r, 2) = [[ 3, 1 ]]
  ///         P(r, 2) = [[ 2, 2 ]]
  ///         P(r, 3) = [[ 2, 1, 1 ]]
  ///         P(r, 4) = [[ 1, 1, 1, 1]]
  ///       when n = 1, P(m, n) = [I_n + [ 4 ]]
  ///       when n = 2, P(m, n) = [I_n + [ 4 ], I_n + [ 3, 1 ], I_n + [ 2, 2 ]]
  ///       when n = 3, P(m, n) = [I_n + [ 4 ], I_n + [ 3, 1 ], I_n + [ 2, 2 ], I_n + [ 2, 1, 1 ]]
  ///       when n ≥ 4, P(m, n) = [
  ///           I_n + [ 4 ],
  ///           I_n + [ 3, 1 ],
  ///           I_n + [ 2, 2 ],
  ///           I_n + [ 2, 1, 1 ],
  ///           I_n + [ 1, 1, 1, 1 ],
  ///         ]
  ///     ...
  ///   ∴ when r = 0, P(m, n) has only a element I_m,
  ///     when r ≥ 1, P(m, n) = ∑ I_n + P(r, k)
  ///         n < r -> 1 ≤ k ≤ n
  ///         n ≥ r -> 1 ≤ k ≤ r
  ///   ∴ when m == n, P(m, n) has only a element I_m, or P(m, n) = ∑ I_n + P(m - n, min(n, m - n))
  ///
  /// =========================================================================================================
  /// At final step, we design a way by using dynamic list to complete the question...
  /// is it possible to use less space to complete the partition like [_binomialCoefficient] does ?
  ///   1. to the last floor that ƒ(m, n) = 1 ?
  ///   2. to the final floor required summation. ?
  ///
  ///

  //
  static int _partitionByIterative(List2D<int> space, int m, int n) {
    if (n == 1) return 1;
    final fEnd = m - n;
    if (fEnd == 0 || fEnd == 1) return 1;
    if (m < 21) return KCore.partitionsIn20[m - 1][n - 1];
    if (fEnd < 21) {
      return KCore.partitionsIn20[fEnd - 1].take(n).sum;
    }

    var f = 20;
    // to the last floor that ƒ(f, n) = 1, ƒ(f, n - 1) = 1
    for (; f < n; f++) {
      for (var k = 1; k < f - 2; k++) {
        space[f][k] = space[f - k].take(k + 1).sum;
      }
    }
    // to the last floor required summation
    for (; f < fEnd; f++) {
      for (var k = 1; k < n; k++) {
        space[f][k] = space[f - k].take(k + 1).sum;
      }
    }
    return space[f].sum;
  }

  static int _partitionByRecursive(List2D<int> space, int m, int n) {
    late final Reducer<int> elementOf;

    elementOf = _partitionElementOf(
      atFirst: FGenerator.filled2D(1),
      atLast: FGenerator.filled2D(1),
      atLastPrevious: FGenerator.filled2D(1),
      instancesOf: (i, j) {
        var sum = 1;
        _partitionElementDeriving<int>(
          i,
          j,
          space: space,
          elementOf: elementOf,
          predicate: (p) => p == 1,
          consume: (p) => sum += p,
          trailing: (_) => sum++,
        );
        return sum;
      },
    );

    return elementOf(m, n);
  }

  static Iterable<List<int>> _partitionSetByRecursive(
    List2D<List2D<int>> space,
    int m,
    int n,
  ) {
    late final Generator2D<Iterable<List<int>>> elementOf;

    List<int> firstOf(int n) => [n];
    List<int> lastOf(int n) => List.filled(n, 1, growable: true);
    List<int> lastPreviousOf(int n) => [2, ...List.filled(n - 2, 1)];

    List2D<int> instancesOf(int i, int j) {
      final instances = [firstOf(i)];
      _partitionElementDeriving<Iterable<List<int>>>(
        i,
        j,
        space: space,
        elementOf: elementOf,
        predicate: (p) => p.isEmpty,
        consume: (p) => instances.addAll(p),
        trailing: (current) => instances.add(
          (current == i ? lastOf(i) : lastPreviousOf(i)),
        ),
      );
      return instances;
    }

    elementOf = _partitionElementOf(
      atFirst: (i, j) => [firstOf(i)],
      atLast: (i, j) => [lastOf(j)],
      atLastPrevious: (i, j) => [lastPreviousOf(j)],
      instancesOf: (i, j) {
        final instances = instancesOf(i, j);
        final result = <List<int>>[];
        for (var instance in instances) {
          result.add([
            ...instance.map((element) => element + 1),
            ...Iterable.generate(j - instance.length, (_) => 1),
          ]);
        }
        return result;
      },
    );

    return elementOf(m, n);
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

  ///
  /// [switchNatural]
  ///
  S switchNatural<S>(
    Supplier<S> onZero,
    Supplier<S>? onNegative,
    Supplier<S>? onPositive, [
    Error? notProvidedError,
  ]) =>
      switch (this) {
        0 => onZero(),
        < 0 => onNegative?.call(),
        > 0 => onPositive?.call(),
        _ => throw UnsupportedError(FErrorMessage.numberNatural),
      } ??
      (throw notProvidedError ?? UnimplementedError());
}

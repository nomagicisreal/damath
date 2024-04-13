part of damath_typed_data;

///
/// static methods:
/// [accumulation]
/// [fibonacci]
/// [collatzConjecture]
/// [stoneTakingFinal]
/// [pascalTriangle], [combination], [binomialCoefficient]
/// [partition], [partitionGroups]
///
/// instance getters, methods:
/// [accumulated], ...
/// [factorized], ...
/// [leadingValue], ...
/// [paritySame], ...
///
///
extension IntExtension on int {
  ///
  /// [largestInt]
  /// [primesIn100]
  ///
  static const int largestInt = 9223372036854775807; // math.pow(2, 63) - 1

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
  /// [predicateALess], [predicateALarger]
  ///
  static bool predicateALess(int a, int b) => a < b;

  static bool predicateALarger(int a, int b) => a > b;

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
        limitLower.outsideClose(0, limitUpper) ||
        limitUpper.outsideClose(limitLower, total)) {
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
  static List<List<int>> pascalTriangle(
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
    if (n > 0 && k > 0 && k <= n + 1) {
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
  /// the description below are variables used in this function, describes how it works
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

    final currentFloor = <int>[1, 2, 1];
    final fEnd = k - 1;
    final fBegin = n - fEnd;
    List<int> floorOf(int f) {
      final length = currentFloor.length;
      return <int>[
        if (f <= fBegin) 1,
        for (var j = 1; j < length; j++) currentFloor[j - 1] + currentFloor[j],
        if (f <= fEnd) 1,
      ];
    }

    for (var f = 3; f < n; f++) {
      final floor = floorOf(f);
      currentFloor
        ..clear()
        ..addAll(floor);
    }
    return floorOf(n).first;
  }

  ///
  /// Generally, these methods return the possible partition of an integer [m],
  /// [partition]
  /// [partitionGroups]
  ///
  /// and these private methods are the implementation of those methods
  /// [_partition]
  /// [_partitionContainer]
  /// [_partitionElementGenerator]
  /// [_partitionSearchOnFloor]
  ///
  /// see the comment under [partitionGroups], above [_partition] to understand the implement logic
  /// see also https://en.wikipedia.org/wiki/Partition_(number_theory) for academic definition
  ///

  ///
  /// [partition] return the possible partition in [n] group for an integer [m],
  /// for example, when [m] = 7, [n] = 4, this function returns 3 because there are 3 possible partition:
  /// [4, 1, 1, 1]
  /// [3, 2, 1, 1]
  /// [2, 2, 2, 1]
  ///
  /// if [n] is not provided, it returns all the possible partitions for an integer [m],
  /// for example, when [m] = 5, this function return 7 because there are 7 possible partition for 5:
  /// (5)
  /// (4, 1)
  /// (3, 2)
  /// (3, 1, 1)
  /// (2, 2, 1)
  /// (2, 1, 1, 1)
  /// (1, 1, 1, 1, 1)
  ///
  static int partition(int m, [int? n]) {
    if (m.isNegative) throw ArgumentError(FErrorMessage.intPartition(m));
    if (n != null) {
      if (n > m) throw ArgumentError(FErrorMessage.intPartitionGroup(m, n));
      return _partition<int>(m, n, container: _partitionContainer<int>(m, n: n));
    }

    final pSpace = _partitionContainer<int>(m);
    var sum = 0;
    for (var i = 0; i < m; i++) {
      sum += _partition<int>(m, i + 1, container: pSpace);
    }
    return sum;
  }

  ///
  /// [partitionGroups] return entire groups of possible partition in [n] for m,
  /// for example, when [m] = 8, [n] = 4, this function returns [
  ///   [5, 1, 1, 1],
  ///   [4, 2, 1, 1],
  ///   [3, 3, 1, 1],
  ///   [3, 2, 2, 1],
  ///   [2, 2, 2, 2],
  /// ]
  ///
  static List<List<int>> partitionGroups(int m, int n) {
    if (m.isNegative || n > m) {
      throw ArgumentError(FErrorMessage.intPartitionGroup(m, n));
    }
    return _partition<List<List<int>>>(
      m,
      n,
      container: _partitionContainer<List<List<int>>>(m, n: n),
    )..sortAccordingly();
  }

  ///
  /// The "row" concept in here helps to calculate values in more efficient way. definition:
  ///   row( 2 ) = [1, 1, 1]
  ///   row( 3 ) = [1, 1, 1, 1]
  /// because there is only 1 way to partition integer 2 into 0 group, 1 group or 2 group,
  /// and there is also only 1 way to partition integer 3 into 0 group, 1 group, 2 group, 3 group.
  /// based on "row" concept, the return value or the answer is equivalent to row([m])([n]).
  ///
  /// To find out the answer, we have to repeat a step:
  /// calculating row( i )( j ) by summarizing row( i-j )( 1 ) to row( i-j )( min(i-j, j) ),
  /// and in the first step, i = [m], j = [n].
  ///   - Take i = 10, j = 7 for example,
  ///     it means that there are 10 same elements have to be partitioned into 7 group.
  ///     Because each group must have 1 element at least,
  ///     we have to consider how many possible partition in 7 group actually for 3 (i-j) element.
  ///     That is, it's possible that 3 elements partitioned into 1 group, 2 group, 3 group. (1 to i-j),
  ///     so the summarize of row(3)(1) to row(3)(3) is the answer.
  ///
  ///   - Take i = 20, j = 7 for example,
  ///     it means that there are 20 same elements have to be partitioned into 7 group.
  ///     Because we have to consider how many possible partition in 7 group actually for 13 (i-j) element.
  ///     it's possible that 13 elements partitioned into 1 group, 2 group, ... 7 group. (1 to j)
  ///
  /// Let "floor" correspond to "row" and contains all the essential values of corresponding row.
  /// Let "target floor" represents "floor( [m]-[n] )". In convenient of discussion,
  /// all the index blow starts by 1, because [n] = 0 not in the consideration of this function.
  ///
  /// Take ([m] = 10, [n] = 4) for example, the description below shows how to use the "floors",
  ///   row(10)(4) = floor(6)(1) + ... + floor(6)(4)
  ///     floor(6)(1) = 1
  ///     floor(6)(2) = floor(4)(1) + ... + floor(4)(2)
  ///     floor(6)(3) = floor(3)(1) + ... + floor(3)(3)
  ///     floor(6)(4) = floor(2)(1) + ... + floor(2)(2)
  ///       floor(4)(1) + floor(4)(2) = floor(4)(1) + floor(2)(1) + floor(2)(2) = 1 + 1 + 1 = 3
  ///       floor(3)(1) + floor(3)(2) + floor(3)(3) = 1 + 1 + 1 = 3
  ///       floor(2)(1) + floor(2)(2) = 1 + 1 = 2
  ///   row(10)(4) = floor(6)(1) + ... + floor(6)(5) = 1 + 3 + 3 + 2 = 9 #
  /// during the calculation, the required floors are:
  ///   floor( 2 ) = [1, 1]
  ///   floor( 3 ) = [1, 1, 1]
  ///   floor( 4 ) = [1, 2]
  ///   floor( 6 ) = [1, 3, 3, 2] (this floor is target floor)
  /// with those "floor", we can get the answer of ([m] = 10, [n] = 4).
  ///
  /// [_partition] implementation is based on the discussion above
  /// [_partitionContainer] for [container] helps to prevent invoking [elementOf] in [_partition] redundantly.
  /// [_partitionElementGenerator] is the generator to find row element
  /// [_partitionSearchOnFloor] is a way to find out where a row element comes from
  ///
  static P _partition<P>(
    int m,
    int n, {
    required List<List<P>> container,
  }) =>
      switch (container) {
        List<List<int>>() => () {
            final pContainer = container as List<List<int>>;
            late final Reducer<int> elementOf;

            int instancesOf(int i, int j) {
              int sum = 1;
              _partitionSearchOnFloor<int>(
                i,
                j,
                container: pContainer,
                elementOf: elementOf,
                predicate: (p) => p == 1,
                consume: (p) => sum += p,
                trailing: (_) => sum++,
              );
              return sum;
            }

            elementOf = _partitionElementGenerator(
              atFirst: FGenerator.filled2D(1),
              atLast: FGenerator.filled2D(1),
              atLastPrevious: FGenerator.filled2D(1),
              instancesOf: instancesOf,
            );

            return elementOf(m, n);
          }(),
        List<List<Iterable<List<int>>>>() => () {
            final partitionSpace = container as List<List<Iterable<List<int>>>>;
            late final Generator2D<Iterable<List<int>>> elementOf;

            List<int> firstOf(int n) => [n];
            List<int> lastOf(int n) => List.filled(n, 1, growable: true);
            List<int> lastPreviousOf(int n) => [2, ...List.filled(n - 2, 1)];

            Iterable<List<int>> instancesOf(int i, int j) {
              final instances = [firstOf(i)];
              _partitionSearchOnFloor<Iterable<List<int>>>(
                i,
                j,
                container: partitionSpace,
                elementOf: elementOf,
                predicate: (p) => p.isEmpty,
                consume: (p) => instances.addAll(p),
                trailing: (current) => instances.add(
                  (current == i ? lastOf(i) : lastPreviousOf(i)),
                ),
              );
              return instances;
            }

            elementOf = _partitionElementGenerator(
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
          }(),
        _ => throw UnimplementedError(),
      } as P;

  ///
  /// [_partitionContainer] specify how much operatable a [_partition] needs.
  /// with predicator, it can prevent calculation for the same value in [_partitionSearchOnFloor].
  /// the values inside [List]<[List]<[P]>> will update during the loop if:
  ///   [P] == [int] && element is 1
  ///   [P] == [int] && element is empty
  ///
  /// the return operatable row must start from row(4) to row(i), correspond to list[0] to list[i-4]
  /// the return operatable column must start from row(i)(2) to row(i)(j), correspond to list[i][0] to list[i][j-2]
  ///
  /// instead of [List.filled], using [List.generate] prevents shared instance for list
  ///
  static List<List<P>> _partitionContainer<P>(int m, {int? n}) {
    final spaceRow = math.max(0, m - 3 - (n ?? 0));
    final Generator<P> generator = P == int
        ? (_) => 1 as P
        : (P == List<List<int>>)
            ? (_) => <List<int>>[] as P
            : throw UnimplementedError(
                'generic type must be int or Iterable<List<int>>, current: $P',
              );
    return List.generate(
      spaceRow,
      n == null
          ? (f) => List.generate(math.min(f + 1, spaceRow - f), generator)
          : (f) => List.generate(math.min(f + 1, n), generator),
    );
  }

  ///
  ///
  static Generator2D<T> _partitionElementGenerator<T>({
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
  static void _partitionSearchOnFloor<P>(
    int i,
    int j, {
    required List<List<P>> container,
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
      var p = container[i - 4][k - 2];
      if (predicate(p)) p = container[i - 4][k - 2] = elementOf(i, k);
      consume(p);
    }
    for (var current = bound + 1; current <= min; current++) {
      trailing(current);
    }
  }

  ///
  /// [accumulated], [factorial]
  ///
  int get accumulated {
    if (this < 0) throw ArgumentError(FErrorMessage.invalidInteger(this));
    var value = 0;
    for (var i = 1; i <= this; i++) {
      value += i;
    }
    return value;
  }

  int get factorial {
    if (this < 0) throw ArgumentError(FErrorMessage.invalidInteger(this));
    var value = 1;
    for (var i = 1; i <= this; i++) {
      value *= i;
    }
    return value;
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
  ///
  bool paritySame(int other) => isEven && other.isEven || isOdd && other.isOdd;

  bool parityOpposite(int other) =>
      isEven && other.isOdd || isOdd && other.isEven;
}

part of damath_typed_data;

///
/// static methods:
/// [partition], ...
///
/// instance getters, methods:
/// ...
///
extension CountingExtension on int {
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
  /// [partitionSpace] for [space] helps to prevent invoking [elementOf] in [_partition] redundantly.
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
      return _partition<int>(partitionSpace<int>(m, n), m, n);
    }
    return partitionSpace<int>(m).mapping((space) {
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
      return partitionSpace<List2D<int>>(m, n).mapping(
        (space) => _partition<List2D<int>>(space, m, n),
      );
    }
    return partitionSpace<List2D<int>>(m).mapping((space) {
      var sum = <List<int>>[];
      for (var i = 0; i < m; i++) {
        sum += _partition<List2D<int>>(space, m, i + 1);
      }
      return sum;
    });
  }

  ///
  /// [_partition] currently supports for [partition] and [partitionSet].
  /// the comment above [partitionByIterative] shows the logics behind algorithm, illustrating how it works.
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
            ? partitionByIterative(space as List2D<int>, m, n)
            : partitionByRecursive(space as List2D<int>, m, n),
        List2D<List2D<int>>() => iterative
            ? (throw UnimplementedError())
            : _partitionSetByRecursive(space as List2D<List2D<int>>, m, n),
        _ => throw UnimplementedError(),
      } as P;

  ///
  /// [partitionSpace] specify how much operatable a [_partition] needs.
  /// with predicator, it can prevent calculation for the same value in [_partitionElementDeriving].
  /// the values inside [List]<[List]<[P]>> will update during the loop if:
  ///   [P] == [int] && element is 1
  ///   [P] == [int] && element is empty
  ///
  /// the return operatable row must start from row(4) to row(i), correspond to list[0] to list[i-4]
  /// the return operatable column must start from row(i)(2) to row(i)(j), correspond to list[i][0] to list[i][j-2]
  ///
  static List<List<P>> partitionSpace<P>(
    int m, [
    int? n,
    bool byIterative = false,
  ]) {
    if (byIterative) {
      final nRow = m - (n ?? 0) - 20;
      final nCol = n == null ? m : math.min(m - n, n);
      if (P == int) {
        return List.of(
          <List<int>>[
            ...KCore.partitionsIn20,
            if (nRow > 0)
              ...ListExtension.generateFrom(
                nRow,
                (k) => List.generate(
                  math.min(nCol, k),
                  (_) => 1,
                  growable: false,
                ),
                start: 21,
                growable: false,
              ),
          ],
          growable: false,
        ) as List<List<P>>;
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
          (f) => List.filled(nCol(f), 1, growable: true),
          growable: false,
        ) as List<List<P>>;
      }

      /// instead of [List.filled], using [List.generate] prevents shared instance for element list
      if (P == List2D<int>) {
        return List.generate(
          nRow,
          (f) => List.generate(nCol(f), (_) => <List<int>>[], growable: false),
          growable: false,
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
  /// [partitionByIterative]
  /// [partitionByRecursive]
  /// [_partitionSetByRecursive]
  ///

  ///
  /// =========================================================================================================
  /// At first, [partition] algorithm is demonstrated as below, which is a recursive way.
  ///
  /// Consider the functionality of partition, "partition for m equal elements in n groups".
  /// Or physically, providing that there are 10 equal stones on a bench,
  /// and there is a man attempt to separate all the stones into 4 groups.
  /// At first, he trying to distribute 4 stone into 4 groups and each group contains at least 1 stone.
  /// after the distribution, the bench remains 10 - 4 stones; thus,
  /// it seems that the puzzle become easier, "how to partition 6 equal element into 4 exist group ?".
  ///
  /// Based on the context above, it's obvious that partition function can be solved in a recursive way.
  /// there are some definitions for the following discussion:
  ///   s, m, n
  ///     | ∀ m ∈ ℤ
  ///     | ∀ n ∈ ℤ, ∀ n ≤ m
  ///     | s = [ x | ∀ x ∈ ℤ ]
  ///   ƒ
  ///     | ƒ is assumed to be the correct function for finding partition, aka partition,
  ///     | ƒ(m, n) is an integer representing the possible partitions in n groups for a positive integer m.
  ///     | ƒ(m, null) is an integer representing the summation of ƒ(m, k), 1 ≤ k ≤ m
  ///
  /// let r be the remain elements of m after distribution.
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
  ///   ∴ when m == n, ƒ(m, n) = 1, or f(m, n) = ∑ ƒ(m - n, k), 1 ≤ k ≤ min(n, m - n)
  ///
  /// =========================================================================================================
  /// At second, [partitionSet] algorithm is demonstrated as below, which is similar to the previous discussion.
  ///
  /// there are some definitions for the following discussion:
  ///   p
  ///     | let p be the function that predicates if a multiset is a valid partition set, aka [partitionPredicate].
  ///     |   p(s, m, n) -> | s | = n && ∑ s = m
  ///   P
  ///     | P is assumed to be the correct function for finding partition set, aka [partitionSet],
  ///     |   P(m, n) = { s | s ∈ P(m, n) <-> p(s, m, n) }
  ///     |   | P(m, n) | = ƒ(m, n)
  ///     | all the sets in P(m, n) are in decreasing order,
  ///     | which is compared by the set's first element if they're not equal, or by the second element, and so forth.
  ///   _
  ///     | _ is a decorator that is appendable on a variable.
  ///     | when appends on a set, it means that set has n elements.
  ///     | when appends on a element in set, it means that it is at the position n in set.
  ///   +
  ///     | + is a operator between two list. providing there is two list A_x and B_y:
  ///     | if A + B = C, then C = [ c |
  ///     |   ∃ a_n && ∃ b_n -> c_n = a_n + b_n,
  ///     |   ∃ a_n && ¬∃ b_n -> c_n = a_n,
  ///     |   ∃ b_n && ¬∃ a_n -> c_n = b_n
  ///     | ], which means | C | = max(x, y)
  ///
  /// let I = [ i | i = 1 ], ∀ I_k ∈ P(k, k)
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
  /// At third, we shows that ƒ can be done by iterative way,
  ///
  /// there are some definitions for the following discussion:
  ///   "remain"
  ///        | the word "remain" here is a equivalent to m - n
  ///   "floor"
  ///        | the word "floor" here denote for "ƒ(m, null), 1 ≤ m ≤ ∞".
  ///        | "kth floor" denote for the instance of "ƒ(k, null)".
  ///        | "target floor" denote for the floor that pending to be summarized,
  ///        |   - summation of target floor = ∑ ƒ(m, k), 1 ≤ k ≤ remain
  ///        |   - notice that summation of target floor is not equivalent to the result.
  ///        |   - because when n < remain, the result is ∑ ƒ(m, n) or P(m, n), while 1 ≤ k ≤ n
  ///        | there are 4 types of lines that denote the concept relating to target floor in diagram:
  ///        |    1. target floor: -------
  ///        |    2. decreasing floors: \
  ///        |    3. convergent floors: /
  ///        |    4. horizontal floors: |
  ///
  /// Note that target floor = ∑ ƒ(m, k), and there are two case for k's range.
  ///   1. 1 ≤ k ≤ remain
  ///     ∀ n > remain -> 1 ≤ k ≤ remain
  ///       for example: m = 50, n = 28, remain = 22           \
  ///         - ∃ decreasing floors (1st ~ 22th)                \
  ///         - ∄ convergent floors, horizontal floors       -----
  ///     ∀ n = remain -> 1 ≤ k ≤ remain = n
  ///       for example: m = 50, n = 25, remain = 25           \
  ///         - ∃ decreasing floors (1st ~ 25th)                \
  ///         - ∄ convergent floors, horizontal floors       -----
  ///         - it's not efficient but convenient to compute all the decreasing floors.
  ///   2. 1 ≤ k ≤ n
  ///     ∀ remain/2 < n < remain -> 1 ≤ k ≤ n,
  ///       for example: m = 50, n = 18, remain = 32                                    \\
  ///         - ∃ decreasing floors (1th ~ 18th, complex between 14th ~ 18th)           //
  ///         - ∃ convergent floors (18th ~ 31th)                                      ----
  ///         - ∄ horizontal floors (converge start before n, 14 < 18)
  ///         - it's not efficient but convenient to extend decreasing floors to n, start convergent floors from n.
  ///     ∀ n = remain/2 -> 1 ≤ k ≤ n,
  ///       for example: m = 60, n = 20, remain = 40
  ///         - ∃ decreasing floors (1th ~ 20th)                                       \
  ///         - ∃ convergent floors (20th ~ 39th)                                      /
  ///         - ∄ horizontal floors (convergent start at n, 20 == 20)                 ---
  ///     ∀ 2n < remain -> 1 ≤ k ≤ n,
  ///       for example: m = 50, n = 10, remain = 40                                     \
  ///         - ∃ decreasing floors (1th ~ 10th)                                          |
  ///         - ∃ convergent floors (30th ~ 39th)                                       /
  ///         - ∃ horizontal floors (10th ~ 30th) (convergent start after n, 29 > 10)   ---
  ///         - it's not efficient but convenient to calculate all the values in horizontal floors.
  ///
  /// conclusion:
  ///   - when n ≥ remain, it's possible to construct target floor by a single loop.
  ///   - when n < remain, it's a challenge coming up with an optimal iterative way.
  ///
  /// note that decreasing floors is optional when m is relatively small.
  /// whether decreasing floors is optional is according to [KCore.partitionsIn20] and [KCore.partitionsSetIn8].
  ///
  ///
  ///
  ///

  ///
  /// note that [partitionByIterative] is faster than [partitionByRecursive] when m > about 1e5 for now.
  ///
  static int partitionByIterative(List2D<int> space, int m, int n) {
    if (n == 1) return 1;
    final remain = m - n;
    if (remain == 0 || remain == 1) return 1;
    if (m < 21) return space[m - 1][n - 1];
    if (remain < 21) return space[remain - 1].take(n).sum;

    var f = 21;

    // it's not verified for n < remain
    if (n < remain) {
      void valueFloorTo(int kBound) {
        final current = space[f - 1];
        for (var k = 2; k <= kBound; k++) {
          current[k - 1] = space[f - k - 1].take(k).sum;
        }
      }

      // decreasing floor
      final kTarget = math.min(n, remain);
      for (; f <= kTarget; f++) {
        valueFloorTo(f - 1);
      }

      // horizontal floor
      for (; f < kTarget - n; f++) {
        valueFloorTo(n);
      }

      // convergent floors
      // for (var kNecessary = n; kNecessary > 1; f++, kNecessary--) {
      //   valueFloorTo(kNecessary);
      // }

      f = remain;
      valueFloorTo(n);

      print('iterative final($remain): ${space[remain - 1]}');


    } else {
      for (; f <= remain; f++) {
        final current = space[f - 1];
        final notCopyable = f ~/ 2 + 1;
        var k = 2;
        for (; k < notCopyable; k++) {
          current[k - 1] = space[f - k - 1].take(k).sum;
        }
        final previous = space[f - 2];
        for (; k < f - 1; k++) {
          current[k - 1] = previous[k - 2];
        }
      }
    }

    return space[remain - 1].sum;
  }

  //
  static int partitionByRecursive(List2D<int> space, int m, int n) {
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

    // final result = elementOf(m, n);
    // print('recursive final(${m - n}): ${space[m - n - 4]}');
    // return result;
  }

  //
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
}

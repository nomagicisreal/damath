part of damath_assumption;
// ignore_for_file: unused_local_variable

///
///
/// partition
/// =========================================================================================================
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
/// let r be the remain elements of m after distribution (r = m - n).
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
///     in other words, f(m, n) = ∑ ƒ(r, k), 1 ≤ k ≤ min(r, n)
///
/// =========================================================================================================
/// At second, we shows that ƒ can be done by iterative way,
///
/// there are some definitions for the following discussion:
///   "floor"
///        | the word "floor" here denote for "ƒ(m, null), 1 ≤ m ≤ ∞".
///        | "kth floor" denote for the instance of "ƒ(k, null)".
///        | "target floor" denote for the floor that pending to be summarized,
///        |   - summation of target floor = ∑ ƒ(r, k), 1 ≤ k ≤ r
///        |   - notice that summation of target floor is not always equivalent to the result.
///        | there are 4 types of lines that denote the concept relating to target floor in diagram:
///        |    1. target floor: -------
///        |    2. decreasing floors: \
///        |    3. convergent floors: /
///        |    4. horizontal floors: |
///
/// When m != n, target floor = ∑ ƒ(r, k), and there are two case for k's range.
///   1. 1 ≤ k ≤ r
///     ∀ n > r -> 1 ≤ k ≤ r
///       for example: m = 50, n = 28, r = 22                \
///         - ∃ decreasing floors (1st ~ 22th)                \
///         - ∄ convergent floors, horizontal floors       -----
///     ∀ n = r -> 1 ≤ k ≤ r = n
///       for example: m = 50, n = 25, r = 25                \
///         - ∃ decreasing floors (1st ~ 25th)                \
///         - ∄ convergent floors, horizontal floors       -----
///         - it's not efficient but convenient to compute all the decreasing floors.
///   2. 1 ≤ k ≤ n
///     ∀ r/2 < n < r -> 1 ≤ k ≤ n,
///       for example: m = 50, n = 18, r = 32                                         \\
///         - ∃ decreasing floors (1th ~ 18th, complex between 14th ~ 18th)           //
///         - ∃ convergent floors (18th ~ 31th)                                      ----
///         - ∄ horizontal floors (converge start before n, 14 < 18)
///         - it's not efficient but convenient to extend decreasing floors to n, start convergent floors from n.
///     ∀ n = r/2 -> 1 ≤ k ≤ n,
///       for example: m = 60, n = 20, r = 40
///         - ∃ decreasing floors (1th ~ 20th)                                       \
///         - ∃ convergent floors (20th ~ 39th)                                      /
///         - ∄ horizontal floors (convergent start at n, 20 == 20)                 ---
///     ∀ 2n < r -> 1 ≤ k ≤ n,
///       for example: m = 50, n = 10, r = 40                                          \
///         - ∃ decreasing floors (1th ~ 10th)                                          |
///         - ∃ convergent floors (30th ~ 39th)                                       /
///         - ∃ horizontal floors (10th ~ 29th) (convergent start after n, 29 > 10)   ---
///         - it's not efficient but convenient to calculate all the values in horizontal floors.
///
/// conclusion:
///   - when n ≥ r, it's possible to construct target floor by a single loop.
///   - when n < r, it's a challenge coming up with an optimal iterative way.
///
///
/// =========================================================================================================
/// At first, [partitionSet] algorithm is demonstrated as below, which is similar to the previous discussion.
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
///     when r = 1,
///       P(r, 1) = [[ 1 ]]
///       P(m, n) = [I_r + [ 1 ]]
///     when r = 2,
///       P(r, 1) = [[ 2 ]]
///       P(r, 2) = [[ 1, 1 ]]
///       when n = 1, P(m, n) = [I_r + [ 2 ]]
///       when n ≥ 2, P(m, n) = [I_r + [ 2 ], I_r + [ 1, 1 ]]
///     when r = 4,
///         P(r, 1) = [[ 4 ]]
///         P(r, 2) = [[ 3, 1 ]]
///         P(r, 2) = [[ 2, 2 ]]
///         P(r, 3) = [[ 2, 1, 1 ]]
///         P(r, 4) = [[ 1, 1, 1, 1]]
///       when n = 1, P(m, n) = [I_r + [ 4 ]]
///       when n = 2, P(m, n) = [I_r + [ 4 ], I_r + [ 3, 1 ], I_r + [ 2, 2 ]]
///       when n = 3, P(m, n) = [I_r + [ 4 ], I_r + [ 3, 1 ], I_r + [ 2, 2 ], I_r + [ 2, 1, 1 ]]
///       when n ≥ 4, P(m, n) = [
///           I_r + [ 4 ],
///           I_r + [ 3, 1 ],
///           I_r + [ 2, 2 ],
///           I_r + [ 2, 1, 1 ],
///           I_r + [ 1, 1, 1, 1 ],
///         ]
///     ...
///   ∴ when r = 0, P(m, n) has only a element I_m,
///     when r ≥ 1, P(m, n) = ∑ I_r + P(r, k)
///       n < r -> 1 ≤ k ≤ n
///       n ≥ r -> 1 ≤ k ≤ r
///     in other words, P(m, n) = ∑ I_r + P(r, k), 1 ≤ k ≤ min(n, r)
///
///

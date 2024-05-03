<details>
    <summary>index</summary>

[basic](#basic)
[number](#number)
[induction](#induction)

</details>

### basic
```dart
Iterable<Iterable<K>> powerSetFor(int size) => throw UnimplementedError(); // combinations from 0 to n
Iterable<Iterable<K>> get powerSet => throw UnimplementedError(); // include empty set
Set<List> cartesianProductAll(List<Set> others) => throw UnimplementedError();
// membership table, which record a member across multiple set, list, aka bool matrix/dataframe
// iterable bool complement
// use bitString to indicate that whether the element is in a list or iterable
```

```dart
// class MultiSet<K> implements Set<K> {
//   intersection: min(Mp, Mq)
//   union:        max(Mp, Mq)
//   difference:   Mp > Mq ? Mp - Mq : 0
//   sum:          Mp + Mq
// }
//
// IntExtension.factorized (in primes)
// NumExtension.digitPowered(int x, int exponent) => (factorized -> to prime log10_2 * 32).floor();
// summation for ar^k, k, k^2, k^3.
```

matrix
1. define matrix size properties (square (one arg) -> rect (two arg))
2. arithmetic, multiplication(deep mind for square)
3. identity (exponent 0 == I)
4. transpose, symmetric
5. bool matrix, and its operation(join (|), meet(&), product(multiply to &, adding to |), power)

cashier algorithm (find the minimum amount of coins/tickets from pocket, which summarized to be the prize)

## number
- decimal expansion
- radix plus/minus/multiply/divided
- Iterable<int/BigInt> pairwise coprime
- IntExtension. least common multiple (max for each prime exponent)
- Bezout coefficient (extended Euclid algorithm (p.286))
- congruence:
    - $ax + b \equiv k \mod m$
    - solving congruence system
- perform arithmetic on big integer by solving congruence system (create a class with encode/decode functions)
   - proof (2^a - 1) mod (2^b - 1) = 2^(a mod b) - 1
   - in binary pairwise coprime by using $gcd(2^a - 1, 2^b - 1) = 2^{gcd(a, b)} - 1$
- Fermat's little theorem !!!!! $(a^p - a) \mod p = 0$
- primitive roots, discrete logarithms (p.300)
hashing integers on limited space by mod allocated or linear probing
store all two primes multiply that not exceeding 10^10
- cipher:
   - monoalphabetic (mapping some/all words by Map or by list(f(aw + b) mod length))
   - transposition (mapping all words by switch position by one-to-one position Map<int, int>)
cryptosystem(p, c, k, e, d)
   - plaintext
   - ciphertext
   - keyspace
   _ encryption function
   - decryption function
encrypt by public key, decrypt by private key (simple version) ??
rsa cryptosystem (p.315)
fully homomorphic cryptosystem (additively, multiplicatively)

## induction
deductive reasoning logic vs inductive reasoning logic
$∑\limits_{i=1}^n i = \frac{n(n + 1)}{2}$ (arithmetic progression)\
$∑\limits_{i=0}^n 2i + 1 = (n + 1)^2$ \
$∑\limits_{i=0}^n 2^i = 2^{n - 1} - 1$ \
$∑\limits_{i=0}^n ar^i = \frac{ar^{n + 1} - a}{r - 1}$ (geometry progression)\
$∑\limits_{i=0}^n \frac{1}{i}$ (harmonic numbers)\
the $2^n \times 2^n$ checkerboard removed one square can be tiled with right triomino\
simple polygon (no two nonconsecutive sides intersect)\
convex
interior, exterior
triangulation
Tree: n (vertices in tree include root, height exclude root, n <= 2^(tree.height + 1) - 1)

## counting
counting functions from m to n, $c = n^m$\
counting injective functions from m to n, $m ≤ n$, $c = \frac{m!}{(n - 1)!}$

- pigeonhole principle
    - N objects placed into k box, at least one box contains $\lceil\frac{N}{k}\rceil$ objects
    - at least 45 element partition into a nested set with size 30, for each set element is identical on its ammount, and the set are ordered $\implies \exist$ consecutive element summation on its ammount $=$ 14

        
        let $a_n$ be the cumulative ammount of set element, inclusively
        let $S_1 = [a_1, a_2, a_3, ..., a_{30}]$, which is strictly increase positive integers sequence.\
        let $S_2 = [a_1 + 14, a_2 + 14 + a_3 + 14, ..., a_{30} + 14]$, which is also strictly increase positive integers sequence.
        let $i, j$ be the order in $S_1, S_2$ respectivly
        $$
        \because \\
        |S_1| = |S_2| = 30\\
        \implies |[...S_1, ...S_2]| = 60\\
        \land \\
        1 ≤ a_i ≤ 45 \\
        \implies 15 ≤ a_j + 14 ≤ 59\\
        \implies |\{...S_1, ...S_2\}| ≤ 59\\

        \therefore \\
        \forall j < i\\
        \exist a_i = a_j + 14
        $$

        -  TOGeneralize: at least m for n, find k
    - ramsey theory, ramsey numbers
- $P(n, r) = \cfrac{n!}{(n - r)!}$
- $C(n, r) = \cfrac{n!}{r!(n - r)!} = \dbinom{n}{r}$
- $(x + y)^n = ∑\limits_{j = 0}^{n} \binom{n}{j} x^{n - j}y^{j}$
    - $∑\limits_{j = 0}^{n} \binom{n}{j} = 2^n$
    - $∑\limits_{k = 0}^{n} \binom{n}{k} (-1)^k = 0$
    - $∑\limits_{k = 0}^{n} \binom{n}{k} 2^k = 3^n$
    - $\binom{n + 1}{k} = \binom{n}{k - 1} \binom{n}{k}$ (Pascal's identity)
    - $\binom{m + n}{r} = ∑\limits_{k = 0}^r \binom{m}{r - k} \binom{n}{k}$ (Vandermonde's identity)
        - $\binom{2n}{r} = ∑\limits_{k = 0}^r \binom{n}{k}^2$
        - $\binom{2n}{r} = ∑\limits_{k = 0}^r \binom{n}{k}^2$
    - $\binom{n + 1}{r + 1} = ∑\limits_{k = r + 1}^{n + 1}\binom{k - 1}{r} = ∑\limits_{j = r}^n \binom{j}{r}$
- $P_r(n, r) = n^r$
- $C_r(n, r) = \binom{n + r - 1}{r}$
- let $S = [n_0, n_1, n_2, ..., n_k]$
    - let $d$ denote "distinguishable"
    - let $¬d$ denote "indistinguishable"
    -  permutate $¬d$ objects: $P_i(n, r, S) = \cfrac{n!}{∏\limits_{i = 0}^k n_i}$
    - $d$ objects into $d$ boxes: $C(n, r, S) = P_i$
    - $¬d$ objects into $d$ boxes: $C(n, r) = C_r$
    - $d$ objects into $¬d$ boxes: $C(n, r) = ∑\limits_{j = 1}^kS(n, j)$
        - ??? stirling number 2rd: $S(n, j) = \frac{1}{j!}∑\limits_{i = 0}^{j - 1}(-1)^i \binom{j}{i}(j - i)^m$
    - $¬d$ objects into $¬d$ boxes: partition
- lexicographic ordering
    - generate next permutation in lexicographic order
    - k-combination (size k)
        - generate next k-combination of set by bitstring
///
///
/// this file contains:
/// [basic]
/// [number]
/// [induction]
///
///
///
///

///
///
/// Basic
///
///
///

const basic = '';
// Iterable<Iterable<K>> powerSetFor(int size) => throw UnimplementedError(); // combinations from 0 to n
// Iterable<Iterable<K>> get powerSet => throw UnimplementedError(); // include empty set
// Set<List> cartesianProductAll(List<Set> others) => throw UnimplementedError();
// membership table, which record a member across multiple set, list, aka bool matrix/dataframe
// iterable bool complement
// use bitString to indicate that whether the element is in a list or iterable

// class MultiSet<K> implements Set<K> {
//   // intersection: min(Mp, Mq)
//   // union:        max(Mp, Mq)
//   // difference:   Mp > Mq ? Mp - Mq : 0
//   // sum:          Mp + Mq
// }

// IntExtension.factorized (in primes)
// NumExtension.digitPowered(int x, int exponent) => (factorized -> to prime log10_2 * 32).floor();
// summation for ar^k, k, k^2, k^3.

// matrix
// 1. define matrix size properties (square (one arg) -> rect (two arg))
// 2. arithmetic, multiplication(deep mind for square)
// 3. identity (exponent 0 == I)
// 4. transpose, symmetric
// 5. bool matrix, and its operation(join (|), meet(&), product(multiply to &, adding to |), power)

// cashier algorithm (find the minimum amount of coins/tickets from pocket, which summarized to be the prize)

///
///
/// number
///
///

const number = '';
//
//
// - decimal expansion
// - radix plus/minus/multiply/divided
// - Iterable<int/BigInt> pairwise coprime
// - IntExtension. least common multiple (max for each prime exponent)
// - Bezout coefficient (extended Euclid algorithm (p.286))
// - solving congruence:
//    1. "ax + b" congruent to "k" modulo "m"
//    2. congruence system
// - perform arithmetic on big integer by solving congruence system (create a class with encode/decode functions)
//    - proof (2^a - 1) mod (2^b - 1) = 2^(a mod b) - 1
//    - in binary pairwise coprime by using gcd(2^a - 1, 2^b - 1) = 2^(gcd(a, b)) - 1
// - be able to proof fermat's little theorem !!!!! ((a^p - a) % p == 0)
// primitive roots, discrete logarithms (p.300)
// hashing integers on limited space by mod allocated or linear probing
// store all two primes multiply that not exceeding 10^10
// cipher:
//    - monoalphabetic (mapping some/all words by Map or by list(f(aw + b) mod length))
//    - transposition (mapping all words by switch position by one-to-one position Map<int, int>)
// cryptosystem(p, c, k, e, d)
//    - plaintext
//    - ciphertext
//    - keyspace
//    _ encryption function
//    - decryption function
// encrypt by public key, decrypt by private key (simple version)
// simulate rsa cryptosystem (p.315)
// fully homomorphic cryptosystem (additively, multiplicatively)
//

const induction = '';
//
// deductive reasoning logic vs inductive reasoning logic
// ∑\limits_{i=1}^n i = n(n + 1)/2                      --- arithmetic progression
// ∑\limits_{i=0}^n 2i + 1 = (n + 1)^2                  ---
// ∑\limits_{i=0}^n 2^i = 2^{n - 1} - 1                 ---
// ∑\limits_{i=0}^n ar^i = \frac{ar^{n + 1} - a}{r - 1} --- geometry progression
// ∑\limits_{i=0}^n 1/i                                 --- harmonic numbers
// n^3 - n is divisible by 3
// the 2^n * 2^n checkerboard removed one square can be tiled with right triomino
// simple polygon (no two nonconsecutive sides intersect), convex, interior, exterior, triangulation
// Tree: n (vertices in tree include root, height exclude root, n <= 2^(tree.height + 1) - 1)
//
//
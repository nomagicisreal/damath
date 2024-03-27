///
///
/// this file contains:
///
///
/// [Proof]
///
///
///
///
///
///
///
///
///
///
///
///
part of damath_experiment;

// p.85
class Proof {
  final Iterable<String> theorems;
  final Iterable<String> premises;
  final Iterable<String> axioms;
  final Iterable<String> lemma;
  final Iterable<String> corollaries;
  final Iterable<String> conjectures;
  final String statement;

  const Proof(
      this.theorems,
      this.premises,
      this.axioms,
      this.lemma,
      this.corollaries,
      this.conjectures,
      this.statement,
      );
}

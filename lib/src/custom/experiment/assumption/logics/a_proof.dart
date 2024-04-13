///
/// this file contains:
///
/// all the proposition and proof starts with definition:
/// [Proof]
///   [ProofUniversal]
///     [ProofDirect]
///     [ProofIndirect]
///
///   [ProofExistent]
///     [ProofConstructive]
///     [ProofNonconstructive]
///
/// [ProofTerminology]
///
///
///
///
part of damath_assumption;

///
/// proof aka implication, see also [Propositioner.implication]
///

// proving p.87 ~ p.113 in code
sealed class Proof {
  final String condition;
  final String conclusion;

  const Proof(this.condition, this.conclusion);

// const factory Proof.universal(String condition, String conclusion) = ProofUniversal;
// const factory Proof.existent(String condition, String conclusion) = ProofExistent;
}

///
///
///
///
/// universal
///
///
///
///

//
sealed class ProofUniversal extends Proof {
  const ProofUniversal(super.condition, super.conclusion);
}

//
abstract class ProofDirect extends ProofUniversal {
  const ProofDirect(super.condition, super.conclusion);
}

//
abstract class ProofIndirect extends ProofUniversal {
  const ProofIndirect(super.condition, super.conclusion);
}

//
class ProofDirectly extends ProofDirect {
  const ProofDirectly(super.condition, super.conclusion);
}

// by showing 'conclusion negation -> condition negation'
abstract class ProofContraposition extends ProofIndirect {
  const ProofContraposition(super.condition, super.conclusion);
}

// by showing "condition always false", which indicates conclusion must be true
abstract class ProofVacuous extends ProofIndirect {
  const ProofVacuous(super.condition, super.conclusion);
}

// a proof that showing "conclusion is true" is called a trivial proof,
// in a trivial proof, the condition or hypothesis may not needed.
abstract class ProofTrivial extends ProofIndirect {
  const ProofTrivial(super.condition, super.conclusion);
}

// a proof that showing 'statement negation -> False'
abstract class ProofContradiction extends ProofIndirect {
  const ProofContradiction(String statement) : super('', statement);
}

///
///
///
/// existent
///
///
///

//
sealed class ProofExistent extends Proof {
  const ProofExistent(super.condition, super.conclusion);
}

// by directly showing there is a condition exist
abstract class ProofConstructive extends ProofExistent {
  final String witness;

  const ProofConstructive(super.condition, this.witness, super.conclusion);
}

// by indirectly inference there is a condition exist
abstract class ProofNonconstructive extends ProofExistent {
  const ProofNonconstructive(super.condition, super.conclusion);

  // by instancing all the other cases are contradicts the condition,
  const ProofNonconstructive.uniqueness(super.condition, super.conclusion);
}

///
///
///
/// [ProofTerminology]
///
///

// p.105
enum ProofReasoning {
  forward,
  backward;
}


//
enum ProofTerminology {
  ///
  /// condition is an observable statement.
  /// conclusion is declarative, which is the result that proof from the condition.
  ///
  condition,
  conclusion,

  ///
  /// premise is declarative, which have asserted to be a true statement without explanation.
  /// assumption is assumed to be true, but also needs to consider of the circumstance that is not true.
  /// hypothesis is hypothetical, which is a predication and needs experimentation by logical sense.
  ///
  premise,
  assumption,
  hypothesis,

  ///
  ///
  ///
  conditionExhaustive,
  conditionCase,

  ///
  ///
  ///
  deduction,

  ///
  ///
  ///
  theorem,
  axiom,
  lemma,
  corollary,

  ///
  ///
  ///
  conjecture;
}

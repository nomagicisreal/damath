///
///
/// this file contains:
///
///
///
/// [Radian3Extension]
///
///
/// [PropositionEquivalenceLaw]
/// [PropositionRulesInference]
///
///
///
///
part of damath_experiment;

///
///
///
///
extension Radian3Extension on Radian3 {
  ///
  /// [Direction3DIn6.front] can be seen within {angleY(-90 ~ 90), angleX(-90 ~ 90)}
  /// [Direction3DIn6.left] can be seen within {angleY(0 ~ -180), angleZ(-90 ~ 90)}
  /// [Direction3DIn6.top] can be seen within {angleX(0 ~ 180), angleZ(-90 ~ 90)}
  /// [Direction3DIn6.back] can be seen while [Direction3DIn6.front] not be seen.
  /// [Direction3DIn6.right] can be seen while [Direction3DIn6.left] not be seen.
  /// [Direction3DIn6.bottom] can be seen while [Direction3DIn6.top] not be seen.
  ///
  List<Direction3DIn6> get visibleFaces {
    throw UnimplementedError();
    // final r = radian.restrict180AbsAngle;
    // final rX = r.dx;
    // final rY = r.dy;
    // final rZ = r.dz;

    // return <Direction3DIn6>[
    //   Radian.ifWithinAngle90_90N(rY) && Radian.ifWithinAngle90_90N(rX)
    //       ? Direction3DIn6.front
    //       : Direction3DIn6.back,
    //   Radian.ifWithinAngle0_180N(rY) && Radian.ifWithinAngle90_90N(rZ)
    //       ? Direction3DIn6.left
    //       : Direction3DIn6.right,
    //   Radian.ifWithinAngle0_180(rX) && Radian.ifWithinAngle90_90N(rZ)
    //       ? Direction3DIn6.top
    //       : Direction3DIn6.bottom,
    // ];
  }
}

///
///
///
///
/// for [Proposition]
///
///
///
///
///

// p.29
enum PropositionEquivalenceLaw {
  identity,
  domination,
  idempotent,
  doubleNegation,
  commutative,
  associative,
  distributive,
  deMorgans,
  absorption,
  negation
} // ... conditional, biconditional,
// p.35 n-Queens problem (find out all the position for all the people in the society)

// p.76
enum PropositionRulesInference {
  modusPonens,
  modusTollens,
  hypotheticalSyllogism,
  disjunctiveSyllogism,
  addition,
  simplification,
  conjunction,
  resolution,
}


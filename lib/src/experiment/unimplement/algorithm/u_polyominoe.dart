///
///
/// this file contains:
///
///
part of damath_experiment;

///
///
///
///
///
/// dominoe
///
/// polyominoe is the tiling that use identically congruent squares that are connected along their edges.
///
///
///

sealed class Polyominoe {
  final double size;

  const Polyominoe(this.size);

  double get area;
}

abstract class Dominoe extends Polyominoe {
  const Dominoe(super.size);

  @override
  double get area => size.squared * 2;
}

abstract class Triomino extends Polyominoe {
  const Triomino(super.size);

  @override
  double get area => size.squared * 3;
}

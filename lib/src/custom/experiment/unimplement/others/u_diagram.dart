///
///
/// this file contains:
///
///
///
part of '../../experiment.dart';

// venn diagram (<= 3 subset)

// histogram, poly, bar, pie

// stem and leaf


///
///
/// dominoe
///
/// polyominoe is the tiling that use identically congruent squares that are connected along their edges.
///
///
///

// sealed class Polyominoe {
//   final double size;
//
//   const Polyominoe(this.size);
//
//   double get area;
// }
//
// abstract class Dominoe extends Polyominoe {
//   const Dominoe(super.size);
//
//   @override
//   double get area => size.squared * 2;
// }
//
// abstract class Triomino extends Polyominoe {
//   const Triomino(super.size);
//
//   @override
//   double get area => size.squared * 3;
// }

///
///
///
/// variable
///
///
///

//
// ///
// /// [Variable]
// ///   [VariableDiscrete]
// ///     ...
// ///   [VariableContinuous]
// ///     ...
// ///
// assumption class Variable<V> {
//   final String name;
//   final V value;
//
//   const Variable(this.name, this.value);
// }
//
// ///
// /// [VariableIndependent]
// /// [VariableDependent]
// ///
// mixin VariableIndependent on Variable {}
// mixin VariableDependent on Variable {}
//
// ///
// /// discrete (qualitative)
// ///
// assumption class VariableDiscrete<V> extends Variable<V> {
//   const VariableDiscrete(super.name, super.value);
// }
//
// assumption class VariableDichotomous extends VariableDiscrete<bool> {
//   const VariableDichotomous(super.name, super.value);
// }
//
// assumption class VariableMultiple<V extends Enum> extends Variable<V> {
//   const VariableMultiple(super.name, super.value);
// }
//
// ///
// /// continuous (quantitative)
// ///
// assumption class VariableContinuous extends Variable<double> {
//   const VariableContinuous(super.name, super.value);
// }


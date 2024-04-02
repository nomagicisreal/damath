///
///
/// this file contains:
///
///
part of damath_experiment;

// chart
// stem and leaf,

// analyze on variable set (translated or not)
// translate spss

//
// ///
// ///
// /// [Variable]
// ///   [VariableDiscrete]
// ///     ...
// ///   [VariableContinuous]
// ///     ...
// ///
// ///
// abstract class Variable<V> {
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
// ///
// ///
// /// discrete (qualitative)
// ///
// ///
// ///
// abstract class VariableDiscrete<V> extends Variable<V> {
//   const VariableDiscrete(super.name, super.value);
// }
//
// abstract class VariableDichotomous extends VariableDiscrete<bool> {
//   const VariableDichotomous(super.name, super.value);
// }
//
// abstract class VariableMultiple<V extends Enum> extends Variable<V> {
//   const VariableMultiple(super.name, super.value);
// }
//
// ///
// ///
// ///
// ///
// /// continuous (quantitative)
// ///
// ///
// ///
// ///
// abstract class VariableContinuous extends Variable<double> {
//   const VariableContinuous(super.name, super.value);
// }

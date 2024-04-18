///
///
/// this file contains:
///
///
///
///
///
///
part of damath_experiment;

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
// ///
// ///
// /// discrete (qualitative)
// ///
// ///
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
// ///
// ///
// ///
// /// continuous (quantitative)
// ///
// ///
// ///
// ///
// assumption class VariableContinuous extends Variable<double> {
//   const VariableContinuous(super.name, super.value);
// }



///
///
///
/// latex
///
///
///
///

//
//
// //
// enum Latex {
//   plus,
//   minus,
//   multiply,
//   divided,
//   modulus;
//
//   @override
//   String toString() => switch (this) {
//     Latex.plus => '+',
//     Latex.minus => '-',
//     Latex.multiply => '*',
//     Latex.divided => '/',
//     Latex.modulus => '%',
//   };
//
//   String get symbol => switch (this) {
//     Latex.plus => r'+',
//     Latex.minus => r'-',
//     Latex.multiply => r'\times',
//     Latex.divided => r'\div',
//     Latex.modulus => throw UnimplementedError(),
//   };
//
//   ///
//   /// latex operation
//   ///
//   String latexOperationOf(String a, String b) => "$a $symbol $b";
//
//   String latexOperationOfDouble(double a, double b, {int fix = 0}) =>
//       "${a.toStringAsFixed(fix)} "
//           "$symbol "
//           "${b.toStringAsFixed(fix)}";
//
//   static double operateAll(
//       double value,
//       Iterable<MapEntry<Latex, double>> operations,
//       ) =>
//       operations.fold(
//         value,
//             (a, operation) => switch (operation.key) {
//           Latex.plus => a + operation.value,
//           Latex.minus => a - operation.value,
//           Latex.multiply => a * operation.value,
//           Latex.divided => a / operation.value,
//           Latex.modulus => a % operation.value,
//         },
//       );
// }


// standard deviation vs standard error
// Central limit theorem
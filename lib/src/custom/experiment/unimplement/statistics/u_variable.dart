///
///
/// this file contains:
///
///
///
///
/// [Latex]
/// [KLaTexString], [KLatexStringEquation], [KLatexStringMatrix1N], [KLatexStringMatrix2N], [FLaTexString]
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
//   divide,
//   modulus;
//
//   @override
//   String toString() => switch (this) {
//     Latex.plus => '+',
//     Latex.minus => '-',
//     Latex.multiply => '*',
//     Latex.divide => '/',
//     Latex.modulus => '%',
//   };
//
//   String get symbol => switch (this) {
//     Latex.plus => r'+',
//     Latex.minus => r'-',
//     Latex.multiply => r'\times',
//     Latex.divide => r'\div',
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
//           Latex.divide => a / operation.value,
//           Latex.modulus => a % operation.value,
//         },
//       );
// }



///
///
///
///
/// latex string
///
///
///
///
//
// extension KLaTexString on String {
//   static const quadraticRoots = r"{-b \pm \sqrt{b^2-4ac} \over 2a}";
//   static const sn = r"S_n";
//   static const x1_ = r"x_1 + x_2 + ... + x_n";
//   static const x1_3 = r"x_1 + x_2 + x_3";
//   static const x1_4 = r"x_1 + x_2 + x_3 + x_4";
//   static const x1_5 = r"x_1 + x_2 + x_3 + x_4 + x_5";
//   static const ax1_ = r"a_1x_1 + a_2x_2 + ... + a_nx_n";
//   static const ax1_3 = r"a_1x_1 + a_2x_2 + a_3x_3";
//   static const ax1_4 = r"a_1x_1 + a_2x_2 + a_3x_3 + a_4x_4";
//   static const ax1_5 = r"a_1x_1 + a_2x_2 + a_3x_3 + a_4x_4 + a_5x_5";
// }
//
// extension KLatexStringEquation on String {
//   static const quadraticRootsOfX = r"x = " + KLaTexString.quadraticRoots;
//   static const yLinearABX = r"y = a + bx";
//   static const yLinearMXK = r"y = mx + k";
// }
//
// extension KLatexStringMatrix1N on String {
//   static const y1_ = r"""\begin{bmatrix}
//   y_1\\
//   y_2\\
//   ...\\
//   y_n\\
//   \end{bmatrix}""";
// }
//
// extension KLatexStringMatrix2N on String {
//   static const const1_x1_ = r"""\begin{bmatrix}
//   1&x_1\\
//   1&x_2\\
//   ...&...\\
//   1&x_n\\
//   \end{bmatrix}""";
// }
//
// extension FLaTexString on String {
//   static String equationOf(Iterable<String> values) => values.reduce(
//         (a, b) => "$a = $b",
//   );
// }
//

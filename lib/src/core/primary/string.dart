///
///
/// this file contains:
///
/// [RegExpExtension]
/// [MatchExtension]
/// [StringExtension]
/// [StringBufferExtension]
///
///
/// [Latex]
/// [KLaTexString], [KLatexStringEquation], [KLatexStringMatrix1N], [KLatexStringMatrix2N], [FLaTexString]
///
///
///
///
part of damath_core;

///
///
extension RegExpExtension on RegExp {
  ///
  /// '+' means one or more,
  /// "*" means zero or more.
  ///
  static String wordUntilFor(String source) =>
      RegExp(r'(\w+)').firstMatch(source)?.group0 ??
      (throw StateError(FErrorMessage.regexNotMatchAny));
}

///
///
///
extension MatchExtension on Match {
  String get group0 => group(0)!;
}

///
/// static methods:
/// [reduceLine], ...
///
/// instance methods:
/// [lowercaseFirstChar], ...
///
///
extension StringExtension on String {
  ///
  /// [reduceLine]
  /// [reduceTab]
  /// [reduceComma]
  ///
  static String reduceLine(String v1, String v2) => '$v1\n$v2';

  static String reduceTab(String v1, String v2) => '$v1\t$v2';

  static String reduceComma(String v1, String v2) => '$v1, $v2';

  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///
  String get lowercaseFirstChar => replaceFirstMapped(
      RegExp(r'[A-Z]'), (match) => match.group0.toLowerCase());

  (String, String) get splitByFirstSpace {
    late final String a;
    final b = replaceFirstMapped(RegExp(r'\w '), (match) {
      a = match.group0.trim();
      return '';
    });
    return (a, b);
  }

  ///
  /// camel, underscore usage
  ///

  String get fromUnderscoreToCamelBody => splitMapJoin(RegExp(r'_[a-z]'),
      onMatch: (match) => match.group0[1].toUpperCase());

  String get fromCamelToUnderscore =>
      lowercaseFirstChar.splitMapJoin(RegExp(r'[a-z][A-Z]'), onMatch: (match) {
        final s = match.group0;
        return '${s[0]}_${s[1].toLowerCase()}';
      });
}

///
///
///
extension StringBufferExtension on StringBuffer {
  void writeIfNotNull(Object? object) {
    if (object != null) write(object);
  }
}

///
///
///
///
///
///
///
///
/// latex
///
///
///
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

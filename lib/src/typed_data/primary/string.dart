///
///
/// this file contains:
///
///
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
part of damath_typed_data;


///
///
///
extension MatchExtension on Match {
  String get group0 => group(0)!;
}


///
///
///
///
extension StringExtension on String {
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

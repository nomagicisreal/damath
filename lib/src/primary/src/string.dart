part of '../primary.dart';

///
///
/// [RegExpExtension]
/// [MatchExtension]
/// [StringExtension]
/// [StringBufferExtension]
///
///


///
///
///
extension RegExpExtension on RegExp {
  ///
  /// '+' means one or more,
  /// "*" means zero or more.
  ///
  static String wordUntilFor(String source) =>
      RegExp(r'(\w+)').firstMatch(source)?.group0 ??
      (throw StateError(ErrorMessages.regexNotMatchAny));
}

///
///
///
extension MatchExtension on Match {
  String? get group0 => group(0);
  String? get group1 => group(1);
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
      RegExp(r'^[A-Z]'), (match) => match.group0!.toLowerCase());

  (String, String) get splitByFirstSpace {
    late final String a;
    final b = replaceFirstMapped(RegExp(r'\w '), (match) {
      a = match.group0!.trim();
      return '';
    });
    return (a, b);
  }

  ///
  /// camel, underscore usage
  ///

  String get fromUnderscoreToCamelBody => splitMapJoin(RegExp(r'_[a-z]'),
      onMatch: (match) => match.group0![1].toUpperCase());

  String get fromCamelToUnderscore =>
      lowercaseFirstChar.splitMapJoin(RegExp(r'[a-z][A-Z]'), onMatch: (match) {
        final s = match.group0!;
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

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
      RegExp(r'\w+').firstMatch(source)?.group0 ??
      (throw StateError(Erroring.regexNotMatchAny));
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
    RegExp(r'^[A-Z]'),
    (match) => match.group0!.toLowerCase(),
  );

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

  String get fromUnderscoreToCamelBody => splitMapJoin(
    RegExp(r'_[a-z]'),
    onMatch: (match) => match.group0![1].toUpperCase(),
  );

  String get fromCamelToUnderscore => lowercaseFirstChar.splitMapJoin(
    RegExp(r'[a-z][A-Z]'),
    onMatch: (match) {
      final s = match.group0!;
      return '${s[0]}_${s[1].toLowerCase()}';
    },
  );

  String insertEvery(int count, [String insertion = ' ']) {
    final buffer = StringBuffer();
    final trail = length - 1;
    for (var i = 0; i < trail; i++) {
      buffer.write(this[i]);
      if ((i + 1) % 8 == 0) buffer.write(insertion);
    }
    buffer.write(this[trail]);
    return buffer.toString();
  }

  String get reversed {
    final buffer = StringBuffer();
    for (var i = length - 1; i > -1; i--) {
      buffer.write(this[i]);
    }
    return buffer.toString();
  }
}

///
///
///
extension StringBufferExtension on StringBuffer {
  void writeIfNotNull(Object? object) {
    if (object != null) write(object);
  }

  void writeUntilNull<T>({
    required Mapper<T?, String?> string,
    required T? current,
    required Mapper<T, T?> apply,
    String separator = ', ',
  }) {
    write(string(current));
    if (current == null) return;
    for (current = apply(current); current != null; current = apply(current)) {
      write('$separator${string(current)}');
    }
  }
}

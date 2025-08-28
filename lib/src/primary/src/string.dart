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
      (throw StateError(ErrorMessage.regexNotMatchAny));
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
/// [mapToLength], ...
/// [reduceLine], ...
///
/// instance methods:
/// [lowercaseFirstChar], ...
///
///
extension StringExtension on String {
  ///
  /// [mapToLength]
  ///
  static int mapToLength(String s) => s.length;

  ///
  /// [reduceLine]
  /// [reduceTab]
  /// [reduceComma]
  /// [reduceMaxLength]
  ///
  static String reduceLine(String v1, String v2) => '$v1\n$v2';

  static String reduceTab(String v1, String v2) => '$v1\t$v2';

  static String reduceComma(String v1, String v2) => '$v1, $v2';

  static String reduceMaxLength(String v1, String v2) =>
      v1.length > v2.length ? v1 : v2;

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
/// [writeBit], ...
/// [writeRepeat], ...
///
///
extension StringBufferExtension on StringBuffer {
  ///
  /// [writeBit]
  /// [writeBits8]
  /// [writeBitsOfMonth]
  ///
  void writeBit(int bits) => write(bits & 1 == 1 ? '1' : '0');

  int writeBits8(int bits) {
    var i = 0;
    while (i < 8) {
      writeBit(bits);
      bits >>= 1;
      i++;
    }
    return bits;
  }

  int writeBitsN(int bits, int n) {
    var i = 0;
    while (i < n) {
      writeBit(bits);
      bits >>= 1;
      i++;
    }
    return bits;
  }

  void writeBitsOfMonth(int days, int dayLast) {
    var i = 0;
    // 1 ~ 24
    for (var j = 1; j < 4; j++) {
      final last = j * 8;
      while (i < last) {
        writeBit(days);
        days >>= 1;
        i++;
      }
      write(' ');
    }

    // 25 ~ lastDay
    while (i < dayLast) {
      writeBit(days);
      days >>= 1;
      i++;
    }
  }

  ///
  /// [writeRepeat]
  /// [writeIfNotNull]
  /// [writeUntilNull]
  ///
  void writeRepeat(int n, String value) {
    for (var i = 0; i < n; i++) {
      write(value);
    }
  }

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

///
///
/// this file contains:
///
/// [NullableExtension]
///
///
/// [DurationExtension]
/// [DateTimeExtension]
///
/// [StringExtension]
/// [MatchExtension]
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
part of damath_core;

///
/// nullable
///
extension NullableExtension<T> on T? {
  bool get isNull => this == null;

  bool get isNotNull => this != null;

  ///
  /// [nullOr]
  /// [nullOrMap]
  ///
  S? nullOr<S>(S value) => this == null ? null : value;

  S? nullOrMap<S>(Mapper<T, S> toVal) => this == null ? null : toVal(this!);

  ///
  /// [mapNotNullOr]
  /// [consumeNotNull]
  ///
  S mapNotNullOr<S>(Mapper<T, S> toVal, Supplier<S> ifNull) {
    return this == null ? ifNull() : toVal(this!);
  }

  void consumeNotNull(Consumer<T> consumer) {
    if (this != null) consumer(this!);
  }

  ///
  /// [expandTo]
  ///
  Iterable<S> expandTo<S>(
    Mapper<T, Iterable<S>> expanding, [
    Supplier<Iterable<S>>? supplyNull,
  ]) =>
      this == null ? supplyNull?.call() ?? Iterable.empty() : expanding(this!);
}

extension BoolExtension on bool {
  String get toStringTOrF => this ? 'T' : 'F';
}

///
/// duration
///
extension DurationExtension on Duration {
  ///
  /// [toStringDayMinuteSecond]
  ///
  String toStringDayMinuteSecond({String splitter = ':'}) {
    final dayMinuteSecond = toString().substring(0, 7);
    return splitter == ":"
        ? dayMinuteSecond
        : dayMinuteSecond.splitMapJoin(RegExp(':'), onMatch: (_) => splitter);
  }
}

///
/// datetime
///
extension DateTimeExtension on DateTime {
  static bool isSameDay(DateTime? a, DateTime? b) => a == null || b == null
      ? false
      : a.year == b.year && a.month == b.month && a.day == b.day;

  String get date => toString().split(' ').first; // $y-$m-$d

  String get time => toString().split(' ').last; // $h:$min:$sec.$ms$us

  int get monthDays => switch (month) {
        1 => 31,
        2 => year % 4 == 0
            ? year % 100 == 0
                ? year % 400 == 0
                    ? 29
                    : 28
                : 29
            : 28,
        3 => 31,
        4 => 30,
        5 => 31,
        6 => 30,
        7 => 31,
        8 => 31,
        9 => 30,
        10 => 31,
        11 => 30,
        12 => 31,
        _ => throw UnimplementedError(),
      };

  static String parseTimestampOf(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string)).toIso8601String();
}

///
/// string
///
extension StringExtension on String {
  String get lowercaseFirstChar => replaceFirstMapped(
      RegExp(r'[A-Z]'), (match) => match.group0.toLowerCase());

  MapEntry<String, String> get splitByFirstSpace {
    late final String key;
    final value = replaceFirstMapped(RegExp(r'\w '), (match) {
      key = match.group0.trim();
      return '';
    });
    return MapEntry(key, value);
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

/// match
extension MatchExtension on Match {
  String get group0 => group(0)!;
}

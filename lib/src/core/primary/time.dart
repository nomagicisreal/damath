///
///
/// this file contains:
///
///
/// [DurationExtension]
/// [DateTimeExtension]
///
///
part of damath_core;

///
/// duration
///
extension DurationExtension on Duration {
  ///
  ///
  /// static methods
  ///
  ///
  static Duration reduceMax(Duration a, Duration b) => a > b ? a : b;

  static Duration reduceMin(Duration a, Duration b) => a < b ? a : b;

  static Duration reducePlus(Duration v1, Duration v2) => v1 + v2;

  static Duration reduceMinus(Duration v1, Duration v2) => v1 - v2;

  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///

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
///
///
///
///
extension DateTimeExtension on DateTime {
  ///
  /// [predicateSameYear], [predicateSameMonth], [predicateSameDay]
  /// [predicateSameDate]
  ///
  static bool predicateSameYear(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.year == b.year;

  static bool predicateSameMonth(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.month == b.month;

  static bool predicateSameDay(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.day == b.day;

  static bool predicateSameDate(DateTime? a, DateTime? b) =>
      a == null || b == null
          ? false
          : a.year == b.year && a.month == b.month && a.day == b.day;
  static Predicator<DateTime> sameDayWith(DateTime? day) =>
          (value) => predicateSameDay(value, day);

  ///
  ///
  ///
  /// instance methods
  ///
  ///
  ///

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

  static String parseTimestamp(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string)).toIso8601String();
}


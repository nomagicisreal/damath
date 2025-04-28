part of '../primary.dart';

///
///
/// [DurationExtension]
/// [DateTimeExtension]
///
///

///
///
/// [milli100], ...
/// [reduceMax], ...
///
///
extension DurationExtension on Duration {
  static const Duration milli100 = Duration(milliseconds: 100);
  static const Duration milli200 = Duration(milliseconds: 200);
  static const Duration milli300 = Duration(milliseconds: 300);
  static const Duration milli400 = Duration(milliseconds: 400);
  static const Duration milli500 = Duration(milliseconds: 500);
  static const Duration milli600 = Duration(milliseconds: 600);
  static const Duration milli700 = Duration(milliseconds: 700);
  static const Duration milli800 = Duration(milliseconds: 800);
  static const Duration milli900 = Duration(milliseconds: 900);
  static const Duration second1 = Duration(seconds: 1);
  static const Duration min1 = Duration(minutes: 1);
  static const Duration hour1 = Duration(hours: 1);
  static const Duration day1 = Duration(days: 1);

  ///
  ///
  ///
  static Duration reduceMax(Duration a, Duration b) => a > b ? a : b;

  static Duration reduceMin(Duration a, Duration b) => a < b ? a : b;

  static Duration reducePlus(Duration v1, Duration v2) => v1 + v2;

  static Duration reduceMinus(Duration v1, Duration v2) => v1 - v2;

  static String dayMinuteSecondFrom(
    Duration duration, [
    String splitter = ':',
  ]) {
    final result = duration.toString().substring(0, 7);
    return splitter == ":"
        ? result
        : result.splitMapJoin(RegExp(':'), onMatch: (_) => splitter);
  }
}

///
///
///
///
///
extension DateTimeExtension on DateTime {
  ///
  ///
  /// constants
  ///
  ///
  static const String sunday_chinese = '（日）';
  static const String monday_chinese = '（一）';
  static const String tuesday_chinese = '（二）';
  static const String wednesday_chinese = '（三）';
  static const String thursday_chinese = '（四）';
  static const String friday_chinese = '（五）';
  static const String saturday_chinese = '（六）';

  ///
  ///
  /// static methods
  ///
  ///
  //
  // sample output: 2025-04-06（日） ~ 2025-04-12（六）
  //
  static String nowWeek({
    int from = DateTime.sunday,
    String sep = " ~ ",
    bool dayName = true,
    Duration after = Duration.zero,
  }) {
    final now = DateTime.now().add(after);
    late final String dateStart;
    late final String dateEnd;
    if (from == DateTime.sunday) {
      if (now.weekday == DateTime.sunday) {
        dateStart = now.date;
        dateEnd = now.addDays(6).date;
      } else {
        final start = now.addDays(-now.weekday);
        dateStart = start.date;
        dateEnd = start.addDays(6).date;
      }
      return '$dateStart${dayName ? sunday_chinese : ''}'
          '$sep'
          '$dateEnd${dayName ? saturday_chinese : ''}';
    }
    throw UnimplementedError();
  }

  ///
  ///
  /// [parseTimestamp]
  /// [predicateSameYear], [predicateSameMonth], [predicateSameDay]
  /// [predicateSameDate]
  ///
  ///
  static String parseTimestamp(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string)).toIso8601String();

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
    2 =>
      year % 4 == 0
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

  ///
  ///
  ///
  DateTime addDays(int days) => add(Duration(days: days));

  DateTime addHours(int hours) => add(Duration(hours: hours));
}

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
  /// [dayMinuteSecondFrom]
  ///
  static String dayMinuteSecondFrom(
    Duration duration, [
    String splitter = ':',
  ]) {
    final result = duration.toString().substring(0, 7);
    return splitter == ":"
        ? result
        : result.splitMapJoin(RegExp(':'), onMatch: (_) => splitter);
  }

  ///
  /// [reduceMax], [reduceMin]
  /// [reducePlus], [reduceMinus]
  ///
  static Duration reduceMax(Duration a, Duration b) => a > b ? a : b;

  static Duration reduceMin(Duration a, Duration b) => a < b ? a : b;

  static Duration reducePlus(Duration v1, Duration v2) => v1 + v2;

  static Duration reduceMinus(Duration v1, Duration v2) => v1 - v2;
}

///
///
///
/// [sunday_chinese], ...
/// return bool       --> [isSameYearN], ...
/// return int        --> [dayOfYear], ...
/// return string     --> [parseTimestamp], ...
/// return date time  --> [normalizeDate], ...
///
///
///
extension DateTimeExtension on DateTime {
  ///
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
  /// [isSameYearN], ..., [isSameDateN]
  /// [isSameDate]
  ///
  static bool isSameYearN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.year == b.year;

  static bool isSameMonthN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.month == b.month;

  static bool isSameDayN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.day == b.day;

  static bool isSameDateN(DateTime? a, DateTime? b) =>
      a == null || b == null
          ? false
          : a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  ///
  ///
  /// [isBefore], [isAfter]
  /// [isIn], [isWithin]
  ///
  /// [anyInvalidWeekday]
  ///
  ///

  ///
  /// [isBefore], [isAfter]
  /// [isIn], [isWithin]
  ///
  static bool isBefore(DateTime date1, DateTime date2) => date1.isBefore(date2);

  static bool isAfter(DateTime date1, DateTime date2) => date1.isAfter(date2);

  static bool isIn(DateTime day, DateTime start, DateTime end) {
    if (day.isAfter(start) && day.isBefore(end)) return true;
    return false;
  }

  static bool isWithin(DateTime day, DateTime start, DateTime end) {
    if (DateTimeExtension.isSameDateN(day, start) ||
        DateTimeExtension.isSameDateN(day, end)) {
      return true;
    }
    if (day.isAfter(start) && day.isBefore(end)) return true;
    return false;
  }

  ///
  /// [anyInvalidWeekday]
  ///
  static bool anyInvalidWeekday(Set<int> dates) =>
      dates.any((day) => day < DateTime.monday || day > DateTime.sunday);

  ///
  ///
  ///
  /// [dayOfYear]
  /// [weekNumberInYearOf]
  /// [monthDaysOf], [monthWeeksOf]
  ///
  ///
  ///

  ///
  /// [dayOfYear]
  /// [weekNumberInYearOf]
  ///
  static int dayOfYear(DateTime date) =>
      DateTime.utc(
        date.year,
      ).difference(DateTime.utc(date.year, date.month, date.day)).inDays +
      1;

  static int weekNumberInYearOf(
    DateTime date, [
    int startingDay = DateTime.sunday,
  ]) {
    final startingDate = DateTime.utc(date.year);
    final days = normalizeDate(date).difference(startingDate).inDays;
    final remains = days % DateTime.daysPerWeek;
    final weeks = days ~/ 7;
    if (remains == 0) return weeks;

    final previousDays = (startingDate.weekday - startingDay) % 7;
    if (remains + previousDays > DateTime.daysPerWeek) return weeks + 1;
    return weeks;
  }

  ///
  /// [monthDaysOf]
  /// [monthWeeksOf]
  ///
  static int monthDaysOf(DateTime date) => switch (date.month) {
    1 => 31,
    2 =>
      date.year % 4 == 0
          ? date.year % 100 == 0
              ? date.year % 400 == 0
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
    _ => throw StateError('invalid month ${date.month}'),
  };

  static int monthWeeksOf(DateTime date, [int startingDay = DateTime.sunday]) =>
      (1 +
          firstDateOfWeekInMonth(
            date,
          ).difference(lastDateOfWeekInMonth(date, startingDay)).inDays) ~/
      7;

  ///
  ///
  ///
  /// [parseTimestamp], [stringDateOf], [nowWeek]
  ///
  ///
  ///

  ///
  /// [parseTimestamp], $y-$m-$d
  ///
  static String stringDateOf(DateTime date) => date.toString().split(' ').first;

  ///
  /// [stringDateOf], $h:$min:$sec.$ms$us
  ///
  static String stringTimeOf(DateTime date) => date.toString().split(' ').last;

  static String parseTimestamp(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string)).toIso8601String();

  ///
  /// [nowWeek], sample output: 2025-04-06（日） ~ 2025-04-12（六）
  ///
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
        dateStart = stringDateOf(now);
        dateEnd = stringDateOf(now.add(Duration(days: 6)));
      } else {
        final start = now.add(Duration(days: -now.weekday));
        dateStart = stringDateOf(start);
        dateEnd = stringDateOf(start.add(Duration(days: 6)));
      }
      return '$dateStart${dayName ? sunday_chinese : ''}'
          '$sep'
          '$dateEnd${dayName ? saturday_chinese : ''}';
    }
    throw UnimplementedError();
  }

  ///
  ///
  /// [normalizeDate], [clamp]
  /// [firstDateOfMonth], [firstDateOfWeek], [firstDateOfWeekInMonth]
  /// [lastDateOfMonth], [lastDateOfWeek], [lastDateOfWeekInMonth]
  ///
  ///

  ///
  /// [normalizeDate], [clamp]
  ///
  static DateTime normalizeDate(DateTime datetime) =>
      DateTime.utc(datetime.year, datetime.month, datetime.day);

  static DateTime clamp(
    DateTime value,
    DateTime lowerLimit,
    DateTime upperLimit,
  ) {
    if (value.isBefore(lowerLimit)) return lowerLimit;
    if (value.isAfter(upperLimit)) return upperLimit;
    return value;
  }

  ///
  /// [firstDateOfMonth], [firstDateOfWeek], [firstDateOfWeekInMonth]
  ///
  static DateTime firstDateOfMonth(DateTime date) =>
      DateTime.utc(date.year, date.month);

  // in dart, -1 % 7 = 6
  static DateTime firstDateOfWeek(
    DateTime date, [
    int startingDay = DateTime.sunday,
  ]) => date.subtract(
    DurationExtension.day1 * ((date.weekday - startingDay) % 7),
  );

  static DateTime firstDateOfWeekInMonth(
    DateTime date, [
    int startingDay = DateTime.sunday,
  ]) => firstDateOfMonth(
    date,
  ).subtract(DurationExtension.day1 * ((date.weekday - startingDay) % 7));

  ///
  /// [lastDateOfMonth], [lastDateOfWeek], [lastDateOfWeekInMonth]
  ///
  static DateTime lastDateOfMonth(DateTime date) =>
      DateTime.utc(date.year, date.month + 1).subtract(DurationExtension.day1);

  static DateTime lastDateOfWeek(
    DateTime date, [
    int startingDay = DateTime.sunday,
  ]) =>
      date.add(DurationExtension.day1 * ((startingDay - 1 - date.weekday) % 7));

  static DateTime lastDateOfWeekInMonth(
    DateTime date, [
    int startingDay = DateTime.sunday,
  ]) => lastDateOfMonth(
    date,
  ).add(DurationExtension.day1 * ((startingDay - 1 - date.weekday) % 7));
}

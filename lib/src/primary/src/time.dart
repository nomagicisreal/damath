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
  /// [toStringDayMinuteSecond]
  ///
  String toStringDayMinuteSecond([String splitter = ':']) {
    final result = toString().substring(0, 7);
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
/// statics:
/// constants                 --> [sunday_inChinese], ...
/// methods return bool       --> [predicateSameYearN], ...
/// methods return dateTime   --> [parseTimestamp], ...
///
/// instances:
/// methods return bool       --> [isLeapYear], ...
/// methods return int        --> [daysOfYear], ...
/// methods return string     --> [toStringDate], ...
/// methods return date time  --> [normalized], ...
///
///
extension DateTimeExtension on DateTime {
  ///
  ///
  ///
  static const String sunday_inChinese = '（日）';
  static const String monday_inChinese = '（一）';
  static const String tuesday_inChinese = '（二）';
  static const String wednesday_inChinese = '（三）';
  static const String thursday_inChinese = '（四）';
  static const String friday_inChinese = '（五）';
  static const String saturday_inChinese = '（六）';

  ///
  ///
  /// [predicateSameYearN], [predicateSameMonthN], [predicateSameDayN], [predicateSameDateN], [predicateSameDate]
  /// [predicateBefore], [predicateAfter]
  /// [predicateIn], [predicateWithin]
  /// [anyInvalidWeekday]
  ///
  ///

  ///
  ///
  /// [predicateSameYearN], ..., [predicateSameDateN]
  /// [predicateSameDate]
  ///
  static bool predicateSameYearN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.year == b.year;

  static bool predicateSameMonthN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.month == b.month;

  static bool predicateSameDayN(DateTime? a, DateTime? b) =>
      a == null || b == null ? false : a.day == b.day;

  static bool predicateSameDateN(DateTime? a, DateTime? b) =>
      a == null || b == null
          ? false
          : a.year == b.year && a.month == b.month && a.day == b.day;

  static bool predicateSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  ///
  /// [predicateBefore], [predicateAfter]
  /// [predicateIn], [predicateWithin]
  ///
  static bool predicateBefore(DateTime date1, DateTime date2) =>
      date1.isBefore(date2);

  static bool predicateAfter(DateTime date1, DateTime date2) =>
      date1.isAfter(date2);

  static bool predicateIn(DateTime day, DateTime start, DateTime end) {
    if (day.isAfter(start) && day.isBefore(end)) return true;
    return false;
  }

  static bool predicateWithin(DateTime day, DateTime start, DateTime end) {
    if (DateTimeExtension.predicateSameDateN(day, start) ||
        DateTimeExtension.predicateSameDateN(day, end)) {
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
  /// [parseTimestamp], [clamping]
  ///
  ///

  ///
  /// [parseTimestamp], [clamping]
  ///
  static DateTime parseTimestamp(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string));

  static DateTime clamping(
    DateTime value,
    DateTime lowerLimit,
    DateTime upperLimit,
  ) {
    if (value.isBefore(lowerLimit)) return lowerLimit;
    if (value.isAfter(upperLimit)) return upperLimit;
    return value;
  }

  ///
  /// [isLeapYear]
  ///
  bool get isLeapYear =>
      year % 4 == 0
          ? year % 100 == 0
              ? year % 400 == 0
                  ? true
                  : false
              : true
          : false;

  ///
  ///
  ///
  /// [daysOfYear]
  /// [monthDays], [monthWeeks]
  /// [yearDays], [yearWeekNumber]
  ///
  ///
  ///

  ///
  /// [daysOfYear]
  ///
  int get daysOfYear =>
      DateTime.utc(year).difference(DateTime.utc(year, month, day)).inDays + 1;

  ///
  /// [monthDays]
  /// [monthWeeks]
  ///
  int get monthDays => switch (month) {
    1 => 31,
    2 => isLeapYear ? 29 : 28,
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
    _ => throw StateError('invalid month $month'),
  };

  int monthWeeks([int startingWeekday = DateTime.sunday]) =>
      (1 +
          firstDateOfMonth
              .firstDateOfWeek(startingWeekday)
              .difference(lastDateOfMonth.lastDateOfWeek(startingWeekday))
              .inDays) ~/
      7;

  ///
  /// [yearDays]
  /// [yearWeekNumber]
  ///
  int get yearDays => isLeapYear ? 365 : 366;

  int yearWeekNumber([int startingWeekday = DateTime.sunday]) {
    final startingDate = DateTime.utc(year);
    final days = normalized.difference(startingDate).inDays;
    final remains = days % DateTime.daysPerWeek;
    final weeks = days ~/ 7;
    if (remains == 0) return weeks;

    final previousDays = (startingDate.weekday - startingWeekday) % 7;
    if (remains + previousDays > DateTime.daysPerWeek) return weeks + 1;
    return weeks;
  }

  ///
  ///
  ///
  /// [toStringDate], [toStringTime]
  ///
  ///

  ///
  /// [toStringDate], $y-$m-$d
  /// [toStringTime], $h:$min:$sec.$ms$us
  ///
  String get toStringDate => toString().split(' ').first;

  String get toStringTime => toString().split(' ').last;

  ///
  ///
  /// [normalized], [clamp]
  /// [firstDateOfMonth], [firstDateOfWeek]
  /// [lastDateOfMonth], [lastDateOfWeek]
  ///
  ///

  ///
  /// [normalized], [clamp]
  ///
  DateTime get normalized => DateTime.utc(year, month, day);

  DateTime clamp(DateTime lowerLimit, DateTime upperLimit) {
    if (isBefore(lowerLimit)) return lowerLimit;
    if (isAfter(upperLimit)) return upperLimit;
    return this;
  }

  ///
  /// [firstDateOfMonth], [firstDateOfWeek]
  /// [lastDateOfMonth], [lastDateOfWeek]
  ///
  DateTime get firstDateOfMonth => DateTime.utc(year, month);

  // in dart, -1 % 7 = 6
  DateTime firstDateOfWeek([int startingDay = DateTime.sunday]) =>
      subtract(DurationExtension.day1 * ((weekday - startingDay) % 7));

  DateTime get lastDateOfMonth =>
      DateTime.utc(year, month + 1).subtract(DurationExtension.day1);

  DateTime lastDateOfWeek([int startingDay = DateTime.sunday]) =>
      add(DurationExtension.day1 * ((startingDay - 1 - weekday) % 7));
}

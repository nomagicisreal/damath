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
/// methods return int        --> [monthDaysOf], ...
/// methods return dateTime   --> [parseTimestamp], ...
///
/// instances:
/// methods return bool       --> [isLeapYear], ...
/// methods return int        --> [daysOfYear], ...
/// methods return string     --> [toStringDate], ...
/// methods return date time  --> [normalized], ...
/// methods return list dates --> [datesGenerateFrom], ...
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
  ///
  static const int limitMonthBegin = 0;
  static const int limitMonthEnd = 13;
  static const int limitHourBegin = -1;
  static const int limitHourEnd = 24;
  static const int hourBegin = 0;
  static const int hourEnd = 23;
  static const int daysAYearNormal = 365;

  ///
  /// [isYearLeapYear]
  ///
  /// [predicateLeapYear]
  /// [predicateSameYearN], [predicateSameMonthN], [predicateSameDayN], [predicateSameDateN], [predicateSameDate]
  /// [predicateBefore], [predicateAfter]
  /// [predicateIn], [predicateWithin]
  ///
  /// [anyInvalidWeekday]
  ///
  ///

  ///
  /// [isYearLeapYear]
  /// [isInvalidMonth]
  ///
  static bool isYearLeapYear(int year) =>
      year % 4 == 0
          ? year % 100 == 0
              ? year % 400 == 0
                  ? true
                  : false
              : true
          : false;

  static bool isInvalidMonth(int month) =>
      month < DateTime.january || month > DateTime.december;

  static bool isValidMonth(int month) =>
      month > limitMonthBegin && month < limitMonthEnd;

  static bool isValidHour(int hour) =>
      hour > limitHourBegin && hour < limitHourEnd;

  static bool isInvalidHour(int hour) => hour < hourBegin || hour > hourEnd;

  static bool isValidDays(int year, int month, int days) =>
      days > 0 && days < monthDaysOf(year, month) + 1;

  static bool Function(dynamic) isValidMonthDynamicOf(int year) =>
      (month) => month > limitMonthBegin && month < limitMonthEnd;

  static bool isValidMonthDynamic(dynamic month) =>
      month > limitMonthBegin && month < limitMonthEnd;

  static bool Function(dynamic) Function(int month) isValidDaysDynamicOf(
    int year,
  ) => (month) => (days) => days > 0 && days < monthDaysOf(year, month) + 1;

  ///
  /// [predicateLeapYear]
  /// [predicateSameYearN], ..., [predicateSameDateN]
  /// [predicateSameDate]
  ///
  static bool predicateLeapYear(DateTime date) => date.isLeapYear;

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
  /// [predicateFalse]
  /// [predicateToday], [predicateWeekend], [predicateWeekday]
  ///
  static bool predicateFalse(DateTime date) => false;

  static bool predicateToday(DateTime date) => date.isSameDate(DateTime.now());

  static bool predicateWeekday(DateTime date) {
    final day = date.weekday;
    return day == DateTime.monday ||
        day == DateTime.tuesday ||
        day == DateTime.wednesday ||
        day == DateTime.thursday ||
        day == DateTime.friday;
  }

  static bool predicateWeekend(DateTime date) {
    final day = date.weekday;
    return day == DateTime.sunday || day == DateTime.saturday;
  }

  ///
  /// [anyInvalidWeekday]
  ///
  static bool anyInvalidWeekday(Set<int> dates) =>
      dates.any((day) => day < DateTime.monday || day > DateTime.sunday);

  ///
  /// [_monthsDays]
  /// [monthDaysOf]
  /// [apply_monthBegin], [apply_monthEnd]
  ///
  static const Map<int, int> _monthsDays = {
    1: 31,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30,
    12: 31,
  };

  static int monthDaysOf(int year, int month) =>
      month == 2
          ? isYearLeapYear(year)
              ? 29
              : 28
          : _monthsDays[month]!;

  static int apply_monthBegin(int year) => DateTime.january;

  static int apply_monthEnd(int year) => DateTime.december;

  static Applier<int> applier_daysEnd(int year) =>
      (month) => monthDaysOf(year, month);

  static int reducer_hourBegin(int month, int day) => 1; // 00:00 ~ 01:00

  static int reducer_hourEnd(int month, int day) => 24; // 23:00 ~ 24:00

  ///
  ///
  /// [parseTimestamp], [clamping]
  /// [max], [min]
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
  /// [max], [min]
  ///
  static DateTime max(DateTime date1, DateTime date2) =>
      date1.isBefore(date2) ? date2 : date1;

  static DateTime min(DateTime date1, DateTime date2) =>
      date1.isBefore(date2) ? date1 : date2;

  ///
  /// [daysToDateClampFrom]
  ///
  static Generator<DateTime> daysToDateClampFrom(
    DateTime start,
    DateTime end, {
    bool fullWeek = true,
    int startingWeekday = DateTime.sunday,
    int times = 1,
  }) {
    if (fullWeek) {
      start = start.firstDateOfWeek(startingWeekday);
      end = end.firstDateOfWeek(startingWeekday);
    } else {
      throw UnimplementedError();
    }
    return (days) {
      final date = DateTime(start.year, start.month, start.day + days * times);
      return date.isAfter(end) ? end : date;
    };
  }

  ///
  /// [isLeapYear]
  /// [isSameDate], [isDifferentDate]
  /// [isSameTime], [isDifferentTime]
  ///
  bool get isLeapYear => isYearLeapYear(year);

  bool isSameDate(DateTime another) =>
      year == another.year && month == another.month && day == another.day;

  bool isDifferentDate(DateTime another) =>
      year != another.year || month != another.month || day != another.day;

  bool isSameTime(DateTime another) =>
      hour == another.hour &&
      minute == another.minute &&
      second == another.second;

  bool isDifferentTime(DateTime another) =>
      hour != another.hour ||
      minute != another.minute ||
      second != another.second;

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
      DateTime(year).difference(DateTime(year, month, day)).inDays + 1;

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
    final startingDate = DateTime(year);
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
  /// [dateOnly], [timeOnly]
  /// [plus]
  /// [addYears], [dateAddYears]
  /// [addMonths], [dateAddMonths]
  /// [addDays], [dateAddDays]
  ///

  ///
  /// [normalized], [clamp]
  ///
  DateTime get normalized => DateTime(year, month, day);

  DateTime clamp(DateTime lowerLimit, DateTime upperLimit) {
    if (isBefore(lowerLimit)) return lowerLimit;
    if (isAfter(upperLimit)) return upperLimit;
    return this;
  }

  ///
  /// [firstDateOfMonth], [firstDateOfWeek]
  /// [lastDateOfMonth], [lastDateOfWeek]
  ///
  DateTime get firstDateOfMonth => DateTime(year, month);

  // in dart, -1 % 7 = 6
  DateTime firstDateOfWeek([int startingDay = DateTime.sunday]) =>
      subtract(DurationExtension.day1 * ((weekday - startingDay) % 7));

  DateTime get lastDateOfMonth =>
      DateTime(year, month + 1).subtract(DurationExtension.day1);

  DateTime lastDateOfWeek([int startingDay = DateTime.sunday]) =>
      add(DurationExtension.day1 * ((startingDay - 1 - weekday) % 7));

  DateTime get dateOnly => DateTime(year, month, day);

  Duration get timeOnly =>
      Duration(hours: hour, minutes: minute, seconds: second);

  ///
  /// [plus]
  ///
  DateTime plus({
    int year = 0,
    int month = 0,
    int day = 0,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) => DateTime(
    this.year + year,
    this.month + month,
    this.day + day,
    this.hour + hour,
    this.minute + minute,
    this.second + second,
    this.millisecond + millisecond,
    this.microsecond + microsecond,
  );

  ///
  /// [addYears], [dateAddYears]
  ///
  DateTime addYears(
    int n, {
    bool keepMonth = true,
    bool keepDay = true,
    bool keepHour = false,
    bool keepMinute = false,
    bool keepSecond = false,
    bool keepMillisecond = false,
    bool keepMicrosecond = false,
  }) => DateTime(
    year + n,
    keepMonth ? month : 0,
    keepDay ? day : 0,
    keepHour ? hour : 0,
    keepMinute ? minute : 0,
    keepSecond ? second : 0,
    keepMillisecond ? millisecond : 0,
    keepMicrosecond ? microsecond : 0,
  );

  DateTime dateAddYears(int n) => DateTime(year + n, month, day);

  ///
  /// [addMonths], [dateAddMonths]
  ///
  DateTime addMonths(
    int n, {
    bool keepDay = true,
    bool keepHour = false,
    bool keepMinute = false,
    bool keepSecond = false,
    bool keepMillisecond = false,
    bool keepMicrosecond = false,
  }) => DateTime(
    year,
    month + n,
    keepDay ? day : 0,
    keepHour ? hour : 0,
    keepMinute ? minute : 0,
    keepSecond ? second : 0,
    keepMillisecond ? millisecond : 0,
    keepMicrosecond ? microsecond : 0,
  );

  DateTime dateAddMonths(int n) => DateTime(year, month + n, day);

  ///
  /// [addDays], [dateAddDays]
  ///
  DateTime dateAddDays(int n) => DateTime(year, month, day + n);

  DateTime addDays(
    int n, {
    bool keepHour = false,
    bool keepMinute = false,
    bool keepSecond = false,
    bool keepMillisecond = false,
    bool keepMicrosecond = false,
  }) => DateTime(
    year,
    month,
    day + n,
    keepHour ? hour : 0,
    keepMinute ? minute : 0,
    keepSecond ? second : 0,
    keepMillisecond ? millisecond : 0,
    keepMicrosecond ? microsecond : 0,
  );

  ///
  /// [datesGenerateFrom], [datesGenerate]
  /// [datesGenerateBegin], [datesGenerateBack]
  ///
  List<DateTime> datesGenerateFrom(int length, [int from = 0]) =>
      List.generate(length, (i) => DateTime(year, month, day + from + i));

  List<DateTime> datesGenerate(int length) =>
      List.generate(length, (i) => DateTime(year, month, day + i));

  List<DateTime> datesGenerateBegin(int length, [int begin = 0]) =>
      List.generate(length, (i) => DateTime(year, month, day + begin - i));

  List<DateTime> datesGenerateBack(int length) =>
      List.generate(length, (i) => DateTime(year, month, day - i));
}

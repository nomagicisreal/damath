///
///
/// this file contains:
///
///
///
///
part of damath_flutter;

///
///
///
extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay pm(int hour, int minute) {
    assert(hour.isRangeClose(0, 11));
    return TimeOfDay(hour: 12 + hour, minute: minute);
  }

  static TimeOfDay am(int hour, int minute) {
    assert(hour.isRangeClose(0, 11));
    return TimeOfDay(hour: hour, minute: minute);
  }
}

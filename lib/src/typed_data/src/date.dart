part of '../typed_data.dart';

///
///
/// [DatesContainer]
/// [_MapValueUint32List]
///
///

///
///
/// [comparator], [toString], [dates]
/// [include], [exclude], [contains], [reset]
///
///
class DatesContainer {
  final Map<(int, int), Uint32List> _bits;

  DatesContainer._(this._bits);

  factory DatesContainer.from(DateTime date) => DatesContainer._({
    (date.year, date.month): Uint32List(1)..[0] = 1 << date.day - 1,
  });

  factory DatesContainer.fromIterable(Iterable<DateTime> dates) =>
      DatesContainer._(
        dates.fold(
          <(int, int), Uint32List>{},
          (bits, date) => bits..setBit((date.year, date.month), date.day - 1),
        ),
      );

  ///
  /// see also [Comparable], [ComparableExtension], [ComparatorExtension]
  /// ```dart
  /// print((1, 1) == (1, 1)); // true
  /// print([1, 1] == [1, 1]); // false
  /// ```
  ///
  static int comparator(
    MapEntry<(int, int), Uint32List> a,
    MapEntry<(int, int), Uint32List> b,
  ) {
    final monthA = a.key;
    final montB = b.key;
    final cYear = monthA.$1.compareTo(montB.$1);
    if (cYear != 0) return cYear;
    return monthA.$2.compareTo(montB.$2);
  }

  @override
  String toString() {
    final buffer = StringBuffer('MonthDatesContainer(\n');
    for (var entry in _bits.entries.sorted(comparator)) {
      final key = entry.key;
      buffer.write('\t');
      final year = key.$1;
      final month = key.$2;
      buffer.write('(${year.toString().padLeft(4)}'); // year
      buffer.write(', ${month.toString().padLeft(2)})'); // month
      buffer.write(' : ');
      buffer.writeln(
        entry.value[0]
            .toRadixString(2)
            .padLeft(DateTimeExtension.monthDaysOf(year, month), '0')
            .reversed
            .insertEvery(8), // days
      );
    }
    buffer.writeln(')');
    return buffer.toString();
  }

  ///
  /// [dates]
  ///
  List<(int, int, int)> get dates {
    final result = <(int, int, int)>[];
    for (var entry in _bits.entries.sorted(comparator)) {
      final key = entry.key;
      final year = key.$1;
      final month = key.$2;
      entry.value.consumeBit1((i) => result.add((year, month, i)));
    }
    return result;
  }

  ///
  /// [datesOf], [datesWithinMonths]
  ///
  List<int> datesOf(int year, int month) {
    final result = <int>[];
    final dates = _bits[(year, month)];
    if (dates == null) return result;
    dates.consumeBit1(result.add);
    return result;
  }

  List<(int, int, int)> datesWithinMonths(int year, int begin, int end) {
    if (begin > end) {
      throw Erroring.invalidYearMonthsScope((year, begin), (year, end));
    }
    final result = <(int, int, int)>[];
    final bits = _bits;
    for (var m = begin; m <= end; m++) {
      final dates = bits[(begin, end)];
      if (dates == null) continue;
      dates.consumeBit1((i) => result.add((year, m, i)));
    }
    return result;
  }

  ///
  /// [datesWithin]
  ///
  List<(int, int, int)> datesWithin(
    (int, int) monthBegin,
    (int, int) monthEnd,
  ) {
    final yBegin = monthBegin.$1;
    final yEnd = monthEnd.$1;
    final mBegin = monthBegin.$2;
    final mEnd = monthEnd.$2;
    if (yBegin > yEnd) {
      throw Erroring.invalidYearMonthsScope(monthBegin, monthEnd);
    }

    final result = <(int, int, int)>[];
    final bits = _bits;

    //
    if (yEnd == yBegin) {
      for (var m = mBegin; m <= mEnd; m++) {
        final dates = bits[(yBegin, m)];
        if (dates == null) continue;
        dates.consumeBit1((i) => result.add((yBegin, m, i)));
      }
      return result;
    }

    // yEnd > yBegin
    for (var y = yBegin; y < yEnd; y++) {
      for (var m = mBegin; m <= DateTime.december; m++) {
        final dates = bits[(y, m)];
        if (dates == null) return result;
        dates.consumeBit1((i) => result.add((y, m, i)));
      }
    }
    for (var m = 1; m <= mEnd; m++) {
      for (var m = DateTime.january; m <= mEnd; m++) {
        final dates = bits[(yEnd, m)];
        if (dates == null) return result;
        dates.consumeBit1((i) => result.add((yEnd, m, i)));
      }
    }
    return result;
  }

  ///
  ///
  ///
  Uint32List include(DateTime date) =>
      _bits.setBit((date.year, date.month), date.day - 1);

  Uint32List? exclude(DateTime date) =>
      _bits.clearBit((date.year, date.month), date.day - 1);

  bool contains(DateTime date) {
    final list = _bits[(date.year, date.month)];
    if (list == null) return false;
    final shift = date.day - 1;
    var bits = list[0];
    for (var i = 0; i < shift; i++) {
      bits >>= 1;
      if (bits == 0) return false;
    }
    return bits & 1 == 1;
  }

  void reset() => _bits.clear();
}

///
///
///
extension _MapValueUint32List<T> on Map<T, Uint32List> {
  Uint32List setBit(T key, int position, {int volume = 1, int which = 0}) =>
      update(
        key,
        (list) => list..[which] |= 1 << position,
        ifAbsent: () => Uint32List(volume)..[which] |= 1 << position,
      );

  Uint32List? clearBit(T key, int position, {int which = 0}) {
    final list = this[key];
    if (list == null) return null;
    list[which] &= ~(1 << position);
    if (list[which] == 0) {
      remove(key);
      return null;
    }
    return list;
  }
}

extension _Unit32List on Uint32List {
  void consumeBit1(void Function(int p) consumePosition, [int which = 0]) {
    for (var i = 1, bits = this[which]; bits != 0; i++, bits >>= 1) {
      if (bits & 1 == 0) continue;
      consumePosition(i);
    }
  }
}

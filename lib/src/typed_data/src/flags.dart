part of '../typed_data.dart';

///
///
/// [BitFlags]
///   --[_BitFlags8]
///   --[_BitFlags16]
///   --[_BitFlags32]
///   --[_BitFlags64]
///
/// * [Weekday]
/// [_DateFlags]
///   --[_SplayDoubleIndexFlags]
///       --[DateFlags]           with [_HourFlags]
///       --[MonthHourFlags]------|
///   --[WeekHourFlags]-----------|
///
///
///

///
///
///
abstract class BitFlags {
  int get size => _n * _field.length;

  bool operator [](int index) =>
      _field[index >> _shift] >> index & _filled == 1;

  void operator []=(int index, bool value) =>
      value
          ? _field.bitSet(index & _filled, index >> _shift)
          : _field.bitClear(index & _filled, index >> _shift);

  factory BitFlags(int length, [bool native = false]) {
    if (length < _BitFlags8.limit) return _BitFlags8(length);
    if (length < _BitFlags16.limit) return _BitFlags16(length);
    if (length < _BitFlags32.limit) return _BitFlags32(length);
    return native ? _BitFlags64(length) : _BitFlags32(length);
  }

  ///
  ///
  ///
  TypedDataList<int> get _field;

  int get _n;

  int get _filled;

  int get _shift;

  const BitFlags._();
}

///
/// ```dart
/// (x + (n - 1)) ~/ n; // faster
/// (x / n).ceil();     // slower unless x is already double
/// ```
///
class _BitFlags8 extends BitFlags {
  static const int limit = 9;
  static const int filled = 7;
  static const int shift = 3;

  @override
  final Uint8List _field;

  _BitFlags8(int length)
    : _field = Uint8List((length + filled) >> shift),
      super._();

  @override
  int get _filled => filled;

  @override
  int get _n => TypedDataListInt.sizeUint8List;

  @override
  int get _shift => shift;
}

class _BitFlags16 extends BitFlags {
  static const int limit = 17;
  static const int filled = 15;
  static const int shift = 4;

  @override
  final Uint16List _field;

  _BitFlags16(int length)
    : _field = Uint16List((length + filled) >> shift),
      super._();

  @override
  int get _filled => filled;

  @override
  int get _n => TypedDataListInt.sizeUint16List;

  @override
  int get _shift => shift;
}

class _BitFlags32 extends BitFlags {
  static const int limit = 33;
  static const int filled = 31;
  static const int shift = 5;

  @override
  final Uint32List _field;

  _BitFlags32(int length)
    : _field = Uint32List((length + filled) >> shift),
      super._();

  @override
  int get _filled => filled;

  @override
  int get _n => TypedDataListInt.sizeUint32List;

  @override
  int get _shift => shift;
}

class _BitFlags64 extends BitFlags {
  // static const int limit = 65;
  static const int filled = 63;
  static const int shift = 6;

  @override
  final Uint64List _field;

  _BitFlags64(int length)
    : _field = Uint64List((length + filled) >> shift),
      super._();

  @override
  int get _filled => filled;

  @override
  int get _n => TypedDataListInt.sizeUint64List;

  @override
  int get _shift => shift;
}

///
///
///
abstract class _DateFlags<T extends TypedDataList<int>> {
  const _DateFlags();

  int get _length;

  int get _size;

  String _fieldToString(int key, int keyKey, T value);

  T _newValue(int value);

  void include(Object record);

  void exclude(Object record);

  void clear();

  bool contains(Object record);

  bool get isEmpty;

  bool get isNotEmpty;
}

///
///
///
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory Weekday.from(DateTime dateTime) => switch (dateTime.weekday) {
    DateTime.monday => monday,
    DateTime.tuesday => tuesday,
    DateTime.wednesday => wednesday,
    DateTime.thursday => thursday,
    DateTime.friday => friday,
    DateTime.saturday => saturday,
    DateTime.sunday => sunday,
    _ => throw ArgumentError('date time weekday: ${dateTime.weekday}'),
  };
}

///
///
///
abstract class _SplayDoubleIndexFlags<T extends TypedDataList<int>>
    extends _DateFlags<T> {
  final int Function(int key1, int key2)? compare;
  final int Function(int key1, int key2)? compareKeyKey;
  final bool Function(dynamic potentialKey)? isValidKey;
  final bool Function(dynamic potentialKey)? isValidKeyKey;
  final SplayTreeMap<int, SplayTreeMap<int, T>> _field;

  _SplayDoubleIndexFlags.empty([
    this.compare,
    this.isValidKey,
    this.compareKeyKey,
    this.isValidKeyKey,
  ]) : _field = SplayTreeMap(compare, isValidKey);

  @override
  String toString() {
    final buffer = StringBuffer('DateFlags(\n');
    for (var entry in _field.entries) {
      final key = entry.key;
      buffer.write('\t');
      buffer.write('$key, \n'.padLeft(4));
      for (var valueEntry in entry.value.entries) {
        final keyKey = valueEntry.key;
        buffer.write(keyKey.toString().padLeft(5));
        buffer.write(' : ');
        buffer.writeln(_fieldToString(key, keyKey, valueEntry.value));
      }
    }
    buffer.writeln(')');
    return buffer.toString();
  }

  SplayTreeMap<int, T> _newKeyKey(int day, int v) =>
      SplayTreeMap(compareKeyKey, isValidKeyKey)..[day] = _newValue(v);

  ///
  ///
  ///
  static StateError _errorEmptyFlagsNotRemoved(int key, int keyKey) =>
      StateError('empty flags key: ($key, $keyKey) should be removed');

  ///
  /// [_include], [exclude], [clear]
  ///
  void _include(covariant (int, int, int) record) {
    final valueMap = _field[record.$1];
    if (valueMap == null) {
      _field[record.$1] = _newKeyKey(record.$2, record.$3);
      return;
    }
    final bitsList = valueMap[record.$2];
    if (bitsList == null) {
      valueMap[record.$2] = _newValue(record.$3);
      return;
    }
    bitsList.bitSet(record.$3, _size);
  }

  @override
  void exclude(covariant (int, int, int) record) {
    final months = _field[record.$1];
    if (months == null) return;
    final days = months[record.$2];
    if (days == null) return;

    days.bitClear(record.$3, _size);
    final length = _length;
    for (var j = 0; j < length; j++) {
      if (days[j] != 0) return;
    }
    months.remove(record.$2);
    if (months.isNotEmpty) return;
    _field.remove(record.$2);
  }

  @override
  void clear() => _field.clear();

  @override
  bool get isEmpty => _field.isEmpty;

  @override
  bool get isNotEmpty => _field.isNotEmpty;

  @override
  bool contains(covariant (int, int, int) date) {
    final months = _field[date.$1];
    if (months == null) return false;
    final days = months[date.$2];
    if (days == null) return false;
    return days[0] >> date.$3 - 1 == 1;
  }

  ///
  /// [_findKey], [_findKeyKey], [_findFlag]
  ///
  int? _findKey(_MapperSplayTreeMapInt toKey) => toKey(_field);

  (int, int)? _findKeyKey(_MapperSplayTreeMapInt toKey) {
    final key = toKey(_field);
    if (key == null) return null;
    return (key, toKey(_field[key]!)!);
  }

  (int, int, int)? _findFlag(
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt<T> toBits,
  ) {
    final key = toKey(_field);
    if (key == null) return null;
    final valueMap = _field[key]!;
    final keyKey = toKey(valueMap)!;
    final length = _length;
    final size = _size;
    for (var i = 0, values = valueMap[keyKey]!; i < length; i++) {
      final value = toBits(values, size);
      if (value != null) return (key, keyKey, value);
    }
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  ///
  /// [_findEntryInKey], [_findEntryAfter]
  ///
  (int, int, int)? _findEntryInKey(
    int key,
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt<T> toPosition,
  ) {
    final valueMap = _field[key];
    if (valueMap == null) return null;
    final keyKey = toKey(valueMap)!;
    final values = valueMap[keyKey]!;
    final length = _length;
    final size = _size;
    for (var i = 0; i < length; i++) {
      final value = toPosition(values, size);
      if (value != null) return (key, keyKey, value);
    }
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  (int, int, int)? _findEntryAfter(
    (int, int, int) record,
    _MapperSplayTreeMapInt toKey,
    _MapperSplayTreeMapIntBy toKeyBy,
    PredicatorReducer<int> predicate,
    _BitsListToInt<T> toPosition,
    _BitsListToIntFrom<T> toPositionFrom,
  ) {
    final field = _field;
    var key = toKey(field);
    if (key == null) return null;

    // recent key > a || latest key < a
    final a = record.$1;
    if (predicate(key, a)) return _findEntryInKey(key, toKey, toPosition);

    // recent keyKey > b || latest keyKey < b
    if (key == a) {
      final b = record.$2;
      final valueMap = field[a]!;
      int? keyKey = toKey(valueMap)!;
      if (predicate(keyKey, b)) {
        return (a, keyKey, toPosition(valueMap[keyKey]!, _size)!);
      }

      // recent value > c || latest value < c
      if (keyKey == b) {
        final c = record.$3;
        final value = toPositionFrom(valueMap[b]!, c, _size);
        if (value != null) return (a, b, value);
      }

      // next keyKey > b || previous keyKey < b
      keyKey = toKeyBy(valueMap, b);
      if (keyKey != null) {
        return (a, keyKey, toPosition(valueMap[keyKey]!, _size)!);
      }
    }

    // next key > a || previous keyKey < a
    key = toKeyBy(field, a);
    if (key != null) return _findEntryInKey(key, toKey, toPosition);

    return null;
  }

  ///
  ///
  /// [_keysAvailable], [_keyKeysAvailable], [_valuesAvailable]
  /// [_entries], [_entriesWithinMonths], [_entriesWithin]
  ///
  ///
  ///

  ///
  /// [_keysAvailable], [_keyKeysAvailable], [_valuesAvailable]
  ///
  Iterable<int> get _keysAvailable => _field.keys;

  Iterable<int> _keyKeysAvailable(int key) {
    final dates = _field[key];
    return dates == null ? [] : dates.keys;
  }

  Iterable<int> _valuesAvailable(int key, int keyKey) sync* {
    final mList = _field[key];
    if (mList == null) return;
    final dList = mList[keyKey];
    if (dList == null) return;
    final length = _length;
    final size = _size;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = dList[j];
      for (var i = 1; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  ///
  /// [_entries], [_entriesWithinMonths], [_entriesWithin]
  ///
  Iterable<(int, int, int)> get _entries sync* {
    for (var yEntry in _field.entries) {
      final y = yEntry.key;
      for (var mEntry in yEntry.value.entries) {
        final m = mEntry.key;
        for (var d = 1, bits = mEntry.value[0]; bits > 0; d++, bits >>>= 1) {
          if (bits & 1 == 1) yield (y, m, d);
        }
      }
    }
  }

  Iterable<(int, int, int)> _entriesWithinMonths(
    int key,
    int begin,
    int end,
  ) sync* {
    final months = _field[key];
    if (months == null) return;
    for (var m = begin; m <= end; m++) {
      final dates = months[m];
      if (dates == null) continue;
      for (var d = 1, bits = dates[0]; bits > 0; d++, bits >>>= 1) {
        if (bits & 1 == 1) yield (key, m, d);
      }
    }
  }

  Iterable<(int, int, int)> _entriesWithin(
    (int, int) begin,
    (int, int) end,
  ) sync* {
    final yBegin = begin.$1;
    final yEnd = end.$1;
    assert(yBegin > yEnd);

    final mBegin = begin.$2;
    final mEnd = end.$2;

    // yEnd == yBegin
    if (yEnd == yBegin) {
      yield* _entriesWithinMonths(yEnd, mBegin, mEnd);
      return;
    }

    // yEnd > yBegin
    yield* _entriesWithinMonths(yBegin, mBegin, DateTime.december);
    for (var y = yBegin + 1; y < yEnd; y++) {
      yield* _entriesWithinMonths(y, DateTime.january, DateTime.december);
    }
    yield* _entriesWithinMonths(yEnd, DateTime.january, mEnd);
  }
}

///
///
/// [DateFlags.empty]
/// [_which], ...
/// [include], ...
/// [_keysAvailable], ...
/// [_entries], ...
///
///
class DateFlags extends _SplayDoubleIndexFlags<Uint32List> {
  @override
  int get _length => 1;

  @override
  int get _size => TypedDataListInt.sizeUint32List;

  @override
  String _fieldToString(int year, int month, Uint32List value) => value[0]
      .toRadixString(2)
      .padLeft(DateTimeExtension.monthDaysOf(year, month), '0')
      .reversed
      .insertEvery(8);

  @override
  Uint32List _newValue(int day) => Uint32List(_length)..[0] = 1 << day - 1;

  @override
  void include(covariant (int, int, int) date) => _include(date);

  ///
  ///
  ///
  DateFlags.empty()
    : super.empty(null, null, null, DateTimeExtension.isValidMonthDynamic);

  factory DateFlags.from((int, int, int) date) {
    final flags = DateFlags.empty();
    flags._field[date.$1] = flags._newKeyKey(date.$2, date.$3);
    return flags;
  }

  factory DateFlags.fromIterable(Iterable<(int, int, int)> iterable) => iterable
      .iterator
      .inductInited(DateFlags.from, (flags, date) => flags..include(date));

  ///
  ///
  /// [firstYear], [firstMonth], [lastYear], [lastMonth]
  /// [firstDate], [lastDate]
  /// [firstDateInYear], [firstDateAfter]
  /// [lastDateInYear], [lastDateBefore]
  ///
  ///
  int? get firstYear => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstMonth => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  int? get lastYear => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastMonth => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get firstDate =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedDataListInt.getBitFirst1);

  (int, int, int)? get lastDate =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedDataListInt.getBitLast1);

  (int, int, int)? firstDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toFirstKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? firstDateAfter((int, int, int) date) => _findEntryAfter(
    date,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitFirst1,
    TypedDataListInt.getBitFirst1From,
  );

  (int, int, int)? lastDateInYear(int year) => _findEntryInKey(
    year,
    SplayTreeMapKeyInt.toLastKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? lastDateBefore((int, int, int) date) => _findEntryAfter(
    date,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_less,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitLast1From,
  );

  ///
  /// [yearsAvailable], [monthsAvailable], [daysAvailable]
  /// [dates], [datesWithinMonths], [datesWithin]
  ///
  Iterable<int> get yearsAvailable => _keysAvailable;

  Iterable<int> monthsAvailable(int year) => _keyKeysAvailable(year);

  Iterable<int> daysAvailable(int year, int month) =>
      _valuesAvailable(year, month);

  Iterable<(int, int, int)> get dates => _entries;

  Iterable<(int, int, int)> datesWithinMonths(int year, int begin, int end) =>
      _entriesWithinMonths(year, begin, end);

  Iterable<(int, int, int)> datesWithin((int, int) begin, (int, int) end) =>
      _entriesWithin(begin, end);
}

///
///
///
mixin _HourFlags on _DateFlags<Uint8List> {
  @override
  int get _length => 3;

  @override
  int get _size => TypedDataListInt.sizeUint8List;

  @override
  String _fieldToString(int month, int day, Uint8List hour) => hour.iterator
      .join(' ', (byte) => byte.toRadixString(2).padLeft(_size, '0'));

  @override
  Uint8List _newValue(int hour) =>
      Uint8List(hour ~/ _size)..[0] = 1 << hour & _BitFlags8.filled;
}

///
///
///
class MonthHourFlags extends _SplayDoubleIndexFlags<Uint8List> with _HourFlags {
  @override
  void include(covariant (int, int, int) hour) => _include(hour);

  MonthHourFlags.empty()
    : super.empty(
        null,
        DateTimeExtension.isValidMonthDynamic,
        null,
        DateTimeExtension.isValidHourDynamic,
      );

  ///
  /// [include]
  /// [firstMonth], [firstDate], [firstHour]
  /// [lastMonth], [lastDate], [lastHour]
  /// [firstDayInMonth], [firstHourAfter]
  /// [lastDayInMonth], [lastHourBefore]
  ///
  int? get firstMonth => _findKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int)? get firstDate => _findKeyKey(SplayTreeMapKeyInt.toFirstKey);

  (int, int, int)? get firstHour =>
      _findFlag(SplayTreeMapKeyInt.toFirstKey, TypedDataListInt.getBitFirst1);

  int? get lastMonth => _findKey(SplayTreeMapKeyInt.toLastKey);

  (int, int)? get lastDate => _findKeyKey(SplayTreeMapKeyInt.toLastKey);

  (int, int, int)? get lastHour =>
      _findFlag(SplayTreeMapKeyInt.toLastKey, TypedDataListInt.getBitLast1);

  (int, int, int)? firstDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toFirstKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? firstHourAfter((int, int, int) hour) => _findEntryAfter(
    hour,
    SplayTreeMapKeyInt.toFirstKey,
    SplayTreeMapKeyInt.toFirstKeyAfter,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitFirst1,
    TypedDataListInt.getBitFirst1From,
  );

  (int, int, int)? lastDayInMonth(int month) => _findEntryInKey(
    month,
    SplayTreeMapKeyInt.toLastKey,
    TypedDataListInt.getBitLast1,
  );

  (int, int, int)? lastHourBefore((int, int, int) hour) => _findEntryAfter(
    hour,
    SplayTreeMapKeyInt.toLastKey,
    SplayTreeMapKeyInt.toLastKeyBefore,
    IntExtension.predicateReduce_larger,
    TypedDataListInt.getBitLast1,
    TypedDataListInt.getBitFirst1From,
  );

  ///
  /// [monthsAvailable], [daysAvailable], [hoursAvailable]
  /// [hours], [hoursWithinMonths], [hoursWithin]
  ///
  Iterable<int> get monthsAvailable => _keysAvailable;

  Iterable<int> daysAvailable(int month) => _keyKeysAvailable(month);

  Iterable<int> hoursAvailable(int month, int day) =>
      _valuesAvailable(month, day);

  Iterable<(int, int, int)> get hours => _entries;

  Iterable<(int, int, int)> hoursWithinMonths(int month, int begin, int end) =>
      _entriesWithinMonths(month, begin, end);

  Iterable<(int, int, int)> hoursWithin((int, int) begin, (int, int) end) =>
      _entriesWithin(begin, end);
}

///
///
///
class WeekHourFlags extends _DateFlags<Uint8List> with _HourFlags {
  final Map<Weekday, Uint8List> _field;

  WeekHourFlags.empty() : _field = {};

  @override
  bool get isEmpty => _field.isEmpty;

  @override
  bool get isNotEmpty => _field.isNotEmpty;

  @override
  bool contains(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) return false;
    final hour = record.$2;
    return hours.bitOn(hour ~/ _size, hour & _BitFlags8.filled);
  }

  @override
  void exclude(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) return;
    final hour = record.$2;
    hours.bitClear(hour ~/ _size, hour & _BitFlags8.filled);
    for (var j = 0; j < _length; j++) {
      if (hours[j] != 0) return;
    }
    _field.remove(record.$1);
  }

  @override
  void include(covariant (Weekday, int) record) {
    final hours = _field[record.$1];
    if (hours == null) {
      _field[record.$1] = _newValue(record.$2);
      return;
    }
    final hour = record.$2;
    hours.bitSet(hour ~/ _size, hour & _BitFlags8.filled);
  }

  @override
  void clear() => _field.clear();
}
//
// class DaysHourFlags {
//   final List<Uint8List> _field;
//
//   const DaysHourFlags(this._field);
// }

///
///
/// timetable for traffic, time sensitive work
///
///
// class DayMinute30Flags {
//   final Uint16List _field; // * 3
//
//   const DayMinute30Flags(this._field);
// }
//
// class DayMinute10Flags {
//   final Uint16List _field; // * 9
//
//   const DayMinute10Flags(this._field);
// }

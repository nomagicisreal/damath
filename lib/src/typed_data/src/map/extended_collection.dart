part of '../../typed_data.dart';

///
///
///
/// [_SplayTreeMapValueList]
///   **[_MixinSplayDate]
///   --[Dated]
///   --[DateTimed]
///
///
///


///
///
/// [_SplayTreeMapValueList.empty], ...
/// [insert], ...
///
///
abstract class _SplayTreeMapValueList<K, V> {
  late final SplayTreeMap<K, List<V>> _field;
  final int Function(K key1, K key2)? _compare;
  final bool Function(dynamic potentialKey)? _isValidKey;

  _SplayTreeMapValueList.empty([this._compare, this._isValidKey])
    : _field = SplayTreeMap(_compare, _isValidKey);

  ///
  /// [insert], [insertAll]
  /// [takeOut], [takeOutAll]
  /// [clear]
  ///
  void insert(K date, V item) {
    final dated = _field[date];
    if (dated == null) {
      _field[date] = [item];
      return;
    }
    dated.add(item);
  }

  void insertAll(K date, List<V> items) {
    final dated = _field[date];
    if (dated == null) {
      _field[date] = items;
      return;
    }
    dated.addAll(items);
  }

  ///
  /// return `true`  if date has removed all events on date, date is removed from [_field] keys
  /// return `false` if date still has events
  ///
  bool takeOut(K date, V item) {
    final dated = _field[date];
    if (dated == null) return false;
    dated.remove(item);
    if (dated.isEmpty) {
      _field.remove(date);
      return false;
    }
    return true;
  }

  bool takeOutAll(K date, List<V> items) {
    final dated = _field[date];
    if (dated == null) return true;
    for (var event in items) {
      dated.remove(event);
    }
    if (dated.isEmpty) {
      _field.remove(date);
      return true;
    }
    return false;
  }

  void clear() => _field.clear();
}

///
/// [_filtered]
///
mixin _MixinSplayDate<K, V> on _SplayTreeMapValueList<K, V> {
  SplayTreeMap<K, List<V>> _filtered(
    FlagsMapDate flags, {
    required int Function(K date) toYear,
    required int Function(K date) toMonth,
    required int Function(K date) toDay,
  }) {
    final result = SplayTreeMap<K, List<V>>(_compare, _isValidKey);
    final flagsField = flags._map.field;
    final bitOn = flags._bitOn;

    int? invalidYear;
    int? invalidMonth;
    for (var entry in _field.entries) {
      final date = entry.key;

      final year = toYear(date);
      if (year == invalidYear) continue;
      final months = flagsField[year];
      if (months == null) {
        invalidYear = year;
        invalidMonth = null;
        continue;
      }

      final month = toMonth(date);
      if (month == invalidMonth) continue;
      final days = months[month];
      if (days == null) {
        invalidMonth = month;
        continue;
      }

      if (!bitOn(toDay(date), days)) continue;

      result[date] = entry.value;
    }
    return result;
  }
}

///
///
/// [Dated.empty], ...
/// [_filtered], ...
///
///
class Dated<T> extends _SplayTreeMapValueList<(int, int, int), T>
    with _MixinSplayDate {
  Dated.empty() : super.empty(Record3Int.comparing);

  factory Dated.on((int, int, int) date, List<T> events) =>
      Dated.empty().._field[date] = events;

  factory Dated.onDates(
    List<(int, int, int)> dates,
    Mapper<(int, int, int), List<T>> toEvents,
  ) => dates.fold(
    Dated.empty(),
    (dated, date) => dated..insertAll(date, toEvents(date)),
  );

  factory Dated.onEvents(List<T> events, Mapper<T, (int, int, int)> toDate) =>
      events.fold(
        Dated.empty(),
        (dated, event) => dated..insert(toDate(event), event),
      );

  ///
  /// [filteredBy]
  ///
  SplayTreeMap<(int, int, int), List<T>> filteredBy(FlagsMapDate flags) =>
      _filtered(
        flags,
        toYear: (date) => date.$1,
        toMonth: (date) => date.$2,
        toDay: (date) => date.$3,
      );
}

///
/// [DateTimed.empty], ...
/// [filteredByDate], ...
///
class DateTimed<T> extends _SplayTreeMapValueList<DateTime, T>
    with _MixinSplayDate {
  DateTimed.empty() : super.empty();

  factory DateTimed.on(DateTime dateTime, List<T> events) =>
      DateTimed.empty().._field[dateTime] = events;

  factory DateTimed.onDates(
    List<DateTime> dates,
    Mapper<DateTime, List<T>> toEvents,
  ) => dates.fold(
    DateTimed.empty(),
    (dated, date) => dated..insertAll(date, toEvents(date)),
  );

  factory DateTimed.onEvents(List<T> events, Mapper<T, DateTime> toDate) =>
      events.fold(
        DateTimed.empty(),
        (dated, event) => dated..insert(toDate(event), event),
      );

  ///
  /// [filteredByDate]
  ///
  SplayTreeMap<DateTime, List<T>> filteredByDate(FlagsMapDate flags) =>
      _filtered(
        flags,
        toYear: (date) => date.year,
        toMonth: (date) => date.month,
        toDay: (date) => date.day,
      );
}

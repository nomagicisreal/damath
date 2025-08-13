part of '../typed_data.dart';

///
///
///
/// [_SplayTreeMapIntIntInt]
///
/// [_SplayTreeMapValueList]   *[_MixinSplayDate]
///   --[Dated]
///   --[DateTimed]
///
///
///
///

///
///
///
extension _SplayTreeMapIntIntTypedInt<T extends TypedDataList<int>>
    on SplayTreeMap<int, SplayTreeMap<int, T>> {
  ///
  /// [_valuesAvailable]
  ///
  Iterable<int> _valuesAvailable(int sizeEach, int key, int keyKey) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapBitsAvailable(sizeEach, FKeep.applier);
  }

  ///
  /// [_records], [_recordsInKey], [_recordsInKeyKey]
  /// [_recordsWithinKeyKey]
  /// [_recordsWithin]
  /// [_recordsWithinValues]
  ///
  ///

  ///
  /// [_records]
  /// [_recordsInKey]
  /// [_recordsInKeyKey]
  ///
  Iterable<(int, int, int)> _records(int sizeEach) sync* {
    for (var eA in entries) {
      final key = eA.key;
      for (var eB in eA.value.entries) {
        final keyKey = eB.key;
        yield* eB.value.mapBitsAvailable(sizeEach, (v) => (key, keyKey, v));
      }
    }
  }

  Iterable<(int, int, int)> _recordsInKey(int sizeEach, int key) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    for (var entry in valueMap.entries) {
      final keyKey = entry.key;
      yield* entry.value.mapBitsAvailable(sizeEach, (v) => (key, keyKey, v));
    }
  }

  Iterable<(int, int, int)> _recordsInKeyKey(
    int sizeEach,
    int key,
    int keyKey,
  ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapBitsAvailable(sizeEach, (v) => (key, keyKey, v));
  }

  ///
  /// [_recordsWithinValues]
  /// [_recordsWithinKeyKey]
  /// [_recordsWithin]
  ///
  Iterable<(int, int, int)> _recordsWithinValues(
    int sizeEach,
    int key,
    int keyKey,
    int? begin,
    int? end,
  ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.mapBitsAvailableBetween(
      sizeEach,
      begin,
      end,
      (v) => (key, keyKey, v),
    );
  }

  Iterable<(int, int, int)> _recordsWithinKeyKey(
    int sizeEach,
    int key,
    int begin,
    int end,
  ) sync* {
    final valueMap = this[key];
    if (valueMap == null) return;
    for (
      int? keyKey = begin;
      keyKey != null && keyKey <= end;
      keyKey = valueMap.firstKeyAfter(keyKey)
    ) {
      final values = valueMap[keyKey]!;
      yield* values.mapBitsAvailable(sizeEach, (v) => (key, keyKey!, v));
    }
  }

  Iterable<(int, int, int)> _recordsWithinKey(
    int sizeEach,
    int begin,
    int end,
  ) sync* {
    for (
      int? key = begin;
      key != null && key <= end;
      key = firstKeyAfter(key)
    ) {
      final valueMap = this[key]!;
      for (var entry in valueMap.entries) {
        final keyKey = entry.key;
        yield* entry.value.mapBitsAvailable(sizeEach, (v) => (key!, keyKey, v));
      }
    }
  }

  Iterable<(int, int, int)> _recordsWithin(
    int sizeEach,
    (int, int, int) begin,
    (int, int, int) end,
  ) sync* {
    final keyBegin = begin.$1;
    final keyEnd = end.$1;
    assert(keyBegin <= keyEnd);

    final keyKeyBegin = begin.$2;
    final keyKeyEnd = end.$2;
    final valueBegin = begin.$3;
    final valueEnd = end.$3;

    // ==
    if (keyEnd == keyBegin) {
      assert(keyKeyBegin <= keyKeyEnd);

      // ==
      if (keyKeyBegin == keyKeyEnd) {
        assert(valueBegin <= valueEnd);
        yield* _recordsWithinValues(
          sizeEach,
          keyBegin,
          keyKeyBegin,
          valueBegin,
          valueEnd,
        );
        return;
      }

      // <
      final valueMap = this[keyBegin];
      if (valueMap == null) return;

      // keyKey begin
      var values = valueMap[keyKeyBegin];
      if (values != null) {
        yield* values.mapBitsAvailableFrom(
          sizeEach,
          valueBegin,
          (v) => (keyBegin, keyKeyBegin, v),
        );
      }

      // keyKeys between
      for (
        var keyKey = valueMap.firstKeyAfter(keyKeyBegin);
        keyKey != null && keyKey < keyKeyEnd;
        keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapBitsAvailable(
          sizeEach,
          (v) => (keyBegin, keyKey!, v),
        );
      }

      // keyKey end
      values = valueMap[keyKeyEnd];
      if (values != null) {
        yield* values.mapBitsAvailableTo(
          sizeEach,
          valueEnd,
          (v) => (keyBegin, keyKeyEnd, v),
        );
      }
      return;
    }

    // <
    // key begin
    var valueMap = this[keyBegin];
    if (valueMap != null) {
      final values = valueMap[keyKeyBegin];
      if (values != null) {
        yield* values.mapBitsAvailableFrom(
          sizeEach,
          valueBegin,
          (v) => (keyBegin, keyKeyBegin, v),
        );
      }
      for (
        var keyKey = valueMap.firstKeyAfter(keyKeyBegin);
        keyKey != null;
        keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapBitsAvailable(
          sizeEach,
          (v) => (keyBegin, keyKey!, v),
        );
      }
    }

    // keys between
    for (
      var key = firstKeyAfter(keyBegin);
      key != null && key < keyEnd;
      key = firstKeyAfter(key)
    ) {
      valueMap = this[key]!;
      for (
        var keyKey = valueMap.firstKey();
        keyKey != null;
        keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapBitsAvailable(
          sizeEach,
          (v) => (key!, keyKey!, v),
        );
      }
    }

    // key end
    valueMap = this[keyEnd];
    if (valueMap != null) {
      for (
        var keyKey = valueMap.firstKey();
        keyKey != null && keyKey < keyKeyEnd;
        keyKey = valueMap.firstKeyAfter(keyKey)
      ) {
        yield* valueMap[keyKey]!.mapBitsAvailable(
          sizeEach,
          (v) => (keyEnd, keyKey!, v),
        );
      }
      final values = valueMap[keyKeyEnd];
      if (values == null) return;
      yield* values.mapBitsAvailableTo(
        sizeEach,
        valueEnd,
        (v) => (keyEnd, keyKeyEnd, v),
      );
    }
  }
}

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
    final bitOn = flags._mutateBitOn;

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
  Dated.empty() : super.empty(DateExtension.comparing);

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

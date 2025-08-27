part of '../typed_data.dart';

///
///
///
/// [_MSetField]
/// [_MSetFieldIndexable]
/// [_MSetFieldMonthsDatesScoped]
/// [_MSetFieldBits]
/// [_MSetFieldBitsMonthsDates]
/// [_MSetSlot]
///
///
///

///
///
///
mixin _MSetField implements _AField, _AFieldIdentical, _AFlagsSet<int> {
  @override
  int? get first => _field.pFirst(_sizeEach);

  @override
  int? get last => _field.pLast(_sizeEach);
}

mixin _MSetFieldIndexable<T>
    implements _AField, _AFieldIdentical, _AFlagsSet<T> {
  @override
  T? get first => _field.pFirst(_sizeEach).nullOrMap(_indexOf);

  @override
  T? get last => _field.pLast(_sizeEach).nullOrMap(_indexOf);

  T _indexOf(int position);
}

mixin _MSetFieldMonthsDatesScoped
    implements _AFlagsSet<(int, int, int)>, _AFlagsScoped<(int, int)>, _AField {
  ///
  /// [_indexOfMonth], [_firstIndexedMonthOf], [_lastIndexedMonthOf]
  ///
  int _indexOfMonth(int year, int month) {
    final begin = this.begin;
    assert(year >= begin.$1 && year <= end.$1);
    return month - begin.$2 + (year - begin.$1) * 12;
  }

  (int, int)? _firstIndexedMonthOf(int year) {
    final begin = this.begin;
    if (year == begin.$1) return (begin.$2, 0);
    final i = _indexOfMonth(year, 1);
    assert(year > begin.$1 && i > -1);
    return i < _field.length ? (1, i) : null;
  }

  (int, int)? _lastIndexedMonthOf(int year) {
    final end = this.end;
    if (year == end.$1) return (end.$2, _field.length - 1);
    final i = _indexOfMonth(year, 12);
    assert(year < end.$1 && i < _field.length);
    return i > -1 ? (12, i) : null;
  }

  ///
  /// [firstInMonth]
  /// [lastInMonth]
  ///
  int? firstInMonth(int year, int month) {
    assert(DateTimeExtension.isValidMonth(month));
    final field = _field, i = _indexOfMonth(year, month);
    return i < 0 || i >= field.length ? null : field.bFirstOf(i);
  }

  int? lastInMonth(int year, int month) {
    assert(DateTimeExtension.isValidMonth(month));
    final field = _field, i = _indexOfMonth(year, month);
    return i < 0 || i >= field.length
        ? null
        : field.bLastOf(i, DateTimeExtension.monthDaysOf(year, month));
  }

  ///
  /// [first]
  /// [firstInYear]
  /// [firstAfter]
  ///
  @override
  (int, int, int)? get first {
    final begin = this.begin, field = _field, length = field.length;
    for (var y = begin.$1, m = begin.$2, i = 0; i < length; i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (y, m, d);
      m++;
      if (m > 12) {
        m = 1;
        y++;
      }
    }
    return null;
  }

  (int, int, int)? firstInYear(int year) {
    final mi = _firstIndexedMonthOf(year);
    if (mi == null) return null;
    final field = _field,
        end = this.end,
        mLimit = year == end.$1 ? end.$2 + 1 : 13;
    for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (year, m, d);
    }
    return null;
  }

  (int, int, int)? firstAfter((int, int, int) date) {
    assert(date.isValidDate);
    final yDate = date.$1, mDate = date.$2, field = _field;
    var i = _indexOfMonth(yDate, mDate);
    if (i < 0 || i >= field.length) return null;

    final begin = this.begin, length = field.length;
    var y = begin.$1, m = begin.$2;
    bool nextMonth() {
      i++;
      if (i >= length) return false;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
      return true;
    }

    final dDate = date.$3;
    int? d;
    if (dDate == DateTimeExtension.monthDaysOf(yDate, mDate)) {
      if (!nextMonth()) return null;
      d = field.bFirstOf(i);
    } else {
      d = field.bFirstOf(i, dDate + 1);
    }
    if (d != null) return (y, m, d);
    if (!nextMonth()) return null;
    do {
      d = field.bFirstOf(i);
      if (d != null) return (y, m, d);
    } while (nextMonth());
    return null;
  }

  ///
  /// [last]
  /// [lastInYear]
  /// [lastBefore]
  ///
  @override
  (int, int, int)? get last {
    final end = this.end,
        field = _field,
        daysOf = DateTimeExtension.monthDaysOf;
    for (var y = end.$1, m = end.$2, i = field.length - 1; i > -1; i--) {
      final d = field.bLastOf(i, daysOf(y, m));
      if (d != null) return (y, m, d);
      m--;
      if (m < 1) {
        y--;
        m = 12;
      }
    }
    return null;
  }

  (int, int, int)? lastInYear(int year) {
    final mi = _lastIndexedMonthOf(year);
    if (mi == null) return null;
    final field = _field,
        mLimit = year == begin.$1 ? begin.$2 - 1 : 0,
        daysOf = DateTimeExtension.monthDaysOf;
    for (var m = mi.$1, i = mi.$2; m > mLimit; m--, i++) {
      final d = field.bLastOf(i, daysOf(year, m));
      if (d != null) return (year, m, d);
    }
    return null;
  }

  (int, int, int)? lastBefore((int, int, int) date) {
    assert(date.isValidDate);
    final yDate = date.$1, mDate = date.$2, field = _field;
    var i = _indexOfMonth(yDate, mDate);
    if (i < 0 || i >= field.length) return null;

    final end = this.end;
    var y = end.$1, m = end.$2;
    bool nextMonth() {
      i--;
      if (i < 0) return false;
      m--;
      if (m < 0) {
        y--;
        m = 12;
      }
      return true;
    }

    final daysOf = DateTimeExtension.monthDaysOf, dDate = date.$3;
    int? d;
    if (dDate == 1) {
      if (!nextMonth()) return null;
      d = field.bLastOf(i, daysOf(yDate, mDate));
    } else {
      d = field.bLastOf(i, dDate - 1);
    }
    if (d != null) return (y, m, d);
    if (!nextMonth()) return null;
    do {
      d = field.bLastOf(i, daysOf(y, m));
      if (d != null) return (y, m, d);
    } while (nextMonth());
    return null;
  }

  ///
  /// [availableYears]
  /// [availableMonths]
  /// [availableDates]
  ///
  Iterable<int> get availableYears sync* {
    final begin = this.begin, field = _field, max = field.length - 1;
    var y = begin.$1, m = begin.$2, i = 0;

    while (true) {
      if (field.bFirstOf(i) != null) {
        yield y;
        i += 13 - m;
        if (i > max) return;
        y++;
        m = 1;
        continue;
      }
      i++;
      if (i > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  Iterable<(int, int)> availableMonths([int? year]) sync* {
    final begin = this.begin, end = this.end, field = _field;

    // months in year
    if (year != null) {
      final mi = _firstIndexedMonthOf(year);
      if (mi == null) return;
      final mLimit = year == end.$1 ? end.$2 + 1 : 13;
      for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
        if (field.bFirstOf(i) != null) yield (year, m);
      }
      return;
    }

    // all months
    var y = begin.$1, m = begin.$2, i = 0;
    final max = field.length - 1;
    while (true) {
      if (field.bFirstOf(i) != null) yield (y, m);
      i++;
      if (i > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  Iterable<(int, int, int)> availableDates([int? year, int? month]) sync* {
    final begin = this.begin, end = this.end, field = _field;

    if (year != null) {
      // dates in a year month
      if (month != null) {
        assert(DateTimeExtension.isValidMonth(month));
        final i = _indexOfMonth(year, month);
        if (i >= field.length) return;
        yield* field.bsMappedOf(i, (d) => (year, month, d));
        return;
      }

      // dates in a year
      final mi = _firstIndexedMonthOf(year);
      if (mi == null) return;
      final mLimit = year == end.$1 ? end.$2 + 1 : 13;
      for (var m = mi.$1, i = mi.$2; m < mLimit; m++, i++) {
        yield* field.bsMappedOf(i, (d) => (year, m, d));
      }
      return;
    }

    // dates in same month
    if (month != null) {
      assert(DateTimeExtension.isValidMonth(month));
      final yBegin = begin.$1, yEnd = end.$1;
      if (yBegin == yEnd) {
        assert(month >= begin.$2 && month <= end.$2);
        yield* field.bsMappedOf(month - begin.$2, (d) => (yBegin, month, d));
        return;
      }
      var y = yBegin, i = month - begin.$2;
      if (i < 0) {
        y++;
        i += 12;
      }
      for (final length = field.length; i < length; y++, i += 12) {
        yield* field.bsMappedOf(i, (d) => (y, month, d));
      }
      return;
    }

    // all dates
    var y = begin.$1, m = begin.$2, i = 0;
    final max = field.length - 1;
    while (true) {
      yield* field.bsMappedOf(i, (d) => (y, m, d));
      i++;
      if (i > max) return;
      m++;
      if (m > 12) {
        y++;
        m = 1;
      }
    }
  }

  ///
  ///
  ///
  Iterable<(int, int, int)> availableDatesFrom(
    int yearFrom, [
    int? monthFrom,
    int? dayFrom,
    bool inclusive = true,
  ]) sync* {
    // todo:
    if (monthFrom != null) {
      assert(dayFrom == null);
      return;
    }

    if (dayFrom == null) {
      return;
    }
  }

  Iterable<(int, int, int)> availableDatesTo(
    int yearTo, [
    int? monthTo,
    int? dayTo,
    bool inclusive = true,
  ]) sync* {
    // todo:
    if (monthTo != null) {
      assert(dayTo == null);
      return;
    }

    if (dayTo == null) {
      return;
    }
  }

  Iterable<(int, int, int)> availableDatesSub(
    int yearFrom,
    int yearTo,
    int monthFrom,
    int monthTo,
    int dayFrom,
    int dayTo, [
    bool includeFrom = true,
    bool includeTo = false,
  ]) sync* {
    // todo:
  }
}

///
///
///
mixin _MSetFieldBits<T> on _MBitsField implements _AFieldSet<T> {
  @override
  void includesSub(T begin, [T? limit]) => _ranges(_bitSet, begin, limit);

  @override
  void excludesSub(T begin, [T? limit]) => _ranges(_bitClear, begin, limit);

  void _ranges(Consumer<int> consume, T begin, T? limit);
}

mixin _MSetFieldBitsMonthsDates on _MBitsFieldMonthsDates
    implements _AFieldSet<(int, int, int)> {
  @override
  void includesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_bitSet, begin, limit);

  @override
  void excludesSub((int, int, int) begin, [(int, int, int)? limit]) =>
      _sub(_bitClear, begin, limit);

  void _sub(
    TriCallback<int> consume,
    (int, int, int) begin,
    (int, int, int)? limit,
  );
}

///
///
///
mixin _MSetSlot<I, T>
    implements _ASlot<T>, _ASlotSet<I, T>, _AFlagsPositionAble<I> {
  @override
  T? get first {
    final slot = _slot;
    final length = slot.length;
    for (var i = 0; i < length; i++) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  T? get last {
    final slot = _slot;
    final length = slot.length;
    for (var i = length - 1; i > -1; i--) {
      final s = slot[i];
      if (s != null) return s;
    }
    return null;
  }

  @override
  Iterable<T> filterOn(FieldParent field) sync* {
    final slot = _slot;
    final length = slot.length;
    final f = field._field;
    final sizeEach = field._sizeEach;
    final count = f.length;
    assert(length == sizeEach * count);
    for (var j = 0; j < count; j++) {
      final start = j * sizeEach;
      for (var i = 0, bits = f[j]; i < sizeEach; i++, bits >>= 1) {
        if (bits & 1 == 1) {
          final value = slot[start + i];
          if (value != null) yield value;
        }
      }
    }
  }

  @override
  void pasteSub(T value, I begin, [I? limit]) {
    final slot = _slot;
    final length = limit == null ? slot.length : _positionOf(limit);
    for (var i = _positionOf(begin); i < length; i++) {
      slot[i] = value;
    }
  }

  @override
  void includesFrom(Iterable<T> iterable, I begin, [bool inclusive = true]) {
    final slot = _slot;
    var i = inclusive ? _positionOf(begin) : _positionOf(begin) + 1;
    assert(i > -1 && i < slot.length);
    for (var it in iterable) {
      slot[i] = it;
      i++;
    }
  }

  @override
  void includesTo(Iterable<T> iterable, I limit, [bool inclusive = true]) {
    final slot = _slot;
    var last = inclusive ? _positionOf(limit) + 1 : _positionOf(limit);
    assert(last < slot.length);
    var i = last - iterable.length;
    assert(i > -1);
    for (var it in iterable) {
      slot[i] = it;
      i++;
    }
  }
}

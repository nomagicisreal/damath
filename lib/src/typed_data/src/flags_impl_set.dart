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
  /// [first]
  /// [firstInYear]
  ///
  @override
  (int, int, int)? get first {
    final begin = this.begin;
    var y = begin.$1;
    var m = begin.$2;
    final field = _field;
    final length = field.length;
    for (var i = 0; i < length; i++) {
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
    final begin = this.begin;
    final yBegin = begin.$1;
    assert(year >= yBegin && year <= end.$1);
    final field = _field;
    final mBegin = begin.$2;

    // ==
    if (year == yBegin) {
      for (var m = mBegin; m < 13; m++) {
        final d = field.bFirstOf(m - mBegin);
        if (d != null) return (year, m, d);
      }
      return null;
    }

    // >
    var i = 13 - mBegin + (year - yBegin - 1) * 12;
    var mLimit = 13;
    final max = field.length - 1;
    if (i + 11 > max) {
      if (i > max) return null;
      mLimit = end.$2 + 1;
    }
    for (var m = 1; m < mLimit; m++, i++) {
      final d = field.bFirstOf(i);
      if (d != null) return (year, m, d);
    }
    return null;
  }

  ///
  /// [last]
  /// [lastInYear]
  ///
  @override
  (int, int, int)? get last {
    final end = this.end;
    var y = end.$1;
    var m = end.$2;
    final field = _field;
    for (var i = field.length - 1; i > -1; i++) {
      final d = field.bLastOf(i, 31);
      if (d != null) return (y, m, d);
      m--;
      if (m < 1) {
        m = 12;
        y--;
      }
    }
    return null;
  }

  (int, int, int)? lastInYear(int year) {
    final begin = this.begin;
    final yBegin = begin.$1;
    assert(year >= yBegin && year <= end.$1);
    final field = _field;
    final mBegin = begin.$2;

    // ==
    if (year == yBegin) {
      final end = this.end;
      for (var m = year == end.$1 ? end.$2 : 12; m >= mBegin; m--) {
        final d = field.bLastOf(m - mBegin, 31);
        if (d != null) return (year, m, d);
      }
      return null;
    }

    // >
    var m = 12;
    var i = 12 - mBegin + (year - yBegin) * 12;
    final max = field.length - 1;
    if (i > max) {
      if (i - 11 > max) return null;
      m = end.$2;
      i = max;
    }
    for (; m > 0; m--, i++) {
      final d = field.bLastOf(i, 31);
      if (d != null) return (year, m, d);
    }
    return null;
  }

  ///
  /// [availableYears]
  /// [availableMonths]
  /// [availableDates]
  ///
  Iterable<int> get availableYears sync* {
    final begin = this.begin;
    final field = _field;
    final max = field.length - 1;
    var y = begin.$1;
    var m = begin.$2;
    var i = 0;

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
    final field = _field;
    final begin = this.begin;

    // months in year
    if (year != null) {
      final yBegin = begin.$1;
      final end = this.end;
      assert(year >= yBegin && year <= end.$1);

      late int i;
      late int m;
      if (year == yBegin) {
        i = 0;
        m = begin.$2;
      } else {
        i = 1 - begin.$2 + (year - yBegin) * 12;
        m = 1;
      }
      for (final l = 1 + (year == end.$1 ? end.$2 : 12); m < l; m++, i++) {
        if (field.bFirstOf(i) != null) yield (year, m);
      }
      return;
    }

    // all months
    var y = begin.$1;
    var m = begin.$2;
    var i = 0;
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
    final field = _field;
    final begin = this.begin;
    final end = this.end;

    if (year != null) {
      final yBegin = begin.$1;
      final mBegin = begin.$2;
      assert(year >= yBegin && year <= this.end.$1);
      final december = (year - yBegin) * 12 - mBegin;

      // dates in a year month
      if (month != null) {
        final i = december + month;
        if (i > field.length - 1) return;
        yield* field.bsMappedOf(i, (d) => (year, month, d));
        return;
      }

      // dates in a year
      late int i;
      late int m;
      if (december < 0) {
        i = 0;
        m = mBegin;
      } else {
        i = december + 1;
        m = 1;
      }
      for (final l = 1 + year == end.$1 ? end.$2 : 12; m < l; m++, i++) {
        yield* field.bsMappedOf(i, (d) => (year, m, d));
      }
      return;
    }

    // dates in same month
    if (month != null) {
      final yBegin = begin.$1;
      final mBegin = begin.$2;
      final yEnd = end.$1;
      final mEnd = end.$2;
      if (yBegin == yEnd) {
        assert(month >= mBegin && month <= mEnd);
        yield* field.bsMappedOf(month - mBegin, (d) => (yBegin, month, d));
        return;
      }
      var i = month - mBegin;
      var y = yBegin;
      if (i < 0) {
        y++;
        i += 12;
      }
      final length = field.length;
      for (; i < length; y++, i += 12) {
        yield* field.bsMappedOf(i, (d) => (y, month, d));
      }
      return;
    }

    // all dates
    var y = begin.$1;
    var m = begin.$2;
    var i = 0;
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

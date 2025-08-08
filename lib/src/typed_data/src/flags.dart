part of '../typed_data.dart';

///
///
/// [_BitFlagsParent]
///   --[BitFlags]
///   |   --[_BitFlags8]
///   |   --[_BitFlags16]
///   |   --[_BitFlags32]
///   |   --[_BitFlags64]
///   |
///   --[_DateFlags]
///       --[_DateFlagsSplayDoubleIndex]
///       |   --[DateFlags]           with [_DateFlagsHour]
///       |   --[MonthHourFlags]------|
///       --[WeekHourFlags]-----------| * [Weekday]
///
///

///
///
///
abstract class _BitFlagsParent {
  int get _sizeEach;

  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;

  bool _bitOn<T extends TypedDataList<int>>(T list, int position) =>
      list.bitOn(position, _shift, _mask);

  void _bitSet<T extends TypedDataList<int>>(T list, int position) =>
      list.bitSet(position, _shift, _mask);

  void _bitClear<T extends TypedDataList<int>>(T list, int position) =>
      list.bitClear(position, _shift, _mask);

  const _BitFlagsParent();
}

///
///
///
abstract class BitFlags extends _BitFlagsParent {
  final int size;

  int get sizeActual => _sizeEach * _field.length;

  factory BitFlags(int size, [bool native = false]) {
    if (size < _BitFlags8.limit) return _BitFlags8(size);
    if (size < _BitFlags16.limit) return _BitFlags16(size);
    if (size < _BitFlags32.limit) return _BitFlags32(size);
    if (size & _BitFlags32.mask == 0) return _BitFlags32(size);
    if (size & _BitFlags16.mask == 0) return _BitFlags16(size);
    if (size & _BitFlags8.mask == 0) return _BitFlags8(size);
    return native ? _BitFlags64(size) : _BitFlags32(size);
  }

  bool operator [](int position) => _bitOn(_field, position);

  void operator []=(int position, bool value) =>
      value ? _bitSet(_field, position) : _bitClear(_field, position);

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType field:\n');
    final size = this.size;
    final sizeEach = _sizeEach;
    final field = _field;
    final length = field.length;
    final space = (sizeEach * length).toString().length + 1;

    // -----...
    final borderLength = space * 2 + sizeEach + sizeEach ~/ _bytes + 5;
    buffer.writeRepeat(borderLength, '-');

    // 0 ~ n, ....
    for (var j = 0; j < length; j++) {
      final start = j * sizeEach;
      buffer.write('|');
      buffer.write('${start + 1}'.padLeft(space));
      buffer.write(' ~');
      buffer.write('${math.min(start + sizeEach, size)}'.padLeft(space));
      buffer.write(': ');
      var i = 0;
      for (var bits = field[j]; bits > 0; bits >>= 1) {
        buffer.write(bits & 1 == 1 ? '1' : '0');
        i++;
        if (i % 8 == 0) buffer.write(' ');
      }
      while (i < sizeEach && start + i < size) {
        buffer.write('0');
        i++;
        if (i % 8 == 0) buffer.write(' ');
      }
      buffer.writeln();
    }

    // ---...
    buffer.writeRepeat(borderLength, '-');
    buffer.writeln();
    return buffer.toString();
  }

  ///
  ///
  ///
  TypedDataList<int> get _field;

  const BitFlags._(this.size);

  static const int _bytes = 8;
}

///
/// ```dart
/// (x + (n - 1)) ~/ n; // faster
/// (x / n).ceil();     // slower unless x is already double
/// ```
///
class _BitFlags8 extends BitFlags {
  static const int limit = 9;
  static const int mask = 7;
  static const int shift = 3;
  static const int sizeEach = Uint8List.bytesPerElement * BitFlags._bytes;

  @override
  int get _mask => mask;

  @override
  int get _sizeEach => sizeEach;

  @override
  int get _shift => shift;

  @override
  final Uint8List _field;

  _BitFlags8(super.length)
    : _field = Uint8List((length + mask) >> shift),
      super._();
}

class _BitFlags16 extends BitFlags {
  static const int limit = 17;
  static const int mask = 15;
  static const int shift = 4;
  static const int sizeEach = Uint16List.bytesPerElement * BitFlags._bytes;

  @override
  final Uint16List _field;

  _BitFlags16(super.length)
    : _field = Uint16List((length + mask) >> shift),
      super._();

  @override
  int get _mask => mask;

  @override
  int get _sizeEach => sizeEach;

  @override
  int get _shift => shift;
}

class _BitFlags32 extends BitFlags {
  static const int limit = 33;
  static const int mask = 31;
  static const int shift = 5;
  static const int sizeEach = Uint32List.bytesPerElement * BitFlags._bytes;

  @override
  final Uint32List _field;

  _BitFlags32(super.length)
    : _field = Uint32List((length + mask) >> shift),
      super._();

  @override
  int get _mask => mask;

  @override
  int get _sizeEach => sizeEach;

  @override
  int get _shift => shift;
}

class _BitFlags64 extends BitFlags {
  // static const int limit = 65;
  static const int filled = 63;
  static const int shift = 6;
  static const int sizeEach = Uint64List.bytesPerElement * BitFlags._bytes;

  @override
  final Uint64List _field;

  _BitFlags64(super.length)
    : _field = Uint64List((length + filled) >> shift),
      super._();

  @override
  int get _mask => filled;

  @override
  int get _sizeEach => sizeEach;

  @override
  int get _shift => shift;
}

///
///
/// [_DateFlags]
/// [_DateFlagsSplayDoubleIndex]
/// [_DateFlagsHour]
///
///

///
///
///
abstract class _DateFlags<T extends TypedDataList<int>>
    extends _BitFlagsParent {
  const _DateFlags();

  T _newValue(int value) =>
      _newList..[value >> _shift] = 1 << (value & _mask) - 1;

  T get _newList;

  void include(Object record);

  void exclude(Object record);

  void clear();

  bool contains(Object record);

  bool get isEmpty;

  bool get isNotEmpty;

  ///
  ///
  ///
  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType field:\n');
    final size = _sizeEach;
    final borderLength =
        8 + _toStringFieldPadLeft + size + size ~/ _BitFlags8.sizeEach;
    buffer.writeRepeat(borderLength, '-');
    _toStringApplyBody(buffer);
    buffer.writeRepeat(borderLength, '-');
    return buffer.toString();
  }

  int get _toStringFieldPadLeft;

  void _toStringApplyBody(StringBuffer buffer);
}

///
///
/// [_bufferApplyField], ...
/// [_errorEmptyFlagsNotRemoved], ...
/// [include], ...
/// [_findKey], ...
///
///
abstract class _DateFlagsSplayDoubleIndex<T extends TypedDataList<int>>
    extends _DateFlags<T> {
  ///
  ///
  ///
  void _bufferApplyField(StringBuffer buffer, int key, int keyKey, T value);

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final pad = _toStringFieldPadLeft;
    for (var entry in _field.entries) {
      final key = entry.key;
      buffer.write('|');
      buffer.write('($key'.padLeft(pad));
      buffer.write(',');
      var padding = false;
      for (var valueEntry in entry.value.entries) {
        if (padding) {
          buffer.write('|');
          buffer.writeRepeat(pad + 1, ' ', false);
        } else {
          padding = true;
        }
        final keyKey = valueEntry.key;
        buffer.write('$keyKey'.padLeft(3));
        buffer.write('): ');
        _bufferApplyField(buffer, key, keyKey, valueEntry.value);
        buffer.writeln();
      }
    }
  }

  ///
  ///
  ///
  final SplayTreeMap<int, SplayTreeMap<int, T>> _field;
  final int Function(int key1, int key2)? compareKeyKey;
  final bool Function(dynamic potentialKey)? isValidKeyKey;
  final Applier<int> toKeyKeyBegin;
  final Applier<int> toKeyKeyEnd;
  final Reducer<int> toValueBegin;
  final Reducer<int> toValueEnd;

  _DateFlagsSplayDoubleIndex.empty({
    bool Function(dynamic potentialKey)? isValidKey,
    this.compareKeyKey,
    this.isValidKeyKey,
    required this.toKeyKeyBegin,
    required this.toKeyKeyEnd,
    required this.toValueBegin,
    required this.toValueEnd,
  }) : _field = SplayTreeMap(Comparable.compare, isValidKey);

  SplayTreeMap<int, T> _newKeyKey(int keyKey, int v) =>
      SplayTreeMap(compareKeyKey, isValidKeyKey)..[keyKey] = _newValue(v);

  ///
  /// [_errorEmptyFlagsNotRemoved]
  /// [_excluding]
  ///
  static StateError _errorEmptyFlagsNotRemoved(int key, int keyKey) =>
      StateError('empty flags key: ($key, $keyKey) should be removed');

  static bool _excluding<T extends TypedDataList<int>>(T list) {
    final length = list.length;
    for (var j = 0; j < length; j++) {
      if (list[j] != 0) return false;
    }
    return true;
  }

  ///
  /// [include], [exclude], [clear]
  ///
  @override
  void include(covariant (int, int, int) record) => _field.record(
    record,
    newKeyKey: _newKeyKey,
    newValue: _newValue,
    setValue: _bitSet,
  );

  @override
  void exclude(covariant (int, int, int) record) => _field.removeRecord(
    record,
    clearValue: _bitClear,
    ensureRemove: _excluding,
  );

  @override
  void clear() => _field.clear();

  ///
  /// [_includeValues], [_includeKeyKeys], [_includeKeys]
  /// [includeRange]
  ///
  void _includeValues(int key, int keyKey, int begin, int end) =>
      _field.recordInts(
        key,
        keyKey,
        begin,
        end,
        newKeyKey: _newKeyKey,
        newValue: _newValue,
        setValue: _bitSet,
      );

  void _includeKeyKeys(int key, int begin, int end) => _field.recordIntsKeyKeys(
    key,
    begin,
    end,
    toValueBegin,
    toValueEnd,
    newKeyKey: _newKeyKey,
    newValue: _newValue,
    setValue: _bitSet,
  );

  void _includeKeys(int begin, int end) => _field.recordIntsKey(
    begin,
    end,
    toKeyKeyBegin,
    toKeyKeyEnd,
    toValueBegin,
    toValueEnd,
    newKeyKey: _newKeyKey,
    newValue: _newValue,
    setValue: _bitSet,
  );

  void includeRange((int, int, int) begin, (int, int, int) end) {
    final keyBegin = begin.$1;
    final keyEnd = end.$1;

    // ==
    if (keyBegin == keyEnd) {
      final keyKeyBegin = begin.$2;
      final keyKeyEnd = end.$2;
      assert(keyKeyBegin <= keyKeyEnd);

      // ==
      if (keyKeyBegin == keyKeyEnd) {
        _includeValues(keyBegin, keyKeyBegin, begin.$3, end.$3);
        return;
      }

      // <
      final toValueBegin = this.toValueBegin;
      final toValueEnd = this.toValueEnd;
      _includeValues(
        keyBegin,
        keyKeyBegin,
        begin.$3,
        toValueEnd(keyBegin, keyKeyBegin),
      );
      for (var j = keyKeyBegin + 1; j < keyKeyEnd; j++) {
        _includeValues(
          keyBegin,
          j,
          toValueBegin(keyBegin, j),
          toValueEnd(keyBegin, j),
        );
      }
      _includeValues(
        keyBegin,
        keyKeyEnd,
        toValueBegin(keyBegin, keyKeyEnd),
        end.$3,
      );
      return;
    }

    // <
    final toKeyKeyEnd = this.toKeyKeyEnd;
    final toValueEnd = this.toValueEnd;
    final keyKeyBegin = begin.$2;
    _includeValues(
      keyBegin,
      keyKeyBegin,
      begin.$3,
      toValueEnd(keyBegin, keyKeyBegin),
    );
    _includeKeyKeys(keyBegin, keyKeyBegin + 1, toKeyKeyEnd(keyBegin));
    _includeKeys(keyBegin + 1, keyEnd - 1);
    final keyKenEnd = end.$2;
    _includeKeyKeys(keyEnd, toKeyKeyBegin(keyEnd), keyKenEnd - 1);
    _includeValues(
      keyEnd,
      toKeyKeyEnd(keyEnd),
      toValueEnd(keyEnd, keyKenEnd),
      end.$3,
    );
  }

  ///
  ///
  ///
  // void _excludeRange(
  //   (int, int, int) begin,
  //   (int, int, int) end,
  //   Applier<int> toKeyKeyBegin,
  //   Applier<int> toKeyKeyEnd,
  //   Applier<int> toValueBegin,
  //   Applier<int> toValueEnd,
  // );

  ///
  /// [isEmpty], [isNotEmpty], [contains]
  ///
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
  ///
  /// [_keysAvailable], [_keyKeysAvailable], [_valuesAvailable]
  /// [_entries], [_entriesWithinKeyKeyInKey], [_entriesWithinKeyKey]
  /// [_findKey], [_findKeyKey], [_findFlag]
  /// [_findEntryInKey], [_findEntryAfter]
  ///
  ///

  ///
  /// [_keysAvailable]
  /// [_keyKeysAvailable]
  /// [_valuesAvailable]
  ///
  Iterable<int> get _keysAvailable => _field.keys;

  Iterable<int> _keyKeysAvailable(int key) {
    final dates = _field[key];
    return dates == null ? [] : dates.keys;
  }

  Iterable<int> _valuesAvailable(int key, int keyKey) sync* {
    final valueMap = _field[key];
    if (valueMap == null) return;
    final values = valueMap[keyKey];
    if (values == null) return;
    yield* values.bitsAvailable(_sizeEach);
  }

  ///
  /// [_entries]
  /// [_entriesWithinValues]
  /// [_entriesWithinKeyKeyInKey]
  /// [_entriesWithinKeyKey]
  /// [_entriesWithin]
  ///
  Iterable<(int, int, int)> get _entries sync* {
    for (var kEntry in _field.entries) {
      final k = kEntry.key;
      for (var kkEntry in kEntry.value.entries) {
        final kk = kkEntry.key;
        for (var v = 1, bits = kkEntry.value[0]; bits > 0; v++, bits >>= 1) {
          if (bits & 1 == 1) yield (k, kk, v);
        }
      }
    }
  }

  // Iterable<(int, int, int)> _entriesWithinValues(
  //   int key,
  //   int keyKey,
  //   int begin,
  //   int end,
  // ) sync* {
  //   final valueMap = _field[key];
  //   if (valueMap == null) return;
  //   final size = _sizeEach;
  //   final values = valueMap[keyKey]!;
  //   yield* values.bitsAvailableMap(size, (v) => (key, keyKey, v));
  // }

  Iterable<(int, int, int)> _entriesWithinKeyKeyInKey(
    int key,
    int begin,
    int end,
  ) sync* {
    final valueMap = _field[key];
    if (valueMap == null) return;
    final size = _sizeEach;
    for (
      int? keyKey = begin;
      keyKey != null && keyKey <= end;
      keyKey = valueMap.firstKeyAfter(keyKey)
    ) {
      final values = valueMap[keyKey]!;
      yield* values.bitsAvailableMap(size, (v) => (key, keyKey!, v));
    }
  }

  Iterable<(int, int, int)> _entriesWithinKeyKey(
    (int, int) begin,
    (int, int) end,
  ) sync* {
    final keyBegin = begin.$1;
    final keyEnd = end.$1;
    assert(keyBegin <= keyEnd);

    final keyKeyBegin = begin.$2;
    final keyKeyEnd = end.$2;

    // ==
    if (keyEnd == keyBegin) {
      yield* _entriesWithinKeyKeyInKey(keyEnd, keyKeyBegin, keyKeyEnd);
      return;
    }

    // <
    final toKeyKeyEnd = this.toKeyKeyEnd;
    final toKeyKeyBegin = this.toKeyKeyBegin;
    yield* _entriesWithinKeyKeyInKey(
      keyBegin,
      keyKeyBegin,
      toKeyKeyEnd(keyBegin),
    );
    final field = _field;
    for (
      int? key = field.firstKeyAfter(keyBegin);
      key != null && key < keyEnd;
      key = field.firstKeyAfter(key)
    ) {
      yield* _entriesWithinKeyKeyInKey(
        key,
        toKeyKeyBegin(key),
        toKeyKeyEnd(key),
      );
    }
    yield* _entriesWithinKeyKeyInKey(keyEnd, toKeyKeyBegin(keyEnd), keyKeyEnd);
  }

  // Iterable<(int, int, int)> _entriesWithin(
  //   (int, int, int) begin,
  //   (int, int, int) end,
  // ) sync* {
  //   final keyBegin = begin.$1;
  //   final keyEnd = end.$1;
  //   assert(keyBegin <= keyEnd);
  //
  //   final keyKeyBegin = begin.$2;
  //   final keyKeyEnd = end.$2;
  //
  //   // ==
  //   if (keyEnd == keyBegin) {
  //     yield* _entriesWithinKeyKeyInKey(keyEnd, keyKeyBegin, keyKeyEnd);
  //     return;
  //   }
  //
  //   // <
  //   final toKeyKeyEnd = this.toKeyKeyEnd;
  //   final toKeyKeyBegin = this.toKeyKeyBegin;
  //   yield* _entriesWithinKeyKeyInKey(
  //     keyBegin,
  //     keyKeyBegin,
  //     toKeyKeyEnd(keyBegin),
  //   );
  //   final field = _field;
  //   for (
  //     int? key = field.firstKeyAfter(keyBegin);
  //     key != null && key < keyEnd;
  //     key = field.firstKeyAfter(key)
  //   ) {
  //     yield* _entriesWithinKeyKeyInKey(
  //       key,
  //       toKeyKeyBegin(key),
  //       toKeyKeyEnd(key),
  //     );
  //   }
  //   yield* _entriesWithinKeyKeyInKey(keyEnd, toKeyKeyBegin(keyEnd), keyKeyEnd);
  // }

  ///
  /// [_findKey]
  /// [_findKeyKey]
  /// [_findFlag]
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
    final field = _field;
    final key = toKey(field);
    if (key == null) return null;
    final valueMap = field[key]!;
    final keyKey = toKey(valueMap)!;
    final value = toBits(valueMap[keyKey]!, _sizeEach);
    if (value != null) return (key, keyKey, value);
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  ///
  /// [_findEntryInKey]
  /// [_findEntryAfter]
  ///
  (int, int, int)? _findEntryInKey(
    int key,
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt<T> toPosition,
  ) {
    final valueMap = _field[key];
    if (valueMap == null) return null;
    final keyKey = toKey(valueMap)!;
    final value = toPosition(valueMap[keyKey]!, _sizeEach);
    if (value != null) return (key, keyKey, value);
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
        return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
      }

      // recent value > c || latest value < c
      if (keyKey == b) {
        final c = record.$3;
        final value = toPositionFrom(valueMap[b]!, c, _sizeEach);
        if (value != null) return (a, b, value);
      }

      // next keyKey > b || previous keyKey < b
      keyKey = toKeyBy(valueMap, b);
      if (keyKey != null) {
        return (a, keyKey, toPosition(valueMap[keyKey]!, _sizeEach)!);
      }
    }

    // next key > a || previous keyKey < a
    key = toKeyBy(field, a);
    if (key != null) return _findEntryInKey(key, toKey, toPosition);

    return null;
  }
}

///
///
///
mixin _DateFlagsHour on _DateFlags<Uint8List> {
  @override
  Uint8List get _newList => Uint8List(howManyList8);

  @override
  int get _sizeEach => _BitFlags8.sizeEach * howManyList8;

  @override
  int get _shift => _BitFlags8.shift;

  @override
  int get _mask => _BitFlags8.mask;

  ///
  ///
  ///
  static const int howManyList8 = 3;

  static void _bufferApplyHours(StringBuffer buffer, Uint8List hours) {
    final length = _DateFlagsHour.howManyList8;
    for (var j = 0; j < length; j++) {
      var i = 0;
      var bits = hours[j];
      while (i < _BitFlags8.sizeEach) {
        buffer.writeBit(bits);
        bits >>= 1;
        i++;
      }
      buffer.write(' ');
    }
  }
}

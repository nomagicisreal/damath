part of '../typed_data.dart';

///
///
/// [_FlagsParent]
///   --[_FlagsField]
///   --[_FlagsOperator]
///   |   --[_MixinFlagsOperatableOf8], [_MixinFlagsOperatableOf16], [_MixinFlagsOperatableOf32], [_MixinFlagsOperatableOf64]
///   |   --[_MixinFlagsPositionAble], [_MixinFlagsMutable]
///   |   --[_MixinFlagsInsertable]
///   |       --[_MixinFlagsInsertableHoursADay]
///   |
///   --[_FlagsParentSource]
///   |   --[Flags] with [_MixinFlagsPositionAble]
///   |   |   --[_FlagsBits8], [_FlagsBits16]
///   |   |   --[_FlagsBits32], [_FlagsBits64]
///   |   |
///   |   --[FlagsRangingDates]
///   |   |
///   --[_FlagsContainer]
///   |
///   --[_FlagsSplayIndexIndex] with [_MixinFlagsInsertable]
///   |   --[FlagsDateMap]
///   |   --[FlagsHourMonthMap] with [_MixinFlagsInsertableHoursADay]
///   |                          |
///   --[FlagsHourWeekdayMap]----|
///   --[FlagsADay]
///   |
///   --[_FlagsParentFieldContainer]
///
///
///
///

///
///
///
abstract class _FlagsParent {
  const _FlagsParent();

  void clear();

  int get _sizeEach;

  int get _toStringFieldBorderLength;

  void _toStringApplyBody(StringBuffer buffer);

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType field:\n');
    final borderLength = _toStringFieldBorderLength;
    buffer.writeRepeat(borderLength, '-');
    buffer.writeln();
    _toStringApplyBody(buffer);
    buffer.writeRepeat(borderLength, '-');
    buffer.writeln();
    return buffer.toString();
  }
}

abstract class _FlagsOperator implements _FlagsParent {
  const _FlagsOperator();

  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;
}

abstract class _FlagsField implements _FlagsParent {
  const _FlagsField();

  TypedDataList<int> get _field;
}

abstract class _FlagsContainer implements _FlagsParent {
  const _FlagsContainer();

  bool contains(dynamic record);

  void include(dynamic record);

  void exclude(dynamic record);
}

///
///
///
/// [_MixinFlagsMutable]
/// [_MixinFlagsOperatableOf8], [_MixinFlagsOperatableOf16]
/// [_MixinFlagsOperatableOf32], [_MixinFlagsOperatableOf64]
///
/// [_MixinFlagsInsertable]
/// [_MixinFlagsInsertableHoursADay]
///
///
///
mixin _MixinFlagsOperatableOf8 implements _FlagsOperator {
  @override
  int get _shift => _FlagsBits8.shift;

  @override
  int get _mask => _FlagsBits8.mask;

  @override
  int get _sizeEach => _FlagsBits8.sizeEach;
}

mixin _MixinFlagsOperatableOf16 implements _FlagsOperator {
  @override
  int get _shift => _FlagsBits16.shift;

  @override
  int get _mask => _FlagsBits16.mask;

  @override
  int get _sizeEach => _FlagsBits16.sizeEach;
}

mixin _MixinFlagsOperatableOf32 implements _FlagsOperator {
  @override
  int get _shift => _FlagsBits32.shift;

  @override
  int get _mask => _FlagsBits32.mask;

  @override
  int get _sizeEach => _FlagsBits32.sizeEach;
}

mixin _MixinFlagsOperatableOf64 implements _FlagsOperator {
  @override
  int get _shift => _FlagsBits64.shift;

  @override
  int get _mask => _FlagsBits64.mask;

  @override
  int get _sizeEach => _FlagsBits64.sizeEach;
}

///
///
///
mixin _MixinFlagsMutable implements _FlagsOperator {
  bool _mutateBitOn(int position, TypedDataList<int> list) =>
      list.bitOn(position, _shift, _mask);

  void _mutateBitSet(int position, TypedDataList<int> list) =>
      list.bitSet(position, _shift, _mask);

  void _mutateBitClear(int position, TypedDataList<int> list) =>
      list.bitClear(position, _shift, _mask);
}

mixin _MixinFlagsPositionAble implements _FlagsField, _FlagsOperator {
  bool _bitOn(int position) => _field.bitOn(position, _shift, _mask);

  void _bitSet(int position) => _field.bitSet(position, _shift, _mask);

  void _bitClear(int position) => _field.bitClear(position, _shift, _mask);
}

///
///
///
mixin _MixinFlagsInsertable implements _FlagsOperator {
  TypedDataList<int> get _newList;

  TypedDataList<int> _newValue(int position) =>
      _newList..[position >> _shift] = 1 << (position & _mask) - 1;

  bool get isEmpty;

  bool get isNotEmpty;
}

mixin _MixinFlagsInsertableHoursADay on _MixinFlagsInsertable {
  @override
  int get _sizeEach => _FlagsBits8.sizeEach * 3;

  @override
  int get _shift => _FlagsBits8.shift;

  @override
  int get _mask => _FlagsBits8.mask;

  @override
  Uint8List get _newList => Uint8List(3);

  void _bufferApplyHours(StringBuffer buffer, TypedDataList<int> hours) {
    final size = _FlagsBits8.sizeEach;
    for (var j = 0; j < 3; j++) {
      var i = 0;
      var bits = hours[j];
      while (i < size) {
        buffer.writeBit(bits);
        bits >>= 1;
        i++;
      }
      buffer.write(' ');
    }
  }
}

///
///
///
abstract class _FlagsParentSource extends _FlagsParent implements _FlagsField {
  @override
  final TypedDataList<int> _field;

  const _FlagsParentSource(this._field);

  int get sizeField => _sizeEach * _field.length;

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }
}

///
///
///
abstract class Flags extends _FlagsParentSource with _MixinFlagsPositionAble {
  final int size;

  bool operator [](int position) => _bitOn(position);

  void operator []=(int position, bool value) =>
      value ? _bitSet(position) : _bitClear(position);

  factory Flags(int size, [bool native = false]) {
    assert(size > 0);
    if (size < _FlagsBits8.limit) return _FlagsBits8(size);
    if (size < _FlagsBits16.limit) return _FlagsBits16(size);
    if (size < _FlagsBits32.limit || !native) return _FlagsBits32(size);
    return _FlagsBits64(size);
  }

  ///
  ///
  ///
  @override
  int get _toStringFieldBorderLength {
    final sizeEach = _sizeEach;
    final titleSpace = (sizeEach * _field.length).toString().length + 1;
    return titleSpace * 2 +
        sizeEach +
        sizeEach ~/ TypedDataListInt.countsAByte +
        5;
  }

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final size = this.size;
    final sizeEach = _sizeEach;
    final field = _field;
    final length = field.length;
    final titleSpace = (sizeEach * length).toString().length + 1;
    for (var j = 0; j < length; j++) {
      final start = j * sizeEach;
      buffer.write('|');
      buffer.write('${start + 1}'.padLeft(titleSpace));
      buffer.write(' ~');
      buffer.write('${math.min(start + sizeEach, size)}'.padLeft(titleSpace));
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
  }

  Flags._(this.size, super._field);
}

///
/// ```dart
/// (x + (n - 1)) ~/ n; // faster
/// (x / n).ceil();     // slower unless x is already double
/// ```
///
class _FlagsBits8 extends Flags with _MixinFlagsOperatableOf8 {
  static const int limit = 9;
  static const int mask = 7;
  static const int shift = 3;
  static const int sizeEach =
      Uint8List.bytesPerElement * TypedDataListInt.countsAByte;

  _FlagsBits8(int size) : super._(size, Uint8List((size + mask) >> shift));
}

class _FlagsBits16 extends Flags with _MixinFlagsOperatableOf16 {
  static const int limit = 17;
  static const int mask = 15;
  static const int shift = 4;
  static const int sizeEach =
      Uint16List.bytesPerElement * TypedDataListInt.countsAByte;

  _FlagsBits16(int size) : super._(size, Uint16List((size + mask) >> shift));
}

class _FlagsBits32 extends Flags with _MixinFlagsOperatableOf32 {
  static const int limit = 33;
  static const int mask = 31;
  static const int shift = 5;
  static const int sizeEach =
      Uint32List.bytesPerElement * TypedDataListInt.countsAByte;

  _FlagsBits32(int size) : super._(size, Uint32List((size + mask) >> shift));
}

class _FlagsBits64 extends Flags with _MixinFlagsOperatableOf64 {
  static const int limit = 65;
  static const int mask = 63;
  static const int shift = 6;
  static const int sizeEach =
      Uint64List.bytesPerElement * TypedDataListInt.countsAByte;

  _FlagsBits64(int size) : super._(size, Uint64List((size + mask) >> shift));
}

///
///
///
abstract class _FlagsParentFieldContainer<T> extends _FlagsParentSource
    with _MixinFlagsPositionAble
    implements _FlagsContainer {
  const _FlagsParentFieldContainer(super.field);

  int _positionOf(T record);

  bool validateRecord(T record);

  @override
  bool contains(covariant T record) => _bitOn(_positionOf(record));

  @override
  void include(covariant T record) => _bitSet(_positionOf(record));

  @override
  void exclude(covariant T record) => _bitClear(_positionOf(record));
}

///
///
/// [_bufferApplyField], ...
/// [_errorEmptyFlagsNotRemoved], ...
/// [_findKey], ...
///
///
abstract class _FlagsSplayIndexIndex<T extends TypedDataList<int>>
    with _MixinFlagsMutable, _MixinFlagsInsertable
    implements _FlagsContainer {
  ///
  /// [_map], [_field]
  /// [_errorEmptyFlagsNotRemoved]
  /// [_excluding]
  ///
  late final SplayTreeMapIntIntInt<TypedDataList<int>> _map;

  SplayTreeMap<int, SplayTreeMap<int, TypedDataList<int>>> get _field =>
      _map.field;

  static StateError _errorEmptyFlagsNotRemoved(int key, int keyKey) =>
      StateError('empty flags key: ($key, $keyKey) should be removed');

  static bool _excluding<T extends TypedDataList<int>>(T list) {
    final length = list.length;
    for (var j = 0; j < length; j++) {
      if (list[j] != 0) return false;
    }
    return true;
  }

  _FlagsSplayIndexIndex.empty({
    bool Function(dynamic potentialKey)? isValidKey,
    int Function(int, int)? compareKeyKey,
    bool Function(dynamic)? Function(int)? isValidKeyKey,
    required int Function(int) toKeyKeyBegin,
    required int Function(int) toKeyKeyEnd,
    required int Function(int, int) toValueBegin,
    required int Function(int, int) toValueEnd,
  }) {
    final bool Function(dynamic)? Function(int) validate =
        isValidKeyKey ?? (_) => null;
    SplayTreeMap<int, TypedDataList<int>> newKeyKey(
      int key,
      int keyKey,
      int value,
    ) =>
        SplayTreeMap(compareKeyKey, validate(key))..[keyKey] = _newValue(value);

    _map = SplayTreeMapIntIntInt(
      SplayTreeMap(Comparable.compare, isValidKey),
      setValue: _mutateBitSet,
      clearValue: _mutateBitClear,
      ensureRemove: _excluding,
      newValue: _newValue,
      newKeyKey: newKeyKey,
      toKeyKeyBegin: toKeyKeyBegin,
      toKeyKeyEnd: toKeyKeyEnd,
      toValueBegin: toValueBegin,
      toValueEnd: toValueEnd,
    );
  }

  ///
  /// [include], [exclude], [clear]
  /// [isEmpty], [isNotEmpty], [contains]
  ///
  @override
  void include(covariant (int, int, int) record) {
    assert(record.isValidDate);
    _map.setRecord(record);
  }

  @override
  void exclude(covariant (int, int, int) record) {
    assert(record.isValidDate);
    _map.removeRecord(record);
  }

  @override
  bool contains(covariant (int, int, int) date) {
    assert(date.isValidDate);
    final months = _map.field[date.$1];
    if (months == null) return false;
    final days = months[date.$2];
    if (days == null) return false;
    return days[0] >> date.$3 - 1 == 1;
  }

  @override
  void clear() => _map.clear();

  @override
  bool get isEmpty => _map.field.isEmpty;

  @override
  bool get isNotEmpty => _map.field.isNotEmpty;

  ///
  /// [includeRange]
  ///
  void includeRange((int, int, int) begin, (int, int, int) end) {
    assert(begin.isValidDate && end.isValidDate && end >= begin);
    final keyBegin = begin.$1;
    final keyEnd = end.$1;
    final map = _map;

    // ==
    if (keyBegin == keyEnd) {
      final keyKeyBegin = begin.$2;
      final keyKeyEnd = end.$2;

      // ==
      if (keyKeyBegin == keyKeyEnd) {
        map.setRecordInts(keyBegin, keyKeyBegin, begin.$3, end.$3);
        return;
      }

      // <
      map.setRecordInts(keyBegin, keyKeyBegin, begin.$3, null);
      for (var j = keyKeyBegin + 1; j < keyKeyEnd; j++) {
        map.setRecordInts(keyBegin, j, null, null);
      }
      map.setRecordInts(keyBegin, keyKeyEnd, null, end.$3);
      return;
    }

    // <
    final keyKeyBegin = begin.$2;
    map.setRecordInts(keyBegin, keyKeyBegin, begin.$3, null);
    map.setRecordIntsKeyKeys(keyBegin, keyKeyBegin + 1, null);
    map.setRecordIntsKey(keyBegin + 1, keyEnd - 1);
    final keyKenEnd = end.$2;
    map.setRecordIntsKeyKeys(keyEnd, null, keyKenEnd - 1);
    map.setRecordInts(keyEnd, keyKenEnd, null, end.$3);
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
  ///
  /// [_findKey], [_findKeyKey], [_findFlag]
  /// [_findEntryInKey], [_findEntryNearBy]
  ///
  ///

  ///
  /// [_findKey]
  /// [_findKeyKey]
  /// [_findFlag]
  ///
  int? _findKey(_MapperSplayTreeMapInt toKey) => toKey(_map.field);

  (int, int)? _findKeyKey(_MapperSplayTreeMapInt toKey) {
    final field = _map.field;
    final key = toKey(field);
    if (key == null) return null;
    return (key, toKey(field[key]!)!);
  }

  (int, int, int)? _findFlag(
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt toBits,
  ) {
    final field = _map.field;
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
  /// [_findEntryNearBy]
  ///
  (int, int, int)? _findEntryInKey(
    int key,
    _MapperSplayTreeMapInt toKey,
    _BitsListToInt toPosition,
  ) {
    final valueMap = _map.field[key];
    if (valueMap == null) return null;
    final keyKey = toKey(valueMap)!;
    final value = toPosition(valueMap[keyKey]!, _sizeEach);
    if (value != null) return (key, keyKey, value);
    throw _errorEmptyFlagsNotRemoved(key, keyKey);
  }

  (int, int, int)? _findEntryNearBy(
    (int, int, int) record,
    _MapperSplayTreeMapInt toKey,
    _MapperSplayTreeMapIntBy toKeyBy,
    PredicatorReducer<int> predicate,
    _BitsListToInt toPosition,
    _BitsListToIntFrom toPositionFrom,
  ) {
    final field = _map.field;
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

  ///
  ///
  ///
  int get _toStringFieldTitleLength;

  void _bufferApplyField(
    StringBuffer buffer,
    int key,
    int keyKey,
    TypedDataList<int> value,
  );

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final pad = _toStringFieldTitleLength;
    for (var entry in _map.field.entries) {
      final key = entry.key;
      buffer.write('|');
      buffer.write('($key'.padLeft(pad));
      buffer.write(',');
      var padding = false;
      for (var valueEntry in entry.value.entries) {
        if (padding) {
          buffer.write('|');
          buffer.writeRepeat(pad + 1, ' ');
        } else {
          padding = true;
        }
        final keyKey = valueEntry.key;
        buffer.write('$keyKey)'.padLeft(4));
        buffer.write(' : ');
        _bufferApplyField(buffer, key, keyKey, valueEntry.value);
        buffer.writeln();
      }
    }
  }
}

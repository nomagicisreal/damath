part of '../typed_data.dart';

///
///
/// [_FlagsParent]
///   **[_FlagsOperator]
///   |   --[_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
///   |   --[_MixinFlagsInsertAble]
///   **[_FlagsField]
///   |   --[_MixinFieldPositionAble] implements [_FlagsOperator]
///   **[_FlagsContainer]
///   |   --[_MixinContainerFieldPositionAble] implements [_MixinFieldPositionAble]
///   |
///   --[_FieldParent] implements [_FlagsField]
///   |   --[_MixinFieldOperatable]
///   |   |
///   |   --[FieldMonthDates] implements [_FlagsContainer]
///   |   --[_FieldParentOperatable] with [_MixinFieldPositionAble], [_MixinFieldOperatable] implements [_FlagsContainer]
///   |       --[FieldADay] with [_MixinContainerFieldPositionAble]
///   |       --[Field]
///   |       --[_FieldParentSpace] with [_MixinContainerFieldPositionAble]
///   |           --[Field2D]
///   |           --[Field3D]
///   |
///   --[_FlagsParentMapSplay] with [_MixinFlagsInsertAble] implements [_FlagsContainer]
///       --[FlagsMapDate]
///       --[FlagsMapHourDate] with [_MixinFlagsInsertAbleHoursADay]
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

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType field:\n');
    final borderLength = _toStringFieldBorderLength;
    buffer.writeRepeat(borderLength, '-');
    buffer.writeln();
    _toStringFlagsBy(buffer);
    buffer.writeRepeat(borderLength, '-');
    buffer.writeln();
    return buffer.toString();
  }

  int get _sizeEach;

  int get _toStringFieldBorderLength;

  void _toStringFlagsBy(StringBuffer buffer);
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

abstract class _FlagsContainer<T> implements _FlagsParent {
  const _FlagsContainer();

  bool validateIndex(T index);

  bool operator [](T index);

  void operator []=(T index, bool value);
}

///
///
///
abstract class _FieldParentSpace<F extends _FieldParent, T>
    extends _FieldParentOperatable<F, T>
    with _MixinContainerFieldPositionAble<T> {
  final int width;
  final int height;

  const _FieldParentSpace(this.width, this.height, super.field);

  @override
  int get _toStringFieldBorderLength =>
      2 + '$height'.length + 2 + (width + 5) ~/ 6 * 7 + 2;

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int i = 0, int shift = 0]) {
    final pad = '$height'.length + 1;
    final width = this.width; // hour per day

    //
    buffer.write('|');
    buffer.writeRepeat(pad + 2, ' ');
    for (var per = 0; per < width; per += 6) {
      buffer.write(' ');
      buffer.write('$per'.padRight(6, ' '));
    }
    buffer.write(' ');
    buffer.write('|');
    buffer.writeln();

    buffer.write('|');
    buffer.writeRepeat(pad + 2, ' ');
    for (var per = 0; per < width; per += 6) {
      buffer.write(' ');
      buffer.write('v');
      buffer.writeRepeat(5, ' ');
    }
    buffer.write(' ');
    buffer.write('|');
    buffer.writeln();
    super._toStringFlagsBy(buffer, i, shift);
  }

  @override
  int get _toStringFlagsIterationLimit => height;

  @override
  Consumer<int> _toStringFlagsEachLineBy(
    StringBuffer buffer, [
    int i = 0,
    int modulo = 0,
  ]) {
    final field = _field;
    final mask = _mask;
    final width = this.width;
    final pad = '$height'.length + 1;
    // final spaceAfterBits = (width + 5) ~/ 6 * 7 - width - (width + 5) ~/ 6 + 1;
    final spaceAfterBits = (width + 5) ~/ 6 * 6 - width + 1;

    var bits = field[i] >> modulo;
    i++;
    final nextField =
        field.length == 1
            ? null
            : (h, w) {
              if (w == width) return;
              if (h * width + modulo + w & mask == 0) {
                bits = field[i];
                i++;
              }
            };
    return (h) {
      buffer.write('${h + 1}'.padLeft(pad));
      buffer.write(' :');
      var w = 0;
      while (w < width) {
        if (w % 6 == 0) buffer.write(' ');
        buffer.writeBit(bits);
        bits >>= 1;
        w++;
        nextField?.call(h, w);
      }
      buffer.writeRepeat(spaceAfterBits, ' ');
      buffer.write('|');
    };
  }
}

///
///
///
abstract class _FieldParent extends _FlagsParent implements _FlagsField {
  @override
  final TypedDataList<int> _field;

  const _FieldParent(this._field);

  int get sizeField => _sizeEach * _field.length;

  @override
  void clear() {
    final length = _field.length;
    for (var i = 0; i < length; i++) {
      _field[i] = 0;
    }
  }

  ///
  ///
  ///
  @override
  void _toStringFlagsBy(StringBuffer buffer, [int i = 0, int shift = 0]) {
    final limit = _toStringFlagsIterationLimit;
    final consume = _toStringFlagsEachLineBy(buffer, i, shift);
    for (var j = 0; j < limit; j++) {
      buffer.write('|');
      consume(j);
      buffer.writeln();
    }
  }

  int get _toStringFlagsIterationLimit;

  Consumer<int> _toStringFlagsEachLineBy(
    StringBuffer buffer, [
    int i = 0,
    int modulo = 0,
  ]);
}

abstract class _FieldParentOperatable<F extends _FieldParent, T>
    extends _FieldParent
    with _MixinFieldPositionAble, _MixinFieldOperatable<F>
    implements _FlagsContainer<T> {
  const _FieldParentOperatable(super._field);
}

///
///
///
abstract class Field extends _FieldParentOperatable<Field, int> {
  final int width;

  factory Field(int width, [bool native = false]) {
    assert(width > 1);
    if (width < TypedIntList.limit8) return _Field8(width);
    if (width < TypedIntList.limit16) return _Field16(width);
    if (width > TypedIntList.sizeEach32 && native) {
      return _Field64(TypedIntList.quotientCeil64(width));
    }
    return _Field32(TypedIntList.quotientCeil32(width));
  }

  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, width);

  @override
  bool operator [](int index) {
    assert(validateIndex(index));
    return _bitOn(index);
  }

  @override
  void operator []=(int index, bool value) {
    assert(validateIndex(index));
    return value ? _bitSet(index) : _bitClear(index);
  }

  ///
  ///
  ///
  @override
  int get _toStringFieldBorderLength {
    final sizeEach = _sizeEach;
    final titleSpace = (sizeEach * _field.length).toString().length + 1;
    return titleSpace * 2 + sizeEach + sizeEach ~/ TypedIntList.countsAByte + 5;
  }

  @override
  int get _toStringFlagsIterationLimit => _field.length;

  @override
  Consumer<int> _toStringFlagsEachLineBy(
    StringBuffer buffer, [
    int i = 0,
    int modulo = 0,
  ]) {
    final width = this.width;
    final sizeEach = _sizeEach;
    final field = _field;
    final titleSpace = (sizeEach * field.length).toString().length + 1;
    return (j) {
      final start = j * sizeEach;
      buffer.write('${start + 1}'.padLeft(titleSpace));
      buffer.write(' ~');
      buffer.write('${math.min(start + sizeEach, width)}'.padLeft(titleSpace));
      buffer.write(': ');
      for (var bits = field[j]; bits > 0; bits >>= 1) {
        buffer.write(bits & 1 == 1 ? '1' : '0');
        i++;
        if (i % 8 == 0) buffer.write(' ');
      }
      while (i < sizeEach && start + i < width) {
        buffer.write('0');
        i++;
        if (i % 8 == 0) buffer.write(' ');
      }
      i = 0;
    };
  }

  Field._(this.width, super._field);
}

///
///
/// [_bufferApplyField], ...
/// [_errorEmptyFlagsNotRemoved], ...
/// [_findKey], ...
///
///
abstract class _FlagsParentMapSplay
    with _MixinFlagsInsertAble
    implements _FlagsContainer<(int, int, int)> {
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

  static bool _excluding(TypedDataList<int> list) {
    final length = list.length;
    for (var j = 0; j < length; j++) {
      if (list[j] != 0) return false;
    }
    return true;
  }

  _FlagsParentMapSplay.empty({
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
        SplayTreeMap(compareKeyKey, validate(key))
          ..[keyKey] = _newInsertion(value);

    _map = SplayTreeMapIntIntInt(
      SplayTreeMap(Comparable.compare, isValidKey),
      setValue: _mutateBitSet,
      clearValue: _mutateBitClear,
      ensureRemove: _excluding,
      newValue: _newInsertion,
      newKeyKey: newKeyKey,
      toKeyKeyBegin: toKeyKeyBegin,
      toKeyKeyEnd: toKeyKeyEnd,
      toValueBegin: toValueBegin,
      toValueEnd: toValueEnd,
    );
  }

  ///
  ///
  ///
  @override
  bool operator []((int, int, int) index) {
    assert(index.isValidDate);
    final months = _map.field[index.$1];
    if (months == null) return false;
    final days = months[index.$2];
    if (days == null) return false;
    return days[0] >> index.$3 - 1 == 1;
  }

  @override
  void operator []=((int, int, int) index, bool value) {
    assert(index.isValidDate);
    value ? _map.setRecord(index) : _map.removeRecord(index);
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
    TypedDataList<int> values,
  );

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
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

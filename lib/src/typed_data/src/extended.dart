part of '../typed_data.dart';

///
///
///
/// [TypedIntList]
///
///
/// [_MapperSplayTreeMapInt], ...
/// [_SplayTreeMapIntIntTypedInt]
///
///
///
///

///
/// static constants and methods:
/// [countsAByte], ...
/// [quotientCeil8], ...
///
/// instances methods:
/// return void                   : [bitConsume], ...
/// return bool                   : [bitOn], ...
/// return integer                : [bitFirst], ...
/// return iterable integer       : [bitsAvailable], ...
/// return iterable provided type : [mapBitsAvailable], ...
///
extension TypedIntList on TypedDataList<int> {
  static const int countsAByte = 8;
  static const int limit4 = 5;
  static const int mask4 = 3;
  static const int shift4 = 2;
  static const int limit8 = 9;
  static const int mask8 = 7;
  static const int shift8 = 3;
  static const int sizeEach8 =
      Uint8List.bytesPerElement * TypedIntList.countsAByte;
  static const int limit16 = 17;
  static const int mask16 = 15;
  static const int shift16 = 4;
  static const int sizeEach16 =
      Uint16List.bytesPerElement * TypedIntList.countsAByte;

  // static const int limit32 = 33;
  static const int mask32 = 31;
  static const int shift32 = 5;
  static const int sizeEach32 =
      Uint32List.bytesPerElement * TypedIntList.countsAByte;

  // static const int limit64 = 65;
  static const int mask64 = 63;
  static const int shift64 = 6;
  static const int sizeEach64 =
      Uint64List.bytesPerElement * TypedIntList.countsAByte;

  ///
  ///
  ///
  static int quotientCeil64(int value) => value + mask64 >> shift64;

  static int quotientCeil32(int value) => value + mask32 >> shift32;

  static int quotientCeil16(int value) => value + mask16 >> shift16;

  static int quotientCeil8(int value) => value + mask8 >> shift8;

  ///
  /// [comparing8First], ...
  ///
  static int comparing8First(Uint8List a, Uint8List b) => a[0].compareTo(b[0]);

  static int comparing16First(Uint16List a, Uint16List b) =>
      a[0].compareTo(b[0]);

  static int comparing32First(Uint16List a, Uint16List b) =>
      a[0].compareTo(b[0]);

  static int comparing64First(Uint64List a, Uint64List b) =>
      a[0].compareTo(b[0]);

  ///
  /// [getBitFirst1]
  /// [getBitLast1]
  /// [getBitFirst1From]
  /// [getBitLast1From]
  ///
  static int? getBitFirst1<T extends TypedDataList<int>>(T list, int size) =>
      list.bitFirst(size);

  static int? getBitLast1<T extends TypedDataList<int>>(T list, int size) =>
      list.bitLast(size);

  static int? getBitFirst1From<T extends TypedDataList<int>>(
    T list,
    int k,
    int size,
  ) => list.bitFirstFrom(k, size);

  static int? getBitLast1From<T extends TypedDataList<int>>(
    T list,
    int k,
    int size,
  ) => list.bitLastFrom(k, size);

  ///
  /// [bitSet], [bitClear]
  /// [bitConsume]
  ///
  void bitSet(int p, int shift, int mask) =>
      this[p >> shift] |= 1 << (p & mask);

  void bitClear(int p, int shift, int mask) =>
      this[p >> shift] &= ~(1 << (p & mask));

  void bitConsume(
    void Function(int p) consume,
    int size,
    int max, [
    int bit = 1,
  ]) {
    for (var j = 0; j < max; j++) {
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) consume(size * j + i);
      }
    }
  }

  ///
  /// [bitOn]
  ///
  bool bitOn(int p, int shift, int mask, [int bit = 1]) =>
      (this[p >> shift] >> (p & mask)) & 1 == bit;

  ///
  /// [bitFirst]
  /// [bitN]
  /// [bitLast]
  ///
  int? bitFirst(int size, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) return size * j + i;
      }
    }
    return null;
  }

  int? bitN(int n, int size, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) {
          n--;
          if (n == 0) return size * j * i;
        }
      }
    }
    return null;
  }

  int? bitLast(int size, [int bit = 1]) {
    for (var j = length - 1; j > -1; j--) {
      for (
        var bits = this[j], mask = 1 << size - 1, i = size - 1;
        mask > 0;
        mask >>= 1, i--
      ) {
        if ((bits & mask) >> i == bit) return size * j + i;
      }
    }
    return null;
  }

  ///
  /// [bitFirstFrom]
  /// [bitNFrom]
  /// [bitLastFrom]
  ///
  int? bitFirstFrom(int k, int size, [int bit = 1]) {
    var j = k ~/ size;
    var i = k & size - 1;
    var bits = this[j];

    while (bits > 0) {
      if (bits & 1 == bit) return size * j + i;
      i++;
      bits >>= 1;
    }
    j++;

    final length = this.length;
    while (j < length) {
      i = 0;
      bits = this[j];
      while (bits > 0) {
        if (bits & 1 == bit) return size * j + i;
        i++;
        bits >>= 1;
      }
      j++;
    }
    return null;
  }

  int? bitNFrom(int k, int size, int n, [int bit = 1]) {
    var j = k ~/ size;
    var i = k & size - 1;
    var bits = this[j];

    while (bits > 0) {
      if (bits & 1 == bit) {
        n--;
        if (n == 0) return size * j + i;
      }
      i++;
      bits >>= 1;
    }
    j++;

    final length = this.length;
    while (j < length) {
      i = 0;
      bits = this[j];
      while (bits > 0) {
        if (bits & 1 == bit) {
          n--;
          if (n == 0) return size * j + i;
        }
        i++;
        bits >>= 1;
      }
      j++;
    }
    return null;
  }

  int? bitLastFrom(int k, int size, [int bit = 1]) {
    var j = k ~/ size;
    var i = k % size - 1;
    var bits = this[j];
    var mask = 1 << i - 1;

    while (mask > 0) {
      if ((bits & mask) >> i == bit) return size * j + i;
      mask >>= 1;
      i--;
    }
    j--;

    while (j > -1) {
      i = size - 1;
      bits = this[j];
      mask = 1 << i - 1;
      while (mask > 0) {
        if ((bits & mask) >> i == bit) return size * j + i;
        mask >>= 1;
        i--;
      }
      j--;
    }

    return null;
  }

  ///
  ///
  /// [bitsAvailable], [mapBitsAvailable]
  /// [mapBitsAvailableFrom]
  /// [mapBitsAvailableTo]
  /// [mapBitsAvailableBetween]
  /// notice that [size] must be 2^n, so [size] - 1 will be [_Field8.mask8], [TypedIntList.mask16], ...
  ///
  ///
  Iterable<int> bitsAvailable<T>(int size) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  Iterable<T> mapBitsAvailable<T>(int size, Mapper<int, T> mapping) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }
  }

  // inclusive
  Iterable<T> mapBitsAvailableFrom<T>(
    int size,
    int from,
    Mapper<int, T> mapping, [
    bool inclusive = true,
  ]) sync* {
    from += inclusive ? 0 : 1;
    var j = from ~/ size;
    final prefix = size * j;
    for (
      var i = from & size - 1, bits = this[j] >> i - 1;
      bits > 0;
      i++, bits >>= 1
    ) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
    j++;

    final length = this.length;
    for (; j < length; j++) {
      final prefix = size * j;
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }
  }

  // inclusive
  Iterable<T> mapBitsAvailableTo<T>(
    int size,
    int to,
    Mapper<int, T> mapping, [
    bool inclusive = true,
  ]) sync* {
    to -= inclusive ? 0 : 1;
    if (to < 1) return;

    final limit = to ~/ size;
    for (var j = 0; j < limit; j++) {
      final prefix = size * j;
      for (var i = 0, bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    final max = to & size - 1;
    final prefix = size * limit;
    for (var i = 0, bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
  }

  // inclusive
  Iterable<T> mapBitsAvailableBetween<T>(
    int size,
    int? from,
    int? to,
    Mapper<int, T> mapping, [
    bool inclusive = true,
  ]) sync* {
    if (from == null) {
      if (to == null) {
        yield* mapBitsAvailable(size, mapping);
        return;
      }
      yield* mapBitsAvailableTo(size, to, mapping, inclusive);
      return;
    }
    if (to == null) {
      yield* mapBitsAvailableFrom(size, from, mapping, inclusive);
      return;
    }

    from += inclusive ? 0 : 1;
    to -= inclusive ? 0 : 1;
    if (from > to) return;

    final limit = to ~/ size;
    final max = to & size - 1;
    var j = from ~/ size;
    var i = from & size - 1;
    var prefix = size * j;

    // on from && on to
    if (j == limit) {
      for (var bits = this[j]; i <= max; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
      return;
    }

    // on from
    for (var bits = this[j] >> i - 1; bits > 0; i++, bits >>= 1) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
    j++;

    // after from, before to
    for (; j < limit; j++) {
      prefix = size * j;
      i = 0;
      for (var bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    // on to
    prefix = size * limit;
    i = 0;
    for (var bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
  }
}

///
///
///
typedef _MapperSplayTreeMapInt<T> = int? Function(SplayTreeMap<int, T> map);
typedef _MapperSplayTreeMapIntBy<T> =
int? Function(SplayTreeMap<int, T> map, int by);

typedef _BitsListToInt = int? Function(TypedDataList<int> list, int size);
typedef _BitsListToIntFrom =
int? Function(TypedDataList<int> list, int k, int size);

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

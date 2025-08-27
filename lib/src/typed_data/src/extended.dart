part of '../typed_data.dart';

///
///
///
/// [TypedIntList]
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
/// return void                   : [pConsume], ...
/// return bool                   : [pOn], ...
/// return integer                : [pFirst], ...
/// return iterable integer       : [pAvailable], ...
/// return iterable provided type : [mapPAvailable], ...
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
  /// [getPFirst1]
  /// [getPLast1]
  /// [getPFirst1From]
  /// [getPLast1From]
  ///
  static int? getPFirst1<T extends TypedDataList<int>>(T list, int sizeEach) =>
      list.pFirst(sizeEach);

  static int? getPLast1<T extends TypedDataList<int>>(T list, int sizeEach) =>
      list.pLast(sizeEach);

  static int? getPFirst1From<T extends TypedDataList<int>>(
    T list,
    int k,
    int sizeEach,
  ) => list.pFirstFrom(k, sizeEach);

  static int? getPLast1From<T extends TypedDataList<int>>(
    T list,
    int k,
    int sizeEach,
  ) => list.pLastFrom(k, sizeEach);

  ///
  /// [bFirstOf]
  /// [bLastOf]
  /// [bsOf]
  /// [bsMappedOf]
  ///
  int? bFirstOf(int i, [int from = 1]) {
    for (var bits = this[i] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) return p;
    }
    return null;
  }

  int? bLastOf(int i, int from) {
    for (
      var bits = this[i], mask = 1 << from - 1, p = from;
      mask > 0;
      mask >>= 1, p--
    ) {
      if (bits & 1 == 1) return p;
    }
    return null;
  }

  Iterable<int> bsOf(int i, [int from = 1]) sync* {
    for (var bits = this[i] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) yield p;
    }
  }

  Iterable<T> bsMappedOf<T>(
    int i,
    Mapper<int, T> mapping, [
    int from = 1,
  ]) sync* {
    for (var bits = this[i] >> from - 1, p = from; bits > 0; bits >>= 1, p++) {
      if (bits & 1 == 1) yield mapping(p);
    }
  }

  ///
  /// [pSet], [pClear]
  /// [pConsume]
  ///
  void pSet(int p, int shift, int mask) => this[p >> shift] |= 1 << (p & mask);

  void pClear(int p, int shift, int mask) =>
      this[p >> shift] &= ~(1 << (p & mask));

  void pConsume(
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
  /// [pOn]
  ///
  bool pOn(int p, int shift, int mask, [int bit = 1]) =>
      (this[p >> shift] >> (p & mask)) & 1 == bit;

  ///
  /// [pFirst]
  /// [pN]
  /// [pLast]
  ///
  int? pFirst(int size, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 0, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) return size * j + i;
      }
    }
    return null;
  }

  int? pN(int n, int size, [int bit = 1]) {
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

  int? pLast(int size, [int bit = 1]) {
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
  /// [pFirstFrom]
  /// [pNFrom]
  /// [pLastFrom]
  ///
  int? pFirstFrom(int k, int size, [int bit = 1]) {
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

  int? pNFrom(int k, int size, int n, [int bit = 1]) {
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

  int? pLastFrom(int k, int size, [int bit = 1]) {
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
  /// [pAvailable], [mapPAvailable]
  /// [mapPAvailableFrom]
  /// [mapPAvailableTo]
  /// [mapPAvailableBetween]
  /// notice that [size] must be 2^n, so [size] - 1 will be [_Field8.mask8], [TypedIntList.mask16], ...
  ///
  ///
  Iterable<int> pAvailable<T>(int size) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 0; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  Iterable<T> mapPAvailable<T>(int size, Mapper<int, T> mapping) sync* {
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
  Iterable<T> mapPAvailableFrom<T>(
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
  Iterable<T> mapPAvailableTo<T>(
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
  Iterable<T> mapPAvailableBetween<T>(
    int size,
    int? from,
    int? to,
    Mapper<int, T> mapping, [
    bool inclusive = true,
  ]) sync* {
    if (from == null) {
      if (to == null) {
        yield* mapPAvailable(size, mapping);
        return;
      }
      yield* mapPAvailableTo(size, to, mapping, inclusive);
      return;
    }
    if (to == null) {
      yield* mapPAvailableFrom(size, from, mapping, inclusive);
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

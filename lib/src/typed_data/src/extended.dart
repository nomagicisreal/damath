part of '../typed_data.dart';

///
///
/// [_MapperSplayTreeMapInt], ...
/// [_DateExtension]
/// [TypedDataListInt]
///
///

///
///
///
typedef _MapperSplayTreeMapInt<T> = int? Function(SplayTreeMap<int, T> map);
typedef _MapperSplayTreeMapIntBy<T> =
    int? Function(SplayTreeMap<int, T> map, int by);

typedef _BitsListToInt<T extends TypedDataList<int>> =
    int? Function(T list, int size);
typedef _BitsListToIntFrom<T extends TypedDataList<int>> =
    int? Function(T list, int k, int size);

///
///
///
extension _DateExtension on (int, int, int) {
  ///
  ///
  ///
  static int comparing((int, int, int) d1, (int, int, int) d2) {
    final cYear = d1.$1.compareTo(d2.$1);
    if (cYear != 0) return cYear;
    final cMonth = d1.$2.compareTo(d2.$2);
    if (cMonth != 0) return cMonth;
    final cDay = d1.$3.compareTo(d2.$3);
    return cDay;
  }

  ///
  ///
  ///
  // bool operator >((int, int, int) another) =>
  //     this.$1 > another.$1 && this.$2 > another.$2 && this.$3 > another.$3;
  //
  // bool operator <((int, int, int) another) =>
  //     this.$1 < another.$1 && this.$2 < another.$2 && this.$3 < another.$3;
}

///
/// [comparing8First], ...
/// [bitConsume], ...
/// [bitOn], ...
///
extension TypedDataListInt on TypedDataList<int> {
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
  /// [bytesFrom]
  /// [bytesFirstFrom8], ...
  ///
  static int bytesFrom<T extends TypedDataList<int>>(T list, int index) =>
      list[index];

  static int bytesFirstFrom8(Uint8List list) => list[0];

  static int bytesFirstFrom16(Uint16List list) => list[0];

  static int bytesFirstFrom32(Uint32List list) => list[0];

  static int bytesFirstFrom64(Uint64List list) => list[0];

  ///
  /// [getBitFirst1]
  /// [getBitLast1]
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
  /// [bitOn]
  /// [bitSet], [bitClear]
  ///
  bool bitOn(int p, int shift, int mask, [int bit = 1]) =>
      (this[p >> shift] >> (p & mask) - 1) & 1 == bit;

  void bitSet(int p, int shift, int mask) =>
      this[p >> shift] |= 1 << (p & mask) - 1;

  void bitClear(int p, int shift, int mask) =>
      this[p >> shift] &= ~(1 << (p & mask) - 1);

  ///
  /// [bitConsume]
  ///
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
  /// [bitFirst]
  /// [bitN]
  /// [bitLast]
  ///
  int? bitFirst(int size, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == bit) return size * j + i;
      }
    }
    return null;
  }

  int? bitN(int n, int size, [int bit = 1]) {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
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
        var bits = this[j], mask = 1 << size - 1, i = size;
        i > 0;
        mask >>= 1, i--
      ) {
        if ((bits & mask) >> i - 1 == bit) return size * j + i;
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
      i = 1;
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
      i = 1;
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
    var i = k & size - 1;
    var bits = this[j];
    var mask = 1 << i - 1;

    while (i > -1) {
      if ((bits & mask) >> i - 1 == bit) return size * j + i;
      mask >>= 1;
      i--;
    }
    j--;

    while (j > -1) {
      i = size;
      bits = this[j];
      mask = 1 << i - 1;
      while (i > -1) {
        if ((bits & mask) >> i - 1 == bit) return size * j + i;
        mask >>= 1;
        i--;
      }
      j--;
    }

    return null;
  }

  ///
  /// [bitsAvailable]
  /// [bitsAvailableMap]
  /// [bitsAvailableAfter]
  /// [bitsAvailableBefore]
  ///
  Iterable<int> bitsAvailable(int size) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 1; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }
  }

  Iterable<T> bitsAvailableMap<T>(int size, Mapper<int, T> mapper) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 1; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield mapper(prefix + i);
      }
    }
  }

  Iterable<int> bitsAvailableAfter(int size, int from) sync* {
    var j = from ~/ size;
    final prefix = size * j;
    for (
      var i = from & size - 1, bits = this[j] >> i - 1;
      bits > 0;
      i++, bits >>= 1
    ) {
      if (bits & 1 == 1) yield prefix + i;
    }
    j++;

    final length = this.length;
    while (j < length) {
      final prefix = size * j;
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
      j++;
    }
  }

  Iterable<int> bitsAvailableBefore(int size, int to) sync* {
    final limit = to ~/ size;
    for (var j = 0; j < limit; j++) {
      final prefix = size * j;
      for (var i = 0, bits = this[j]; i < size; i++, bits >>= 1) {
        if (bits & 1 == 1) yield prefix + i;
      }
    }

    final max = to & size - 1;
    final prefix = size * limit;
    for (var i = 0, bits = this[limit]; i < max; i++, bits >>= 1) {
      if (bits & 1 == 1) yield prefix + i;
    }
  }
}

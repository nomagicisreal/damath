part of '../typed_data.dart';

///
///
///
///
/// [_MapperSplayTreeMapInt], ...
/// [TypedDataListInt]
///
/// [Weekday]
/// [MinutePeriod]
///
///
///

///
///
///
typedef _MapperSplayTreeMapInt<T> = int? Function(SplayTreeMap<int, T> map);
typedef _MapperSplayTreeMapIntBy<T> =
    int? Function(SplayTreeMap<int, T> map, int by);

typedef _BitsListToInt =
    int? Function(TypedDataList<int> list, int size);
typedef _BitsListToIntFrom =
    int? Function(TypedDataList<int> list, int k, int size);

///
/// [comparing8First], ...
/// [bitConsume], ...
/// [bitOn], ...
///
extension TypedDataListInt on TypedDataList<int> {
  static const int countsAByte = 8;

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
  ///
  /// [bitsAvailable] // prevent replicate implementation
  /// [mapBitsAvailable]
  /// [mapBitsAvailableFrom]
  /// [mapBitsAvailableTo]
  /// [mapBitsAvailableBetween]
  /// notice that [size] must be 2^n, so [size] - 1 will be [_FieldBits8.mask], [_FieldBits16.mask], ...
  ///
  ///
  Iterable<T> mapBitsAvailable<T>(int size, Mapper<int, T> mapping) sync* {
    final length = this.length;
    for (var j = 0; j < length; j++) {
      final prefix = size * j;
      var bits = this[j];
      for (var i = 1; bits > 0; i++, bits >>= 1) {
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
      for (var i = 1, bits = this[j]; bits > 0; i++, bits >>= 1) {
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
      for (var i = 1, bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    final max = to & size - 1;
    final prefix = size * limit;
    for (var i = 1, bits = this[limit]; i <= max; bits >>= 1, i++) {
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
      yield* mapBitsAvailableTo(size, to, mapping);
      return;
    }
    if (to == null) {
      yield* mapBitsAvailableFrom(size, from, mapping);
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
      i = 1;
      for (var bits = this[j]; bits > 0; bits >>= 1, i++) {
        if (bits & 1 == 1) yield mapping(prefix + i);
      }
    }

    // on to
    prefix = size * limit;
    i = 1;
    for (var bits = this[limit]; i <= max; bits >>= 1, i++) {
      if (bits & 1 == 1) yield mapping(prefix + i);
    }
  }
}

///
///
///
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory Weekday.from(DateTime dateTime) => switch (dateTime.weekday) {
    DateTime.monday => monday,
    DateTime.tuesday => tuesday,
    DateTime.wednesday => wednesday,
    DateTime.thursday => thursday,
    DateTime.friday => friday,
    DateTime.saturday => saturday,
    DateTime.sunday => sunday,
    _ => throw ArgumentError('date time weekday: ${dateTime.weekday}'),
  };
}

// enum MinutePeriod {
//   per1,
//   per5,
//   per10,
//   per20,
//   per30;
//
//   int get number => switch (this) {
//     MinutePeriod.per1 => 1,
//     MinutePeriod.per5 => 5,
//     MinutePeriod.per10 => 10,
//     MinutePeriod.per20 => 20,
//     MinutePeriod.per30 => 30,
//   };
// }

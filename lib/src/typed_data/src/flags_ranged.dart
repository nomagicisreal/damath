part of '../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_FlagsParent]
///
/// [FlagsRangingDates]
/// [FlagsRangingDaysHours]
///   --[_FlagsRDH8], [_FlagsRDH16]
///   --[_FlagsRDH32], [_FlagsRDH64]
///
///
///

///
///
///
class FlagsRangingDates extends _FlagsParentSource
    implements _FlagsContainer {
  final (int, int, int) begin;
  final (int, int, int) end;

  FlagsRangingDates(this.begin, this.end)
    : assert(begin.isValidDate && end.isValidDate, 'invalid date $begin, $end'),
      assert(end > begin, 'invalid range begin($begin), end($end)'),
      super(Uint32List(1 + begin.monthsToDates(end.$1, end.$2)));

  int _indexOf(int year, int month) => begin.monthsToDates(year, month);

  @override
  int get _sizeEach => _FlagsBits32.sizeEach;

  @override
  bool contains(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    return 1 == _field[_indexOf(record.$1, record.$2)] >> record.$3 - 1 & 1;
  }

  @override
  void include(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    _field[_indexOf(record.$1, record.$2)] |= 1 << record.$3 - 1;
  }

  @override
  void exclude(covariant (int, int, int) record) {
    assert(record.isValidDate && begin <= record && record <= end);
    _field[_indexOf(record.$1, record.$2)] &= ~(1 << record.$3 - 1);
  }

  @override
  int get _toStringFieldBorderLength => 15 + 32 + 4;

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final december = DateTime.december;
    final daysOf = DateTimeExtension.monthDaysOf;
    final begin = this.begin;
    var year = begin.$1;
    var month = begin.$2;
    for (var monthDaysField in _field) {
      buffer.write('|');
      buffer.write('($year'.padLeft(6));
      buffer.write(',');
      buffer.write('$month)'.padLeft(4));
      buffer.write(' : ');
      buffer.writeBitsOfMonth(monthDaysField, daysOf(year, month));
      buffer.writeln();
      month++;
      if (month > december) {
        month = 1;
        year++;
      }
    }
  }
}

///
///
///
abstract class FlagsRangingDaysHours
    extends _FlagsParentFieldContainer<(int, int)> {
  final int hourBegin;
  final int hoursPerDay;
  final int daysCount;

  factory FlagsRangingDaysHours(
    int hourBegin,
    int hourLimit,
    int daysCount, [
    bool native = false,
  ]) {
    assert(
      DateTimeExtension.isValidHour(hourBegin),
      'invalid hourBegin: $hourBegin',
    );
    assert(
      DateTimeExtension.isValidHour(hourLimit),
      'invalid hourEnd: $hourLimit',
    );
    assert(daysCount > 1, 'invalid days count: $daysCount');

    final hpd = hourLimit - hourBegin; // hours per day
    assert(hpd > 1, 'invalid hours per day: $hpd');
    final ht = hpd * daysCount; // hours total
    if (ht < _FlagsBits8.limit) return _FlagsRDH8(hourBegin, hpd, daysCount);
    if (ht < _FlagsBits16.limit) return _FlagsRDH16(hourBegin, hpd, daysCount);
    if (ht < _FlagsBits32.limit) return _FlagsRDH32(hourBegin, hpd, daysCount);
    if (!native) return _FlagsRDH32.multiple(hourBegin, hpd, daysCount, ht);
    return ht < _FlagsBits64.limit
        ? _FlagsRDH64(hourBegin, hpd, daysCount)
        : _FlagsRDH64.multiple(hourBegin, hpd, daysCount, ht);
  }

  @override
  bool validateRecord((int, int) record) =>
      record.$1.isRangeClose(1, daysCount) &&
      record.$2.isRangeOpenUpper(hourBegin, hourBegin + hoursPerDay);

  ///
  ///
  ///
  @override
  int _positionOf((int, int) record) {
    assert(validateRecord(record));
    return (record.$1 - 1) * hoursPerDay + record.$2 - hourBegin + 1;
  }

  @override
  int get _toStringFieldBorderLength =>
      3 + '$daysCount'.length + 2 + (hoursPerDay + 5) ~/ 6 * 7 + 2;

  @override
  void _toStringApplyBody(StringBuffer buffer) {
    final daysCount = this.daysCount;
    final pad = '$daysCount'.length + 1;
    final hourBegin = this.hourBegin;
    final hoursPerDay = this.hoursPerDay;

    //
    buffer.write('|');
    buffer.writeRepeat(pad + 3, ' ');
    for (var per = 0; per < hoursPerDay; per += 6) {
      buffer.write(' ');
      buffer.write('${hourBegin + per}:00'.padLeft(5, '0'));
      buffer.write(' ');
    }
    buffer.write(' ');
    buffer.write('|');

    buffer.writeln();
    buffer.write('|');
    buffer.writeRepeat(pad + 3, ' ');
    for (var per = 0; per < hoursPerDay; per += 6) {
      buffer.write(' ');
      buffer.write('v');
      buffer.writeRepeat(5, ' ');
    }
    buffer.write(' ');
    buffer.write('|');
    buffer.writeln();

    //
    final field = _field;
    final mask = _mask;
    var i = 0;
    var bits = field[i];
    i++;
    final only1Bits = field.length == 1;
    final spaceAfterBits =
        // (hoursPerDay + 5) ~/ 6 * 7 - hoursPerDay - (hoursPerDay + 5) ~/ 6 + 1;
        (hoursPerDay + 5) ~/ 6 * 6 - hoursPerDay + 1;
    for (var d = 0; d < daysCount; d++) {
      buffer.write('|');
      buffer.write('${d + 1}'.padLeft(pad));
      buffer.write('d');
      buffer.write(' :');
      var h = 0;
      final hoursRouted = d * hoursPerDay;
      while (h < hoursPerDay) {
        if (h % 6 == 0) buffer.write(' ');
        buffer.writeBit(bits);
        bits >>= 1;
        h++;
        if (only1Bits) continue;
        if (hoursRouted + h & mask == 0) {
          bits = field[i];
          i++;
        }
      }
      buffer.writeRepeat(spaceAfterBits, ' ');
      buffer.write('|');
      buffer.writeln();
    }
  }

  FlagsRangingDaysHours._(
    this.hourBegin,
    this.hoursPerDay,
    this.daysCount,
    super._field,
  );
}

class _FlagsRDH8 extends FlagsRangingDaysHours with _MixinFlagsOperatableOf8 {
  _FlagsRDH8(int hourBegin, int hoursPerDay, int daysCount)
    : super._(hourBegin, hoursPerDay, daysCount, Uint8List(1));
}

class _FlagsRDH16 extends FlagsRangingDaysHours with _MixinFlagsOperatableOf16 {
  _FlagsRDH16(int hourBegin, int hoursPerDay, int daysCount)
    : super._(hourBegin, hoursPerDay, daysCount, Uint16List(1));
}

class _FlagsRDH32 extends FlagsRangingDaysHours with _MixinFlagsOperatableOf32 {
  _FlagsRDH32(int hourBegin, int hoursPerDay, int daysCount)
    : super._(hourBegin, hoursPerDay, daysCount, Uint32List(1));

  _FlagsRDH32.multiple(
    int hourBegin,
    int hoursPerDay,
    int daysCount,
    int hoursTotal,
  ) : super._(
        hourBegin,
        hoursPerDay,
        daysCount,
        Uint32List(hoursTotal + _FlagsBits32.mask >> _FlagsBits32.shift),
      );
}

class _FlagsRDH64 extends FlagsRangingDaysHours with _MixinFlagsOperatableOf64 {
  _FlagsRDH64(int hourBegin, int hoursPerDay, int daysCount)
    : super._(hourBegin, hoursPerDay, daysCount, Uint64List(1));

  _FlagsRDH64.multiple(
    int hourBegin,
    int hoursPerDay,
    int daysCount,
    int hoursTotal,
  ) : super._(
        hourBegin,
        hoursPerDay,
        daysCount,
        Uint64List(hoursTotal + _FlagsBits64.mask >> _FlagsBits64.shift),
      );
}

// ///
// ///
// ///
// class FlagsScheduleDays {
//
// }
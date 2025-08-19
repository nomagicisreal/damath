part of '../typed_data.dart';

///
/// [_FlagsParent]
///   **[_FlagsContainer] for all [_FlagsParent] concrete children
///   **[_FlagsOperator] -> [_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
///   |   --[_MixinFlagsValueInsert]
///   **[_FlagsIterable]
///   |
///   --[_FieldParent]
///   |   --[_MixinFieldOperatable] for all [_FieldParent] children
///   |   --[_MixinFieldPositionAble] implements [_FlagsOperator]
///   |   |   --[_MixinFieldPositionAbleIterable]
///   |   |   --[_MixinFieldPositionAbleContainer] implements [_FlagsContainer]
///   |   --[_MixinFieldIterable]
///   |   --[_MixinFieldIterableIndex]
///   |   |
///   |   --[_FieldParentSpatial1] with [_MixinFieldPositionAble]
///   |   |   --[Field]
///   |   |   --[_FieldParentSpatial2]
///   |   |       **[_FieldSpatialCollapse] for all [_FieldParentSpatial2] children
///   |   |       --[Field2D] with [_MixinFieldPositionAbleContainer]
///   |   |       --[_FieldParentSpatial3]
///   |   |           --[Field3D] with [_MixinFieldPositionAbleContainer]
///   |   |           --[_FieldParentSpatial4]
///   |   |               --[Field4D] with [_MixinFieldPositionAbleContainer]
///   |   |
///   |   --[_FieldParentScope]
///   |   |   --[FieldDatesInMonths]
///   |   |
///   |   --[FieldAB] with [_MixinFieldPositionAbleContainer]
///   |
///   --[_FlagsParentMapSplay] with [_MixinFlagsValueInsert] implements [_FlagsContainer]
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

  int get _sizeEach;

  @override
  String toString() {
    String result = '';
    assert(() {
      final instance = this;
      final borderLength = switch (instance) {
        _FieldParentSpatial1() => switch (instance) {
          // spatial 2, 3, 4 are the same
          _FieldParentSpatial2() =>
            2 +
                '${instance.spatial2}'.length +
                2 +
                (instance.spatial1 + 3) ~/ 4 * 5 +
                2,
          Field() =>
            3 +
                '${instance.spatial1}'.length * 2 +
                4 +
                (_sizeEach + TypedIntList.mask4 >> TypedIntList.shift4) * 5 +
                2,
        },
        FieldDatesInMonths() || FlagsMapDate() => 15 + 32 + 4,
        FieldAB() =>
          3 +
              6 +
              2 +
              switch (instance.bDivision) {
                    1 => 6,
                    2 || 3 => 4,
                    _ => 3,
                  } *
                  (instance.bDivision + 1) +
              2,
        FlagsMapHourDate() => 4 + 5 + 3 + 32 + 4,
        _FlagsParent() =>
          throw UnimplementedError(instance.runtimeType.toString()),
      };

      ///
      ///
      ///
      final buffer = StringBuffer('$runtimeType field:\n');
      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();

      ///
      /// body
      ///
      // field 1d ~ 4d
      if (instance is _FieldParent) {
        final field = instance._field;
        if (instance is _FieldParentSpatial1) {
          void fieldFlags1() {
            final size = _sizeEach;
            final max = instance.spatial1;
            final pad = '${size * field.length}'.length + 1;
            final jLast = field.length - 1;
            final maskChunk = TypedIntList.mask4;
            final countLastLine = max & instance._mask;
            final limit = field.length;
            for (var j = 0; j < limit; j++) {
              final start = j * size;
              late final int space;
              late final String end;
              late final Predicator<int> predicate;
              if (j == jLast && countLastLine != 0) {
                end = '${max - 1}';
                predicate = IntExtension.predicator_additionLess(start, max);
                space =
                    1 +
                    (size >> TypedIntList.shift4) * 5 -
                    countLastLine -
                    (countLastLine + TypedIntList.mask4 >> TypedIntList.shift4);
              } else {
                end = '${start + size}';
                predicate = IntExtension.predicator_less(size);
                space = 1;
              }

              buffer.write('|');
              buffer.write('$start'.padLeft(pad));
              buffer.write(' ~');
              buffer.write(end.padLeft(pad));
              buffer.write(' :');
              var i = 0;
              for (var bits = field[j]; bits > 0; bits >>= 1) {
                buffer.writeIfNotNull(i & maskChunk == 0 ? ' ' : null);
                buffer.writeBit(bits);
                i++;
              }
              while (predicate(i)) {
                buffer.writeIfNotNull(i & maskChunk == 0 ? ' ' : null);
                buffer.write('0');
                i++;
              }
              buffer.writeRepeat(space, ' ');
              buffer.writeln('|');
            }
          }

          ///
          ///
          ///
          if (instance is _FieldParentSpatial2) {
            final mask = instance._mask;
            final spatial1 = instance.spatial1; // hour per day
            final spatial2 = instance.spatial2;
            final pad = '$spatial2'.length + 1;
            final padAfterBits = (spatial1 + 3) ~/ 4 * 4 - spatial1 + 1;

            void fieldFlags2([int l = 0, int pass = 0]) {
              buffer.write('|');
              buffer.writeRepeat(pad + 2, ' ');
              for (var per = 0; per < spatial1; per += 4) {
                buffer.write(' ');
                buffer.write('$per'.padRight(4, ' '));
              }
              buffer.write(' ');
              buffer.write('|');
              buffer.writeln();

              buffer.write('|');
              buffer.writeRepeat(pad + 2, ' ');
              for (var per = 0; per < spatial1; per += 4) {
                buffer.write(' ');
                buffer.write('v');
                buffer.writeRepeat(3, ' ');
              }
              buffer.write(' ');
              buffer.write('|');
              buffer.writeln();

              var bits = field[l] >> pass;
              l++;
              final nextField =
                  field.length == 1
                      ? null
                      : (j, i) {
                        if (i == spatial1) return;
                        if (j * spatial1 + pass + i & mask == 0) {
                          bits = field[l];
                          pass = 0;
                          l++;
                        }
                      };
              for (var j = 0; j < spatial2; j++) {
                buffer.write('|');
                buffer.write('${j + 1}'.padLeft(pad));
                buffer.write(' :');
                var i = 0;
                while (i < spatial1) {
                  if (i % 4 == 0) buffer.write(' ');
                  buffer.writeBit(bits);
                  bits >>= 1;
                  i++;
                  nextField?.call(j, i);
                }
                buffer.writeRepeat(padAfterBits, ' ');
                buffer.writeln('|');
              }
            }

            ///
            ///
            ///
            if (instance is _FieldParentSpatial3) {
              void fieldFlags3() {
                final space = spatial1 * spatial2;
                final spatial3 = instance.spatial3;
                final sizeEach = _sizeEach;
                for (var k = 0; k < spatial3; k++) {
                  final start = k * space;
                  fieldFlags2(start ~/ sizeEach, start % sizeEach);
                  if (k < spatial3 - 1) {
                    buffer.write('\\');
                    buffer.write('${k + 1}/'.padLeft(borderLength - 1, '-'));
                    buffer.writeln();

                    buffer.write('/${k + 2}'.padRight(borderLength - 1, '-'));
                    buffer.write('\\');
                    buffer.writeln();
                  }
                }
              }

              ///
              ///
              ///
              if (instance is _FieldParentSpatial4) {
                buffer.writeRepeat(borderLength, '==');
                buffer.writeRepeat(borderLength, '==');
                throw UnimplementedError();
              } else {
                fieldFlags3();
              }
            } else {
              fieldFlags2();
            }
          } else {
            fieldFlags1();
          }

          ///
          ///
          ///
        } else if (instance is FieldDatesInMonths) {
          final field = instance._field;
          final december = DateTime.december;
          final daysOf = DateTimeExtension.monthDaysOf;
          final begin = instance.begin;
          var year = begin.$1;
          var month = begin.$2;

          final limit = field.length;
          for (var j = 0; j < limit; j++) {
            buffer.write('|');
            buffer.write('($year'.padLeft(6));
            buffer.write(',');
            buffer.write('$month)'.padLeft(4));
            buffer.write(' :');
            buffer.write(' ');
            buffer.writeBitsOfMonth(field[j], daysOf(year, month));
            buffer.writeln(' |');
            month++;
            if (month > december) {
              month = 1;
              year++;
            }
          }

          ///
          ///
          ///
        } else if (instance is FieldAB) {
          final field = instance._field;
          final shift = instance._shift;
          final mask = instance._mask;
          final division = instance.bDivision;
          final hoursPerLine = switch (division) {
            1 => 6,
            2 || 3 => 4,
            _ => 3,
          };
          final size = hoursPerLine * division;

          final limit = (instance.aLimit - 1) ~/ hoursPerLine;
          var i = 0;
          for (var j = 0; j < limit; j++) {
            final h = j * hoursPerLine;
            buffer.write('|');
            buffer.write('$h'.padLeft(3));
            buffer.write(' ~');
            buffer.write('${h + hoursPerLine - 1}'.padLeft(3));
            buffer.write(' :');
            for (var m = 0; m < size; m++) {
              if (m % division == 0) buffer.write(' ');
              buffer.writeBit(field[i >> shift] >> (i & mask));
              i++;
            }
            buffer.writeln(' |');
          }
        } else {
          throw UnimplementedError();
        }

        ///
        ///
        ///
      } else if (instance is _FlagsParentMapSplay) {
        void flags(
          int pad,
          void Function(int year, int month, TypedDataList<int> values)
          applyField,
        ) {
          for (var entry in instance._map.field.entries) {
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
              applyField(key, keyKey, valueEntry.value);
              buffer.writeln();
            }
          }
        }

        if (instance is FlagsMapDate) {
          flags(
            6,
            (year, month, days) => buffer.writeBitsOfMonth(
              days[0],
              DateTimeExtension.monthDaysOf(year, month),
            ),
          );
        } else if (instance is FlagsMapHourDate) {
          flags(4, (month, day, hours) {
            final size = TypedIntList.sizeEach8;
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
          });
        } else {
          throw UnimplementedError();
        }
      } else {
        throw UnimplementedError();
      }
      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();
      result = buffer.toString();
      return true;
    }());
    return result;
  }
}

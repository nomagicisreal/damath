part of '../typed_data.dart';

///
///
/// [_PFlags]
///   **[_AFieldContainer] for all [_PFlags] concrete children
///   **[_AFieldIdentical]
///   **[_AFieldBits]
///   **[_AFlagsCollapse]
///   **[_AFlagsSet]
///   **[_AFlagsOperatable]
///   |
///   --[FieldParent], [ParentSlot]
///   |   --[Field]
///   |   --[Field2D]
///   |   --[Field3D]
///   |   --[Field4D]
///   |   --[_PFieldScoped]
///   |   |   --[FieldDatesInMonths]
///   |   |
///   |   --[FieldAB]
///   |
///   --[_PFieldMapSplay]
///   |   --[FieldMapDate]
///   |   --[FieldMapHourDate]
///   |
///   --[ParentSlot]
///   |   --[Slot]
///   |
///
///
///
///
/// there are only two functions here: [clear], [toString]
///
sealed class _PFlags {
  const _PFlags();

  ///
  /// clear all flags
  ///
  void clear();

  @override
  String toString() {
    String result = '';

    assert(() {
      final buffer = StringBuffer('$runtimeType field:\n');
      final instance = this;
      if (instance is ParentSlot) {
        final slot = instance._slot;
        final length = slot.length;
        final pad = '$length'.length + 1;
        final list = <String>[];
        for (var i = 0; i < length; i++) {
          list.add('${slot[i]}');
        }
        final padItem = list.reduce(StringExtension.reduceMaxLength).length;
        for (var i = 0; i < length; i++) {
          if (i & 3 == 0) {
            buffer.write('$i'.padLeft(pad));
            buffer.write(' ~');
            buffer.write('${i + 4}'.padLeft(pad));
            buffer.write(' :');
          }
          buffer.write(' ');
          buffer.write('${slot[i]}'.padLeft(padItem));
          i + 1 & 3 == 0 ? buffer.writeln() : buffer.write(',');
        }
        result = buffer.toString();
        return true;
      }
      final borderLength = switch (instance) {
        Field() =>
          3 +
              '${instance.spatial1}'.length * 2 +
              4 +
              (instance._sizeEach + 3 >> 2) * 5 +
              2,
        _AFlagsSpatial2() => // Field2D() || Field3D() || Field4D()
          2 +
              '${instance.spatial2}'.length +
              2 +
              (instance.spatial1 + 3 >> 2) * 5 +
              2,
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
        FieldDatesInMonths() || FieldMapDate() => 15 + 32 + 4 + 2,
        FieldMapHourDate() => 4 + 5 + 3 + 32 + 4 + 2,
        _ => 0,
      };
      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();

      ///
      /// body
      ///
      if (instance is FieldParent) {
        final field = instance._field;
        final sizeEach = instance._sizeEach;
        final _ = switch (instance) {
          Field() || Field2D() || Field3D() || Field4D() => () {
            if (instance is Field) {
              final spatial1 = instance.spatial1;
              final pad = '${sizeEach * field.length}'.length + 1;
              final jLast = field.length - 1;
              final countLastLine = spatial1 & instance._mask;
              final limit = field.length;

              for (var j = 0; j < limit; j++) {
                final start = j * sizeEach;
                late final int space;
                late final String end;
                late final Predicator<int> predicate;
                if (j == jLast && countLastLine != 0) {
                  end = '${spatial1 - 1}';
                  predicate = IntExtension.predicator_additionLess(
                    start,
                    spatial1,
                  );
                  space =
                      1 +
                      (sizeEach >> TypedIntList.shift4) * 5 -
                      countLastLine -
                      (countLastLine + TypedIntList.mask4 >>
                          TypedIntList.shift4);
                } else {
                  end = '${start + sizeEach}';
                  predicate = IntExtension.predicator_less(sizeEach);
                  space = 1;
                }

                buffer.write('|');
                buffer.write('$start'.padLeft(pad));
                buffer.write(' ~');
                buffer.write(end.padLeft(pad));
                buffer.write(' :');
                var i = 0;
                for (var bits = field[j]; bits > 0; bits >>= 1) {
                  buffer.writeIfNotNull(i & 3 == 0 ? ' ' : null);
                  buffer.writeBit(bits);
                  i++;
                }
                while (predicate(i)) {
                  buffer.writeIfNotNull(i & 3 == 0 ? ' ' : null);
                  buffer.write('0');
                  i++;
                }
                buffer.writeRepeat(space, ' ');
                buffer.writeln('|');
              }
              return;
            }

            void fieldFlags2(
              int spatial1,
              int spatial2,
              int mask, [
              int l = 0,
              int pass = 0,
            ]) {
              final pad = '$spatial2'.length + 1;
              final padAfterBits = (spatial1 + 3) ~/ 4 * 4 - spatial1 + 1;

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

            if (instance is Field2D) {
              fieldFlags2(instance.spatial1, instance.spatial2, instance._mask);
              return;
            }

            ///
            ///
            ///
            void fieldFlags3(
              int spatial1,
              int spatial2,
              int spatial3,
              int mask,
            ) {
              final space = spatial1 * spatial2;
              for (var k = 0; k < spatial3; k++) {
                final start = k * space;
                fieldFlags2(
                  spatial1,
                  spatial2,
                  mask,
                  start ~/ sizeEach,
                  start % sizeEach,
                );
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

            if (instance is Field3D) {
              fieldFlags3(
                instance.spatial1,
                instance.spatial2,
                instance.spatial3,
                instance._mask,
              );
              return;
            }

            if (instance is Field4D) {
              buffer.writeRepeat(borderLength, '==');
              buffer.writeRepeat(borderLength, '==');
              throw UnimplementedError();
            }
            throw UnimplementedError();
          }(),
          FieldAB() => () {
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
          }(),
          FieldDatesInMonths() => () {
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
          }(),
        };
      } else if (instance is _PFieldMapSplay) {
        void flags(
          int pad,
          void Function(int y, int m, TypedDataList<int> d) applyField,
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

        final _ = switch (instance) {
          FieldMapDate() => flags(
            6,
            (year, month, days) => buffer.writeBitsOfMonth(
              days[0],
              DateTimeExtension.monthDaysOf(year, month),
            ),
          ),
          FieldMapHourDate() => flags(4, (month, day, hours) {
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
          }),
        };
      } else {
        throw UnimplementedError();
      }

      ///
      ///
      ///
      buffer.writeRepeat(borderLength, '-');
      buffer.writeln();
      result = buffer.toString();
      return true;
    }());
    return result;
  }
}

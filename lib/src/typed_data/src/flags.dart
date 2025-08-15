part of '../typed_data.dart';

///
///
/// [_FlagsParent]
///   **[_FlagsContainer] for all [_FlagsParent] concrete children
///   **[_FlagsOperator]
///   |   --[_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
///   |   --[_MixinFlagsInsertAble]
///   |
///   --[_FieldParent]
///   |   --[_MixinFieldOperatable] for all [_FieldParent] children
///   |   --[_MixinFieldPositionAble] implements [_FlagsOperator]
///   |   |   --[_MixinFieldPositionAbleContainer] implements [_FlagsContainer]
///   |   |
///   |   --[_FieldParentSpatial1] with [_MixinFieldPositionAble]
///   |   |   --[Field]
///   |   |   --[_FieldParentSpatial2]
///   |   |       --[Field2D] with [_MixinFieldPositionAbleContainer]
///   |   |       --[_FieldParentSpatial3]
///   |   |           --[Field3D] with [_MixinFieldPositionAbleContainer]
///   |   |           --[_FieldParentSpatial4]
///   |   |
///   |   --[_FieldParentScope]
///   |   |   --[FieldDatesInMonths]
///   |   |
///   |   --[FieldAB] with [_MixinFieldPositionAbleContainer]
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

///
/// the abstract functions be in [_FlagsContainer], instead of be in [_FieldParent],
/// preventing redundant, ambiguous generic type pass through out many-level inheritance.
///
abstract class _FlagsContainer<T> implements _FlagsParent {
  const _FlagsContainer();

  bool validateIndex(T index);

  bool operator [](T index);

  void operator []=(T index, bool value);
}

///
///
///
///
///
///
abstract class _FieldParent extends _FlagsParent {
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

  @override
  void _toStringFlagsBy(StringBuffer buffer);
}

//
abstract class _FieldParentSpatial1 extends _FieldParent
    with _MixinFieldPositionAble {
  final int width;

  const _FieldParentSpatial1(this.width, super._field);

  @override
  int get _toStringFieldBorderLength =>
      3 + '$width'.length * 2 + 4 + (_sizeEach + 7) ~/ 8 * 9 + 2;

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
    final size = _sizeEach;
    final field = _field;
    final max = width;
    final pad = '${size * field.length}'.length + 1;
    final mask = TypedIntList.mask8;
    final jLast = field.length - 1;

    //
    final limit = _field.length;
    for (var j = 0; j < limit; j++) {
      final start = j * size;
      late final int space;
      late final String end;
      late final Predicator<int> predicate;
      if (j == jLast) {
        end = '$max';
        predicate = IntExtension.predicator_additionLess(start, max);
        final count = max & _mask;
        space = count + 7 ~/ 8 * 8 - count + 1;
      } else {
        end = '${start + size}';
        predicate = IntExtension.predicator_less(size);
        space = 1;
      }

      buffer.write('|');
      buffer.write('${start + 1}'.padLeft(pad));
      buffer.write(' ~');
      buffer.write(end.padLeft(pad));
      buffer.write(' :');
      var i = 0;
      for (var bits = field[j]; bits > 0; bits >>= 1) {
        buffer.writeIfNotNull(i & mask == 0 ? ' ' : null);
        buffer.writeBit(bits);
        i++;
      }
      while (predicate(i)) {
        buffer.writeIfNotNull(i & mask == 0 ? ' ' : null);
        buffer.write('0');
        i++;
      }
      buffer.writeRepeat(space, ' ');
      buffer.write('|');
    }
  }
}

//
abstract class _FieldParentSpatial2 extends _FieldParentSpatial1 {
  final int height;

  const _FieldParentSpatial2(super.width, this.height, super.field);

  @override
  int get _toStringFieldBorderLength =>
      2 + '$height'.length + 2 + (width + 5) ~/ 6 * 7 + 2;

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int i = 0, int pass = 0]) {
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

    //
    final field = _field;
    final mask = _mask;
    final spaceAfterBits = (width + 5) ~/ 6 * 6 - width + 1;

    var bits = field[i] >> pass;
    i++;
    final nextField =
        field.length == 1
            ? null
            : (h, w) {
              if (w == width) return;
              if (h * width + pass + w & mask == 0) {
                bits = field[i];
                pass = 0;
                i++;
              }
            };
    final limit = height;
    for (var h = 0; h < limit; h++) {
      buffer.write('|');
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
      buffer.writeln('|');
    }
  }
}

//
abstract class _FieldParentSpatial3 extends _FieldParentSpatial2 {
  final int depth;

  const _FieldParentSpatial3(
    super.width,
    super.height,
    this.depth,
    super.field,
  );

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int i = 0, int pass = 0]) {
    final depth = this.depth;
    final width = this.width;
    final height = this.height;
    final sizeEach = _sizeEach;
    final borderLength = _toStringFieldBorderLength;
    for (var d = 0; d < depth; d++) {
      final start = d * width * height;
      super._toStringFlagsBy(buffer, start ~/ sizeEach, start % sizeEach);
      if (d < depth - 1) {
        buffer.write('\\');
        buffer.write('${d + 1}/'.padLeft(borderLength - 1, '-'));
        buffer.writeln();

        buffer.write('/${d + 2}'.padRight(borderLength - 1, '-'));
        buffer.write('\\');
        buffer.writeln();
      }
    }
  }
}

// abstract class _FieldParentSpatial4 extends _FieldParentSpatial3 {
//   // final int
//   const _FieldParentSpatial4(super.width, super.height, super.depth, super.field);
//
// }

///
///
///
abstract class _FieldParentScope<T> extends _FieldParent {
  final T begin;
  final T end;

  const _FieldParentScope(this.begin, this.end, super.field);
}

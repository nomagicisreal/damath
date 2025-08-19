part of '../typed_data.dart';

///
/// [_FlagsParent]
///   **[_FlagsContainer] for all [_FlagsParent] concrete children
///   **[_FlagsOperator]
///   |   --[_MixinFlagsOperate8], [_MixinFlagsOperate16], [_MixinFlagsOperate32], [_MixinFlagsOperate64]
///   |   --[_MixinFlagsInsertAble]
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

abstract class _FlagsOperator implements _FlagsParent {
  const _FlagsOperator();

  // int get _shift => math.log(_sizeEach) ~/ math.ln2 - 1;
  int get _shift;

  // int get _mask => ~(1 << _shift);
  int get _mask;
}

abstract class _FlagsIterable<T> implements _FlagsParent {
  const _FlagsIterable();

  T? get flagFirst;

  T? get flagLast;

  void includesRange(T begin, T end);

  void excludesRange(T begin, T end);

  // T? flagsFirstAfter(int position);
  //
  // T? flagsLastBefore(int position);
  //
  // Iterable<T> get flags;
  //
  // Iterable<T> flagsFrom(int position, [bool inclusive = true]);
  //
  // Iterable<T> flagsTo(int position, [bool inclusive = true]);
  //
  // Iterable<T> flagsBetween(int pBegin, int pEnd, [bool inclusive = true]);
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
  final int spatial1;

  const _FieldParentSpatial1(this.spatial1, super._field);

  @override
  int get _toStringFieldBorderLength =>
      3 +
      '$spatial1'.length * 2 +
      4 +
      (_sizeEach + TypedIntList.mask4 >> TypedIntList.shift4) * 5 +
      2;

  @override
  void _toStringFlagsBy(StringBuffer buffer) {
    final size = _sizeEach;
    final field = _field;
    final max = spatial1;
    final pad = '${size * field.length}'.length + 1;
    final jLast = field.length - 1;
    final maskChunk = TypedIntList.mask4;
    final countLastLine = max & _mask;

    //
    final limit = _field.length;
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
}

//
abstract class _FieldSpatialCollapse<S> implements _FieldParentSpatial2 {
  S collapseOn(int index);
}

//
abstract class _FieldParentSpatial2 extends _FieldParentSpatial1 {
  final int spatial2;

  const _FieldParentSpatial2(super.spatial1, this.spatial2, super.field);

  @override
  int get _toStringFieldBorderLength =>
      2 + '$spatial2'.length + 2 + (spatial1 + 3) ~/ 4 * 5 + 2;

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int l = 0, int pass = 0]) {
    final pad = '$spatial2'.length + 1;
    final spatial1 = this.spatial1; // hour per day

    ///
    ///
    ///
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

    ///
    ///
    ///
    final field = _field;
    final mask = _mask;
    final spaceAfterBits = (spatial1 + 3) ~/ 4 * 4 - spatial1 + 1;

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
    final limit = spatial2;
    for (var j = 0; j < limit; j++) {
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
      buffer.writeRepeat(spaceAfterBits, ' ');
      buffer.writeln('|');
    }
  }
}

//
abstract class _FieldParentSpatial3 extends _FieldParentSpatial2 {
  final int spatial3;

  const _FieldParentSpatial3(
    super.spatial1,
    super.spatial2,
    this.spatial3,
    super.field,
  );

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int l = 0, int pass = 0]) {
    final space = spatial1 * spatial2;
    final spatial3 = this.spatial3;
    final sizeEach = _sizeEach;
    final borderLength = _toStringFieldBorderLength;
    for (var k = 0; k < spatial3; k++) {
      final start = k * space;
      super._toStringFlagsBy(buffer, start ~/ sizeEach, start % sizeEach);
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
}

abstract class _FieldParentSpatial4 extends _FieldParentSpatial3 {
  final int spatial4;

  const _FieldParentSpatial4(
    super.spatial1,
    super.spatial2,
    super.spatial3,
    this.spatial4,
    super.field,
  );

  @override
  void _toStringFlagsBy(StringBuffer buffer, [int l = 0, int pass = 0]) {
    final borderLine = _toStringFieldBorderLength;
    buffer.writeRepeat(borderLine, '==');
    super._toStringFlagsBy(buffer, l, pass);
    buffer.writeRepeat(borderLine, '==');
    throw UnimplementedError();
  }
}

///
///
///
abstract class _FieldParentScope<T> extends _FieldParent {
  final T begin;
  final T end;

  const _FieldParentScope(this.begin, this.end, super.field);
}

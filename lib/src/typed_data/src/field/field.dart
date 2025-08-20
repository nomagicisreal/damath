part of '../../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [Field]
/// [Field2D]
/// [Field3D]
/// [Field4D]
///
///
///

///
///
///
abstract class Field extends _PFieldSpatial1
    with
        _MIterableField,
        _MBitsField,
        _MFieldBitsIterable<int>,
        _MFieldOperatable<Field>
    implements _AFlagsContainer<int> {
  factory Field(int width, [bool native = false]) {
    assert(width > 1);
    if (width < TypedIntList.limit8) return _Field8(width);
    if (width < TypedIntList.limit16) return _Field16(width);
    if (width > TypedIntList.sizeEach32 && native) {
      return _Field64(width, TypedIntList.quotientCeil64(width));
    }
    return _Field32(width, TypedIntList.quotientCeil32(width));
  }

  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, spatial1);

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

  @override
  void _ranges(Consumer<int> consume, int begin, int limit) {
    for (var i = begin; i < limit; i++) {
      consume(i);
    }
  }

  Field._(super.spatial1, super._field);
}

///
///
///
abstract class Field2D extends _PFieldSpatial2
    with
        _MIterableFieldIndexable<(int, int)>,
        _MFieldContainerBits<(int, int)>,
        _MFieldBitsIterable<(int, int)>,
        _MFieldOperatable<Field2D>
    implements _AFieldCollapse<Field> {
  factory Field2D(int width, int height, {bool native = false}) {
    assert(width > 1 && height > 1);
    final size = width * height;
    if (size < TypedIntList.limit8) return _Field2D8(width, height);
    if (size < TypedIntList.limit16) return _Field2D16(width, height);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field2D64(width, height, TypedIntList.quotientCeil64(size));
    }
    return _Field2D32(width, height, TypedIntList.quotientCeil32(size));
  }

  @override
  Field collapseOn(int index) {
    assert(index.isRangeClose(1, spatial2));
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1;
    final result = Field(spatial1);
    for (var i = 0; i < spatial1; i++) {
      if (_bitOn(start + i)) result._bitSet(i);
    }
    return result;
  }

  @override
  bool validateIndex((int, int) index) =>
      index.$1.isRangeClose(1, spatial2) &&
      index.$2.isRangeOpenUpper(0, spatial1);

  @override
  int _positionOf((int, int) index) {
    assert(validateIndex(index));
    return (index.$1 - 1) * spatial1 + index.$2;
  }

  @override
  (int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2));
    return (position ~/ spatial1 + 1, position % spatial1);
  }

  @override
  void _ranges(Consumer<int> consume, (int, int) begin, (int, int) limit) {
    var i = begin.$2;
    var j = begin.$1;
    final iLimit = limit.$2;
    final jEnd = limit.$1;
    assert(j <= jEnd);

    final spatial1 = this.spatial1;
    var index = (j - 1) * spatial1 + i;

    // j == jEnd
    if (j == jEnd) {
      assert(i < iLimit);
      for (; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // j < jEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }

    // j == jEnd
    for (i = 0; i < iLimit; i++, index++) {
      consume(index);
    }
  }

  Field2D._(super.spatial1, super.spatial2, super.field);
}

///
///
///
abstract class Field3D extends _PFieldSpatial3
    with
        _MIterableFieldIndexable<(int, int, int)>,
        _MFieldContainerBits<(int, int, int)>,
        _MFieldBitsIterable<(int, int, int)>,
        _MFieldOperatable<Field3D>
    implements _AFieldCollapse<Field2D> {
  factory Field3D(int width, int height, int depth, [bool native = false]) {
    assert(width > 1 && height > 1 && depth > 1);
    final size = width * height * depth;
    if (size < TypedIntList.limit8) return _Field3D8(width, height, depth);
    if (size < TypedIntList.limit16) return _Field3D16(width, height, depth);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field3D64(
        width,
        height,
        depth,
        TypedIntList.quotientCeil64(size),
      );
    }
    return _Field3D32(width, height, depth, TypedIntList.quotientCeil32(size));
  }

  @override
  bool validateIndex((int, int, int) index) =>
      index.$1.isRangeClose(1, spatial3) &&
      index.$2.isRangeClose(1, spatial2) &&
      index.$3.isRangeOpenUpper(0, spatial1);

  @override
  Field2D collapseOn(int index) {
    assert(index.isRangeClose(1, spatial3));
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial2 * spatial1;
    final result = Field2D(spatial1, spatial2);
    for (var j = 0; j < spatial2; j++) {
      final begin = j * spatial1;
      for (var i = 0; i < spatial1; i++) {
        final p = begin + i;
        if (_bitOn(start + p)) result._bitSet(p);
      }
    }
    return result;
  }

  @override
  int _positionOf((int, int, int) index) {
    assert(validateIndex(index));
    return ((index.$1 - 1) * spatial2 + index.$2 - 1) * spatial1 + index.$3;
  }

  @override
  (int, int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    assert(position.isRangeOpenUpper(0, spatial1 * spatial2 * spatial3));
    final p2 = position ~/ spatial1 + 1;
    return (p2 ~/ spatial2 + 1, p2 % spatial2, position % spatial1);
  }

  @override
  void _ranges(
    Consumer<int> consume,
    (int, int, int) begin,
    (int, int, int) limit,
  ) {
    var i = begin.$3;
    var j = begin.$2;
    var k = begin.$1;
    final iLimit = limit.$3;
    final jEnd = limit.$2;
    final kEnd = limit.$1;
    assert(k <= kEnd);

    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    var index = ((k - 1) * spatial2 + j - 1) * spatial1 + i;

    // k == kEnd
    if (k == kEnd) {
      assert(j <= jEnd); // belows is copied from [Field2D]

      // j == jEnd
      if (j == jEnd) {
        assert(i < iLimit);
        for (; i < iLimit; i++, index++) {
          consume(index);
        }
        return;
      }

      // j < jEnd
      for (; i < spatial1; i++, index++) {
        consume(index);
      }
      for (j++; j < jEnd; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }

      // j == jEnd
      for (i = 0; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // k < kEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < spatial2; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (k++; k < kEnd; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }

    // k == kEnd
    for (j = 0; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (i = 0; i < iLimit; i++, index++) {
      consume(index);
    }
  }

  Field3D._(super.spatial1, super.spatial2, super.spatial3, super.field);
}

///
///
///
abstract class Field4D extends _PFieldSpatial4
    with
        _MIterableFieldIndexable<(int, int, int, int)>,
        _MFieldContainerBits<(int, int, int, int)>,
        _MFieldBitsIterable<(int, int, int, int)>,
        _MFieldOperatable<Field4D>
    implements _AFieldCollapse<Field3D> {
  factory Field4D(int s1, int s2, int s3, int s4, [bool native = false]) {
    assert(s1 > 1 && s2 > 1 && s3 > 1 && s4 > 1);
    final size = s1 * s2 * s3 * s4;
    if (size < TypedIntList.limit8) return _Field4D8(s1, s2, s3, s4);
    if (size < TypedIntList.limit16) return _Field4D16(s1, s2, s3, s4);
    if (size > TypedIntList.sizeEach32 && native) {
      return _Field4D64(s1, s2, s3, s4, TypedIntList.quotientCeil64(size));
    }
    return _Field4D32(s1, s2, s3, s4, TypedIntList.quotientCeil32(size));
  }

  @override
  bool validateIndex((int, int, int, int) index) =>
      index.$1.isRangeClose(1, spatial4) &&
      index.$2.isRangeClose(1, spatial3) &&
      index.$3.isRangeClose(1, spatial2) &&
      index.$4.isRangeOpenUpper(0, spatial1);

  @override
  Field3D collapseOn(int index) {
    assert(index.isRangeClose(1, spatial4));
    final spatial3 = this.spatial3;
    final spatial2 = this.spatial2;
    final spatial1 = this.spatial1;
    final start = (index - 1) * spatial1 * spatial2 * spatial3;
    final result = Field3D(spatial1, spatial2, spatial3);
    for (var k = 0; k < spatial3; k++) {
      final b1 = k * spatial2;
      for (var j = 0; j < spatial2; j++) {
        final b2 = j * spatial1;
        for (var i = 0; i < spatial1; i++) {
          final p = b1 + b2 + i;
          if (_bitOn(start + p)) result._bitSet(p);
        }
      }
    }
    return result;
  }

  @override
  int _positionOf((int, int, int, int) index) {
    assert(validateIndex(index));
    return (((index.$1 - 1) * spatial3 + index.$2 - 1) * spatial2 +
                index.$3 -
                1) *
            spatial1 +
        index.$4;
  }

  @override
  (int, int, int, int) _indexOf(int position) {
    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final spatial3 = this.spatial3;
    assert(
      position.isRangeOpenUpper(0, spatial1 * spatial2 * spatial3 * spatial4),
    );
    final p2 = position ~/ spatial1 + 1;
    final p3 = p2 ~/ spatial2 + 1;
    return (
      p3 ~/ spatial3 + 1,
      p3 % spatial3,
      p2 % spatial2,
      position % spatial1,
    );
  }

  @override
  void _ranges(
    Consumer<int> consume,
    (int, int, int, int) begin,
    (int, int, int, int) limit,
  ) {
    var i = begin.$4;
    var j = begin.$3;
    var k = begin.$2;
    var l = begin.$1;
    final iLimit = limit.$4;
    final jEnd = limit.$3;
    final kEnd = limit.$2;
    final lEnd = limit.$1;
    assert(l <= lEnd);

    final spatial1 = this.spatial1;
    final spatial2 = this.spatial2;
    final spatial3 = this.spatial3;
    var index = (((l - 1) * spatial3 + k - 1) * spatial2 + j - 1) + i;

    // l == lEnd
    if (l == lEnd) {
      assert(k <= kEnd); // belows is copied from [_rangeS3From]

      // k == kEnd
      if (k == kEnd) {
        assert(j <= jEnd); // belows is copied from [_rangeS2From]

        // j == jEnd
        if (j == jEnd) {
          assert(i < iLimit);
          for (; i < iLimit; i++, index++) {
            consume(index);
          }
          return;
        }

        // j < jEnd
        for (; i < spatial1; i++, index++) {
          consume(index);
        }
        for (j++; j < jEnd; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }

        // j == jEnd
        for (i = 0; i < iLimit; i++, index++) {
          consume(index);
        }
        return;
      }

      // k < kEnd
      for (; i < spatial1; i++, index++) {
        consume(index);
      }
      for (j++; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
      for (k++; k < kEnd; k++) {
        for (j = 0; j < spatial2; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }
      }

      // k == kEnd
      for (j = 0; j < jEnd; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
      for (i = 0; i < iLimit; i++, index++) {
        consume(index);
      }
      return;
    }

    // l < lEnd
    for (; i < spatial1; i++, index++) {
      consume(index);
    }
    for (j++; j < spatial2; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (k++; k < spatial3; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }
    for (l++; l < lEnd; l++) {
      for (k = 0; k < spatial3; k++) {
        for (j = 0; j < spatial2; j++) {
          for (i = 0; i < spatial1; i++, index++) {
            consume(index);
          }
        }
      }
    }

    // l == lEnd
    for (k = 0; k < kEnd; k++) {
      for (j = 0; j < spatial2; j++) {
        for (i = 0; i < spatial1; i++, index++) {
          consume(index);
        }
      }
    }
    for (j = 0; j < jEnd; j++) {
      for (i = 0; i < spatial1; i++, index++) {
        consume(index);
      }
    }
    for (i = 0; i < iLimit; i++, index++) {
      consume(index);
    }
  }

  Field4D._(
    super.spatial1,
    super.spatial2,
    super.spatial3,
    super.spatial4,
    super.field,
  );
}

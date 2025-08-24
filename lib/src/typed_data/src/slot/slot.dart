part of '../../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [Slot]
/// [Slot2D]
/// [Slot3D]
/// [Slot4D]
///
///
///

///
///
///
class Slot<T> extends _PSlot<T>
    with _MFlagsContainerSpatial1<T?>, _MEquatableSlot<T, Slot<T>> {
  Slot(super.size);

  @override
  int get spatial1 => _slot.length;

  @override
  Slot<T> get newZero => Slot(_slot.length);

  @override
  T? operator [](int index) {
    assert(validateIndex(index));
    return _slot[index];
  }

  @override
  void operator []=(int index, T? value) {
    assert(validateIndex(index));
    _slot[index] = value;
  }
}

class Slot2D<T> extends _PSlot<T>
    with
        _MFlagsContainerSpatial2<T?>,
        _MSlotContainerPositionAble<(int, int), T>,
        _MEquatableSlot<T, Slot2D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;

  Slot2D(this.spatial1, this.spatial2) : super(spatial1 * spatial2);

  Slot2D.from(Field2D field) : this(field.spatial1, field.spatial2);

  @override
  Slot2D<T> get newZero => Slot2D(spatial1, spatial2);
}

class Slot3D<T> extends _PSlot<T>
    with
        _MFlagsContainerSpatial3<T?>,
        _MSlotContainerPositionAble<(int, int, int), T>,
        _MEquatableSlot<T, Slot3D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;

  Slot3D(this.spatial1, this.spatial2, this.spatial3)
    : super(spatial1 * spatial2 * spatial3);

  Slot3D.from(Field3D field)
    : this(field.spatial1, field.spatial2, field.spatial3);

  @override
  Slot3D<T> get newZero => Slot3D(spatial1, spatial2, spatial3);
}

class Slot4D<T> extends _PSlot<T>
    with
        _MFlagsContainerSpatial4<T?>,
        _MSlotContainerPositionAble<(int, int, int, int), T>,
        _MEquatableSlot<T, Slot4D<T>> {
  @override
  final int spatial1;
  @override
  final int spatial2;
  @override
  final int spatial3;
  @override
  final int spatial4;

  Slot4D(this.spatial1, this.spatial2, this.spatial3, this.spatial4)
    : super(spatial1 * spatial2);

  Slot4D.from(Field4D field)
    : this(field.spatial1, field.spatial2, field.spatial3, field.spatial4);

  @override
  Slot4D<T> get newZero => Slot4D(spatial1, spatial2, spatial3, spatial4);
}

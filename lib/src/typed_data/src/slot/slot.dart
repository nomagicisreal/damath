part of '../../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [Slot]
/// [Slot2D] todo
/// [Slot3D]
/// [Slot4D]
///
///
///

///
///
///
class Slot<T> extends _PSlot<T>
    with _MSlotInit<T, Slot<T>>, _MSetSlot<T>
    implements _AFlagsContainer<int, T?> {

  Slot.empty(int size) : super(List.filled(size, null));

  Slot.emptyFrom(FieldParent field)
    : super(List.filled(field.size, null));

  @override
  bool validateIndex(int index) => index.isRangeOpenUpper(0, _slot.length);

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

  @override
  Slot<T> get newZero => Slot.empty(_slot.length);
}

part of '../../typed_data.dart';

///
///
///
/// to know the inheritance detail, see the comment above [_PFlags]
///
/// [SlotDatesInMonths]
///
///

///
///
///
class SlotDatesInMonths<T> extends ParentSlot<T>
    with
        _MFlagsContainerScopedDate<T?>,
        _MFlagsScopedDatePositionDay,
        _MSlotContainerPositionAble<(int, int, int), T>,
        _MSetSlot<(int, int, int), T>,
        _MEquatableSlot<T, SlotDatesInMonths<T>> {
  @override
  final (int, int) begin;
  @override
  final (int, int) end;

  SlotDatesInMonths(this.begin, this.end)
    : assert(
        DateTimeExtension.isValidYearMonthScope(begin, end),
        'invalid date $begin ~ $end',
      ),
      super(begin.daysToDate(end.$1, end.$2));
}

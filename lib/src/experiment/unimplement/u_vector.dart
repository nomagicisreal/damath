///
///
/// this file contains:
///
///
///
part of damath_experiment;

///
/// implement vector in r way
///

// class Vector2 extends Operatable
//     with
//         OperatableDirectable,
//         OperatableComparable<Point>,
//         OperatableScalable,
//         OperatableStepable {
//   double x;
//   double y;
//
//   Vector2(this.x, this.y);
// }

// mixin OperatableComparableData<O extends OperatableComparable<O>>
//     on Operatable {
//   static StateError error() => StateError('no implementation for comparison');
//
//   O compareTo(O other);
//
//   O isEqualTo(covariant O other) => compareTo(other);
//
//   bool operator >(O other) => Comparable.compare(this, other) == 1;
//
//   bool operator <(O other) => Comparable.compare(this, other) == -1;
//
//   bool operator >=(O other) {
//     final value = Comparable.compare(this, other);
//     return value == 1 || value == 0;
//   }
//
//   bool operator <=(O other) {
//     final value = Comparable.compare(this, other);
//     return value == -1 || value == 0;
//   }
// }

///
///
/// this file contains:
///
/// [Operatable]
///   [OperatableComparable]
///   [OperatableScalable]
///   [OperatableStepable]
///   [OperatableComplex]
///
///
///
part of damath_math;

//
abstract class Operatable {
  const Operatable();
}

///
/// directable
///
mixin OperatableDirectable<O> on Operatable {
  Object operator -();

  Object operator +(covariant O other);

  Object operator -(covariant O other);
}

///
/// comparable
///
mixin OperatableComparable<O extends OperatableComparable<O>> on Operatable
    implements Comparable<O> {
  static StateError error() =>
      StateError('no implementation for comparison');

  @override
  int compareTo(O other);

  @override
  bool operator ==(covariant O other) => Comparable.compare(this, other) == 0;

  bool operator >(O other) => Comparable.compare(this, other) == 1;

  bool operator <(O other) => Comparable.compare(this, other) == -1;

  bool operator >=(O other) {
    final value = Comparable.compare(this, other);
    return value == 1 || value == 0;
  }

  bool operator <=(O other) {
    final value = Comparable.compare(this, other);
    return value == -1 || value == 0;
  }
}

///
/// scalable
///
mixin OperatableScalable<O> on Operatable {
  Object operator *(covariant O other);

  Object operator /(covariant O other);

  Object operator %(covariant O other);
}

///
/// stepable
///
mixin OperatableStepable<O> on Operatable {
  Object operator ~/(covariant O other);
}

///
/// complex
///
mixin OperatableComplex<O> on Operatable {
  Object operator &(covariant O other);

  Object operator ^(covariant O other);

  Object operator >>(covariant O other);

  Object operator <<(covariant O other);
}

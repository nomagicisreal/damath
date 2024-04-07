///
///
/// this file contains:
///
/// [Polynomial]
///   * [PolynomialItemDecoration]
///   [PolynomialItem]
///   [PolynomialSetOneUnknown]
///   [PolynomialSet]
/// [PolynomialFunction]
///
///
///
///
part of damath_experiment;

//
sealed class Polynomial 
    with OperatableDirectable<Polynomial>
{
  const Polynomial();
}

///
///
/// item
/// [PolynomialItemDecoration]
/// [PolynomialItem]
///
///
class PolynomialItemDecoration extends Polynomial
    with OperatableComparable<PolynomialItemDecoration> {
  final double coefficient;
  final double exponent;

  PolynomialItemDecoration(this.coefficient, this.exponent);

  @override
  int compareTo(PolynomialItemDecoration other) =>
      exponent.compareTo(other.exponent);

  @override
  PolynomialItemDecoration operator -() {
    throw UnimplementedError();
  }

  @override
  PolynomialItemDecoration operator +(covariant PolynomialItemDecoration other) {
    throw UnimplementedError();
  }

  @override
  PolynomialItemDecoration operator -(covariant PolynomialItemDecoration other) {
    throw UnimplementedError();
  }
}

abstract class PolynomialItem extends Polynomial {
  final String unknown;
  final PolynomialItemDecoration _decoration;

  double get coefficient => _decoration.coefficient;

  double get exponent => _decoration.exponent;

  PolynomialItem(this.unknown, double coefficient, double exponent)
      : _decoration = PolynomialItemDecoration(coefficient, exponent);

  PolynomialItem.constant(double coefficient)
      : unknown = '',
        _decoration = PolynomialItemDecoration(coefficient, 1);

  PolynomialItem.x(double coefficient, double exponent)
      : this('x', coefficient, exponent);

  PolynomialItem.y(double coefficient, double exponent)
      : this('y', coefficient, exponent);

  bool get isPositive => coefficient.isPositive;

  String get valueAbs =>
      '${coefficient.abs()}$unknown${exponent == 1 ? '' : '^$exponent'}';

  @override
  String toString() => '${isPositive ? '+' : '-'} $valueAbs';

  String toStringAsFirst() => isPositive ? valueAbs : toString();

  @override
  bool operator ==(covariant PolynomialItem other) =>
      hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(unknown, coefficient, exponent);

  ///
  /// operators
  ///

// @override
// Polynomial operator +(Polynomial other) => switch (other) {
//       PolynomialItem() => () {
//           final unknownOther = other.unknown;
//           if (unknown == unknownOther) {
//             final exponentOther = other.exponent;
//             return exponent == exponentOther
//                 ? PolynomialItem(
//                     unknown,
//                     coefficient + other.coefficient,
//                     exponent,
//                   )
//                 : PolynomialSetOneUnknown(
//                     unknown,
//                     exponentOther < exponent
//                         ? [other._decoration, _decoration]
//                         : [_decoration, other._decoration],
//                   );
//           }
//
//           throw UnimplementedError();
//         }(),
//       PolynomialSet() => throw UnimplementedError(),
//       PolynomialSetOneUnknown() => throw UnimplementedError(),
//     };
//
// @override
// PolynomialItem operator -(Polynomial other) {
//   throw UnimplementedError();
// }
}

abstract class PolynomialSetOneUnknown extends Polynomial {
  final String unknown;
  final List<PolynomialItemDecoration> decorations;

  PolynomialSetOneUnknown(this.unknown, this.decorations)
      : assert(decorations.iterator.isSorted(true));

  @override
  Polynomial operator +(Polynomial other) {
    throw UnimplementedError();
  }

  @override
  Polynomial operator -(Polynomial other) {
    throw UnimplementedError();
  }
}

abstract class PolynomialSet extends Polynomial {
  final Map<String, List<PolynomialItemDecoration>> items;

  List<PolynomialItemDecoration> _decorationsOf(String unknown) =>
      items[unknown]!;

  List<double> coefficientsOf(String unknown) =>
      _decorationsOf(unknown).mapToList((d) => d.coefficient);

  List<double> exponentsOf(String unknown) =>
      _decorationsOf(unknown).mapToList((d) => d.exponent);

  PolynomialSet(this.items)
      : assert(
          !items.anyValues(
            (decorations) => decorations.iterator.existEqualBy(
              (value) => value.exponent,
            ),
          ),
        );

  String get unknowns => items.joinKeys();

// @override
// String toString() {
//   final buffer = StringBuffer(items.toStringAsFirst());
//   final length = items.length;
//   for (var i = 1; i < length; i++) {
//     buffer.write(items[i]);
//   }
//   return buffer.toString();
// }
//
// PolynomialSet derivative([int dimension = 1]) {
//   throw UnimplementedError();
// }
}

abstract class PolynomialFunction extends Polynomial {
  final String name;
  final PolynomialSet items;

  const PolynomialFunction(this.name, this.items);

  const PolynomialFunction.fOf(this.items) : name = 'f';

  @override
  String toString() => '$name${items.unknowns} = $items';
}

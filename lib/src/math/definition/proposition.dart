///
///
/// this file contains:
/// [Propositioner]
///
/// [PropositionComponent]
///   [Proposition]
///   [PropositionProduct]
///   [PropositionComplex]
///
/// [TruthTable]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of damath_math;
// ignore_for_file: constant_identifier_names

///
/// [Propositioner] enums all the possibility of proposition operation.
/// the names of [conjunction], [disjunction], [exclusiveOr], [implication], [biconditional]
/// comes from the book "Discrete Mathematics and Its Applications", (see https://www.google.com.tw/books/edition/Discrete_Mathematics_and_Its_Application/T_K9tgEACAAJ)
///
/// these operations of [_alwaysFalse], [_alwaysTrue], ...
/// are based on the condition: (T, T), (T, F), (F, T), (F, F). take [_conjunction] for example;
/// because the conjunction table is:
///   (T, T) == T
///   (T, F) == F
///   (F, T) == F
///   (F, F) == F
/// the comment after [_conjunction] definition, 'TFFF', relatively indicates the result above.
///
enum Propositioner {
  alwaysFalse(_alwaysFalse),
  alwaysTrue(_alwaysTrue),
  ignorance(_ignorance),
  ignoranceNot(_ignoranceNot),
  dependence(_dependence),
  dependenceNot(_dependenceNot),
  conjunction(_conjunction),
  conjunctionNot(_conjunctionNot),
  disjunction(_disjunction),
  disjunctionNot(_disjunctionNot),
  implication(_implication),
  implicationNot(_implicationNot),
  implicationInverse(_implicationInverse),
  implicationInverseNot(_implicationInverseNot),
  exclusiveOr(_exclusiveOr),
  biconditional(_biconditional);

  bool call(bool p, bool q) => _operation(p, q);

  final Reducer<bool> _operation;

  const Propositioner(this._operation);

  static bool _alwaysFalse(bool p, bool q) => false; // FFFF
  static bool _alwaysTrue(bool p, bool q) => true; // TTTT
  static bool _ignorance(bool p, bool q) => p; // TTFF
  static bool _ignoranceNot(bool p, bool q) => !p; // FFTT
  static bool _dependence(bool p, bool q) => q; // TFTF
  static bool _dependenceNot(bool p, bool q) => !q; // FTFT
  static bool _conjunction(bool p, bool q) => p && q; // TFFF
  static bool _conjunctionNot(bool p, bool q) => !p || !q; // FTTT
  static bool _disjunction(bool p, bool q) => p || q; // TTTF
  static bool _disjunctionNot(bool p, bool q) => !p && !q; // FFFT
  static bool _implication(bool p, bool q) => !p || q; // TFTT
  static bool _implicationNot(bool p, bool q) => p && !q; // FTFF
  static bool _implicationInverse(bool p, bool q) => p || !q; // TTFT
  static bool _implicationInverseNot(bool p, bool q) => !p && q; // FFTF
  static bool _exclusiveOr(bool p, bool q) => p ^ q; // FTTF
  static bool _biconditional(bool p, bool q) => p == q; // TFFT
}

///
/// proposition component
///
sealed class PropositionComponent {
  const PropositionComponent();

  String get declarative;

  bool get value;

  PropositionComponent operator -(); // negation

  PropositionComponent operate(
    PropositionComponent other,
    Propositioner combine,
  );

  PropositionComponent operator &(PropositionComponent other) =>
      operate(other, Propositioner.conjunction);

  PropositionComponent operator |(PropositionComponent other) =>
      operate(other, Propositioner.disjunction);

  PropositionComponent operator >(PropositionComponent other) =>
      operate(other, Propositioner.implication);

  PropositionComponent operator ^(PropositionComponent other) =>
      operate(other, Propositioner.exclusiveOr);

  PropositionComponent operator +(PropositionComponent other) =>
      operate(other, Propositioner.biconditional);

  PropositionComponent operator <<(PropositionComponent other) =>
      operate(other, Propositioner.ignorance);

  PropositionComponent operator >>(PropositionComponent other) =>
      operate(other, Propositioner.dependence);
}

///
/// Proposition
/// [declarative], [value]
///
///
class Proposition extends PropositionComponent {
  @override
  final String declarative;
  @override
  final bool value;

  const Proposition(this.declarative, this.value);

  @override
  int get hashCode => declarative.hashCode;

  @override
  bool operator ==(covariant Proposition other) => hashCode == other.hashCode;

  @override
  String toString() => "'$declarative' is $value";

  @override
  Proposition operator -() => Proposition(declarative, !value); // negation

  @override
  PropositionProduct operate(
    covariant Proposition other,
    Propositioner combine,
  ) =>
      PropositionProduct(this, combine, other);
}

///
/// Proposition Product
/// [declarative], [value]
/// [p], [q], [reduce]
///
///
class PropositionProduct extends PropositionComponent {
  @override
  final bool value;
  final Proposition p;
  final Proposition q;
  final Propositioner reduce;

  @override
  String get declarative => '${reduce.name}[($p), ($q)]';

  PropositionProduct(this.p, this.reduce, this.q)
      : value = reduce(p.value, q.value);

  @override
  int get hashCode => Object.hash(p.hashCode, q.hashCode, reduce.hashCode);

  @override
  bool operator ==(covariant Proposition other) => hashCode == other.hashCode;

  @override
  String toString() => "$declarative == $value";

  @override
  PropositionProduct operator -() => PropositionProduct(-p, reduce, -q);

  @override
  PropositionComponent operate(
    PropositionComponent other,
    Propositioner combine,
  ) =>
      PropositionComplex([p, q, other], [reduce, combine]);
}

///
///
/// Proposition Complex
/// [declarative], [value]
/// [components], [operations]
///
///
class PropositionComplex extends PropositionComponent {
  ///
  /// but for [PropositionComponent],
  /// [operations] cannot record computed-hidden [value] for each operation
  ///
  final Iterable<PropositionComponent> components;
  final Iterable<Propositioner> operations;

  @override
  String get declarative => components
      .reduceFrom(
        (p) => StringBuffer(p.declarative),
        (buffer, p) => buffer
          ..write('\n')
          ..write(p is PropositionComplex ? '\t' : '')
          ..write(p.declarative),
      )
      .toString();

  @override
  bool get value => components.intersectionReduceTo(
        operations,
        (p) => p.value,
        (oldValue, value, reduce) => reduce(oldValue, value),
      );

  PropositionComplex(this.components, this.operations)
      : assert(operations.length + 1 == components.length);

  // static String diagramBatch(
  //   PropositionComponent component,
  // ) =>
  //     switch (component) {
  //       Proposition() => throw UnimplementedError(),
  //       PropositionProduct() => throw UnimplementedError(),
  //       PropositionComplex() => diagram(component),
  //     };
  //
  // static String diagram(
  //   PropositionComplex complex,
  // ) {
  //   final batches = complex.components.map(diagramBatch);
  //   throw UnimplementedError();
  // }

  @override
  String toString() => throw UnimplementedError();

  @override
  PropositionComplex operator -() =>
      PropositionComplex(components.map((p) => -p), operations);

  @override
  PropositionComplex operate(
    PropositionComponent other,
    Propositioner combine,
  ) =>
      PropositionComplex([...components, other], [...operations, combine]);

  ///
  ///
  ///
  /// others
  ///
  ///
  ///

  ///
  /// [forEachProposition]
  /// [forEachOperation]
  ///
  void forEachProposition(Consumer<PropositionComponent> consumer) {
    for (var component in components) {
      consumer(component);
    }
  }

  void forEachOperation(Consumer<Propositioner> consumer) {
    for (var component in operations) {
      consumer(component);
    }
  }

  ///
  /// [foldPropositions]
  ///
  S foldPropositions<S>(
    S initialValue,
    Companion<S, PropositionComponent> combine,
  ) =>
      components.fold(initialValue, (v, component) => combine(v, component));

  ///
  /// [declarativesSet]
  /// [propositionsSet]
  ///
  Set<String> get declarativesSet => foldPropositions(
        {},
        (set, p) => switch (p) {
          Proposition() => set..add(p.declarative),
          PropositionProduct() => set
            ..add(p.p.declarative)
            ..add(p.q.declarative),
          PropositionComplex() => set..addAll(declarativesSet),
        },
      );

  Set<Proposition> get propositionsSet => foldPropositions(
        {},
        (set, p) => switch (p) {
          Proposition() => set..add(p),
          PropositionProduct() => set
            ..add(p.p)
            ..add(p.q),
          PropositionComplex() => set..addAll(propositionsSet),
        },
      );

  ///
  /// [updateAll]
  ///
  void updateAll(String declarative, bool value) {
    throw UnimplementedError();
  }
  
  TruthTable get truthTable {
    // final table = TruthTable(declaratives, result);
    throw UnimplementedError();
  }
}

///
/// [result] is computed by [declaratives] in binary. for example,
///   [declaratives] = ['sun rise', 'sky shine', 'stay high']
///   results is computed by:
///     'sun rise' == true, 'sky shine' == true, 'stay high' == true
///     'sun rise' == true, 'sky shine' == true, 'stay high' == false
///     'sun rise' == true, 'sky shine' == false, 'stay high' == true
///     'sun rise' == true, 'sky shine' == false, 'stay high' == false
///     'sun rise' == false, 'sky shine' == true, 'stay high' == true
///     'sun rise' == false, 'sky shine' == true, 'stay high' == false
///     'sun rise' == false, 'sky shine' == false, 'stay high' == true
///     'sun rise' == false, 'sky shine' == false, 'stay high' == false
///
///
class TruthTable {
  final Set<String> declaratives;
  final int _result;

  num get nCol => declaratives.length;

  num get nRow => declaratives.length.powBy(2);

  Iterable<bool> get result {
    final result = <bool>[];

    final length = nRow;
    var value = _result;
    for (var i = 0; i < length; i++) {
      result.add(value.isEven);
      value >>= 1;
    }
    return result;
  }

  const TruthTable(this.declaratives, this._result);

  factory TruthTable.fromComplex(PropositionComplex complex) {
    throw UnimplementedError();
    // final declaratives = complex.declarativesSet;
    // final children = declaratives.mapToMap((declarative) => true);
    //
    // var operations = complex.operations;
    // var value = 0;
    // final length = declaratives.length.powBy(2);
    // for (var i = 0; i < length; i++) {
    //   value += complex.value ? 1 : 0;
    //   value <<= 1;
    //   // result = PropositionResult(p, operations);
    // }
    // return TruthTable._(declaratives, value);
  }
}

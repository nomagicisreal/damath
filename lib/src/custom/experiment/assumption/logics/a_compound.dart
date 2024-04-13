///
/// this file contains:
///
/// all the proposition and proof starts with definition:
/// [Definition] ?
/// ------------------------------------------------------------------------------------------------------
///
/// [Propositioner]
///
/// [PropositionComponent]
///   [Proposition]
///   [Proposition2]
///   [PropositionCompound]
///
///
/// [SetPropositionExtension]
/// [SetProposition2Extension]
/// [SetPropositionCompoundExtension]
///
/// [PropositionEquivalenceLaw], ...
/// [PropositionRulesInference], ...
///
part of damath_assumption;

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

  ///
  /// [truthTable] is computed in binary.
  /// See Also:
  ///   [Proposition.truthTable]
  ///   [Proposition2.truthTable]
  ///   [PropositionCompound.truthTable]
  ///
  Iterable<bool> get truthTable;

  PropositionComponent operator -(); // negation

  PropositionComponent operate(
      PropositionComponent other, Propositioner fusion);

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

  bool isConsistentWithin(Set<PropositionComponent> other);
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

  @override
  Iterable<bool> get truthTable => const [true, false];

  const Proposition(this.declarative, this.value);

  @override
  int get hashCode => Object.hash(declarative.hashCode, value.hashCode);

  @override
  bool operator ==(covariant Proposition other) => hashCode == other.hashCode;

  @override
  String toString() => "'$declarative' is $value";

  @override
  Proposition operator -() => Proposition(declarative, !value); // negation

  @override
  Proposition2 operate(
    covariant Proposition other,
    Propositioner fusion,
  ) =>
      Proposition2(this, fusion, other);

  @override
  bool isConsistentWithin(covariant Set<Proposition> other) =>
      other.isConsistent && {this, ...other}.isConsistent;
}

///
/// Proposition Product
/// [declarative], [value]
/// [p], [q], [reduce]
///
///
class Proposition2 extends PropositionComponent {
  @override
  final bool value;
  final Proposition p;
  final Proposition q;
  final Propositioner reduce;

  @override
  Iterable<bool> get truthTable => [
        reduce(true, true),
        reduce(true, false),
        reduce(false, true),
        reduce(false, false),
      ];

  @override
  String get declarative => '${reduce.name}[($p), ($q)]';

  Proposition2(this.p, this.reduce, this.q) : value = reduce(p.value, q.value);

  @override
  int get hashCode => Object.hash(p.hashCode, q.hashCode, reduce.hashCode);

  @override
  bool operator ==(covariant Proposition other) => hashCode == other.hashCode;

  @override
  String toString() => "$declarative == $value";

  @override
  Proposition2 operator -() => Proposition2(-p, reduce, -q);

  @override
  PropositionCompound operate(
    PropositionComponent other,
    Propositioner fusion,
  ) =>
      PropositionCompound([p, q, other], [reduce, fusion]);

  @override
  bool isConsistentWithin(covariant Set<Proposition2> other) {
    if (!other.isConsistent) return false;
    final p = this.p;
    final q = this.q;
    return {
      p,
      q,
      ...other.iterator.mapWhereExpand(
        (product) =>
            product.p == p ||
            product.p == q ||
            product.q == p ||
            product.q == q,
        (product) sync* {
          yield product.p;
          yield product.q;
        },
      )
    }.isConsistent;
  }

  Proposition2 copyWith({
    Proposition? p,
    Proposition? q,
    Propositioner? reduce,
  }) =>
      Proposition2(p ?? this.p, reduce ?? this.reduce, q ?? this.q);
}

///
///
/// [_components], [_operations]
/// [declarative], [value]
///
/// [truthTable], [isTautology]
///
/// [forEachProposition], [forEachOperation]
/// [update]
/// [propositionsSet], [declarativesSet]
///
class PropositionCompound extends PropositionComponent {
  final List<PropositionComponent> _components;
  final List<Propositioner> _operations;

  PropositionCompound(this._components, this._operations)
      : assert(() {
          // every propositions having same 'declarative', must have same 'value'
          final ps = _components.iterator.groupBy((p) => p.declarative).values;
          for (var list in ps) {
            print(list);
            // if (list.iterator.existDifferent) return false;
          }

          return _operations.length + 1 == _components.length;
        }());

  ///
  /// [declarative]
  /// [value]
  ///
  @override
  String get declarative => _components.iterator
      .reduceToInitialized(
        (p) => StringBuffer(p.declarative),
        (buffer, p) => buffer
          ..write('\n')
          ..write(p is PropositionCompound ? '\t' : '')
          ..write(p.declarative),
      )
      .toString();

  @override
  bool get value => _components.iterator.leadThenInterFold(
        0,
        (p) => p.value,
        _operations.iterator,
        (value, p, fusion) => fusion(value, p.value),
      );

  @override
  int get hashCode => declarative.hashCode;

  @override
  bool operator ==(covariant PropositionCompound other) =>
      hashCode == other.hashCode;

  ///
  /// [truthTable]
  ///

  ///
  /// [truthTable] for example, let [declarativesSet] = {'sun rise', 'sky shine', 'stay high'}
  ///   [truthTable] comes from [_operations] respectively to the order below:
  ///     'sun rise' == true, 'sky shine' == true, 'stay high' == true
  ///     'sun rise' == true, 'sky shine' == true, 'stay high' == false
  ///     'sun rise' == true, 'sky shine' == false, 'stay high' == true
  ///     'sun rise' == true, 'sky shine' == false, 'stay high' == false
  ///     'sun rise' == false, 'sky shine' == true, 'stay high' == true
  ///     'sun rise' == false, 'sky shine' == true, 'stay high' == false
  ///     'sun rise' == false, 'sky shine' == false, 'stay high' == true
  ///     'sun rise' == false, 'sky shine' == false, 'stay high' == false
  /// just the way binary code goes.
  ///
  /// see also [IteratorBool]
  ///
  @override
  Iterable<bool> get truthTable {
    // final declaratives = declarativesSet;
    // final propositions = declaratives.map((d) => null);
    throw UnimplementedError();
  }

  ///
  /// [toString]
  /// [operate], ...
  ///

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
  PropositionCompound operator -() =>
      PropositionCompound(_components.mapToList((p) => -p), _operations);

  @override
  PropositionCompound operate(
    PropositionComponent other,
    Propositioner fusion,
  ) =>
      PropositionCompound([..._components, other], [..._operations, fusion]);

  @override
  bool isConsistentWithin(covariant Set<PropositionCompound> other) {
    if (!other.isConsistent) return false;
    final set = propositionsSet;
    return {
      ...set,
      ...other.iterator.mapWhereExpand(
        (value) => set.any((p) => value.propositionsSet.contains(p)),
        (value) => value.propositionsSet,
      ),
    }.isConsistent;
  }

  ///
  ///
  ///
  /// others
  /// [forEachProposition], [forEachOperation]
  /// [update]
  ///
  /// [_foldPropositionsToSet]
  /// [propositionsSet]
  /// [declarativesSet]
  ///
  ///

  ///
  /// [forEachProposition]
  /// [forEachOperation]
  ///
  void forEachProposition(Consumer<Proposition> consumer) {
    void v;
    for (var component in _components) {
      v = switch (component) {
        Proposition() => consumer(component),
        Proposition2() => () {
            consumer(component.p);
            consumer(component.q);
          }(),
        PropositionCompound() => component.forEachProposition(consumer),
      };
    }
    return v;
  }

  void forEachOperation(Consumer<Propositioner> consumer) {
    for (var component in _operations) {
      consumer(component);
    }
  }

  ///
  /// [update]
  ///
  void update(String declarative, bool toValue) {
    void v;
    for (var i = 0; i < _components.length; i++) {
      final component = _components[i];
      v = switch (component) {
        Proposition() => () {
            if (component.declarative == declarative) {
              _components[i] = Proposition(declarative, toValue);
            }
          }(),
        Proposition2() => () {
            final pO = component.p;
            final qO = component.q;
            final pN = pO.declarative == declarative
                ? Proposition(declarative, toValue)
                : pO;
            final qN = qO.declarative == declarative
                ? Proposition(declarative, toValue)
                : qO;
            if (pN != pO || qN != qO) {
              _components[i] = component.copyWith(p: pN, q: qN);
            }
          }(),
        PropositionCompound() => component.update(declarative, toValue),
      };
    }
    return v;
  }

  ///
  /// [_foldPropositionsToSet]
  ///
  Set<K> _foldPropositionsToSet<K>(
    Mapper<Proposition, K> toK,
    Mapper<PropositionCompound, Set<K>> toKSet,
  ) =>
      _components.fold(
        {},
        (set, component) => switch (component) {
          Proposition() => set..add(toK(component)),
          Proposition2() => set
            ..add(toK(component.p))
            ..add(toK(component.q)),
          PropositionCompound() => set..addAll(toKSet(component)),
        },
      );

  ///
  /// [propositionsSet]
  /// [declarativesSet]
  ///
  Set<Proposition> get propositionsSet => _foldPropositionsToSet(
        FKeep.applier,
        (value) => value.propositionsSet,
      );

  Set<String> get declarativesSet => _foldPropositionsToSet(
        (p) => p.declarative,
        (complex) => complex.declarativesSet,
      );
}

///
///
///
///
/// extensions
///
///
///
///
///

extension SetPropositionExtension on Set<Proposition> {
  bool get isConsistent => consistentBy((p) => p.declarative, (p) => p.value);
}

extension SetProposition2Extension on Set<Proposition2> {
  bool get isConsistent => iterator.fold<Set<Proposition>>(
      {},
      (set, value) => set
        ..add(value.p)
        ..add(value.q)).isConsistent;
}

extension SetPropositionCompoundExtension on Set<PropositionCompound> {
  bool get isConsistent => iterator.fold<Set<Proposition>>(
        {},
        (set, compound) => set..addAll(compound.propositionsSet),
      ).isConsistent;
}

///
///
///
///
///
///
///
///
/// unimplement
///
///
///
///
///
///
///

// p.29
enum PropositionEquivalenceLaw {
  identity,
  domination,
  idempotent,
  doubleNegation,
  commutative,
  associative,
  distributive,
  deMorgans,
  absorption,
  negation
} // ... conditional, biconditional,
// p.34 n-Queens problem (find out all the position for all the people in the society)
// p.35 sudoku problem (find out relative position for all the people in the society)

// p.76
enum PropositionRulesInference {
  modusPonens,
  modusTollens,
  hypotheticalSyllogism,
  disjunctiveSyllogism,
  addition,
  simplification,
  conjunction,
  resolution,
}

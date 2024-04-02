///
///
///
/// this file contains:
///
/// [VertexAncestor]
///   [VertexNullable]
///   [Vertex]
///     [Node]
///     [NodeBinary]
///       [NodeBinaryAvl]
///       [NodeBinarySet]
///     [NodeTree]
///
///   [VertexComparable]
///
///
/// [EdgeAncestor]
///   [EdgeNullable]
///   [Edge]
///   * [EdgeBidirectionalAncestor]
///     [EdgeBidirectionalNullable]
///     [EdgeBidirectional]
///
///
/// [IterableEdgeExtension]
///
///
///
part of damath_experiment;


///
/// [VertexAncestor]
///   [VertexNullable]
///   [Vertex]
///   [VertexComparable]
///
///

sealed class VertexAncestor<T> {
  T data;

  VertexAncestor(this.data);

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant VertexAncestor<T> other) =>
      hashCode == other.hashCode;
}

//
class VertexNullable<T> extends VertexAncestor<T?> {
  VertexNullable(super.data);

  @override
  String toString() => 'VertexNullable($data)';
}

//
class Vertex<T> extends VertexAncestor<T> {
  Vertex(super.data);

  @override
  String toString() => 'Vertex($data)';
}

//
class VertexComparable<T extends Comparable> extends Operatable
    with OperatableComparable<VertexComparable<T>>
    implements VertexAncestor<T> {
  @override
  T data;

  VertexComparable(this.data);

  @override
  String toString() => 'VertexComparable($data)';

  @override
  int compareTo(VertexComparable<T> other) => data.compareTo(other.data);
}

///
///
/// [Node]
/// [NodeBinary]
/// [NodeBinaryAvl]
/// [NodeTree]
///
///

///
/// [data], [another]
///
/// [isLinked], [isNotLinked]
/// [toStringLinked], [toString]
/// [link], [linkIfNull], [linkData], [linkDataIfNull]
///
///
class Node<T> extends Vertex<T> {
  Node<T>? another;

  Node(super.data, [this.another]);

  Node.fromData(super.data, [T? another])
      : another = another.nullOrMap((value) => Node(value));

  ///
  /// [isLinked]
  /// [isNotLinked]
  ///
  bool get isLinked => another != null;

  bool get isNotLinked => another == null;

  String toStringLinked([String prefix = '']) {
    final another = this.another;
    return another == null
        ? '$prefix$data'
        : '$prefix$data${another.toStringLinked('--')}';
  }

  @override
  String toString() => 'Node: ${toStringLinked()}';

  ///
  /// [link]
  /// [linkIfNull]
  /// [linkData]
  /// [linkDataIfNull]
  ///
  void link(Node<T> other) => another = other;

  void linkIfNull(Node<T> other) => another ??= other;

  void linkData(T data) => another = Node(data);

  void linkDataIfNull(T data) => another ??= Node(data);
}

///
/// [data], [left], [right]
///
/// static methods:
/// [stringDiagramOf]
///
/// instance getters, methods:
/// [iterateFromLeftToRight], [iterateFromRightToLeft]
/// [traversalFromLeftToRight], [traversalFromRightToLeft]
/// [climbFromLeftToRight], [climbFromRightToLeft]
/// [leftest], [rightest]
/// [depthLeft], [depthRight], [depth], [height]
/// [relativeNodes]
/// [any], [contains]
/// [everyDifferent]
///
///
class NodeBinary<T> extends Vertex<T> {
  NodeBinary<T>? left;
  NodeBinary<T>? right;

  NodeBinary(super.data, {this.left, this.right});

  NodeBinary.fromData(super.data, {T? left, T? right})
      : left = left.nullOrMap((value) => NodeBinary(value)),
        right = right.nullOrMap((value) => NodeBinary(value));

  static String stringDiagramOf<E>(
      NodeBinary<E>? node, [
        String bottom = '',
        String root = '',
        String top = '',
      ]) =>
      node == null
          ? '${root.replaceFirst('=', '')}\n'
          : (
      StringBuffer()
        ..write(stringDiagramOf(
          node.left,
          '$top| ',
          '$top =',
          '$top  ',
        ))
        ..write('$root${node.data}\n')
        ..write(stringDiagramOf(
          node.right,
          '$bottom  ',
          '$bottom =',
          '$bottom| ',
        )),
      ).toString();

  @override
  String toString() => stringDiagramOf(this);

  ///
  ///
  /// [iterateFromLeftToRight], [iterateFromRightToLeft]
  /// [traversalFromLeftToRight], [traversalFromRightToLeft]
  /// [climbFromLeftToRight], [climbFromRightToLeft]
  ///
  ///
  void iterateFromLeftToRight(Consumer<T> consume) {
    left?.iterateFromLeftToRight(consume);
    consume(data);
    right?.iterateFromLeftToRight(consume);
  }

  void iterateFromRightToLeft(Consumer<T> consume) {
    right?.iterateFromRightToLeft(consume);
    consume(data);
    left?.iterateFromRightToLeft(consume);
  }

  void traversalFromLeftToRight(Consumer<T> consume) {
    consume(data);
    left?.iterateFromLeftToRight(consume);
    right?.iterateFromLeftToRight(consume);
  }

  void traversalFromRightToLeft(Consumer<T> consume) {
    consume(data);
    right?.iterateFromRightToLeft(consume);
    left?.iterateFromRightToLeft(consume);
  }

  void climbFromLeftToRight(Consumer<T> consume) {
    left?.iterateFromLeftToRight(consume);
    right?.iterateFromLeftToRight(consume);
    consume(data);
  }

  void climbFromRightToLeft(Consumer<T> consume) {
    left?.iterateFromRightToLeft(consume);
    right?.iterateFromRightToLeft(consume);
    consume(data);
  }

  ///
  /// [leftest], [rightest]
  /// [depthLeft], [depthRight], [depth], [height]
  ///
  NodeBinary<T> get leftest => left?.leftest ?? this;

  NodeBinary<T> get rightest => right?.rightest ?? this;

  int get depthLeft {
    final left = this.left;
    return left == null ? 0 : 1 + left.depth;
  }

  int get depthRight {
    final right = this.right;
    return right == null ? 0 : 1 + right.depth;
  }

  int get depth => math.max(depthLeft, depthRight);

  int get height => depth + 1; // + current node

  ///
  /// [relativeNodes]
  /// [any], [contains]
  /// [everyDifferent]
  ///
  List<T> get relativeNodes {
    final list = <T>[];
    iterateFromLeftToRight(list.add);
    return list;
  }

  bool any(Predicator<T> test) {
    try {
      iterateFromLeftToRight((value) {
        if (test(value)) throw DamathException(DamathException.pass);
      });
    } on DamathException catch (e) {
      return e.message == DamathException.pass;
    }
    return false;
  }

  bool contains(T element) => any((a) => a == element);

  bool get everyDifferent {
    final values = this.relativeNodes;
    return values.toSet().length == values.length;
  }
}

///
/// [data], [left], [right], ...
///
/// instance getters, methods:
/// [balanceFactor]
/// [balance]
/// [rotateLeft], [rotateRight]
/// [rotateLeftRight], [rotateRightLeft]
///
///
class NodeBinaryAvl<T> extends NodeBinary<T> {
  @override
  NodeBinaryAvl<T>? get left => super.left as NodeBinaryAvl<T>?;

  @override
  NodeBinaryAvl<T>? get right => super.right as NodeBinaryAvl<T>?;

  NodeBinaryAvl(super.data,
      {NodeBinaryAvl<T>? super.left, NodeBinaryAvl<T>? super.right});

  NodeBinaryAvl.fromData(super.data, {super.left, super.right})
      : super.fromData();

  ///
  /// because [depthLeft] >= 0, [depthRight] >= 0,
  /// if [balanceFactor] == 2, [depthLeft] >=2, which indicates [left] != null
  /// if [balanceFactor] == -2, [depthRight] >=2, which indicates [right] != null
  ///
  int get balanceFactor => depthLeft - depthRight;

  ///
  /// after balancing, these methods return the balanced root of current node
  ///
  /// [balance]
  /// [rotateLeft], [rotateRight]
  /// [rotateLeftRight], [rotateRightLeft]
  ///
  NodeBinaryAvl<T> balance() => switch (balanceFactor) {
    2 => left!.balanceFactor == -1 ? rotateLeftRight() : rotateRight(),
    -2 => right!.balanceFactor == 1 ? rotateRightLeft() : rotateLeft(),
    _ => this,
  };

  NodeBinaryAvl<T> rotateLeft() {
    final pivot = right!;
    right = pivot.left;
    pivot.left = this;
    return pivot;
  }

  NodeBinaryAvl<T> rotateRight() {
    final pivot = left!;
    left = pivot.right;
    pivot.right = this;
    return pivot;
  }

  NodeBinaryAvl<T> rotateLeftRight() {
    final left = this.left;
    if (left == null) return this;
    this.left = left.rotateLeft();
    return rotateRight();
  }

  NodeBinaryAvl<T> rotateRightLeft() {
    final right = this.right;
    if (right == null) return this;
    this.right = right.rotateRight();
    return rotateLeft();
  }
}

///
///
///
class NodeBinarySet<T> extends NodeBinary<T> {
  NodeBinarySet(super.data, {super.left, super.right})
      : assert(NodeBinary(data, left: left, right: right).everyDifferent);
}

///
/// [children]
/// [isLeaf]
///
/// [add]
/// [forEachData], [forEachNode]
/// [foldData], [foldNode]
/// [whereData], [whereNode]
///
class NodeTree<T> extends Vertex<T> {
  final List<NodeTree<T>> children;

  NodeTree(super.data, this.children);

  ///
  /// [isLeaf]
  ///
  bool get isLeaf => children.isEmpty;

  ///
  /// [add]
  ///
  void add(NodeTree<T> child) => children.add(child);

  ///
  /// [forEachData]
  /// [forEachNode]
  ///
  void forEachData(Consumer<T> consume, [bool breadth = true]) =>
      forEachNode((node) => consume(node.data), breadth);

  void forEachNode(Consumer<NodeTree<T>> consume, [bool breadth = true]) =>
      breadth
          ? _forEachNodeBreadthFirst(consume)
          : _forEachNodeDepthFirst(consume);

  ///
  /// [_forEachNodeDepthFirst]
  /// [_forEachNodeBreadthFirst]
  ///
  void _forEachNodeDepthFirst(Consumer<NodeTree<T>> consume) {
    consume(this);
    for (final child in children) {
      child._forEachNodeDepthFirst(consume);
    }
  }

  void _forEachNodeBreadthFirst(Consumer<NodeTree<T>> consume) {
    consume(this);
    final list = List<NodeTree<T>>.of(children);
    for (var i = 0; i < list.length; i++) {
      final node = list[i];
      consume(node);
      list.addAll(node.children);
    }
  }

  ///
  /// [foldData], [foldNode]
  ///
  F foldData<F>(F initial, Companion<F, T> combine, [bool breadth = true]) {
    var value = initial;
    forEachNode((node) => value = combine(value, node.data), breadth);
    return value;
  }

  F foldNode<F>(
      F initial,
      Companion<F, NodeTree<T>> combine, [
        bool breadth = true,
      ]) {
    var value = initial;
    forEachNode((node) => value = combine(value, node), breadth);
    return value;
  }

  ///
  /// [whereData], [whereNode]
  ///
  List<T> whereData(Predicator<T> test, [bool breadth = true]) =>
      foldData([], (l, data) => test(data) ? (l..add(data)) : l);

  List<NodeTree<T>> whereNode(
      Predicator<NodeTree<T>> test, [
        bool breadth = true,
      ]) =>
      foldNode([], (l, node) => test(node) ? (l..add(node)) : l, breadth);
}

///
///
///
/// [EdgeAncestor]
///   [EdgeNullable]
///   [Edge]
///
///
///

///
/// [_source], [_destination], [weight]
/// [contains], ...
///
sealed class EdgeAncestor<T, S, V extends VertexAncestor<T?>> {
  final V _source;
  final V _destination;
  S weight;

  EdgeAncestor(this._source, this._destination, this.weight);

  String toStringIdentity();

  ///
  /// [contains]
  /// [containsBoth]
  /// [containsData]
  ///
  bool contains(V vertex) => _source == vertex || _destination == vertex;

  bool containsBoth(V source, V destination) =>
      _source == source || _destination == destination;

  bool containsData(T data) =>
      _source.data == data || _destination.data == data;

  MapEntry<V, V> get toVertexEntry => MapEntry(_source, _destination);
}

///
/// static methods:
/// [translateToSource], ...
///
/// instance methods:
///  ...
///
class EdgeNullable<T> extends EdgeAncestor<T, double?, VertexNullable<T>> {
  // EdgeNullable._(super.source, super.destination, super.weight);

  EdgeNullable(T? source, T? destination, [double? weight])
      : super(VertexNullable(source), VertexNullable(destination), weight);

  T? get source => _source.data;

  set source(T? value) => super._source.data = value;

  T? get destination => _destination.data;

  set destination(T? value) => super._destination.data = value;

  @override
  String toStringIdentity() => '$weight:${_source.data}===${_destination.data}';

  @override
  String toString() => 'EdgeNullable(${toStringIdentity()})';

  ///
  /// [translateToSource], [translateToDestination]
  ///
  static VertexNullable<T> translateToSource<T>(EdgeNullable<T> edge) =>
      edge._source;

  static VertexNullable<T> translateToDestination<T>(EdgeNullable<T> edge) =>
      edge._source;
}

///
/// static methods:
/// [translateToSource], ...
///
/// instance methods:
///  ...
///
class Edge<T> extends EdgeAncestor<T, double, Vertex<T>> {
  // Edge._(super.source, super.destination, super.weight);

  Edge(T source, T destination, [double weight = double.infinity])
      : super(Vertex(source), Vertex(destination), weight);

  T get source => _source.data;

  set source(T value) => super._source.data = value;

  T get destination => _destination.data;

  set destination(T value) => super._destination.data = value;

  @override
  String toStringIdentity() => '$weight:${_source.data}===${_destination.data}';

  @override
  String toString() => 'Edge(${toStringIdentity()})';

  ///
  /// [translateToSource], [translateToDestination]
  ///
  static Vertex<T> translateToSource<T>(Edge<T> edge) => edge._source;

  static Vertex<T> translateToDestination<T>(Edge<T> edge) => edge._source;
}

///
///
///
/// [EdgeBidirectionalAncestor]
///   [EdgeBidirectionalNullable]
///   [EdgeBidirectional]
///
///
///
///
///

///
/// [weightReverse]
///
mixin EdgeBidirectionalAncestor<T, S, V extends VertexAncestor<T?>>
on EdgeAncestor<T, S, V> {
  S get weightReverse;

  bool get isBidirectionalEqual => weight == weightReverse;
}

///
///
///
class EdgeBidirectionalNullable<T> extends EdgeNullable<T>
    with EdgeBidirectionalAncestor<T, double?, VertexNullable<T>> {
  @override
  double? weightReverse;

  EdgeBidirectionalNullable(
      super.source,
      super.destination,
      super.weight,
      this.weightReverse,
      );

  @override
  String toString() => 'EdgeBidirectionalNull('
      '${_source.data}==$weight>===<$weightReverse==${_destination.data})';
}

///
///
///
class EdgeBidirectional<T> extends Edge<T>
    with EdgeBidirectionalAncestor<T, double, Vertex<T>> {
  @override
  double weightReverse;

  EdgeBidirectional(
      super.source,
      super.destination,
      super.weight,
      this.weightReverse,
      );

  @override
  String toString() => 'EdgeBidirectional('
      '${_source.data}==$weight>===<$weightReverse==${_destination.data})';
}

///
///
///
/// collection
///
///
///

///
/// [toVertices]
///
extension IterableEdgeExtension<T, S, V extends VertexAncestor<T?>>
on Iterable<EdgeAncestor<T, S, V>> {
  Set<V> get toVertices => fold(
    {},
        (set, edge) => set
      ..add(edge._source)
      ..add(edge._destination),
  );
}

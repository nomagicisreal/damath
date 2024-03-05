///
///
/// this file contains:
///
/// [VertexAncestor]
///   [VertexNullable]
///   [Vertex]
///     [Node]
///     [NodeBinary]
///       [NodeAvl]
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
/// [GraphAncestor]
///   [Graph]
///   [GraphMutable]
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
class VertexComparable<T extends Comparable> extends VertexAncestor<T>
    with ComparableData<T, VertexComparable<T>> {
  VertexComparable(super.data);

  @override
  String toString() => 'VertexComparable($data)';

  @override
  int compareTo(VertexComparable<T> other) => data.compareTo(other.data);
}

///
///
/// [Node]
/// [NodeBinary]
/// [NodeAvl]
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
      : another = another.nullOrTranslate((value) => Node(value));

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
/// [relatives]
/// [any], [contains]
/// [isUniqueInRelatives]
///
///
class NodeBinary<T> extends Vertex<T> {
  NodeBinary<T>? left;
  NodeBinary<T>? right;

  NodeBinary(super.data, {this.left, this.right});

  NodeBinary.fromData(super.data, {T? left, T? right})
      : left = left.nullOrTranslate((value) => NodeBinary(value)),
        right = right.nullOrTranslate((value) => NodeBinary(value));

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
  /// [relatives]
  /// [any], [contains]
  /// [isUniqueInRelatives]
  ///
  List<T> get relatives {
    final list = <T>[];
    iterateFromLeftToRight(list.add);
    return list;
  }

  bool any(Predicator<T> test) {
    const pass = 'pass';
    try {
      iterateFromLeftToRight((value) {
        if (test(value)) throw DamathException(pass);
      });
    } on DamathException catch (e) {
      return e.message == pass;
    }
    return false;
  }

  bool contains(T element) => any((a) => a == element);

  bool get isUniqueInRelatives {
    final values = this.relatives;
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
class NodeAvl<T> extends NodeBinary<T> {
  @override
  NodeAvl<T>? get left => super.left as NodeAvl<T>?;

  @override
  NodeAvl<T>? get right => super.right as NodeAvl<T>?;

  NodeAvl(super.data, {NodeAvl<T>? super.left, NodeAvl<T>? super.right});

  NodeAvl.fromData(super.data, {super.left, super.right}) : super.fromData();

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
  NodeAvl<T> balance() => switch (balanceFactor) {
        2 => left!.balanceFactor == -1 ? rotateLeftRight() : rotateRight(),
        -2 => right!.balanceFactor == 1 ? rotateRightLeft() : rotateLeft(),
        _ => this,
      };

  NodeAvl<T> rotateLeft() {
    final pivot = right!;
    right = pivot.left;
    pivot.left = this;
    return pivot;
  }

  NodeAvl<T> rotateRight() {
    final pivot = left!;
    left = pivot.right;
    pivot.right = this;
    return pivot;
  }

  NodeAvl<T> rotateLeftRight() {
    final left = this.left;
    if (left == null) return this;
    this.left = left.rotateLeft();
    return rotateRight();
  }

  NodeAvl<T> rotateRightLeft() {
    final right = this.right;
    if (right == null) return this;
    this.right = right.rotateRight();
    return rotateLeft();
  }
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
  String toString() =>
      'EdgeNullable($weight:${_source.data}===${_destination.data})';

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

  Edge(T source, T destination, [double weight = 1])
      : super(Vertex(source), Vertex(destination), weight);

  T get source => _source.data;

  set source(T value) => super._source.data = value;

  T get destination => _destination.data;

  set destination(T value) => super._destination.data = value;

  @override
  String toString() => 'Edge($weight:${_source.data}===${_destination.data})';

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
/// [GraphAncestor]
///
///

///
///
/// [vertices], ...
///
/// [edgesFrom], ...
/// [hasCycleOn], ...
/// [_hasCycleOn], ...
///
///
abstract class GraphAncestor<T, S, V extends VertexAncestor<T?>,
    E extends EdgeAncestor<T, S, V>> {
  const GraphAncestor();

  ///
  /// [vertices], [edges], [weights]
  ///
  Iterable<V> get vertices;

  Iterable<E> get edges;

  ///
  /// [vertexGroupsFromEdges]
  /// [destinationsGroupBySources]
  /// [sourcesGroupByDestinations]
  ///
  Map<K, List<D>> vertexGroupsFromEdges<K, D>(
    Translator<E, K> edgeToKey,
    Translator<E, D> edgeToValue,
  ) =>
      edges.fold(
        {},
        (map, edge) => map
          ..update(
            edgeToKey(edge),
            (m) => m..add(edgeToValue(edge)),
            ifAbsent: () => [edgeToValue(edge)],
          ),
      );

  Map<V, List<V>> get destinationsGroupBySources => vertexGroupsFromEdges(
        (value) => value._source,
        (value) => value._destination,
      );

  Map<V, List<V>> get sourcesGroupByDestinations => vertexGroupsFromEdges(
        (value) => value._destination,
        (value) => value._source,
      );

  ///
  /// [containsVertex], [containsEdge]
  /// [weightFrom]
  ///
  bool containsVertex(V vertex) => vertices.contains(vertex);

  bool containsEdge(E edge) => edges.contains(edge);

  S weightFrom(V source, V destination) => edges.firstWhereMap(
        (edge) => edge.containsBoth(source, destination),
        (edge) => edge.weight,
      );

  ///
  /// [edgesFrom], [edgesTo]
  /// [destinationsFrom], [sourcesTo]
  /// [reachablesFrom]
  ///
  Iterable<E> edgesFrom(V source) =>
      edges.where((edge) => edge._source == source);

  Iterable<E> edgesTo(V destination) =>
      edges.where((edge) => edge._destination == destination);

  Iterable<V> destinationsFrom(V source) => edges.whereMap(
        (edge) => edge._source == source,
        (edge) => edge._destination,
      );

  Iterable<V> sourcesTo(V destination) => edges.whereMap(
        (edge) => edge._destination == destination,
        (edge) => edge._source,
      );

  Iterable<V> reachablesFrom(V source, [bool breadth = true]) =>
      breadth ? _searchBreathFirst(source) : _searchDepthFirst(source);

  ///
  /// [hasCycleOn]
  ///
  bool hasCycleOn(V source) => _hasCycleOn(source, []);

  ///
  ///
  /// private implementations:
  ///
  /// [_hasCycleOn]
  /// [_searchBreathFirst]
  /// [_searchDepthFirst]
  ///
  ///

  ///
  /// [_hasCycleOn]
  ///
  bool _hasCycleOn(V source, List<V> pushed) {
    pushed.add(source);
    final result = destinationsFrom(source).any((destination) =>
        pushed.contains(destination) || _hasCycleOn(destination, pushed));
    pushed.remove(source);
    return result;
  }

  ///
  /// [_searchBreathFirst]
  /// [_searchDepthFirst]
  ///
  List<V> _searchBreathFirst(V source) {
    final visited = <V>[source];
    for (var i = 0; i < visited.length; i++) {
      destinationsFrom(visited[i]).conditionalConsume(
        (destination) => visited.notContains(destination),
        (destination) => visited.add(destination),
      );
    }
    return visited;
  }

  List<V> _searchDepthFirst(V source) {
    final visited = <V>[source];
    while (visited.isNotEmpty) {
      destinationsFrom(visited.removeLast()).conditionalConsume(
        (destination) => visited.notContains(destination),
        (destination) => visited.add(destination),
      );
    }
    return visited;
  }
}

//
class Graph<T> extends GraphAncestor<T, double, Vertex<T>, Edge<T>> {
  @override
  final List<Edge<T>> edges;

  @override
  Set<Vertex<T>> get vertices => edges.toVertices;

  const Graph(this.edges);
}

///
/// [createVertex], ...
/// [createEdge], ...
///
abstract class GraphMutable<T, S, V extends VertexAncestor<T>,
E extends EdgeAncestor<T, S, V>> extends GraphAncestor<T, S, V, E> {
  ///
  /// [createVertex], [addVertex]
  /// [createEdge], [addEdge],
  ///

  V createVertex(V vertex);

  V addVertex(V vertex);

  E createEdge(E edge);

  E addEdge(E edge);
}

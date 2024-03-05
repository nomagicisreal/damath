///
///
/// this file contains:
///
/// [Vertex]
///   [VertexComparable]
///
///   [Node]
///   [NodeBinary]
///     [NodeAvl]
///     * [NodeBinarySet]
///   [NodeTree]
///
///
///   * [Edge]
///     * [Graph]
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

///
///
/// [Vertex]
/// [VertexComparable]
///
///

class Vertex<E> {
  final E data;

  Vertex(this.data);

  @override
  String toString() => 'Vertex($data)';

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<E> other) => hashCode == other.hashCode;
}

class VertexComparable<E extends Comparable> extends Vertex<E>
    with ComparableData<E, VertexComparable<E>> {
  VertexComparable(super.data);

  @override
  String toString() => 'VertexComparable($data)';

  @override
  int compareTo(VertexComparable<E> other) => data.compareTo(other.data);
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
class Node<E> extends Vertex<E> {
  Node<E>? another;

  Node(super.data, [this.another]);

  bool get isLinked => another.isNotNull;

  bool get isNotLinked => another.isNull;

  String toStringLinked([String prefix = '']) {
    final another = this.another;
    return another == null
        ? '$prefix$data'
        : '$prefix$data${another.toStringLinked('--')}';
  }

  @override
  String toString() => 'Node: ${toStringLinked()}';

  void link(Node<E> other) => another = other;

  void linkIfNull(Node<E> other) => another ??= other;

  void linkData(E data) => another = Node(data);

  void linkDataIfNull(E data) => another ??= Node(data);
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
/// [values]
/// [any], [contains]
/// [everyIsUnique]
///
///
class NodeBinary<E> extends Vertex<E> {
  NodeBinary<E>? left;
  NodeBinary<E>? right;

  NodeBinary(super.data, {this.left, this.right});

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
  void iterateFromLeftToRight(Consumer<E> consume) {
    left?.iterateFromLeftToRight(consume);
    consume(data);
    right?.iterateFromLeftToRight(consume);
  }

  void iterateFromRightToLeft(Consumer<E> consume) {
    right?.iterateFromRightToLeft(consume);
    consume(data);
    left?.iterateFromRightToLeft(consume);
  }

  void traversalFromLeftToRight(Consumer<E> consume) {
    consume(data);
    left?.iterateFromLeftToRight(consume);
    right?.iterateFromLeftToRight(consume);
  }

  void traversalFromRightToLeft(Consumer<E> consume) {
    consume(data);
    right?.iterateFromRightToLeft(consume);
    left?.iterateFromRightToLeft(consume);
  }

  void climbFromLeftToRight(Consumer<E> consume) {
    left?.iterateFromLeftToRight(consume);
    right?.iterateFromLeftToRight(consume);
    consume(data);
  }

  void climbFromRightToLeft(Consumer<E> consume) {
    left?.iterateFromRightToLeft(consume);
    right?.iterateFromRightToLeft(consume);
    consume(data);
  }

  ///
  /// [leftest], [rightest]
  /// [depthLeft], [depthRight], [depth], [height]
  ///
  NodeBinary<E> get leftest => left?.leftest ?? this;

  NodeBinary<E> get rightest => right?.rightest ?? this;

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
  /// [values]
  /// [any], [contains]
  /// [everyIsUnique]
  ///
  List<E> get values {
    final list = <E>[];
    iterateFromLeftToRight(list.add);
    return list;
  }

  bool any(Predicator<E> test) {
    final pass = 'pass';
    try {
      iterateFromLeftToRight((value) {
        if (test(value)) throw DamathException(pass);
      });
    } on DamathException catch (e) {
      return e.message == pass;
    }
    return false;
  }

  bool contains(E element) => any((a) => a == element);

  bool get everyIsUnique {
    final values = this.values;
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
class NodeAvl<E> extends NodeBinary<E> {
  @override
  NodeAvl<E>? get left => super.left as NodeAvl<E>?;

  @override
  NodeAvl<E>? get right => super.right as NodeAvl<E>?;

  NodeAvl(super.data, {NodeAvl<E>? super.left, NodeAvl<E>? super.right});

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
  NodeAvl<E> balance() => switch (balanceFactor) {
        2 => left!.balanceFactor == -1 ? rotateLeftRight() : rotateRight(),
        -2 => right!.balanceFactor == 1 ? rotateRightLeft() : rotateLeft(),
        _ => this,
      };

  NodeAvl<E> rotateLeft() {
    final pivot = right!;
    right = pivot.left;
    pivot.left = this;
    return pivot;
  }

  NodeAvl<E> rotateRight() {
    final pivot = left!;
    left = pivot.right;
    pivot.right = this;
    return pivot;
  }

  NodeAvl<E> rotateLeftRight() {
    final left = this.left;
    if (left == null) return this;
    this.left = left.rotateLeft();
    return rotateRight();
  }

  NodeAvl<E> rotateRightLeft() {
    final right = this.right;
    if (right == null) return this;
    this.right = right.rotateRight();
    return rotateLeft();
  }
}

///
///
/// [NodeBinarySet]
///
///

///
/// [root]
///
/// [contains]
///
class NodeBinarySet<E> {
  NodeBinary<E> root;

  NodeBinarySet(this.root) : assert(root.everyIsUnique);

  bool contains(E element) => root.contains(element);
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
class NodeTree<E> extends Vertex<E> {
  final List<NodeTree<E>> children;

  NodeTree(super.data, this.children);

  ///
  /// [isLeaf]
  ///
  bool get isLeaf => children.isEmpty;

  ///
  /// [add]
  ///
  void add(NodeTree<E> child) => children.add(child);

  ///
  /// [forEachData]
  /// [forEachNode]
  ///
  void forEachData(Consumer<E> consume, [bool breadth = true]) =>
      forEachNode((node) => consume(node.data), breadth);

  void forEachNode(Consumer<NodeTree<E>> consume, [bool breadth = true]) =>
      breadth
          ? _forEachNodeBreadthFirst(consume)
          : _forEachNodeDepthFirst(consume);

  ///
  /// [_forEachNodeDepthFirst]
  /// [_forEachNodeBreadthFirst]
  ///
  void _forEachNodeDepthFirst(Consumer<NodeTree<E>> consume) {
    consume(this);
    for (final child in children) {
      child._forEachNodeDepthFirst(consume);
    }
  }

  void _forEachNodeBreadthFirst(Consumer<NodeTree<E>> consume) {
    consume(this);
    final list = List<NodeTree<E>>.of(children);
    for (var i = 0; i < list.length; i++) {
      final node = list[i];
      consume(node);
      list.addAll(node.children);
    }
  }

  ///
  /// [foldData], [foldNode]
  ///
  F foldData<F>(F initial, Companion<F, E> combine, [bool breadth = true]) {
    var value = initial;
    forEachNode((node) => value = combine(value, node.data), breadth);
    return value;
  }

  F foldNode<F>(
    F initial,
    Companion<F, NodeTree<E>> combine, [
    bool breadth = true,
  ]) {
    var value = initial;
    forEachNode((node) => value = combine(value, node), breadth);
    return value;
  }

  ///
  /// [whereData], [whereNode]
  ///
  List<E> whereData(Predicator<E> test, [bool breadth = true]) =>
      foldData([], (l, data) => test(data) ? (l..add(data)) : l);

  List<NodeTree<E>> whereNode(
    Predicator<NodeTree<E>> test, [
    bool breadth = true,
  ]) =>
      foldNode([], (l, node) => test(node) ? (l..add(node)) : l, breadth);
}

///
///
/// edge
///
///

///
/// [source], [destination]
///
class Edge<E> {
  Vertex<E>? source;
  Vertex<E>? destination;
  double? weight;

  Edge(this.source, this.destination, this.weight);

  bool contains(Vertex<E> vertex) => source == vertex || destination == vertex;
}

///
///
/// [vertices]
///
/// [createVertex], ...
/// [createEdge], ...
///
/// [edgesFrom], ...
///
/// [hasCycle], ...
///
/// [_hasCycle]
///
///
abstract class Graph<E> {
  ///
  /// [vertices]
  /// [edges]
  ///
  Iterable<Vertex<E>> get vertices;

  Iterable<Edge<E>> get edges;

  ///
  /// [edgesGroupByVertex]
  ///
  Map<Vertex<E>, List<Edge<E>>> get edgesGroupByVertex {
    final map = <Vertex<E>, List<Edge<E>>>{};
    for (var edge in edges) {
      map.updateIfNotNull(
        edge.source,
            (value) => value..add(edge),
        ifAbsent: () => [edge],
      );
      map.updateIfNotNull(
        edge.destination,
            (value) => value..add(edge),
        ifAbsent: () => [edge],
      );
    }
    return map;
  }

  ///
  /// [createVertex]
  /// [containsVertex]
  ///
  Vertex<E> createVertex(E data);

  bool containsVertex(Vertex<E> vertex) => vertices.contains(vertex);

  ///
  /// [createEdge]
  /// [addEdge]
  /// [containsEdge]
  ///
  void createEdge(Edge<E> edge);

  void addEdge(Edge<E> edge);

  bool containsEdge(Edge<E> edge) => edges.contains(edge);

  ///
  /// [edgesFrom]
  /// [destinationsFrom]
  /// [weightFrom]
  ///
  List<Edge<E>> edgesFrom(Vertex<E> source);

  List<Vertex<E>> destinationsFrom(Vertex<E> source);

  double? weightFrom(Vertex<E> source, Vertex<E> destination);

  ///
  /// [searchReachableFrom]
  ///
  List<Vertex<E>> searchReachableFrom(
      Vertex<E> source, [
        bool breadth = true,
      ]) =>
      breadth ? _searchBreathFirst(source) : _searchDepthFirst(source);

  ///
  /// [hasCycle]
  ///
  bool hasCycle(Vertex<E> source) => _hasCycle(source, []);

  ///
  ///
  /// private implementations:
  ///
  /// [_hasCycle]
  /// [_searchBreathFirst]
  /// [_searchDepthFirst]
  ///
  ///

  ///
  /// [_hasCycle]
  ///
  bool _hasCycle(Vertex<E> source, List<Vertex<E>> pushed) {
    pushed.add(source);
    final result = destinationsFrom(source).any((destination) =>
    pushed.contains(destination) || _hasCycle(destination, pushed));
    pushed.remove(source);
    return result;
  }

  ///
  /// [_searchBreathFirst]
  /// [_searchDepthFirst]
  ///
  List<Vertex<E>> _searchBreathFirst(Vertex<E> source) {
    final visited = <Vertex<E>>[source];
    for (var i = 0; i < visited.length; i++) {
      destinationsFrom(visited[i]).conditionalConsume(
            (destination) => visited.notContains(destination),
            (destination) => visited.add(destination),
      );
    }
    return visited;
  }

  List<Vertex<E>> _searchDepthFirst(Vertex<E> source) {
    final visited = <Vertex<E>>[source];
    while (visited.isNotEmpty) {
      destinationsFrom(visited.removeLast()).conditionalConsume(
            (destination) => visited.notContains(destination),
            (destination) => visited.add(destination),
      );
    }
    return visited;
  }
}

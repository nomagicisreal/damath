///
///
/// this file contains:
/// [Vertex]
///   [VertexComparable]
///   [Node]
///     [NodeBinary]
///       [TreeBinary]
///       [TreeBinarySet]
///
/// [EdgeType]
/// [Edge]
///
///
///
/// [IterableEdgeExtension]
/// [SetVertexExtension]
///
///
///
///
///
///
///
///
part of damath;

///
///
///
/// [Vertex]
/// [VertexComparable]
///
///
///

//
class Vertex<T> {
  T data;

  Vertex(this.data);

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(covariant Vertex<T> other) => hashCode == other.hashCode;

  @override
  String toString() => data.toString();
}

//
class VertexComparable<D extends Comparable> extends Vertex<D>
    with ComparableData<D, VertexComparable<D>> {
  VertexComparable(super.data);

  @override
  String toString() => '$data';
}

///
///
///
/// [Node]
/// [NodeBinary]
///
///
///

///
/// [data], [another]
/// [_stringLinked], [toString]
///
/// [isLinked]
/// [link], ...
///
class Node<E> extends Vertex<E> {
  Node<E>? another;

  Node(super.data, this.another);

  String _stringLinked([bool onNext = true]) => onNext ? '--$this' : '$this--';

  @override
  String toString() {
    var linked = this.another;
    return '$data${linked?._stringLinked(true) ?? ''}';
  }

  @override
  int get hashCode => Object.hash(super.hashCode, another?.data.hashCode);

  @override
  bool operator ==(covariant Node<E> other) => hashCode == other.hashCode;

  ///
  /// [isLinked]
  /// [link]
  /// [linkIfAbsent]
  /// [linkIfNotEqualTo]
  ///

  bool get isLinked => another == null;

  Node<E> link(E data) => Node(this.data, Node(data, null));

  Node<E> linkIfAbsent(E data) => Node(this.data, another ?? Node(data, null));

  Node<E> linkIfNotEqualTo(E data) =>
      Node(this.data, another?.data == data ? another : Node(data, null));
}

///
/// [data]
/// [left], [right]
///
/// static methods:
/// [diagramOf], [depthOf]
///
/// instance methods:
/// [iterateFromLeftToRight], [iterateFromRightToLeft]
/// [traversalFromLeftToRight], [traversalFromRightToLeft]
/// [climbFromRightToLeft], [climbFromLeftToRight]
/// [contains], [values],
/// [valuesAreUnique], [size]
/// [leftest], [rightest]
/// [depth], [height]
/// [appendLeftest], ...
/// [updateData], ...
/// [pull]
///
class NodeBinary<E> extends Vertex<E> {
  NodeBinary<E>? left;
  NodeBinary<E>? right;

  NodeBinary(super.data, {this.left, this.right});

  @override
  String toString() => diagramOf(this);

  @override
  int get hashCode =>
      Object.hash(super.hashCode, left.hashCode, right.hashCode);

  @override
  bool operator ==(covariant NodeBinary<E> other) => hashCode == other.hashCode;

  ///
  ///
  /// [depthOf]
  /// [diagramOf]
  ///
  ///

  static int depthOf<E>(NodeBinary<E> node) {
    final left = node.left;
    final right = node.right;
    final depthLeft = left == null ? 0 : (1 + depthOf(left));
    final depthRight = right == null ? 0 : (1 + depthOf(right));
    return math.max(depthLeft, depthRight);
  }

  static String diagramOf<E>(
    NodeBinary<E>? node, [
    String top = '',
    String root = '',
    String bottom = '',
  ]) {
    if (node == null) return '$root null\n';
    if (node.left == null && node.right == null) {
      return '$root${node.data}\n';
    }
    final a = diagramOf(node.right, '$top  ', '$top--', '$top| ');
    final b = '$root${node.data}\n';
    final c = diagramOf(node.left, '$bottom| ', '$bottom--', '$bottom  ');
    return '$a$b$c';
  }

  ///
  /// [iterateFromLeftToRight], [iterateFromRightToLeft]
  /// [traversalFromLeftToRight], [traversalFromRightToLeft]
  /// [climbFromRightToLeft], [climbFromLeftToRight]
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
    left?.traversalFromLeftToRight(consume);
    right?.traversalFromLeftToRight(consume);
  }

  void traversalFromRightToLeft(Consumer<E> consume) {
    consume(data);
    right?.traversalFromRightToLeft(consume);
    left?.traversalFromRightToLeft(consume);
  }

  void climbFromRightToLeft(Consumer<E> action) {
    left?.climbFromRightToLeft(action);
    right?.climbFromRightToLeft(action);
    action(data);
  }

  void climbFromLeftToRight(Consumer<E> action) {
    right?.climbFromLeftToRight(action);
    left?.climbFromLeftToRight(action);
    action(data);
  }

  ///
  /// [contains]
  /// [values]
  /// [valuesAreUnique], [size]
  ///

  bool contains(E element) {
    final s = 'NodeBinary contains element: $element';
    try {
      iterateFromLeftToRight((v) {
        if (v == element) throw DamathException(s);
      });
    } on DamathException catch (e) {
      return e.message == s;
    }
    return false;
  }

  List<E> get values {
    final list = <E>[];
    iterateFromLeftToRight(list.add);
    return list;
  }

  bool get valuesAreUnique {
    final values = this.values;
    return values.toSet().length == values.length;
  }

  int get size {
    int size = 0;
    iterateFromLeftToRight((_) => size++);
    return size;
  }

  ///
  ///
  /// [leftest], [rightest]
  /// [depth], [height]
  ///
  ///
  NodeBinary<E> get leftest => left?.leftest ?? this;

  NodeBinary<E> get rightest => right?.rightest ?? this;

  int get depth => depthOf(this);

  int get height => depth + 1;

  ///
  ///
  /// [appendLeftest]
  /// [appendRightest]
  ///
  ///
  void appendLeftest(NodeBinary<E> node) =>
      left == null ? left = node : left?.appendLeftest(node);

  void appendRightest(NodeBinary<E> node) =>
      right == null ? right = node : right?.appendRightest(node);

  ///
  ///
  /// [updateData]
  /// [updateNode], [updateNodeOnData]
  ///
  ///
  void updateData(E oldData, E newData) {
    left?.updateData(oldData, newData);
    right?.updateData(oldData, newData);
    if (data == oldData) data = newData;
  }

  void updateNode(NodeBinary<E> oldNode, NodeBinary<E> newNode) {
    if (this == oldNode) {
      data = newNode.data;
      left = newNode.left;
      right = newNode.right;
    }
    left?.updateNode(oldNode, newNode);
    right?.updateNode(oldNode, newNode);
  }

  void updateNodeOnData(E data, NodeBinary<E> newNode) {
    if (this.data == data) {
      this.data = newNode.data;
      left = newNode.left;
      right = newNode.right;
    }
    left?.updateNodeOnData(data, newNode);
    right?.updateNodeOnData(data, newNode);
  }

  ///
  /// [pull]
  ///
  E pull([bool fromLeft = true]) {
    final cache = fromLeft ? left : right;
    if (cache == null) {
      throw DamathException(
        'NodeBinary.${fromLeft ? 'left' : 'right'} must not be null',
      );
    }
    final oldData = data;
    data = cache.data;
    final cacheLeft = cache.left;
    final cacheRight = cache.right;

    if (fromLeft) {
      left = cacheLeft;
      if (cacheRight != null) right?.appendLeftest(cacheRight);
    } else {
      right = cacheRight;
      if (cacheLeft != null) left?.appendRightest(cacheLeft);
    }
    return oldData;
  }
}

///
///
///
/// [TreeBinary]
/// [TreeBinarySet]
/// [TreeBinarySetSorted]
///
///
///

///
/// [root]
///
/// [values], [contains]
///
class TreeBinary<E> {
  NodeBinary<E> root;

  TreeBinary(this.root);

  List<E> get values => root.values;

  bool contains(E element) => root.contains(element);
}

///
///
/// [root]
///
///
class TreeBinarySet<E> extends TreeBinary<E> {
  TreeBinarySet(super.root) : assert(root.valuesAreUnique);
}


///
///
///
/// [Edge]
///
///
///

class Edge<T> {
  final Vertex<T> source;
  final Vertex<T> destination;
  final double weight;

  const Edge(this.source, this.destination, this.weight);

  @override
  String toString() => '$source==$weight=>$destination';

  Iterable<Vertex<T>> get corners => [source, destination];

  bool contains(Vertex<T> vertex) => source == vertex || destination == vertex;

  bool notContains(Vertex<T> vertex) => !contains(vertex);

  bool hasCornerIn(Set<Vertex<T>> vertices) => vertices.any((v) => contains(v));

  bool hasCornerNotIn(Set<Vertex<T>> vertices) =>
      vertices.any((v) => notContains(v));

  bool noCornerIn(Set<Vertex<T>> vertices) => !hasCornerIn(vertices);

  bool isIn(Set<Vertex<T>> vertices) => !hasCornerNotIn(vertices);

  bool isBridgeIn(Set<Vertex<T>> vertices) {
    final list = vertices.toList();
    final hasCornerIn = contains(list.removeFirst());
    return list.any((v) => contains(v) != hasCornerIn);
  }

  Vertex<T> opposite(Vertex<T> a) {
    assert(contains(a));
    return a == source ? destination : source;
  }

  bool operator <(Edge<T> another) => weight < another.weight;

  bool operator >(Edge<T> another) => weight > another.weight;
}


enum EdgeType { directed, undirected }


///
///
///
/// collection extensions
///
///
///
///

extension IterableEdgeExtension<T> on Iterable<Edge<T>> {
  bool anyConnect(Vertex<T> vertex) => any((edge) => edge.contains(vertex));

  Iterable<Edge<T>> whereConnect(Vertex<T> v) => where((e) => e.contains(v));
}

extension SetVertexExtension<C extends Comparable> on Set<Vertex<C>> {
  bool isEveryContainedBy(Iterable<Edge<C>> edges) {
    for (var v in this) {
      if (!edges.anyConnect(v)) return false;
    }
    return true;
  }
}
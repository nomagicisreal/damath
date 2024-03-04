///
///
/// this file contains:
///
/// [Vertex]
///   [VertexComparable]
///   [Node]
///     [NodeBinary]
///       [TreeBinary]
///         [TreeBinarySet]
///
/// [Edge]
///
/// [IterableEdgeExtension]
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
/// [stringDiagramOf]
///
/// [iterateFromLeftToRight], [iterateFromRightToLeft]
/// [traversalFromLeftToRight], [traversalFromRightToLeft]
/// [climbFromLeftToRight], [climbFromRightToLeft]
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
///
/// [TreeBinary]
/// [TreeBinarySet]
///
///

///
/// [root]
///
/// [contains]
///
class TreeBinary<E> {
  NodeBinary<E> root;

  TreeBinary(this.root);

  bool contains(E element) => root.contains(element);
}

///
///
///
class TreeBinarySet<E> extends TreeBinary<E> {
  TreeBinarySet(super.root) : assert(root.everyIsUnique);
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

extension IterableEdgeExtension<E> on Iterable<Edge<E>> {
  Map<Vertex<E>, List<Edge<E>>> get groupByVertex {
    final map = <Vertex<E>, List<Edge<E>>>{};
    for (var edge in this) {
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
}

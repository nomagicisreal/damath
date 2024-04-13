///
///
///
/// this file contains:
///
/// ##[_MixinVertexLazyFinal], ..., [_MixinVertexHiddenAssign]
/// ##[_MixinVertexComparatorPredicate]
/// ##[_MixinVertexOperatableComparable]
///
/// ##[_MixinNodeNextInsertableNullable]
/// ##[_MixinNodeNextInsertableByPredication]
/// ##[_MixinNodeNextInsertableByComparator]
/// [NodeBinary]
///   [NodeBinaryAvl]
/// [NodeTree], [_NodeTreeChainedConstructor], [NodeTreeChained]
///
/// [Junction]
///
/// [Edge]
///   [EdgeBidirectional]
/// [IterableEdgeExtension]
///
///
/// [Graph]
///   [_MixinGraphFunctions]
///   [_MixinGraphSetVertex]
///   [_MixinGraphSetEdge]
///
///   [_InterfaceGraphMutable]
///
///
///
///
part of damath_experiment;

// //
// mixin _MixinVertexLazyFinal<T> on Vertex<T> {
//   @override
//   late final T data;
// }
//
// //
// mixin _MixinVertexLazyMutable<T> on Vertex<T> {
//   @override
//   late T data;
// }
//
// //
// mixin _MixinNodeNextLazy<T> on Node<T> {
//   @override
//   late Node<T>? next;
// }
//
// //
// class _MixinNodeLazyNext<T> extends Node<T> with _MixinNodeNextLazy<T> {
//   @override
//   T data;
//
//   _MixinNodeLazyNext(this.data, [Node<T>? next]) {
//     if (next != null) this.next = next;
//   }
// }
// ....

//
// mixin _MixinVertexHiddenAssign<T> on _MixinVertexHidden<T> {
//   bool _nullAssign(T data) {
//     if (_data == null) {
//       _data = data;
//       return true;
//     }
//     return false;
//   }
// }

// mixin _MixinVertexComparatorPredicate<T> on Vertex<T> {
//   Predicator<int> get _predicator;
//
//   Comparator<T> get _comparator;
//
//   bool _predicateNew(T data) => _predicator(_comparator(this.data, data));
// }

///
/// [_MixinVertexOperatableComparable]
///
///

//
base mixin _MixinVertexOperatableComparable<T extends Comparable>
    on BOperatableComparable<_MixinVertexOperatableComparable<T>>
    implements Vertex<T> {
  @override
  int compareTo(_MixinVertexOperatableComparable<T> other) =>
      data.compareTo(other.data);
}


// //
// mixin _MixinNodeNextInsertableNullable<T>
// on
//     _NodeNextInsertable<T, _MixinNodeNextInsertableNullable<T>>,
//     _MixinVertexHiddenAssign<T> {
//   @override
//   void insert(T data) {
//     if (!_nullAssign(data)) super.insert(data);
//   }
// }
//
// //
// mixin _MixinNodeNextInsertableByPredication<T>
// on _NodeNextInsertable<T, _MixinNodeNextInsertableByPredication<T>> {
//   @override
//   void insert(T data) =>
//       _predicate(data) ? _insertCurrent(data) : _insertNext(data);
//
//   bool _predicate(T data);
// }
//
// //
// mixin _MixinNodeNextInsertableByComparator<T,
// N extends _MixinNodeNextInsertableByComparator<T, N>>
// on _NodeNextInsertable<T, N> {
//   @override
//   void insert(T data, [Comparator<T>? comparator]);
//
//   @override
//   void insertAll(Iterable<T> iterable, [Comparator<T>? comparator]) =>
//       iterable.iterator.consumeAll((data) => insert(data, comparator));
//
//   @override
//   void _insertNext(T data, [Comparator<T>? comparator]) =>
//       _child = _constructChild(
//         data,
//             (general) => general..insert(data, comparator),
//       );
// }

///
///
/// [NodeBinary]
/// [NodeBinaryAvl]
/// [NodeTree]
///
///

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
abstract class NodeBinary<T> extends Vertex<T> {
  NodeBinary<T>? get left;

  NodeBinary<T>? get right;

  const NodeBinary();

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

  int get height => depth + 1; // + current general

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
    const String pass = 'pass';
    try {
      iterateFromLeftToRight((value) {
        if (test(value)) throw pass;
      });
    } on String catch (message) {
      return message == pass;
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
abstract class NodeBinaryAvl<T> extends NodeBinary<T> {
  @override
  NodeBinaryAvl<T>? get left;

  set left(NodeBinaryAvl<T>? node);

  @override
  NodeBinaryAvl<T>? get right;

  set right(NodeBinaryAvl<T>? node);

  const NodeBinaryAvl();

  ///
  /// because [depthLeft] >= 0, [depthRight] >= 0,
  /// if [balanceFactor] == 2, [depthLeft] >=2, which indicates [left] != null
  /// if [balanceFactor] == -2, [depthRight] >=2, which indicates [right] != null
  ///
  int get balanceFactor => depthLeft - depthRight;

  ///
  /// after balancing, these methods return the balanced root of current general
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
/// [children]
/// [isLeaf]
///
/// [add]
/// [forEachData], [forEachNode]
/// [foldData], [foldNode]
/// [whereData], [whereNode]
///
abstract class NodeTree<T> extends Vertex<T> {
  final List<NodeTree<T>> children;

  NodeTree(this.children);

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
  F foldData<F>(F initial, Companion<F, T> company, [bool breadth = true]) {
    var value = initial;
    forEachNode((node) => value = company(value, node.data), breadth);
    return value;
  }

  F foldNode<F>(
    F initial,
    Companion<F, NodeTree<T>> company, [
    bool breadth = true,
  ]) {
    var value = initial;
    forEachNode((node) => value = company(value, node), breadth);
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
///
///
///
///
///
///
///
///


//
// typedef _NodeTreeChainedConstructor<T> = NodeTreeChained<T> Function(
//     Comparator<T> comparator,
//     T data,
//     NodeTreeChained<T>? next,
//     );
//
// //
// mixin _MixinNodeTreeChained<T, N extends NodeTreeChained<T>>
// on
//     _NodeNextInsertable<T, NodeTreeChained<T>>,
//     _MixinVertexComparatorPredicate<T> {
//   @override
//   NodeConstructorNext<T, NodeTreeChained<T>> get _construct =>
//           (data, next) => _chained(_comparator, data, next);
//
//   @override
//   void insert(T data) => throw UnimplementedError();
//
//   _NodeTreeChainedConstructor<T> get _chained;
// }
//
//
// ///
// /// [_comparator], ...(overrides)
// ///
// assumption class NodeTreeChained<T> extends Vertex<T>
//     with
//         _MixinVertexComparatorPredicate<T>,
//         _MixinNodeTreeChained<T, NodeTreeChained<T>> {
//   ///
//   /// overrides
//   ///
//   @override
//   final Comparator<T> _comparator;
//
//   @override
//   final _NodeTreeChainedConstructor<T> _chained;
//
//   ///
//   /// constructors
//   ///
//   const NodeTreeChained(this._comparator, this._chained);
// }


///
///
///

abstract class Junction<T, V extends Vertex<T>> extends Vertex<T> {
  const Junction();

  V get another;
}

///
///
///
/// [Edge]
/// [EdgeBidirectional]
///
///
///

///
/// [_source], [_destination], [weight]
/// [contains], ...
///
abstract class Edge<T, S, V extends Vertex<T>> {
  V get _source;

  V get _destination;

  S get weight;

  T get source => _source.data;

  set source(T value) => _source.data = value;

  T get destination => _destination.data;

  set destination(T value) => _destination.data = value;

  String toStringIdentity() => '$weight:${_source.data}===${_destination.data}';

  @override
  String toString() => 'Edge(${toStringIdentity()})';

  const Edge();

  ///
  /// [toSource], [toDestination]
  ///
  static Vertex<T> toSource<T, S, V extends Vertex<T>>(Edge<T, S, V> edge) =>
      edge._source;

  static Vertex<T> toDestination<T, S, V extends Vertex<T>>(
          Edge<T, S, V> edge) =>
      edge._source;

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
///
///
/// [EdgeBidirectional]
///
///
///
///
///

///
/// [weightReverse]
///
mixin EdgeBidirectional<T, S, V extends Vertex<T>> on Edge<T, S, V> {
  S get weightReverse;

  bool get isWeightEqual => weight == weightReverse;

  @override
  String toStringIdentity() =>
      '${_source.data}==$weight>===<$weightReverse==${_destination.data})';
}

///
/// [toVertices]
///
extension IterableEdgeExtension<T, S, V extends Vertex<T>>
    on Iterable<Edge<T, S, V>> {
  Set<V> get toVertices => fold(
        {},
        (set, edge) => set
          ..add(edge._source)
          ..add(edge._destination),
      );
}

///
///
///
///
///
/// graph
///
///
///
///
///
///

///
///
/// [vertices], ...
///
///
abstract class Graph<T, S, V extends Vertex<T>, E extends Edge<T, S, V>> {
  const Graph();

  ///
  /// [vertices], [edges], [weights]
  ///
  Iterable<V> get vertices;

  Iterable<E> get edges;

  String toStringIdentity() => '\n'
      'Vertices: ${vertices.map((e) => e.data)}\n'
      'Edges: ${edges.map((e) => e.toStringIdentity())}\n';

  @override
  String toString() => 'GraphAncestor(${toStringIdentity()})';

  bool containsVertex(V vertex) => vertices.contains(vertex);

  bool containsEdge(E edge) => edges.contains(edge);
}

// ///
// ///
// /// [edgesFrom], ...
// /// [hasCycleOn], ...
// /// [_hasCycleOn], ...
// ///
// ///
// mixin _MixinGraphFunctions<T, S, V extends Vertex<T>, E extends Edge<T, S, V>>
// on Graph<T, S, V, E> {
//   ///
//   /// [vertexGroupsFromEdges]
//   /// [destinationsGroupBySources]
//   /// [sourcesGroupByDestinations]
//   ///
//   Map<K, List<D>> vertexGroupsFromEdges<K, D>(
//       Mapper<E, K> edgeToKey,
//       Mapper<E, D> edgeToValue,
//       ) =>
//       edges.fold(
//         {},
//             (map, edge) => map
//           ..update(
//             edgeToKey(edge),
//                 (m) => m..add(edgeToValue(edge)),
//             ifAbsent: () => [edgeToValue(edge)],
//           ),
//       );
//
//   Map<V, List<V>> get destinationsGroupBySources => vertexGroupsFromEdges(
//         (value) => value._source,
//         (value) => value._destination,
//   );
//
//   Map<V, List<V>> get sourcesGroupByDestinations => vertexGroupsFromEdges(
//         (value) => value._destination,
//         (value) => value._source,
//   );
//
//   ///
//   /// [containsVertex], [containsVerticesOnEdge], [containsAllVertices]
//   /// [containsEdge], [containsAllEdges], [containsEdgeForBoth]
//   /// [weightFrom]
//   ///
//
//   bool containsVerticesOnEdge(E edge) =>
//       containsVertex(edge._source) && containsVertex(edge._destination);
//
//   bool containsAllVertices(Iterable<V> vertices) =>
//       this.vertices.iterator.containsAll(vertices.iterator);
//
//   bool containsEdgeForBoth(V source, V destination) =>
//       edges.any((edge) => edge.containsBoth(source, destination));
//
//   bool containsAllEdges(Iterable<E> edges) =>
//       this.edges.iterator.containsAll(edges.iterator);
//
//   S weightFrom(V source, V destination) => edges.iterator.findMap(
//         (edge) => edge.containsBoth(source, destination),
//         (edge) => edge.weight,
//   );
//
//   ///
//   /// [edgesFrom], [edgesTo]
//   /// [destinationsFrom], [sourcesTo]
//   /// [reachablesFrom]
//   ///
//   Iterable<E> edgesFrom(V source) =>
//       edges.where((edge) => edge._source == source);
//
//   Iterable<E> edgesTo(V destination) =>
//       edges.where((edge) => edge._destination == destination);
//
//   Iterable<V> destinationsFrom(V source) => edges.iterator.mapWhere(
//         (edge) => edge._source == source,
//         (edge) => edge._destination,
//   );
//
//   Iterable<V> sourcesTo(V destination) => edges.iterator.mapWhere(
//         (edge) => edge._destination == destination,
//         (edge) => edge._source,
//   );
//
//   Iterable<V> reachablesFrom(V source, [bool breadth = true]) =>
//       breadth ? _searchBreathFirst(source) : _searchDepthFirst(source);
//
//   ///
//   /// [hasCycleOn]
//   ///
//   bool hasCycleOn(V source) => _hasCycleOn(source, []);
//
//   ///
//   ///
//   /// private implementations:
//   ///
//   /// [_hasCycleOn]
//   /// [_searchBreathFirst]
//   /// [_searchDepthFirst]
//   ///
//   ///
//
//   ///
//   /// [_hasCycleOn]
//   ///
//   bool _hasCycleOn(V source, List<V> pushed) {
//     pushed.add(source);
//     final result = destinationsFrom(source).any((destination) =>
//     pushed.contains(destination) || _hasCycleOn(destination, pushed));
//     pushed.remove(source);
//     return result;
//   }
//
//   ///
//   /// [_searchBreathFirst]
//   /// [_searchDepthFirst]
//   ///
//   List<V> _searchBreathFirst(V source) {
//     final visited = <V>[source];
//     for (var i = 0; i < visited.length; i++) {
//       destinationsFrom(visited[i]).iterator.whereConsume(
//             (destination) => visited.iterator.notContains(destination),
//             (destination) => visited.add(destination),
//       );
//     }
//     return visited;
//   }
//
//   List<V> _searchDepthFirst(V source) {
//     final visited = <V>[source];
//     while (visited.isNotEmpty) {
//       destinationsFrom(visited.removeLast()).iterator.whereConsume(
//             (destination) => visited.iterator.notContains(destination),
//             (destination) => visited.add(destination),
//       );
//     }
//     return visited;
//   }
// }

// //
// mixin _MixinGraphSetVertex<T> on Graph<T, double, Vertex<T>, Edge<T, double, Vertex<T>>>
// implements
//     _MixinGraphFunctions<T, double, Vertex<T>, Edge<T, double, Vertex<T>>> {
//   @override
//   Set<Vertex<T>> get vertices;
//
//   @override
//   Set<Edge<T, double, Vertex<T>>> edges = {};
//
//   ///
//   /// Returns `true` if [edge] (or an equal value) was not yet in the [edges].
//   /// Otherwise returns `false` and the set is not changed. See also [Set.add]
//   ///
//   bool addEdgeForVertices(Edge<T, double, Vertex<T>> edge) {
//     if (containsVerticesOnEdge(edge)) return edges.add(edge);
//     throw StateError(
//       'Edge.source(${edge._source}) or '
//           'Edge.destination(${edge._destination}) not in $vertices',
//     );
//   }
// }
//
// //
// mixin _MixinGraphSetEdge<T> on Graph<T, double, Vertex<T>, Edge<T, double, Vertex<T>>>
// implements
//     _MixinGraphFunctions<T, double, Vertex<T>, Edge<T, double, Vertex<T>>> {
//   @override
//   Set<Edge<T, double, Vertex<T>>> get edges;
//
//   @override
//   Set<Vertex<T>> get vertices => edges.toVertices;
// }
//
// ///
// /// [createVertex], ...
// /// [createEdge], ...
// ///
// assumption interface class _InterfaceGraphMutable<T, S, V extends Vertex<T>,
// E extends Edge<T, S, V>> extends Graph<T, S, V, E> {
//   ///
//   /// [createVertex], [addVertex]
//   /// [createEdge], [addEdge],
//   ///
//
//   V createVertex(V vertex);
//
//   V addVertex(V vertex);
//
//   E createEdge(E edge);
//
//   E addEdge(E edge);
// }

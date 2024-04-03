///
///
/// this file contains:
///
/// [GraphAncestor]
///   [GraphVertex]
///   [GraphEdge]
///
///   [GraphMutable]
///
///
///
part of damath_experiment;

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

  String toStringIdentity() => '\n'
      'Vertices: ${vertices.map((e) => e.data)}\n'
      'Edges: ${edges.map((e) => e.toStringIdentity())}\n';

  @override
  String toString() => 'GraphAncestor(${toStringIdentity()})';

  ///
  /// [vertexGroupsFromEdges]
  /// [destinationsGroupBySources]
  /// [sourcesGroupByDestinations]
  ///
  Map<K, List<D>> vertexGroupsFromEdges<K, D>(
    Mapper<E, K> edgeToKey,
    Mapper<E, D> edgeToValue,
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
  /// [containsVertex], [containsVerticesOnEdge], [containsAllVertices]
  /// [containsEdge], [containsAllEdges], [containsEdgeForBoth]
  /// [weightFrom]
  ///
  bool containsVertex(V vertex) => vertices.contains(vertex);

  bool containsVerticesOnEdge(E edge) =>
      containsVertex(edge._source) && containsVertex(edge._destination);

  bool containsAllVertices(Iterable<V> vertices) =>
      this.vertices.iterator.containsAll(vertices.iterator);

  bool containsEdge(E edge) => edges.contains(edge);

  bool containsEdgeForBoth(V source, V destination) =>
      edges.any((edge) => edge.containsBoth(source, destination));

  bool containsAllEdges(Iterable<E> edges) =>
      this.edges.iterator.containsAll(edges.iterator);

  S weightFrom(V source, V destination) => edges.iterator.findMap(
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

  Iterable<V> destinationsFrom(V source) => edges.iterator.mapWhere(
        (edge) => edge._source == source,
        (edge) => edge._destination,
      );

  Iterable<V> sourcesTo(V destination) => edges.iterator.mapWhere(
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
      destinationsFrom(visited[i]).iterator.whereConsume(
            (destination) => visited.iterator.notContains(destination),
            (destination) => visited.add(destination),
          );
    }
    return visited;
  }

  List<V> _searchDepthFirst(V source) {
    final visited = <V>[source];
    while (visited.isNotEmpty) {
      destinationsFrom(visited.removeLast()).iterator.whereConsume(
            (destination) => visited.iterator.notContains(destination),
            (destination) => visited.add(destination),
          );
    }
    return visited;
  }
}

//
class GraphVertex<T> extends GraphAncestor<T, double, Vertex<T>, Edge<T>> {
  @override
  final Set<Vertex<T>> vertices;

  @override
  final Set<Edge<T>> edges = {};

  GraphVertex(this.vertices);

  ///
  /// Returns `true` if [edge] (or an equal value) was not yet in the [edges].
  /// Otherwise returns `false` and the set is not changed. See also [Set.add]
  ///
  bool addEdgeForVertices(Edge<T> edge) {
    if (containsVerticesOnEdge(edge)) return edges.add(edge);
    throw DamathException(
      'Edge.source(${edge._source}) or '
      'Edge.destination(${edge._destination}) not in $vertices',
    );
  }
}

//
class GraphEdge<T> extends GraphAncestor<T, double, Vertex<T>, Edge<T>> {
  @override
  final Set<Edge<T>> edges;

  @override
  Set<Vertex<T>> get vertices => edges.toVertices;

  GraphEdge(this.edges);
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

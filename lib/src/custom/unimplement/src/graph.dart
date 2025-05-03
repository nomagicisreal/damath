part of '../unimplement.dart';

///
/// (All-Source-Shortest Path)
/// Floyd–Warshall algorithm: https://www.geeksforgeeks.org/floyd-warshall-algorithm-dp-16/
/// (Single-Source-Shortest Path)
/// Dijkstra’s Algorithm: https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
///
/// Minimum Spanning Tree - Prim
/// Minimum Spanning Tree - Kruskal
/// Travelling salesman problem: https://www.geeksforgeeks.org/travelling-salesman-problem-using-dynamic-programming/
///
///


// ///
// ///
// /// [Junction]
// /// [Edge], [EdgeBidirectional]
// /// [Graph], ...
// ///
// ///
//
// ///
// ///
// ///
// abstract class Junction<T, V extends Vertex<T>> extends Vertex<T> {
//   const Junction();
//
//   V get another;
// }
//
// ///
// /// [_source], [_destination], [weight]
// /// [contains], ...
// ///
// abstract class Edge<T, S, V extends Vertex<T>> {
//   V get _source;
//
//   V get _destination;
//
//   S get weight;
//
//   T get source => _source.data;
//
//   set source(T value) => _source.data = value;
//
//   T get destination => _destination.data;
//
//   set destination(T value) => _destination.data = value;
//
//   String toStringIdentity() => '$weight:${_source.data}===${_destination.data}';
//
//   @override
//   String toString() => 'Edge(${toStringIdentity()})';
//
//   const Edge();
//
//   ///
//   /// [toSource], [toDestination]
//   ///
//   static Vertex<T> toSource<T, S, V extends Vertex<T>>(Edge<T, S, V> edge) =>
//       edge._source;
//
//   static Vertex<T> toDestination<T, S, V extends Vertex<T>>(
//     Edge<T, S, V> edge,
//   ) => edge._source;
//
//   ///
//   /// [contains]
//   /// [containsBoth]
//   /// [containsData]
//   ///
//   bool contains(V vertex) => _source == vertex || _destination == vertex;
//
//   bool containsBoth(V source, V destination) =>
//       _source == source || _destination == destination;
//
//   bool containsData(T data) =>
//       _source.data == data || _destination.data == data;
//
//   MapEntry<V, V> get toVertexEntry => MapEntry(_source, _destination);
// }
//
// ///
// /// [weightReverse]
// ///
// mixin EdgeBidirectional<T, S, V extends Vertex<T>> on Edge<T, S, V> {
//   S get weightReverse;
//
//   bool get isWeightEqual => weight == weightReverse;
//
//   @override
//   String toStringIdentity() =>
//       '${_source.data}==$weight>===<$weightReverse==${_destination.data})';
// }
//
// ///
// /// [toVertices]
// ///
// extension IterableEdgeExtension<T, S, V extends Vertex<T>>
//     on Iterable<Edge<T, S, V>> {
//   Set<V> get toVertices => fold(
//     {},
//     (set, edge) =>
//         set
//           ..add(edge._source)
//           ..add(edge._destination),
//   );
// }
//
// ///
// ///
// /// [vertices], ...
// ///
// ///
// abstract class Graph<T, S, V extends Vertex<T>, E extends Edge<T, S, V>> {
//   const Graph();
//
//   ///
//   /// [vertices], [edges]
//   ///
//   Iterable<V> get vertices;
//
//   Iterable<E> get edges;
//
//   String toStringIdentity() =>
//       '\n'
//       'Vertices: ${vertices.map((e) => e.data)}\n'
//       'Edges: ${edges.map((e) => e.toStringIdentity())}\n';
//
//   @override
//   String toString() => 'GraphAncestor(${toStringIdentity()})';
//
//   bool containsVertex(V vertex) => vertices.contains(vertex);
//
//   bool containsEdge(E edge) => edges.contains(edge);
// }
//
// ///
// ///
// /// [edgesFrom], ...
// /// [hasCycleOn], ...
// /// [_hasCycleOn], ...
// ///
// ///
// mixin _MixinGraphFunctions<T, S, V extends Vertex<T>, E extends Edge<T, S, V>>
//     on Graph<T, S, V, E> {
//   ///
//   /// [vertexGroupsFromEdges]
//   /// [destinationsGroupBySources]
//   /// [sourcesGroupByDestinations]
//   ///
//   Map<K, List<D>> vertexGroupsFromEdges<K, D>(
//     Mapper<E, K> edgeToKey,
//     Mapper<E, D> edgeToValue,
//   ) => edges.fold(
//     {},
//     (map, edge) =>
//         map..update(
//           edgeToKey(edge),
//           (m) => m..add(edgeToValue(edge)),
//           ifAbsent: () => [edgeToValue(edge)],
//         ),
//   );
//
//   Map<V, List<V>> get destinationsGroupBySources => vertexGroupsFromEdges(
//     (value) => value._source,
//     (value) => value._destination,
//   );
//
//   Map<V, List<V>> get sourcesGroupByDestinations => vertexGroupsFromEdges(
//     (value) => value._destination,
//     (value) => value._source,
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
//       this.vertices.containsAll(vertices);
//
//   bool containsEdgeForBoth(V source, V destination) =>
//       edges.any((edge) => edge.containsBoth(source, destination));
//
//   bool containsAllEdges(Iterable<E> edges) => this.edges.containsAll(edges);
//
//   S weightFrom(V source, V destination) =>
//       edges.firstWhere((edge) => edge.containsBoth(source, destination)).weight;
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
//     (edge) => edge._source == source,
//     (edge) => edge._destination,
//   );
//
//   Iterable<V> sourcesTo(V destination) => edges.iterator.mapWhere(
//     (edge) => edge._destination == destination,
//     (edge) => edge._source,
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
//     final result = destinationsFrom(source).any(
//       (destination) =>
//           pushed.contains(destination) || _hasCycleOn(destination, pushed),
//     );
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
//       destinationsFrom(visited[i]).iterator.consumeWhere(
//         (destination) => !visited.contains(destination),
//         (destination) => visited.add(destination),
//       );
//     }
//     return visited;
//   }
//
//   List<V> _searchDepthFirst(V source) {
//     final visited = <V>[source];
//     while (visited.isNotEmpty) {
//       destinationsFrom(visited.removeLast()).iterator.consumeWhere(
//         (destination) => !visited.contains(destination),
//         (destination) => visited.add(destination),
//       );
//     }
//     return visited;
//   }
// }
//
// //
// mixin _MixinGraphSetVertex<T>
//     on Graph<T, double, Vertex<T>, Edge<T, double, Vertex<T>>>
//     implements
//         _MixinGraphFunctions<T, double, Vertex<T>, Edge<T, double, Vertex<T>>> {
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
//       'Edge.destination(${edge._destination}) not in $vertices',
//     );
//   }
// }

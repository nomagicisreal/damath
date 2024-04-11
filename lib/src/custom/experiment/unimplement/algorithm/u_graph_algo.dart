///
///
/// this file contains:
/// [NodeBinarySetSorted]
/// [NodeAvlComparable]
/// [NodeTrie], [NodeTrieString]
///
/// [AdjacencyList], [AdjacencyMatrix]
///
/// [Heap]
///
/// some sample code can be seen at https://medium.com/@m.m.shahmeh/data-structures-algorithms-in-dart-5-5-660e0ef30a4d
///
///
///
/// extensions:
/// [SetVertexExtension]
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
part of damath_experiment;


// extension GraphAlgorithm<C extends Comparable> on List<List<C>> {
//   ///
//   /// (Single-Source-Shortest Path)
//   ///
//   List<Vertex<C>> shortestDijkstra(
//       Vertex<C> source,
//       Vertex<C> destination, {
//         Map<Vertex<C>, VertexComparableMutable<C>?>? paths,
//       }) {
//     throw UnimplementedError();
//   }
// }

//
// ///
// ///
// /// [root], [min], [max]
// ///
// class NodeBinarySetSorted<E extends Comparable> extends NodeBinarySet<E> {
//   NodeBinarySetSorted(super.root) : assert(throw UnimplementedError());
//
//   ///
//   /// [min], [max]
//   ///
//   NodeBinary<E> get min => leftest;
//
//   NodeBinary<E> get max => rightest;
//
//   ///
//   /// [insertionOf], [removalOf]
//   ///
//   static NodeBinary<E> insertionOf<E extends Comparable>(
//       NodeBinary<E>? general,
//       E data,
//       ) =>
//       general == null
//           ? NodeBinary(data)
//           : () {
//         return switch (data.compareTo(general.data)) {
//           -1 => general..left = insertionOf(general.left, data),
//           1 => general..right = insertionOf(general.right, data),
//           0 => throw UnimplementedError('data already exist: $data'),
//           _ => throw UnimplementedError(),
//         };
//       }();
//
//   static NodeBinary<E>? removalOf<E extends Comparable>(
//       NodeBinary<E>? general,
//       E data,
//       NodeBinary<E>? Function(NodeBinary<E> general) fillFrom,
//       ) =>
//       general == null
//           ? null
//           : () {
//         final value = data.compareTo(general.data);
//         return switch (value) {
//           -1 => general..left = removalOf(general.left, data, fillFrom),
//           1 => general..right = removalOf(general.right, data, fillFrom),
//           0 => fillFrom(general),
//           _ => throw UnimplementedError(),
//         };
//       }();
//
//   static NodeBinary<E>? fillFromLargerAfterRemoval<E extends Comparable>(
//       NodeBinary<E> general,
//       ) {
//     final right = general.right;
//     return right == null
//         ? general.left
//         : () {
//       final replacement = right.leftest.data;
//       general.data = replacement;
//       general.right =
//           removalOf(right, replacement, fillFromLargerAfterRemoval<E>);
//       return general;
//     }();
//   }
//
//   static NodeBinary<E>? fillFromSmallerAfterRemoval<E extends Comparable>(
//       NodeBinary<E> general,
//       ) {
//     final left = general.left;
//     final right = general.right;
//     if (left != null && right != null) {
//       final replacement = left.rightest.data;
//       general.data = replacement;
//       general.left = removalOf(left, replacement, fillFromSmallerAfterRemoval<E>);
//       return general;
//     } else {
//       return left ?? right;
//     }
//   }
//
//   ///
//   /// [insert], [remove]
//   ///
//   void insert(E value) => root = insertionOf(root, value);
//
//   void remove(E value, [bool fillFromSmaller = true]) {
//     if (value == root.data) {
//       throw UnimplementedError('root must not be removed');
//     } else {
//       root = removalOf(
//         root,
//         value,
//         fillFromSmaller
//             ? fillFromSmallerAfterRemoval
//             : fillFromLargerAfterRemoval,
//       )!;
//     }
//   }
// }
//
// class NodeAvlComparable<E extends Comparable> extends NodeBinaryAvl<E> {
//   NodeAvlComparable(super.data);
//
//   @override
//   NodeBinaryAvl<E> _updateInsert(covariant NodeBinaryAvl<E>? general, E value) {
//     final balanced = balance(super._updateInsert(general, value) as NodeBinaryAvl<E>);
//     balanced.height = 1 + math.max(balanced.heightLeft, balanced.heightRight);
//     return balanced;
//   }
//
//   @override
//   NodeBinaryAvl<E> _updateRemove(covariant NodeBinaryAvl<E>? general, E value) {
//     final balanced = balance(super._updateRemove(general, value) as NodeBinaryAvl<E>);
//     balanced.height = 1 + math.max(balanced.heightLeft, balanced.heightRight);
//     return balanced;
//   }
// }
//
// class NodeTrie<T> {
//   T? data;
//   NodeTrie<T>? parent;
//
//   NodeTrie({this.data, this.parent});
//
//   final Map<T, NodeTrie<T>?> children = {};
//   bool isTerminating = false;
// }
//
// class NodeTrieString {
//   NodeTrie<int> root = NodeTrie(data: null, parent: null);
//
//   void insert(String text) {
//     var current = root;
//
//     for (var codeUnit in text.codeUnits) {
//       current.children[codeUnit] ??= NodeTrie(data: codeUnit, parent: current);
//       current = current.children[codeUnit]!;
//     }
//
//     current.isTerminating = true;
//   }
//
//   bool contains(String text) {
//     var current = root;
//     for (var codeUnit in text.codeUnits) {
//       final child = current.children[codeUnit];
//       if (child == null) return false;
//       current = child;
//     }
//     return current.isTerminating;
//   }
//
//   void remove(String text) {
//     var current = root;
//     for (var codeUnit in text.codeUnits) {
//       final child = current.children[codeUnit];
//       if (child == null) return;
//       current = child;
//     }
//     if (!current.isTerminating) return;
//     current.isTerminating = false;
//
//     while (current.parent != null &&
//         current.children.isEmpty &&
//         !current.isTerminating) {
//       current.parent!.children[current.data!] = null;
//       current = current.parent!;
//     }
//   }
//
//   ///
//   /// match
//   ///
//
//   List<String> _moreMatches(String prefix, NodeTrie<int> general) {
//     List<String> results = [];
//     if (general.isTerminating) results.add(prefix);
//
//     for (final child in general.children.values) {
//       final codeUnit = child!.data!;
//       results.addAll(
//         _moreMatches('$prefix${String.fromCharCode(codeUnit)}', child),
//       );
//     }
//     return results;
//   }
//
//   List<String> matchPrefix(String prefix) {
//     var current = root;
//     for (var codeUnit in prefix.codeUnits) {
//       final child = current.children[codeUnit];
//       if (child == null) return [];
//       current = child;
//     }
//
//     return _moreMatches(prefix, current);
//   }
// }
//
// mixin GraphVertexComparable<E> on Graph<E> {
//   int _index = 0;
//
//   int _indexOf(Vertex<E> v) => (v as VertexComparable<E>).value as int;
// }
//
// class AdjacencyList<E> extends Graph<E> with GraphVertexComparable<E> {
//   final Map<VertexComparable<E>, List<Edge<E>>> _connections = {};
//
//   @override
//   Iterable<Vertex<E>> get vertices => _connections.keys;
//
//   @override
//   Vertex<E> createVertex(E data) {
//     final vertex = VertexComparable(_index, data);
//     _index++;
//     _connections[vertex] = [];
//     return vertex;
//   }
//
//   @override
//   void addEdge(
//       Vertex<E> source,
//       Vertex<E> destination, {
//         EdgeType edgeType = EdgeType.undirected,
//         double weight = double.infinity,
//       }) {
//     _connections[source]?.add(Edge(source, destination, weight));
//     if (edgeType == EdgeType.undirected) {
//       _connections[destination]?.add(Edge(destination, source, weight));
//     }
//   }
//
//   @override
//   List<Edge<E>> edgesFrom(Vertex<E> source) => _connections[source] ?? [];
//
//   @override
//   double weightFrom(
//       Vertex<E> source,
//       Vertex<E> destination,
//       ) {
//     final match = edgesFrom(source).where((edge) {
//       return edge.destination == destination;
//     });
//     if (match.isEmpty) return double.infinity;
//     return match.first.weight;
//   }
//
//   @override
//   String toString() => _connections
//       .fold(
//     StringBuffer(),
//         (buffer, entry) =>
//     buffer..writeln('${entry.key} --> ${entry.x.join(', ')}'),
//   )
//       .toString();
// }
//
// class AdjacencyMatrix<E> extends Graph<E> with GraphVertexComparable<E> {
//   final List<Vertex<E>> _vertices = [];
//   final List<List<double?>?> _weights = [];
//
//   @override
//   Iterable<Vertex<E>> get vertices => _vertices;
//
//   @override
//   Vertex<E> createVertex(E data) {
//     final vertex = VertexComparable(_index, data);
//     _index++;
//     _vertices.add(vertex);
//     for (var i = 0; i < _weights.length; i++) {
//       _weights[i]?.add(null);
//     }
//     _weights.add(List<double?>.filled(_vertices.length, null)); // row
//     return vertex;
//   }
//
//   @override
//   void addEdge(
//       Vertex<E> source,
//       Vertex<E> destination, {
//         EdgeType edgeType = EdgeType.undirected,
//         double weight = double.infinity,
//       }) {
//     final si = _indexOf(source);
//     final di = _indexOf(destination);
//
//     _weights[si]?[di] = weight;
//     if (edgeType == EdgeType.undirected) _weights[di]?[si] = weight;
//   }
//
//   @override
//   List<Edge<E>> edgesFrom(Vertex<E> source) {
//     final si = _indexOf(source);
//     final edges = <Edge<E>>[];
//     for (var column = 0; column < _weights.length; column++) {
//       final weight = _weights[si]?[column];
//       if (weight != null) {
//         edges.add(Edge(source, _vertices[column], weight));
//       }
//     }
//     return edges;
//   }
//
//   @override
//   double weightFrom(Vertex<E> source, Vertex<E> destination) =>
//       _weights[_indexOf(source)]?[_indexOf(destination)] ?? double.infinity;
//
//   @override
//   String toString() {
//     final buffer = StringBuffer();
//     for (final vertex in _vertices) {
//       buffer.writeln('${_indexOf(vertex)}: ${vertex.data}');
//     }
//     for (int i = 0; i < _weights.length; i++) {
//       for (int j = 0; j < _weights.length; j++) {
//         buffer.write((_weights[i]?[j] ?? '.').toString().padRight(6));
//       }
//       buffer.writeln();
//     }
//     return buffer.toString();
//   }
// }
//
//
// class Heap<E extends Comparable> {
//   final Comparator<E> comparator;
//   final List<E> elements = [];
//
//   Heap(List<E> elements, {bool increase = false})
//       : comparator =
//   increase ? Comparable.compare : ComparableData.compareReverse {
//     this.elements.addAll(elements);
//     if (isNotEmpty) {
//       final start = elements.length ~/ 2 - 1;
//       for (var i = start; i >= 0; i--) {
//         _shiftDown(i);
//       }
//     }
//   }
//
//   @override
//   String toString() => 'Heap($elements)';
//
//   ///
//   /// [length]
//   /// [isEmpty], [isNotEmpty],
//   /// [peek]
//   ///
//   int get length => elements.length;
//
//   bool get isEmpty => elements.isEmpty;
//
//   bool get isNotEmpty => elements.isNotEmpty;
//
//   E get peek => elements.first;
//
//   ///
//   /// [_indexPreviousFrom], [_indexNextFrom], [_indexParentFrom]
//   /// [_prioritize], [_priorityMax]
//   ///
//   int _indexPreviousFrom(int iParent) => 2 * iParent + 1;
//
//   int _indexNextFrom(int iParent) => 2 * iParent + 2;
//
//   int _indexParentFrom(int iChild) => (iChild - 1) ~/ 2;
//
//   bool _prioritize(E vA, E vB) => comparator(vA, vB) > 0;
//
//   int _priorityMax(int indexA, int indexB) {
//     final elements = this.elements;
//     if (indexA >= elements.length) return indexB;
//     return _prioritize(elements[indexA], elements[indexB]) ? indexA : indexB;
//   }
//
//   ///
//   /// [_swap]
//   /// [_shiftUp], [_shiftDown]
//   ///
//   void _swap(int indexA, int indexB) => elements.swap(indexA, indexB);
//
//   void _shiftUp(int index) {
//     var child = index;
//     var parent = _indexParentFrom(child);
//     while (child > 0 && child == _priorityMax(child, parent)) {
//       _swap(child, parent);
//       child = parent;
//       parent = _indexParentFrom(child);
//     }
//   }
//
//   void _shiftDown(int index) {
//     var parent = index;
//     while (true) {
//       var tempt = _priorityMax(_indexPreviousFrom(parent), parent);
//       tempt = _priorityMax(_indexNextFrom(parent), tempt);
//       if (tempt == parent) return;
//       _swap(parent, tempt);
//       parent = tempt;
//     }
//   }
//
//   ///
//   /// [insert]
//   /// [removeAt], [removeLast]
//   /// [indexOf]
//   ///
//   void insert(E value) {
//     elements.add(value);
//     _shiftUp(elements.length - 1);
//   }
//
//   E removeAt(int index) {
//     final lastIndex = elements.length - 1;
//     if (index < 0 || index > lastIndex) {
//       throw UnimplementedError('index out of range(0, $lastIndex)');
//     }
//
//     if (index == lastIndex) elements.removeLast();
//     _swap(index, lastIndex);
//     final value = elements.removeLast();
//     _shiftDown(index);
//     _shiftUp(index);
//     return value;
//   }
//
//   E removeLast() {
//     if (isEmpty) throw UnimplementedError('no elements');
//
//     _swap(0, elements.length - 1);
//     final value = elements.removeLast();
//     _shiftDown(0);
//     return value;
//   }
//
//   int indexOf(E value, [int index = 0]) {
//     final elements = this.elements;
//     final current = elements[index];
//     if (index >= elements.length || _prioritize(value, current)) return -1;
//
//     if (value == current) return index;
//     final previous = indexOf(value, _indexPreviousFrom(index));
//     if (previous != -1) return previous;
//     return indexOf(value, _indexNextFrom(index));
//   }
// }
//
// ///
// ///
// ///
// ///
// /// [SetVertexExtension]
// ///
// ///
// ///
// ///
// ///
//
// //
// extension SetVertexExtension<C extends Comparable> on Set<Vertex<C>> {
//   ///
//   /// Minimum Spanning Tree - Prim
//   ///
//   Set<Edge<C>> prim(Set<Edge<C>> edgesSet) {
//     throw UnimplementedError();
//   }
//
//   ///
//   /// Minimum Spanning Tree - Kruskal
//   ///
//   Set<Edge<C>> kruskal(Set<Edge<C>> edgesSet) {
//     throw UnimplementedError();
//   }
// }
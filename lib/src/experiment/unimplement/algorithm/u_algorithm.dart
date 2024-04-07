///
///
/// this file contains:
/// [HuffManCode]
/// [SequencingUtil]
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
part of damath_experiment;

///
class HuffManCode<S> {
  final Map<List<bool>, S> _byteSymbol;
  final Map<S, List<bool>> _symbolByte;

  HuffManCode._(this._byteSymbol, this._symbolByte);

  // factory HuffManCode(Iterable<S> symbols) {
  //   final probability = symbols.probability;
  //
  //   final entries = probability.entries.toList();
  //   SortingUtil.quickSort(probability.values.toList());
  //   probability.entries.indexed;
  //   // instead of 0 and 1, using 1 and 2
  //
  //   // return HuffManCode._({});
  // }

  S? operator [](List<bool> byte) => _byteSymbol[byte];

  List<bool>? operator &(S symbol) => _symbolByte[symbol];
}

///
///
/// [shortestFloyd]
/// [shortestDijkstra]
/// [shortestTravelingSalesman]
/// [pairwiseSequenceAlignment]
///
extension SequencingUtil<C extends Comparable> on List<List<C>> {
  static const List<List<num>> floydShortestSamplePaths = [
    [0, 1, 1, 3, 5, 7, 99],
    [10, 0, 2, 4, 41, 11, 44],
    [19, 3, 0, 43, 14, 71, 72],
    [16, 2, 100, 0, 8, 6, 29],
    [29, 16, 2, 100, 0, 8, 6],
    [6, 29, 16, 2, 100, 0, 8],
    [6, 24, 61, 20, 10, 66, 0],
  ];

  ///
  /// (All-Source-Shortest Path)
  ///
  static List<List<num>> shortestFloyd(List<List<num>> rawPaths) {
    final raw = rawPaths;
    final size = raw.length;
    assert(size == raw[0].length);
    for (var i = 0; i < raw.length; i++) {
      assert(raw[i][i] == 0);
    }

    final shortest = rawPaths;
    for (var k = 0; k < size; k++) {
      for (var i = 0; i < size; i++) {
        for (var j = 0; j < size; j++) {
          shortest[i][j] = math.min(
            shortest[i][j],
            shortest[i][k] + shortest[k][j],
          );
        }
      }
    }

    ///
    /// 1. D(0)[a][b]
    /// 2. D(1)[a][b]
    /// 3. D(2)[a][b]
    /// ...
    /// n-1. D(n-1)[a][b]
    ///
    /// everytime finding shortest path P, it's necessary to update the path using P
    ///

    throw UnimplementedError();
  }

  ///
  ///
  static List<List<num>> shortestTravelingSalesman(List<List<num>> rawPath) {
    final raw = rawPath;
    final size = raw.length;
    assert(size == raw[0].length);
    for (var i = 0; i < raw.length; i++) {
      assert(raw[i][i] == 0);
    }

    throw UnimplementedError();
  }

  ///
  ///
  /// take sequence (X, Y) for example,
  /// X -> A A C A G T T A C C
  /// Y -> T A A G G T C A
  /// - alignment 1:
  ///   _ A A C A G T T A C C
  ///   T A A _ G G T _ _ C A
  /// - alignment 2
  ///   A A C A G T T A C C
  ///   T A _ A G G T _ C A
  /// the gap indicates the insertion or deletion, if mismatch penalty = m, deletion penalty = d,
  ///   penalty of alignment 1 = 2m + 4d
  ///   penalty of alignment 2 = 3m + 2d
  /// [pairwiseSequenceAlignment] is a method to find the best alignment with minimum penalty sum
  ///
  ///
  static MapEntry<String, String> pairwiseSequenceAlignment(
    String x,
    String y, {
    int penaltyMatch = 0,
    int penaltyMismatch = 1,
    int penaltyDeletion = 2,
  }) {
    ///
    ///
    /// define S(k) = S[k...last]
    /// opt(S1[i], S2[j]) = min(
    ///   opt(S1[i+1], S2[j+1]) + m,
    ///   opt(S1[i+1], S2[j]) + d,
    ///   opt(S1[i], S2[j+1]) + d,
    /// );
    ///

    throw UnimplementedError();
  }

  ///
  ///
  /// when [isIncrease] == true, [compareLastElement] == false,
  ///   list..sortAccordingly(); // [
  ///   //  [2, 5, 1],
  ///   //  [2, 5, 6, 1],
  ///   //  [2, 5, 6, 9],
  ///   //  [2, 5, 6, 1, 90],
  ///   // ]
  ///
  /// when [isIncrease] == true, [compareLastElement] == true,
  ///   list..sortAccordingly(); // [
  ///   //  [2, 5, 10],
  ///   //  [2, 5, 6, 10],
  ///   //  [2, 5, 6, 10, 90],
  ///   //  [2, 5, 6, 9],
  ///   // ]
  ///
  /// when [isIncrease] == true, [compareLastElement] == false,
  ///   list..sortAccordingly(); // [
  ///   //  [2, 5, 10],
  ///   //  [2, 5, 6, 9],
  ///   //  [2, 5, 6, 10],
  ///   //  [2, 5, 6, 9, 90],
  ///   // ]
  ///

  void sortDirty([
    bool increase = true,
    bool compareLastElement = false,
  ]) {
    assert(everyElementSorted(increase));
    assert(!compareLastElement);
    final groups = iterator.groupBy((value) => value.length);
    // final result = <List<C>>[];
    groups.forEach((length, value) {
      // queue ??
      // result.insertAll(value..sortAccordingly(increase));
    });
  }
}



///
///
/// Strassen’s Matrix Multiplication
/// Chained Matrix Multiplication, Deepmind Matrix Multiplication
/// Optimal Binary Search Tree
/// Deepmind sorting https://www.nature.com/articles/s41586-023-06004-9
///
/// meta algorithm: https://www.blocktempo.com/interpretation-of-meta-algorithm/
///
///
